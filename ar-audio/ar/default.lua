--音频播放

app_controller = ae.ARApplicationController:shared_instance()
app_controller:require('./scripts/include.lua')

app = AR:create_application(AppType.ImageTrack, "demo")
app:load_scene_from_json("res/simple_scene.json","demo_scene")
scene = app:get_current_scene()

app.on_loading_finish = function()
    audio = scene.ResumeButton:audio()
                              :path("/res/media/testcase.mp3")
                              :repeat_count(-1)
                              :start()

    AR:perform_after(6000, function()
        audio:pause()
        AR:perform_after(6000, function()
            audio:resume()
            AR:perform_after(6000, function()
                audio:stop()
            end)
        end)
    end)

end

