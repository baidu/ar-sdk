--背景音乐repeat

app_controller = ae.ARApplicationController:shared_instance()
app_controller:require('./scripts/include.lua')

app = AR:create_application(AppType.ImageTrack, "demo")
app:load_scene_from_json("res/simple_scene.json","demo_scene")
scene = app:get_current_scene()

app.on_loading_finish = function()
    app:play_bg_music("/res/media/testcase.mp3", 3, 0)
end

