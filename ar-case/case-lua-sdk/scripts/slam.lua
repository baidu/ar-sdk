-- slam.lua --
function SLAM()
	local Slam = {}

    Slam.on_first_plane_detected = 0
    Slam.on_all_plane_lost = 0

    -- Slam.is_show_lay_model = 0
    -- Slam.open_place_status = 0
    -- Slam.close_place_status = 0

	function Slam.slam_reset(self, x, y, depth, reset_type)
        reset_type = reset_type or 2
    	local mapData = ae.MapData:new() 
        mapData:put_int("id", MSG_TYPE_SLAM_RESET) 
        mapData:put_float("x",x)
        mapData:put_float("y",y)
        mapData:put_int("type",reset_type)
        mapData:put_float("distance",depth)
        AR.current_application.lua_handler:send_message_tosdk(mapData)
        mapData:delete()
	end

    function Slam.start_slam()
        local mapData = ae.MapData:new() 
        mapData:put_int("id", MSG_TYPE_START_SLAM) 
        AR.current_application.lua_handler:send_message_tosdk(mapData)
        mapData:delete()
    end

    -- artype = 9 时 以下方法生效 -- 

    function Slam.start_plane_detect(type)
         local mapData = ae.MapData:new()
         mapData:put_string("event_name", "start_detect_plane")
         app.lua_handler:send_message_tosdk(mapData)
         mapData:delete()
    end

    function Slam.set_plane_detection_type(type)

        local msg = {}
        msg["event_name"] = "set_plane_detection_type"
        msg["type"] =  type
        
        app_controller:send_message_to_native(msg)
    end

    function Slam.redetect_plane(self)
        local msg = {}
        msg["event_name"] = "redetect_plane"
        
        app_controller:send_message_to_native(msg)
    end

    function Slam.set_plane_feature_info_enabled(type)

        local current_type = 0
         if type == false then
            current_type = 0
         else
            current_type = 1
         end

        local msg = {}
        msg["event_name"] = "set_plane_feature_info_enabled"
        msg["type"] =  current_type
        
        app_controller:send_message_to_native(msg)

    end

    function Slam.set_plane_hit_test_enabled(type, x, y)

        local data = ae.MapData:new()
        data:put_int("type", type)
        if x == nil or y == nil then
            data:put_int("dafault", 1)
        else
            data:put_float("x", x)
            data:put_float("y", y)
        end

         local mapData = ae.MapData:new()
         mapData:put_string("event_name", "plane_hit_test_enabled")
         mapData:put_map_data("event_data", data)
         app.lua_handler:send_message_tosdk(mapData)
         mapData:delete()
         data:delete()

    end

    -- function Slam.open_place_status(self)
    --     local mapData = ae.MapData:new()
    --     mapData:put_int("id", MSG_TYPE_OPEN_PLACE_STATUE)
    --     app.lua_handler:send_message_tosdk(mapData)
    --     mapData:delete()
    -- end

    -- function Slam.close_place_status(self)
    --     local mapData = ae.MapData:new()
    --     mapData:put_int("id", MSG_TYPE_CLOSE_PLACE_STATUE) 
    --     app.lua_handler:send_message_tosdk(mapData)
    --     mapData:delete()
    -- end

    -- end --

	return Slam
end

-- slam.lua end --

