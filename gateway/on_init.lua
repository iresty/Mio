require "resty.core"

local status = require "gateway.module.status"
local common = require "gateway.module.common"

xpcall(status.init, common.err_handle)
