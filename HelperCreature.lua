HelperCreature = {}
HelperCreature.__index = HelperCreature

function HelperCreature.new()
    local self = setmetatable({}, HelperCreature)
    return self
end

function HelperCreature:getCreatureInRange(from, to, callback)
    callback = callback or nil
    local creatures = {}
    for x = from.x - 1, to.x + 1 do
		for y = from.y - 1, to.y + 1 do
			local creatureId = getTopCreature({x = x, y = y, z = from.z}).uid
			if creatureId ~= 0 and callback then
                callback(creatureId, creatures)
            end
		end
	end
    return creatures
end                                                          

function HelperCreature:getCreatureInRangeNames(from, to)
    local creaturesName = self:getCreatureInRange(from, to, function(uid, t) 
        table.insert(t, getCreatureName(uid)) 
    end)
    return table.concat(creaturesName, ",")
end

function HelperCreature:getCreatureMoreHealthInRange(from, to)
    local creatures = self:getCreatureInRange(from, to, function(uid, t) 
        table.insert(t, {
            creatureId = uid,
            health = getCreatureHealth(uid)
        }) 
    end)
    return HTable:sortBy(creatures, function(a, b) 
        return a.health < b.health
    end)
end

function HelperCreature:hasCreatureInRange(from, to)
    return not not self:getCreatureInRange(from, to)
end

return HelperCreature