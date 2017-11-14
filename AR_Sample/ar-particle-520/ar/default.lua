app_controller = ae.ARApplicationController:shared_instance()
-- 不要修改模块引入的顺序 --
app_controller:require('./scripts/utils.lua')
app_controller:require('./scripts/const.lua')
app_controller:require('./scripts/device.lua')
app_controller:require('./scripts/bridge.lua')
app_controller:require('./scripts/ar.lua')
app_controller:require('./scripts/scene.lua')
app_controller:require('./scripts/application.lua')
app_controller:require('./scripts/node.lua')
app_controller:require('./scripts/particle_system.lua')



app = AR:create_application(AppType.Imu, "ParticleSystem")
app:load_scene_from_json("res/simple_scene.json","demo_scene")

app.device:open_imu(0)

scene = app:get_current_scene()

local ESCROLL = 2
local ESCROLL_DOWN = 9
local ESCROLL_UP = 11


app.on_loading_finish = function()
    io.write(".........app.on_loading_finish...........")

    scene.yinhua2.particle.emit_status = "0"
    scene.yinhua3.particle.emit_status = "0"
end

app.on_target_found = function()
ARLOG('on target found')
end

app.on_target_lost = function()
ARLOG('on target lost')
end


scene.on_touch_event = function(etype, ex, ey)


    if (etype == ESCROLL_UP) then
        scene.yinhua2.particle.emit_status = "0"
        scene.yinhua3.particle.emit_status = "0"
        return;
    end


    if (etype == ESCROLL) then
        local pos = scene:unproject(ex, ey, 1500)

        scene.yinhua2.particle.emitter_position = pos.x..","..pos.y..","..pos.z
        scene.yinhua2.particle.emit_status = "1"

        scene.yinhua3.particle.emitter_position = pos.x..","..pos.y..","..pos.z
        scene.yinhua3.particle.emit_status = "1"

        return;
    end

    if (etype == ESCROLL_DOWN) then
        local pos = scene:unproject(ex, ey, 1500)

        scene.yinhua2.particle.emitter_position = pos.x..","..pos.y..","..pos.z
        scene.yinhua2.particle.emit_status = "1"

        scene.yinhua3.particle.emitter_position = pos.x..","..pos.y..","..pos.z
        scene.yinhua3.particle.emit_status = "1"

        return;
    end

end
