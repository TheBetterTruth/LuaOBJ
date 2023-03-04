_G.object = {
	_pcVIsInstance = false,
	_pcVType = "object",
	_pcVInherits = {},
	_pcVConstructor = function(self) end,
    _pcVBaseConstructors = {},
	_pcVFuncs = {},
    _pcVFields =  {}
}

object._pcVFuncs.equals = function(self, target)
	if not target._pcVIsInstance then error("Expected object instance, got meta class for '" + self.pcVType + "#equals(target)'") end
	if target._pcVType ~= self._pcVType then return false end
	
	local selfLen = 0
	for k, v in pairs(self) do selfLen = selfLen + 1 end
	
	local tarLen = 0
	for k, v in pairs(target) do tarLen = tarLen + 1 end
	
	if selfLen ~= tarLen then return false end
	
	for k, v in pairs(self) do
		if target[k] ~= self[k] then return false end
	end
	
	return true
end
object._pcVFuncs.getType = function(self)
	return self._pcVType
end
object._pcVFuncs.instanceOf = function(self, class)
	if class._pcVIsInstance then error("Expected meta class, got instance for '" + self.pcVType + "#instanceOf(target)'") end
	
	for k, v in pairs(self._pcVInherits) do
		if v == class._pcVIsInstance then return true end
	end
	
	return false
end

function object:new(...)
	local tmp = {}
	
    for k, v in pairs(self._pcVFields) do
        tmp[k] = v
    end

    for k, v in pairs(self._pcVFuncs) do
		tmp[k] = function(...)
			return v(tmp, ...)
		end
	end

	for k, v in pairs(self) do
        if k == "_pcVIsInstance" or k == "_pcVType" or k == "_pcVInherits" then
            tmp[k] = v
		elseif k ~= "new" or k ~= "_pcVConstructor" or k ~= "_pcVFields" then
		    tmp[k] = function(...) return v(tmp, ...) end
        end
	end
	
	tmp._pcVIsInstance = true

	local constructors = {}

	for i=1,#self._pcVBaseConstructors do
		constructors[i] = self._pcVBaseConstructors[i]
	end

    tmp.base = function(...)
		local const = constructors[#constructors]
		table.remove(constructors, #constructors)

		const(tmp, ...)
	end

	self._pcVConstructor(tmp, ...)
	return tmp
end
function object:inherit(objName, meta, constructor)
	local tmp = {}
	
	for k, v in pairs(self) do
		tmp[k] = v
	end
	
	tmp._pcVType = objName
	table.insert(tmp._pcVInherits, self._pcVType)
    
    for i=0,#self._pcVBaseConstructors do
        tmp._pcVBaseConstructors[i] = self._pcVBaseConstructors[i]
    end
    table.insert(tmp._pcVBaseConstructors, self._pcVConstructor)
	tmp._pcVConstructor = function(self, ...) constructor(self, ...) end
	
	for k, v in pairs(meta) do
		tmp._pcVFields[k] = v
	end
	
	_G[objName] = tmp
end