--缩放动画测试

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
    anim = scene.bantouPhoto:scale_from_to()
                            :from(Vector3(0.1, 0.1, 0.1))
                            :delay(2000)
                            :to(Vector3(15,15,15))
                            :duration(30000)
                            :start()
    ARLOG("play scale animation")

    AR:perform_after(6000, function()
        anim:pause()
        ARLOG("pause scale animation")

        AR:perform_after(6000, function()
            anim:resume()
            ARLOG("resume scale animation")

            AR:perform_after(6000, function()
                anim:stop()
                ARLOG("stop scale animation")
            end)
        end)
    end)
end
