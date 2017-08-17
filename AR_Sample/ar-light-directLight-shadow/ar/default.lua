app_controller = ae.ARApplicationController:shared_instance()
app_controller:require('./scripts/include.lua')

app = AR:create_application(AppType.ImageTrack, "rotate anim")
app:load_scene_from_json("res/simple_scene.json","demo_scene")
scene = app:get_current_scene()


app.on_loading_finish = function()
    ARLOG("onApplicationDidLoad")
end