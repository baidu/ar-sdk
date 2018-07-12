app_controller = ae.ARApplicationController:shared_instance()
app_controller:require('./scripts/include.lua')
app = AR:create_application(AppType.Slam, 'bear')
app:load_scene_from_json('res/main.json','demo_scene')
scene = app:get_current_scene()

app.on_loading_finish = function()
	app:onArInit()
    -- EDLOG('资源包加载完成后回调,相当于主函数')
    -- 初始化
    app.device:enable_front_camera()
    anim =  scene.model:pod_anim()
								:anim_repeat(false)
								:frame_start(1)
								:frame_end(39)
								:on_complete(function()
									anim.pause()
								end)
		            :start()
    audio_intro = scene.root:audio()
                            :path('res/audio/10000804/yingwu_intro.mp3')
														:repeat_count(1)
														:on_complete(function()
															scene.info_card_left:set_visible(false)
															scene.info_card_right:set_visible(false)
															scene.click_Close_Book:set_visible(false)
															scene.click_Open_Book:set_visible(true)
														end)
                            :start()

    scene.model.on_click = function()
        model_is_click()
    end

    Event:addEventListener("plane_feature_info", plane_info)


    -- 播放手势教学动画
    initVideoPlayers()
    -- showTwoFingerScroll()

    AR:perform_after(200, showOneFingerScroll)
    AR:perform_after(3200, hideOneFingerScroll)
    AR:perform_after(6200, showTwoFingerScroll)
    AR:perform_after(9200, hideTwoFingerScroll)
    AR:perform_after(12200, showOneFingerClick)
    AR:perform_after(15200, hideOneFingerClick)
	AR:perform_after(18200,showOnefingerSeparate)
	AR:perform_after(21200,hideOnefingerSeparate)

    scene.reset.on_click = function()
        reset_slam()
        hideReset()
    end
end

app.offscreen_button_show = function()
    -- EDLOG('离屏幕引导')
    showReset()
end

--模型重新回到屏幕时
app.offscreen_button_hide = function()
  scene.reset:set_visible(false)
end

function reset_slam()
    app.slam:slam_reset(0.5,0.5,1000)
end

function showReset()
    reset_show = true
    scene.reset:set_visible(true)
    scene.reset:framePicture():repeat_count(999):start()
    hideOneFingerScroll()
    hideTwoFingerScroll()
    hideOneFingerClick()
end

function hideReset()
    scene.reset:set_visible(false)
end

--模型点击回调
function model_is_click()
    ARLOG("zch model is click")

    scene.model:set_visible(true)
		audio_intro:stop()
		audio_hd = scene.model:audio()
														:path('res/audio/10000805/yingwu.mp3')
														:repeat_count(1)
														:start()

    scene.model:pod_anim()
                   :repeat_count(1)
									 :on_complete(function()
										 ARLOG("zch Animation complete")
									 end)
									 :frame_start(50)
									 :frame_end(167)
									 :speed(1.5)
                   :start()
end


-- 初始化视频播放器
function initVideoPlayers()
    oneFingerScroll = scene.guide_video_onefinger_scroll:video()
                                                        :path('res/video/10000799/video_onefinger_scroll.mp4')
    twoFingerScroll = scene.guide_video_twofinger_scroll:video()
                                                        :path('res/video/10000801/video_twofinger_scroll.mp4')
    oneFingerClick = scene.guide_video_single_click:video()
                                                    :path('res/video/10000800/video_single_click.mp4')
	  onefingerSeparate = scene.guide_video_two_separate:video()
		                                                  :path('res/video/10000802/video_onefinger_separate.mp4')
end

-- 播放单指滑动教学动画
function showOneFingerScroll()
    if reset_show then
        return
    end

    scene.guide_video_onefinger_scroll:set_visible(true)
    oneFingerScroll:start()
end

function hideOneFingerScroll()
    scene.guide_video_onefinger_scroll:set_visible(false)
    oneFingerScroll:stop()
end

-- 播放点击教学动画
function showOneFingerClick()
    if reset_show then
        return
    end
    scene.guide_video_single_click:set_visible(true)
    oneFingerClick:start()
end

function hideOneFingerClick()
    scene.guide_video_single_click:set_visible(false)
    oneFingerClick:stop()
end

-- 播放双指滑动教学动画
function showTwoFingerScroll()
    if reset_show then
        return
    end
    scene.guide_video_twofinger_scroll:set_visible(true)
    twoFingerScroll:start()
end

function hideTwoFingerScroll()
    scene.guide_video_twofinger_scroll:set_visible(false)
    twoFingerScroll:stop()
end
--播放双指缩放教学
function showOnefingerSeparate()
	if reset_show then
		return
	end
	scene.guide_video_two_separate:set_visible(true)
	onefingerSeparate:start()
end
function hideOnefingerSeparate()
	scene.guide_video_two_separate:set_visible(false)
	onefingerSeparate:stop()
end
--屏幕旋转
app.device.on_device_rotate = function(orientation)
    if(orientation == DeviceOrientation.Left) then
      rotateleft()

    elseif(orientation == DeviceOrientation.Right) then
      rotateright()

    end
end

function rotateleft()
    scene.info_card_left:set_visible(true)
    scene.info_card_right:set_visible(false)
    scene.info_card_left:set_rotation_by_xyz(90,-90,0)
    scene.click_Close_Book:set_visible(true)
    scene.click_Close_Book:set_rotation_by_xyz(90,-90,0)
    scene.click_Open_Book:set_rotation_by_xyz(90,-90,0)
    scene.guide_video_onefinger_scroll:set_rotation_by_xyz(90,-90,0)
    scene.guide_video_twofinger_scroll:set_rotation_by_xyz(90,-90,0)
    scene.guide_video_single_click:set_rotation_by_xyz(90,-90,0)
    scene.guide_up:set_rotation_by_xyz(90,-90,0)
    scene.guide_down:set_rotation_by_xyz(90,-90,0)
    scene.arrow_guide:set_rotation_by_xyz(90,-90,0)
    scene.reset:set_rotation_by_xyz(90,-90,0)
    scene.click_Close_Book.on_click = function()
        scene.click_Close_Book:set_visible(false)
        scene.click_Open_Book:set_visible(true)
        scene.info_card_left:set_visible(false)
        audio_intro:stop()
    end
    scene.click_Open_Book.on_click = function()
        scene.click_Open_Book:set_visible(false)
        scene.click_Close_Book:set_visible(true)
        scene.info_card_left:set_visible(true)
        audio_intro:start()
    end
end

function rotateright()
    scene.info_card_left:set_visible(false)
    scene.info_card_right:set_visible(true)
    scene.car_card:set_rotation_by_xyz(90,90,0)
    scene.click_Close_Book:set_rotation_by_xyz(90,90,0)
    scene.click_Open_Book:set_rotation_by_xyz(90,90,0)
    scene.guide_video_onefinger_scroll:set_rotation_by_xyz(90,90,0)
    scene.guide_video_twofinger_scroll:set_rotation_by_xyz(90,90,0)
    scene.guide_video_single_click:set_rotation_by_xyz(90,90,0)
    scene.guide_up:set_rotation_by_xyz(90,90,0)
    scene.guide_down:set_rotation_by_xyz(90,90,0)
    scene.reset:set_rotation_by_xyz(90,90,0)
    scene.click_Close_Book.on_click = function()
        scene.click_Close_Book:set_visible(false)
        scene.click_Open_Book:set_visible(true)
        scene.info_card_right:set_visible(false)
        audio_intro:stop()
    end
    scene.click_Open_Book.on_click = function()
        scene.click_Open_Book:set_visible(false)
        scene.click_Close_Book:set_visible(true)
        scene.info_card_right:set_visible(true)
        audio_intro:start()
    end
end

app.device.on_camera_change = function(is_front)
    ARLOG("is_front = "..is_front)
    if (is_front == 1) then
        ARLOG("to front")
        app:switch_app_type("None")
        app.entity:set_active_scene_camera_look_at("0,-900,700", "0,0,0", "0,1,0", false)
        scene.root:reset_rts()
    else
        ARLOG("to back")
        app:switch_app_type("Slam")
        scene.root:reset_rts()
        reset_slam()
    end
end

-- app.onArInit为编辑工具自动生成的方法，请勿删除/修改方法內的内容
app.onArInit = function(self)
-- 框架方法，请勿删除或修改
end
