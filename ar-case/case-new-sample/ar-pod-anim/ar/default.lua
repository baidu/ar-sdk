app_controller = ae.ARApplicationController:shared_instance()
local script_vm = app_controller:get_script_vm()
script_vm:require_module("./scripts/include.lua")
local application = app_controller:add_application_with_name("my_ar_application")
application:add_scene_from_json("res/simple_scene.json","demo_scene")
application:active_scene_by_name("demo_scene")

scene = application:get_current_scene()

function on_loading_finish() 
	pod_anim_test()
end
application:set_script_loading_finish_handler(on_loading_finish)

function pod_anim_test()
	pod_node = scene:get_node_by_name("bear")
	anim_controller = pod_node:get_animation_controller()
	local config = {}
	config["repeat_count"] = 0
	local model_anim_session = anim_controller:create_animation_session("model", config)
	model_anim_session:play()

	AR:perform_after(6000, function ()

		model_anim_session:pause()
	end)

	AR:perform_after(12000, function ()
		model_anim_session:play()
	end)

	AR:perform_after(18000, function ()
		model_anim_session:stop()
	end)
end










