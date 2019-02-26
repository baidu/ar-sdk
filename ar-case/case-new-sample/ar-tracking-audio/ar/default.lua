
app_controller = ae.ARApplicationController:shared_instance()
app_controller:require('./scripts/include.lua')

app = AR:create_application(AppType.ImageTrack, "audio scene")
app:load_scene_from_json("res/simple_scene.json","scene")
scene = app:get_current_scene()

--local player = ae.ARMusicPlayer:get_instance()
local rigid_session 

app.on_loading_finish = function()
    pod_node = scene:get_node_by_name("simplePod")
    anim_controller = pod_node:get_animation_controller()
    local config = {}
    config["repeat_count"] = 0
    local model_anim_session = anim_controller:create_animation_session("model", config)
    model_anim_session:play()

    rigid_controller = pod_node:get_media_controller()
    rigid_config = {}
    rigid_config["repeat_count"] =0

    rigid_session = rigid_controller:create_media_session("audio","/res/media/bg.mp3", rigid_config)
    rigid_session:play()

end

app.on_target_found = function()
    rigid_session:play()
end


app.on_target_lost = function()
    rigid_session:pause()
end
