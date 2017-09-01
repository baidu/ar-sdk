-- 粒子合集效果lua配置 --
app_controller = ae.ARApplicationController:shared_instance()
app_controller:require("./scripts/include.lua")
app = AR:create_application(AppType.Imu, "ParticleSystem")
app:load_scene_from_json("res/simple_scene.json", "demo_scene")
app.device:open_imu(1)
app:set_gl_cull_face(true)
local current_scene = app.current_scene
app.on_loading_finish = function()
    current_scene.root:audio():path("res/media/monolophosaurus_shout.mp3"):repeat_count(-1):start()
    current_scene.sky:pod_anim():anim_repeat(true):start()
    current_scene.walk_Node:pod_anim():anim_repeat(true):start()
    current_scene.volcano_Node:pod_anim():anim_repeat(false):start()
    setBirdEyeView()
    -- body
end
function setBirdEyeView()
    application:set_active_scene_camera_look_at("0.0, 0.0, 0.0", "0, 100, 0", "0, 2.0, 1.0")
end
