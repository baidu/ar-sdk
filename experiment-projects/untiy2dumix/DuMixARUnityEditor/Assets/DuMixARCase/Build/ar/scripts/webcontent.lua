function WebContent()
	local wc = {}
	wc.close = function(self)
		local mapData = ae.MapData:new() 
		mapData:put_int("id", MSG_TYPE_WEB_OPERATION) 
		mapData:put_string("cmd", "close")
		AR.current_application.lua_handler:send_message_tosdk(mapData)
		mapData:delete()
	end
	wc.load = function(self, url)
		local mapData = ae.MapData:new() 
		mapData:put_int("id", MSG_TYPE_WEB_OPERATION) 
		mapData:put_string("cmd", "load")
		mapData:put_string("url", url)
		AR.current_application.lua_handler:send_message_tosdk(mapData)
		mapData:delete()
	end	

	wc.load_local = function(self, url)
		local mapData = ae.MapData:new() 
		mapData:put_int("id", MSG_TYPE_WEB_OPERATION) 
		mapData:put_string("cmd", "load_local")
		mapData:put_string("url", url)
		AR.current_application.lua_handler:send_message_tosdk(mapData)
		mapData:delete()
	end

	wc.show = function(self)
		local mapData = ae.MapData:new() 
		mapData:put_int("id", MSG_TYPE_WEB_OPERATION) 
		mapData:put_string("cmd", "show")
		AR.current_application.lua_handler:send_message_tosdk(mapData)
		mapData:delete()
	end
	return wc
end

