app_controller = ae.ARApplicationController:shared_instance()
local script_vm = app_controller:get_script_vm()
script_vm:require_module("./scripts/include.lua")

local application = app_controller:add_application_with_name("my_ar_application")
application:add_scene_from_json("res/simple_scene.json","demo_scene")
application:active_scene_by_name("demo_scene")

scene = application:get_current_scene()

function on_loading_finish()
    local orientation = application:get_property_string("device_orientation")
    application:add_observer_for_property("device_orientation",on_observer)

end 
application:set_script_loading_finish_handler(on_loading_finish)

function on_observer(key, old_value, new_value)
     ARLOG(key.."changed from("..old_value..")to new value("..new_value..")")
end

