app_controller = ae.ARApplicationController:shared_instance()
-- 不要修改模块的引入顺序 --
-- 模块引入的路径以default.lua 所在路径为根目录 --
-- utils.lua --
function LOAD_UTILS()
	function ARLOG(line)
		io.write('[LUA-LOG] '..line)
	end

	function NOP_FUNC(...)
		ARLOG('nop_func called')
	end

	function F_GENERATOR()
		FUNC_NAME_INDEX = 0
		return function()
			FUNC_NAME_INDEX = FUNC_NAME_INDEX+1
			return "BAR_ANONYMOUS_FUNC_"..FUNC_NAME_INDEX
		end
	end
	FNAME = F_GENERATOR()

	function RES_CLOSURE(func)
		RANDOM_NAME = FNAME()
		GLOBALFUNC = func
		loadstring(RANDOM_NAME.."=GLOBALFUNC")()
		return RANDOM_NAME
	end

	function VERSION_LOWER_8_5()
		if(ae.ARApplicationController ~= nil) then
			return false
		else
			return true
		end
	end


	function REOMVE_SPECIAL_SYMBOL(str,remove)  
	    local lcSubStrTab = {}  
	    while true do  
	        local lcPos = string.find(str,remove)  
	        if not lcPos then  
	            lcSubStrTab[#lcSubStrTab+1] =  str      
	            break  
	        end  
	        local lcSubStr  = string.sub(str,1,lcPos-1)  
	        lcSubStrTab[#lcSubStrTab+1] = lcSubStr  
	        str = string.sub(str,lcPos+1,#str)  
	    end  
	    local lcMergeStr =""  
	    local lci = 1  
	    while true do  
	        if lcSubStrTab[lci] then  
	            lcMergeStr = lcMergeStr .. lcSubStrTab[lci]   
	            lci = lci + 1  
	        else   
	            break  
	        end  
	    end  
	    return lcMergeStr  
	end 

	function string:split(sep)
	   local sep, fields = sep or ":", {}
	   local pattern = string.format("([^%s]+)", sep)
	   self:gsub(pattern, function(c) fields[#fields+1] = c end)
	   return fields
	end

	function IN_ARRAY(key, arr)
		if not arr then
			return false
		end
		for k, v in pairs(arr) do
			if(v == key) then
				return true
			end
		end
		return false
	end

	ARLOG('load util')
end

LOAD_UTILS()
--  utils.lua end -- 
-- utils.lua --
function LOAD_CONST()
	AppType = {}
	-- AppType.None = 0
	-- AppType.ImageTrack = 1
	AppType.Imu = 2
	AppType.ImageTrack = 3
	AppType.Slam = 4

	-- Device Orientation -- 
	DeviceOrientation = {}
	DeviceOrientation.Portrait = 0
	DeviceOrientation.Left = 1
	DeviceOrientation.Right = 2

	-- SDK LUA MSG TYPE --
	-- shake --
	MSG_TYPE_SHAKE = 10000
	MSG_TYPE_OPEN_SHAKE = 10001
	MSG_TYPE_STOP_SHAKE = 10002
	MAX_SHAKE_THRESHOLD = 9.8

	-- track -- 
	MSG_TYPE_OPEN_TRACK = 10101
	MSG_TYPE_STOP_TRACK = 10102

	-- camera --
	MSG_TYPE_CAMERA_CHANGE = 10200

	
	-- voice api --
	MSG_TYPE_VOICE_START = 2001
	MSG_TYPE_VOICE_STOP = 2002
	
	--voice status --
	VOICE_STATUS_READYFORSPEECH = 0
	VOICE_STATUS_BEGINNINGOFSPEECH = 1
	VOICE_STATUS_ENDOFSPEECH = 2
	VOICE_STATUS_ERROR = 3
	VOICE_STATUS_RESULT = 4
	VOICE_STATUS_RESULT_NO_MATCH = 5
	VOICE_STATUS_PARTIALRESULT = 6
	VOICE_STATUS_CANCLE = 7
	
	--voice error status --
	VOICE_ERROR_STATUS_NULL = 0
	VOICE_ERROR_STATUS_SPEECH_TIMEOUT = 1
	VOICE_ERROR_STATUS_NETWORK = 2
	VOICE_ERROR_STATUS_INSUFFICIENT_PERMISSIONS = 3
	-- voice api end --
	
	ARLOG('load const')
end

LOAD_CONST()
--  utils.lua end -- 
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
endfunction HANDLE_SDK_MSG(mapData)
	msg_id = mapData['id']
	if (msg_id == MSG_TYPE_SHAKE) then
        max_acc = mapData['max_acc']
        ARLOG('got max acc '..max_acc)
        if(max_acc < MAX_SHAKE_THRESHOLD) then
            return
        end
        if(AR.current_application.device.shake_enable == false) then
        	ARLOG('fuck')
        	return
        end

		if(AR.current_application.device.on_device_shake ~= 0) then
			AR.current_application.device.on_device_shake()
		else
			ARLOG("收到Shake消息，但onDeviceShake方法未定义")
		end
	elseif(msg_id == MSG_TYPE_VOICE_START) then
		if(Speech.callBack ~= nil) then
			Speech.callBack(mapData)
		end
	elseif(msg_id == MSG_TYPE_CAMERA_CHANGE) then
		if(AR.current_application.device.on_camera_change ~= 0) then
			local is_front_camera = mapData['front_camera']
			AR.current_application.device.on_camera_change(is_front_camera)
		end
	else
		ARLOG("收到未知消息类型: "..msg_id)
	end
end-- frame.lua --
function LOAD_AR()	
	AR = {}
	AR.current_application = 0
	function AR.create_application(self, app_type, name)
		local app_entity = 0
		if(ae.ARApplicationController) ~= nil then
			app_entity = ae.ARApplicationController:shared_instance():add_application_with_type(app_type, name)
		else
			app_entity = ae.ARApplication:shared_application()
		end

		local app = LOAD_APPLICATION()
		app.entity = app_entity
		app:setup_handlers()

		local lua_handler = app:get_lua_handler()
		lua_handler:register_lua_sdk_bridge("HANDLE_SDK_MSG")
		self.current_application = app
		return app
	end

	-- Loop --
	BAR_ON_LOOP = true
	LOOP_INTERVAL = 30
	LOOP_FUNC = nil

	AR.fire_loop = function(self, loop_func, interval)
		if(type(loop_func) ~= 'function') then
			ARLOG("param error, param of function type needed");
			return
		end
		LOOP_FUNC = loop_func
		if(interval < 25) then
			ARLOG("param error, loop interval too short");
		end
		LOOP_INTERVAL = interval
		ae.LuaUtils:call_function_after_delay(LOOP_INTERVAL, "BAR_INNER_LOOP")
	end

	AR.cancel_loop = function(self)
		BAR_ON_LOOP = false
		LOOP_FUNC = nil
	end

	function BAR_INNER_LOOP()
		if(type(LOOP_FUNC) == 'function') then
			LOOP_FUNC()
		end
		if BAR_ON_LOOP then
			ae.LuaUtils:call_function_after_delay(LOOP_INTERVAL, "BAR_INNER_LOOP")
		end
	end

	-- Delay -- 

	AR.perform_after = function(self, delay, func)
		local random_name = RES_CLOSURE(func)
		ae.LuaUtils:call_function_after_delay(delay, random_name)
	end

	ARLOG('Load AR')
end
LOAD_AR()

-- frame.lua end --
-- scene.lua --
function CREATE_SCENE()
	local NEW_SCENE = {}
	NEW_SCENE.application = 0
	setmetatable(NEW_SCENE, NEW_SCENE)
	NEW_SCENE.__index = function(self, key)
		if(self.entity[key] == nil) then
			local node = GET_NODE(self, key)
			if (node == nil) then
				ARLOG('尝试调用ar_scene的'..key..' 方法/属性, 该方法/属性不存在')
				return NOP_FUNC
			else
				return node
			end
		else
			__F_FUNC = function(self, ...)
				__BACK_FUNC = self.entity[key]
				return __BACK_FUNC(self.entity, ...)
			end
			return __F_FUNC
		end
	end
	return NEW_SCENE
end
ARLOG('load scene maker')
-- scene.lua end --
-- application.lua --

function LOAD_APPLICATION()
	local application = {}
	application.entity = nil

	application.on_loading_finish = 0
	application.on_target_lost = 0
	application.on_target_found = 0

	application.device = GET_DEVICE()
	application.device.application = application
	application.current_scene = 0

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

		function ON_TARGET_LOST()
			if(self.on_target_lost ~= 0) then
				self.on_target_lost()
			else
				local scene = self:get_current_scene()
				scene:set_visible(false)
			end
		end

		function ON_TARGET_FOUND()
			if(self.on_target_found ~= 0) then
				self.on_target_found()
			end
		end

		handler_id =  lua_handler:register_handle("APPLICATION_DID_LOAD")
		self:set_on_loading_finish_handler(handler_id)

		handler_id =  lua_handler:register_handle("ON_TARGET_LOST")
		self:set_on_tracking_lost_handler(handler_id)

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

	application.get_engine_version = function(self)
		local version = self.entity:get_engine_version()
		local engine_version = REOMVE_SPECIAL_SYMBOL(version,"%.")
		local version = tonumber(engine_version)
		local eng_version_table = {[100] = 0.4,[110] = 0.5}
		local v = eng_version_table[version]
		if(v == nil) then
			v = 99999
		end
		return v
	end

	application.open_url = function (self,url)
		local engine_version = self:get_engine_version()
		if engine_version > 0.4 then
			self.entity:open_url(url,1)
			ARLOG('------------ 1',engine_version)
		else
			self.entity:open_url(url,0)
			ARLOG('------------ 0',engine_version)
		end
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
-- node.lua --
function LOAD_NODE()
	AR_NODE_CACHE = {}
	function GET_NODE(scene ,name)
		CURRENT_SCENE = scene
		if(AR_NODE_CACHE[name] ~= nil)
		then
			return AR_NODE_CACHE[name]
		end

		local node = {}
		if(name == 'root')
		then
			node.entity = CURRENT_SCENE:get_root_node()
		else
			node.entity = CURRENT_SCENE:get_node_by_name(name)
		end

		if(node.entity == nil) then
			return nil
		end

		node.lua_handler = scene.application.lua_handler
		node._on_click = 0
		node._on_update = 0

		AR_NODE_CACHE[name] = node
		setmetatable(node, node)

		node.material = Material(node)


		node.__index = function(self, key) 

			if(key == "position") then
				return self:get_position()
			end

			if(key == "scale") then
				return self:get_scale()
			end

			if(self.entity[key] == nil)
			then
				ARLOG('尝试调用ar_node的'..key..' 方法/属性, 该方法/属性不存在')
				return NOP_FUNC
			else
				__F_FUNC = function(self, ...)
					__BACK_FUNC = self.entity[key]
					return __BACK_FUNC(self.entity, ...)
				end
				return __F_FUNC
			end
		end

		node.__newindex = function(self, key, value) 
			if(key == 'position') then
				self:set_position(value)
			elseif(key == 'scale') then
				self:set_scale(value)
			elseif(key == 'on_click') then
				local anony_func = function()
					if(self._on_click ~= 0) then
						self._on_click()
					end
				end
				self._on_click = value
				local RANDOM_NAME = RES_CLOSURE(anony_func)	
				local lua_handler = scene.application.lua_handler
				local handler_id = lua_handler:register_handle(RANDOM_NAME)
				self.entity:set_event_handler(0, handler_id)
			elseif(key == 'on_update') then
				local anony_func = function()
					if(self._on_update ~= 0) then
						self._on_update()
					end
				end
				self._on_update = value
				local RANDOM_NAME = RES_CLOSURE(anony_func)	
				local lua_handler = scene.application.lua_handler
				local handler_id = lua_handler:register_handle(RANDOM_NAME)
				self.entity:set_event_handler(100, handler_id)
				ARLOG('here')
			else 
				rawset(self, key, value)
			end
		end
		
		node.move_by = function(self)
			local anim = Anim('move_by', self)
			return anim
		end

		node.scale_by = function(self)
			local anim = Anim('scale_by', self)
			return anim
		end

		node.rotate_to = function(self)
			local anim = Anim('rotate_to', self)
			return anim
		end

		node.rotate_by = function(self)
			local anim = Anim('rotate_by', self)
			return anim
		end

        node.scale_from_to = function(self)
            local anim = Anim('scale_to', self)
            return anim
        end

		node.pod_anim = function(self)
			local anim = Anim('pod', self)
			return anim 
		end

		-- private
		node.get_position = function(self)
			local str_pos = self.entity:get_position()
			local vec = Vector3(str_pos)
			return vec
		end

		node.set_position = function(self, vec)
			self.entity:set_position(vec.x, vec.y, vec.z)
		end

		node.get_scale = function(self)
			local str_scale = self.entity:get_scale()
			local vec = Vector3(str_scale)
			return vec
		end

		node.set_scale = function(self, vec)
			self.entity:set_scale(vec.x, vec.y, vec.z)
		end

		node.audio = function (self)
			local audio = Audio(self)
			return audio
		end

		node.video = function (self)
			local video = Video(self)
			return video
		end

		-- private end

		return node
	end

	ARLOG('load node')
end

LOAD_NODE()

-- node.lua end --

-- node_material.lua -- 
function LOAD_MATERIAL()
	Material = {
		__call = function(self, entity)
			local material = {
				_entity = nil, 
				_scalar_key = {"roughness", "metalness", "clearCoat", "clearCoatRoughness", 
					"reflectivity","refractionRatio", "emissiveIntensity", "shininess", "opacity",
					"aoMapIntensity", "lightMapIntensity", "envMapIntensity", "emissiveIntensity", 
					"displacementScale", "displacementBias", "bumpScale",
					has = function(self, key)
						for k, v in pairs(self) do
							if(v == key) then
								return true
							end
						end
						return false
					end
					},
				_vector_key = {"offsetRepeat", "normalScale", "diffuse", "specular", "emissive",
					has = function(self, key)
						for k, v in pairs(self) do
							if(v == key) then
								return true
							end
						end
						return false
					end
				},
				__newindex = function(self, key, value)
					if(self._scalar_key:has(key)) then
						if(self._entity == nil) then
							return
						end
						self._entity:set_material_property(key, value)

					elseif(self._vector_key:has(key)) then
						if(self._entity == nil) then
							return
						end
						self._entity:set_material_vector_property(key, value)
					else
						ARLOG("material property setter error")
						rawset(self, key, value)
					end
				end
			}
			material._entity = entity
			setmetatable(material, material)
			return material
		end
	}
	setmetatable(Material, Material)
end

LOAD_MATERIAL()

-- node_material end ---- amath.lua -- 
function LOAD_MATH()
	Vector3 = {
		__add = function(self, other_vec3)
			local new_vec3 = Vector3("0,0,0")
			new_vec3.x = self.x + other_vec3.x
			new_vec3.y = self.y + other_vec3.y
			new_vec3.z = self.z + other_vec3.z
			return new_vec3
		end,
		__sub = function(self, other_vec3)
			local new_vec3 = Vector3("0,0,0")
			new_vec3.x = self.x - other_vec3.x
			new_vec3.y = self.y - other_vec3.y
			new_vec3.z = self.z - other_vec3.z
			return new_vec3
		end,
		__unm = function(self)
			local new_vec3 = Vector3("0,0,0")
			new_vec3.x = -self.x
			new_vec3.y = -self.y
			new_vec3.z = -self.z
			return new_vec3
		end,
		__mul = function(self, scalar)
			local new_vec3 = Vector3("0,0,0")
			new_vec3.x = self.x * scalar
			new_vec3.y = self.y * scalar
			new_vec3.z = self.z * scalar
			return new_vec3
		end,
		__div = function(self, scalar)
			local new_vec3 = Vector3("0,0,0")
			new_vec3.x = self.x / scalar
			new_vec3.y = self.y / scalar
			new_vec3.z = self.z / scalar
			return new_vec3
		end,
		__call = function(self, ...)
			local arg = { ... }
			param = arg[1]
			local vec3 = {}
			vec3.x = 0
			vec3.y = 0
			vec3.z = 0
			vec3.encode = function(self)
				return tostring(self.x)..','..tostring(self.y)..','..tostring(self.z)
			end

			setmetatable(vec3, self)
			if (type(param) == 'string') and (#arg == 1) then
				local arr = param:split(',')
				if #arr ~= 3 then
					vec3.x = 0
					vec3.y = 0
					vec3.z = 0
					return vec3	
				end
				vec3.x = arr[1]
				vec3.y = arr[2]
				vec3.z = arr[3]
				return vec3
			end

			if (#arg == 3) then
				vec3.x = arg[1]
				vec3.y = arg[2]
				vec3.z = arg[3]
				return vec3
			end

			return vec3
		end,
		__tostring = function(self)
			return 'x:'..tostring(self.x)..', y:'..tostring(self.y)..', z:'..tostring(self.z)
		end
	}
	setmetatable(Vector3, Vector3)

	ARLOG('load amath')
end
LOAD_MATH()
-- amath.lua end --

-- anim.lua --
function LOAD_ANIM()
	Anim = {
		__call = function(self, anim_type, entity) 
			local anim = {
				_anim_type = nil,
				_entity = nil,
				_duration = 1000,
				_repeat_max_count = 0,
				_forward_direction = 1,
				_start_offset = 0,
				_delay = 0,
				_repeat_mode = 0,
				_interpolater_type = 0,
				_src_xyz = Vector3("0,0,0"),
				_dst_xyz = Vector3("0,0,0"),
				_curve0_xyz = '',
				_curve1_xyz = '',
				_curve2_xyz = '',
				_curve3_xyz = '',
				_forward_logic = 0,
				_backward_logic = 0,
				_source_degree = 0,
				_target_degree = 0,
				_axis_xyz = Vector3("0,1,0"),
				_frame_start = -1,
				_frame_end = -1,
				_anim_name = -1,
				_speed = 1,
				_repeat = -1,
				_on_complete = nil,
				_anim_id = -1,
				get_meta_param = function(self)
					if self._anim_type == 'move_by' then
						local param = ae.TranslateMotionParam:new() 
						param._forward_direction = self._forward_direction
						param._repeat_mode = self._repeat_mode
						param._repeat_max_count = self._repeat_max_count
						param._duration = self._duration
						param._start_offset = self._start_offset
						param._delay = self._delay
						param._interpolater_type = self._interpolater_type
						param._curve0_xyz = self._curve0_xyz
						param._curve1_xyz = self._curve1_xyz
						param._curve2_xyz = self._curve2_xyz
						param._curve3_xyz = self._curve3_xyz

						param._dst_xyz = self._dst_xyz:encode()
						return param
					end
					if self._anim_type == 'move_to' then
						local param = ae.TranslateMotionParam:new() 
						param._forward_direction = self._forward_direction
						param._repeat_mode = self._repeat_mode
						param._repeat_max_count = self._repeat_max_count
						param._duration = self._duration
						param._start_offset = self._start_offset
						param._delay = self._delay
						param._interpolater_type = self._interpolater_type
						param._curve0_xyz = self._curve0_xyz
						param._curve1_xyz = self._curve1_xyz
						param._curve2_xyz = self._curve2_xyz
						param._curve3_xyz = self._curve3_xyz

						param._dst_xyz = self._dst_xyz:encode()
						param._src_xyz = self._src_xyz:encode()
						return param
					end
					if self._anim_type == 'scale_by' then
						local param = ae.ScaleMotionParam:new()
						param._forward_direction = self._forward_direction
						param._repeat_mode = self._repeat_mode
						param._repeat_max_count = self._repeat_max_count
						param._duration = self._duration
						param._start_offset = self._start_offset
						param._delay = self._delay
						param._interpolater_type = self._interpolater_type

						param._dst_xyz = self._dst_xyz:encode()
						return  param
					end
					if self._anim_type == 'scale_to' then
						local param = ae.ScaleMotionParam:new()
						param._forward_direction = self._forward_direction
						param._repeat_mode = self._repeat_mode
						param._repeat_max_count = self._repeat_max_count
						param._duration = self._duration
						param._start_offset = self._start_offset
						param._delay = self._delay
						param._interpolater_type = self._interpolater_type

						param._dst_xyz = self._dst_xyz:encode()
						param._src_xyz = self._src_xyz:encode()
						return param
					end
					if self._anim_type == 'rotate_to' then
						local param = ae.RotateMotionParam:new()
						param._forward_direction = self._forward_direction
						param._repeat_mode = self._repeat_mode
						param._repeat_max_count = self._repeat_max_count
						param._duration = self._duration
						param._start_offset = self._start_offset
						param._delay = self._delay
						param._interpolater_type = self._interpolater_type

						param._source_degree = self._source_degree
						param._target_degree = self._target_degree
						param._axis_xyz = self._axis_xyz:encode()
						return param
					end
					if self._anim_type == 'rotate_by' then
						local param = ae.RotateMotionParam:new()
						param._forward_direction = self._forward_direction
						param._repeat_mode = self._repeat_mode
						param._repeat_max_count = self._repeat_max_count
						param._duration = self._duration
						param._start_offset = self._start_offset
						param._delay = self._delay
						param._interpolater_type = self._interpolater_type

						param._target_degree = self._target_degree
						param._axis_xyz = self._axis_xyz:encode()
						return param
					end


				end,
				get_meta_action_priority_config = function(self)
					local action_config = ae.ActionPriorityConfig:new() 
					action_config.forward_logic = self._forward_logic
					action_config.backward_logic = self._backward_logic
					ARLOG("Get Action Config")
					return action_config
				end,

				start = function(self)
					local __anim_id = -1
					if(self._anim_type == 'pod') then
						if(VERSION_LOWER_8_5()) then
							if(self._repeat == -1) then
								__anim_id = self._entity:play_pod_animation_all(self._speed, self._repeat_max_count, self._frame_start, self._frame_end)
							else
								__anim_id = self._entity:play_pod_animation_all(self._speed, self._repeat, self._frame_start, self._frame_end)
							end
						else
							if(self._repeat == -1) then
								if(self._anim_name == -1) then
									__anim_id = self._entity:play_pod_animation_all(self._speed, self._repeat_max_count, self._frame_start, self._frame_end)
								else
									__anim_id = self._entity:play_pod_animation_all(self._speed, self._repeat_max_count, self._anim_name)
								end								
							else
								if(self._anim_name == -1) then
									__anim_id = self._entity:play_pod_animation_all(self._speed, self._repeat, self._frame_start, self._frame_end)
								else
									__anim_id = self._entity:play_pod_animation_all(self._speed, self._repeat, self._anim_name)
								end	
							end
						end
					else
						local param = self:get_meta_param()
						local config = self:get_meta_action_priority_config()
						__anim_id = self._entity:play_rigid_anim(param, config)
					end
					-- 配置回调函数
					if self._on_complete ~= nil then
						if type(self._on_complete) == 'string' then
							local handler_id = self._entity.lua_handler:register_handle(self._on_complete)
							self._entity:set_action_completion_handler(__anim_id, handler_id)
						end
						if type(self._on_complete) == 'function' then
							local RANDOM_NAME = RES_CLOSURE(self._on_complete)
							local handler_id = self._entity.lua_handler:register_handle(RANDOM_NAME)
							self._entity:set_action_completion_handler(__anim_id, handler_id)	
						end
					end
					self._anim_id = __anim_id
					return self
				end,
				pause = function(self)
					if(self._anim_id ~= -1) then
						self._entity:pause_action(self._anim_id)
					end
					return self
				end,
				resume = function(self)
					if(self._anim_id ~= -1) then
						self._entity:resume_action(self._anim_id)
					end
					return self
				end,
				stop = function(self)
					if(self._anim_id ~= -1) then
						self._entity:stop_action(self._anim_id)
						self._anim_id = -1
					end
					return self
				end,
				duration = function(self, d)
					self._duration = d
					return self
				end,
				repeat_mode = function(self, mode)
					self._repeat_mode = mode
					return self
				end, 
				repeat_count = function(self, count)
					self._repeat_max_count = count
					return self
				end,
				forward_direction = function(self, d)
					self._forward_direction = d
					return self
				end,
				start_offset = function(self, offset)
					self._start_offset = offset
					return self
				end,
				delay = function(self, d)
					self._delay = d
					return self
				end,
				to = function(self, vec)
					self._dst_xyz = vec
					return self
				end,
				from = function(self, vec)
					self._src_xyz = vec
					return self
				end,
				backward_logic = function(self, value)
					self._backward_logic = value
					return self
				end,
				forward_logic = function(self, value)
					self._forward_logic = value
					return self
				end,
				interpolater_type = function(self, mode)
					self._interpolater_type = mode
					return self
				end,
				on_complete = function(self, handler)
					self._on_complete = handler
					return self
				end,
				curve0_xyz = function(self, vector)
					self._curve0_xyz = vector:encode()
					return self
				end,
				curve1_xyz = function(self, vector)
					self._curve1_xyz = vector:encode()
					return self
				end,
				curve2_xyz = function(self, vector)
					self._curve2_xyz = vector:encode()
					return self
				end,
				curve3_xyz = function(self, vector)
					self._curve3_xyz = vector:encode()
					return self
				end,
				from_degree = function(self, degree)
					self._source_degree = degree
					return self
				end,
				to_degree = function(self, degree)
					self._target_degree = degree
					return self
				end,
				axis_xyz = function(self, vec)
					self._axis_xyz = vec
					return self
				end,
				frame_start = function(self, value)
					self._frame_start = value
					return self
				end,
				frame_end = function(self, value)
					self._frame_end = value
					return self
				end,
				speed = function(self, value)
					self._speed = value
					return self
				end,
				anim_name = function(self, value)
					self._anim_name = value
					return self
				end,
				anim_repeat = function(self, value)
					self._repeat = value
					return self
				end
			}
			setmetatable(anim, self)
			anim._anim_type = anim_type
			anim._entity = entity
			return anim
		end
	}
	setmetatable(Anim, Anim)

	ARLOG('load anim')
end

LOAD_ANIM()
-- anim.lua end--

-- audio.lua 

function LOAD_AUDIO()
	Audio = {
		__call = function (self, entity)
			local audio = {
				_entity = nil,
				_config = nil,
				_path = '',
				_repeat_count = 0,
				_delay = 0,
				_forward_logic = 0,
				_backward_logic = 0,
				_on_complete = nil,
				_audio_id = -1,

				get_meta_action_priority_config = function(self)
					local action_config = ae.ActionPriorityConfig:new() 
					action_config.forward_logic = self._forward_logic
					action_config.backward_logic = self._backward_logic
					ARLOG("Get Action Config")
					return action_config
				end,

				start = function(self)
					local config = self:get_meta_action_priority_config()
					local audio_id = self._entity:play_audio(config,self._path, self._repeat_count, self._delay)
					ARLOG(' ----------- 系统 play_audio 调用 -------------- ')
					if (self._on_complete ~= nil) then
						if type(self._on_complete) == 'string' then
							local lua_handler = self._entity.lua_handler
							local handler_id = lua_handler:register_handle(self._on_complete)
							self._entity:set_action_completion_handler(audio_id, handler_id)
						end
						if type(self._on_complete) == 'function' then
							local lua_handler = self._entity.lua_handler
							local RANDOM_NAME = RES_CLOSURE(self._on_complete)
							local handler_id = lua_handler:register_handle(RANDOM_NAME)
							self._entity:set_action_completion_handler(audio_id, handler_id)	
						end
					end
					self._audio_id = audio_id

					return self
				end,
				pause = function(self)
					self._entity:pause_action(self._audio_id)
					ARLOG(' ------------ 系统 pause_action(audio) 调用 -------------- ')
					return self

				end,
				resume = function(self)
					self._entity:resume_action(self._audio_id)
					ARLOG(' ------------ 系统 resume_action(audio) 调用 -------------- ')
					return self

				end,
				stop = function(self)
					self._entity:stop_action(self._audio_id)
					ARLOG(' ------------ 系统 stop_action(audio) 调用 -------------- ')
					return self

				end,
				path = function (self,string)
					self._path = string
					return self
				end,

				repeat_count = function (self,count)
					self._repeat_count = count
					return self
				end,

				delay = function (self,value)
					self._delay = value
					return self
				end,

				forward_logic = function (self,value)
					self._forward_logic = value
					return self
				end,
				backward_logic = function (self,value)
					self._backward_logic = value
					return self
				end,

				on_complete = function(self, handler)
					self._on_complete = handler
					return self
				end
			}
			audio._entity = entity
			return audio
		end
	}
	setmetatable(Audio,Audio)
	ARLOG('load audio')
end

LOAD_AUDIO()

-- audio.lua end



-- video.lua 
function LOAD_VIDEO()
	Video = {
		__call = function (self,entity)
			local video = {
				_entity = nil,
				_path = '',
				_repeat_count = 0,
				_delay = 0,
				_forward_logic = 0,
				_backward_logic = 0,
				_on_complete = nil,
				_video_id = -1,

				get_meta_action_priority_config = function(self)
					local action_config = ae.ActionPriorityConfig:new() 
					action_config.forward_logic = self._forward_logic
					action_config.backward_logic = self._backward_logic
					ARLOG("Get Action Config")
					return action_config
				end,
				start = function (self)
					local config = self:get_meta_action_priority_config()
					local video_id = self._entity:play_texture_video(config, self._path, self._repeat_count, self._delay)
					ARLOG(' ----------- 系统 play_texture_video 调用 -----------')
					if(self._on_complete ~= nil) then
						if type(self._on_complete) == 'string' then
							local lua_handler = self._entity.lua_handler
							local handler_id = lua_handler:register_handle(self._on_complete)
							self._entity:set_action_completion_handler(video_id, handler_id)
						end
						if type(self._on_complete) == 'function' then
							local lua_handler = self._entity.lua_handler
							local RANDOM_NAME = RES_CLOSURE(self._on_complete)
							local handler_id = lua_handler:register_handle(RANDOM_NAME)
							self._entity:set_action_completion_handler(video_id, handler_id)	
						end
					end
					self._video_id = video_id

					return self
				end,
				pause = function (self)
					self._entity:pause_action(self._video_id)
					ARLOG(' ------------ 系统 pause_action(video) 调用 -------------- ')
					return self
				end,
				resume = function (self)
					self._entity:resume_action(self._video_id)
					ARLOG(' ------------ 系统 resume_action(video) 调用 -------------- ')
					return self
				end,

				stop = function (self)
					self._entity:stop_action(self._video_id)
					ARLOG(' ------------ 系统 stop_action(video) 调用 -------------- ')
					return self
				end,

				path = function (self,string)
					self._path = string
					return self
				end,
				repeat_count = function (self,count)
					self._repeat_count = count
					return self
				end,
				delay = function (self,value)
					self._delay = value
					return self
				end,

				forward_logic = function (self,value)
					self._forward_logic = value
					return self
				end,
				backward_logic = function (self,value)
					self._backward_logic = value
					return self
				end,
				on_complete = function (self,handler)
					self._on_complete = handler
					return self
				end
			}
			video._entity = entity
			return video
		end
	}
	setmetatable(Video,Video)
	ARLOG('load video')
end
LOAD_VIDEO()

-- video.lua end
app = AR:create_application(AppType.ImageTrack, "bear")
app:load_scene_from_json("res/simple_scene.json","demo_scene")

scene = app:get_current_scene()

local version = app:get_engine_version()

-- print(type(version) ..' === === = == = == '.. version)
-- ARLOG(' ======================================================================')

app.on_loading_finish = function()
	app.device:open_shake_listener()
	app.device:stop_track_service()
	scene.bear.on_click = function()
		app.device:open_track_service()
	end
	pod_anim_test()
	-- audio_test()

end

function rigid_anim_test()
	anim = scene.bear:rotate_by()
					 :duration(2000)
					 :repeat_mode(1)
					 :repeat_count(0)
					 :axis_xyz(Vector3(1,0,0))
					 :to_degree(360)
					 :on_complete(function() 
					 	ARLOG('anim done')
					 end)
					 :start()
end

function pod_anim_test()
	anim = scene.bear:pod_anim()
					 :anim_repeat(false)
					 :on_complete(function() 
					 	ARLOG('pod anim done')
					 end)
					 :anim_repeat(true)
					 :start()
	
	scene.bear.on_click = function()
		anim:stop()
	end

	scene.share.on_click = function()
		anim:pause()
	end

	scene.resume.on_click = function()
		anim:resume()
	end
end


function video_test()
	v_id = 0
	ARLOG(' === 封装 video  性能、功能、逻辑测试 ===  ')
	video_id = scene.videoPlane:video()
						 :path('res/media/star_plan.mp4')
						 :repeat_count(3)
						 :delay(1000)
						 :on_complete(function ()
						 	v_id = 0
						 	ARLOG(' vodeo done  ------- start next short.mp4  ---- '..v_id)
						 end)

	scene.share.on_click = function()
		ARLOG(' share click  ')
		if v_id == 1 then
			ARLOG(' --- bear video pause  --- ')
			video_id:pause()
			v_id = 2
		elseif v_id == 2 then
			ARLOG(' --- bear video resume  --- ')
			video_id:resume()
			v_id = 3
		elseif v_id == 3 then
			ARLOG(' --- bear video stop  --- ')
			video_id:stop()
			v_id = 0
		elseif v_id == 0 then
			ARLOG(' --- bear video again start --- ')
			video_id:start()
			v_id = 1
		end
		
	end
end

function audio_test()
	a_id = 0
	ARLOG(' === 封装 Audio  性能、功能、逻辑测试 === ')
		audio_id = scene.bear:audio()
		  :path('res/media/music.mp3')
		  :repeat_count(-2)
		  :delay(1000)
		  :on_complete(function() 
		  		a_id = 0	
		  		ARLOG('audio done --- start next short.mp3 ---'..a_id)
		  		audio_id:path('res/media/short.mp3')
		  				:repeat_count(-1)
		  				:delay(1000)
		  				:on_complete(function ()
		  					a_id = 0	
		  				end)
		  	end)

	scene.resume.on_click = function ()
		ARLOG(' button click  ')
		if a_id == 1 then
			ARLOG(' --- bear music pause  --- ')
			audio_id:pause()
			a_id = 2
		elseif a_id == 2 then
			ARLOG(' --- bear music resume  --- ')
			audio_id:resume()
			a_id = 3
		elseif a_id == 3 then
			ARLOG(' --- bear music stop  --- ')
			audio_id:stop()
			a_id = 0
		elseif a_id == 0 then
			ARLOG(' --- bear music again start --- ')
			audio_id:start()
			a_id = 1
		end
	end
end


app.on_target_found = function()
	ARLOG('on target found')
end

app.on_target_lost = function()
	ARLOG('on target lost')
end

app.device.on_device_rotate = function(orientation)
	if(orientation == DeviceOrientation.Left) then
		ARLOG('Rotate to left')
	elseif(orientation == DeviceOrientation.Right) then
		ARLOG('Rotate to right')
	elseif(orientation == DeviceOrientation.Portrait) then
		ARLOG('Rotate to Portrait')
	end
end

app.device.on_device_shake = function()
	ARLOG('shake')
end

app.device.on_camera_change = function(is_front_camera)
	ARLOG('on camera change '..is_front_camera)
end







