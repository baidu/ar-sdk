--旋转动画测试

app_controller = ae.ARApplicationController:shared_instance()
app_controller:require('./scripts/include.lua')

app = AR:create_application(AppType.ImageTrack, "rotate anim")
app:load_scene_from_json("res/simple_scene.json","demo_scene")
scene = app:get_current_scene()

app.on_loading_finish = function()
    ARLOG("onApplicationDidLoad")
    playAnim()
end

function playAnim()
    anim = scene.bantouPhoto:rotate_by()
                     :to_degree(360)
                     :axis_xyz(Vector3(1, 0, 0))
                     :duration(1000)
                     :repeat_count(100)
                     :start()

    ARLOG("play rotate animation")

    AR:perform_after(6000, function()
        anim:pause()
        ARLOG("pause rotate animation")

        AR:perform_after(6000, function()
            anim:resume()
            ARLOG("resume rotate animation")

            AR:perform_after(6000, function()
                anim:stop()
                ARLOG("stop rotate animation")
            end)
        end)
    end)
end
