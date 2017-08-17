--iMU随屏初始化


app_controller = ae.ARApplicationController:shared_instance()
app_controller:require('./scripts/include.lua')

app = AR:create_application(AppType.ImageTrack, "test_demo")
app:load_scene_from_json("res/simple_scene.json","demo_scene")

local scene = app.current_scene

app.on_loading_finish = function()
    app.device:open_imu(1)
    scene.root:play_pod_animation_all(1.0, true)
end