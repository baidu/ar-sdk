function LOAD_LOGO()
    Logo = {}
    Logo.callBack = nil

    Logo.stop_recg = function(self, code)
        local mapData = ae.MapData:new()
        mapData:put_int("id", MSG_TYPE_LOGO_STOP)
        mapData:put_string("logo_code", code)
        lua_handler:send_message_tosdk(mapData)
    end
    Logo.stat_recg = function(self, code)
        local mapData = ae.MapData:new()
        mapData:put_int("id", MSG_TYPE_LOGO_START)
        mapData:put_string("logo_code", code)
        lua_handler:send_message_tosdk(mapData)
    end

    Logo.hit_recg = function(self, code)
        local mapData = ae.MapData:new()
        mapData:put_int("id", MSG_TYPE_LOGO_HIT)
        mapData:put_string("logo_code", code)
        lua_handler:send_message_tosdk(mapData)
    end
end

LOAD_LOGO()

