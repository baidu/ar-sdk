-- framePicture.luap
function LOAD_FRAME_PICTURE()
	FramePicture = {
		__call = function (self,entity)
			local framePicture = {
				_entity = nil,
				_repeat_count = 0,
				_delay = 0,
				_on_complete = nil,
				_framePicture_id = -1,


				start = function (self)
					local framePicture_id = self._entity:play_frame_animation(self._repeat_count, self._delay)
					ARLOG(' ----------- 系统 play_frame_animation 调用 -----------')
					if(self._on_complete ~= nil) then
						if type(self._on_complete) == 'string' then
							local lua_handler = self._entity.lua_handler
							local handler_id = lua_handler:register_handle(self._on_complete)
							self._entity:set_action_completion_handler(framePicture_id, handler_id)
						end
						if type(self._on_complete) == 'function' then
							local lua_handler = self._entity.lua_handler
							local RANDOM_NAME = RES_CLOSURE(self._on_complete)
							local handler_id = lua_handler:register_handle(RANDOM_NAME)
							self._entity:set_action_completion_handler(framePicture_id, handler_id)	
						end
					end
					self._framePicture_id = framePicture_id

					return self
				end,
				pause = function (self)
					self._entity:pause_action(self._framePicture_id)
					ARLOG(' ------------ 系统 pause_action(framePicture) 调用 -------------- ')
					return self
				end,
				resume = function (self)
					self._entity:resume_action(self._framePicture_id)
					ARLOG(' ------------ 系统 resume_action(framePicture) 调用 -------------- ')
					return self
				end,

				stop = function (self)
					self._entity:stop_action(self._framePicture_id)
					ARLOG(' ------------ 系统 stop_action(framePicture) 调用 -------------- ')
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

				on_complete = function (self,handler)
					self._on_complete = handler
					return self
				end
			}
			framePicture._entity = entity
			return framePicture
		end
	}
	setmetatable(FramePicture,FramePicture)
	ARLOG('load framePicture')
end
LOAD_FRAME_PICTURE()

-- framePicture.lua end
