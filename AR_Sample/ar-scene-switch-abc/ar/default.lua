--
-- Created by IntelliJ IDEA.
-- User: Angus_shyang
-- Date: 2017/9/27
-- Time: 15:06
-- To change this template use File | Settings | File Templates.
-- 
-- Demo 跟丢后动态换贴图 以及点击按钮换贴图


app_controller = ae.ARApplicationController:shared_instance()
-- 引入include.lua脚本文件
app_controller:require('./scripts/include.lua')
-- 设置case类型
app = AR:create_application(AppType.ImageTrack, "switch_scene")
-- 加载场景文件
app:load_scene_from_json("res/simple_scene_A.json","scene_A")
local scene = app:get_current_scene()

app:add_scene_from_json("res/simple_scene_B.json","scene_B")
app:add_scene_from_json("res/simple_scene_C.json","scene_C")



app.on_loading_finish = function()
    -- 加载场景A
    sceneAAA()

end





function sceneAAA()
    -- 场景A
    -- 播放模型动画
    scene.animA:pod_anim():anim_repeat(true):start()
    -- 点击切至场景C
    scene.clickA_1.on_click = function ()
        ARLOG(" 已点击切换至场景C  ")
        sceneCCC()

    end
    
    -- 点击切至场景B
    scene.clickA_2.on_click = function ()
        sceneBBB()
    end

end



function sceneBBB()
    -- 场景B
        app:switch_to_scene_with_name("scene_B")
        local scene = app:get_current_scene()
        scene.animB:pod_anim():anim_repeat(true):start()
    -- 点击切至场景A
    scene.clickB_1.on_click = function ()
        ARLOG(" 已点击切换至场景A  ")
        app:switch_to_scene_with_name("scene_A")
        sceneAAA()

    end
    
    -- 点击切至场景C
    scene.clickB_2.on_click = function ()

        sceneCCC()
        
    end

end



function sceneCCC()
    -- 场景C
    app:switch_to_scene_with_name("scene_C")
    local scene = app:get_current_scene()
    scene.animC:pod_anim():anim_repeat(true):start()
    scene.animC_Box002:replace_texture("/res/texture/Bear_1.0.32.jpg","map")
    scene.bgC:replace_texture("/res/texture/bgC.png","diffuseMap")

    -- 点击切至场景B
    scene.clickC_1.on_click = function ()
        ARLOG(" 已点击切换至场景B  ")
        sceneBBB()

    end
    
    -- 点击切至场景A
    scene.clickC_2.on_click = function ()
        app:switch_to_scene_with_name("scene_A")
        sceneAAA()
        
    end


end



-- 跟丢识别图后再跟上会调该方法
app.on_target_found = function()
	ARLOG("扫描识别图,识别图找到后回调")

	if show then
		scene.bear_Box002:replace_texture("/res/texture/Bear_1.0.32.jpg","map")
		show = false
	else
		scene.bear_Box002:replace_texture("/res/texture/Bear_1.0.3.jpg","map")
		show = true
	end
end





