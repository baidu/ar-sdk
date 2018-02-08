-- scene.lua --
function CREATE_SCENE()
	local NEW_SCENE = {}
	NEW_SCENE.application = 0
	setmetatable(NEW_SCENE, NEW_SCENE)
	NEW_SCENE.__index = function(self, key)
		if(self.entity[key] == nil) then
			local node = GET_NODE(self, key)
			if (node == nil) then
				ARLOG('尝试调用ar_scene的'..key..' 方法/属性, 该方法/属性不存在')
				return NOP_FUNC
			else
				return node
			end
		else
			__F_FUNC = function(self, ...)
				__BACK_FUNC = self.entity[key]
				return __BACK_FUNC(self.entity, ...)
			end
			return __F_FUNC
		end
	end
	return NEW_SCENE
end
ARLOG('load scene maker')
-- scene.lua end --
