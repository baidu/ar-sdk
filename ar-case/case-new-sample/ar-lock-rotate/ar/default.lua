--跟上锁定水平&跟丢解锁水平

app_controller = ae.ARApplicationController:shared_instance()
app_controller:require('./scripts/include.lua')

--创建图像跟踪
app = AR:create_application(AppType.ImageTrack, "scene")
--从Json中加载场景，并激活场景scene
app:load_scene_from_json("res/simple_scene.json","scene")

local scene = app.current_scene

app.on_loading_finish = function ()
	scene.bwPhoto:set_rotate_with_world_axis(1);
	
end

app.on_target_lost = function ()
	setBirdEyeView()
    scene.bwPhoto:set_rotate_with_world_axis(-1);
	-- body
end

app.on_target_found = function ()
	scene.bwPhoto:set_rotate_with_world_axis(1);
	-- body
end
function setBirdEyeView()
    app:set_camera_look_at("0.0, 0.0, 800.0", "0, 0, 0", "0, 2.0, 1.0")
end