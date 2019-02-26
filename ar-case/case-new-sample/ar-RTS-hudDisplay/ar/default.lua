app_controller = ae.ARApplicationController:shared_instance()
local script_vm = app_controller:get_script_vm()
script_vm:require_module("./scripts/include.lua")
local application = app_controller:add_application_with_name("my_ar_application")
application:add_scene_from_json("res/simple_scene.json","demo_scene")
application:active_scene_by_name("demo_scene")

scene = application:get_current_scene()

function on_loading_finish() 
    translate_anim()
    scale_anim()
    rotation_anim()
end
application:set_script_loading_finish_handler(on_loading_finish)

function translate_anim()

    plane_node = scene:get_node_by_name("bantouPhoto")
    rigid_controller = plane_node:get_animation_controller()
    rigid_config = {}
    rigid_config["duration"] = 10000
    rigid_config["repeat_count"] =1
    rigid_config["translate_to"] = ae.ARVec3:new_local(1,0,0)

    rigid_config["rigid_anim_type"] = "translate"
    rigid_config["interp_type"] = "bounce"

    rigid_session = rigid_controller:create_animation_session("rigid", rigid_config)
    rigid_session:play()

end


function scale_anim()
    
    plane_node = scene:get_node_by_name("bwPhoto")
    rigid_controller = plane_node:get_animation_controller()
    rigid_config = {}
    rigid_config["duration"] = 3000
    rigid_config["scale_from"] = ae.ARVec3:new_local(0.1,0.1,0.1)
    rigid_config["scale_to"] = ae.ARVec3:new_local(5,5,5)
    rigid_config["repeat_count"] =0
    rigid_config["repeat_mode"] = "reverse"

    rigid_config["rigid_anim_type"] = "scale"
    rigid_config["interp_type"] = "bounce"

    rigid_session = rigid_controller:create_animation_session("rigid", rigid_config)
    rigid_session:play()
end






function rotation_anim()
	
    plane_node = scene:get_node_by_name("colorPhoto")
    rigid_controller = plane_node:get_animation_controller()
    rigid_config = {}
    rigid_config["duration"] = 10000
    rigid_config["repeat_count"] = 1
    rigid_config["rotate_to"] = 360
    rigid_config["rotate_axis"] = ae.ARVec3:new_local(1,0,0)

    rigid_config["rigid_anim_type"] = "rotate"
    rigid_config["interp_type"] = "bounce"

    rigid_session = rigid_controller:create_animation_session("rigid", rigid_config)
    rigid_session:play()
end













