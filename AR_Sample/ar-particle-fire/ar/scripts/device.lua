function GET_DEVICE()
	local Device = {}
	Device.application = 0
	Device.on_device_rotate = 0
	Device.on_device_shake = 0
	Device.open_imu = 0
	Device.close_imu = 0
	Device.shake_enable = false
	Device.on_camera_change = 0

	Device.open_shake_listener = 0
	Device.stop_shake_listner = 0
	Device.set_shake_threshold = 0

	function Device.open_shake_listener(self)
		ARLOG('open shake listener')
		local mapData = ae.MapData:new() 
   	 	mapData:put_int("id",MSG_TYPE_OPEN_SHAKE ) 
    	self.application.lua_handler:send_message_tosdk(mapData)
    	self.shake_enable = true
	end

	function Device.stop_shake_listener(self)
		local mapData = ae.MapData:new() 
   	 	mapData:put_int("id", MSG_TYPE_STOP_SHAKE) 
    	self.application.lua_handler:send_message_tosdk(mapData)
    	self.shake_enable = false
	end

	function Device.open_track_service(self)
		local mapData = ae.MapData:new() 
   	 	mapData:put_int("id", MSG_TYPE_OPEN_TRACK) 
    	self.application.lua_handler:send_message_tosdk(mapData)
	end

	function Device.stop_track_service(self)
		local mapData = ae.MapData:new() 
   	 	mapData:put_int("id", MSG_TYPE_STOP_TRACK) 
    	self.application.lua_handler:send_message_tosdk(mapData)
	end
	
	function Device.set_shake_threshold(self, threshold)
		if (type(threshold) == "number") then
	 		if (threshold > 5) then
				MAX_SHAKE_THRESHOLD = threshold
			else 
				ARLOG("gravity threshold is too small")
			end
		else 
			ARLOG("invalid number")
		end 
	end

	function Device.get_shake_threshold(self)
		return MAX_SHAKE_THRESHOLD
	end

	function Device.open_imu(self, type)
		self.application:open_imu_service(type)
	end

	function Device.close_imu(self)
		self.application:close_imu_service()
	end

	return Device
end