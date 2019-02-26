-- bridge.lua --

function HANDLE_SDK_MSG(mapData)

	msg_name = mapData['event_name']
	msg_data = mapData['event_data']
	if msg_name then  Event:dispatchEvent({name=msg_name,data=msg_data}) end

	msg_id = mapData['id']
	if (msg_id == MSG_TYPE_SHAKE) then
        max_acc = mapData['max_acc']
        ARLOG('got max acc '..max_acc)
        if(max_acc < MAX_SHAKE_THRESHOLD) then
            return
        end
        if(AR.current_application.device.shake_enable == false) then
        	return
        end

		if(AR.current_application.device.on_device_shake ~= 0) then
			AR.current_application.device.on_device_shake()
		else
			ARLOG("收到Shake消息，但onDeviceShake方法未定义")
		end

	elseif(msg_id == MSG_TYPE_VOICE_START) then
		if(Speech.callBack ~= nil) then
			Speech.callBack(mapData)
		end

	elseif(msg_id == MSG_TYPE_TTS_SPEAK) then
		if(Tts.callBack ~= nil) then
			Tts.callBack(mapData)
		end		

	elseif(msg_id == MSG_TYPE_CAMERA_CHANGE) then
		if(AR.current_application.device.on_camera_change ~= 0) then
			local is_front_camera = mapData['front_camera']
			AR.current_application.device.on_camera_change(is_front_camera)
		end

	elseif(msg_id == MST_TYPE_REMOTE_DEBUG_REC) then
		code = mapData['code']
		loadstring(code)()

	-- WebView --
	elseif(msg_id == MSG_TYPE_WEBVIEW_OPERATION) then
		op = mapData['operation']
		ARLOG("WebViewOperation.operation: "..op)
		if op == WebViewOperation.LoadFinish then
			ARLOG("WebViewOperation.loadFinish texture_id: "..mapData['texture_id'])
			WebView:WebViewLoaded(mapData['texture_id'])
		elseif op == WebViewOperation.UpdateFinish then
			ARLOG("WebViewOperation.updateFinish texture_id: "..mapData['texture_id'])
			WebView:WebViewUpdateFinished(mapData['texture_id'])
		elseif op == WebViewOperation.LoadFailed then
			ARLOG("WebViewOperation.LoadFailed texture_id: "..mapData['texture_id'])
            msg = mapData['data']
			WebView:WebViewLoadError(mapData['texture_id'], msg)
		end
		
	-- WebView end --

	elseif(msg_id == MSG_TYPE_TRACK_TIPS) then
		msg_tips_type = mapData['tips_type']
		if (msg_tips_type == TrackTips.trackedDistanceTooFar) then
			if (AR.current_application.on_tracked_distance_too_far ~= nil) then
				AR.current_application.on_tracked_distance_too_far()
			else
				ARLOG("收到track消息，但application on_tracked_too_far方法未定义")
			end

		elseif (msg_tips_type == TrackTips.trackedDistanceTooNear) then 
			if (AR.current_application.on_tracked_distance_too_near ~= nil) then
				AR.current_application.on_tracked_distance_too_near()
			else
				ARLOG("收到track消息，但application on_tracked_too_near方法未定义")
			end

		elseif (msg_tips_type == TrackTips.trackedDistanceNormal) then 
			if (AR.current_application.on_tracked_distance_normal ~= nil) then
				AR.current_application.on_tracked_distance_normal()
			else
				ARLOG("收到track消息，但on_tracked_distance_normal方法未定义")
			end

		else
			ARLOG("收到track消息，但无方法："..msg_tips_type)
		end

    elseif(msg_id == LOAD_STATUS_DOWNLOAD_ANSWER) then
    	if (BatchLoader.CallBack  ~= nil) then
    		BatchLoader.CallBack(mapData)
    		ARLOG("收到DownLoad batch消息")
    	end

    elseif(msg_id == MSG_TYPE_SLAM_DIRECTION_GUIDE) then
    	if (AR.current_application.slam.on_slam_direction_guide ~= nil) then
    		switchGuide = mapData['switchGuide']
    		guideDirection = mapData['guideDirection'] or 0
    		AR.current_application.slam.on_slam_direction_guide(switchGuide, guideDirection)
    	end

    elseif(msg_id == PADDLE_GESTURE_STATUS_DETECTED) then
    	if (PaddleGesture.CallBack  ~= nil) then
    		PaddleGesture.CallBack(mapData)
    		ARLOG("收到Gesture消息")
    	end

    elseif(msg_id == MSG_TYPE_LUA_REQUEST_STATUS or msg_id == MSG_TYPE_LUA_REQUEST_ANSWER) then
    	HTTPS:HANDLE_CALLBACK_FORM_SDK(mapData)

    elseif(msg_id == MSG_TYPE_VIDEO) then
		msg_data = mapData['msg_data']
	    if (Video.call_back ~= nil) then
	        Video.call_back(msg_data)
	        ARLOG("收到Video call_back 消息")
	    end

	elseif(msg_id == MSG_TYPE_AUDIO) then
		msg_data = mapData['msg_data']
	    if (Audio.call_back ~= nil) then
	        Audio.call_back(msg_data)
	        ARLOG("收到Audio call_back 消息")
	    end
	    
	elseif(msg_id == MSG_TYPE_DIALOG_RESULT) then
    	if (Alert.CallBack ~= nil) then
    		Alert.CallBack(mapData)
    	end

	-- ARKit -- 
	elseif(msg_id == MSG_TYPE_ARKIT_PlANE_DETECTED) then
		if(AR.current_application.device.plane_detected ~= 0) then
			AR.current_application.device.plane_detected()
			local plane_pos = {}
			plane_pos.x= mapData['plane_position_x']
			plane_pos.y= mapData['plane_position_y']
			plane_pos.z= mapData['plane_position_z']

			AR.current_application.device.get_plane_position(plane_pos)
		end

	elseif(msg_id == MSG_TYPE_ARKIT_PlANE_CLEAR) then
		if(AR.current_application.device.plane_clear ~= 0) then
			AR.current_application.device.plane_clear()
		end

	-- show_lay_status
	elseif(msg_id == MSG_TYPE_SHOW_LAY_STATUS) then
		if(AR.current_application.device.show_lay_status ~= 0) then
			local show = mapData['show']
			AR.current_application.device.show_lay_status(show)
		end
	-- ARKit end-- 
    elseif(msg_id == MSG_TYPE_RENDER_SIZE_ANSWER) then 
		if (AR.current_application.device.get_render_size_callback  ~= nil) then
            local width = mapData['width']
            local height = mapData['height']
            AR.current_application.device.get_render_size_callback(width,height)
    	end
    elseif(msg_id == MSG_TYPE_RECORD_STATE) then
        if(AR.current_application.device.on_record_state_change ~= 0) then
        	local is_record = mapData['record_state']
        	AR.current_application.device.on_record_state_change(is_record)
    	end
	else
		ARLOG("收到未知消息类型: "..msg_id)
    end
end
