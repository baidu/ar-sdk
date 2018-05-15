app_controller = ae.ARApplicationController:shared_instance()
app_controller:require('./scripts/include.lua')
app = AR:create_application(AppType.ImageTrack, "bear")
app:load_scene_from_json("res/simple_scene.json","demo_scene")
scene = app:get_current_scene()



app.on_loading_finish = function()
     app.device:open_imu(1)
     Logo.stat_recg(2)

end

Logo.callBack = function(data)
    local logo_status = data['logo_code']
    if(logo_status ~= nil) then
        if(logo_status == MSG_TYPE_LOGO_START) then

        end
        if(logo_status == MSG_TYPE_LOGO_HIT)then
            local str = data['logo_result']
            matchResult(str);
            scene.kuang:set_visible(false)    
            scene.icon:set_visible(false)
            scene.text:set_visible(false)
        end
        if(logo_status == MSG_TYPE_LOGO_STOP)then
            
        end
    end
end


function matchResult(str)
    if( str == 'baidu')then
        scene.bear_ydh:set_visible(true)
        scene.bear_ydh:pod_anim()
 	              :anim_repeat(true)
 	              :start()
 	    Logo.stop_recg(3)
    end
end

