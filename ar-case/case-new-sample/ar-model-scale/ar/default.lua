app_controller = ae.ARApplicationController:shared_instance()
local script_vm = app_controller:get_script_vm()
script_vm:require_module("./scripts/include.lua")

local application = app_controller:add_application_with_name("my_ar_application")
application:add_scene_from_json("res/simple_scene.json","demo_scene")
application:active_scene_by_name("demo_scene")

scene = application:get_current_scene()
--application:open_imu_service(1,1)

function on_loading_finish() 
	pod_node = scene:get_node_by_name("samplePod")
	anim_controller = pod_node:get_animation_controller()
	local config = {}
	config["rigid_anim_type"] = "scale"
	config["duration"] = 8000 
	config["delay"] = 2000
	config["scale_to"] = ae.ARVec3:new_local(3,3,1)

	local model_anim_session = anim_controller:create_animation_session("rigid", config)
	model_anim_session:play()
end
application:set_script_loading_finish_handler(on_loading_finish)
