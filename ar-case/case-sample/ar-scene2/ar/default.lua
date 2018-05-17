--ar-离开触发物居中显示

app_controller = ae.ARApplicationController:shared_instance()
app_controller:require('./scripts/include.lua')


--创建图像跟踪
app = AR:create_application(AppType.ImageTrack, "rotate anim")
--从Json中加载场景，并激活场景
app:load_scene_from_json("res/simple_scene.json","demo_scene")
scene = app:get_current_scene()

app.on_loading_finish = function()
    scene.button1:rotate_by()
                :to_degree(360)
                :axis_xyz(Vector3(0,1,1))
                :delay(0)
                :duration(1000)
                :repeat_count(100)
                :start()
end

app.on_target_lost = function()
    setBirdEyeView()
end

--旧接口
function setBirdEyeView()
    app:set_camera_look_at("0.0, 0.0, 800.0", "0, 0, 0", "0, 2.0, 1.0")
end
