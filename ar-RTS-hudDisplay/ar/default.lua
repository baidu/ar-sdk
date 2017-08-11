--author: shenxuecen@baidu.com

app_controller = ae.ARApplicationController:shared_instance()
-- 不要修改模块引入的顺序 --
app_controller:require('./scripts/utils.lua')
app_controller:require('./scripts/const.lua')
app_controller:require('./scripts/device.lua')
app_controller:require('./scripts/bridge.lua')
app_controller:require('./scripts/ar.lua')
app_controller:require('./scripts/scene.lua')
app_controller:require('./scripts/application.lua')
app_controller:require('./scripts/node.lua')
app_controller:require('./scripts/material.lua')
app_controller:require('./scripts/amath.lua')
app_controller:require('./scripts/anim.lua')
app_controller:require('./scripts/audio.lua')
app_controller:require('./scripts/video.lua')

app = AR:create_application(AppType.ImageTrack, "demo anim")
app:load_scene_from_json("res/simple_scene.json","demo_scene")
scene = app:get_current_scene()


app.on_loading_finish = function()
    io.write("onApplicationDidLoad")
    translate_anim()
    scale_anim()
    rotation_anim()
end

function translate_anim()

    anim = scene.bantouPhoto:move_by()
                            :to(Vector3(1, 0, 0))
                            :delay(1000)
                            :duration(1000)
                            :repeat_count(1000)
                            :repeat_mode(1)
                            :start()

end


function scale_anim()
    anim = scene.bwPhoto:scale_from_to()
                            :from(Vector3(0.1, 0.1, 0.1))
                            :delay(1000)
                            :to(Vector3(5,5,5))
                            :duration(2000)
                            :repeat_count(1000)
                            :repeat_mode(1)
                            :start()
end






function rotation_anim()
	
    anim = scene.colorPhoto:rotate_by()
    				 :delay(1000)
                     :to_degree(360)
                     :axis_xyz(Vector3(1, 0, 0))
                     :duration(3000)
                     :repeat_count(100)
                     :repeat_mode(1)
                     :start()
end













