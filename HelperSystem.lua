HelperSystem = {}
HelperSystem.__index = HelperSystem

function HelperSystem.new()
    local self = setmetatable({}, HelperSystem)
    return self
end

function HelperSystem:getLuaVersion()
    return _VERSION
end

function HelperSystem:getOperatingSystem()
    if os.execute("uname > /dev/null 2>&1") == 0 then
        local prompt = io.popen("uname")
		if prompt then
			local uname = prompt:read("*a")
			prompt:close()
			if uname:match("Linux") then
				return "Linux"
			end
		end
    else
		if os.execute("ver > nul 2>&1") == 0 then
			return "Windows"
		end
    end
    return "Unknown"
end

function HelperSystem:getVariableFromFile(file, variable, showError)
    local fileFunction, err = loadfile(file)
    showError = showError or false

    if not fileFunction then
        if showError then
            error("Erro ao carregar o arquivo: " .. err)
        end
    end

    local env = {}
    local luaVersion = HString:number(
        self:getLuaVersion()
    )

    if luaVersion <= 5.1 then
        setfenv(fileFunction, env)
        fileFunction()
    else
        if luaVersion >= 5.2 then
            local envFunction = function()
                _ENV = env
                return fileFunction()
            end
            envFunction()
        end
    end

    if not env[variable] then
        if showError then
            error(("Variável '%s' não encontrada no arquivo "):format(variable))
        end
    end

    return env[variable]
end

function HelperSystem:listFiles(folder)
    local files = {}
    local command = ("ls -A1 -F '%s' | grep -v '/$'"):format(folder)

    local operationSystem = self:getOperatingSystem()
    if HString:equals(operationSystem, "Windows") then
        command = ("dir /B /A-D %s"):format(folder)
    end

    local prompt = io.popen(command)

    if prompt then
        for file in prompt:lines() do
            table.insert(files, file)
        end
        prompt:close()
    end

    return files
end

function HelperSystem:listFolders(folder, includeSubfolders)
    local folders = {}
    local command = ("find '%s' -type d"):format(folder)

    if includeSubfolders then
        command = ("%s -maxdepth 1"):format(command)
    end

    local operationSystem = self:getOperatingSystem()
    if HString:equals(operationSystem, "Windows") then
        command = ("dir /B /AD %s"):format(folder)

        if includeSubfolders then
            command = ("dir /B /S /AD %s"):format(folder)
        end
    end

    local prompt = io.popen(command)

    if prompt then
        for folderPath in prompt:lines() do
            if folderPath ~= folder then
                table.insert(folders, folderPath)
            end
        end
        prompt:close()
    end

    return folders
end

function HelperSystem:listFoldersWithCallback(folder, includeSubfolders, callback)
    local folders = {}
    local command = ("find '%s' -type d"):format(folder)
    callback = callback or nil

    if includeSubfolders then
        command = ("%s -maxdepth 1"):format(command)
    end

    local operationSystem = self:getOperatingSystem()
    if HString:equals(operationSystem, "Windows") then
        command = ("dir /B /AD %s"):format(folder)

        if includeSubfolders then
            command = ("dir /B /S /AD %s"):format(folder)
        end
    end

    local prompt = io.popen(command)

    if prompt then
        for folderPath in prompt:lines() do
            if folderPath ~= folder and callback then
                callback(folders, folderPath)
            end
        end
        prompt:close()
    end

    return folders
end

function HelperSystem:appendTextInFile(filename, text)
    local file, err = io.open(filename, "a")

    if not file then
        error("Erro ao abrir o arquivo:", err)
        return false
    end

    file:write(text)
    file:close()

    return true
end

return HelperSystem