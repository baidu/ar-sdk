-- 燃烧的树lua配置文件 --
app_controller = ae.ARApplicationController:shared_instance()
app_controller:require("./scripts/include.lua")

app = AR:create_application(AppType.Imu, "ParticleSystem")
app:load_scene_from_json("res/simple_scene.json", "demo_scene")
app.device:open_imu(1)

app.on_loading_finish = function()
    ARLOG(".........app.on_loading_finish...........")
    scene.fire.particle.emit_status = "1"
end
