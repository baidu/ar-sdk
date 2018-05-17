
app_controller = ae.ARApplicationController:shared_instance()
app_controller:require('./scripts/include.lua')

--创建图像跟踪
app = AR:create_application(AppType.Slam, "slam scene")
--从Json中加载场景，并激活场景scene
app:load_scene_from_json("res/simple_scene.json","scene")
scene = app:get_current_scene()


--陀螺仪
app.device:open_imu(0)


app.on_loading_finish = function()
    scene.samplePod:enable_only_rotate_vertical()
    scene.samplePod:pod_anim()
                    :anim_repeat(true)
                    :start()
end