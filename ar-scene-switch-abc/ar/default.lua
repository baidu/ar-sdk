-- 复杂场景景切换播放测试
-- author: limin20@baidu.com


app_controller = ae.ARApplicationController:shared_instance()
app_controller:require('./scripts/include.lua')

--创建图像跟踪
app = AR:create_application(AppType.ImageTrack, "switch scene")
--从Json中加载场景，并激活场景scene_a
app:load_scene_from_json("res/simple_scene.json","scene_a")
scene = app:get_current_scene()
--加载场景scene_b
app:add_scene_from_json("res/simple_scene_b.json", "scene_b")
--加载场景scene_c
app:add_scene_from_json("res/simple_scene_c.json", "scene_c")

local firstFound = true
app:set_gl_cull_face(true)



app.on_loading_finish = function()
    audio = scene.simplePod:audio()
                            :path('/res/media/bg.mp3')
                            :repeat_count(-1)
                            :delay(0)
                            :start()
    anim = scene.simplePod:pod_anim()
                            :speed(1)
                            :anim_repeat(true)
                            :start()
end

app.on_target_lost = function()
    ARLOG("tracking loss..")
    switchSceneB()
end

app.on_target_found = function()
    ARLOG("tracking found..")
    local root_node = scene:get_root_node()
    root_node:set_rotation_by_xyz(0.0, 0.0, 0.0)
    if (firstFound == false) then
        switchSceneC()
    end
    firstFound = false
end

function switchSceneC()
    app:switch_to_scene_with_name("scene_c")
    scene.SceneCButton.on_click = function()
        switchSceneB()
    end
end

function switchSceneB()
    app:switch_to_scene_with_name("scene_b")
    scene.SceneBButton.on_click = function()
        switchSceneC()
    end
end
