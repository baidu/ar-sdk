-- arkit.lua --
function arkit()
	local ARKit = {}

    ARKit.on_first_plane_detected = 0
    ARKit.on_all_plane_lost = 0

    function ARKit.start_plane_detect(type)
         local mapData = ae.MapData:new()
         mapData:put_string("event_name", "start_detect_plane")
         app.lua_handler:send_message_tosdk(mapData)
         mapData:delete()
    end

    function ARKit.set_plane_detection_type(type)

        local msg = {}
        msg["event_name"] = "set_plane_detection_type"
        msg["type"] =  type
        
        app_controller:send_message_to_native(msg)
    end

    function ARKit.redetect_plane(self)
        local msg = {}
        msg["event_name"] = "redetect_plane"
        
        app_controller:send_message_to_native(msg)
    end

    function ARKit.set_plane_feature_info_enabled(type)

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

	return ARKit
end

-- arkit.lua end --

