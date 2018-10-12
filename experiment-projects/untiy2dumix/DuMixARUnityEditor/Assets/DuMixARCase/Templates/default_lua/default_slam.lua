app_controller = ae.ARApplicationController:shared_instance()
app_controller:require('./scripts/include.lua')
app = AR:create_application(AppType.Slam, 'bear')
app:load_scene_from_json('res/main.json','demo_scene')
scene = app:get_current_scene()
app_controller:require('./unity.lua')
app_controller:require('./main.lua')

