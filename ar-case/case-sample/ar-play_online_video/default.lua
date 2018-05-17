app_controller = ae.ARApplicationController:shared_instance()
app_controller:require('./scripts/include.lua')
app = AR:create_application(AppType.ImageTrack, "video")
app:load_scene_from_json("res/simple_restore_scene.json","video_scene")
scene = app:get_current_scene()
local video_id
local clickNUM=0
app.on_loading_finish = function()
      play()
    scene.again.on_click=function()
      play()
      scene.again:set_visible(false)  
      scene.againText:set_visible(false) 
      scene.linkText:set_visible(false) 
      scene.link:set_visible(false)
      scene.all:set_visible(false)
    end
    scene.link.on_click=function()
      app:open_url('http://ar.baidu.com/m')
    end

    
end
app.on_target_found = function()
    video_id:resume()
end


Video.call_back = function(data)

      ARLOG('=====progress=====')
      play_status = data['data']['play_status']
      ARLOG("play_status:"..play_status)
      --首次进入，播放状态是准备成功时，先暂停
      if(tostring(play_status) == "1")then
          if(clickNUM==0)then
          video_id:pause()
        end
      end
      msg_id = data['data']['play_progress']
      ARLOG("progress:"..msg_id)
      progress = tonumber(msg_id)
      

    ARLOG('======video call_back=======')
    for key,value in pairs(data) do
      if key ~= "data" then
        ARLOG(key.." :"..tostring(value))
      end
    end
    for key,value in pairs(data['data']) do
      ARLOG(key.." :"..tostring(value))
    end   

    ARLOG('======video play info=======')
    video_info = video_id:get_video_play_info()
    for key,value in pairs(video_info) do
        ARLOG(key.." :"..tostring(value))
    end

    ARLOG('======video play info end=======')
    
    
end



function play()
  onProgressUpdate(0)
    video_id = scene.videoPlane1:video()
                        :path('http://ar-fm.cdn.bcebos.com/ar-website%2FARcasejinji12-21.mp4')
                        :from_time(0)
                        :repeat_count(1)
                        :is_remote(1)
                        :on_complete(function ()
                            scene.again:set_visible(true)  
                            scene.againText:set_visible(true) 
                            scene.linkText:set_visible(true) 
                            scene.link:set_visible(true)
                            scene.all:set_visible(true)
                        end)
                        :start()
end








app.on_target_lost = function()

  app:set_camera_look_at("0, 0, 1000","0, 0, 0", "0.0, 1.0, 0.0")
end

