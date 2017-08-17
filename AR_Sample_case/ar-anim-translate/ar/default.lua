--动画平移延迟

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
                            :to(Vector3(0, -2000, 0))
                            :delay(2000)
                            :duration(30000)
                            :start()
    AR:perform_after(6000, function()
        anim:pause()

        AR:perform_after(6000, function()
            anim:resume()

            AR:perform_after(6000, function()
                anim:stop()
            end)
        end)
    end)
end
