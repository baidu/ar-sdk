--横屏适配

app_controller = ae.ARApplicationController:shared_instance()
app_controller:require('./scripts/include.lua')

--创建图像跟踪
app = AR:create_application(AppType.ImageTrack, "audio scene")
--从Json中加载场景，并激活场景scene
app:load_scene_from_json("res/simple_scene.json","scene")

node = app.current_scene.backgroundpic

app.device.on_device_rotate = function(orientation)
    if(orientation == DeviceOrientation.Left) then
        node:set_rotation_by_xyz(90,-90,0)
    elseif(orientation == DeviceOrientation.Right) then
        node:set_rotation_by_xyz(90,90,0)
    elseif(orientation == DeviceOrientation.Portrait) then
        node:set_rotation_by_xyz(90,0,0)
    end
end
