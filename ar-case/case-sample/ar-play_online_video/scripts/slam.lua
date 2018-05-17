-- slam.lua --
function SLAM()
	local Slam = {}
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

	return Slam
end
-- slam.lua end --

