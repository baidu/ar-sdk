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
					local video_id = self._entity:play_texture_video(self._path,self._repeat_count,self._delay)

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
					self._delay = delay
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
