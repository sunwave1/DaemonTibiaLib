HelperString = {}
HelperString.__index = HelperString

function HelperString.new()
    local self = setmetatable({}, HelperString)
    return self
end

function HelperString:number(str)
    return tonumber(
        str:match("%d+%.?%d*")
    )
end

function HelperString:levenshtein(str1, str2)
    local len1, len2 = #str1, #str2
    local matriz = {}
    for i = 0, len1 do
        matriz[i] = {
            [0] = i
        }
    end
    for j = 0, len2 do
        matriz[0][j] = j
    end
    for i = 1, len1 do
        for j = 1, len2 do
            local custo = str1:sub(i,i) ~= str2:sub(j,j) and 1 or 0
            matriz[i][j] = math.min(matriz[i-1][j] + 1, matriz[i][j-1] + 1, matriz[i-1][j-1] + custo)
        end
    end
    return matriz[len1][len2]
end

function HelperString:equals(str1, str2)
    return self:levenshtein(str1, str2) <= 2
end

return HelperString