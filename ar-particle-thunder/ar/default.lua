-- 粒子雷电效果lua配置 --
app_controller = ae.ARApplicationController:shared_instance()
app_controller:require('./scripts/include.lua')
app = AR:create_application(AppType.ImageTrack, "ParticleSystem")
app:load_scene_from_json("res/simple_scene.json","demo_scene")
app:set_gl_cull_face(true)
app.device:open_imu(0)

scene = app.current_scene

local _unproject_position
local _id_audio = -1
local _particle_emitter
local _particle_emitter_earth
local _root_node = scene.root

app.on_loading_finish = function()
    setBirdEyeView()
    scene.thunder_particle.particle.emit_status = 0
    app:play_bg_music("/res/media/rain.mp3", -1)
end
local ESCROLL = 2
local ESCROLL_DOWN = 9
local ESCROLL_UP = 11

scene.on_touch_event = function(etype, ex, ey)
    if (etype == ESCROLL_UP) then
        scene.thunder_particle.particle.emit_status = 0
        return;
    end
    if (etype == ESCROLL_DOWN or etype == ESCROLL) then
        _unproject_position = scene:unproject(ex, ey, 1000)
        scene.thunder_particle.particle.emitter_position =
        _unproject_position.x..",".._unproject_position.y..",".._unproject_position.z
        scene.thunder_particle.particle.emit_status = 1
        if(_id_audio~=-1)then
        _id_audio:stop()
        end
        _id_audio = _root_node:audio():path("/res/media/thunder1.mp3"):delay(0):repeat_count(1):start()
        return;
    end
end
function setBirdEyeView()
    app:set_active_scene_camera_look_at("0.0, 0.0, 500","0, 0, 0", "0, 0, -1")
end
