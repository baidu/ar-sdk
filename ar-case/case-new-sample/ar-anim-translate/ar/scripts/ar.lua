-- frame.lua --
function LOAD_AR()	
	AR = {}
	AR.current_application = 0

	function AR.create_application(self, app_type, name)
		local app_entity = 0
		app_entity = ae.ARApplicationController:shared_instance():add_application_with_type(app_type, name)

		local app = LOAD_APPLICATION()
		app.entity = app_entity
		app:setup_handlers()

		lua_handler = app:get_lua_handler()
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


	-- DataStore --
	AR.set_dataStore = function(self, mode, key, value)
		ae.SharedPreference:set_value(mode, key, value) 
	end


	AR.get_dataStore = function(self, mode, key)
		local name = ae.SharedPreference:get_value(mode, key)
		return name
	end

	ARLOG('Load AR')
end
LOAD_AR()

-- frame.lua end --
