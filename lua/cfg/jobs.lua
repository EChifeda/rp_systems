TSACONF = TSACONF or {}

TSACONF:AddJob("Гражданский", {
    color = Color(76, 255, 139, 255),
    model = {
        "models/player/citizens_c8/male_01.mdl",
        "models/player/citizens_c8/male_02.mdl",
        "models/player/citizens_c8/female_01.mdl",
        "models/player/citizens_c8/female_02.mdl"
    },
    description = [[Вы ещё не знаете что вас ждёт]],
    weapons = {"cid", "keys"},
    command = "CIT",
    max = 0,
    salary = 100,
    save = true,
    candemote = false,
    cit = true,
    category = "Граждане",
    bg = { [1] = 0, [2] = 0 },
    PlayerSpawn = function(ply)
        ply:SetHealth(70)
        ply:SetMaxHealth(70)
        ply:SetWalkSpeed(80)
        ply:SetRunSpeed(200)
    end,
})
