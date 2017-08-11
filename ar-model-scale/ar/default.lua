--代码控制模型缩放


app_controller = ae.ARApplicationController:shared_instance()
app_controller:require('./scripts/include.lua')

app = AR:create_application(AppType.ImageTrack, "test_demo")
app:load_scene_from_json("res/simple_scene.json","demo_scene")
local scene = app.current_scene

app.on_loading_finish =function ()
    local scaleAction = scene.bear:scale_from_to()
                                    :from(Vector3(0.3,0.3,1))
                                    :duration(8000)
                                    :delay(20)
                                    :to(Vector3(3,3,1))
                                    :start()
     
end