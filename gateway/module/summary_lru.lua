local lru = require "resty.lrucache"
local lru_s = lru.new(1024)

local _M = { _VERSION = '0.01', lru = lru_s}

local mt = { __index = _M }
local default_ttl = 1
local ngx_now = ngx.now


function _M.hmincr(key, ...)
    local value = lru_s:get(key) or {}
    for i=1, select('#', ...), 2 do
        local field = select(i, ...)
        local increment = select(i+1, ...)
        value[field] = (value[field] or 0) + increment
    end
    lru_s:set(key, value, default_ttl)
end

function _M.hset( key, field, value )
    local cur_value = lru_s:get(key) or {}
    cur_value[field] = value

    lru_s:set(key, cur_value, default_ttl)
end


function _M.hget( key, field )
    local cur_value = lru_s:get(key) or {}

    return cur_value[field]
end

function _M.get( key )
    return lru_s:get(key)
end

function _M.delete( key )
    return lru_s:delete(key)
end

function _M.keys()
    local keys = {}
    local hash = lru_s.hasht
    for key, _ in pairs(hash) do
        local node = lru_s.key2node[key]
        if node.expire < 0 or node.expire >= ngx_now() then
            table.insert(keys, key)
        end
    end

    return keys
end

return _M
