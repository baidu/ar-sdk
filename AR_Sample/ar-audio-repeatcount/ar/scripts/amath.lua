-- amath.lua -- 
function LOAD_MATH()
	Vector3 = {
		__add = function(self, other_vec3)
			local new_vec3 = Vector3("0,0,0")
			new_vec3.x = self.x + other_vec3.x
			new_vec3.y = self.y + other_vec3.y
			new_vec3.z = self.z + other_vec3.z
			return new_vec3
		end,
		__sub = function(self, other_vec3)
			local new_vec3 = Vector3("0,0,0")
			new_vec3.x = self.x - other_vec3.x
			new_vec3.y = self.y - other_vec3.y
			new_vec3.z = self.z - other_vec3.z
			return new_vec3
		end,
		__unm = function(self)
			local new_vec3 = Vector3("0,0,0")
			new_vec3.x = -self.x
			new_vec3.y = -self.y
			new_vec3.z = -self.z
			return new_vec3
		end,
		__mul = function(self, scalar)
			local new_vec3 = Vector3("0,0,0")
			new_vec3.x = self.x * scalar
			new_vec3.y = self.y * scalar
			new_vec3.z = self.z * scalar
			return new_vec3
		end,
		__div = function(self, scalar)
			local new_vec3 = Vector3("0,0,0")
			new_vec3.x = self.x / scalar
			new_vec3.y = self.y / scalar
			new_vec3.z = self.z / scalar
			return new_vec3
		end,
		__call = function(self, ...)
			local arg = { ... }
			param = arg[1]
			local vec3 = {}
			vec3.x = 0
			vec3.y = 0
			vec3.z = 0
			vec3.encode = function(self)
				return tostring(self.x)..','..tostring(self.y)..','..tostring(self.z)
			end

			setmetatable(vec3, self)
			if (type(param) == 'string') and (#arg == 1) then
				local arr = param:split(',')
				if #arr ~= 3 then
					vec3.x = 0
					vec3.y = 0
					vec3.z = 0
					return vec3	
				end
				vec3.x = arr[1]
				vec3.y = arr[2]
				vec3.z = arr[3]
				return vec3
			end

			if (#arg == 3) then
				vec3.x = arg[1]
				vec3.y = arg[2]
				vec3.z = arg[3]
				return vec3
			end

			return vec3
		end,
		__tostring = function(self)
			return 'x:'..tostring(self.x)..', y:'..tostring(self.y)..', z:'..tostring(self.z)
		end
	}
	setmetatable(Vector3, Vector3)

	ARLOG('load amath')
end
LOAD_MATH()
-- amath.lua end --

