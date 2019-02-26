function LOAD_PADDLE_IMGSEG()
    PaddleImgseg = {}    

    PaddleImgseg.send_control_msg = function(self,open)
        local mapData = ae.MapData:new() 
        mapData:put_int("id", PADDLE_IMGSEG_CONTROL)
        mapData:put_int("open", open)
        AR.current_application.lua_handler:send_message_tosdk(mapData)
    end
    
end

LOAD_PADDLE_IMGSEG()