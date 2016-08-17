local pairs = pairs
local require = require
local pcall = pcall
local type = type
local string_lower = string.lower
local lor = require("lor.index")
local dashboard_router = lor:Router()


dashboard_router:get("/", function(req, res, next)
    res:render("index")
end)

--- 加载gateway暴露出来的API
local default_api_path = "gateway.api"
local ok, api = pcall(require, default_api_path)

if not ok or not api or type(api) ~= "table" then
    ngx.log(ngx.ERR, "[API exposed error], api_path:", default_api_path)
    return dashboard_router
end

for uri, api_methods in pairs(api) do
    ngx.log(ngx.INFO, "load route, uri:", uri)
    if type(api_methods) == "table" then
        for method, func in pairs(api_methods) do
            local m = string_lower(method)
            if m == "get" or m == "post" or m == "put" or m == "delete" then
                dashboard_router[m](dashboard_router, uri, func())
            end
        end
    end
end


return dashboard_router


