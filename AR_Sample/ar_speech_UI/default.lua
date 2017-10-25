app_controller = ae.ARApplicationController:shared_instance()
app_controller:require('./scripts/include.lua')
app = AR:create_application(AppType.ImageTrack, "bear")
app:load_scene_from_json("res/simple_scene.json","demo_scene")

scene = app:get_current_scene()

local version = app:get_engine_version()

-- print(type(version) ..' === === = == = == '.. version)
-- ARLOG(' ======================================================================')

app.on_loading_finish = function()
	app.device:open_imu(1)
	-- 展示语音按钮
  	Speech.show_mic_icon()
  	
  	scene.pic:set_visible(true)


  	-- 开启语音
	Speech.start_listen()


end



-- 语音回调响应 -- 
Speech.callBack = function(data)
	voiceCallback(data)
end


-- 语音callback
function voiceCallback(mapData)
 
    local status = mapData['status']
    io.write(' lua voiceCallback status '..status)
    if(status ~= nil) then
        if(status == VOICE_STATUS_READYFORSPEECH) then
        	ARLOG('语音准备就绪')
        	voiceNode:set_visible(false)
        end
        if(status == VOICE_STATUS_BEGINNINGOFSPEECH) then
        	ARLOG('可以开始说话')
        end
        if(status == VOICE_STATUS_ENDOFSPEECH) then
        	ARLOG('说话结束')
        	voiceNode:set_visible(true)
        end
        if(status == VOICE_STATUS_ERROR) then
        	ARLOG('识别出错')
	        errorid = mapData['error_id']
	        errorId(errorid)
        end
        if(status == VOICE_STATUS_RESULT) then
	        str = mapData['voice_result']
	        ARLOG('识别最终结果 : '..str)
	        matchResult(str)
        end
        if(status == VOICE_STATUS_RESULT_NO_MATCH) then
        	ARLOG('识别结果不匹配')
        end
        if(status == VOICE_STATUS_PARTIALRESULT) then
       	 	ARLOG('识别临时结果')
        end
        if(status == VOICE_STATUS_CANCLE) then
       	 	ARLOG('取消识别')
       	 	voiceNode:set_visible(true)
        end
    end
    
end

--结果匹配
function matchResult(str)
  io.write(' lua voiceCallback matchResult '..str)
	
	if( str == 'show')then
	-- 调用模型显示
		pod_anim_test()
	end
	
	if( str == 'change')then
	--case 处理
		replace()
	end
	
	if( str == 'right')then
	--case 处理
	end
end


function errorId(id)
  if( id == VOICE_ERROR_STATUS_NULL)
	then
	ARLOG('未知错误')
	end
	
	if( id == VOICE_ERROR_STATUS_SPEECH_TIMEOUT)
	then
	ARLOG('没有语音输入')
	end
	
	if( id == VOICE_ERROR_STATUS_NETWORK)
	then
	ARLOG('网络错误')
	end
	
	if( id == VOICE_ERROR_STATUS_INSUFFICIENT_PERMISSIONS)
	then
	ARLOG('权限错误')
	end
end




function pod_anim_test()
	
	scene.pic:set_visible(true)
	ARLOG(" 我 被 语音 调起 了 zzzzzzzzzzzzzzzz")

	-- app.device:open_imu(1)
	scene.bear:set_visible(true)



	anim = scene.bear:pod_anim()
					 :anim_repeat(false)
					 :on_complete(function() 
					 	ARLOG('pod anim done')
					 end)
					 :anim_repeat(true)
					 :start()
end



function replace()
	scene.bear_Box002:replace_texture("/res/texture/Bear_1.0.32.jpg","map")
end

-- app.on_target_found = function()
-- 	ARLOG('on target found')
-- end

-- app.on_target_lost = function()
-- 	ARLOG('on target lost')
-- end









