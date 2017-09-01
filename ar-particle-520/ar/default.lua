--粒子画图效果lua配置--
app_controller = ae.ARApplicationController:shared_instance()
app_controller:require("./scripts/include.lua")
app = AR:create_application(AppType.Imu, "ParticleSystem")
app:load_scene_from_json("res/simple_scene.json", "demo_scene")
app.device:open_imu(1)
scene = app.current_scene
local ESCROLL = 2
local ESCROLL_DOWN = 9
local ESCROLL_UP = 11
local positionx = 0
local positiony = 0
local positionz = 0
local isscroll = 0

app.on_loading_finish = function()
    ARLOG(".........app.on_loading_finish...........")
    scene.write1.particle.emit_status = "0"
    scene.write2.particle.emit_status = "0"
end

scene.on_touch_event = function(etype, ex, ey)
    if (etype == ESCROLL_UP) then
        scene.write1.particle.emit_status = "0"
        scene.write2.particle.emit_status = "0"
        isscroll = 0
        ARLOG("ESCROLL_UP")
        return
    end
    if (etype == ESCROLL) then
        local pos = scene:unproject(ex, ey, 200)
        calcuate_diff(pos.x, pos.y, pos.z)
        scene.write2.particle.emitter_position = pos.x .. "," .. pos.y .. "," .. pos.z
        scene.write2.particle.emit_status = "1"
        return
    end
end

function calcuate_diff(x, y, z)
    for var = 0.0, 1.0, 0.1 do
        local nowx = x - (x - positionx) * var * isscroll
        local nowy = y - (y - positiony) * var * isscroll
        local nowz = z - (z - positionz) * var * isscroll
        scene.write1.particle.emit_status = "1"
        scene.write1.particle.emitter_position = nowx .. "," .. nowy .. "," .. nowz
        scene.write1.particle.emit_particle = "1"
    end
    positionx = x
    positiony = y
    positionz = z
    isscroll = 1
end
