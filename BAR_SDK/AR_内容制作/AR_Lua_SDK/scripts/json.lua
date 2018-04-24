-- json_parser.lua --
function LOAD_JSON()

    JSONNODE = {

    TYPE_OBJECT = 0,
    TYPE_ARRAY = 1,
    TYPE_UNKNOWN = 2,

    __call = function (self, type, instance)
        local jsonobject = {
            _type = JSONNODE.TYPE_OBJECT,
            _ins = nil,

            get_ins = function(self)
                return self._ins
            end,

            set_ins_nil = function(self)
                self._ins = nil
            end,

            is_object = function(self)
                return self._type == JSONNODE.TYPE_OBJECT
            end,

            is_array = function(self)
                return self._type == JSONNODE.TYPE_ARRAY
            end
        }
     jsonobject._type = type
     jsonobject._ins = instance
     return jsonobject
     end
    }
    setmetatable(JSONNODE,JSONNODE)

	JsonHandler = {}
    -- 解析json的接口
	JsonHandler.parse = function(self,data)

        if (data == nil)  then
             ARLOG("LuaJson parse error: input param data is nil!!!")
             return nil
        end

        local json_root = ae.LuaJsonParser:parse(data)

        if (json_root == nil) then
            ARLOG("LuaJson parse error: data is not a json string!!!")
        end

        local  node = JSONNODE(JSONNODE.TYPE_OBJECT, json_root)
        return node
	end

	JsonHandler.get_object = function(self, object, object_name)

        if (object == nil or object:get_ins() == nil or object_name == nil) then
             ARLOG("LuaJson get_object error: input param is nil!!!")
             return nil
        end

        local node_ins = ae.LuaJsonParser:get_object_item(object:get_ins(), object_name)
        local  node = JSONNODE(JSONNODE.TYPE_UNKNOWN, node_ins)
        return node
	end

    JsonHandler.if_has_object = function(self, object, object_name)
        if (object == nil or object:get_ins() == nil or object_name == nil) then
             ARLOG("LuaJson if_has_object error: input param is nil!!!")
             return false
        end
        return ae.LuaJsonParser:has_object_item(object:get_ins(),object_name)
    end
 
    JsonHandler.get_array_object_size = function(self, object)
        if (object == nil or object:get_ins() == nil) then
             ARLOG("LuaJson get_array_object_size error: input param json object is nil!!!")
             return -1
        end
        return ae.LuaJsonParser:get_array_size(object:get_ins())
    end

    JsonHandler.get_object_by_index = function(self, object, index)
        if (object == nil or object:get_ins() == nil or index == nil) then
             ARLOG("LuaJson get_object_by_index error: input param is nil!!!")
             return nil
        end

        local node_ins = ae.LuaJsonParser:get_array_item(object:get_ins(), index)
        local  node = JSONNODE(JSONNODE.TYPE_UNKNOWN, node_ins)
        return node
    end

   JsonHandler.get_int_value = function(self, object, key)

        if (object == nil or object:get_ins() == nil or key == nil) then
             ARLOG("LuaJson get_int_value error: input param is nil!!!")
             return 0
        end

        return ae.LuaJsonParser:get_object_item_int_value(object:get_ins(), key)
    end

    JsonHandler.get_double_value = function(self, object, key)

        if (object == nil or object:get_ins() == nil or key == nil) then
             ARLOG("LuaJson get_double_value error: input param is nil!!!")
             return 0
        end
        return ae.LuaJsonParser:get_object_item_double_value(object:get_ins(), key)
    end

    JsonHandler.get_string_value = function(self, object, key)

        if (object == nil or object:get_ins() == nil or key == nil) then
             ARLOG("LuaJson get_string_value error: input param is nil!!!")
             return ""
        end
        return ae.LuaJsonParser:get_object_item_string_value(object:get_ins(), key)
    end

    --创建json的接口
    JsonHandler.create_object = function(self)
        local node_ins = ae.LuaJsonParser:create_object()
        local node = JSONNODE(JSONNODE.TYPE_OBJECT, node_ins)
        return node
    end

    JsonHandler.create_array_object = function(self)

        local node_ins = ae.LuaJsonParser:create_array()
        local node = JSONNODE(JSONNODE.TYPE_ARRAY, node_ins)
        return node
    end

    JsonHandler.add_object_to_object = function(self, object, key, sub_object)
        if (object == nil or sub_object == nil or object:get_ins() == nil or sub_object:get_ins() == nil or key == nil) then
             ARLOG("LuaJson add_object_to_object error: input param is nil!!!")
             return
        end

        if (object:get_ins() == sub_object:get_ins()) then
             ARLOG("LuaJson add_object_to_object error: two objects are same, add operation fail!!!")
             return
        end

        ae.LuaJsonParser:add_item_to_object(object:get_ins(), key, sub_object:get_ins(), 1)
    end
 
    JsonHandler.add_string_to_object = function(self, object, key, value)

        if (object == nil or object:get_ins() == nil or key == nil or value == nil) then
             ARLOG("LuaJson add_string_to_object error: input param is nil!!!")
             return
        end
        ae.LuaJsonParser:add_string_to_object(object:get_ins(), key, value)
    end

    JsonHandler.add_number_to_object = function(self, object, key, value)
        if (object == nil or object:get_ins() == nil or key == nil or value == nil) then
             ARLOG("LuaJson add_number_to_object error: input param is nil!!!")
             return
        end
        ae.LuaJsonParser:add_number_to_object(object:get_ins(), key, value)
    end

    JsonHandler.add_object_to_array = function(self, array_object, sub_object)

        if (array_object == nil or sub_object == nil or array_object:get_ins() == nil or sub_object:get_ins() == nil) then
             ARLOG("LuaJson add_object_to_array error: input param json object is nil!!!")
             return
        end
        if (array_object:get_ins() == sub_object:get_ins()) then
             ARLOG("LuaJson add_object_to_array error: two objects are same, add operation fail!!!")
             return
        end

        if (not array_object:is_array()) then
             ARLOG("LuaJson add_object_to_array error: first object is not a array object, add operation fail!!!")
             return
        end
        ae.LuaJsonParser:add_item_to_array(array_object:get_ins(), sub_object:get_ins(), 1)
    end

    JsonHandler.print = function(self, object)

        if (object == nil or object:get_ins() == nil) then
             ARLOG("LuaJson print error: input param json object is nil!!!")
             return ""
        end
        return ae.LuaJsonParser:print(object:get_ins(), 0)
    end

    JsonHandler.delete_object = function(self, object)
        if (object == nil or object:get_ins() == nil) then
            ARLOG("LuaJson delete_object error: input param json object is nil!!!")
            return
        end
        ae.LuaJsonParser:delete_root(object:get_ins())
        object:set_ins_nil()
    end

end


LOAD_JSON()

-- json_parser.lua end --
