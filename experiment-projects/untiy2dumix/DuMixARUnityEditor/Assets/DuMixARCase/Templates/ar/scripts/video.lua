-- video.lua 
function LOAD_VIDEO()
	Video = {
		__call = function (self,entity)
			local video = {
				_entity = nil,
				_path = '',
				_is_remote = 0,
				_from_time = 0,
				_repeat_count = 0,
				_delay = 0,
				_forward_logic = 0,
				_backward_logic = 0,
				_on_complete = nil,
				_video_id = -1,
                _refresh_when_stop = false,

                _video_total_length = 0,
                _video_play_length = 0,
                _video_is_played = false,

				get_meta_action_priority_config = function(self)
					local action_config = ae.ActionPriorityConfig:new() 
					action_config.forward_logic = self._forward_logic
					action_config.backward_logic = self._backward_logic
					ARLOG("Get Action Config")
					return action_config
				end,
				start = function (self)
					local config = self:get_meta_action_priority_config()
					local video_id = self._entity:play_texture_video(config, self._path, self._repeat_count, self._delay, self._is_remote, self._from_time)
                    local engine_version = app:get_version()
                    if engine_version < 150 then
        				video_id = self._entity:play_texture_video(config,self._path, self._repeat_count, self._delay)
        			end
					config:delete()
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
                    self._video_is_played = true

					return self
				end,
				pause = function (self)
					self._entity:pause_action(self._video_id)
                    self._video_is_played = false
					ARLOG(' ------------ 系统 pause_action(video) 调用 -------------- ')
					return self
				end,
				resume = function (self)
					self._entity:resume_action(self._video_id)
                    self._video_is_played = true
					ARLOG(' ------------ 系统 resume_action(video) 调用 -------------- ')
					return self
				end,
				stop = function (self)
					self._entity:stop_action(self._video_id)
                    if (self._refresh_when_stop) then
                        self:refresh_texture()
                    end
                    self._video_is_played = false
					ARLOG(' ------------ 系统 stop_action(video) 调用 -------------- ')
					return self
				end,
                refresh_texture = function(self)
                    self._entity:refresh_texture("video_texture")
                    return self
                end,
				path = function (self,string)
					self._path = string
					return self
				end,
				is_remote = function (self, remote)
                	self._is_remote = remote
                	return self
                end,
                from_time = function (self, from)
                	self._from_time = from
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
				end,
                reset_texture_when_use_stop = function (self,value)
                    self._refresh_when_stop = value
                    return self
                end,

                --for 10.2临时解决方案的接口
                video_total_length = function (self, value)
                    self._video_total_length = value
                    return self
                end,

                get_video_play_info = function (self)
                    return self._entity:get_video_play_info(self._video_id)
                end,

                --for 10.2临时解决方案的接口
                check_if_pause = function (self, value, value2)
                    local engine_version = CURRENT_SCENE.application:get_version()
                    if (not engine_version == 23) then
                        return self
                    end

                    if (self._video_is_played) then
                        self._video_play_length = self._video_play_length + value
                        if (self._video_play_length > self._video_total_length * value2) then
                            io.write("play_length"..self._video_play_length)
                            self:pause()
                            self._video_is_played = false
                            self._video_play_length = 0
                            if type(self._on_complete) == 'function' then
                                self._on_complete()
                            end
                         end
                    end
                    return self
                end
			}
			video._entity = entity
			return video
		end
	}
	Video.callBack = nil
	setmetatable(Video,Video)
	ARLOG('load video')
end
LOAD_VIDEO()

-- video.lua end
