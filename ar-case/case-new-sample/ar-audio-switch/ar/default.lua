app_controller = ae.ARApplicationController:shared_instance()
local script_vm = app_controller:get_script_vm()
script_vm:require_module("./scripts/include.lua")
local application = app_controller:add_application_with_name("my_ar_application")
application:add_scene_from_json("res/simple_scene.json","demo_scene")
application:active_scene_by_name("demo_scene")

scene = application:get_current_scene()
--application:open_imu_service(1,1)

function on_loading_finish() 
    
    local player = ae.ARMusicPlayer:get_instance()
    local config = {}
    config["repeat_count"] = 0
    player:play_music("/res/media/bg_music.mp3", config)
    
    setNormal()
    scene.btn_zhixian_bg:set_visible(true)
    scene.btn_zhixian_normal:set_visible(false)
    scene.btn_zhixian_selected:set_visible(true)
    zhi_music()  
    
    scene.btn_zhixian_normal.on_click = function ()
        setNormal()
        scene.btn_zhixian_bg:set_visible(true)
        scene.btn_zhixian_normal:set_visible(false)
        scene.btn_zhixian_selected:set_visible(true)
        zhi_music()
    end
    scene.btn_huanxing_normal.on_click = function ()
        setNormal()
        scene.btn_huanxing_bg:set_visible(true)
        scene.btn_huanxing_normal:set_visible(false)
        scene.btn_huanxing_selected:set_visible(true)
        huan_music()
    end
    scene.btn_luoxian_normal.on_click = function ()
        setNormal()
        scene.btn_luoxian_bg:set_visible(true)
        scene.btn_luoxian_normal:set_visible(false)
        scene.btn_luoxian_selected:set_visible(true)
        luo_music()
    end                                      

end
application:set_script_loading_finish_handler(on_loading_finish)



function setNormal()
    scene.btn_zhixian_bg:set_visible(false)
    scene.btn_zhixian_normal:set_visible(true)
    scene.btn_zhixian_selected:set_visible(false)
    scene.btn_huanxing_bg:set_visible(false)
    scene.btn_huanxing_normal:set_visible(true)
    scene.btn_huanxing_selected:set_visible(false)
    scene.btn_luoxian_bg:set_visible(false)
    scene.btn_luoxian_normal:set_visible(true)
    scene.btn_luoxian_selected:set_visible(false)
end  
function zhi_music()
    rigid_controller = root_node:get_media_controller()
    rigid_config = {}
    rigid_config["repeat_count"] =1
    rigid_config["forward_conflict_solving_strategy"] = "force_cancel_forward"
    rigid_config["backward_conflict_solving_strategy"] = "cancel_backward"

    rigid_session = rigid_controller:create_media_session("audio","/res/media/test1.mp3", rigid_config)
    rigid_session:play()
end

function huan_music()
    rigid_controller = root_node:get_media_controller()
    rigid_config = {}
    rigid_config["repeat_count"] =1
    rigid_config["forward_conflict_solving_strategy"] = "force_cancel_forward"
    rigid_config["backward_conflict_solving_strategy"] = "cancel_backward"

    rigid_session = rigid_controller:create_media_session("audio","/res/media/test2.mp3", rigid_config)
    rigid_session:play()
end

function luo_music()
    rigid_controller = root_node:get_media_controller()
    rigid_config = {}
    rigid_config["repeat_count"] =1
    rigid_config["forward_conflict_solving_strategy"] = "force_cancel_forward"
    rigid_config["backward_conflict_solving_strategy"] = "cancel_backward"

    rigid_session = rigid_controller:create_media_session("audio","/res/media/test3.mp3", rigid_config)
    rigid_session:play()
end








