-- single_ability.lua --
function LOAD_SINGLE_ABILITY()

	SingleAbility = {}
	SingleAbility.callBack = nil

	-- 官方关闭AR的按钮回调
	SingleAbility.close_ar = function(self)
		local mapData = ae.MapData:new() 
			mapData:put_int("id", MSG_TYPE_CLOSE_AR) 
			lua_handler:send_message_tosdk(mapData)
			mapData:delete()
	end

end

LOAD_SINGLE_ABILITY()

-- single_ability.lua end --
