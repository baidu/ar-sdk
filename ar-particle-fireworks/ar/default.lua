-- 粒子烟花效果lua配置文件 --
app_controller = ae.ARApplicationController:shared_instance()
app_controller:require("./scripts/include.lua")
app = AR:create_application(AppType.Imu, "ParticleSystem")
app:load_scene_from_json("res/simple_scene.json", "demo_scene")
app.device:open_imu(1)
local current_scene = app.current_scene
app.on_loading_finish = function()
    setBirdEyeView()
    -- body
end
function setBirdEyeView()
    application:set_active_scene_camera_look_at("0.0, 0.0, 0.0", "0, 100, 0", "0, 2.0, 1.0")
end
