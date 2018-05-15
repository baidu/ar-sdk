-- utils.lua --
function LOAD_UTILS()
	function ARLOG(line)
		io.write('[LUA-LOG] '..line)
	end

	function DELOG(line)
		local lua_h = AR.current_application:get_lua_handler()
		local mapData = ae.MapData:new()
		mapData:put_int("id", MST_TYPE_REMOTE_DELOG_SEND)
		mapData:put_string("log", line)
		lua_handler:send_message_tosdk(mapData)
		mapData:delete()
	end

	function DEBUG(line)
		if lua_handler == nil then

		else
			local mapData = ae.MapData:new() 
			mapData:put_int("id", MST_TYPE_REMOTE_DEBUG_SEND) 
			mapData:put_string("log", line)
			lua_handler:send_message_tosdk(mapData)
			mapData:delete()
		end
	end

	function NOP_FUNC(...)
		ARLOG('nop_func called')
	end

	function F_GENERATOR()
		FUNC_NAME_INDEX = 0
		return function()
			FUNC_NAME_INDEX = FUNC_NAME_INDEX+1
			return "BAR_ANONYMOUS_FUNC_"..FUNC_NAME_INDEX
		end
	end
	FNAME = F_GENERATOR()

	function RES_CLOSURE(func)
		RANDOM_NAME = FNAME()
		GLOBALFUNC = func
		loadstring(RANDOM_NAME.."=GLOBALFUNC")()
		return RANDOM_NAME
	end

	function VERSION_LOWER_8_5()
		if(ae.ARApplicationController ~= nil) then
			return false
		else
			return true
		end
	end


	function REOMVE_SPECIAL_SYMBOL(str,remove)  
	    local lcSubStrTab = {}  
	    while true do  
	        local lcPos = string.find(str,remove)  
	        if not lcPos then  
	            lcSubStrTab[#lcSubStrTab+1] =  str      
	            break  
	        end  
	        local lcSubStr  = string.sub(str,1,lcPos-1)  
	        lcSubStrTab[#lcSubStrTab+1] = lcSubStr  
	        str = string.sub(str,lcPos+1,#str)  
	    end  
	    local lcMergeStr =""  
	    local lci = 1  
	    while true do  
	        if lcSubStrTab[lci] then  
	            lcMergeStr = lcMergeStr .. lcSubStrTab[lci]   
	            lci = lci + 1  
	        else   
	            break  
	        end  
	    end  
	    return lcMergeStr  
	end 

	function string:split(sep)
	   local sep, fields = sep or ":", {}
	   local pattern = string.format("([^%s]+)", sep)
	   self:gsub(pattern, function(c) fields[#fields+1] = c end)
	   return fields
	end

	function IN_ARRAY(key, arr)
		if not arr then
			return false
		end
		for k, v in pairs(arr) do
			if(v == key) then
				return true
			end
		end
		return false
	end

	ARLOG('load util')
end

LOAD_UTILS()
--  utils.lua end -- 
