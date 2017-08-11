--[[audio
--加载完播放
--lost 暂停
--found 第一次不操作，第二次 恢复
--]]

app_controller = ae.ARApplicationController:shared_instance()
app_controller:require('./scripts/include.lua')

--创建图像跟踪
app = AR:create_application(AppType.ImageTrack, "audio scene")
--从Json中加载场景，并激活场景scene
app:load_scene_from_json("res/simple_scene.json","scene")
scene = app:get_current_scene()

local firstFound = true
local audio

app.on_loading_finish = function()
    ARLOG("play music..")
    anim = scene.simplePod:pod_anim()
                            :speed(1)
                            :anim_repeat(true)
                            :start()

    audio = scene.simplePod:audio()
                            :path('/res/media/bg.mp3')
                            :repeat_count(-1)
                            :delay(0)
                            :start()

    ARLOG("play audio id:" .. audio)

end

app.on_target_found = function()
    ARLOG("tracking found..")
    scene.simplePod:set_rotation_by_xyz(0.0, 0.0, 0.0)
    ARLOG(string.format("firstFound :%s", tostring(firstFound)))
    if (firstFound == false) then
        ARLOG("resumeAudio found..")
        audio:resume()
    end
    firstFound = false
end


app.on_target_lost = function()
    ARLOG("tracking loss..")
    ARLOG(string.format("firstFound :%s", tostring(firstFound)))
    audio:pause()
    --pauseAudio()
end
