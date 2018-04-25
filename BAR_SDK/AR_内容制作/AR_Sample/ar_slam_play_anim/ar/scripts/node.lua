-- node.lua --
function LOAD_NODE()

	NULL_NODE = {}
	NULL_NODE.__index = function(self, key)
		ARLOG('NULL_NODE operation')
		return self
	end
	NULL_NODE.__call = function(self, ...)
		ARLOG('NULL_NODE operation')
	end
	NULL_NODE.__newindex = function(self, key, value)
		ARLOG('NULL_NODE operation')
	end
	setmetatable(NULL_NODE, NULL_NODE)

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
			ARLOG('NULL NODE created')
			return NULL_NODE
		end

		node.lua_handler = scene.application.lua_handler
		node._on_click = 0
		node._on_update = 0

		AR_NODE_CACHE[name] = node
		setmetatable(node, node)

		node.material = Material(node)
		node.particle = ParticleSystem(node)


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

