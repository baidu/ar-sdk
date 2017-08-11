--动画平移repeat

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
    anim = scene.bantouPhoto:move_by()
                            :to(Vector3(0, -1000, 0))
                            :delay(2000)
                            :duration(5000)
                            :repeat_count(1000)
                            :repeat_mode(1)
                            :start()

end
