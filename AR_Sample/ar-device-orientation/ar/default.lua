app_controller = ae.ARApplicationController:shared_instance()
app_controller:require('./scripts/include.lua')
app = AR:create_application(AppType.ImageTrack, "bear")
app:load_scene_from_json("res/simple_scene.json","demo_scene")

scene = app:get_current_scene()

local version = app:get_engine_version()

-- print(type(version) ..' === === = == = == '.. version)
-- ARLOG(' ======================================================================')

app.on_loading_finish = function()

end



app.on_target_found = function()
	ARLOG('on target found')
end

app.on_target_lost = function()
	ARLOG('on target lost')
end

app.device.on_device_rotate = function(orientation)
	if(orientation == DeviceOrientation.Left) then
		ARLOG('Rotate to left')
	elseif(orientation == DeviceOrientation.Right) then
		ARLOG('Rotate to right')
	elseif(orientation == DeviceOrientation.Portrait) then
		ARLOG('Rotate to Portrait')
	end
end






