-- application.lua --

function LOAD_APPLICATION()
	local application = {}
	application.entity = nil

	application.on_loading_finish = 0
--	application.on_target_lost = 0
	application.on_target_found = 0
	application._offscreen_button_show = 0
    application._offscreen_button_hide = 0

	application.device = GET_DEVICE()
	application.device.application = application
	application.current_scene = 0

	application.slam = SLAM()
	application.slam.application = application;

	application.webContent = WebContent()

	setmetatable(application, application)

	application.__index = function(self, key)
		if(key == 'lua_handler') then
			return self.entity:get_lua_handler()
		end
		if(self.entity[key] == nil) then
			ARLOG('尝试调用application的'..key..' 方法/属性, 该方法/属性不存在')
			return NOP_FUNC
		else
			__F_FUNC = function(self, ...)
					__BACK_FUNC = self.entity[key]
					return __BACK_FUNC(self.entity, ...)
				end
			return __F_FUNC
		end
	end

	application.__newindex = function(self, key, value) 
		if(key == 'offscreen_button_show') then
			local anony_func = function()
				if(self._offscreen_button_show ~= 0) then
					self._offscreen_button_show()
				end
			end

			self._offscreen_button_show = value
			local RANDOM_NAME = RES_CLOSURE(anony_func)	
			local lua_handler = self.lua_handler
			local handler_id = lua_handler:register_handle(RANDOM_NAME)
			self:set_show_offscreen_button_handler(handler_id)

		elseif(key == 'offscreen_button_hide') then
			local anony_func = function()
				if(self._offscreen_button_hide ~= 0) then
					self._offscreen_button_hide()
				end
			end
			self._offscreen_button_hide = value
			local RANDOM_NAME = RES_CLOSURE(anony_func)	
			local lua_handler = self.lua_handler
			local handler_id = lua_handler:register_handle(RANDOM_NAME)
			self:set_hide_offscreen_button_handler(handler_id)
        elseif(key == 'on_target_lost') then
            function ON_TARGET_LOST()
                self.on_target_lost()
            end
            local lua_handler = self.entity:get_lua_handler()
            local handler_id =  lua_handler:register_handle("ON_TARGET_LOST")
            self:set_on_tracking_lost_handler(handler_id)
            rawset(self, key, value)
		else
			rawset(self, key, value)
		end
	end


	application.setup_handlers = function(self)
		local lua_handler = self.entity:get_lua_handler()
		local handler_id = 0

		function DEVICE_TO_LANDSCAPE_LEFT()
			if(self.device.on_device_rotate ~= 0) then
				self.device.on_device_rotate(DeviceOrientation.Left)
			end
		end

		function DEVICE_TO_LANDSCAPE_RIGHT()
			if(self.device.on_device_rotate ~= 0) then
				self.device.on_device_rotate(DeviceOrientation.Right)
			end
		end

		function DEVICE_TO_PORTRAIT()
			if(self.device.on_device_rotate ~= 0) then
				self.device.on_device_rotate(DeviceOrientation.Portrait)
			end
		end

		handler_id = lua_handler:register_handle("DEVICE_TO_LANDSCAPE_LEFT")
		self:set_on_landscape_left_handler(handler_id)
		
		handler_id = lua_handler:register_handle("DEVICE_TO_LANDSCAPE_RIGHT")
		self:set_on_landscape_right_handler(handler_id)
		
		handler_id = lua_handler:register_handle("DEVICE_TO_PORTRAIT")
		self:set_on_portrait_handler(handler_id)

		function APPLICATION_DID_LOAD()
			if(self.on_loading_finish ~= 0) then
				self.on_loading_finish()
			end
		end

		-- function ON_TARGET_LOST()
		-- 	if(self.on_target_lost ~= 0) then
		-- 		self.on_target_lost()
		-- 	else
		-- 		local scene = self:get_current_scene()
		-- 		scene:set_visible(false)
		-- 	end
		-- end

		function ON_TARGET_FOUND()
			if(self.on_target_found ~= 0) then
				self.on_target_found()
			end
		end

		handler_id =  lua_handler:register_handle("APPLICATION_DID_LOAD")
		self:set_on_loading_finish_handler(handler_id)

--		handler_id =  lua_handler:register_handle("ON_TARGET_LOST")
--		self:set_on_tracking_lost_handler(handler_id)

		handler_id =  lua_handler:register_handle("ON_TARGET_FOUND")
		self:set_on_tracking_found_handler(handler_id)
	end

	application.load_scene_from_json = function(self, file_path, name)
		self:add_scene_from_json(file_path, name)
		self:active_scene_by_name(name)
		self.current_scene = self:get_current_scene()
	end

	application.add_scene_from_json = function(self, file_path, name)
		self.entity:add_scene_from_json(file_path, name)
	end

	application.active_scene_by_name = function(self, name)
		self.entity:active_scene_by_name(name)
		self.current_scene = self:get_current_scene()
	end

	application.get_current_scene = function(self)
		new_scene = CREATE_SCENE()
		new_scene.entity = self.entity:get_current_scene()
		self.current_scene = new_scene
		self.current_scene.application = self
		return new_scene
	end

	application.get_scene_by_name = function(self, name)
		new_scene = CREATE_SCENE()
		new_scene.entity = self.entity:get_scene_by_name(name)
	end

	application.get_version = function(self)
		local version = self.entity:get_engine_version()
		local engine_version = REOMVE_SPECIAL_SYMBOL(version,"%.")
		local version = tonumber(engine_version)
		local eng_version_table = {[100] = 11, [110] = 12, [120] = 14, [121] = 16, [122] = 18, 
								   [123] = 19, [124] = 20, [125] = 23, [126] = 100, [130] = 110, 
								   [131] = 120, [132] = 130, [133] = 135, [140] = 145, [141] = 150, [142] = 155}
		local v = eng_version_table[version]
		if(v == nil) then
			v = 99999
		end
		return v
	end

	application.stop_bg_music = function(self, name)
		self.entity:pause_bg_music()
	end

	application.open_url = function(self,url)
		local engine_version = self:get_version()
		if engine_version >= 12 then
			self.entity:open_url(url,1)
		else
			self.entity:open_url(url,0)
		end
	end

	application.visible_type = function(self,type)
        local mapData = ae.MapData:new()
        mapData:put_int("id", MSG_TYPE_VIEW_VISIBLE_TYPE)
        mapData:put_int("visibleType",type)
        self.lua_handler:send_message_tosdk(mapData)
        mapData:delete()
    end

	application.switch_case = function(self,arkey,artype)
        local mapData = ae.MapData:new()
        mapData:put_int("id", MSG_TYPE_SWITCH_CASE)
        mapData:put_int("arkey",arkey)
        mapData:put_int("artype",artype)
        self.lua_handler:send_message_tosdk(mapData)
    end

	return application
end

-- function LOAD_LUA_HANDLER()
-- 	local lua_handler = {}
-- 	lua_handler.entity = nil
-- 	setmetatable(lua_handler, lua_handler)
-- 	lua_handler.__index = function(self, key)
-- 		if(self.entity[key] == nil) then
-- 			ARLOG('尝试调用lua_handler的'..key..' 方法/属性, 该方法/属性不存在')
-- 			return NOP_FUNC
-- 		else
-- 			__F_FUNC = function(self, ...)
-- 					__BACK_FUNC = self.entity[key]
-- 					return __BACK_FUNC(self.entity, ...)
-- 				end
-- 			return __F_FUNC
-- 		end
-- 	end
-- 	return lua_handler
-- end

ARLOG('load application/lua_handler')
-- application.lua end
