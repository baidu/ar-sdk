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
app = AR:create_application(AppType.ImageTrack, "bear")
-- 加载场景文件
app:load_scene_from_json("res/simple_scene.json","demo_scene")

scene = app:get_current_scene()
local show = true

app.on_loading_finish = function()
    pod_anim_test()
    ARLOG("资源包加载完成后回调,相当于主函数")

    -- 点击按钮换贴图
    scene.click1.on_click = function ()
    	if show then
    		scene.bear_Box002:replace_texture("/res/texture/Bear_1.0.32.jpg","map")
    	else
    		scene.bear_Box002:replace_texture("/res/texture/Bear_1.0.3.jpg","map")
    	end
    end
    
    -- 点击换回贴图
    scene.click2.on_click = function ()
    	if show then
    		scene.bear_Box002:replace_texture("/res/texture/Bear_1.0.3.jpg","map")
    	else
    		scene.bear_Box002:replace_texture("/res/texture/Bear_1.0.32.jpg","map")
    	end
    	
    end

end

-- app.on_target_lost = function()
-- 	ARLOG("扫描识别图,识别图丢失后回调")
-- end


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


function pod_anim_test()
	--播放模型动画
	anim = scene.bear:pod_anim()
					 :anim_repeat(true)
					 :on_complete(function() 
					 	ARLOG('pod anim done')
					 end)
					 :start()
end



