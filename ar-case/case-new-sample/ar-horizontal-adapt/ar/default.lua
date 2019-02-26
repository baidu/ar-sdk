app_controller = ae.ARApplicationController:shared_instance()
local script_vm = app_controller:get_script_vm()
script_vm:require_module("./scripts/include.lua")

local application = app_controller:add_application_with_name("my_ar_application")
application:add_scene_from_json("res/simple_scene.json","demo_scene")
application:active_scene_by_name("demo_scene")

scene = application:get_current_scene()
node = scene:get_node_by_name("backgroundpic")


local angle = 1.57
local axis1 = ae.ARVec3:new_local(1, 0, 0)
local axis2 = ae.ARVec3:new_local(0, -1, 0)
local axis3 = ae.ARVec3:new_local(0, 1, 0)
local quat = ae.ARQuat:new_local(axis1, angle)
local quat2 = ae.ARQuat:new_local(axis2, angle)
local quat3 = ae.ARQuat:new_local(axis3, angle)
local quat_left = quat*quat2
local quat_right = quat*quat3

function on_loading_finish()
    local orientation = application:get_property_string("device_orientation")
    application:add_observer_for_property("device_orientation",on_observer)
end 
application:set_script_loading_finish_handler(on_loading_finish)

function on_observer(key, old_value, new_value)
     ARLOG(key.."changed from("..old_value..")to new value("..new_value..")")

    if new_value == "landscape_left" then
          node:set_property_quat("rotation_quat", quat_left)
     elseif new_value == "landscape_right" then
     	  node:set_property_quat("rotation_quat", quat_right)
     elseif new_value == "portrait" then
     	  node:set_property_quat("rotation_quat", quat)
     end

end

