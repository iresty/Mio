local lor = require("lor.index")
local app = lor()
local router = require("api.router")

-- routes
app:use(router())

-- 404 error
app:use(function(req, res, next)
    if req:is_found() ~= true then
        res:status(404):json({
            success = false,
            msg = "404! sorry, not found."
        })
    end
end)

-- error handle middleware
app:erroruse(function(err, req, res, next)
    ngx.log(ngx.ERR, err)
    res:status(500):json({
        success = false,
        msg = "500! unknown error."
    })
end)

app:run()
