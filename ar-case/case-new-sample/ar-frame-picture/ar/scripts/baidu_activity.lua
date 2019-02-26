-- baidu_activity.lua --
function LOAD_BAIDU_ACTIVITY()

	BaiduActivity = {}
	BaiduActivity.callBack = nil
	-- 从lua层传到SDK层【手百定制】，携带参数调起H5（最低版本手百10.3）
	BaiduActivity.send_value = function(extra_data,url,action_id)
		local mapData = ae.MapData:new()
		mapData:put_int("id", MSG_TYPE_SEND_VALUE)

		if value == nil then
			value = 0
		end

		mapData:put_map_data("extra_data", extra_data)
		mapData:put_string("url", url)
		mapData:put_string("action_id", action_id)

		lua_handler:send_message_tosdk(mapData)
		mapData:delete()
	end

end

LOAD_SINGLE_ACTIVITY()

-- baidu_activity.lua end --
