--背景音乐2

app_controller = ae.ARApplicationController:shared_instance()
app_controller:require('./scripts/include.lua')

app = AR:create_application(AppType.ImageTrack, "demo")
app:load_scene_from_json("res/simple_scene.json","demo_scene")
scene = app:get_current_scene()

app.on_loading_finish = function()
    app:play_bg_music("/res/media/yue.mp3", -1, 0)
    scene.root_entity:pod_anim()
                     :start()
end

app.on_target_lost = function()
    app:pause_bg_music()
end

app.on_target_found = function()
    app:resume_bg_music()
end