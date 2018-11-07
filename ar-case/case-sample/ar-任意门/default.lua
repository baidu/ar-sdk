-- ArbitraryGate  
app_controller = ae.ARApplicationController:shared_instance()
app_controller:require('./scripts/include.lua')
--创建图像跟踪
app = AR:create_application(4, "ArbitraryGate")
--从Json中加载场景，并激活场景scene
app:load_scene_from_json("res/simple_restore_scene.json","ArbitraryGate")
scene = app:get_current_scene()
-- 分步loading
batch_one_finish = false

-- 复位
-- reset = 0

is_place_status = 0
can_play = 0
is_detected = 0
showDoor = 0

-- 进门后音频播放标识
inDoorMusic_id = 0

-- 门内外四种状态标识
INDOOR_OUTSIDE  = 1
INDOOR_INSIDE   = 2
OUTDOOR_OUTSIDE = 3
OUTDOOR_INSIDE  = 4

-- 判断是否进入天空盒内部
inTheSkyBox = 0
-- NowInFrontOfTheWall = true
inSkyBoxTip_show = true

-- 1S前所处的位置
last_position = 3
last_status = -1
current_status = -1
current_position = 3

-- 是否进入
isComeIn = false

-- 判断手势点击
is_down = false
touch_down_time = 0
touch_up_time = 0

-- 由于case加载完成后, 便会开始检测平面
-- 在未点击引导页按钮前, 即使检测到平面, 也不会显示提示点击屏幕的UI
is_Start = false
-- 获取平面位置信息
current_plane_pos = 0

seturl1 = "${seturl1}"
seturl2 = "${seturl2}"

app.on_loading_finish = function()
    scene.welcome_Show:set_visible(true)
    -- scene.school_Name:set_visible(true)
    scene.progressBar:set_visible(true)
    scene.onloadingTip:set_visible(true)

    -- 分步loading 完成
    scene.on_batch_load_finish = function(id,ret)
         onBatchLoadFinish(id,ret)
    end

    -- 分步loading
    scene.on_batch_load_progress_update = function(id, progress)
        onBatchLoadProgressUpdate(id,progress)
    end

    scene:load_batch(1)  
    scene:set_slam_move_limits(1.5,4)
end

BatchLoader.user_confirm_download = function(batch_id)
    if (batch_id == 'batch1') then
        scene:load_batch(1)
    end
end

-- BatchLoader.user_refuse_download = function(batch_id)
--     -- io.write("user_refuse_download :"..batch_id)
-- end

app.device.plane_detected = function()
    is_detected = 1
    scene.lookingFor:audio():path('/res/media/find_end.mp3'):repeat_count(1):start()
    scene.lookingFor:set_visible(false)
    scene.lookingForTip:set_visible(false)
    if is_Start then
        showGuide()
    end
    scene.root.position = Vector3(0,0,0)
    -- ARLOG("syp : 已找到地面")
    app.device.get_plane_position = function(plane_pos)
        current_plane_pos = plane_pos
        ARLOG("syp - plane_pos :"..current_plane_pos.x..'|'..current_plane_pos.y..'|'..current_plane_pos.z)
    end
end


function onBatchLoadFinish(id, ret)
    if (id == 1 and ret == -1) then
        BatchLoader.send_download_retry_msg()
        return
    end

    scene.root.on_update = function ()
        onRootNodeUpdated()
        -- local camrera_world_rot = Vector3(scene.mainCamera:get_world_rotation())
        -- ARLOG("sy--camrera_world_rot: = "..camrera_world_rot.x..' = '..camrera_world_rot.y..' = '..camrera_world_rot.z)
    end

    if (id == 1 and ret == 0) then
        batch_one_finish = true
        scene.onloadingTip:set_visible(false)
        scene:delete_node_by_name("onloadingTip")
        scene:delete_node_by_name("progressBar")

        scene.go_Show:set_visible(true)
        scene.go_Show.on_click = startButtonClick
    end
end

function onBatchLoadProgressUpdate(id, progress)
    if (id == 1) then
        AR:perform_after(10,updateprogress_1(progress))
    end
end

-- progress_bar = scene.progressbar_pPlane9
function updateprogress_1(progress)
    -- 更新进度条
    local pathProgress = "res/media/progress_bar/bar"..tostring(progress)..".png"
    scene.progressBar:replace_texture(pathProgress, "uDiffuseTexture")
end

function startButtonClick()
    ARLOG('sytest-startButtonClick')
    -- app.device:start_place_status()
    is_Start = true
    scene.welcome_Show:set_visible(false)
    scene.school_Name:set_visible(false)
    scene.go_Show:set_visible(false)
    if is_detected == 0 then
        ARLOG('sytest-startButton plane_detected')
        scene.lookingFor:set_visible(true)
        scene.lookingForTip:set_visible(true)
        scene.lookingFor:play_frame_animation(-1,0)
    else
        showGuide()
    end
end

function clickScreenEvent()
    -- reset = 0
    showDoor = 1
    can_play = 1
    is_place_status = 0

    scene.ARKitPortal:set_visible(true)
    --scene click event
    scene.palmClickScreen:set_visible(false)
    scene.palmClickScreen:audio():path('/res/media/setDoor.mp3'):repeat_count(1):start()
    scene.ARKitPortal:set_touchable(true)
    scene.initial:set_visible(true)
    initial_id = scene.initial:video():path('/res/media/initial.mp4'):repeat_count(1):reset_texture_when_use_stop(true):on_complete(function ()
        -- if reset == 0 then
        scene.goIntoTip:set_visible(true)
        -- end
        scene.initial:set_visible(false)
        scene.warpGate_outDoor:set_visible(true)
        scene:delete_node_by_name("initial")
    end):start()
    AR:perform_after(1000,function ()
        outDoor_id = scene.warpGate_outDoor:video():path('/res/media/gate.mp4'):repeat_count(-1):reset_texture_when_use_stop(true):start()
        scene.Door:set_visible(true)
        scene.Left_Halfsphere:set_visible(true)
        scene.Left_OpacityWall:set_visible(true)
    end)
    app.device:close_place_status()

    app.device.on_record_state_change = function(record_start)
        io.write('record_start is '..record_start)
        isrecord = record_start
        if isrecord == 1 then
            -- scene.reset:set_visible(false)
            scene.button1:set_visible(false)
            scene.button2:set_visible(false)
            scene.buttonBG:set_visible(false)

        else
            -- scene.reset:set_visible(true)
            scene.button1:set_visible(true)
            scene.button2:set_visible(true)
            scene.buttonBG:set_visible(true)
        end
    end
end

function onRootNodeUpdated(delta)
    if can_play == 0 then
        return
    end
    if is_place_status == 1 then
        return
    end
    if showDoor == 0 then
        return
    end

    local show = isShowSkyBox()

    if show == 0 then
        io.write("syi_status -- 进门 A -> B")
        inTheSkyBox = 1
        inTheSkyBoxShow()

    elseif show == 1 then
        io.write("syi_status -- 出门 B -> A")
        if inTheSkyBox == 1 then
            inTheSkyBox = 0
            scene.Right_Halfsphere:set_visible(false)
            scene.Left_OpacityWall:set_visible(true)
            outSideTheSkyBoxShow()
        end

    elseif show == 4 then
        io.write("syi_status -- 穿墙后-进门 B -> A")
        inTheSkyBox = 1
        inTheSkyBoxShow()
        pierceThroughAWallGoBack()

    elseif show == 5 then
        io.write("syi_status -- 穿墙后-出门 A -> B")
        if inTheSkyBox == 1 then
            inTheSkyBox = 0
            outSideTheSkyBoxShow()
            scene.Right_OpacityWall:set_visible(true)
            scene.Left_Halfsphere:set_visible(false)
            pierceThroughAWall()
        end

    elseif show == 2 then
        if inTheSkyBox == 0 then
            io.write("syi_status----未在天空盒内 穿墙")
            scene.Left_Halfsphere:set_visible(false)
            scene.Right_Halfsphere:set_visible(true)
            scene.Right_OpacityWall:set_visible(true)
            scene.Middle_Halfsphere:set_visible(false)
            scene.Left_OpacityWall:set_visible(false)
            pierceThroughAWall()
            scene.goIntoTip:set_visible(false)
        else
            io.write("syi_status----天空盒中 穿墙")
            scene.Middle_Halfsphere:set_visible(true)
            scene.Left_Halfsphere:set_visible(true)
            scene.Right_Halfsphere:set_visible(true)
            scene.Left_OpacityWall:set_visible(false)
            scene.Right_OpacityWall:set_visible(false)
        end

    elseif show == 3 then
        if inTheSkyBox == 0 then
            io.write("syi_status----未在天空盒内 穿墙返回")
            scene.Right_Halfsphere:set_visible(false)
            scene.Left_Halfsphere:set_visible(true)
            scene.Left_OpacityWall:set_visible(true)
            scene.Middle_Halfsphere:set_visible(false)
            scene.Right_OpacityWall:set_visible(false)
            pierceThroughAWallGoBack()
        else
            io.write("syi_status----天空盒中 穿墙返回")
            scene.Middle_Halfsphere:set_visible(true)
            scene.Left_Halfsphere:set_visible(true)
            scene.Right_Halfsphere:set_visible(true)
            scene.Left_OpacityWall:set_visible(false)
            scene.Right_OpacityWall:set_visible(false)
        end
    end
end

login_id = -1

function isShowSkyBox()
    -- ARLOG("ssssssy: "..inTheSkyBox)
    if can_play == 0 then
        return 0
    end

    local door_pos = Vector3(scene.Door:get_world_position())
    local camera_pos = Vector3(scene.mainCamera:get_world_position())
    -- ARLOG("syD get_world_position door_Z:"..door_pos.z)
    local d_x = tonumber(door_pos.x)
    local d_y = tonumber(door_pos.y)
    local d_z = tonumber(door_pos.z)
    local c_x = tonumber(camera_pos.x)
    local c_y = tonumber(camera_pos.y)
    local c_z = tonumber(camera_pos.z)

    door_obb = scene.Door:get_corners()

    -- A1 是_P2 和 _P7 连线的中心点, A2 是 _P3 和 _P6 连线的中心点
    local A1 = {
        x = door_obb._p2.x,
        z = (door_obb._p2.z + door_obb._p7.z)/2
    }
    local A2 = {
        x = door_obb._p3.x,
        z = (door_obb._p3.z + door_obb._p6.z)/2
    }

    local P2 = {
        x = door_obb._p2.x,
        z = door_obb._p2.z
    }

    local P3 = {
        x = door_obb._p3.x,
        z = door_obb._p3.z
    }

    local P6 = {
        x = door_obb._p6.x,
        z = door_obb._p6.z
    }

    local P7 = {
        x = door_obb._p7.x,
        z = door_obb._p7.z
    }
    -- 门的 OBB (p2,p3,p6,p7)组成的平面中心点
    -- local centerPoint = {
    --     x = (A1.x + A2.x)/2,
    --     z = (A1.z + A2.z)/2
    -- }

    local CToLine = PointToLineDistance(camera_pos,P7,P6)
    local CToLeftLine = PointToLineDistance(camera_pos,P2,P7)
    local CToRightLine = PointToLineDistance(camera_pos,P3,P6)
    -- ARLOG("sycTest -- current CToLine is :"..CToLine..' '..type(CToLine))
    -- ARLOG("sycTest -- current CToLeftLine is :"..CToLeftLine..' '..type(CToLeftLine))
    -- ARLOG("sycTest -- current CToRightLine is :"..CToRightLine..' '..type(CToRightLine))

    if CToLine > 0 and CToLeftLine > 0 and CToRightLine < 0 and login_id == -1 then
        login_id = 1

    elseif CToLine < 0 and CToLeftLine > 0 and CToRightLine < 0 and login_id == -1 then
        login_id = 2

    elseif CToLine > 0 and CToLeftLine < 0 and CToRightLine > 0 and login_id == -1 then
        login_id = 3

    elseif CToLine < 0 and CToLeftLine < 0 and CToRightLine > 0 and login_id == -1 then
        login_id = 4
    end

    local current_position_changed = 0
    if login_id == 1 then
        ARLOG("sycTest -- current PointToLineDistance == +++++++++++ 111111111111")
        if CToLeftLine >= 0 and CToRightLine <= 0 then
            if CToLine >= 0 and current_position ~= OUTDOOR_OUTSIDE then
                current_position = OUTDOOR_OUTSIDE
                current_position_changed = 1
                io.write('sycTest--current_position OUTDOOR_OUTSIDE AAAAAAAAAA +++')

            elseif CToLine < 0 and current_position ~= INDOOR_INSIDE then
                current_position = INDOOR_INSIDE
                current_position_changed = 1
                io.write('sycTest--current_position INDOOR_INSIDE BBBBBBBBBB +++')
            end
        else
            if CToLine < 0 and current_position ~= INDOOR_OUTSIDE then
                current_position = INDOOR_OUTSIDE
                current_position_changed = 1
                io.write('sycTest--current_position -- INDOOR_OUTSIDE CCCCCCCCCCC +++')

            elseif CToLine >= 0 and current_position ~= OUTDOOR_INSIDE then
                current_position = OUTDOOR_INSIDE
                current_position_changed = 1
                io.write('sycTest--current_position -- OUTDOOR_INSIDE DDDDDDDDDDD +++')
            end
        end

    elseif login_id == 2 then

        ARLOG("sycTest -- current PointToLineDistance == --------- 222222222222")
        if CToLeftLine >= 0 and CToRightLine <= 0 then
            if CToLine < 0 and current_position ~= OUTDOOR_OUTSIDE then
                current_position = OUTDOOR_OUTSIDE
                current_position_changed = 1
                io.write('sycTest--current_position OUTDOOR_OUTSIDE AAAAAAAAAA ---')

            elseif CToLine >= 0 and current_position ~= INDOOR_INSIDE then
                current_position = INDOOR_INSIDE
                current_position_changed = 1
                io.write('sycTest--current_position INDOOR_INSIDE BBBBBBBBBB ---')
            end
        else
            if CToLine >= 0 and current_position ~= INDOOR_OUTSIDE then
                current_position = INDOOR_OUTSIDE
                current_position_changed = 1
                io.write('sycTest--current_position INDOOR_OUTSIDE CCCCCCCCCCC ---')

            elseif CToLine < 0 and current_position ~= OUTDOOR_INSIDE then
                current_position = OUTDOOR_INSIDE
                current_position_changed = 1
                io.write('sycTest--current_position OUTDOOR_INSIDE DDDDDDDDDDD ---')
            end
        end

    elseif login_id == 3 then
        ARLOG("sycTest -- current PointToLineDistance == +++++++++++ 3333333333333")
        if CToLeftLine <= 0 and CToRightLine >= 0 then
            if CToLine >= 0 and current_position ~= OUTDOOR_OUTSIDE then
                current_position = OUTDOOR_OUTSIDE
                current_position_changed = 1
                io.write('sycTest--current_position OUTDOOR_OUTSIDE AAAAAAAAAA +++')

            elseif CToLine < 0 and current_position ~= INDOOR_INSIDE then
                current_position = INDOOR_INSIDE
                current_position_changed = 1
                io.write('sycTest--current_position INDOOR_INSIDE BBBBBBBBBB +++')
            end
        else
            if CToLine < 0 and current_position ~= INDOOR_OUTSIDE then
                current_position = INDOOR_OUTSIDE
                current_position_changed = 1
                io.write('sycTest--current_position -- INDOOR_OUTSIDE CCCCCCCCCCC +++')

            elseif CToLine >= 0 and current_position ~= OUTDOOR_INSIDE then
                current_position = OUTDOOR_INSIDE
                current_position_changed = 1
                io.write('sycTest--current_position -- OUTDOOR_INSIDE DDDDDDDDDDD +++')
            end
        end

    elseif login_id == 4 then
        ARLOG("sycTest -- current PointToLineDistance == --------- 444444444444")
        if CToLeftLine <= 0 and CToRightLine >= 0 then
            if CToLine < 0 and current_position ~= OUTDOOR_OUTSIDE then
                current_position = OUTDOOR_OUTSIDE
                current_position_changed = 1
                io.write('sycTest--current_position OUTDOOR_OUTSIDE AAAAAAAAAA ---')

            elseif CToLine >= 0 and current_position ~= INDOOR_INSIDE then
                current_position = INDOOR_INSIDE
                current_position_changed = 1
                io.write('sycTest--current_position INDOOR_INSIDE BBBBBBBBBB ---')
            end
        else
            if CToLine >= 0 and current_position ~= INDOOR_OUTSIDE then
                current_position = INDOOR_OUTSIDE
                current_position_changed = 1
                io.write('sycTest--current_position INDOOR_OUTSIDE CCCCCCCCCCC ---')

            elseif CToLine < 0 and current_position ~= OUTDOOR_INSIDE then
                current_position = OUTDOOR_INSIDE
                current_position_changed = 1
                io.write('sycTest--current_position OUTDOOR_INSIDE DDDDDDDDDDD ---')
            end
        end

    end

    io.write("sy-----:current_position: "..current_position)
    io.write("sy-----:last_position: "..last_position)

    if current_position_changed == 1 then
        if last_position == OUTDOOR_OUTSIDE and current_position == INDOOR_INSIDE then

            if inTheSkyBox == 0 then
                io.write("syc -- 进门 -- AAAAA --> BBBBB")
                current_status = 0
            else
                io.write("syc -- 穿墙后-出门 -- AAAAA --> BBBBB")
                current_status = 5
            end

        elseif last_position == INDOOR_INSIDE and current_position == OUTDOOR_OUTSIDE then

            if inTheSkyBox == 1 then
                io.write("syc -- 出门 -- BBBBB --> AAAAA")
                current_status = 1
            else
                io.write("syc -- 穿墙后-进门 -- BBBBB --> AAAAA")
                current_status = 4
            end

        elseif last_position == OUTDOOR_INSIDE and current_position == INDOOR_OUTSIDE then
            io.write("syc ---穿墙到背面 -- DDDDD --> CCCCC")
            current_status = 2

        elseif last_position == INDOOR_OUTSIDE and current_position == OUTDOOR_INSIDE then
            io.write("syc ---穿墙回正面 -- CCCCC --> DDDDD")
            current_status = 3
        else
            current_status = -1
        end 
        last_position = current_position
    end
    io.write("sy_current_status: "..current_status)
    return current_status
end


function inTheSkyBoxShow()
    -- 在天空盒内显示
    scene.ARKitPortal:set_touchable(false)
    showInside()
    scene.goIntoTip:set_visible(false)
    scene.Left_Halfsphere:set_visible(true)
    scene.Right_Halfsphere:set_visible(true)
    scene.Middle_Halfsphere:set_visible(true)
    scene.Left_OpacityWall:set_visible(false)
    scene.Right_OpacityWall:set_visible(false)
    -- scene.Left_MDoor:set_visible(true)
    AR:perform_after(500,function ()
        scene.Right_MDoor:set_visible(true)
    end)
end

function outSideTheSkyBoxShow()
    -- 在天空盒外显示
    AR:perform_after(1000,function ()
        scene.Right_MDoor:set_visible(false)
    end)
    -- stop_skybox_bgMusic()
    scene.Middle_Halfsphere:set_visible(false)
    -- scene.Left_MDoor:set_visible(false)
    -- ARLOG("now_AlphaDoorShow: 此时透明门消失")
    scene.ARKitPortal:set_touchable(true)
end

function showInside()
    -- ARLOG("sy--test:进入天空盒啦")
    if inSkyBoxTip_show then
        showGoAroundTips()
        inSkyBoxTip_show = false
    end
    -- ARLOG("sy--test:文案显示结束")
    -- ARLOG("sy--test: inDoorMusic_id = "..inDoorMusic_id)
    -- if inDoorMusic_id == 0 then
    --     start_skybox_bgMusic()
    -- end
end

-- function start_skybox_bgMusic()
--     AR:perform_after(100, function()
--         inDoorMusic = scene.Door:audio():path('/res/media/inDoor.mp3'):repeat_count(-1):start()
--     end)
--     inDoorMusic_id = 1
-- end

-- function pause_skybox_bgMusic()
--     inDoorMusic:pause()
--     inDoorMusic_id = 2
-- end

-- function resume_skybox_bgMusic()
--     inDoorMusic:resume()
-- end

-- function stop_skybox_bgMusic()
--     if inDoorMusic_id == 1 then
--         inDoorMusic:stop()
--         inDoorMusic_id = 0
--     end
-- end

function showGoAroundTips()
    scene.goAroundTip:set_visible(true)

    AR:perform_after(3000,function ()
        scene.goAroundTip:set_visible(false)
    end)
end


-- function clickRestartScene()
--     io.write("sytest:click reset")
--     if showDoor == 1 then
--         reset = 1
--         isComeIn = false
--         showDoor = 0
--         can_play = 0
--         is_detected = 0
--         is_place_status = 1
--         inSkyBoxTip_show = true
--         stop_skybox_bgMusic()
--         startButtonClick()
        
--         -- app.device:close_place_status()
--         app.device:restart_status()
--         -- local camera_pos = Vector3(scene.mainCamera:get_world_position())
--         -- local camera_pos_x = tonumber(camera_pos.x)
--         scene.ARKitPortal.position = Vector3(0,-0.6,-2)
--         scene.ARKitPortal:set_visible(false)
--         scene.ARKitPortal:set_touchable(false)
--         scene.Door:set_visible(false)
--         scene.Left_MDoor:set_visible(false)
--         scene.Right_MDoor:set_visible(false)
--         scene.Left_Halfsphere:set_visible(false)
--         scene.Left_OpacityWall:set_visible(false)
--         scene.Middle_Halfsphere:set_visible(false)
--         scene.Right_Halfsphere:set_visible(false)
--         scene.Right_OpacityWall:set_visible(false)
--         scene.warpGate_outDoor:set_visible(false)
--         scene.warpGate_inDoor:set_visible(false)
--         scene.initial:set_visible(false)
--         scene.goIntoTip:set_visible(false)
--         scene.reset:set_visible(false)
--         scene.button1:set_visible(false)
        -- scene.button1Text:set_visible(false)
--         -- scene.root:reset_rts()
--         inDoor_id:stop()
--         outDoor_id:stop()
--         initial_id:stop()
--         app.device:start_place_status()
--     end
-- end

function showGuide()
    scene.palmClickScreen:set_visible(true)
    scene.alphaImage:set_visible(true)
    scene.alphaImage.on_click = function ()
        ARLOG("sytest:aplha Image is clicked")
        if is_detected == 0 then
            return
        end
        clickScreenEvent()
        scene.alphaImage:set_visible(false)
        scene.palmClickScreen:set_visible(false)
        -- scene.reset:set_visible(true)
        -- scene.reset.on_click = clickRestartScene
        scene.button1:set_visible(true)
        -- scene.button1Text:set_visible(true)
        scene.button1.on_click = function ()
            app:open_url(seturl1)
        end
        scene.button2:set_visible(true)
        scene.button2.on_click = function ()
            app:open_url(seturl2)
        end
        scene.buttonBG:set_visible(true)
        
    end
end

function pierceThroughAWall()
    scene.warpGate_outDoor:set_visible(false)
    scene.warpGate_inDoor:set_visible(true)
    inDoor_id = scene.warpGate_inDoor:video():path('/res/media/gate.mp4'):repeat_count(-1):reset_texture_when_use_stop(true):start()
end

function pierceThroughAWallGoBack()
    scene.warpGate_outDoor:set_visible(true)
    scene.warpGate_inDoor:set_visible(false)
end

function PointToLineDistance(Point,lineP1,lineP2)
    -- 点到线的距离
    -- Point 初始点,一般为当前相机位置
    -- lineP1 线上任意一点
    -- lineP2 线上任意一点
    -- return 可得到Point 距离 lineP1与lineP2 两点连线 的长度
    -- return 单位number
    -- sample: local distance = PointToLineDistance(Point,lineP1,lineP2)

    local x1 = lineP1.x
    local z1 = lineP1.z
    local x2 = lineP2.x
    local z2 = lineP2.z
    ARLOG("current xz = "..x1.." "..z1.." "..x2.." "..z2)

    --  x + ky -d = 0
    local k = (x1-x2)/(z2-z1)
    local d = x1 + (x1-x2)/(z2-z1)*z1
    -- local lineEquation = Point.x + k*Point.z - d
    return Point.x + k*Point.z - d
    -- ARLOG("sycTest -- current lineEquation is zzz:"..lineEquation)
end

function SpaceTwoPointDistance(point1,point2)
    -- 空间两点之间的距离
    return math.sqrt((point1.x-point2.x)*(point1.x-point2.x)+(point1.z-point2.z)*(point1.z-point2.z))
    -- ARLOG("sySpaceTwoPointDistance:"..distance)
end

-- lua 打印完整table
function print_r(t)  
    local print_r_cache={}
    local function sub_print_r(t,indent)
        if (print_r_cache[tostring(t)]) then
            print(indent.."*"..tostring(t))
        else
            print_r_cache[tostring(t)]=true
            if (type(t)=="table") then
                for pos,val in pairs(t) do
                    if (type(val)=="table") then
                        print(indent.."["..pos.."] => "..tostring(t).." {")
                        sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
                        print(indent..string.rep(" ",string.len(pos)+6).."}")
                    elseif (type(val)=="string") then
                        print(indent.."["..pos..'] => "'..val..'"')
                    else
                        print(indent.."["..pos.."] => "..tostring(val))
                    end
                end
            else
                print(indent..tostring(t))
            end
        end
    end
    if (type(t)=="table") then
        print(tostring(t).." {")
        sub_print_r(t,"  ")
        print("}")
    else
        sub_print_r(t,"  ")
    end
    print()
end
table.print = print_r



