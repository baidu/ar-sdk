app_controller = ae.ARApplicationController:shared_instance()
app_controller:require('./scripts/include.lua')
app = AR:create_application(AppType.Slam, "cat")
app:load_scene_from_json("res/simple_scene.json","demo_scene")
lua_handler = app:get_lua_handler()
scene = app:get_current_scene()
update = 0
touch = 0
show_gesture_guide_move = false
show_gesture_guide_rotate = false
show_gesture_guide_singlemove = false

-- ae.SharedPreference:set_value(1, "name", "nick") 
-- local name = ae.SharedPreference:get_value(1, "name")
-- io.write("sy test  "..name)
app.on_loading_finish = function()


  -- 开启离屏引导
  scene:set_show_offscreen_guidance(true)
  click_Go()

end


function click_Go()


  scene.cat1before:set_visible(true)
  scene.click_Open_Book:set_visible(true)
  scene.click_OpenUrl:set_visible(true)
  scene.show_TextCard:set_visible(true)


  music1_1 = scene.cat1before:audio()
                             :path('res/media/cat_introduce.mp3')
                             :repeat_count(1)
                             :on_complete(function ()

                                    scene.click_Open_Book:set_visible(false)   
                                    scene.click_Close_Book:set_visible(true) 
                                    scene.show_TextCard:set_visible(false)

                             end)
                             :start()

   ae.LuaUtils:call_function_after_delay(200, "showlightmove")
    ae.LuaUtils:call_function_after_delay(3200, "cancellightmove")
    ae.LuaUtils:call_function_after_delay(6200, "showlight")
    ae.LuaUtils:call_function_after_delay(9200, "cancelguiderotate")
    ae.LuaUtils:call_function_after_delay(12200, "showsingleclick")
    ae.LuaUtils:call_function_after_delay(15200, "cancelguidemove")

  cat1before = scene.cat1before:pod_anim()
        :repeat_count(-1)

        :on_complete(function ()

        end)
        :start()


  scene.click_Open_Book.on_click = function()
       scene.click_Open_Book:set_visible(false)   
       scene.click_Close_Book:set_visible(true) 
       scene.show_TextCard:set_visible(false)
       music1_1:stop()  

  end

  scene.click_Close_Book.on_click = function()
       scene.click_Close_Book:set_visible(false)   
       scene.click_Open_Book:set_visible(true) 
       scene.show_TextCard:set_visible(true)
       music1_1:start()  

  end


--打开网页
  scene.click_OpenUrl.on_click = function()

     ARLOG("打开网页")
      app:open_url("https://voice.baidu.com/Graph/arcase")

  end




--点击之后

  scene.cat1before.on_click = function()
     touch = 1
     scene.cat1before:set_visible(false)
     cat1before:stop()
     scene.cat1after:set_visible(true)
     scene.BLN_Light:set_visible(false)
     cat1after = scene.cat1after:pod_anim()
                                :repeat_count(1)
                                :on_complete(function ()
                                    scene.cat1after:set_visible(false)
                                    scene.cat1before:set_visible(true)
                                    cat1before:start()
                                end)
                                :start()


      music2 = scene.cat1after:audio()
                             :path('res/media/cat_shout.mp3')
                             :repeat_count(2)
                             :start()  

  end



end


function cancelguidemove()
  show_gesture_guide_move = false
  scene.guide_video_single_click:set_visible(false)
end

function cancelguiderotate()
  show_gesture_guide_rotate = false
  scene.guide_video_twofinger_scroll:set_visible(false)
end



function showlight()
   ARLOG("show rotate guide")
  show_gesture_guide_rotate = true
  scene.guide_video_twofinger_scroll:set_visible(true)
  scene.guide_video_twofinger_scroll:video()
                                :path('res/media/video_twofinger_scroll.mp4')
                                :start()


end

function showlightmove()


  show_gesture_guide_singlemove = true
  scene.guide_video_onefinger_scroll:set_visible(true)
  scene.guide_video_onefinger_scroll:video()
                                :path('res/media/video_onefinger_scroll.mp4')
                                :start()

end

function cancellightmove()

     show_gesture_guide_rotate = false
      scene.guide_video_onefinger_scroll:set_visible(false)

end

function showsingleclick()


  show_gesture_guide_move = true
  scene.guide_video_single_click:set_visible(true)
  scene.guide_video_single_click:video()
                                :path('res/media/video_single_click.mp4')
                                :start()

end


function cancelguidemove()
  show_gesture_guide_move = false
  scene.guide_video_single_click:set_visible(false)
end


local show_offscreen_button = false
local has_dismis_guide = false
local has_show_arrow = false
local has_show_slam_guide = false

scene.reset.on_click = function()
    ARLOG('reset on_click')
    scene.root:reset_rts()
    reset_slam_with_face_to_camera(100)
end

function reset_slam_with_face_to_camera(delay)
    first_reset = true
    function reset_slam_face_to_camera()
        app.slam:slam_reset(0.5,0.5,1000,3)
        scene.cat_group:set_visible(true)
    end
    if (first_reset) then
        first_reset = false
        scene.cat_group:set_visible(false)
        app.slam:slam_reset(0.5,0.5,1000,3)
        AR:perform_after(delay, reset_slam_face_to_camera)
    else
        app.slam:slam_reset(0.5,0.5,1000,3)
    end
end

app.offscreen_button_show = function()
    ARLOG('offscreen_button_show')
    show_offscreen_button = true
    if ((not has_show_arrow) and (not has_show_slam_guide)) then
        has_show_arrow = true
        scene.arrow_guide:set_visible(true)
        ae.LuaUtils:call_function_after_delay(3000, "hide_arrow_guide")
    else
        scene.reset:set_visible(true)
        frame_id = scene.reset:framePicture()
            :repeat_count(-1)
            :start()
    end
end

app.offscreen_button_hide = function()
    ARLOG('offscreen_button_hide') 
    show_offscreen_button = false
    scene.reset:set_visible(false)
    scene.arrow_guide:set_visible(false)
    if (not has_dismis_guide) then
        has_dismis_guide = true
    end
end

app.slam.on_slam_direction_guide = function(switchGuide, guideDirection) 
    ARLOG('switchGuide : '.. switchGuide .. ', guideDirection : '.. guideDirection)
    if (switchGuide == 1) then
        has_show_slam_guide = true
        if (guideDirection == 1) then
            scene.guide_up:set_visible(true)
            scene.guide_down:set_visible(false)
        else
            scene.guide_up:set_visible(false)
            scene.guide_down:set_visible(true)
        end
    else
        scene.guide_up:set_visible(false)
        scene.guide_down:set_visible(false)
    end
end

function hide_arrow_guide()
    ARLOG('hide_arrow_guide')
    if (not has_dismis_guide) then 
        scene.arrow_guide:set_visible(false)
        scene.reset:set_visible(true)
                frame_id = scene.reset:framePicture()
            :repeat_count(-1)
            :start()
    end
end

scene.guide_video_single_click.on_update = function()
  if (show_gesture_guide_move) then
      local root_pos_str = scene.root:get_world_position()
      local bear_pos = Vector3(root_pos_str)
      local guide_screen_pos = scene:project(bear_pos.x, bear_pos.y, bear_pos.z)
      scene.guide_video_single_click:set_hud_position(guide_screen_pos.x, guide_screen_pos.y)
  end
end

scene.guide_video_twofinger_scroll.on_update = function()
  if (show_gesture_guide_rotate) then
      local root_pos_str = scene.root:get_world_position()
      local bear_pos = Vector3(root_pos_str)
      local guide_screen_pos = scene:project(bear_pos.x, bear_pos.y, bear_pos.z)
      scene.guide_video_twofinger_scroll:set_hud_position(guide_screen_pos.x, guide_screen_pos.y)
  end
end



scene.guide_video_onefinger_scroll.on_update = function()
  if (show_gesture_guide_singlemove) then
      local root_pos_str = scene.root:get_world_position()
      local bear_pos = Vector3(root_pos_str)
      local guide_screen_pos = scene:project(bear_pos.x, bear_pos.y, bear_pos.z)
      scene.guide_video_onefinger_scroll:set_hud_position(guide_screen_pos.x, guide_screen_pos.y)
  end
end










