local type = type
local pairs = pairs
local common = require "gateway.module.common"
local uri_lrucache = require "gateway.module.summary_lru" -- 用作持久的统计使用

local function table_is_array(t)
    if type(t) ~= "table" then return false end
    local i = 0
    for _ in pairs(t) do
        i = i + 1
        if t[i] == nil then return false end
    end
    return true
end

local _M = {}

-- 启动以来的统计数据
local shared_summary = ngx.shared.summary
--保留最近1分钟的 summary 统计，key 是秒数，1分钟过期,一共有60个 key
local shared_recording_summary = ngx.shared.recording_summary

local lrucache = require "resty.lrucache"
local history_summary = lrucache.new(1)  -- 存放历史 summary，json 格式的 string


-- lru 里面的数据结构是:{uri1:{"total":12,"sent":123123,"3xx":444,"2xx":5555}}
-- shared dict 里面的数据结构是:
--{
--  "days这个是天数":
--          {uri1:
--                {"total":232342342,"qps":112,"sent":123123,"3xx":444,"2xx":5555}
--          }
--}


function _M.sync_data_to_shared_dict()
    local function _sync_data()
        local seconds = ngx.time()
        local today = math.floor(seconds / 86400) -- 3600 * 24 = 86400
        local report = common.json_decode(shared_summary:get(today)) or {}
        local report_per_second = common.json_decode(shared_recording_summary:get(seconds)) or {}

        local keys = uri_lrucache.keys()
        for _, key in ipairs(keys) do
            local single_worker_value = uri_lrucache.get(key)

            -- 先合并到今天的整体统计中
            local all_workers_value = report[key]
            report[key] = common.merge_table(all_workers_value, single_worker_value)

            -- 再合并到当前描述的统计中
            all_workers_value = report_per_second[key]
            report_per_second[key] = common.merge_table(all_workers_value, single_worker_value)

            uri_lrucache.delete(key)
        end

        shared_summary:set(today, common.json_encode(report))
        shared_recording_summary:set(seconds, common.json_encode(report_per_second), 60)
    end

    xpcall(_sync_data, common.err_handle)

    ngx.timer.at(0.5, _M.sync_data_to_shared_dict)
end

function _M.log()
    local uri = ngx.var.uri
    local status = math.floor(tonumber(ngx.var.status) / 100) .. 'xx'
    local sent_length = tonumber(ngx.var.bytes_sent)
    local request_time = tonumber(ngx.var.request_time)
    uri_lrucache.hmincr(uri, "total", 1, status, 1, "sent", sent_length, "request_time", request_time)
end

function _M.last_one_minute_report()
    local seconds = ngx.time()
    local report = {}
    for i = 1, 60 do
        report = common.merge_table(report,
                        common.json_decode(shared_recording_summary:get(seconds - i)) or {})
    end

    if not report or table_is_array(report) then
        return {}
    else
        return report
    end
end

function _M.history_report()
    local days = 2 -- 默认返回前两天的历史数据
    local today = math.floor(ngx.time() / 86400) -- 3600 * 24 = 86400

    local report = history_summary:get('history')
    if nil == report then
        report = {}
        for i = 1, days do
            report = common.merge_table(report,
                            common.json_decode(shared_summary:get(today - i)) or {})
        end
        history_summary:set('history', common.json_encode(report), 3600)
    end

    -- 无数据时可能会等于[]
    if not report or table_is_array(report) then
        return {}
    else
        return report
    end
end

-- 只返回当天的 summary
function _M.report()
    -- today 的含义是第几天
    local today = math.floor(ngx.time() / 86400) -- 3600 * 24 = 86400
    local report = shared_summary:get(today)

    return common.json_decode(report)
end


return _M
