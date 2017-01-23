function saveTabelToFile(value, filename)
	local file,err = io.open( filename, "wb" )

	if err then 
		print(err)
		return err 
	end

    local lookupTable = {}
    local result = {}

    local function _v(v)
        if type(v) == "string" then
            v = "\"" .. v .. "\""
        end
        return tostring(v)
    end

    local function _key(v)
    	return "[" .. v .. "]"
    end

    local function _saveTabelToFile(value, key, indent, nest, keylen)
        spc = ""
        if type(keylen) == "number" then
            spc = string.rep(" ", keylen - string.len(_v(key)))
        end
        if type(value) ~= "table" then
            result[#result +1 ] = string.format("%s%s%s = %s,", indent, _key(_v(key)), spc, _v(value))
        -- elseif lookupTable[value] then
        --     result[#result +1 ] = string.format("%s%s%s = *REF*", indent, key, spc)
        else
            lookupTable[value] = true
            if not key then
            	result[#result +1 ] = "return {"
            else
            	result[#result +1 ] = string.format("%s%s = {", indent, _key(_v(key)))
            end

            
            local indent2 = indent.."    "
            local keys = {}
            local keylen = 0
            local values = {}
            for k, v in pairs(value) do
                keys[#keys + 1] = k
                local vk = _v(k)
                local vkl = string.len(vk)
                if vkl > keylen then keylen = vkl end
                values[k] = v
            end
            table.sort(keys, function(a, b)
                if type(a) == "number" and type(b) == "number" then
                    return a < b
                else
                    return tostring(a) < tostring(b)
                end
            end)
            for i, k in ipairs(keys) do
                _saveTabelToFile(values[k], k, indent2, nest + 1, keylen)
            end
            if not key then
            	result[#result +1] = string.format("%s}", indent)
            else
            	result[#result +1] = string.format("%s},", indent)
            end
        end
    end
    _saveTabelToFile(value, key, "  ", 1)

    local str = table.concat(result,"\n")
    file:write(str)
    file:close()

end
