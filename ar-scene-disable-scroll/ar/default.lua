--disable-scroll:单指平移

app_controller = ae.ARApplicationController:shared_instance()
app_controller:require('./scripts/include.lua')

--创建图像跟踪
app = AR:create_application(AppType.ImageTrack, "size scene")
--从Json中加载场景，并激活场景
app:load_scene_from_json("res/simple_scene.json","demo_scene")
scene = app:get_current_scene()

app.on_loading_finish = function()
end

app.on_target_lost = function()
end

app.on_target_found = function()
    ARLOG("hello")
end
