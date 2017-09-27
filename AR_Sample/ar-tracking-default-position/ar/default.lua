app_controller = ae.ARApplicationController:shared_instance()
app_controller:require('./scripts/include.lua')
app = AR:create_application(AppType.ImageTrack, "bear")
app:load_scene_from_json("res/simple_scene.json","demo_scene")

scene = app:get_current_scene()

local version = app:get_engine_version()

-- print(type(version) ..' === === = == = == '.. version)
-- ARLOG(' ======================================================================')


app.on_loading_finish = function()

	pod_anim_test()
end


-- 跟丢触发图后
app.on_target_lost = function()
	ARLOG('on target lost')

	AR:perform_after(300,function ()
		app.device:open_imu(1)
	end)
		

	app:set_camera_look_at("0, 0, 1000","0, 0, 0", "0.0, 1.0, 0.0")

end



-- 跟丢后再跟上
app.on_target_found = function()
	ARLOG('on target found')
	
	
end




-- pod模型动画播放
function pod_anim_test()
	anim = scene.bear:pod_anim()
					 :anim_repeat(false)
					 :on_complete(function() 
					 	ARLOG('pod anim done')
					 end)
					 :anim_repeat(true)
					 :start()

	AR:perform_after(6000, function ()

		anim:pause()
	end)

	AR:perform_after(12000, function ()
		anim:resume()
	end)

	AR:perform_after(18000, function ()
		anim:stop()
	end)
end





