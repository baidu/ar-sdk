function GET_DEVICE()
	local Device = {}
	Device.application = 0
	Device.on_device_rotate = 0
	Device.on_device_shake = 0
	Device.open_imu = 0
	Device.close_imu = 0
	Device.shake_enable = false
	Device.on_camera_change = 0
	Device.on_record_state_change = 0
	Device.open_shake_listener = 0
	Device.stop_shake_listner = 0
	Device.set_shake_threshold = 0

	Device.get_camera_pitch_angle = 0

	Device.get_render_size_callback = nil

	-- arkit
    Device.plane_detected = 0
    Device.get_plane_position = 0
    Device.plane_clear = 0

	Device.show_lay_status = 0
    Device.open_place_status = 0
    Device.close_place_status = 0
    Device.restart_status = 0

	function Device.open_shake_listener(self)
		ARLOG('open shake listener')
		local mapData = ae.MapData:new() 
   	 	mapData:put_int("id",MSG_TYPE_OPEN_SHAKE ) 
    	self.application.lua_handler:send_message_tosdk(mapData)
    	self.shake_enable = true
    	mapData:delete()
	end

	function Device.stop_shake_listener(self)
		local mapData = ae.MapData:new() 
   	 	mapData:put_int("id", MSG_TYPE_STOP_SHAKE) 
    	self.application.lua_handler:send_message_tosdk(mapData)
    	self.shake_enable = false
    	mapData:delete()
	end

		-- get_render_size--
    function Device.get_render_size(self,callback) 
    	Device.get_render_size_callback = callback
        local mapData = ae.MapData:new()
        mapData:put_int("id", MSG_TYPE_RENDER_SIZE)
        self.application.lua_handler:send_message_tosdk(mapData)
    end

	function Device.open_track_service(self)
		local mapData = ae.MapData:new() 
   	 	mapData:put_int("id", MSG_TYPE_OPEN_TRACK) 
    	self.application.lua_handler:send_message_tosdk(mapData)
    	mapData:delete()
	end

	function Device.stop_track_service(self)
		local mapData = ae.MapData:new() 
   	 	mapData:put_int("id", MSG_TYPE_STOP_TRACK) 
    	self.application.lua_handler:send_message_tosdk(mapData)
    	mapData:delete()
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
	    mapData:delete()
	end

	function Device.open_imu(self, imu_type, init_position)
		imu_type = imu_type or 0
		init_position = init_position or 0
		local version = self.application:get_version()
        ARLOG('version : '..version)
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
		mapData:delete()
	end

	function Device.change_frontback_camera(self)
		local mapData = ae.MapData:new()
		mapData:put_int("id", MSG_TYPE_CHANGE_FRONTBACK_CAMERA)
		self.application.lua_handler:send_message_tosdk(mapData)
	end
    
    function Device.get_camera_pitch_angle(self)
    	local scene = application.get_current_scene()
    	if (scene ~= nil) then
    		return scene:get_camera_pitch_angle()
    	end
    end

    function Device.open_place_status(self)
    	local mapData = ae.MapData:new()
		mapData:put_int("id", MSG_TYPE_OPEN_PLACE_STATUE)
		self.application.lua_handler:send_message_tosdk(mapData)
		mapData:delete()
    end

    function Device.close_place_status(self)
    	local mapData = ae.MapData:new()
    	mapData:put_int("id", MSG_TYPE_CLOSE_PLACE_STATUE) 
    	self.application.lua_handler:send_message_tosdk(mapData)
    	mapData:delete()
    end

    function Device.restart_status(self)
    	local mapData = ae.MapData:new()
		mapData:put_int("id", MSG_TYPE_RESET_STATUE)
		self.application.lua_handler:send_message_tosdk(mapData)
		mapData:delete()
    end

	return Device
end


