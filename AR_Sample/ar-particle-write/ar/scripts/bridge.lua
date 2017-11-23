function HANDLE_SDK_MSG(mapData)
	msg_id = mapData['id']
	if (msg_id == MSG_TYPE_SHAKE) then
        max_acc = mapData['max_acc']
        ARLOG('got max acc '..max_acc)
        if(max_acc < MAX_SHAKE_THRESHOLD) then
            return
        end
        if(AR.current_application.device.shake_enable == false) then
        	ARLOG('fuck')
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
	else
		ARLOG("收到未知消息类型: "..msg_id)
	end
end