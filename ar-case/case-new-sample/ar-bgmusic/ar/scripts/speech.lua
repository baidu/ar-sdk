-- speech.lua -- 
function LOAD_SPEECH()
	Speech = {}
	Speech.callBack = nil

	Speech.start_listen = function(self)
		local mapData = ae.MapData:new() 
		mapData:put_int("id", MSG_TYPE_VOICE_START) 
		lua_handler:send_message_tosdk(mapData)
		mapData:delete()
	end

	Speech.stop_listen = function(self)
		local mapData = ae.MapData:new() 
		mapData:put_int("id", MSG_TYPE_VOICE_STOP) 
		lua_handler:send_message_tosdk(mapData)
		mapData:delete()
	end
 
    Speech.show_mic_icon = function(self)
		local mapData = ae.MapData:new() 
		mapData:put_int("id", MSG_TYPE_VOICE_SHOW_MIC_ICON) 
		lua_handler:send_message_tosdk(mapData)
		mapData:delete()
	end

 	Speech.hide_mic_icon = function(self)
		local mapData = ae.MapData:new() 
		mapData:put_int("id", MSG_TYPE_VOICE_HIDE_MIC_ICON) 
		lua_handler:send_message_tosdk(mapData)
		mapData:delete()
	end
end

LOAD_SPEECH()

-- speech.lua end --