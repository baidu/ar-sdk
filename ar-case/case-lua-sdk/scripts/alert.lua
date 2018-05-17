-- alert.lua

function LOAD_ALERT()

    Alert = {

        __call = function(self,id)
            local alert = {
                _msg = nil,
                _title = nil,
                _confirm_text = nil,
                _cancel_text = nil,
                _on_confirm = nil,
                _on_cancel = nil,

                get_key = function(self)
                    local key = tostring(os.clock())..tostring(math.random(1,1000000))
                    return key
                end,

                show = function(self)
                    local mapData = ae.MapData:new() 
                    local key = self:get_key()

                    mapData:put_int("id", MSG_TYPE_SHOW_DIALOG)
                    mapData:put_string("msg",self._msg)
                    mapData:put_string("title",self._title)
                    mapData:put_string("confirm_text",self._confirm_text)
                    mapData:put_string("cancel_text",self._cancel_text)
                    mapData:put_string("key",key)
                    AR.current_application.lua_handler:send_message_tosdk(mapData)
                    mapData:delete()
                    Alert.instances[key] = self
                    return self
                end,

                show_dialog = function (self,msg)
                    self._msg = msg
                    return self
                end,

                title = function (self,title)
                    self._title = title
                    return self
                end,

                confirm_text = function (self,confirm_text)
                    self._confirm_text = confirm_text
                    return self
                end,
                cancel_text = function (self,cancel_text)
                    self._cancel_text = cancel_text
                    return self
                end,

                on_confirm = function(self, handler)
                    self._on_confirm = handler
                    return self
                end,

                on_cancel = function(self, handler)
                    self._on_cancel = handler
                    return self
                end,

                show_toast = function(self,msg)
                    local mapData = ae.MapData:new() 
                    local key = self:get_key()

                    mapData:put_int("id", MSG_TYPE_SHOW_TOAST)
                    mapData:put_string("msg",msg)
                    mapData:put_string("key",key)
                    AR.current_application.lua_handler:send_message_tosdk(mapData)
                    mapData:delete()
                    
                    Alert.instances[key] = self
                    return self
                end

            }

            return alert
        end
    }

    setmetatable(Alert,Alert)

    Alert.instances = {}

    Alert.CallBack = function(mapData)

        key = mapData["key"]
        result = mapData["result"]
        alert = Alert.instances[key]
        if result == "confirm" then
            alert._on_confirm()
        elseif result == "cancel" then
            alert._on_cancel()
        end

    end

    ARLOG('load Alert')
end

LOAD_ALERT()




