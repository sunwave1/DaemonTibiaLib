HelperTable = {}
HelperTable.__index = HelperTable

function HelperTable.new()
    local self = setmetatable({}, HelperTable)
    return self
end

function HelperTable:where(tbl, condition)
    local result = {}
    for _, v in ipairs(tbl) do
        if condition(v) then
            table.insert(result, v)
        end
    end
    return result
end

function HelperTable:sortBy(tbl, compare)
    local sortedTbl = {}
    for _, v in ipairs(tbl) do
        table.insert(sortedTbl, v)
    end
    table.sort(sortedTbl, compare)
    return sortedTbl
end

function HelperTable:get(tbl, key, default)
    local keys = {}
    for k in string.gmatch(key, "[^%.]+") do
        table.insert(keys, k)
    end

    local current = tbl
    for _, k in ipairs(keys) do
        if type(current) == "table" and current[k] ~= nil then
            current = current[k]
        else
            return default
        end
    end

    return current
end

function HelperTable:set(tbl, key, value)
    local keys = {}
    for k in string.gmatch(key, "[^%.]+") do
        table.insert(keys, k)
    end

    local current = tbl
    for i, k in ipairs(keys) do
        if i == #keys then
            current[k] = value
        else
            if current[k] == nil or type(current[k]) ~= "table" then
                current[k] = {}
            end
            current = current[k]
        end
    end
end

function HelperTable:toJson(tbl)
    return json.encode(tbl)
end

function HelperTable:toTable(tbl)
    local jsonStatus, jsonData = pcall(function() return json.decode(tbl) end) 

    if not jsonStatus then 
        return nil 
    end

    return jsonData
end

function HelperTable:contains(tbl, v)
    for _, val in pairs(tbl) do
        if val == v then
            return true
        end
    end
    return false
end

function HelperTable:length(tbl)
    local count = 0
    for i, v in pairs(tbl) do
        count = count + 1
    end
    return count
end

function HelperTable:keys(tbl)
    local keys = {}
    for k, _ in pairs(tbl) do
        table.insert(k, keys)
    end
    return keys
end

return HelperTable