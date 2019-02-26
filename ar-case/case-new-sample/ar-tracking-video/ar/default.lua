
app_controller = ae.ARApplicationController:shared_instance()
app_controller:require('./scripts/include.lua')
app = AR:create_application(AppType.ImageTrack, "video scene")
app:load_scene_from_json("res/simple_scene.json","scene")
scene = app:get_current_scene()

local rigid_session 


app.on_loading_finish = function()
    video_node = scene:get_node_by_name("videoPlane")
    rigid_controller = video_node:get_media_controller()
    rigid_config = {}
    rigid_config["repeat_count"] =0
    --rigid_config["delay"] = 5000

    rigid_session = rigid_controller:create_media_session("video","/res/media/content.mp4", rigid_config)
    rigid_session:play()
end

app.on_target_found = function()
    rigid_session:play()
end

app.on_target_lost = function()
    rigid_session:pause()
end

