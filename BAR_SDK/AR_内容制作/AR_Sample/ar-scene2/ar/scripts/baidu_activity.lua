-- baidu_activity.lua --
function LOAD_BAIDU_ACTIVITY()

	BaiduActivity = {}
	BaiduActivity.callBack = nil
	-- 从lua层传到SDK层的值:手百定制
	BaiduActivity.send_value = function(extra_data,url,action_id)
		local mapData = ae.MapData:new()
		mapData:put_int("id", MSG_TYPE_SEND_VALUE)

		if value == nil then
			value = 0
		end
		
--[["extra_data": {
			"score": 100,
			"detail": {
				"bronze": 1,
				"silver": 3,
				"gold": 10
			}
		},
--]]
		mapData:put_map_data("extra_data", action_id)
		mapData:put_string("url", url)
		mapData:put_string("action_id", action_id)

		lua_handler:send_message_tosdk(mapData)
	end

end

LOAD_SINGLE_ACTIVITY()

-- baidu_activity.lua end --
