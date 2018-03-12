-- scene.lua --
function CREATE_SCENE()
	local NEW_SCENE = {}
	NEW_SCENE.application = 0
	NEW_SCENE._on_touch_event = 0
	NEW_SCENE._on_batch_load_finish = 0
	NEW_SCENE._on_batch_load_progress_update = 0
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
	NEW_SCENE.__newindex = function(self, key, value)
		if(key == 'on_touch_event') then
			local anony_func = function(etype, ex, ey)
				if(self._on_touch_event ~= 0) then
					self._on_touch_event(etype, ex, ey)
				end
			end
			self._on_touch_event = value
			local RANDOM_NAME = RES_CLOSURE(anony_func)
			local lua_handler = self.application.lua_handler
			local handler_id = lua_handler:register_handle(RANDOM_NAME)
			self.entity:set_event_handler(EventType.Scroll, handler_id)
			self.entity:set_event_handler(EventType.ScrollDown, handler_id)
			self.entity:set_event_handler(EventType.ScrollUp, handler_id)

		elseif (key == 'on_batch_load_finish')  then
			local anony_func = function(id,ret)
				if(self._on_batch_load_finish ~= 0) then
					self._on_batch_load_finish(id ,ret)
				end
			end
			self._on_batch_load_finish = value
			local RANDOM_NAME = RES_CLOSURE(anony_func)
			local lua_handler = self.application.lua_handler
			local handler_id = lua_handler:register_handle(RANDOM_NAME)
			self.entity:set_event_handler(EventType.BatchLoadFinish, handler_id)
			
		elseif (key == 'on_batch_load_progress_update')  then
			local anony_func = function(id, progress)
				if(self._on_batch_load_progress_update ~= 0) then
					self._on_batch_load_progress_update(id ,progress)
				end
			end
			self._on_batch_load_progress_update = value
			local RANDOM_NAME = RES_CLOSURE(anony_func)
			local lua_handler = self.application.lua_handler
			local handler_id = lua_handler:register_handle(RANDOM_NAME)
			self.entity:set_event_handler(EventType.BatchLoadProgressUpdate, handler_id)
		else
			rawset(self, key, value)
		end
	end

     NEW_SCENE.delete_node_by_name = function(self, node_name)
        AR_NODE_CACHE[node_name] = nil
        self:remove_node_by_name(node_name)
    end

	return NEW_SCENE
end
ARLOG('load scene maker')
-- scene.lua end --

