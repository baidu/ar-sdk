-- particle_system.lua -- 
function LOAD_PARTICLE_SYSTEM()
	ParticleSystem = {
		__call = function(self, entity)
			local particle_system = {
				_entity = nil, 
				_vector_key = { "emit_particle", "emitter_position",
							   	"emitter_rotation_axis", "emitter_rotation_axis_variance",
								"emitter_rotation_angle_min","emitter_rotation_angle_max",
								"shape_strectch_scale", "emit_status",
								"emission_rate", "particle_stretch_scale",
								"particle_velocity", "particle_velocity_var",
								"particle_acceleration", "particle_acceleration_var",
								"particle_size", "particle_color_start",
								"particle_color_start_var", "particle_color_end",
								"particle_color_end_var", "spin_angle_min",
								"spin_angle_max",
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
					if(self._vector_key:has(key)) then
						if(self._entity == nil) then
							return
						end
						self._entity:set_particle_system_property(key, value)
					else
						ARLOG("particle system property setter error")
						rawset(self, key, value)
					end
				end
			}
			particle_system._entity = entity
			setmetatable(particle_system, particle_system)
			return particle_system
		end
	}
	setmetatable(ParticleSystem, ParticleSystem)
end

LOAD_PARTICLE_SYSTEM()

-- particle_system end --
