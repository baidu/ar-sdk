local application = ae.ARApplication:shared_application()

is8_5 = (ae.ARApplicationController ~= nil)

--注册app加载完成之后的回调
lua_handler = application:get_lua_handler()


local appLoadedHandlerId = lua_handler:register_handle("onApplicationDidLoad")
local trackingLossHandlerId = lua_handler:register_handle("onTrackingLoss")
local trackingFoundHandleId = lua_handler:register_handle("onTrackingFound");
application:set_on_loading_finish_handler(appLoadedHandlerId)
application:set_on_tracking_lost_handler(trackingLossHandlerId)
application:set_on_tracking_found_handler(trackingFoundHandleId);

--从JSON中加载场景
application:add_scene_from_json("res/simple_scene.json", "demo_scene")
--激活场景
application:active_scene_by_name("demo_scene")
--配置NODE
local current_scene = application:get_current_scene()
local root_node = current_scene:get_root_node()

local showScene = lua_handler:register_handle("ShouwMyUI")
local bianxing_handle = lua_handler:register_handle("bianxingClick")
local duijue_handle = lua_handler:register_handle("duijueClick")
local resume_handle = lua_handler:register_handle("resumeClick")
local ximiannai_handle = lua_handler:register_handle("OpenMyUrl1")
local tengxun_handle = lua_handler:register_handle("OpenMyUrl2")
local model_handle = lua_handler:register_handle("OnClickModel")

local bianxingjingang = current_scene:get_node_by_name("bianxingjingang")
local bianxing_btn = current_scene:get_node_by_name("bianxing")
local duijue_btn = current_scene:get_node_by_name("duijue")
local test_model

local tengxun_btn = current_scene:get_node_by_name("tengxun")
local ximiannai_btn = current_scene:get_node_by_name("ximiannai")
local resume_btn = current_scene:get_node_by_name("ResumeButton")
local tishi
local tishi2
local index = 1
local audioID
local playModelId
local handler_id
local click_playModel_idx = 1

local isbool = true
local isLoss = false

local yinying = current_scene:get_node_by_name("yinying")

local playYingying
function onApplicationDidLoad()
    bianxingjingang:set_visible(false)
    bianxing_btn:set_visible(false)
    duijue_btn:set_visible(false)
    tengxun_btn:set_visible(false)
    ximiannai_btn:set_visible(false)
    resume_btn:set_visible(false)
    yinying:set_visible(false)
    --test_model = current_scene:get_node_by_name("testbtn")
    tishi = current_scene:get_node_by_name("tishi")
    tishi:set_event_handler(0, showScene)
    

    -- tishi2 = current_scene:get_node_by_name("tishi2")
    -- tishi2:set_event_handler(0, showScene)

    bianxing_btn:set_event_handler(0, bianxing_handle)
    duijue_btn:set_event_handler(0, duijue_handle)

    resume_btn:set_event_handler(0,resume_handle)
    ximiannai_btn:set_event_handler(0,ximiannai_handle)
    tengxun_btn:set_event_handler(0,tengxun_handle)
    --test_model:set_event_handler(0,model_handle)
    -- if is8_5 then
    --     io.write('&&&&&& current is 8.5')
    --     tishi:set_visible(false)
    --     tishi2:set_visible(true)
    -- else
    --     io.write('&&&&&& current is 8.4')
    --     tishi:set_visible(true)
    --     tishi2:set_visible(false)
    -- end
    --root_node = current_scene:get_root_node()
    --animID = root_node:play_pod_animation_all(1, false)
    --audioID = root_node:play_audio("/res/media/sound32004.mp3", 1, 0)
    ae.LuaUtils:call_function_after_delay(500, "onDelayVisible")
end

function onDelayVisible()
    tishi:set_visible(true)
end

--跟丢回调处理
function onTrackingLoss()
    isLoss = true
    application:relocate_current_scene()
    setBirdEyeView()
end

function setBirdEyeView()
    if isLoss == true then
        bianxingjingang:set_position(0,-170,0)
        yinying:set_position(0,-170,0)
        if index == 1 or index == 2 then
            bianxingjingang:set_rotation_by_xyz(7,-15,0)
            yinying:set_rotation_by_xyz(7,-15,0)
        elseif index == 3 then

        end
    end
    --application:set_active_scene_camera_look_at("-150, 0, 2650", "50, 0, 600", "0, 1, 0.0")
    application:set_active_scene_camera_look_at("0, 0, 1000", "0, 0, 0", "0, 1, 0")
end

--重新找到
function onTrackingFound()
    isLoss = false
    bianxingjingang:set_position(0,-250,0)
    yinying:set_position(0,-250,0)
    bianxingjingang:set_rotation_by_xyz(0,-15,0)
    yinying:set_rotation_by_xyz(0,-15,0)
    bianxingjingang:set_scale(7,7,7)
    yinying:set_scale(7,7,7)
end

function ShouwMyUI()
    tishi:set_visible(false)
    --tishi2:set_visible(false)
    bianxing_btn:set_visible(true)
    duijue_btn:set_visible(true)
    tengxun_btn:set_visible(true)
    ximiannai_btn:set_visible(true)
    resume_btn:set_visible(true)
    -- test_model:set_visible(true)
    -- test_model:set_touchable(true)
    
    application:play_bg_music("/res/media/bg.mp3", -1, 0)
    --bianxingjingang:play_pod_animation_all(1,true,-1,1400)
    bianxingjingang:set_visible(true)
    yinying:set_visible(true)
    local cfg = ae.ActionPriorityConfig:new()
    cfg.forward_logic = 2
    cfg.backward_logic = 1
    local prm = ae.PodAnimationParam:new()
    --pod模型中在标示的区间动画名称，由模型设计师指定
    prm._name = ""
    --=模型动画速度
    prm._speed = 1
    --=重复次数
    prm._repeat_count = 1
    --动画开始帧
    prm._start = 96
    --动画结束帧154
    prm._end = 816
    playModelId = bianxingjingang:play_pod_animation_all(prm, cfg)
    playYingying =yinying:play_pod_animation_all(prm,cfg)
    --bianxingjingang:play_pod_animation_all(1,false,96,154)
    --audioID = root_node:play_audio("/res/media/bianren.mp3", 1, 0)
    local cfg_audio = ae.ActionPriorityConfig:new()
    cfg_audio.forward_logic = 2
    cfg_audio.backward_logic = 1
    audioID = root_node:play_audio(cfg_audio, "/res/media/bianren.mp3", 1, 0)

    --local handler_id = lua_handler:register_handle("on_play_model_anim_finish")
    handler_id = lua_handler:register_handle("on_play_model_anim_finish")

    --第一个事件播放完成后，执行第二个事件
   --bianxingjingang:set_action_completion_handler(playModelId, handler_id)
end

--点击变形按钮
function bianxingClick()
    local cfg = ae.ActionPriorityConfig:new()
    cfg.forward_logic = 2
    cfg.backward_logic = 1
    local prm = ae.PodAnimationParam:new()
    local cfg_audio = ae.ActionPriorityConfig:new()
    cfg_audio.forward_logic = 2
    cfg_audio.backward_logic = 1
    if isLoss == true then
        bianxingjingang:set_rotation_by_xyz(7,-15,0)
        yinying:set_rotation_by_xyz(7,-15,0)
    else 
        bianxingjingang:set_rotation_by_xyz(0,-7,0)
        yinying:set_rotation_by_xyz(0,-7,0)
    end
    if index == 1 then
        
        --pod模型中在标示的区间动画名称，由模型设计师指定
        prm._name = ""
        --=模型动画速度
        prm._speed = 1
        --=重复次数
        prm._repeat_count = 1
        --动画开始帧
        prm._start = -1
        --动画结束帧
        prm._end = 62
        playModelId = bianxingjingang:play_pod_animation_all(prm, cfg)
        playYingying =yinying:play_pod_animation_all(prm,cfg)
        --playModelId = bianxingjingang:play_pod_animation_all(1,false,-1,62)
        --audioID = root_node:play_audio("/res/media/bianche.mp3", 1, 0)
        audioID = root_node:play_audio(cfg_audio, "/res/media/bianche.mp3", 1, 0)
        index = 2
    elseif index == 2 then
        -- local cfg = ae.ActionPriorityConfig:new()
        -- cfg.forward_logic = 2
        -- cfg.backward_logic = 2
        -- local prm = ae.PodAnimationParam:new()
        --pod模型中在标示的区间动画名称，由模型设计师指定
        prm._name = ""
        --=模型动画速度
        prm._speed = 1
        --=重复次数
        prm._repeat_count = 1
        --动画开始帧
        prm._start = 97
        --动画结束帧156
        prm._end = 816
        playModelId = bianxingjingang:play_pod_animation_all(prm, cfg)
        playYingying =yinying:play_pod_animation_all(prm,cfg)
        --playModelId = bianxingjingang:play_pod_animation_all(1,false,97,156)
        --audioID = root_node:play_audio("/res/media/bianren.mp3", 1, 0)
        audioID = root_node:play_audio(cfg_audio, "/res/media/bianren.mp3", 1, 0)
        index = 1
    elseif index == 3 then
        -- local cfg = ae.ActionPriorityConfig:new()
        -- cfg.forward_logic = 2
        -- cfg.backward_logic = 2
        -- local prm = ae.PodAnimationParam:new()
        --pod模型中在标示的区间动画名称，由模型设计师指定
        prm._name = ""
        --=模型动画速度
        prm._speed = 1
        --=重复次数
        prm._repeat_count = 1
        --动画开始帧
        prm._start = -1
        --动画结束帧
        prm._end = 62
        playModelId = bianxingjingang:play_pod_animation_all(prm, cfg)
        playYingying =yinying:play_pod_animation_all(prm,cfg)
        --playModelId = bianxingjingang:play_pod_animation_all(1,false,-1,62)
        --audioID = root_node:play_audio("/res/media/bianche.mp3", 1, 0)
        audioID = root_node:play_audio(cfg_audio, "/res/media/bianche.mp3", 1, 0)
        index = 2
    end
    --local handler_id = lua_handler:register_handle("on_play_model_anim_finish")
    --第一个事件播放完成后，执行第二个事件
    --bianxingjingang:set_action_completion_handler(playModelId, handler_id)
end

--点击对决按钮--播放挥剑动画
function duijueClick()
    bianxingjingang:set_rotation_by_xyz(0,0,0)
    yinying:set_rotation_by_xyz(0,0,0)
    index = 3
    --===播放节点动画【PodAnimationParam:pod动画参数;ActionPriorityConfig:指令优化级配置】
    local cfg = ae.ActionPriorityConfig:new()
    cfg.forward_logic = 2
    cfg.backward_logic = 1
    local prm = ae.PodAnimationParam:new()
    --pod模型中在标示的区间动画名称，由模型设计师指定
    prm._name = ""
    --=模型动画速度
    prm._speed = 1
    --=重复次数
    prm._repeat_count = 1
    --动画开始帧
    prm._start = 817
    --动画结束帧
    prm._end = 1244
    playModelId = bianxingjingang:play_pod_animation_all(prm, cfg)
    playYingying =yinying:play_pod_animation_all(prm,cfg)
    --playModelId = bianxingjingang:play_pod_animation_all(1,false,817,884)
    --audioID = root_node:play_audio("/res/media/huijian.mp3", 1, 0)
    local cfg_audio = ae.ActionPriorityConfig:new()
    cfg_audio.forward_logic = 2
    cfg_audio.backward_logic = 1
    audioID = root_node:play_audio(cfg_audio, "/res/media/huijian.mp3", 1, 0)

    --local handler_id = lua_handler:register_handle("on_play_model_anim_finish")
    --第一个事件播放完成后，执行第二个事件
    --bianxingjingang:set_action_completion_handler(playModelId, handler_id)
end

function OnClickModel()
    if isbool == false then
        return
    end
    --if click_playModel_idx == 1 then
        bianxingjingang:set_rotation_by_xyz(0,0,0)
        yinying:set_rotation_by_xyz(0,0,0)
        --===播放节点动画【PodAnimationParam:pod动画参数;ActionPriorityConfig:指令优化级配置】
        local cfg = ae.ActionPriorityConfig:new()
        cfg.forward_logic = 2
        cfg.backward_logic = 1
        local prm = ae.PodAnimationParam:new()
        --pod模型中在标示的区间动画名称，由模型设计师指定
        prm._name = ""
        --=模型动画速度
        prm._speed = 1
        --=重复次数
        prm._repeat_count = 1
        --动画开始帧
        prm._start = 817
        --动画结束帧
        prm._end = 1244
        playModelId = bianxingjingang:play_pod_animation_all(prm, cfg)
        playYingying =yinying:play_pod_animation_all(prm,cfg)
        --playModelId = bianxingjingang:play_pod_animation_all(1,false,817,884)
        --audioID = root_node:play_audio("/res/media/huijian.mp3", 1, 0)
        local cfg_audio = ae.ActionPriorityConfig:new()
        cfg_audio.forward_logic = 2
        cfg_audio.backward_logic = 1
        audioID = root_node:play_audio(cfg_audio, "/res/media/huijian.mp3", 1, 0)
    --end
end

function on_play_model_anim_finish()
    --[[
    io.write("status:------------------------------" .. status)
    if (0 == status) then
        io.write("index:------------------------------" .. index)
        if index == 1 then
            --播放待机
            -- local cfg = ae.ActionPriorityConfig:new()
            -- cfg.forward_logic = 2
            -- cfg.backward_logic = 1
            -- local prm = ae.PodAnimationParam:new()
            -- --pod模型中在标示的区间动画名称，由模型设计师指定
            -- prm._name = ""
            -- --=模型动画速度
            -- prm._speed = 1
            -- --=重复次数
            -- prm._repeat_count = 1
            -- --动画开始帧
            -- prm._start = 156
            -- --动画结束帧
            -- prm._end = 196
            -- playModelId = bianxingjingang:play_pod_animation_all(prm, cfg)
            playModelId = bianxingjingang:play_pod_animation_all(1,true,156,196)
        elseif index == 2 then
            playModelId = bianxingjingang:play_pod_animation_all(1,true,70,100)
        elseif index == 3 then
            --播放挥剑待机
            -- local cfg2 = ae.ActionPriorityConfig:new()
            -- cfg2.forward_logic = 2
            -- cfg2.backward_logic = 1
            -- local prm2 = ae.PodAnimationParam:new()
            -- --pod模型中在标示的区间动画名称，由模型设计师指定
            -- prm2._name = ""
            -- --=模型动画速度
            -- prm2._speed = 1
            -- --=重复次数
            -- prm2._repeat_count = 1
            -- --动画开始帧
            -- prm2._start = 884
            -- --动画结束帧
            -- prm2._end = 924
            -- playModelId = bianxingjingang:play_pod_animation_all(prm2, cfg2)
            playModelId = bianxingjingang:play_pod_animation_all(1,true,884,924)
        end
    end
    ]]--
end

function resumeClick()
    if isLoss == false then
        application:relocate_current_scene()
    else 
        application:relocate_current_scene()
        setBirdEyeView()
    end
end

function OpenMyUrl1()
    application:open_url("https://ad.doubleclick.net/ddm/clk/400861012;200926683;t", 1)
end
function OpenMyUrl2()
    application:open_url("https://ad.doubleclick.net/ddm/clk/400861012;200926683;t", 1)
end
