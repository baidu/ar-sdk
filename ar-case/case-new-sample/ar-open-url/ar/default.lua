app_controller = ae.ARApplicationController:shared_instance()
local script_vm = app_controller:get_script_vm()
script_vm:require_module("./scripts/include.lua")
local application = app_controller:add_application_with_name("my_ar_application")
application:add_scene_from_json("res/simple_scene.json","demo_scene")
application:active_scene_by_name("demo_scene")

scene = application:get_current_scene()
--application:open_imu_service(1,1)

function on_loading_finish() 

end
application:set_script_loading_finish_handler(on_loading_finish)
  
function get_application_property()
	application:open_url("https://www.baidu.com/",0)
end

local application_property = scene:get_node_by_name("button1")
application_property:set_interaction_event_handler("click", get_application_property)  
