app_controller = ae.ARApplicationController:shared_instance()
app_controller:require("./scripts/include.lua")

app = AR:create_application(AppType.Imu, "demo anim")
app:load_scene_from_json("res/simple_scene.json", "demo_scene")
scene = app:get_current_scene()
local spiderMan = scene:get_node_by_name("daodiao_fuzhi")
local video
local fistLoadBatch =0
guidanceTarge = 0
guidanceCtr = 1
gestureCtr =1
local num = 1
local num2 = 1
local progress_bar = scene:get_node_by_name("progressbar_Loading1")
app.on_loading_finish = function()
    -- scene:load_all_batch()
    app:open_imu_service(1)
    ARLOG("onApplicationDidLoad")
    scene.progressbar:set_visible(false)
    scene.on_loading_text:set_visible(false)
    scene.on_batch_load_finish = function(id, ret)
        onBatchLoadFinish(id, ret)
    end
    scene.on_batch_load_progress_update = function(id, progress)
        onBatchLoadProgressUpdate(id, progress)
    end
end
-- scene.on_touch_event = function(etype, ex, ey)
--     if(fistLoadBatch==0)then
--         scene.progressbar:set_visible(true)
--         scene.on_loading_text:set_visible(true)
--         scene:load_batch(1)
--         frame_id = scene.on_loading_box:framePicture():repeat_count(100):start()
--     end

--     -- body
-- end
scene.photoOne.on_click = function()
    scene.progressbar:set_visible(true)
    scene.on_loading_text:set_visible(true)
    scene:load_batch(1)
    frame_id = scene.on_loading_box:framePicture():repeat_count(100):start()
    -- body
end
-- 自定义load batch完成后的回调函数
function onBatchLoadFinish(id, ret)
    if (id == 1 and ret == 0) then
        ARLOG("load_batch_one")
        scene.tips2:set_visible(false)
        scene.close:set_visible(false)
        
        -- video = scene.videoPlane1:video():path("res/media/video1.mp4"):repeat_count(-1):start()
        -- scene.progressbar:set_visible("false")
        scene:remove_node_by_name("progressbar")
        scene:remove_node_by_name("on_loading_box")
        scene:remove_node_by_name("on_loading_text")
        scene:remove_node_by_name("photoOne")
        -- scene:set_user_interaction_config("disable_all", 1)
        ctrGestureState=ae.SharedPreference:get_value(2, "ctrGuideState")
        ARLOG("ctrGuideState"..ctrGestureState)
        if(ctrGestureState=="1")then
            scene:set_user_interaction_config("disable_all", 0)
        else
            if(ctrGestureState=="0")then
                scene:set_user_interaction_config("disable_all", 1)
            end
        end
        scene.button1.on_click = function()
            ARLOG("click1")
            ARLOG("click1" .. guidanceTarge)
            if (guidanceCtr == 1) then
                if (guidanceTarge == 0) then
                    scene.tips1:set_visible(false)
                    scene.tips2:set_visible(true)
                    scene:set_offscreen_guidance_target("base")
                    guidanceTarge = 1
                    ARLOG("click1" .. guidanceTarge)
                else
                    scene.tips1:set_visible(true)
                    scene.tips2:set_visible(false)
                    scene:set_offscreen_guidance_target("daodiao_Line003")
                    guidanceTarge = 0
                    ARLOG("click1" .. guidanceTarge)
                end
            end
        end
        scene.button2.on_click = function()
            ARLOG("click2")
            if (guidanceCtr == 1) then
                scene.open:set_visible(false)
                scene.close:set_visible(true)
                scene:set_show_offscreen_guidance(false)
                guidanceCtr = 0
                ARLOG(guidanceCtr)
            else
                scene.open:set_visible(true)
                scene.close:set_visible(false)
                scene:set_show_offscreen_guidance(true)
                guidanceCtr = 1
                ARLOG(guidanceCtr)
            end
        end
    end
end
-- 自定义load batch过程中后的回调函数
function onBatchLoadProgressUpdate(id, progress)
    io.write("onBatchLoadProgressUpdate " .. id .. " " .. progress)
    if (id == 1) then
        updateprogress_1(progress)
    end
end
-- 自定义定义的进度条函数
function updateprogress_1(progress)
    local delta = progress / 202 * -1
    ARLOG("vvv")
    -- video:stop()
    progress_bar:set_material_vector_property("offsetRepeat", tostring(delta) .. ",0, 1, 1")
end
