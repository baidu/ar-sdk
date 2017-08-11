app_controller = ae.ARApplicationController:shared_instance()
app_controller:require('./scripts/include.lua')


--创建图像跟踪
app = AR:create_application(AppType.ImageTrack, "open url")
--从Json中加载场景，并激活场景
app:load_scene_from_json("res/simple_scene.json","demo_scene")
scene = app:get_current_scene()

app.on_loading_finish = function()
    scene.button1.on_click = function()
        app:open_url("https://www.baidu.com/")
    end
end