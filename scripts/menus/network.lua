--  (c) Copyright 2005-2006 by François Beerten and Jimmy Salmon
--  (c) Copyright 2010      by Pali Rohár

function bool2int(boolvalue)
  if boolvalue == true then
    return 1
  else
    return 0
  end
end

function int2bool(int)
  if int == 0 then
    return false
  else
    return true
  end
end

function ErrorMenu(errmsg)
  local menu = WarMenu(nil, panel(4), false)
  menu:setSize(144, 64)
  menu:setPosition((Video.Width - 144) / 2, (Video.Height - 64) / 2)
  menu:setDrawMenusUnder(true)

  menu:addLabel("Error:", 72, 5)

  local l = MultiLineLabel(errmsg)
  l:setFont(Fonts["large"])
  l:setAlignment(MultiLineLabel.CENTER)
  l:setVerticalAlignment(MultiLineLabel.CENTER)
  l:setLineWidth(135)
  l:setWidth(135)
  l:setHeight(20)
  l:setBackgroundColor(dark)
  menu:add(l, 4, 19)

  menu:addHalfButton("~!OK", "o", 41, 40, function() menu:stop() end)

  menu:run()
end

function addPlayersList(menu, numplayers)
  local i
  local players_name = {}
  local players_state = {}
  local sx = Video.Width / 10
  local sy = Video.Height / 10
  local numplayers_text

  menu:writeLargeText("Players", sx * 11, sy*3)
  for i=1,8 do
    players_name[i] = menu:writeText("Player"..i, sx * 11, sy*4 + i*9)
    players_state[i] = menu:writeText("Preparing", sx * 11 + 40, sy*4 + i*9)
  end
  numplayers_text = menu:writeText("Open slots : " .. numplayers - 1, sx *11, sy*4 + 72)

  local function updatePlayers()
    local connected_players = 0
    local ready_players = 0
    players_state[1]:setCaption("Creator")
    players_name[1]:setCaption(Hosts[0].PlyName)
    for i=2,8 do
      if Hosts[i-1].PlyName == "" then
        players_name[i]:setCaption("")
        players_state[i]:setCaption("")
      else
        connected_players = connected_players + 1
        if ServerSetupState.Ready[i-1] == 1 then
          ready_players = ready_players + 1
          players_state[i]:setCaption("Ready")
        else
          players_state[i]:setCaption("Preparing")
        end
        players_name[i]:setCaption(Hosts[i-1].PlyName)
     end
    end
    numplayers_text:setCaption("Open slots : " .. numplayers - 1 - connected_players)
    numplayers_text:adjustSize()
    return (connected_players > 0 and ready_players == connected_players)
  end

  return updatePlayers
end


joincounter = 0

function RunJoiningMapMenu(s)
  local menu
  local listener
  local sx = Video.Width / 10
  local sy = Video.Height / 10
  local numplayers = 3
  local state
  local d

  menu = WarMenu("Joining game: Map")

  menu:writeLargeText("Map", sx, sy*3)
  menu:writeText("File:", sx, sy*3+15)
  maptext = menu:writeText(NetworkMapName, sx+25, sy*3+15)
  menu:writeText("Players:", sx, sy*3+25)
  players = menu:writeText(numplayers, sx+35, sy*3+25)
  menu:writeText("Description:", sx, sy*3+35)
  descr = menu:writeText(description, sx+10, sy*3+45)

  local fow = menu:addCheckBox("Fog of war", sx, sy*3+60, function() end)
  fow:setMarked(true)
  ServerSetupState.FogOfWar = 1
  fow:setEnabled(false)
  local revealmap = menu:addCheckBox("Reveal map", sx, sy*3+75, function() end)
  revealmap:setEnabled(false)

  menu:writeText("~<Your Race:~>", sx, sy*6)
  local race = menu:addDropDown({"Map Default", "Human", "Orc"}, sx + 50, sy*6, function() end)
  local raceCb = function(dd)
     GameSettings.Presets[NetLocalHostsSlot].Race = race:getSelected()
     LocalSetupState.Race[NetLocalHostsSlot] = race:getSelected()
  end
  race:setActionCallback(raceCb)
  race:setSize(95, 10)

  menu:writeText("Units:", sx, sy*6+12)
  local units = menu:addDropDown({"Map Default", "One Peasant Only"}, sx + 50, sy*6+12,
    function(dd) end)
  units:setSize(95, 10)
  units:setEnabled(false)

  menu:writeText("Resources:", sx, sy*6+25)
  local resources = menu:addDropDown({"Map Default", "Low", "Medium", "High"}, sx + 50, sy*6+25,
    function(dd) end)
  resources:setSize(95, 10)
  resources:setEnabled(false)

  local OldPresentMap = PresentMap
  PresentMap = function(desc, nplayers, w, h, id)
    numplayers = nplayers
    players:setCaption(""..nplayers)
    players:adjustSize()
    descr:setCaption(desc)
    descr:adjustSize()
    OldPresentMap(desc, nplayers, w, h, id)
  end

  -- Security: The map name is checked by the stratagus engine.
  Load(NetworkMapName)
  local function readycb(dd)
     LocalSetupState.Ready[NetLocalHostsSlot] = bool2int(dd:isMarked())
  end
  menu:addCheckBox("~!Ready", sx*6,  sy*7, readycb)

  local updatePlayersList = addPlayersList(menu, numplayers)

  joincounter = 0
  local function listen()
    NetworkProcessClientRequest()
    fow:setMarked(int2bool(ServerSetupState.FogOfWar))
    GameSettings.NoFogOfWar = not int2bool(ServerSetupState.FogOfWar)
    revealmap:setMarked(int2bool(ServerSetupState.RevealMap))
    GameSettings.RevealMap = ServerSetupState.RevealMap
    units:setSelected(ServerSetupState.UnitsOption)
    GameSettings.NumUnits = ServerSetupState.UnitsOption
    resources:setSelected(ServerSetupState.ResourcesOption)
    GameSettings.Resources = ServerSetupState.ResourcesOption
    updatePlayersList()
    state = GetNetworkState()
    -- FIXME: don't use numbers
    if (state == 15) then -- ccs_started, server started the game
      SetThisPlayer(1)
      joincounter = joincounter + 1
      if (joincounter == 30) then
        SetFogOfWar(fow:isMarked())
        if revealmap:isMarked() == true then
          RevealMap()
        end
        NetworkGamePrepareGameSettings()
        war1gus.InCampaign = false
        RunMap(NetworkMapName, fow:isMarked())
        PresentMap = OldPresentMap
        menu:stop()
      end
    elseif (state == 10) then -- ccs_unreachable
      ErrorMenu("Cannot reach server")
      menu:stop()
    end
  end
  listener = LuaActionListener(listen)
  menu:addLogicCallback(listener)

  menu:addFullButton("~!Cancel", "c", Video.Width / 2 - 50, Video.Height - 50,
    function() NetworkDetachFromServer(); menu:stop() end)

  menu:run()
end

function RunJoiningGameMenu(s)
  local menu = WarMenu(nil, panel(4), false)
  menu:setSize(144, 64)
  menu:setPosition((Video.Width - 144) / 2, (Video.Height - 64) / 2)
  menu:setDrawMenusUnder(true)

  menu:addLabel("Connecting to server", 72, 5)

  local percent = 0

  local sb = StatBoxWidget(129, 15)
  sb:setCaption("Connecting...")
  sb:setPercent(percent)
  menu:add(sb, 7, 19)
  sb:setBackgroundColor(dark)

  local function checkconnection()
    NetworkProcessClientRequest()
    percent = percent + 100 / (24 * GetGameSpeed()) -- 24 seconds * fps
    sb:setPercent(percent)
    local state = GetNetworkState()
    -- FIXME: do not use numbers
    if (state == 3) then -- ccs_mapinfo
      -- got ICMMap => load map
      RunJoiningMapMenu()
      menu:stop(0)
    elseif (state == 4) then -- ccs_badmap
      ErrorMenu("Map not available")
      menu:stop(1)
    elseif (state == 10) then -- ccs_unreachable
      ErrorMenu("Cannot reach server")
      menu:stop(1)
    elseif (state == 12) then -- ccs_nofreeslots
      ErrorMenu("Server is full")
      menu:stop(1)
    elseif (state == 13) then -- ccs_serverquits
      ErrorMenu("Server gone")
      menu:stop(1)
    elseif (state == 16) then -- ccs_incompatibleengine
      ErrorMenu("Incompatible engine version")
      menu:stop(1)
    elseif (state == 17) then -- ccs_incompatibleluafiles
      ErrorMenu("Incompatible lua files")
      menu:stop(1)
    end
  end
  local listener = LuaActionListener(checkconnection)
  menu:addLogicCallback(listener)

  menu:addHalfButton("Cancel (~<Esc~>)", "escape", 41, 40,
    function() menu:stop(1) end)

  menu:run()
end

function RunJoinIpMenu()
  local menu = WarMenu()
  local offx = Video.Width / 2
  local offy = Video.Height / 2 - 30
  local padding = 4

  InitGameSettings()
  InitNetwork1()

  local connectLabel = menu:writeText("Connect to IP:", offx, offy)
  connectLabel:setX(offx - connectLabel:getWidth() - padding) -- place left of center
  local server = menu:addTextInputField("", offx + padding, offy) -- place right of connectLabel

  local serverLabel = menu:addLabel(_("Discovered servers"), offx, offy + server:getHeight() + padding)
  local servers = {}
  local serverlist = menu:addListBox(offx - 50, serverLabel:getY() + serverLabel:getHeight() + padding, 100, 50, servers)
  local function ServerListUpdate()
    servers = NetworkDiscoverServers(true)
    serverlist:setList(servers)
  end
  ServerListUpdate()
  local counter = 30
  local listener = LuaActionListener(function(s)
        if counter == 0 then
           counter = 300
           ServerListUpdate()
        else
           counter = counter - 1
        end
  end)
  menu:addLogicCallback(listener)

  local okBtn = menu:addHalfButton("~!Connect", "c", offx, serverlist:getY() + serverlist:getHeight() + padding * 4,
    function(s)
      local serverText = server:getText()
      if #serverText == 0 then
        local idx = serverlist:getSelected() + 1
        if idx > 0 then
          serverText = servers[idx]
        end
      end
      local ip = string.match(serverText, "[0-9\.]+")
      if (NetworkSetupServerAddress(ip) ~= 0) then
        ErrorMenu("Invalid server name")
        return
      end
      NetworkInitClientConnect()
      if (RunJoiningGameMenu() ~= 0) then
        -- connect failed, don't leave this menu
        return
      end
      menu:stop()
    end
  )
  okBtn:setX(offx - okBtn:getWidth() - padding)

  menu:addHalfButton("~!Previous Menu", "p", offx + padding, okBtn:getY(), function() menu:stop() end)

  menu:run()
end

function RunServerMultiGameMenu(map, description, numplayers)
  local menu
  local sx = Video.Width / 10
  local sy = Video.Height / 10
  local startgame
  local d

  menu = WarMenu("Create MultiPlayer game")

  menu:writeLargeText("Map", sx, sy*3)
  menu:writeText("File:", sx, sy*3+15)
  maptext = menu:writeText(map, sx+25, sy*3+15)
  menu:writeText("Players:", sx, sy*3+25)
  players = menu:writeText(numplayers, sx+35, sy*3+25)
  menu:writeText("Description:", sx, sy*3+35)
  descr = menu:writeText("Unknown map", sx+10, sy*3+45)

  local function fowCb(dd)
    ServerSetupState.FogOfWar = bool2int(dd:isMarked())
    NetworkServerResyncClients()
    GameSettings.NoFogOfWar = not dd:isMarked()
  end
  local fow = menu:addCheckBox("Fog of war", sx, sy*3+60, fowCb)
  fow:setMarked(true)
  local function revealMapCb(dd)
    ServerSetupState.RevealMap = bool2int(dd:isMarked())
    NetworkServerResyncClients()
    GameSettings.RevealMap = bool2int(dd:isMarked())
  end
  local revealmap = menu:addCheckBox("Reveal map", sx, sy*3+75, revealMapCb)

  menu:writeText("Race:", sx, sy*6)
  local race = menu:addDropDown({"Map Default", "Human", "Orc"}, sx + 50, sy*11, function(dd) end)
  local raceCb = function(arg)
     GameSettings.Presets[0].Race = race:getSelected()
     ServerSetupState.Race[0] = race:getSelected()
     LocalSetupState.Race[0] = race:getSelected()
     NetworkServerResyncClients()
  end
  race:setActionCallback(raceCb)
  race:setSize(95, 10)

  menu:writeText("Units:", sx, sy*6+12)
  d = menu:addDropDown({"Map Default", "One Peasant Only"}, sx + 50, sy*6+12,
    function(dd)
      GameSettings.NumUnits = dd:getSelected()
      ServerSetupState.UnitsOption = GameSettings.NumUnits
      NetworkServerResyncClients()
    end)
  d:setSize(95, 10)

  menu:writeText("Resources:", sx, sy*6+25)
  d = menu:addDropDown({"Map Default", "Low", "Medium", "High"}, sx + 50, sy*6+25,
    function(dd)
      GameSettings.Resources = dd:getSelected()
      ServerSetupState.ResourcesOption = GameSettings.Resources
      NetworkServerResyncClients()
    end)
  d:setSize(95, 10)

  local updatePlayers = addPlayersList(menu, numplayers)

  NetworkMapName = map
  NetworkInitServerConnect(numplayers)
  ServerSetupState.FogOfWar = 1
  startgame = menu:addFullButton("~!Start Game", "s", sx * 6,  sy*7,
    function(s)
      SetFogOfWar(fow:isMarked())
      if revealmap:isMarked() == true then
        RevealMap()
      end
      NetworkServerStartGame()
      NetworkGamePrepareGameSettings()
      war1gus.InCampaign = false
      RunMap(map, fow:isMarked())
      menu:stop()
    end
  )
  startgame:setVisible(false)
  local waitingtext = menu:writeText("Waiting for players", sx*6, sy*7)
  local function updateStartButton(ready)
    startgame:setVisible(ready)
    waitingtext:setVisible(not ready)
  end

  local listener = LuaActionListener(function(s) updateStartButton(updatePlayers()) end)
  menu:addLogicCallback(listener)
  OnlineService.startadvertising()

  menu:addFullButton("~!Cancel", "c", Video.Width / 2 - 50, Video.Height - 50,
    function()
      InitGameSettings()
      OnlineService.stopadvertising()
      menu:stop()
    end)

  menu:run()
end

function RunCreateMultiGameMenu(s)
  local menu
  local map = "No Map"
  local description = "No map"
  local mapfile = "maps/forest1.smp.gz"
  local numplayers = 3
  local sx = Video.Width / 10
  local sy = Video.Height / 10

  menu = WarMenu("Create MultiPlayer game")

  menu:writeText("File:", sx, sy*3+15)
  maptext = menu:writeText(mapfile, sx+25, sy*3+15)
  menu:writeText("Players:", sx, sy*3+25)
  players = menu:writeText(numplayers, sx+35, sy*3+25)
  menu:writeText("Description:", sx, sy*3+35)
  descr = menu:writeText(description, sx+10, sy*3+45)

  local OldPresentMap = PresentMap
  PresentMap = function(desc, nplayers, w, h, id)
    numplayers = nplayers
    players:setCaption(""..numplayers)
    players:adjustSize()
    description = desc
    descr:setCaption(desc)
    descr:adjustSize()
    OldPresentMap(desc, nplayers, w, h, id)
  end

  Load(mapfile)
  local browser = menu:addBrowser("maps/", "^.*%.smp%.?g?z?$", sx*5, sy*2+10, sx*8, sy*5)
  local function cb(s)
    mapfile = browser.path .. browser:getSelectedItem()
    Load(mapfile)
    maptext:setCaption(mapfile)
    maptext:adjustSize()
  end
  browser:setActionCallback(cb)

  menu:addFullButton("~!Create Game", "c", sx,  sy*6,
    function(s)
      if (browser:getSelected() < 0) then
        return
      end
      RunServerMultiGameMenu(mapfile, description, numplayers)
      menu:stop()
    end
  )

  menu:addFullButton("Cancel (~<Esc~>)", "escape", sx,  sy*7+12,
    function() menu:stop() end)

  menu:run()
  PresentMap = OldPresentMap
end

function RunMultiPlayerGameMenu(s)
  local menu = WarMenu()
  local offx = (Video.Width - 320) / 2
  local offy = (Video.Height - 200) / 2 - 30

  InitGameSettings()
  InitNetwork1()

  menu:writeText(_("Nickname :"), 104 + offx, 131 + offy)
  local nick = menu:addTextInputField(GetLocalPlayerName(), offx + 149, 130 + offy)
  menu:writeText(_("Password :"), 104 + offx, 131 + offy + 18)
  local pass = menu:addTextInputField("", offx + 149, 130 + offy + 18)

  local loginBtn = menu:addHalfButton(_("Go ~!Online"), "o", 104 + offx, 160 + (18 * 0) + offy,
    function()
      if nick:getText() ~= GetLocalPlayerName() then
        SetLocalPlayerName(nick:getText())
        wc1.preferences.PlayerName = nick:getText()
        SavePreferences()
      end
      if string.len(pass:getText()) == 0 then
         ErrorMenu("Please enter your password")
      else
         OnlineService.setup({ ShowError = ErrorMenu })
         OnlineService.connect(wc1.preferences.OnlineServer, wc1.preferences.OnlinePort)
         OnlineService.login(nick:getText(), pass:getText())
         RunOnlineMenu()
      end
  end)
  local signupLabel = menu:addLabel(
     _("Sign up"),
     loginBtn:getWidth() + loginBtn:getX() + loginBtn:getWidth() / 2,
     loginBtn:getY() + loginBtn:getHeight() / 4)
  local signUpCb = function(evt, btn, cnt)
     if evt == "mouseClick" then
        if nick:getText() ~= GetLocalPlayerName() then
           SetLocalPlayerName(nick:getText())
           wc1.preferences.PlayerName = nick:getText()
           SavePreferences()
        end
        if string.len(pass:getText()) == 0 then
           ErrorMenu("Please choose a password for the new account")
        else
           OnlineService.setup({ ShowError = ErrorMenu })
           OnlineService.connect(wc1.preferences.OnlineServer, wc1.preferences.OnlinePort)
           OnlineService.signup(nick:getText(), pass:getText())
           RunOnlineMenu()
        end
     end
  end
  local signUpListener = LuaActionListener(signUpCb)
  signupLabel:addMouseListener(signUpListener)

  menu:addFullButton("~!Join Game", "j", 104 + offx, 160 + (18 * 1) + offy,
    function()
      if nick:getText() ~= GetLocalPlayerName() then
        SetLocalPlayerName(nick:getText())
        preferences.PlayerName = nick:getText()
        SavePreferences()
      end
      RunJoinIpMenu()
      menu:stop()
    end)
  menu:addFullButton("~!Create Game", "c", 104 + offx, 160 + (18 * 2) + offy,
    function()
      if nick:getText() ~= GetLocalPlayerName() then
        SetLocalPlayerName(nick:getText())
        preferences.PlayerName = nick:getText()
        SavePreferences()
      end
      RunCreateMultiGameMenu()
      menu:stop()
    end)

  menu:addFullButton("~!Previous Menu", "p", 104 + offx, 160 + (18 * 3) + offy,
    function() menu:stop() end)

  menu:run()

  ExitNetwork1()
end

function RunOnlineMenu()
  local counter = 0

  local menu = WarMenu("Online")

  local margin = 5
  local btnHeight = 19
  local listWidth = 65

  local userLabel = menu:addLabel(_("Users"), margin, margin, nil, false)
  local userList = {}
  local users = menu:addListBox(
     userLabel:getX(),
     userLabel:getY() + userLabel:getHeight(),
     listWidth,
     Video.Height / 4,
     userList
  )

  local friendLabel = menu:addLabel(_("Friends"), margin, users:getY() + users:getHeight() + margin, nil, false)
  local friends = menu:addListBox(
     friendLabel:getX(),
     friendLabel:getY() + friendLabel:getHeight(),
     users:getWidth(),
     users:getHeight(),
     {}
  )

  local channelLabel = menu:addLabel(_("Channels"), margin, friends:getY() + friends:getHeight() + margin, nil, false)
  local channelList = {}
  local selectedChannelIdx = -1
  local channels = menu:addListBox(
     channelLabel:getX(),
     channelLabel:getY() + channelLabel:getHeight(),
     users:getWidth(),
     users:getHeight(),
     channelList
  )
  local channelSelectCb = function()
     OnlineService.joinchannel(channelList[channels:getSelected() + 1])
  end
  channels:setActionCallback(channelSelectCb)

  local gamesLabel = menu:addLabel(_("Games"), users:getX() + users:getWidth() + margin, userLabel:getY(), nil, false)
  local gamesObjectList = {}
  local gamesList = {}
  local games = menu:addListBox(
     gamesLabel:getX(),
     gamesLabel:getY() + gamesLabel:getHeight(),
     Video.Width - (users:getX() + users:getWidth() + margin) - margin,
     Video.Height / 6,
     gamesList
  )

  local messageLabel = menu:addLabel(_("Chat"), games:getX(), games:getY() + games:getHeight() + margin, nil, false)
  local messageList = {}
  local messages = menu:addListBox(
     messageLabel:getX(),
     messageLabel:getY() + messageLabel:getHeight(),
     games:getWidth(),
     Video.Height - (margin + messageLabel:getY() + messageLabel:getHeight()) - (btnHeight * 2) - (margin * 2),
     messageList
  )

  local input = menu:addTextInputField(
     "",
     messages:getX(),
     messages:getY() + messages:getHeight() + margin,
     messages:getWidth()
  )
  input:setActionCallback(function()
        counter = 1
        OnlineService.sendmessage(input:getText())
        input:setText("")
  end)
  local createGame = menu:addHalfButton(
     _("~!Create Game"),
     "c",
     input:getX(),
     input:getY() + btnHeight,
     function()
        RunCreateMultiGameMenu()
     end
  )
  createGame:setWidth((Video.Width - margin * 4 - listWidth) / 3)
  local joinGame = menu:addHalfButton(
     _("~!Join Game"),
     "j",
     createGame:getX() + createGame:getWidth() + margin,
     createGame:getY(),
     function()
        local selectedGame = gamesObjectList[games:getSelected() + 1]
        if selectedGame then
           local ip, port
           for k, v in string.gmatch(selectedGame.Host, "([0-9\.]+):(%d+)") do
              ip = k
              port = tonumber(v)
           end
           print("Attempting to join " .. ip .. ":" .. port)
           NetworkSetupServerAddress(ip, port)
           NetworkInitClientConnect()
           OnlineService.punchNAT(selectedGame.Creator)
           if (RunJoiningGameMenu() ~= 0) then
              -- connect failed, don't leave this menu
              return
           end
        else
           ErrorMenu(_("No game selected"))
        end
     end
  )
  joinGame:setWidth(createGame:getWidth())
  local prevMenuBtn = menu:addHalfButton(
     _("~!Previous Menu"),
     "p",
     joinGame:getX() + joinGame:getWidth() + margin,
     joinGame:getY(),
     function()
        OnlineService.disconnect()
        menu:stop()
     end
  )
  prevMenuBtn:setWidth(createGame:getWidth())

  local AddUser = function(name)
     table.insert(userList, name)
     users:setList(userList)
  end

  local ClearUsers = function()
     for i,v in ipairs(userList) do
        table.remove(userList, i)
     end
     users:setList(userList)
  end

  local RemoveUser = function(name)
     for i,v in ipairs(userList) do
        if v == name then
           table.remove(userList, i)
        end
     end
     users:setList(userList)
  end

  local SetFriends = function(...)
     friendsList = {}
     for i,v in ipairs(arg) do
        table.insert(friendsList, v.Name .. "|" .. v.Product .. "(" .. v.Status .. ")")
     end
     friends:setList(friendsList)
  end

  local SetGames = function(...)
     gamesList = {}
     gamesObjectList = {}
     for i,game in ipairs(arg) do
        table.insert(gamesList, game.Map .. " " .. game.Creator .. ", type: " .. game.Type .. game.Settings .. ", slots: " .. game.MaxPlayers)
        table.insert(gamesObjectList, game)
     end
     games:setList(gamesList)
  end

  local SetChannels = function(...)
     channelList = {}
     for i,v in ipairs(arg) do
        table.insert(channelList, v)
     end
     channels:setList(channelList)
     channels:setSelected(selectedChannelIdx)
  end

  local SetActiveChannel = function(name)
     ClearUsers()
     local index = {}
     for k,v in pairs(channelList) do
        if v == name then
           selectedChannelIdx = k - 1
           return
        end
     end
     selectedChannelIdx = -1
  end

  local AddMessage = function(str, pre, suf)
     for line in string.gmatch(str, "([^".. string.char(10) .."]+)") do
       if pre and suf then
         table.insert(messageList, pre .. line .. suf)
       else
         table.insert(messageList, line)
       end
     end
     messages:setList(messageList)
     messages:scrollToBottom()
  end

  local ShowInfo = function(errmsg)
     AddMessage(errmsg, "~<", "~>")
  end

  local lastError = nil
  local ShowError = function(errmsg)
     AddMessage(errmsg, "~red~", "~>")
     lastError = errmsg
  end

  local ShowUserInfo = function(info)
     local s = {"UserInfo", string.char(10)}
     for k, v in pairs(info) do
        s[#s+1] = string.char(10)
        s[#s+1] = k
        s[#s+1] = ": "
        s[#s+1] = v
     end
     s = table.concat(s)
     ShowError(s)
  end

  OnlineService.setup({
        AddUser = AddUser,
        RemoveUser = RemoveUser,
        SetFriends = SetFriends,
        SetGames = SetGames,
        SetChannels = SetChannels,
        SetActiveChannel = SetActiveChannel,
        ShowChat = AddMessage,
        ShowInfo = ShowInfo,
        ShowError = ShowError,
        ShowUserInfo = ShowUserInfo
  })

  -- check if we're connected, exit this menu if connection fails
  local goonline = true
  local timer = 10
  function checkLogin()
     if goonline then
        if timer > 0 then
           timer = timer - 1
        else
           timer = 10
           result = OnlineService.status()
           if result == "connected" then
              goonline = false
           elseif result ~= "connecting" then
              if lastError then
                 ErrorMenu(lastError)
              else
                 ErrorMenu(result)
              end
              menu:stop()
           end
        end
     end
 end
 local listener = LuaActionListener(function(s) checkLogin() end)
 menu:addLogicCallback(listener)

 menu:run()
end
