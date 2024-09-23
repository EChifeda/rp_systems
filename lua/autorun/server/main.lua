include("cfg/db.lua")

function db:onConnected()
    print("Соединение с базой данных успешно.")
end

function db:onConnectionFailed(err)
    print("Ошибка соединения с базой данных: " .. err)
end

db:connect()

TSACONF = TSACONF or {}
TSACONF.Jobs = TSACONF.Jobs or {}
TSACONF.Players = TSACONF.Players or {}

function TSACONF:AddJob(name, jobInfo)
    if self.Jobs[name] then
        print("Ошибка: Профессия с таким названием уже существует.")
        return false
    end

    self.Jobs[name] = jobInfo
    print("Профессия '" .. name .. "' добавлена.")
    return true
end

function TSACONF:ChangeJob(player, jobName)
    local job = self.Jobs[jobName]

    if not job then
        print("Ошибка: Профессия '" .. jobName .. "' не найдена.")
        return
    end
    
    player:SetJob(jobName)
    
    if job.PlayerSpawn then
        job.PlayerSpawn(player)
    end

    for _, weapon in ipairs(job.weapons) do
        player:Give(weapon)
    end
    player:ChatPrint("Вы теперь " .. jobName .. "!")
end

function TSACONF:SaveJob(player)
    if not player:GetJob() then return end

    local jobName = player:GetJob()
    local steamID = player:SteamID()
    
    -- Создаем SQL-запрос для сохранения данных о профессии
    local query = db:query("INSERT INTO player_jobs (steam_id, job_name) VALUES (" .. db:escape(steamID) .. ", " .. db:escape(jobName) .. ") ON DUPLICATE KEY UPDATE job_name = " .. db:escape(jobName))

    function query:onSuccess()
        print("Профессия игрока " .. player:GetName() .. " сохранена как: " .. jobName)
    end

    function query:onError(err)
        print("Ошибка сохранения профессии: " .. err)
    end

    query:start()
end

function TSACONF:GetJobInfo(jobName)
    return self.Jobs[jobName] or nil
end

function Player:GetJob()
    return TSACONF.Players[self:SteamID()] and TSACONF.Players[self:SteamID()].job or nil
end

function Player:SetJob(jobName)
    if not TSACONF.Jobs[jobName] then return end
    TSACONF.Players[self:SteamID()] = TSACONF.Players[self:SteamID()] or {}
    TSACONF.Players[self:SteamID()].job = jobName
end
