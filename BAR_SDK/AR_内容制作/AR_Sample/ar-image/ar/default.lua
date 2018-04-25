--图片遮挡

app_controller = ae.ARApplicationController:shared_instance()
app_controller:require('./scripts/include.lua')

app = AR:create_application(AppType.ImageTrack, "bear")
app:load_scene_from_json("res/simple_scene.json","demo_scene")

scene = app:get_current_scene()

app.on_loading_finish = function()
	AR:perform_after(1000, function() 
		scene.sakuraPlane:play_frame_animation(0, 0)
	end)
end
