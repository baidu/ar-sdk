app_controller = ae.ARApplicationController:shared_instance()
app_controller:require('./scripts/include.lua')
app = AR:create_application(AppType.ImageTrack, "bear")
app:load_scene_from_json("res/simple_scene.json","demo_scene")
scene = app:get_current_scene()


app.on_loading_finish = function()
	local version = app:get_version()
	ARLOG(' = === == ==  version ==== = == = '..version)

	local frame_id = scene.BLN_Light:framePicture()
					:repeat_count(3)
					:delay(2000)
					:on_complete(function ()
						-- 完成后回调
						scene.bear:set_visible(true)

					end)
					:start()
	-- scene.BLN_Light:play_frame_animation(0,0)
	scene.BLN_Light.on_click = function ()
		ARLOG(" ========    = = = = == = == = === ===========111111")
		  frame_id:stop()
	end

	scene.resume.on_click = function ()
		ARLOG(" ========    = = = = == = == = === ===========222222")
		  frame_id:pause()
		  	
	end

	scene.share.on_click = function ()
		ARLOG(" ========    = = = = == = == = === ===========333333")
		frame_id:resume()

	end
end


app.on_target_found = function()

end

app.on_target_lost = function()

end


scene.node1.on_click = function()

end

