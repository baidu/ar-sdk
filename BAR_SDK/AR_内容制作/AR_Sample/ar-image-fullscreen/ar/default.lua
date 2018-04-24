--图片全屏
app_controller = ae.ARApplicationController:shared_instance()
app_controller:require('./scripts/include.lua')

app = AR:create_application(AppType.ImageTrack, "test_demo")
app:load_scene_from_json("res/simple_scene.json","demo_scene")
local scene = app.current_scene
--配置NODE
app.on_loading_finish = function()
    scene.backgroundpic.on_click = function ()
        onShareButtonClick()
    end
end

function onShareButtonClick()
    app:open_url("https://www.baidu.com/", 0)
end