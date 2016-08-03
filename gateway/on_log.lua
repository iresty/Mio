local summary = require "gateway.module.summary"
local status  = require "gateway.module.status"
local common  = require "gateway.module.common"


local function start()
  summary.log()
  status.log()
end

xpcall(start, common.err_handle)
