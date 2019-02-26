-- speech.lua -- 
function LOAD_HTTPS()

    CONN = {
        __call = function (self, http_instance, id)

        local conn = {
        _HTTPS = nil,
        _request_id = 0,
        _request_method = "POST",
        _url = '',
        _content = '',
        _stuats_callback = nil,
        _answer_callback = nil,

        set_request_method = function (self, string)
            self._request_method = string
            --io.write("url set_request_method:")
            return self
        end,

        set_url = function (self, string)
            self._url = string
            --io.write("url set_url:")
            return self

        end,

        set_content = function (self, string)
            self._content = string
            --io.write("url set_content:")
            return self
        end,

        on_send_error = function (self, handler)
            self._stuats_callback = handler
            return self
        end,

        on_receive_answer = function (self, handler)
            self._answer_callback = handler
            return self
        end,

        send = function (self)
            local mapData = ae.MapData:new() 
		    mapData:put_int("id", MSG_TYPE_LUA_URL_REQUEST)

            local request_id = "LuaHttpRequest"..tostring(self._request_id)

		    mapData:put_string("request_id", request_id)
		    mapData:put_string("request_method", self._request_method)
		    mapData:put_string("url", self._url) 
		    mapData:put_string("content",self._content)

		    lua_handler:send_message_tosdk(mapData)
            mapData:delete()

            self._HTTPS:ADD_REQUEST_TABLE(request_id, self)
            io.write("HTTP_REQUEST_SEND,ID:"..self._request_id)
		    return self
        end,

        status_callback = function (self, mapdata)
            local status = mapdata['status']
            if (status == UrlStatus.NetworkError) then
            	ARLOG("request failed for network error! the url is:"..self._url)
            end

            if (status == UrlStatus.ParamError) then
            	ARLOG("request failed for parameter error! the url is:"..self._url)
            end

            if (self._stuats_callback ~= nil) then
            	self._stuats_callback(status)
            end
        end,

        answer_callback = function (self, mapdata)
            local data = mapdata['data']
            if (self._answer_callback ~= nil) then
                if (data == "{}") then
                    ARLOG("warning! request's answer from server is nil! please check your url or content, url is:"..self._url)
                end
            	self._answer_callback(data)
            end
        end,

        get_request_id = function (self)
            local id_string = "LuaHttpRequest"..tostring(self._request_id)
            return id_string
        end
        }
        conn._HTTPS = http_instance
        conn._request_id = id
        return conn

        end

    }
    setmetatable(CONN,CONN)


    HTTPS = {
	    REQUEST_ID = 0,
        REQUEST_TABLE = {
        },

        REQUEST_ID_ADD = function (self)
            self.REQUEST_ID = self.REQUEST_ID + 1
        end,

        ADD_REQUEST_TABLE = function (self, request_id, conn_instance)
            self.REQUEST_TABLE[request_id] = conn_instance
        end,

        HANDLE_CALLBACK_FORM_SDK = function(self, mapdata)

            local answer_type = mapdata['id']
            local request_id = mapdata['request_id']

            local conn = self.REQUEST_TABLE[request_id]
                if (conn ~= nil) then
                    if (answer_type == MSG_TYPE_LUA_REQUEST_STATUS) then
                        conn:status_callback(mapdata)
                	end
                	if (answer_type == MSG_TYPE_LUA_REQUEST_ANSWER) then
                		conn:answer_callback(mapdata)
                	end
                    self.REQUEST_TABLE[request_id] = nil
                end
        end,
        open_connection = function (self)
            local Connection = CONN(self,self.REQUEST_ID)
            self:REQUEST_ID_ADD()
            return Connection
        end
    }
end

LOAD_HTTPS()

-- speech.lua end --
