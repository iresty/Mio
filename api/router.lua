local ipairs = ipairs
local pairs = pairs
local require = require
local table_insert = table.insert
local string_lower = string.lower
local lor = require("lor.index")
local api_router = lor:Router()

--- 加载gateway暴露出来的API
local default_api_path = "gateway.api"
local ok, api = pcall(require, default_api_path)

if not ok then
    ngx.log(ngx.ERR, "[api load error], api_path:", default_api_path, ok)
else
    if api and type(api) == "table" then
        for uri, api_methods in pairs(api) do
            ngx.log(ngx.INFO, "load route, uri:", uri)
            if type(api_methods) == "table" then
                for method, func in pairs(api_methods) do
                    local m = string_lower(method)

                    if m == "get" then
                         api_router:get(uri, func(store))
                    elseif m == "post" then
                        api_router:post(uri, func(store))
                    elseif m == "put" then
                        api_router:put(uri, func(store))
                    elseif m == "delete" then
                        api_router:delete(uri, func(store))
                    end
                end
            end
        end
    end
end

return api_router

