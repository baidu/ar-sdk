-- Filter.lua --
function LOAD_FILTER()

Filter = {}

-- 滤镜的数据集合
FilterAdjustData = {}

-- 开始滤镜组，加载json中的start的滤镜
Filter.start = function(self)
    local mapData = ae.MapData:new()
    mapData:put_int("action",MSG_TYPE_FILTER_START)
    mapData:put_string("file_path", "/res/filter_config.json")
    lua_handler:send_message_tosdk(mapData)
    mapData:delete()
end

-- 更新滤镜组：需要指定更新到某一个滤镜id
Filter.update = function(self,filter_group_id)
    if filter_group_id == nil then 
        ARLOG("filter id is null")
        return
    end

    local mapData = ae.MapData:new()
    mapData:put_int("action", MSG_TYPE_FILTER_UPDATE)
    mapData:put_string("filter_group_id", filter_group_id)
    lua_handler:send_message_tosdk(mapData)
    mapData:delete()
end

-- 关闭滤镜
Filter.stop = function(self)
    local mapData = ae.MapData:new()
    mapData:put_int("action",MSG_TYPE_FILTER_STOP)
    lua_handler:send_message_tosdk(mapData)
    mapData:delete()
end

-- 将filter_config.json中的某一个滤镜组设置为disable的状态 当切换到这个滤镜组的时候将不会有效果
Filter.disable_filter_group = function(self,filter_group_id,disable)
    ARLOG("disable_filter_group")

    local mapData = ae.MapData:new()
    mapData:put_int("action",MSG_TYPE_FILTER_DISABLE_TECHNIQUE)
    mapData:put_string("filter_group_id", filter_group_id)
    mapData:put_string("disable",disable)
    lua_handler:send_message_tosdk(mapData)
    mapData:delete()
end

-- 屏蔽滤镜中某一层的滤镜组(params：指定id，目标，是否关闭）
Filter.disable_target = function(self,filter_group_id,target,disable)
    if filter_group_id == nil then 
        ARLOG("filter_group_id id is null")
        return
    end

    if target == nil then
        ARLOG("filter target is null")
        return
    end

    if disable == nil then
        disable = 0
    end

    local mapData = ae.MapData:new()
    mapData:put_int("action", MSG_TYPE_FILTER_DISABLE_TARGET)
    mapData:put_string("filter_group_id", filter_group_id)
    mapData:put_string("target", target)
    mapData:put_string("disable",disable)
    lua_handler:send_message_tosdk(mapData)
    mapData:delete()

end

-- 在某一个滤镜的滤镜组中更新一个滤镜 (params:滤镜组id，目标，滤镜参数)
Filter.update_pass = function(self,filter_group_id,target,pass)
    ARLOG("reset")
    if filter_group_id == nil then 
        ARLOG("filter id is null")
        return
    end

    if target == nil then
        target = ""
    end

    local mapData = ae.MapData:new()
    mapData:put_int("action", MSG_TYPE_FILTER_RESET)
    mapData:put_int("reset_type",ResetType.update)
    mapData:put_string("filter_group_id", filter_group_id)
    mapData:put_string("target", target)
    mapData:put_map_data("pass",pass)
    lua_handler:send_message_tosdk(mapData)
    mapData:delete()

end

-- 在某一个滤镜组中增加一个滤镜 (params:滤镜组id，目标，滤镜参数)
Filter.add_pass = function(self,filter_group_id,target,pass)
    ARLOG("add_pass")
    if filter_group_id == nil then 
        ARLOG("filter_group_id id is null")
        return
    end

    if target == nil then
        target = ""
    end

    local mapData = ae.MapData:new()
    mapData:put_int("action", MSG_TYPE_FILTER_RESET)
    mapData:put_int("reset_type",ResetType.add)
    mapData:put_string("filter_group_id", filter_group_id)
    mapData:put_string("target", target)
    mapData:put_map_data("pass",pass)
    lua_handler:send_message_tosdk(mapData)
    mapData:delete()

end

-- 在某一个滤镜组中删除一个滤镜：(params:滤镜id，目标，滤镜id)
Filter.delete_pass = function(self,filter_group_id,target,pass_id)
    ARLOG("reset")
    if filter_group_id == nil then 
        ARLOG("filter id is null")
        return
    end

    if target == nil then
        target = ""
    end

    local pass = ae.MapData:new()
    pass:put_string("pass_id", pass_id)

    local mapData = ae.MapData:new()
    mapData:put_int("action", MSG_TYPE_FILTER_RESET)
    mapData:put_int("reset_type",ResetType.delete)
    mapData:put_string("filter_group_id", filter_group_id)
    mapData:put_string("target", target)
    mapData:put_map_data("pass",pass)
    lua_handler:send_message_tosdk(mapData)
    mapData:delete()

end

-- 滤镜调节：颜色，饱和度，锐度等(只能调整当前滤镜)  adjustType 默认是float类型
Filter.adjust = function(self,target,pass_id,data)
    ARLOG("ADJUST")
    if adjustType == nil then
        adjustType = AdjustType.float
    end

    local mapData = ae.MapData:new()
    mapData:put_int("action", MSG_TYPE_FILTER_ADJUST)
    mapData:put_string("target",target)
    mapData:put_string("pass_id",pass_id)
    mapData:put_map_data("adjust_params",data)
    lua_handler:send_message_tosdk(mapData)
    mapData:delete()
end

--  获取一个 int 类型滤镜数据
FilterAdjustData.put_int = function(self,key,value)
    local mapData = ae.MapData:new()
    mapData:put_int("adjust_value_type", AdjustType.int)
    mapData:put_string("adjust_key", key)
    mapData:put_string("adjust_value", value)
    return  mapData
end

-- 获取一个 float 类型滤镜数据
FilterAdjustData.put_float = function(self,key,value)
    local mapData = ae.MapData:new()
    mapData:put_int("adjust_value_type", AdjustType.float)
    mapData:put_string("adjust_key", key)
    mapData:put_string("adjust_value", value)
    return  mapData
end

-- 获取一个 point 类型滤镜数据 ：形如"1，1，1"的字符串
FilterAdjustData.put_point = function(self,key,value)
    local mapData = ae.MapData:new()
    mapData:put_int("adjust_value_type", AdjustType.int)
    mapData:put_string("adjust_key", key)
    mapData:put_string("adjust_value", value)
    return  mapData
end

-- 获取一个 vec3 类型滤镜数据 ：形如"1，1，1"的字符串
FilterAdjustData.put_vec3 = function(self,key,value)
    local mapData = ae.MapData:new()
    mapData:put_int("adjust_value_type", AdjustType.float)
    mapData:put_string("adjust_key", key)
    mapData:put_string("adjust_value", value)
    return  mapData
end

-- 获取一个 vec4 类型滤镜数据 ：形如"1，1，1，4"的字符串
FilterAdjustData.put_vec4 = function(self,key,value)
    local mapData = ae.MapData:new()
    mapData:put_int("adjust_value_type", AdjustType.int)
    mapData:put_string("adjust_key", key)
    mapData:put_string("adjust_value", value)
    return  mapData
end

-- 获取一个 size 类型滤镜数据集合 ：形如"200,400"的字符串
FilterAdjustData.put_map_data = function(self,key,value)
    local mapData = ae.MapData:new()
    mapData:put_int("adjust_value_type", AdjustType.size)
    mapData:put_string("adjust_key", key)
    mapData:put_string("adjust_value", value)
    return  mapData
end

-- 获取一个 map 类型滤镜数据集合 ：可以存入多个filterData
FilterAdjustData.put_map_data = function(...)
    local mapData = ae.MapData:new()
    mapData:put_int("adjust_value_type", AdjustType.map)
    mapData:put_string("adjust_key", "mapData")

    local subMap = ae.MapData:new()
    local arg={...}
    for i,v in ipairs(arg) do
        subMap:put_map_data(i,v)
    end
    mapData:put_map_data("adjust_value",subMap)
    return  mapData
end

-- 获取一个 mat3 类型滤镜数据集合 ：形如"0,0,0,0,0,0,0,0,0"的字符串
FilterAdjustData.put_mat3 = function(self,key,value)
    local mapData = ae.MapData:new()
    mapData:put_int("adjust_value_type", AdjustType.mat3)
    mapData:put_string("adjust_key", key)
    mapData:put_string("adjust_value", value)
    return  mapData
end

-- 获取一个 mat4 类型滤镜数据集合 ：形如"0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"的字符串
FilterAdjustData.put_mat4 = function(self,key,value)
    local mapData = ae.MapData:new()
    mapData:put_int("adjust_value_type", AdjustType.mat4)
    mapData:put_string("adjust_key", key)
    mapData:put_string("adjust_value", value)
    return  mapData
end

end

LOAD_FILTER()

-- Filter.lua end --
