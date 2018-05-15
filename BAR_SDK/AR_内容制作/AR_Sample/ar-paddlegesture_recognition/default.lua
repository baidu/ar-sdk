app_controller = ae.ARApplicationController:shared_instance()
app_controller:require('./scripts/include.lua')
app = AR:create_application(AppType.ImageTrack, "bear")
app:load_scene_from_json("res/simple_scene.json","demo_scene")
scene = app:get_current_scene()

app.on_loading_finish = function()

	app.device:open_imu(1)


    scene.StartButton.on_click = function()
    	scene.ContentPlane:set_visible(false)
    	scene.StartButton:set_visible(false)
        --开启手势识别
        PaddleGesture:send_control_msg(1)
        --张开手掌提示
        scene.gesture_2:set_visible(true)
    end
	

end

resultType1 = 0
resultType2 = 0
resultType3 = 0

function validateResult( resultType)
	resultType1 = resultType2
	resultType2 = resultType3
	resultType3 = resultType
	if(resultType1 == resultType2  and resultType2 == resultType3) then
		return resultType
	end
	return 0
end


PaddleGesture.on_gesture_detected = function(mapData)

    --手势回调

	local count = mapData['gesture_count']
    resultMap = mapData['gesture_result1']
    result = resultMap['type']
    score = resultMap['score']

	x1 = resultMap['x1']
	y1 = resultMap['y1']
	x2 = resultMap['x2']
	y2 = resultMap['y2']
    result = validateResult(result)

    if (score < 0.8) then
       return
    end 

    if (result == 2) then
			scene.gesture_2:set_visible(false)
			scene.bear:set_visible(true)
			scene.bear:pod_anim():anim_repeat(true):start()
			PaddleGesture:send_control_msg(0)
		
    end


end


