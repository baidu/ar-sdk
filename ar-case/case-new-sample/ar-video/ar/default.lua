app_controller = ae.ARApplicationController:shared_instance()
local script_vm = app_controller:get_script_vm()
script_vm:require_module("./scripts/include.lua")
local application = app_controller:add_application_with_name("my_ar_application")
application:add_scene_from_json("res/simple_scene.json","demo_scene")
application:active_scene_by_name("demo_scene")

scene = application:get_current_scene()
--application:open_imu_service(1,1)

function on_loading_finish() 
    audio()
end
application:set_script_loading_finish_handler(on_loading_finish)

function audio()
    video_node = scene:get_node_by_name("videoPlane")
    rigid_controller = video_node:get_media_controller()
    rigid_config = {}
    rigid_config["repeat_count"] =0
    --rigid_config["delay"] = 5000

    rigid_session = rigid_controller:create_media_session("video","/res/media/content.mp4", rigid_config)
    rigid_session:play()
    AR:perform_after(6000, function()
        rigid_session:pause()

        AR:perform_after(6000, function()
            rigid_session:play()

            AR:perform_after(6000, function()
                rigid_session:stop()
            end)
        end)
    end)
end


