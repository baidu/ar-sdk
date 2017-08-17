-- 视频播放测试


app_controller = ae.ARApplicationController:shared_instance()
app_controller:require('./scripts/include.lua')

--创建图像跟踪
app = AR:create_application(AppType.ImageTrack, "audio scene")
--从Json中加载场景，并激活场景scene
app:load_scene_from_json("res/simple_scene.json","scene")
scene = app:get_current_scene()

local video_plane_node = scene:get_node_by_name("videoPlane")

local video




app.on_loading_finish = function()
    video = scene.videoPlane:video()
                            :path('/res/media/content.mp4')
                            :repeat_count(-1)
                            :start()

    AR:perform_after(6000, pauseVideo)
end


function pauseVideo()
    video:pause()
--    video_plane_node:pause_action(video)
--    ARLOG("pause video id:" .. video)
    AR:perform_after(6000, resumeVideo)
end

function resumeVideo()
--    ARLOG("resume video id:" .. video)
    video:resume()
--    video_plane_node:resume_action(video)
    AR:perform_after(6000, stopVideo)
end

function stopVideo()
--    ARLOG("stop video id:" .. video)
--    video_plane_node:stop_action(video)
    video:stop()
    --AR:perform_after(3000, onStart)
end
