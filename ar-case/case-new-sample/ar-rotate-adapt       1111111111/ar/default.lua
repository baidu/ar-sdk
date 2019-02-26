--旋转适配


app_controller = ae.ARApplicationController:shared_instance()
-- 不要修改模块引入的顺序 --
app_controller:require('./scripts/include.lua')
app = AR:create_application(AppType.Imu, "ParticleSystem")
app:load_scene_from_json("res/simple_scene.json", "demo_scene")
current_scene = app.current_scene
local isInIntro = false
local isInIntroAudio = false
local isEntered = false

local curIntroAudioId = -1
local motionAudioId = -1

local curAniId = 0
local totalAni = 4
local audioNode = current_scene.BLN_Light1

local pod_node = current_scene.root_entity

local podActionId = -1

local daiji = current_scene.daiji
local houjiao = current_scene.houjiao
local walk = current_scene.walk
local run = current_scene.run
--设置节点可点击
local handler = lua_handler:register_handle("on_click")
local node = current_scene:get_node_by_name("node_name")
node:set_event_handler(0, handler)
current_scene.daiji_body:set_touchable(true)
current_scene.houjiao_body:set_touchable(true)
current_scene.walk_body:set_touchable(true)
current_scene.run_body:set_touchable(true)
local daijiAction = daiji:pod_anim()
local houjiaoAction = houjiao:pod_anim()
local walkAction = walk:pod_anim()
local runAction = run:pod_anim()

local toHoujiao = true

local curAni = "daiji"

local clickable = true

local zooPage = "zoo_8_5"
local is8_5 = (ae.ARApplicationController ~= nil)
if is8_5 then
    zooPage = "zoo_8_5"
else
    zooPage = "zoo_8_4"
end
-- BLN 显示
bln_light1 = current_scene.BLN_Light1
bln_light2 = current_scene.BLN_Light2
current_scene.go.on_click = function()
    onGoClick()
-- body
end
current_scene.details.on_click = function()
    onDetailsClick()
-- body
end
current_scene.details_open.on_click = function()
    onDetailsClick()
-- body
end
current_scene.init.on_click = function()
    onInitClick()
-- body
end
current_scene.baike.on_click = function()
    onBaikeClick()
-- body
end

current_scene.zoo_8_5:set_visible(true)
app.on_loading_finish = function()
    current_scene.daiji_body.on_click = function()
        onDaijiClick()
    -- body
    end
    current_scene.houjiao_body.on_click = function()
        onHoujiaoClick()
    -- body
    end
    current_scene.walk_body.on_click = function()
        onWalkClick()
    -- body
    end
    current_scene.run_body.on_click = function()
        onRunClick()
    -- body
    end
end
function onDaijiClick()
    print("onDaijiClick")
    if not clickable then
        return
    end
    daijiAction:pause()
    daijiAction:stop()
    daiji:set_visible(false)
    if toHoujiao == true then
        toHoujiao = false
        curAni = "houjiao"
        houjiao:set_visible(true)
        houjiaoAction:start()
        motionAudioId = houjiao:audio()
            :path('res/media/roar.mp3')
            :repeat_count(1)
            :delay(0)
            :on_complete(function()
                print("onRoarCompletion")
                clickable = true
                if curAni == "houjiao"
                then
                    houjiaoAction:pause()
                    :stop()
                    houjiao:set_visible(false)
                    daiji:set_visible(true)
                    daijiAction:start()
                    curAni = "daiji"
                end
                
                if isInIntro then
                    curIntroAudioId:resume()
                end
            
            end)
        :start()
        clickable = false
        
        if isInIntro then
            curIntroAudioId:pause()
        end
    else
        walk:set_visible(true)
        walkAction = walk:pod_anim():start()
        curAni = "walk"
    end
    
    bln_light1:set_visible(false)
    bln_light2:set_visible(false)
--curIntroAudioId:stop()
end
function onHoujiaoClick()
    print("onHoujiaoClick")
    if not clickable then return end
    houjiaoAction:pause()
    houjiaoAction:stop()
    houjiao:set_visible(false)
    walk:set_visible(true)
    walkAction:start()
    curAni = "walk"
end

function onWalkClick()
    print("onWalkClick")
    if not clickable then return end
    walkAction:pause()
    walkAction:stop()
    
    walk:set_visible(false)
    run:set_visible(true)
    runAction:speed(0.8)
    :start()
    curAni = "run"
end
function onRunClick()
    print("onRunClick")
    if not clickable then
        return
    end
    runAction:pause():stop()
    run:set_visible(false)
    daiji:set_visible(true)
    daijiAction:start()
    curAni = "daiji"
    
    toHoujiao = true
end


function onGoClick()
    print("onGoClick")
    app.device:open_imu(1)
    current_scene.zoo_8_5:set_visible(false)
    current_scene.go:set_visible(false)
    current_scene.init:set_visible(true)
    current_scene.baike:set_visible(true)
    current_scene.gray:set_visible(false)
    
    isEntered = true
    current_scene.samplePod:set_visible(true)
    if curIntroAudioId ~= -1 then
        curIntroAudioId:stop()
    end
    onDetailsClick()
    
    daiji:set_visible(true)
    daijiAction:start()
    
    current_scene.BLN_Light1:set_visible(true)
    current_scene.BLN_Light2:set_visible(true)
    scale_anim1 = current_scene.BLN_Light1:scale_by()
        :from(Vector3(1, 1, 1))
        :duration(1000)
        :to(Vector3(0.5, 0.5, 0.5))
        :repeat_count(1000)
        :repeat_mode(1)
        :start()
end
function onDetailsClick()
    print("onDetailsClick")
    if not isEntered then return end
    toggleIntro()
end

function onInitClick()
    print("onInitClick")
    if not isEntered then return end
    current_scene.root_entity:reset_rts()
end

function onBaikeClick()
    if not isEntered then return end
    app:open_url("https://voice.baidu.com/Graph/arcase")
end
function toggleIntro()
    if isInIntro then
        isInIntro = false
        current_scene.intro:set_visible(false)
        curIntroAudioId:stop()
        current_scene.details:set_visible(true)
        current_scene.details_open:set_visible(false)
    else
        isInIntro = true
        current_scene.intro:set_visible(true)
        -- curIntroAudioId = audioNode:audio()
        --     :path("/res/media/intro.mp3")
        --     :repeat_count(1)
        --     :delay(0)
        --     :start()
        --播放音频
        audio_node = scene:get_node_by_name("BLN_Light1")
        rigid_controller = audio_node:get_media_controller()
        rigid_config = {}
        rigid_config["repeat_count"] =0
        --rigid_config["delay"] = 5000

        rigid_session = rigid_controller:create_media_session("audio","/res/media/intro.mp3", rigid_config)
        rigid_session:play()
        
        current_scene.details:set_visible(false)
        current_scene.details_open:set_visible(true)
        if curAni == "houjiao" then
            curIntroAudioId:pause()
        end
    end
end

function () 
    local  = scene:get_node_by_name("bear")
    local pod_animation_controller=bear:get_animation_controller()
    local anim_config = {}
    anim_config["repeat_count"] = -1
    local pod_anim_session = pod_animation_controller:create_animation_session("model", anim_config)
    pod_anim_session:play()
end
