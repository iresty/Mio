local cjson  = require "cjson"

local _M = {}

function _M.merge_table(base_table, up_table)
    if "table" ~= type(base_table) then
        return up_table
    end

    if "table" ~= type(up_table) then
        return base_table
    end

    local new_table = {}
    for k, v in pairs(base_table) do
        if "table" == type(v) then
            new_table[k] = _M.merge_table(v, up_table[k])
        elseif "number" == type(v) then
            new_table[k] = v + (up_table[k] or 0)
        else
            new_table[k] = up_table[k] or v
        end
    end

    for k, v in pairs(up_table) do
        if new_table[k] == nil then
            new_table[k] = v
        end
    end

    return new_table
end

function _M.json_decode(str)
    local json_value = nil
    pcall(function (str) json_value = cjson.decode(str) end, str)
    return json_value
end

function _M.json_encode(data, empty_table_as_object)
  --lua的数据类型里面，array和dict是同一个东西。对应到json encode的时候，就会有不同的判断
  --对于linux，我们用的是cjson库：A Lua table with only positive integer keys of type number will be encoded as a JSON array. All other tables will be encoded as a JSON object.
  --cjson对于空的table，就会被处理为object，也就是{}
  --dkjson默认对空table会处理为array，也就是[]
  --处理方法：对于cjson，使用encode_empty_table_as_object这个方法。文档里面没有，看源码
  --对于dkjson，需要设置meta信息。local a= {}；a.s = {};a.b='中文';setmetatable(a.s,  { __jsontype = 'object' });ngx.say(comm.json_encode(a))
    local json_value = nil
    if cjson.encode_empty_table_as_object then
        cjson.encode_empty_table_as_object(empty_table_as_object or false) -- 空的table默认为array
    end

    if require("ffi").os ~= "Windows" then
        cjson.encode_sparse_array(true)
    end
    --json_value = json.encode(data)
    pcall(function (data) json_value = cjson.encode(data) end, data)
    return json_value
end


function _M.err_handle()
    ngx.log(ngx.ERR, debug.traceback())
end

return _M
