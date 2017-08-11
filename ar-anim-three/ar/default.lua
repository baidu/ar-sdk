--旋转平移动画

app_controller = ae.ARApplicationController:shared_instance()
app_controller:require('./scripts/include.lua')

app = AR:create_application(AppType.ImageTrack, "demo anim")
app:load_scene_from_json("res/simple_scene.json","demo_scene")
scene = app:get_current_scene()

app.on_loading_finish = function()
    ARLOG("onApplicationDidLoad")
    playAnim()
end

function playAnim()
    s = scene.bantouPhoto:scale_from_to()
                            :from(Vector3(0.1, 0.1, 0.1))
                            :delay(2000)
                            :to(Vector3(15,15,15))
                            :duration(30000)

    t = scene.bantouPhoto:move_by()
                         :to(Vector3(0, -2000, 0))
                         :delay(2000)
                         :duration(30000)

    r = scene.bantouPhoto:rotate_by()
                         :to_degree(360)
                         :axis_xyz(Vector3(1, 0, 0))
                         :delay(2000)
                         :duration(1000)
                         :repeat_count(100)

    s:start()
    r:start()
    t:start()
end
