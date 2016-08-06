local string_lower = string.lower
local ipairs = ipairs
local pairs = pairs
local table_insert = table.insert
local lor = require("lor.index")
local dashboard_router = lor:Router()


dashboard_router:get("/", function(req, res, next)
    res:render("index")
end)


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
                        dashboard_router:get(uri, func(store))
                    elseif m == "post" then
                        dashboard_router:post(uri, func(store))
                    elseif m == "put" then
                        dashboard_router:put(uri, func(store))
                    elseif m == "delete" then
                        dashboard_router:delete(uri, func(store))
                    end
                end
            end
        end
    end
end


return dashboard_router


