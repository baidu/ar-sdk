app_controller = ae.ARApplicationController:shared_instance()
local script_vm = app_controller:get_script_vm()
script_vm:require_module("./scripts/include.lua")

local application = app_controller:add_application_with_name("my_ar_application")
application:add_scene_from_json("res/simple_scene.json","demo_scene")
application:active_scene_by_name("demo_scene")

scene = application:get_current_scene()
--local bear = scene:get_node_by_name("bear")
local media_node = scene:get_node_by_name("sakuraPlane")
function on_loading_finish() 
    local media_controller = media_node:get_media_controller()
    local config = {}
    config = {}
    config["repeat_count"] = 0
    ARLOG('frame1:默认配置')

    media_session = media_controller:create_media_session("image_sequence", "ll ", config)
    media_session:play()
end
application:set_script_loading_finish_handler(on_loading_finish)

