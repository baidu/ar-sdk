-- 音频切换测试
app_controller = ae.ARApplicationController:shared_instance()
app_controller:require('./scripts/include.lua')

app = AR:create_application(AppType.ImageTrack, "test_demo")
app:load_scene_from_json("res/simple_scene.json","demo_scene")
local scene = app.current_scene
--配置NODE
local root_node=scene.root
app.on_loading_finish = function()
    -- 进入场景配合动画先播放介绍音乐（start.mp3）
    app:set_active_scene_camera_look_at("0, 0, 2000", "0, 0, 0", "0, 1, 0.0")
    --root_node = current_scene:get_root_node()
    ARLOG('play_bg_music /res/media/bg_music.mp3')
    app:play_bg_music("/res/media/bg_music.mp3", -1, 0)
    ARLOG('play_bg_music /res/media/bg_music.mp3 end')
    --initTabButton()
    setNormal()
    scene.btn_zhixian_bg:set_visible(true)
    scene.btn_zhixian_normal:set_visible(false)
    scene.btn_zhixian_selected:set_visible(true)
    zhi_music()  
    --[[
        bind_event("btn_zhixian_normal", "onBtn1Click")
    bind_event("btn_huanxing_normal", "onBtn2Click")
    bind_event("btn_luoxian_normal", "onBtn3Click")
    --]]
    scene.btn_zhixian_normal.on_click = function ()
        setNormal()
        scene.btn_zhixian_bg:set_visible(true)
        scene.btn_zhixian_normal:set_visible(false)
        scene.btn_zhixian_selected:set_visible(true)
        zhi_music()
    end
    scene.btn_huanxing_normal.on_click = function ()
        setNormal()
        scene.btn_huanxing_bg:set_visible(true)
        scene.btn_huanxing_normal:set_visible(false)
        scene.btn_huanxing_selected:set_visible(true)
        huan_music()
    end
    scene.btn_luoxian_normal.on_click = function ()
        setNormal()
        scene.btn_luoxian_bg:set_visible(true)
        scene.btn_luoxian_normal:set_visible(false)
        scene.btn_luoxian_selected:set_visible(true)
        luo_music()
    end                                      
end

--2D跟踪失败的回调
app.on_target_lost = function()
   setBirdEyeView()

end

--2D跟踪成功的回调
app.on_target_found = function()
    ARLOG("onApplicationDidLoad")

end

function setBirdEyeView()
    application:set_active_scene_camera_look_at("-200, -1000, 900", "-200, 0, 0", "0, 1, 0.0")
end

function setNormal()
    scene.btn_zhixian_bg:set_visible(false)
    scene.btn_zhixian_normal:set_visible(true)
    scene.btn_zhixian_selected:set_visible(false)
    scene.btn_huanxing_bg:set_visible(false)
    scene.btn_huanxing_normal:set_visible(true)
    scene.btn_huanxing_selected:set_visible(false)
    scene.btn_luoxian_bg:set_visible(false)
    scene.btn_luoxian_normal:set_visible(true)
    scene.btn_luoxian_selected:set_visible(false)
end  
function zhi_music()
    audioA=scene.root:audio():
                path("/res/media/test1.mp3")
                :repeat_count(1)
                :delay(0)
                :forward_logic(5)
                :backward_logic(0)
                :start()
end

function huan_music()
    audioB=scene.root:audio():
                path("/res/media/test2.mp3")
                :repeat_count(1)
                :delay(0)
                :forward_logic(5)
                :backward_logic(0)
                :start()
end

function luo_music()
    audioC=scene.root:audio():
                path("/res/media/test3.mp3")
                :repeat_count(1)
                :delay(0)
                :forward_logic(5)
                :backward_logic(0)
                :start()
end
