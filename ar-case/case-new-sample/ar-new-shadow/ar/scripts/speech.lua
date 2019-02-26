-- speech.lua -- 
function LOAD_VOICE()
	Speech = {}
	Speech.callBack = nil

	Speech.start_listen = function(self)
		local mapData = ae.MapData:new() 
		mapData:put_int("id", MSG_TYPE_VOICE_START) 
		lua_handler:send_message_tosdk(mapData)
	end

	Speech.stop_listen = function(self)
		local mapData = ae.MapData:new() 
		mapData:put_int("id", MSG_TYPE_VOICE_STOP) 
		lua_handler:send_message_tosdk(mapData)
	end
end

LOAD_VOICE()

-- speech.lua end --