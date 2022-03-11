playerData <- array( GetMaxPlayers(), null );
fpvEnabled <- false;

function onScriptLoad()
{
    srand( GetTickCount() );
    
    dofile("scripts/accounts.nut");
    dofile("scripts/admin.nut");
    dofile("scripts/ammu-nation.nut");
    dofile("scripts/announcements.nut");
    dofile("scripts/autosave.nut");
    dofile("scripts/bans.nut");
    dofile("scripts/commands.nut");
    dofile("scripts/functions.nut");
    dofile("scripts/limit.nut");
    dofile("scripts/player.nut");
    dofile("scripts/teleports.nut");
    dofile("scripts/utility.nut");

    SetServerSettings();
    SetSpawnSettings();
    AddClasses();

    accountDb     <- ConnectSQL("accounts.db");
    vehiclesDb    <- ConnectSQL("vehicles.db");
    locDb         <- ConnectSQL("locations.db");
    banDb         <- ConnectSQL("bans.db");
    personalVehDb <- ConnectSQL("personalvehs.db"); 

    QuerySQL(accountDb,     "CREATE TABLE IF NOT EXISTS accounts(id INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT, password TEXT, kills INTEGER DEFAULT 0, deaths INTEGER DEFAULT 0, topspree INTEGER DEFAULT 0, headshots INTEGER DEFAULT 0, adminlevel INTEGER DEFAULT 0, cash INTEGER DEFAULT 0, autologin BOOL, uid TEXT, uid2 TEXT, ip TEXT );");
    QuerySQL(vehiclesDb,    "CREATE TABLE IF NOT EXISTS vehicles(id INTEGER PRIMARY KEY AUTOINCREMENT, vehicleid INTEGER, x FLOAT, y FLOAT, z FLOAT, angle FLOAT, color1 INTEGER, color2 INTEGER);");
    QuerySQL(locDb,         "CREATE TABLE IF NOT EXISTS locations(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, x FLOAT, y FLOAT, z FLOAT, angle FLOAT);");
    QuerySQL(banDb,         "CREATE TABLE IF NOT EXISTS bans(id INTEGER PRIMARY KEY AUTOINCREMENT, banned TEXT, banned_ip TEXT, ban_expire INTEGER, isPerma BOOL, admin TEXT, reason TEXT, uid TEXT, uid2 TEXT);");
    QuerySQL(personalVehDb, "CREATE TABLE IF NOT EXISTS vehicles(id INTEGER PRIMARY KEY AUTOINCREMENT, owner TEXT, vehicleid INTEGER);");

    loadVehicles(); 
    loadCheckpoints();
    loadAmmuNations();

    toggleLights <- BindKey( true, 0x32, null, null );
    toggleTaxiLights <- BindKey( true, 0x33, null, null );
    helpKey <- BindKey( true, 0x48, null, null );
    exitSpec <- BindKey( true, 0x08, null, null );

    // Print work fix by rww
    HideMapObject(1587,-1074.912964,-276.7081299,11.05003262);
}

function onScriptUnload()
{
    DisconnectSQL(accountDb);
    DisconnectSQL(vehiclesDb);
    DisconnectSQL(locDb);
    DisconnectSQL(banDb);
    DisconnectSQL(personalVehDb);
}

function loadVehicles()
{
    local vehcount = 0;
    local q = QuerySQL( vehiclesDb, "SELECT * FROM vehicles ");
    if(q)
    {
        while(GetSQLColumnData(q, 0))
        {
            local model = GetSQLColumnData(q, 1);
            local x = GetSQLColumnData(q, 2);
            local y = GetSQLColumnData(q, 3);
            local z = GetSQLColumnData(q, 4);
            local a = GetSQLColumnData(q, 5);
            local col1 = GetSQLColumnData(q, 6);
            local col2 = GetSQLColumnData(q, 7);
            CreateVehicle( model, 0, Vector(x.tofloat(),y.tofloat(),z.tofloat()), a, col1, col2 );            
            GetSQLNextRow( q );
            ++vehcount;            
        }
        FreeSQLQuery(q);
    }
    if(vehcount > 0)
    {
        print(vehcount + " vehicles have been loaded from vehicle database.");
    }
    else print("No vehicles were found in the database. You can add some using /addvehicle (Requires Admin Level 3)");
}

function onKeyDown( player, bindId )
{
    switch(bindId)
    {
        case toggleLights:
        {
            if(player.Vehicle) player.Vehicle.Lights = !player.Vehicle.Lights;
            break;
        }
        case helpKey:
        {
            SendMessageToTeamChat( player.ID, "I need help! Location: " + GetLocation(player.Pos.x, player.Pos.y) );
            break;
        }
        case exitSpec:
        {
            player.SpectateTarget = null;
            break;
        }
        case toggleTaxiLights:
        {
            if(player.Vehicle) player.Vehicle.TaxiLight = !player.Vehicle.TaxiLight;
        }
    }
}

function onPlayerSpawn(player)
{
    Announce("", player, 8);
    if(playerData[player.ID].diepos && playerData[player.ID].isDieposSet) player.Pos = playerData[player.ID].deathpos;
    player.World = player.UniqueWorld;
    playerData[player.ID].spawnTimer = NewTimer( "endSpawnProtection", 3000, 1, player.ID);
    player.Disarm();
    player.SetSpawnWeps();
    return 1;
}

function onPlayerJoin(player)
{
    Message(COLOR_GREEN + player.Name + COLOR_WHITE + " has connected to the server.");
    player.IsBanned();
    player.Angle = 2.92;
    playerData[player.ID] = Player();

    if(accounts.IsRegistered(player))
    {
        playerData[player.ID].registered = true;
        
        local q = QuerySQL(accountDb, "SELECT * FROM accounts WHERE username='"+player.Name+"' COLLATE NOCASE");
        if(GetSQLColumnData(q, 9) == 1) // If auto login is enabled
        {
            if(GetSQLColumnData(q, 10) == player.UniqueID || GetSQLColumnData(q, 11) == player.UniqueID2) // If UID or UID2 matches
            {
                accounts.AutoLogin(player);
            }
            else {
                MessagePlayer(COLOR_PINK + "Your nickname is registered into the server, please use /login <password> to login.", player);
            }
        }
        else {
            MessagePlayer(COLOR_PINK + "Your nickname is registered into the server, please use /login <password> to login.", player);
        }
        FreeSQLQuery(q);
    }
    else 
    {
        MessagePlayer(COLOR_PINK + "You are not registered into the server please use /register <password> to register.", player);
    }
}

function onPlayerPart(player, reason)
{
    switch(reason){
        case 0:
            Message(COLOR_GREEN + player.Name + COLOR_WHITE + " left the game. (Timeout)");
            break;
        case 1:
            Message(COLOR_GREEN + player.Name + COLOR_WHITE + " left the game. (Disconnect)");
            break;
        case 2:
            Message(COLOR_GREEN + player.Name + COLOR_WHITE + " left the game. (Kicked)");
            break;
        case 3:
            Message(COLOR_GREEN + player.Name + COLOR_WHITE + " left the game. (Crashed)");
    }
    accounts.LogOut(player);
    if(playerData[player.ID].healTimer) playerData[player.ID].healTimer.Delete();
    if(playerData[player.ID].spawnTimer) playerData[player.ID].spawnTimer.Delete();
    playerData[player.ID] = null;
}

function onPlayerDeath(player, reason)
{
    ++playerData[player.ID].deaths;
    switch(reason)
    {
        case 51: Message(COLOR_GREEN + player.Name + COLOR_WHITE + " exploded."); break;
        case 70: Message(COLOR_GREEN + player.Name + COLOR_WHITE + " commited suicide."); break;
        case 44: Message(COLOR_GREEN + player.Name + COLOR_WHITE + " fell."); break;
        case 43: Message(COLOR_GREEN + player.Name + COLOR_WHITE + " drowned."); break;
        case 31: Message(COLOR_GREEN + player.Name + COLOR_WHITE + " burned."); break;
        default: Message(COLOR_GREEN + player.Name + COLOR_WHITE + " died.");
    }
    Announce("~t~Wasted!", player, 5)
}

function onPlayerKill( killer, player, reason, bodypart )
{
    Message(COLOR_RED + killer.Name + COLOR_GRAY + " " + getKillMessage(reason) + " " + COLOR_RED + player.Name + COLOR_GRAY + " (" + GetWeaponName(reason) + ") (" + GetBodypartName(bodypart) + ")");
    killer.Score++;

    killer.IncCash(750);
    player.DecCash(100);

    playerData[player.ID].deathpos = player.Pos;
    playerData[player.ID].isDieposSet = true;

    playerData[killer.ID].kills++;
    playerData[player.ID].deaths++;
    playerData[killer.ID].spree++;
    playerData[killer.ID].session_kills++;
    playerData[player.ID].session_deaths++;

    if(bodypart == BODYPART_HEAD) ++playerData[killer.ID].headshots;

    if(playerData[player.ID].spree >= 5) Message(COLOR_YELLOW + player.Name + COLOR_WHITE + "'s spree of " + COLOR_YELLOW + playerData[player.ID].spree + COLOR_WHITE + " is ended by " + COLOR_YELLOW + killer.Name );
    playerData[player.ID].spree = 0;

    if(playerData[killer.ID].spree % 5 == 0) {
        onPlayerKillingSpree(killer);
    }
    if(playerData[killer.ID].topspree < playerData[killer.ID].spree) playerData[killer.ID].topspree = playerData[killer.ID].spree;
    Announce("~t~Wasted!", player, 5);
}

function onPlayerTeamKill( killer, player, reason, bodypart )
{
    if(player.Team == 255)
    {
        onPlayerKill(killer, player, reason, bodypart);
    }
    else
    {
        Message(COLOR_RED + killer.Name + COLOR_GRAY + " team killed " + COLOR_RED + player.Name + COLOR_GRAY + " (" + GetWeaponName(reason) + ") (" + GetBodypartName(bodypart) + ")");
        killer.Drown("Server", "Team-Killing");
        ++playerData[player.ID].teamkilling_warn;
        if(playerData[player.ID].teamkilling_warn == 3)
        {
            bans.TempBan(killer.Name, "Server", "5m", "Team-Killing");
        }
    }
}

function onPlayerRequestSpawn(player)
{
    if(playerData[player.ID].registered && !playerData[player.ID].logged)
    {
        MessagePlayer(COLOR_RED + "This nickname is registered, you need to login to spawn!", player)
        return 0;
    }
    return 1;
}


function onPlayerChat(player, msg)
{
    if(playerData[player.ID].registered && !playerData[player.ID].logged)
    {
        MessagePlayer(COLOR_RED + "This nickname is registered, you need to login to chat!", player);
        return 0;
    }
    if(playerData[player.ID].muted)
    {
        MessagePlayer(COLOR_RED + "You are currently muted.", player);
        return 0;
    }
    print("[CHAT]" + player.Name + ": " + msg);
    return 1; 
}

function onPlayerActionChange(player, oldAction, newAction) {
    if (newAction == 12 && (player.Weapon == 26 || player.Weapon == 27 || player.Weapon == 32)) {
        onPlayerFPV(player, player.Weapon);
    }
}

function onPlayerRequestClass( player, classId, team, skin )
{
    switch(team)
    {
        case 1:
        {
            Announce("~o~Shark Gang", player, 8);
            break;
        }
        case 2:
        {
            Announce("~y~Taxi Drivers", player, 8);
            break;
        }
        case 3:
        {
            Announce("~h~Cuban Gang", player, 8);
            break;
        }
        case 4:
        {
            Announce("~b~Haitian Gang", player, 8);
            break;
        }
        case 5:
        {
            Announce("~x~Vercetti Family", player, 8);
            break;
        }
        case 6:
        {
            Announce("~p~Police", player, 8);
            break;
        }
        case 7:
        {
            Announce("~r~Fireman", player, 8);
            break;
        }
        case 8:
        {
            Announce("~t~Businessman", player, 8);
            break;
        }
        case 9:
        {
            Announce("~w~Biker Gang", player, 8);
            break;
        }
        case 10:
        {
            Announce("Lady", player, 8);
            break;
        }
        case 11:
        {
            Announce("~w~Thug", player, 8);
            break;
        }
        case 12:
        {
            Announce("~y~Construction Workers", player, 8);
        }
    }
}

function onPlayerEnterVehicle( player, vehicle, door )
{
    if(GetHour() >= 20 || GetHour() <= 3)
    {
        vehicle.Lights = true;
    }
}

function onPlayerExitVehicle( player, vehicle)
{
    vehicle.Lights = false;
    vehicle.TaxiLight = false;
}

function onCheckpointEntered( player, cp ) {
    if(!player.Vehicle)
    {
        if(cp.ID < teleports.len())
        {
            player.Pos = teleports[cp.ID][1];
            PlaySound( player.UniqueWorld , 465 , player.Pos );
        }
        else
        {   
            onPlayerEnterAmmuNation(player);
        }
    }
}

function onPlayerEnterAmmuNation(player)
{
    playerData[player.ID].buymode = true;
    Announce("~g~Welcome to ~t~Vice City Ammu Nation! ~g~Use /buywep to purchase weapon.", player, 0);
}

function onPlayerFPV(player, weapon)
{
    if(GetWeaponType(weapon) == "Rifle" || weapon == WEP_M60)
    {
        if(!fpvEnabled)
        {
            Announce("~g~FPV is disabled in this server!", player, 1);
            player.Slot = 0;
        }
    }
}

function onPlayerKillingSpree(player)
{
    Announce("~o~Killing Spree!", player, 5);
    Message(COLOR_RED+player.Name + COLOR_WHITE + " is on killing spree of " + COLOR_RED + playerData[player.ID].spree + COLOR_WHITE + " reward: " + COLOR_GREEN + playerData[player.ID].spree * 100 + "$");
    player.IncCash(playerData[player.ID].spree * 250);
    if(player.World == 1) player.GiveArmour(10); 
}

function onTimeChange( lastHour, lastMinute, hour, minute )
{
    if(hour % 5 == 0 && minute == 0)
    {
        // Auto Weather change every 5 minutes, Weather Cycle: Sunny, Mostlyclear, Overcast, Rain, Thunder
        local weather = GetWeather();
        switch(weather)
        {
            case WEATHER_MOSTLYCLEAR: SetWeather(WEATHER_OVERCAST); break;
            case WEATHER_OVERCAST: SetWeather(WEATHER_RAIN); break;
            case WEATHER_STORM: SetWeather(WEATHER_SUNNY); break;
            case WEATHER_SUNNY: SetWeather(WEATHER_MOSTLYCLEAR); break;
            case WEATHER_RAIN: SetWeather(WEATHER_STORM); break;
        }
    }
}
