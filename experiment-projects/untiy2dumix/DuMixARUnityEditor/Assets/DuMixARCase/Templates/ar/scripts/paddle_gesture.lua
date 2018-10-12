function LOAD_PADDLE_GESTURE()
    PaddleGesture = {}
    PaddleGesture.on_gesture_detected = nil

    PaddleGesture.send_control_msg = function(self,open)
        local mapData = ae.MapData:new() 
        mapData:put_int("id", PADDLE_GESTURE_CONTROL)
        mapData:put_int("open", open)
        AR.current_application.lua_handler:send_message_tosdk(mapData)
        mapData:delete()
    end

    PaddleGesture.CallBack = function(mapData)
        if(PaddleGesture.on_gesture_detected ~= nil) then
            PaddleGesture.on_gesture_detected(mapData)
        end
    end
end

LOAD_PADDLE_GESTURE()