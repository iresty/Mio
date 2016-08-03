local summary = require "gateway.module.summary"
local common   = require "gateway.module.common"

xpcall(summary.sync_data_to_shared_dict, common.err_handle)
