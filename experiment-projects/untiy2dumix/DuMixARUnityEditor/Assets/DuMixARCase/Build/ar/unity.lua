function unityInit()
	scene['ButtonB'].unity_click_binder = function ()
		scene['Bear'].u_pod_anim:stop()
		local anim = scene['Bear']:pod_anim():speed(1):repeat_count(9000):start()
		scene['Bear'].u_pod_anim = anim

	end
	scene['ButtonA'].unity_click_binder = function ()
		app:open_url('http://www.baidu.com')
	end
end
