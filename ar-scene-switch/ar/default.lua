-- 2个场景切换播放测试
-- author: chenming03@baidu.com


app_controller = ae.ARApplicationController:shared_instance()
app_controller:require('./scripts/include.lua')



--创建图像跟踪
app = AR:create_application(AppType.ImageTrack, "switch scene")
--从Json中加载场景，并激活场景scene1
app:load_scene_from_json("res/simple_scene.json","demo_scene1")
scene = app:get_current_scene()
--加载场景scene2
app:add_scene_from_json("res/simple_scene2.json", "demo_scene2")


app.on_loading_finish = function()
    scene.ResumeButton.on_click = function()
        switchScene2()
    end
end

function switchScene2()
    app:switch_to_scene_with_name("demo_scene2")
    scene.Scene2Button.on_click = function()
        switchScene1()
    end
end

function switchScene1()
    app:switch_to_scene_with_name("demo_scene1")
    scene.ResumeButton.on_click = function()
        switchScene1()
    end
end
