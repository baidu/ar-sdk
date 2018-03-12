-- node_material.lua -- 
function LOAD_MATERIAL()
	Material = {
		__call = function(self, entity)
			local material = {
				_entity = nil, 
				_scalar_key = {"roughness", "metalness", "clearCoat", "clearCoatRoughness", 
					"reflectivity","refractionRatio", "emissiveIntensity", "shininess", "opacity",
					"aoMapIntensity", "lightMapIntensity", "envMapIntensity", "emissiveIntensity", 
					"displacementScale", "displacementBias", "bumpScale",
					has = function(self, key)
						for k, v in pairs(self) do
							if(v == key) then
								return true
							end
						end
						return false
					end
					},
				_vector_key = {"offsetRepeat", "normalScale", "diffuse", "specular", "emissive",
					has = function(self, key)
						for k, v in pairs(self) do
							if(v == key) then
								return true
							end
						end
						return false
					end
				},
				__newindex = function(self, key, value)
					if(self._scalar_key:has(key)) then
						if(self._entity == nil) then
							return
						end
						self._entity:set_material_property(key, value)

					elseif(self._vector_key:has(key)) then
						if(self._entity == nil) then
							return
						end
						self._entity:set_material_vector_property(key, value)
					else
						ARLOG("material property setter error")
						rawset(self, key, value)
					end
				end
			}
			material._entity = entity
			setmetatable(material, material)
			return material
		end
	}
	setmetatable(Material, Material)
end

LOAD_MATERIAL()

-- node_material end --

