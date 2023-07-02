local ESX = exports.es_extended:getSharedObject()
local cam = nil
local visualizzandoListaStili = false

local animationDict = ''
local animationName = ''

postNUI = function(data)
    SendNUIMessage(data)
end

if Config.Command.enable then 
    RegisterCommand(Config.Command.commandName, function()
        OpenAimStyleMenu()
    end)
end

if Config.Keybinds.enable then 
    RegisterKeyMapping('-+stilemira', Config.Keybinds.description, 'keyboard', Config.Keybinds.keybind)
    RegisterCommand('-+stilemira', function(source, args, rawCommand)
        OpenAimStyleMenu()
    end)
    TriggerEvent('chat:removeSuggestion', '/+stilemira')
end

Citizen.CreateThread(function()
   while ESX.IsPlayerLoaded() == false do 
    Wait(10)
   end

   ESX.TriggerServerCallback('ricky-server:aimGetSelected', function(selected)
    for k,v in pairs(Config.Stili) do 
        if v.id == selected then 
            animationDict = v.animation.dict
            animationName = v.animation.anim
        end
    end
   end)
end)

OpenAimStyleMenu = function()
    visualizzandoListaStili = true
    FreezeEntityPosition(PlayerPedId(), true)
    ClearPedTasks(PlayerPedId())
    ESX.TriggerServerCallback('ricky-server:aimGetSelected', function(selected)
        if selected == '' or selected == nil then 
            selected = 'default'
        end
        postNUI({
            type = "SET_CONFIG",
            config = Config
        })
        postNUI({
            type = "UPDATE_SELECTED",
            selected = selected,
        }) 
        for k,v in pairs(Config.Stili) do 
            if v.id == selected then 
                animationDict = v.animation.dict
                animationName = v.animation.anim
            end
        end
        SetNuiFocus(true, true)
        postNUI({
            type = "OPEN",
            stili = Config.Stili
        })
        DisplayRadar(false)
        TurnCamera()
    end)
end

RegisterNUICallback('close', function(data, cb)
    FreezeEntityPosition(PlayerPedId(), false)
    visualizzandoListaStili = false
    RenderScriptCams(false, false, 0, true, true)
    SetCamActive(cam, false)
    DestroyCam(cam, true)
    cam = nil
    SetNuiFocus(false, false)
    ClearPedTasks(PlayerPedId())
    DisplayRadar(true)
end)

TurnCamera = function()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    local camCoords = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 1.0, 1.0) -- Regola la posizione della telecamera davanti al personaggio
    local camRotation = GetEntityHeading(playerPed)

    cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamCoord(cam, camCoords)
    PointCamAtEntity(cam, playerPed, 0.0, 0.0, 0.0, true)
    SetCamActive(cam, true)
    RenderScriptCams(true, false, 0, true, true)
end


RegisterNUICallback('setNewStyle', function(data, cb)
    local id = data.id 
    if id ~= 'default' then 
    for k,v in pairs(Config.Stili) do 
      if v.id == id then 
        RequestAnimDict(v.animation.dict)
        while not HasAnimDictLoaded(v.animation.dict) do
          Citizen.Wait(0)
        end
        TaskPlayAnim(PlayerPedId(), v.animation.dict, v.animation.anim, 8.0, -8.0, -1, 1, 0, false, false, false)
       end
    end
else
    ClearPedTasks(PlayerPedId())
end
    TriggerServerEvent('ricky-server:aimChangeStyle', id)
end)

RegisterNetEvent('ricky-client:aimChangeStyle')
AddEventHandler('ricky-client:aimChangeStyle', function(id)
  postNUI({
    type = "UPDATE_SELECTED",
    selected = id
  })

  if id == 'default' then 
    animationDict = ''
    animationName = ''
    return
  end

  for k,v in pairs(Config.Stili) do 
    if v.id == id then 
        animationDict = v.animation.dict
        animationName = v.animation.anim
    end
end
end)


Citizen.CreateThread(function()
   while true do 
    Wait(0)
    local ped = PlayerPedId()
    
    if visualizzandoListaStili == false and animationDict ~= '' then
     if not IsPedInAnyVehicle(ped) then
        
        RequestAnimDict(animationDict)
        while not HasAnimDictLoaded(animationDict) do
          Citizen.Wait(0)
        end
         if IsPlayerFreeAiming(PlayerId()) then
             if not IsEntityPlayingAnim(ped, animationDict, animationName, 3) then
                TaskPlayAnim(ped, animationDict, animationName, 8.0, -8.0, -1, 49, 0, 0, 0, 0)
                SetEnableHandcuffs(ped, true)
            end
         elseif IsEntityPlayingAnim(ped, animationDict, animationName, 3) then
             ClearPedTasks(ped)
             SetEnableHandcuffs(ped, false)
         end
     end
    end

   end
end)