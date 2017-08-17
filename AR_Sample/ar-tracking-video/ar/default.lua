-- 视频播放测试


app_controller = ae.ARApplicationController:shared_instance()
app_controller:require('./scripts/include.lua')

--创建图像跟踪
app = AR:create_application(AppType.ImageTrack, "video scene")
--从Json中加载场景，并激活场景scene
app:load_scene_from_json("res/simple_scene.json","scene")
scene = app:get_current_scene()

local firstFound = true
local video

app.on_loading_finish = function()
end

app.on_target_found = function()
    ARLOG("tracking found..")
    ARLOG(string.format("firstFound :%s", tostring(firstFound)))
    if (firstFound == false) then
        resumeVideo()
    else
        playVideo()
    end
    firstFound = false
end

app.on_target_lost = function()
    ARLOG("tracking loss..")
    ARLOG(string.format("firstFound :%s", tostring(firstFound)))
    pauseVideo()
end

function playVideo()
    video = scene.videoPlane:video()
                            :path("/res/media/content.mp4")
                            :repeat_count(-1)
                            :start()

end

function pauseVideo()
    video:pause()
--    ARLOG("pause video id:" .. playVideoId)
end

function resumeVideo()
--    ARLOG("resume video id:" .. playVideoId)
    video:resume()
end

function stopVideo()
--    ARLOG("stop video id:" .. playVideoId)
    video:stop()
end
