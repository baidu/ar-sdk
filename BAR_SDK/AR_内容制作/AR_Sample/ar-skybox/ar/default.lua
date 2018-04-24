app_controller = ae.ARApplicationController:shared_instance()
app_controller:require('./scripts/include.lua')

app = AR:create_application(AppType.ImageTrack, "test_demo")
app:load_scene_from_json("res/skybox_scene.json","demo_scene")

local scene = app.current_scene

app.on_loading_finish = function()
    app.device:open_imu(1)
end