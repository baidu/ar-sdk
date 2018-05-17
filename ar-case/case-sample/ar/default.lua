app_controller = ae.ARApplicationController:shared_instance()
-- 引入include.lua脚本文件
app_controller:require('./scripts/include.lua')

-- 设置case类型
app = AR:create_application(AppType.ImageTrack, "bear")

-- 加载场景文件
app:load_scene_from_json("res/simple_scene.json","demo_scene")




scene = app:get_current_scene()

app.on_loading_finish = function()

    pod_anim_test()
    ARLOG("资源包加载完成后回调,相当于主函数")

end

-- app.on_target_lost = function()
-- 	ARLOG("扫描识别图,识别图丢失后回调")
-- end

-- app.on_target_found = function()
-- 	ARLOG("扫描识别图,识别图找到后回调")
-- end


function pod_anim_test()
	--播放模型动画
	anim = scene.bear:pod_anim()
					 :anim_repeat(true)
					 :on_complete(function() 
					 	ARLOG('pod anim done')
					 end)
					 :start()
	
	scene.bear.on_click = function()
		--设置点击小熊,停止小熊动画
		anim:stop()
	end
end



