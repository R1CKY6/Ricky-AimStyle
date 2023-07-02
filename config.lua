Config =  {}

Config.Command = {
    enable = true,
    commandName = 'aimstyle'
}

Config.Keybinds = {
    enable = true,
    keybind = 'J',
    description = 'Apri il menu degli stili di mira'
}

Config.Translate = {
    ["title"] = "SELEZIONA IL TUO STILE PREFERITO",
    ["default"] = "Default",
    ["close"] = "CHIUDI",
}

-- Si raccomanda di non modificare l'id
Config.Stili = {
    {
        label = 'Poliziotto',
        id = 'poliziotto',
        animation = {
            dict = 'combat@aim_variations@pistol',
            anim = 'var_a',
        }
    },
    {
        label = "Gangster",
        id = 'gangster',
        animation = {
            dict = 'combat@aim_variations@1h@gang',
            anim = 'aim_variation_a',
        }
    },
    {
        label = "Hillbilly",
        id = 'hillbilly',
        animation = {
            dict = 'combat@aim_variations@1h@hillbilly',
            anim = 'aim_variation_a',
        }
    },
}