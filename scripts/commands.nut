function onPlayerCommand(player, cmd, text)
{
    cmd = cmd.tolower();
    if(onPlayerAdminCommand(player,cmd,text, playerData[player.ID].adminlevel))
    {
        return;
    }
    if(text)
    {
        text = text.tolower();
    }
    switch(cmd)
    {
        case "commands":
        case "cmds":
        {
            MessagePlayer(COLOR_PINK + "Available commands:" + COLOR_WHITE +" /commands /rules /register /login /autologin /diepos /saveloc /gotoloc /getwep /spawnwep /stats /sessionstats /fps /ping /admins /report /goto /nogoto /loc /tc /spree /flip /removewep /spectate /buywep /buycar /sellcar /getcar /mycar", player)
            break;
        }
        case "buywep":
        {
            if(playerData[player.ID].buymode)
            {
                if(!text)
                {
                    local weplist = ""
                    for(local i = 0; i < weapons.len(); ++i)
                    {
                        weplist += GetWeaponName(weapons[i][0]) + " " + weapons[i][1] + "$ ";
                    }
                    Announce("", player, 0); // To clear "Welcome to Ammu Nation" announcement comes when entering ammu nation checkpoint
                    Announce("~g~Weapons:" + weplist, player, 1);
                }
                else {
                    for(local i = 0; i < weapons.len(); ++i)
                    {
                        if(GetWeaponID(text) == weapons[i][0])
                        {
                            if(player.Cash >= weapons[i][1])
                            {
                                player.DecCash(weapons[i][1]);
                                player.GiveWeapon(weapons[i][0], weapons[i][2]);
                                MessagePlayer(COLOR_GREEN + "You've successfully purchased " + GetWeaponName(weapons[i][0]) + " with " + weapons[i][2] + " ammo for " + weapons[i][1] + "$", player);
                            }
                            else MessagePlayer(COLOR_RED + "You don't have enough money to buy this weapon!", player);
                            return 1;
                        }
                    }
                    if(GetWeaponName(GetWeaponID(text)) != "Unknown") MessagePlayer(COLOR_RED + "The weapon " + GetWeaponName(GetWeaponID(text)) + " is not available on ammu nation!", player);
                    else MessagePlayer(COLOR_RED + "Incorrect weapon!", player);
                }
            }
            else MessagePlayer(COLOR_RED + "You have to be in Ammu Nation to use this command!", player);
            break;
        }
        case "loc":
        {
            if(!text)
                MessagePlayer(COLOR_PINK + "Your location is: " + COLOR_WHITE + GetLocation(player.Pos.x, player.Pos.y), player);
            else {
                local targetplr = GetPlayer(text);
                if(targetplr)
                {
                    MessagePlayer(COLOR_PINK + targetplr.Name + "'s location is: " + COLOR_WHITE + GetLocation(player.Pos.x, player.Pos.y), player);
                }
                else MessagePlayer(COLOR_RED + "Player not found!", player);
            }
            break;
        }
        case "tc":
        case "teamchat":
        case "tchat":
        {
            if(text)
            {
                if(playerData[player.ID].muted)
                {
                    MessagePlayer(COLOR_RED + "You are muted.", player);
                    return;
                }
                SendMessageToTeamChat(player.ID, text);
            }
            else MessagePlayer(COLOR_RED + "Correct usage: /tc <text>", player);
            break;
        }
        case "register":
        {
            if(text) 
            {
                if(!playerData[player.ID].registered) {
                    accounts.Register(player, text);
                }
                else MessagePlayer(COLOR_RED + "You are already registered!", player);
            }
            else MessagePlayer(COLOR_RED + "Correct usage: /register <password>", player);
            break;
        }
        case "login":
        {
            if(text)
            {
                if(playerData[player.ID].logged) MessagePlayer(COLOR_RED + "You are already logged in!", player);
                else if(accounts.Login(player, text) == false) // If wrong password entered
                {
                    ++playerData[player.ID].wrongpass_warn;
                    if(playerData[player.ID].wrongpass_warn == 3) 
                    {
                        player.Kick("Server", "Invalid Password Attempts");
                    }
                }
            }
            else MessagePlayer(COLOR_RED + "Correct usage: /login <password>", player);
            break;
        }
        case "autologin":
        {
            if(playerData[player.ID].logged)
            {
                local q = QuerySQL(accountDb, "SELECT * FROM accounts WHERE username='"+player.Name+"' COLLATE NOCASE");
                local autologin = GetSQLColumnData(q, 9);
                if(autologin)
                {
                    QuerySQL(accountDb, "UPDATE accounts SET autologin='0' WHERE username='"+player.Name+"' COLLATE NOCASE");
                    MessagePlayer(COLOR_GREEN + "Autologin is disabled.", player);
                }
                else {
                    QuerySQL(accountDb, "UPDATE accounts SET autologin='1' WHERE username='"+player.Name+"' COLLATE NOCASE");
                    MessagePlayer(COLOR_GREEN + "Autologin is enabled.", player);                    
                }
                FreeSQLQuery(q);
            }
            else MessagePlayer(COLOR_RED + "Log in to use this command.", player);
            break;
        }
        case "fps":
        case "ping":
        {
            if(!text) {
                MessagePlayer(COLOR_GRAY + "Your FPS: " + COLOR_WHITE + player.FPS + COLOR_GRAY + " Your ping: " + COLOR_WHITE + player.Ping, player);
            } 
            else 
            {
                local plr = GetPlayer(text)
                if(plr)
                {   
                    MessagePlayer(COLOR_GRAY + plr.Name +"'s FPS: " + COLOR_WHITE + plr.FPS + COLOR_GRAY + " ping: " + COLOR_WHITE + plr.Ping, player );
                } else MessagePlayer(COLOR_RED + "Error: Player not found!", player);
            }
            break;
        }
        case "heal":
        {
            if(player.IsSpawned)
            {
                if(playerData[player.ID].healTimer == null)
                {
                    if(!player.Vehicle)
                    {
                        playerData[player.ID].healingProcess = true;
                        MessagePlayer(COLOR_GREEN + "You will be healed in 5 seconds, don't move.", player);
                        playerData[player.ID].healPos = player.Pos;
                        playerData[player.ID].healTimer = NewTimer("HealPlayer", 5000, 1, player.ID);
                    }
                    else MessagePlayer(COLOR_RED + "You can't heal in vehicle!", player);
                }
                else MessagePlayer(COLOR_RED + "You can't use this command now!", player);
            } 
            else MessagePlayer(COLOR_RED + "You have to be spawned to use this command!", player);
            break;
        }
        case "diepos":
        {
            switch(text)
            {
                case "on":
                {
                    if(!playerData[player.ID].diepos)
                    {
                        MessagePlayer(COLOR_PINK + "You have successfully turned on your die-pos feature, you will spawn at where you die!", player);
                        playerData[player.ID].diepos = true;
                    }
                    else MessagePlayer(COLOR_RED + "Your die pos feature is already turned on!", player);
                    break;
                }
                case "off":
                {
                    if(playerData[player.ID].diepos)
                    {
                        MessagePlayer(COLOR_PINK + "You have successfully turned off die pos feature!", player);
                        playerData[player.ID].diepos = false;
                    } 
                    else MessagePlayer(COLOR_RED + "Your die pos feature is already off!", player);
                    break;
                }
                default:
                {
                    MessagePlayer(COLOR_RED + "Usage: /diepos [on/off]", player);
                }
            }
            break;
        }
        case "report":
        { 
            if(text) {
                if(NumTok(text, " ") >= 2)
                {
                    local targetplr = GetPlayer(GetTok(text, " ", 1));
                    local reason = GetTok(text, " ", 2 NumTok(text, " "));
                    if(targetplr)
                    {
                        SendMessageToStaffChat("Server", player.Name + " has reported " + targetplr.Name + " reason: " + reason );
                        MessagePlayer(COLOR_GREEN + "The report sent to all admins in game, thank you for reporting.", player);
                    }
                    else MessagePlayer(COLOR_RED + "Target player not found!", player);
                }
                else MessagePlayer(COLOR_RED + "Corect usage: /report <player> <reason>", player);
            } else MessagePlayer(COLOR_RED + "Corect usage: /report <player> <reason>", player);
            break;
        }
        case "admins":
        {
            local admincount = 0;
            local adminlist = "";
            for(local i = 0; i < GetMaxPlayers(); ++i) {
                local plr = GetPlayer(i)
                if(plr) {
                    if(playerData[i].adminlevel >= 1) {
                        adminlist += plr.Name + " "
                        ++admincount;
                    }
                } 
            } 
            if(admincount == 0) 
            {
                MessagePlayer(COLOR_RED + "No admins in game!", player)
                return;
            }
            MessagePlayer(COLOR_YELLOW + "Admins in game (" + admincount + "): " + COLOR_WHITE + adminlist, player)
            break;
        }
        case "spree":
        {
            local playercount = 0;
            local playerlist = "";
            for(local i = 0; i < GetMaxPlayers(); ++i) {
                local plr = GetPlayer(i)
                if(plr) {
                    if(playerData[i].spree >= 5) {
                        playerlist += plr.Name + "(" + playerData[plr.ID].spree + ") ";
                        ++playercount;
                    }
                } 
            } 
            if(playercount == 0) 
            {
                MessagePlayer(COLOR_RED + "No player on spree!", player)
                return;
            }
            MessagePlayer(COLOR_BLUE + "Players on spree (" + playercount + "): " + COLOR_WHITE + playerlist, player)
            break;
        }
        case "spawnwep":
        {
            if(text) 
            {
                local wepid = 0;
                local weplist = "";
                if(text) {
                    local i = 1;
                    playerData[player.ID].spawnweps.clear();
                    playerData[player.ID].spawnweps.resize(NumTok(text, " "), null);
                    while(GetTok(text, " ", i)) {
                        switch(GetWeaponID(GetTok(text, " ", i)))
                        {
                            case WEP_MINIGUN: case WEP_RPG: case WEP_GRENADE: 
                            case WEP_REMOTE: case WEP_TEARGAS: case WEP_MOLOTOV: 
                            case WEP_ROCKET: case WEP_CHAINSAW: case WEP_FLAMETHROWER:
                            {
                                local disallowedwep = GetWeaponID( GetTok(text, " ", i) ); 
                                disallowedwep = GetWeaponName(disallowedwep);
                                MessagePlayer(COLOR_RED + "You can't get " + disallowedwep, player);
                                break;
                            }
                            default:
                            {
                                playerData[player.ID].spawnweps.insert(i, GetWeaponID(GetTok(text, " ", i)))
                                wepid = GetWeaponID(GetTok(text, " ", i))
                                weplist+= GetWeaponName(wepid) + " ";
                            }
                        }
    
                        ++i;
                    }
                    if(weplist != "")
                    {
                        player.Disarm();
                        player.SetSpawnWeps();
                        MessagePlayer(COLOR_YELLOW + "Your spawnwep list is: " + COLOR_WHITE + weplist, player);
                    } 
                } else MessagePlayer(COLOR_RED + "Correct usage: /spawnwepwep <weapon list>", player)
            }
            else MessagePlayer(COLOR_RED + "Correct usage: /spawnwep <weapon 1, weapon 2,...>", player)
            break;
        }
        case "removewep":
        {  
            if(!text)
            {
                MessagePlayer(COLOR_RED + "Correct usage: /removewep <weapon>", player);
                return;
            }
            local wepId = GetWeaponID(text);
            if(wepId)
            {
                local wepSlot = GetWeaponSlot(wepId);
                if(player.GetWeaponAtSlot( wepSlot ) == wepId)
                {
                    player.RemoveWeapon(wepId);
                    MessagePlayer(COLOR_GREEN + "You have removed " + GetWeaponName(wepId) + " from your inventory!", player);
                }
                else {
                    MessagePlayer(COLOR_RED + "You don't have " + GetWeaponName(wepId) + " in your inventory!", player);
                }
            }
            else MessagePlayer(COLOR_RED + "Weapon not found!", player);
            break;
        }
        case "we":
        case "wep":
        case "getwep":
        {
            local wepid = 0;
            local weplist = "";
            if(text) {
                local i = 1;
                while(GetTok(text, " ", i)) {
                    switch(GetWeaponID(GetTok(text, " ", i)))
                    {
                        case WEP_MINIGUN: case WEP_RPG: case WEP_GRENADE: 
                        case WEP_REMOTE: case WEP_TEARGAS: case WEP_MOLOTOV: 
                        case WEP_ROCKET: case WEP_CHAINSAW: case WEP_FLAMETHROWER:
                        {
                            local disallowedwep = GetWeaponID( GetTok(text, " ", i) ) 
                            disallowedwep = GetWeaponName(disallowedwep)
                            MessagePlayer(COLOR_RED + "You can't get " + disallowedwep, player);
                            break;
                        }
                        default:
                        {
                            player.SetWeapon(GetWeaponID(GetTok(text, " ", i)), 9999);
                            wepid = GetWeaponID(GetTok(text, " ", i))
                            weplist+= GetWeaponName(wepid) + " ";
                        }
                    }
                    ++i;
                }
                if(weplist != "") MessagePlayer(COLOR_YELLOW + "Weapons received: " + COLOR_WHITE + weplist, player);
            } else MessagePlayer(COLOR_RED + "Correct usage: /getwep <weapon list>", player);
            break;
        }
        case "saveloc": 
        {
            if(text) {
                local locName = GetTok(text, " ", 1)
                local q = QuerySQL(locDb, "SELECT * FROM locations WHERE name='"+locName.tolower()+"'");
                if(q) {
                    MessagePlayer(COLOR_RED + "Error: location name " + locName + " exists!", player);
                    FreeSQLQuery(q);
                    return;
                } 
                else 
                {
                    QuerySQL(locDb, "INSERT INTO locations(name,x,y,z,angle) VALUES('"+locName.tolower()+"','"+player.Pos.x+"','"+player.Pos.y+"','"+player.Pos.z+"','"+player.Angle+"');");
                    MessagePlayer(COLOR_RED + "You have successfully saved a location, you can go to this location by /gotoloc " + locName, player);
                }
                
            } else MessagePlayer(COLOR_RED + "Correct usage: /saveloc <loc name>", player);
            break;
        }
        case "gotoloc": 
        {
            if(text) {
                local locName = GetTok(text, " ", 1)
                local q = QuerySQL(locDb, "SELECT * FROM locations WHERE name='"+locName.tolower()+"'");
                if(q) {
                    if(player.IsSpawned && player.World == 1) 
                    {
                        if(!player.Frozen)
                        {
                            if(!player.Vehicle)
                            {
                                local x = GetSQLColumnData(q, 2);
                                local y = GetSQLColumnData(q, 3);
                                local z = GetSQLColumnData(q, 4);
                                local angle = GetSQLColumnData(q, 5);
                                player.Frozen = true;
                                MessagePlayer(COLOR_YELLOW + "You will be teleported to " + COLOR_WHITE + locName + COLOR_YELLOW + " in 5 seconds to prevent abuse.", player)
                                NewTimer("TeleportPlayer", 5000, 1, player.ID, x, y, z, angle);
                            }
                            else MessagePlayer(COLOR_RED + "You can't use this command while on vehicle!", player);
                        }
                        else MessagePlayer(COLOR_RED +"You can't use this command while frozen!", player);
                    } 
                    else MessagePlayer(COLOR_RED + "You have to spawn in deathmatch world to use this command!", player);
                    FreeSQLQuery(q);
                }
                else 
                {
                    MessagePlayer(COLOR_RED + "No such location with name " + locName + " exists!", player);
                }
            } else  MessagePlayer(COLOR_RED + "Correct usage: /gotoloc <loc name>", player)
            break;
        }
        case "goto": {
            if(text) {
                local plr = GetPlayer(text);
                if(plr) {
                    if(player.IsSpawned) {
                        if(plr.IsSpawned) {
                            if(!playerData[plr.ID].nogoto) {
                                if(player.Name != plr.Name) {
                                    if(player.Cash >= 500)
                                    {
                                        player.Cash-=500;
                                        player.Frozen = true;
                                        MessagePlayer(COLOR_YELLOW + "You will be teleported to " + COLOR_WHITE + plr.Name + COLOR_YELLOW + " in 5 seconds to prevent abuse.", player);
                                        NewTimer("TeleportPlayer", 5000, 1, player.ID, plr.Pos.x, plr.Pos.y, plr.Pos.z, player.Angle);
                                    } else MessagePlayer(COLOR_RED + "You need $500 to teleport to another player!", player);
                                } else MessagePlayer(COLOR_RED + "You cannot teleport to yourself!", player);
                            } else MessagePlayer(COLOR_RED + "Target player has no goto enabled!", player);
                        } else MessagePlayer(COLOR_RED + "Target player is not spawned", player);
                    } else MessagePlayer(COLOR_RED + "You have to be spawned to use this command!", player);
                } else MessagePlayer(COLOR_RED + "Player not found!", player);
            } else MessagePlayer(COLOR_RED + "Correct usage: /goto [player]", player);
            break;  
        }
        case "nogoto":
        {
            if(playerData[player.ID].nogoto) {
                playerData[player.ID].nogoto = false;
                MessagePlayer(COLOR_GREEN + "You turned off no goto, players now able to teleport you.", player);
            }
            else {
                playerData[player.ID].nogoto = true;
                MessagePlayer(COLOR_GREEN + "You turned on no goto, players can't teleport you now.", player);
            }
            break;
        }
        case "stats":
        {
            if(!text)
            {
                MessagePlayer(
                    COLOR_PINK + "Your stats:" +
                    COLOR_GRAY + " Kills: " + COLOR_WHITE + playerData[player.ID].kills + 
                    COLOR_GRAY + " Deaths: " + COLOR_WHITE + playerData[player.ID].deaths + 
                    COLOR_GRAY + " Headshots: " + COLOR_WHITE + playerData[player.ID].headshots + 
                    COLOR_GRAY + " K/D Ratio: " + COLOR_WHITE + playerData[player.ID].kills.tofloat() / playerData[player.ID].deaths.tofloat() +
                    COLOR_GRAY + " Top spree: " + COLOR_WHITE + playerData[player.ID].topspree, player);

            }
            else {
                local targetplr = GetPlayer(text)
                if(targetplr)
                {
                MessagePlayer(
                    COLOR_PINK + targetplr.Name + "'s' stats:" +
                    COLOR_GRAY + " Kills: " + COLOR_WHITE + playerData[targetplr.ID].kills + 
                    COLOR_GRAY + " Deaths: " + COLOR_WHITE + playerData[targetplr.ID].deaths + 
                    COLOR_GRAY + " Headshots: " + COLOR_WHITE + playerData[targetplr.ID].headshots + 
                    COLOR_GRAY + " K/D Ratio: " + COLOR_WHITE + playerData[targetplr.ID].kills.tofloat() / playerData[targetplr.ID].deaths.tofloat() +
                    COLOR_GRAY + " Top spree: " + COLOR_WHITE + playerData[targetplr.ID].topspree, player);
                }
                else MessagePlayer(COLOR_RED + "Error: Player not found!", player);
            }
            break;
        }
        case "sessionstats":
        {
            MessagePlayer(COLOR_PINK + "Session stats: Kills: " + COLOR_WHITE + playerData[player.ID].session_kills + COLOR_GRAY + " Deaths: " + COLOR_WHITE + playerData[player.ID].session_deaths + COLOR_GRAY " K/D Ratio: " + COLOR_WHITE + playerData[player.ID].kills.tofloat() / playerData[player.ID].deaths.tofloat(), player)
            break;
        }
        case "rules":
        {
            MessagePlayer(COLOR_YELLOW + "Following is not allowed: " + COLOR_WHITE + "Stat padding, racism, spamming, death evasion, mute evasion, ban evasion, usage of vpn, script bug abuse, any kind of wall glitching, game modifications, trainers, team killing, spawn killing and advertisement", player);
            break;
        }
        case "flip":
        {
            if(player.Vehicle)
            {
                local rot = player.Vehicle.Rotation;
                player.Vehicle.Rotation = Quaternion( 0.0, 0.0, rot.z, rot.w );
            } 
            break;
        }
        case "fix":
        {
            if(player.Vehicle)
            {
                if(playerData[player.ID].fix)
                {
                    if(player.Cash >= 500)
                    {
                        if(player.Vehicle.Health >= 250)
                        {
                            playerData[player.ID].fix = false;
                            player.DecCash(500);
                            player.Vehicle.Fix();
                            MessagePlayer(COLOR_GREEN + "You've repaired your vehicle for 500$!", player);
                            NewTimer("fixTimer", 30 * 1000, 1, player.ID);
                        }
                        else MessagePlayer(COLOR_RED + "You can't repair vehicle while its on fire!", player);
                    }
                    else MessagePlayer(COLOR_RED + "You need 500$ to use this command!", player);
                }
                else MessagePlayer(COLOR_RED + "You can use this command in every 30 seconds!", player);
            }
            else MessagePlayer(COLOR_RED + "You can use this command only on vehicle!", player);
            break;
        }
        case "spec":
        case "spectate":
        {
            if(!player.IsSpawned || playerData[player.ID].adminlevel >= 1)
            {
                if(text)
                {
                    local targetplr = GetPlayer(text)
                    if(targetplr)
                    {
                        if(targetplr.ID != player.ID)
                        {
                            if(targetplr.IsSpawned)
                            {
                                MessagePlayer(COLOR_GREEN + "You've entered spectator mode.", player);
                                MessagePlayer(COLOR_GREEN + "Press backspace to exit from spectator mode.", player);
                                player.SpectateTarget = targetplr;
                            } else MessagePlayer(COLOR_RED + "Target player is not spawned!", player);
                        }
                        else MessagePlayer(COLOR_RED + "You can't spectate yourself!", player);
                    }
                    else MessagePlayer(COLOR_RED + "Target player not found!", player);
                }
                else MessagePlayer(COLOR_RED + "Correct usage: /spec <player>", player);
            }
            break;
        }
        case "buycar":
        {
            if(playerData[player.ID].registered)
            {
                if(player.Vehicle)
                {
                    if(GetVehiclePrice(player.Vehicle.Model) != 0)
                    {
                        local q = QuerySQL(personalVehDb, "SELECT * FROM vehicles WHERE owner='"+player.Name+"' COLLATE NOCASE")
                        if(q)
                        {
                            MessagePlayer(COLOR_RED + "You already own a vehicle. Use /sellcar if you want to sell it.", player);
                            FreeSQLQuery(q);
                        }
                        else 
                        {
                            if(GetVehiclePrice(player.Vehicle.Model) > 0)
                            {
                                if(player.Money >= GetVehiclePrice(player.Vehicle.Model))
                                {
                                    player.DecCash(GetVehiclePrice(player.Vehicle.Model));
                                    QuerySQL(personalVehDb, "INSERT INTO vehicles(owner,vehicleid) VALUES('"+player.Name+"','"+player.Vehicle.Model+"')");
                                    MessagePlayer(COLOR_YELLOW + "You successfully bought " + COLOR_WHITE + GetVehicleNameFromModel(player.Vehicle.Model) + COLOR_YELLOW + " for " + COLOR_WHITE + GetVehiclePrice(player.Vehicle.Model) + "!", player);
                                }    
                                else MessagePlayer(COLOR_RED + "You need " + COLOR_WHITE + GetVehiclePrice(player.Vehicle.Model) + "$" + COLOR_RED + " to buy this vehicle!", player );
                            }
                            else MessagePlayer(COLOR_RED + "This vehicle is not for sale!", player);
                        }
                    }
                    else MessagePlayer(COLOR_RED + "This vehicle is not for sale!", player);
                }
                else MessagePlayer(COLOR_RED + "Get in the vehicle you wish to buy, then use this command.", player);
            }
            else MessagePlayer(COLOR_RED + "You must be registered to buy a vehicle.", player);
            break;
        }
        case "car":
        case "mycar":
        {
            if(player.Vehicle)
            {
                MessagePlayer(COLOR_WHITE + "You are currently driving " + COLOR_GREEN + GetVehicleNameFromModel(player.Vehicle.Model), player);
                if(GetVehiclePrice(player.Vehicle.Model) == 0) MessagePlayer(COLOR_WHITE + "This vehicle is not for sale.", player);
                else MessagePlayer(COLOR_WHITE + "This vehicle is on sale for " + COLOR_GREEN + GetVehiclePrice(player.Vehicle.Model) + "$", player);
            }
            else MessagePlayer(COLOR_RED + "You are not in a vehicle!", player);
            break;
        }
        case "spawncar":
        case "getcar":
        {
            local q = QuerySQL(personalVehDb, "SELECT * FROM vehicles WHERE owner='"+player.Name+"' COLLATE NOCASE");
            if(q)
            {
                if(player.IsSpawned)
                {
                    if(!player.Vehicle)
                    {
                        local vehmodel = GetSQLColumnData(q, 2);
                        if(playerData[player.ID].personalVehicle)
                        {
                            playerData[player.ID].personalVehicle.Delete();
                            playerData[player.ID].personalVehicle = CreateVehicle( vehmodel, Vector(player.Pos.x + 2, player.Pos.y, player.Pos.z), player.Angle, Random(0,90), Random(0,90) );
                            MessagePlayer(COLOR_WHITE + "Spawned vehicle: " + COLOR_GREEN + GetVehicleNameFromModel(vehmodel), player);
                        }
                        else {
                            playerData[player.ID].personalVehicle = CreateVehicle( vehmodel, Vector(player.Pos.x + 2, player.Pos.y, player.Pos.z), player.Angle, Random(0,90), Random(0,90) );
                            MessagePlayer(COLOR_WHITE + "Spawned vehicle: " + COLOR_GREEN + GetVehicleNameFromModel(vehmodel), player);
                        }
                    }
                    else MessagePlayer(COLOR_RED + "You can't use this command in vehicle!", player);
                }
                else MessagePlayer(COLOR_RED + "You have to be spawned to use this command!", player);
                FreeSQLQuery(q);
            }
            else MessagePlayer(COLOR_RED + "You don't own a vehicle!", player);
            break;
        }
        case "sellcar":
        {   
            local q = QuerySQL(personalVehDb, "SELECT * FROM vehicles WHERE owner='"+player.Name+"' COLLATE NOCASE");
            if(q)
            {
                local ownedVehicle = GetSQLColumnData(q, 2);
                player.IncCash(GetVehiclePrice(ownedVehicle) / 2);
                QuerySQL(personalVehDb, "DELETE FROM vehicles WHERE owner='"+player.Name+"' COLLATE NOCASE");
                MessagePlayer(COLOR_GREEN + "You sold " + COLOR_WHITE + GetVehicleNameFromModel(ownedVehicle) + COLOR_GREEN + " for " + COLOR_WHITE + GetVehiclePrice(ownedVehicle) / 2 + "$!", player);
                FreeSQLQuery(q);
            }
            else MessagePlayer(COLOR_RED + "You don't own a vehicle.", player);
            break;
        }
        default:
        {
            MessagePlayer(COLOR_YELLOW + "No such commands exists, use " + COLOR_WHITE + "/commands " + COLOR_YELLOW + "to see commands list.", player)
        }
    }
}