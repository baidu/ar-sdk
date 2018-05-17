-- 粒子火焰效果lua配置 --
app_controller = ae.ARApplicationController:shared_instance()
app_controller:require("./scripts/include.lua")
app = AR:create_application(AppType.Imu, "ParticleSystem")
app:load_scene_from_json("res/simple_scene.json", "demo_scene")
app.device:open_imu(1)

scene = app.current_scene

local ESCROLL = 2
local ESCROLL_DOWN = 9
local ESCROLL_UP = 11

local is_scroll = 0
local is_down = 0

local vel_y = 1500
local acce_y = -1500
local particle_strectch_x = 1
local particle_strectch_y = 1

local shape_strectch_x = 1
local shape_strectch_y = 1
local shape_strectch_z = 1

local scale = 1.08

local update_id = 0

app.on_loading_finish = function()
    io.write(".........app.on_loading_finish...........")

    scene.fire.particle.emit_status = "0"
end

app.on_target_found = function()
    ARLOG("on target found")
end

app.on_target_lost = function()
    ARLOG("on target lost")
end

scene.on_touch_event = function(etype, ex, ey)
    io.write("onTouchEvent(" .. etype .. ")")

    if (etype == ESCROLL_UP) then
        io.write("ESCROLL_UP")

        if (is_down > 0.9) then
            ae.LuaUtils:call_function_after_delay(100, "end_fire")
            return
        end

        if (is_down < 0.1) then
            scene.fire.particle.emit_status = "0"
            vel_y = 1500
            acce_y = -1500
            particle_strectch_x = 1
            particle_strectch_y = 1
            shape_strectch_x = 1
            shape_strectch_y = 1
            shape_strectch_z = 1
            is_scroll = 0
            is_down = 0
            ae.LuaUtils:cancel_delay_function_call(update_id)
        end

        return
    end

    if (etype == ESCROLL_DOWN) then
        io.write("ESCROLL_DOWN")
        local pos = scene:unproject(ex, ey, 4000)
        scene.fire.particle.emitter_position = pos.x .. "," .. pos.y .. "," .. pos.z

        update_param()
        is_down = 1
        scene.fire.particle.emit_status = "1"
        return
    end

    if (etype == ESCROLL) then
        io.write("ESCROLL")

        if (is_scroll < 0.1) then
            update_param()
            is_scroll = 1
        end

        is_down = 0

        local pos = scene:unproject(ex, ey, 4000)
        scene.fire.particle.emitter_position = pos.x .. "," .. pos.y .. "," .. pos.z
        scene.fire.particle.emit_status = "1"
        return
    end
end

function update_param()
    vel_y = vel_y * scale
    acce_y = acce_y * 1.025
    particle_strectch_x = particle_strectch_x * scale
    particle_strectch_y = particle_strectch_y * scale

    shape_strectch_x = shape_strectch_x * scale
    shape_strectch_y = shape_strectch_y
    shape_strectch_z = shape_strectch_z * scale

    scene.fire.particle.particle_velocity = "0," .. vel_y .. ",0"
    scene.fire.particle.particle_stretch_scale = particle_strectch_x .. "," .. particle_strectch_y
    scene.fire.particle.particle_acceleration = "0," .. acce_y .. ",0"
    scene.fire.particle.shape_strectch_scale = shape_strectch_x .. "," .. shape_strectch_y .. "," .. shape_strectch_z

    if (shape_strectch_x < 4) then
        update_id = ae.LuaUtils:call_function_after_delay(300, "update_param")
    end
end

function end_fire()
    if (is_scroll < 0.1) then
        scene.fire.particle.emit_status = 0
        vel_y = 1500
        acce_y = -1500
        particle_strectch_x = 1
        particle_strectch_y = 1
        shape_strectch_x = 1
        shape_strectch_y = 1
        shape_strectch_z = 1
        is_scroll = 0
        is_down = 0
        ae.LuaUtils:cancel_delay_function_call(update_id)
    end
end
