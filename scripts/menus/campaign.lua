--      (c) Copyright 2010      by Pali Rohár

function Briefing(title, objs, bg, mapbg, text, voices)
  SetPlayerData(GetThisPlayer(), "RaceName", currentRace)

  local menu = WarMenu()

  local voice = 0
  local channel = -1
  local head1 = nil
  local head2 = nil

  local bg1 = CGraphic:New(bg)
  bg1:Load()
  bg1:Resize(Video.Width, Video.Height)
  local bg2 = nil
  if CanAccessFile(mapbg) then
     bg2 = CGraphic:New(mapbg)
     bg2:Load()
     bg2:Resize(Video.Width, Video.Height)
  end

  local bg = ImageButton()
  bg:setNormalImage(bg1)
  menu:add(bg, 0, 0)

  if (currentRace == "human") then
    PlayMusic(HumanBriefingMusic)
    LoadUI("human", Video.Width, Video.Height)

    local g = CGraphic:New("graphics/428.png", 240 / 5, 48) -- TODO: animate
    g:Load()
    g:Resize((240 / 5) * (Video.Width / 640), 48 * Video.Height / 400)
    head1 = ImageWidget(g)

    g = CGraphic:New("graphics/429.png", 134, 84) -- TODO: animate
    g:Load()
    g:Resize(134 * Video.Width / 640, 84 * Video.Height / 400)
    head2 = ImageWidget(g)

    menu:add(head1, 166 * Video.Width / 640, 74 * Video.Height / 400)
    menu:add(head2, 414 * Video.Width / 640, 58 * Video.Height / 400)
  elseif (currentRace == "orc") then
    PlayMusic(OrcBriefingMusic)
    LoadUI("orc", Video.Width, Video.Height)

    local g = CGraphic:New("graphics/426.png", 560 / 5, 134) -- TODO: animate
    g:Load()
    g:Resize(560 / 5 * Video.Width / 640, 134 * Video.Height / 400)
    head1 = ImageWidget(g)
    
    g = CGraphic:New("graphics/427.png", 690 / 5, 116) -- TODO: animate
    g:Load()
    g:Resize(690 / 5 * Video.Width / 640, 116 * Video.Height / 400)
    head2 = ImageWidget(g)

    menu:add(head1, 36 * Video.Width / 640, 134 * Video.Height / 400)
    menu:add(head2, 404 * Video.Width / 640, 104 * Video.Height / 400)
  else
    StopMusic()
  end

  Objectives = objs

  if (title ~= nil) then
     local headline = title
     if (objs ~= nil) then
        headline = title .. " - " .. objectives[1]
     end
     menu:addLabel(headline, 0.1 * Video.Width, 0.1 * Video.Height, Fonts["large"], false)
  end

  local t = LoadBuffer(text)
  local sw = ScrollingWidget(Video.Width, 0.6 * Video.Height)
  sw:setBackgroundColor(Color(0,0,0,0))
  sw:setSpeed(0.38)

  local l = MultiLineLabel(t)
  l:setForegroundColor(Color(0, 0, 0, 255))
  l:setFont(Fonts["large"])
  l:setAlignment(MultiLineLabel.CENTER)
  l:setVerticalAlignment(MultiLineLabel.BOTTOM)
  l:setLineWidth(0.7 * Video.Width)
  l:adjustSize()
  l:setHeight(0.9 * Video.Height)
  sw:add(l, 0, 0)
  menu:add(sw, 0.15 * Video.Width, 0.2 * Video.Height)

  function PlayNextVoice()
    voice = voice + 1
    if (voice <= table.getn(voices)) then
      channel = PlaySoundFile(voices[voice], PlayNextVoice);
    else
      channel = -1
    end
  end
  PlayNextVoice()

  local speed = GetGameSpeed()
  SetGameSpeed(30)

  local currentAction = nil
  function action2()
     if (channel ~= -1) then
        voice = table.getn(voices)
        StopChannel(channel)
     end
     StopMusic()
     MusicStopped()
     menu:stop()
  end
  function action1()
     if bg2 ~= nil then
        bg:setNormalImage(bg2)
        head1:setVisible(false)
        head2:setVisible(false)
        currentAction = action2
     else
        action2()
     end
  end
  currentAction = action1

  local overall = ImageButton()
  overall:setWidth(Video.Width)
  overall:setHeight(Video.Height)
  overall:setBorderSize(0)
  overall:setBaseColor(Color(0, 0, 0, 0))
  overall:setForegroundColor(Color(0, 0, 0, 0))
  overall:setBackgroundColor(Color(0, 0, 0, 0))
  overall:setActionCallback(function()
        currentAction()
  end)

  l:setActionCallback(action2)
  sw:setActionCallback(action2)

  menu:add(overall, 0, 0)
  menu:run()

  SetGameSpeed(speed)
end

function GetCampaignState(race)
  if (race == "orc") then
    return preferences.CampaignOrc
  elseif (race == "human") then
    return preferences.CampaignHuman
  end
  return 1
end

function IncreaseCampaignState(race, state)
  -- Loaded saved game could have other old state
  -- Make sure that we use saved state from config file
  if (race == "orc") then
    if (state ~= preferences.CampaignOrc) then return end
    preferences.CampaignOrc = preferences.CampaignOrc + 1
  elseif (race == "human") then
    if (state ~= preferences.CampaignHuman) then return end
    preferences.CampaignHuman = preferences.CampaignHuman + 1
  end
  -- Make sure that we immediately save state
  SavePreferences()
end

function CreateEndingStep(bg, text, voice)
  return function()
      print ("Ending in " .. bg .. " with " .. text .. " and " .. voice)
	  local menu = WarMenu(nil, bg, true)
	  StopMusic()
	  local t = LoadBuffer(text)
	  t = "\n\n\n\n\n\n\n\n\n\n" .. t .. "\n\n\n\n\n\n\n\n\n\n\n\n\n"
	  local sw = ScrollingWidget(320, 170 * Video.Height / 480)
	  sw:setBackgroundColor(Color(0,0,0,0))
	  sw:setSpeed(0.28)
	  local l = MultiLineLabel(t)
	  l:setFont(Fonts["large"])
	  l:setAlignment(MultiLineLabel.LEFT)
	  l:setVerticalAlignment(MultiLineLabel.TOP)
	  l:setLineWidth(320)
	  l:adjustSize()
	  sw:add(l, 0, 0)
	  menu:add(sw, 70 * Video.Width / 640, 80 * Video.Height / 480)
	  local channel = -1
	  menu:addHalfButton("~!Continue", "c", 455 * Video.Width / 640, 440 * Video.Height / 480,
		function()
		  if (channel ~= -1) then
			StopChannel(channel)
		  end
		  menu:stop()
		  StopMusic()
		end)
      channel = PlaySoundFile(voice, function() end);
	  menu:run()
	  GameResult = GameVictory
  end
end

function CreatePictureStep(bg, sound, title, text)
  return function()
    SetPlayerData(GetThisPlayer(), "RaceName", currentRace)
    PlayMusic(sound)
    local menu = WarMenu(nil, bg)
    local offx = (Video.Width - 640) / 2
    local offy  = (Video.Height - 480) / 2
    menu:addLabel(title, offx + 320, offy + 240 - 67, Fonts["large-title"], true)
    menu:addLabel(text, offx + 320, offy + 240 - 25, Fonts["small-title"], true)
    menu:addHalfButton("~!Continue", "c", 455 * Video.Width / 640, 440 * Video.Height / 480,
      function() menu:stop() end)
    menu:run()
    GameResult = GameVictory
  end
end

function CreateMapStep(race, map)
  return function()
    -- If there is a pre-setup step, run it, if that fails, don't worry
    local prefix = "campaigns/" .. race .. "/"
    pcall(function () Load(prefix .. map .. "_prerun.lua") end)
    Load(prefix .. map .. "_c2.sms")
    Load(prefix .. "campaign_titles.lua")

    local race_prefix = string.lower(string.sub(race, 1, 1))

    Briefing(
       campaign_titles[tonumber(map)],
       objectives,
       "../graphics/ui/" .. race .. "/briefing.png",
       "../graphics/" .. race_prefix .. "map" .. map .. ".png",
       prefix .. map .. "_intro.txt",
       {prefix .. map .. "_intro.wav"}
    )

    PlayMovie("videos/" .. race_prefix .. "map" .. map .. ".ogv")

    war1gus.InCampaign = true
    Load(prefix .. map .. ".smp")
    RunMap(prefix .. map .. ".smp", preferences.FogOfWar)
    if (GameResult == GameVictory) then
      IncreaseCampaignState(currentRace, currentState)
    end
  end
end

function CreateVictoryStep(bg, text, voices)
  return function()
    Briefing(nil, nil, bg, text, voices)
    GameResult = GameVictory
  end
end

function CampaignButtonTitle(race, i)
  Load("campaigns/" .. race .. "/campaign_titles.lua")
  title = campaign_titles[i] or "xxx"

  if ( string.len(title) > 20 ) then
	  title = string.sub(title, 1, 19) .. "..."
  end

  return title
end

function CampaignButtonFunction(campaign, race, i, menu)
  return function()
    position = campaign.menu[i]
    currentCampaign = campaign
    currentRace = race
    currentState = i
    menu:stop()
    RunCampaign(campaign)
  end
end

function RunCampaignSubmenu(race)
  Load("scripts/campaigns.lua")
  campaign = CreateCampaign(race)

  currentRace = race
  SetPlayerData(GetThisPlayer(), "RaceName", currentRace)

  local menu = WarMenu()
  local offx = (Video.Width - 640) / 2
  local offy = (Video.Height - 480) / 2

  local show_buttons = GetCampaignState(race)
  local half = math.ceil(show_buttons/2)

  for i=1,half do
    menu:addFullButton(CampaignButtonTitle(race, i), ".", offx + 63, offy + 64 + (36 * i), CampaignButtonFunction(campaign, race, i, menu))
  end

  for i=1+half,show_buttons do
    menu:addFullButton(CampaignButtonTitle(race, i), ".", offx + 329, offy + 64 + (36 * (i - half)), CampaignButtonFunction(campaign, race, i, menu))
  end

  menu:addFullButton("~!Previous Menu", "p", offx + 193, offy + 212 + (36 * 5),
    function() menu:stop(); currentCampaign = nil; currentRace = nil; currentState = nil; RunCampaignGameMenu() end)
  menu:run()

end

function RunCampaign(campaign)
  if (campaign ~= currentCampaign or position == nil) then
    position = 1
  end

  currentCampaign = campaign

  while (position <= table.getn(campaign.steps)) do
    campaign.steps[position]()
    if (GameResult == GameVictory) then
      position = position + 1
    elseif (GameResult == GameDefeat) then
    elseif (GameResult == GameDraw) then
    elseif (GameResult == GameNoResult) then
      currentCampaign = nil
      return
    else
      break -- quit to menu
    end
  end

  RunCampaignSubmenu(currentRace)

  currentCampaign = nil
end

function RunCampaignGameMenu()
  local menu = WarMenu()
  local offx = (Video.Width - 640) / 2
  local offy = (Video.Height - 480) / 2

  menu:addFullButton("~!Orc campaign", "o", offx + 193, offy + 212 + (36 * 0),
    function() RunCampaignSubmenu("orc"); menu:stop() end)
  menu:addFullButton("~!Human campaign", "h", offx + 193, offy + 212 + (36 * 1),
    function() RunCampaignSubmenu("human"); menu:stop() end)

  menu:addFullButton("~!Previous Menu", "p", offx + 193, offy + 212 + (36 * 5),
    function() RunSinglePlayerSubMenu(); menu:stop() end)

  menu:run()
end

