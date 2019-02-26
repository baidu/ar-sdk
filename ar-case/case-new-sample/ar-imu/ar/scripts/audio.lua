-- audio.lua 

function LOAD_AUDIO()
	Audio = {
		__call = function (self, entity)
			local audio = {
				_entity = nil,
				_config = nil,
				_path = '',
				_is_remote = 0,
				_from_time = 0,
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
					local audio_id = self._entity:play_audio(config,self._path, self._repeat_count, self._delay, self._is_remote, self._from_time)
                    local engine_version = app:get_version()
                    if engine_version < 150 then
        				audio_id = self._entity:play_audio(config,self._path, self._repeat_count, self._delay)
        			end
					config:delete()
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

				get_audio_play_info = function (self)
                    return self._entity:get_audio_play_info(self._audio_id)
                end,

                is_remote = function (self, remote)
                	self._is_remote = remote
                	return self
                end,

                from_time = function (self, from)
                	self._from_time = from
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
	Audio.callBack = nil
	setmetatable(Audio,Audio)
	ARLOG('load audio')
end

LOAD_AUDIO()

-- audio.lua end



