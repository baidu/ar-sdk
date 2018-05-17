-- tts.lua --
function LOAD_TTS()
	Tts = {}
	Tts.callBack = nil

	Tts.speak = function(self,tts,speaker,speed,volume)
		local mapData = ae.MapData:new()
		mapData:put_int("id", MSG_TYPE_TTS_SPEAK)
		mapData:put_string("tts", tts)

		if speaker == nil then
			speaker = 0
		end

		if speed == nil then
			speed = 5
		end

		if volume == nil then
			volume = 0.5
		end

		mapData:put_int("speaker", speaker)
		mapData:put_int("speed", speed)
		mapData:put_float("volume", volume)
		ARLOG(' lua speak function')
		AR.current_application.lua_handler:send_message_tosdk(mapData)
		mapData:delete()

	end

	Tts.pause = function(self)
		local mapData = ae.MapData:new()
		mapData:put_int("id", MSG_TYPE_TTS_PAUSE)
		AR.current_application.lua_handler:send_message_tosdk(mapData)
		mapData:delete()
	end

	Tts.resume = function(self)
		local mapData = ae.MapData:new()
		mapData:put_int("id", MSG_TYPE_TTS_RESUME)
		AR.current_application.lua_handler:send_message_tosdk(mapData)
		mapData:delete()
	end

	Tts.stop = function(self)
		local mapData = ae.MapData:new()
		mapData:put_int("id", MSG_TYPE_TTS_STOP)
		AR.current_application.lua_handler:send_message_tosdk(mapData)
		mapData:delete()
	end

end
LOAD_TTS()

-- tts.lua end --

