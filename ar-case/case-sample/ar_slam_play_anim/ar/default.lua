app_controller = ae.ARApplicationController:shared_instance()
app_controller:require('./scripts/include.lua')
app = AR:create_application(AppType.Slam, "bear")
app:load_scene_from_json("res/simple_scene.json","demo_scene")

scene = app:get_current_scene()

local version = app:get_engine_version()

-- print(type(version) ..' === === = == = == '.. version)
-- ARLOG(' ======================================================================')

app.on_loading_finish = function()
	pod_anim_test()
end

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

app.on_target_found = function()
	ARLOG('on target found')
end

app.on_target_lost = function()
	ARLOG('on target lost')
end









