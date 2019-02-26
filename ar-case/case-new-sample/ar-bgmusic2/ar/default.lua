app_controller = ae.ARApplicationController:shared_instance()
local script_vm = app_controller:get_script_vm()
script_vm:require_module("./scripts/include.lua")


app = AR:create_application(AppType.ImageTrack, "rotate anim")
app:load_scene_from_json("res/simple_scene.json","demo_scene")
scene = app:get_current_scene()

local root_node=scene.root
local player = ae.ARMusicPlayer:get_instance()

app.on_loading_finish = function()
    
    local config = {}
    config["repeat_count"] = 0
    player:play_music("/res/media/testcase.mp3", config)
                              
end 
app.on_target_lost = function()
    player:pause()
end

app.on_target_found = function()
    player:resume()
end

