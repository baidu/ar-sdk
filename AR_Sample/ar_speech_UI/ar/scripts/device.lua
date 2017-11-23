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

	-- 开启绝对模式下imu，此种方式打开的imu会保留初始位置的，以后从别的模式恢复到此种imu的模式下，不会重新初始化位置
	function Device.open_imu_with_init_position(self)
		local mapData = ae.MapData:new() 
	    mapData:put_int("id", MSG_TYPE_OPEN_IMU_WHIT_INIT_POSITION) 
	    mapData:put_int("type", 1) 
	    mapData:put_int("resume_original_position", 1)
	    self.application.lua_handler:send_message_tosdk(mapData)
	end

	function Device.open_imu(self, imu_type, init_position)
		imu_type = imu_type or 0
		init_position = init_position or 0
		local version = self.application:get_version()
        ARLOG('version : ',version)
		--判断引擎版本：如果大于等于20, 调用新接口
		if version >= 20 and version < 10000 then
			self.application:open_imu_service(imu_type, init_position)
		else 
			self.application:open_imu_service(imu_type)
		end
	end

	function Device.close_imu(self)
		self.application:close_imu_service()
	end
	
	function Device.enable_front_camera(self)
		local mapData = ae.MapData:new()
		mapData:put_int("id", MSG_TYPE_ENABLE_FRONT_CAMERA)
		self.application.lua_handler:send_message_tosdk(mapData)
	end
    
	return Device
end


