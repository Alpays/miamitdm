function onPlayerAdminCommand(player, cmd, text, adminlevel)
{
    switch(cmd)
    {
        // Level 1 Admin (Moderator) commands
        case "acmds":
        case "admincmds":
        case "acommands":
        {
            switch(adminlevel)
            {
                case 1:
                {
                    MessagePlayer(COLOR_PINK + "Level 1 admin commands:" + COLOR_WHITE + " /acmds /ac /mypos /setweather /kick /announce /announce2 /announceall /announceall2 /drown /mute /unmute /slap /disarm /settime /fpv", player)
                    break;
                }
                case 2:
                {
                    MessagePlayer(COLOR_PINK + "Level 2 admin commands:" + COLOR_WHITE + " /acmds /ac /mypos /setweather /kick /announce /announce2 /announceall /announceall2 /drown /mute /unmute /slap /disarm /settime /fpv /reward /givewep /givewepall /ban /tempban /unban /unbanip /createvehicle /bring /agoto /sethp /setjitterlimit /transfernick", player)
                    break;
                }
                case 3:
                {
                    MessagePlayer(COLOR_PINK + "Level 3 admin commands:" + COLOR_WHITE + " /acmds /ac /mypos /setweather /kick /announce /announce2 /announceall /announceall2 /drown /mute /unmute /slap /disarm /settime /fpv /reward /givewep /givewepall /ban /tempban /unban /unbanip /createvehicle /bring /agoto /sethp /setjitterlimit /transfernick /addvehicle /getvehicleinfo /getbaninfo /adminlevel /exec", player)
                }
            }
            break;
        }
        case "mypos":
        {
            if(adminlevel >= 1)
            {
                MessagePlayer(COLOR_BLUE + "Your Position: X: " + player.Pos.x + " Y: " + player.Pos.y + " Z: " + player.Pos.z + " Angle: " + player.Angle, player);
            }
            break;
        }
        case "weather":
        case "setweather":
        {
            if(adminlevel >= 1) 
            {  
                if(text && IsNum(text))
                {
                    local weather = text.tointeger();
                    if(weather >= 0 && weather <= 5) // IDs above 5 are corrupt weathers
                    {
                        SetWeather(weather);
                        Message(COLOR_BLUE + "Admin " + COLOR_WHITE + player.Name + COLOR_BLUE + " has set weather to [" + COLOR_WHITE + weather + COLOR_BLUE + "]");
                    }
                    else MessagePlayer(COLOR_RED + "Invalid weather id.", player);
                }
                else MessagePlayer(COLOR_RED + "Correct usage: /setweather <weather id>", player);
            }
            break;
        }
        case "time":
        case "settime":
        {
            if(adminlevel >= 1)
            {
                if(text && IsNum(GetTok(text, " ", 1)))
                {
                    local hour = GetTok(text, " ", 1).tointeger();
                    if(NumTok(text, " ") != 2) 
                    {
                        SetHour(hour);
                        SetMinute(0);
                        Message(COLOR_BLUE + "Admin " + COLOR_WHITE + player.Name + COLOR_BLUE + " set time to " + COLOR_WHITE + hour + ":00");
                    }
                    else if(IsNum(GetTok(text, " ", 2))) {
                        local minute = GetTok(text, " ", 2).tointeger();
                        SetHour(hour);
                        SetMinute(minute);
                        Message(COLOR_BLUE + "Admin " + COLOR_WHITE + player.Name + COLOR_BLUE + " set time to " + COLOR_WHITE + hour + ":" + minute);
                    }
                    else MessagePlayer(COLOR_RED + "Correct usage: /settime <hour> [<minute>]", player);
                }
                else MessagePlayer(COLOR_RED + "Correct usage: /settime <hour> [<minute>]", player);
            }
            break;
        }
        case "kick":
        {
            if(adminlevel >= 1) 
            {  
                if(text && NumTok(text, " ") >= 2) 
                {
                    local targetplr = GetPlayer(GetTok(text, " ", 1));
                    local reason = GetTok(text, " ", 2 NumTok(text, " "));
                    if(targetplr)
                    {
                        targetplr.Kick(player.Name, reason);
                    } else MessagePlayer(COLOR_RED + "Player not found!", player)
                } else MessagePlayer(COLOR_RED + "Correct usage: /kick <player> <reason>", player)
            }
            break;
        }
        case "announce":
        {
                if(adminlevel >= 1)
                {
                if(text) 
                {
                    local targetplr = GetPlayer(GetTok(text, " ", 1));
                    local announcement = GetTok(text, " ", 2 NumTok(text, " "));
                    if(targetplr)
                    {
                        if(announcement){
                            Announce(announcement, targetplr, 1);
                            SendMessageToStaffChat("Server", player.Name + " announced " + announcement + " to " + targetplr.Name);
                        } else MessagePlayer(COLOR_RED + "Correct usage: /announce <player> <text>", player);
                    } else MessagePlayer(COLOR_RED + "Player not found!", player);
                } else MessagePlayer(COLOR_RED + "Correct usage: /announce <player> <text>", player);
            }
            break;
        }
        case "announce2":
        {
            if(adminlevel >= 1)
            {
                if(text) 
                {
                    local targetplr = GetPlayer(GetTok(text, " ", 1));
                    local announcement = GetTok(text, " ", 2 NumTok(text, " "));
                    if(targetplr)
                    {
                        if(announcement){
                            Announce(announcement, targetplr, 3);
                            SendMessageToStaffChat("Server", player.Name + " announced " + announcement + " to " + targetplr.Name);
                        } MessagePlayer(COLOR_RED + "Correct usage: /announce2 <player> <text>", player);
                    } else MessagePlayer(COLOR_RED + "Player not found!", player);
                } else MessagePlayer(COLOR_RED + "Correct usage: /announce2 <player> <text>", player);
            }
            break;
        }
        case "mute":
        {
            if(adminlevel >= 1) 
            {
                if(text)
                {
                    local targetplr = GetPlayer(GetTok(text, " ", 1));
                    if(GetTok(text, " ", 2) && IsNum(GetTok(text, " ", 2)))
                    {
                       targetplr.Mute(player.Name, GetTok(text, " ", 2).tointeger());
                    }
                    else MessagePlayer(COLOR_RED + "Correct usage: /mute <player> <duration> (by seconds)", player);
                }
                else MessagePlayer(COLOR_RED + "Correct usage: /mute <player> <duration> (by seconds)", player);
            }
            break;
        }
        case "unmute":
        {
            if(adminlevel >= 1) 
            {
                local targetplr = GetPlayer(text);
                if(targetplr) {
                    if(!playerData[targetplr.ID].muted) {
                        MessagePlayer(COLOR_RED + "This player is not muted!", player);
                        return;
                    }
                    targetplr.Unmute();
                    Message(COLOR_BLUE + "Admin " + COLOR_WHITE + player.Name + COLOR_BLUE + " unmuted " + COLOR_WHITE + targetplr.Name);
                }                
            }
            break;
        }
        case "drown":
        {
            if(adminlevel >= 1) 
            {
                if(text && NumTok(text, " ") >= 2) 
                {
                    local targetplr = GetPlayer(GetTok(text, " ", 1));
                    local reason = GetTok(text, " ", 2 NumTok(text, " "));
                    if(targetplr)
                    {
                        if(targetplr.IsSpawned)
                        {
                            targetplr.Drown(player.Name, reason);
                        }
                        else MessagePlayer(COLOR_RED + "Target player is not spawned!", player);
                    } else MessagePlayer(COLOR_RED + "Player not found!", player)
                } else MessagePlayer(COLOR_RED + "Correct usage: /drown <player> <reason>", player)
            } 
            break;
        }
        case "slap":
        {
            if(adminlevel >= 1) 
            {
                if(text && NumTok(text, " ") >= 2) 
                {
                    local targetplr = GetPlayer(GetTok(text, " ", 1));
                    local reason    = GetTok(text, " ", 2 NumTok(text, " "));
                    if(targetplr)
                    {
                        if(targetplr.IsSpawned) { 
                            targetplr.Slap(player.Name, reason);
                        } else MessagePlayer(COLOR_RED + "Target player ("+player.Name+") is not spawned!", player)
                    } else MessagePlayer(COLOR_RED + "Player not found!", player)
                } else MessagePlayer(COLOR_RED + "Correct usage: /slap [player] [reason]", player)
            } 
            break;            
        }
        case "disarm":
        {
            if(adminlevel >= 1) 
            {
                if(text) {
                    local targetplr = GetPlayer(text)
                    if(targetplr)
                    {
                        targetplr.Disarm();
                        SendMessageToStaffChat("Server", player.Name + " has disarmed " + targetplr.Name)
                        MessagePlayer(COLOR_BLUE + "Admin " + COLOR_WHITE + player.Name + COLOR_BLUE + " disarmed you.", targetplr)
                    } else MessagePlayer(COLOR_RED + "Player not found!", player)
                }  else MessagePlayer(COLOR_RED + "Correct usage: /disarm [player] !", player)
            } 
            break;
        }
        case "announceall":
        {
            if(adminlevel >= 1) 
            {
                if(text) {
                    AnnounceAll(text, 1)
                    SendMessageToStaffChat("Server", player.Name + " announced " + text)
                } else MessagePlayer(COLOR_RED + "Correct usage: /announceall [text]", player)
            } 
            break;
        }       
        case "announceall2":
        {
            if(adminlevel >= 1) 
            {
                if(text) {
                    AnnounceAll(text, 3)
                    SendMessageToStaffChat("Server", player.Name + " announced " + text)
                } else MessagePlayer(COLOR_RED + "Correct usage: /announceall2 <text>", player)
            } 
            break;
        }
        case "ac":
        {
            if(adminlevel >= 1)
            {
                if(text)
                {
                    SendMessageToStaffChat(player.Name, text);
                }
                else MessagePlayer(COLOR_RED + "Correct usage: /ac <text>", player);
            }
            break;
        }
        case "fpv":
        {
            if(adminlevel >= 1)
            {
                if(fpvEnabled)
                {
                    fpvEnabled = false;
                    MessagePlayer(COLOR_YELLOW + "You have disabled First Person View (FPV).", player);
                }
                else {
                    fpvEnabled = true;
                    MessagePlayer(COLOR_YELLOW + "You have enabled First Person View (FPV).", player);
                }
            }
            break;
        }
        // Level 2 Admin commands
        case "bring":
        {
            if(adminlevel >= 2)
            {
                if(text) {
                    local plr = GetPlayer(text)
                    if(plr) {
                        if(plr.IsSpawned) {
                            plr.World = player.World;
                            plr.Pos = player.Pos;
                            plr.Pos.x+=1;
                            plr.Pos.y+=1;
                            SendMessageToStaffChat("Server", player.Name + " has teleported " + plr.Name + " to them");
                        }
                        else MessagePlayer(COLOR_RED + "Target player is not in freemode!", player);
                    } else MessagePlayer(COLOR_RED + "Target player is not found!", player);
                } else MessagePlayer(COLOR_RED + "Correct usage: /bring <player>", player);
            }
            break;
        }
        case "reward":
        {
            if(adminlevel >= 2) 
            {
                if(text) {
                    if(NumTok(text, " ") == 2 && IsNum(GetTok(text, " ", 2)))
                    {
                        local plr = GetPlayer(GetTok(text, " ", 1));
                        local amount = GetTok(text, " ", 2).tointeger();
                        if(plr)
                        {
                            plr.Cash += amount 
                            Message(COLOR_BLUE + "Admin " + COLOR_WHITE + player.Name + COLOR_BLUE + " has rewarded " + COLOR_WHITE + plr.Name + COLOR_BLUE + " amount: [" + COLOR_WHITE + amount.tostring() + "$" + COLOR_BLUE + "]");
                        }
                    } else MessagePlayer(COLOR_RED + "Correct usage: /reward <player> <amount>", player)
                } else MessagePlayer(COLOR_RED + "Correct usage: /reward <player> <amount>", player)
            }  
            break;
        }
        case "givewep":
        {
            if(adminlevel >= 2) 
            {
                if(text) {
                    if(NumTok(text, " ") == 3 && IsNum(GetTok(text, " ", 2)) && IsNum(GetTok(text, " ", 3))) {
                        local targetplr = GetPlayer(GetTok(text, " ", 1))
                        local wep = GetTok(text, " ", 2).tointeger();
                        local ammo = GetTok(text, " ", 3).tointeger();
                        if(targetplr)
                        {
                            targetplr.SetWeapon(wep, ammo)
                            SendMessageToStaffChat("Server", player.Name + " is giving " + GetWeaponName(wep) + " with " + ammo + " ammo to " + targetplr.Name)
                        } else MessagePlayer(COLOR_RED + "Player not found!", player)
                    } else MessagePlayer(COLOR_RED + "Correct usage: /givewep <player> <weapon id> <ammo>", player)
                } else MessagePlayer(COLOR_RED + "Correct usage: /givewep <player> <weapon id> <ammo>", player)
            } 
            break;
        }
        case "givewepall":
        {
            if(adminlevel >= 2) 
            {
                if(text) {
                    if(NumTok(text, " ") == 2 && IsNum(GetTok(text, " ", 1)) && IsNum(GetTok(text, " ", 2))) {
                        local wep = GetTok(text, " ", 2).tointeger();
                        local ammo = GetTok(text, " ", 3).tointeger();
                        for(local i = 0; i < GetMaxPlayers(); ++i)
                        {
                            if(FindPlayer(i)) i.SetWeapon(wep, ammo);
                        }
                        SendMessageToStaffChat("Server", player.Name + " is giving " + GetWeaponName(wep) + " with " + ammo + " ammo to everyone");
                    } else MessagePlayer(COLOR_RED + "Correct usage: /givewepall <weapon id> <ammo>", player)
                } else MessagePlayer(COLOR_RED + "Correct usage: /givewepall <weapon id> <ammo>", player)
            } 
            break;
        }
        case "ban":
        {
            if(adminlevel >= 2)
            {
                 if(text && NumTok(text, " ") >= 2)
                 {
                     local targetplr = GetPlayer(GetTok(text, " ", 1));
                     local reason = GetTok(text, " ", 2 NumTok(text, " "));
                     if(targetplr) {
                        bans.Ban(targetplr.Name, player.Name, reason);
                     }
                     else MessagePlayer(COLOR_RED + "Target player not found!", player);

                 }
                 else MessagePlayer(COLOR_RED + "Correct usage: /ban <player> <reason>", player);
            }
            break;
        }
        case "tempban":
        {
            if(adminlevel >= 2)
            {
                if(text && NumTok(text, " " ) >= 3)
                {
                    local targetplr = GetPlayer(GetTok(text, " ", 1));
                    if(targetplr)
                    {
                        local reason = GetTok(text, " ", 3 NumTok(text, " "))
                        if(!bans.TempBan(targetplr.Name, player.Name, GetTok(text, " ", 2), reason))
                        {
                            MessagePlayer(COLOR_RED + "Invalid duration provided.", player);
                        }
                    }
                    else MessagePlayer(COLOR_RED + "Target player not found!", player);
                }
                else MessagePlayer(COLOR_RED + "Correct usage: /tempban <player> <duration> <reason>", player);        
            }
            break;
        }
        case "unban":
        {
            if(adminlevel >= 2)
            {
                if(text && NumTok(text, " ") > 0)
                {
                    local bannedplr = GetTok(text, " ", 1);
                    if(bans.IsBanned(bannedplr.tolower()))
                    {
                        bans.Unban(bannedplr.tolower());
                        MessagePlayer(COLOR_GREEN + "Player " + COLOR_WHITE + bannedplr + COLOR_RED + " should now be unbanned.", player);
                    }
                    else MessagePlayer(COLOR_RED + "Player " + COLOR_WHITE + bannedplr + COLOR_RED + " is not banned!", player);
                }
                else MessagePlayer(COLOR_RED + "Correct usage: /unban <player name>", player);
            }
            break;
        }
        case "unbanip":
        {
            if(adminlevel >= 2)
            {
                if(text && NumTok(text, " ") > 0)
                {
                    local ip = GetTok(text, " ", 1);
                    if(bans.IsBannedIP(ip))
                    {
                        bans.UnbanIP(ip);
                        MessagePlayer(COLOR_GREEN + "Ip Adress " + COLOR_WHITE + ip + COLOR_GREEN + " should now be unbanned.", player);
                    }
                    else MessagePlayer(COLOR_RED + "Ip Adress " + COLOR_WHITE + ip + COLOR_RED + " is not banned!", player);
                }
                else MessagePlayer(COLOR_RED + "Correct usage: /unbanip <ip adress>", player);
            }
            break;
        }
        case "createvehicle":
		{
            if(adminlevel >= 2) 
            {
                if(text && IsNum(text))
                {
                    local model = text.tointeger();
                    local veh = CreateVehicle( model, player.World, Vector(player.Pos.x + 2,player.Pos.y + 0.7,player.Pos.z), player.Angle, Random(0,90), Random(0,90) );
                    if(veh) veh.SingleUse = true;
                }
                else MessagePlayer(COLOR_RED + "Correct usage: /createvehicle <vehicle id>", player);
            }
            break;
		}
        case "agoto":
        {
            if(adminlevel >= 2)
            {
                if(text) {
                    local targetplr = GetPlayer(text)
                    if(targetplr)
                    {
                        if(player.IsSpawned)
                        {
                            if(targetplr.IsSpawned) 
                            {
                                if(targetplr.Name != player.Name)
                                {
                                    player.Pos = targetplr.Pos;
                                    player.Pos.x+= 2;
                                    SendMessageToStaffChat("Server", player.Name + " teleported to " + targetplr.Name);
                                }
                                else MessagePlayer(COLOR_RED + "You can't teleport to yourself!", player);
                            } else MessagePlayer(COLOR_RED + "Target player is not spawned!", player);
                        } else MessagePlayer(COLOR_RED + "You have to be spawned to use this command!", player);
                    }   
                    else MessagePlayer(COLOR_RED + "Player not found!", player);
                } else MessagePlayer(COLOR_RED + "Correct usage: /agoto <player>", player);
            }
            break;
        }
        case "sethp":
        {
            if(adminlevel >= 2)
            {
                if(text && NumTok(text, " ") == 2)
                {
                    local targetplr = GetPlayer(GetTok(text, " ", 1));
                    local hp = GetTok(text, " ", 2);
                    if(targetplr)
                    {
                        if(IsNum(hp))
                        {
                            hp = hp.tointeger();
                            if(hp > 0 && hp <= 100)
                            {
                                targetplr.Health = hp;
                                SendMessageToStaffChat("Server", player.Name + " has set " + targetplr.Name + "'s hp to " + hp);
                            }
                            else MessagePlayer(COLOR_RED + "Health value must be between 1 and 100!", player);
                        }
                        else MessagePlayer(COLOR_RED + "Health value must be numeric!", player);
                    }
                    else MessagePlayer(COLOR_RED + "Target player not found!", player);
                }
                else MessagePlayer(COLOR_RED + "Correct usage: /sethp <player> <hp>", player);
            }
            break;
        }
        case "setjitterlimit":
        {
            if(adminlevel >= 2)
            {
                if(!text)
                {
                    MessagePlayer(COLOR_YELLOW + "Jitter limit is: " + COLOR_WHITE + jitterlimit, player);
                }
                else {
                    if(IsNum(text))
                    {
                        text = text.tointeger();
                        jitterlimit = text;
                        MessagePlayer(COLOR_GREEN + "Changing jitter limit to " + COLOR_WHITE + text, player);
                    }
                    else MessagePlayer(COLOR_RED + "Correct usage: /setjitterlimit <jitter limit>", player);
                }
            }
            break;
        }
        case "transfernick":
        {
            if(adminlevel >= 2)
            {
                if(!text || NumTok(text, " ") < 2) MessagePlayer(COLOR_RED + "Correct usage: /transfernick <old nick> <new nick>", player);
                else {
                    local oldNickname = GetTok(text, " ", 1);
                    local newNickname = GetTok(text, " ", 2);
                    local q = QuerySQL(accountDb, "SELECT * FROM accounts WHERE username='"+oldNickname+"' COLLATE NOCASE");
                    if(q)
                    {
                        FreeSQLQuery(q);
                        q = QuerySQL(accountDb, "SELECT * FROM accounts WHERE username='"+newNickname+"' COLLATE NOCASE");
                        if(q)
                        {
                            MessagePlayer(COLOR_RED + "An account with " + COLOR_WHITE + newNickname + COLOR_RED + " name exists!", player);
                            FreeSQLQuery(q);
                            return true;
                        }
                        QuerySQL(accountDb,  "UPDATE accounts SET username='"+newNickname+"' WHERE username='"+oldNickname+"' COLLATE NOCASE");
                        QuerySQL(personalVehDb, "UPDATE vehicles SET owner='"+newNickname+"' WHERE owner='"+oldNickname+"' COLLATE NOCASE");
                        SendMessageToStaffChat(player.Name, "changed " + oldNickname + "'s nickname to " + newNickname);
                        for(local i = 0; i < GetMaxPlayers(); ++i)
                        {
                            local plr = FindPlayer(i);
                            if(plr)
                            {
                                if(plr.Name.tolower() == oldNickname.tolower())
                                {
                                    Message(COLOR_WHITE + "Admin " + COLOR_YELLOW + player.Name + COLOR_WHITE + " has changed " + COLOR_YELLOW + plr.Name + COLOR_WHITE + "'s nick to " + COLOR_YELLOW + newNickname );
                                    plr.Name = newNickname;
                                    break;
                                }
                            }
                        }
                    }
                    else MessagePlayer(COLOR_RED + "No player with nickname " + COLOR_WHITE + oldNickname + COLOR_RED + " exists.", player);
                }
            }
            break;
        }
        // Level 3 Admin (Manager, Developer) commands
        case "adminlevel":
        {
            if(adminlevel == 3) 
            {
                if(text) {
                    local targetplr = GetPlayer(GetTok(text, " ", 1))
                    if(targetplr)
                    {
                        if(GetTok(text, " ", 2) == null) return MessagePlayer(COLOR_RED + "Correct usage: /adminlevel [player] [level]", player);
                        local level = GetTok(text, " ", 2).tointeger();
                        if(level >= 0 && level <= 3)
                        {   
                            playerData[targetplr.ID].adminlevel = level;
                            SendMessageToStaffChat("Server", player.Name + " has set " + targetplr.Name + "'s admin level to " + level)
                        } else MessagePlayer(COLOR_RED + "Correct usage: /adminlevel <player> <level (0-3)>", player)
                    } else MessagePlayer(COLOR_RED + "Player not found!", player)
                } else MessagePlayer(COLOR_RED + "Correct usage: /adminlevel <player> <level (0-3)>", player) 
            }
            break;
        }
        case "addvehicle":
        {
            if(adminlevel == 3) 
            {
                if(text) {
                    local vehicle = GetTok(text, " ", 1);
                    local color1 = Random(0,90);
                    local color2 = Random(0,90);
                    if(GetTok(text, " ", 2) != null) color1 = GetTok(text, " ", 2)
                    if(GetTok(text, " ", 3) != null) color2 = GetTok(text, " ", 3)
                    QuerySQL(vehiclesDb, "INSERT INTO vehicles(vehicleid, x, y, z, angle, color1, color2) VALUES('"+vehicle+"','"+player.Pos.x+"','"+player.Pos.y+"','"+player.Pos.z+"','"+player.Angle+"','"+color1+"','"+color2+"')");
                    SendMessageToStaffChat("Server", player.Name + " has added a vehicle into the database with vehicle id: " + vehicle + " color 1: " + color1 + " color 2: " + color2 + " at X: " + player.Pos.x + " Y: " + player.Pos.y + " Z: "+ player.Pos.z)
                } else MessagePlayer(COLOR_RED + "Usage: /addvehicle <vehicle id> [<color 1> <color 2>]", player)
            }
            break;
        }
        case "getvehicleinfo":
        {
            if(adminlevel == 3) 
            {
                if(text && IsNum(text)) {
                    local q = QuerySQL(vehiclesDb, "SELECT * FROM vehicles WHERE id='"+text.tointeger()+"'");
                    if(q){
                        local veh_id = GetSQLColumnData(q, 1);
                        local veh_pos = Vector(GetSQLColumnData(q,2), GetSQLColumnData(q,3), GetSQLColumnData(q,4) );
                        local veh_color1 = GetSQLColumnData(q, 6);
                        local veh_color2 = GetSQLColumnData(q, 7);
                        MessagePlayer(COLOR_GREEN + "Information of vehicle with id: " + text.tointeger() + " is: vehicle's id: " + veh_id + " position x: " + veh_pos.x + " y: " + veh_pos.y + " z: " + veh_pos.z + " first color: " + veh_color1 + " second color: " + veh_color2, player);
                        FreeSQLQuery(q);
                    } else MessagePlayer(COLOR_RED + "There is no vehicle with id " + COLOR_WHITE + text.tointeger() + COLOR_RED +" in database!", player);
                }
                else MessagePlayer(COLOR_RED + "Correct usage: /getvehicleinfo <vehicle id>", player);
            }
            break;
        }
        case "getbaninfo":
        {
            if(adminlevel == 3)
            {
                if(text) {
                    if(IsNum(text))
                    {   
                        text = text.tointeger();
                        local q = QuerySQL(banDb, "SELECT * FROM bans WHERE id='"+text+"'")
                        if(q) 
                        {
                            local nick = GetSQLColumnData(q, 1);
                            local ip = GetSQLColumnData(q, 2);
                            local admin = GetSQLColumnData(q, 5);
                            local reason = GetSQLColumnData(q, 6);
                            local uid = GetSQLColumnData(q, 7);
                            local uid2 = GetSQLColumnData(q, 8);
                            MessagePlayer(
                                COLOR_GREEN + "Information of ban with id " + COLOR_WHITE + text + 
                                COLOR_GREEN + " nickname: " + COLOR_WHITE + nick + 
                                COLOR_GREEN + " uid: " + COLOR_WHITE + uid + COLOR_GREEN + " uid2: " + COLOR_WHITE + uid2 + 
                                COLOR_GREEN + " IP: " + COLOR_WHITE + ip + 
                                COLOR_GREEN + " admin banned: " + COLOR_WHITE + admin + 
                                COLOR_GREEN + " reason: " + COLOR_WHITE + reason
                            ,player )
                            FreeSQLQuery(q);
                        } else MessagePlayer(COLOR_RED + "There is no ban with id " + COLOR_WHITE + text + COLOR_RED + " in database!", player);
                    } else MessagePlayer(COLOR_RED + "Correct usage: /getbaninfo <ban id>", player);
                } else MessagePlayer(COLOR_RED + "Correct usage: /getbaninfo <ban id>", player);
            }
            break;
        }
        case "exec":
        {
            if(adminlevel == 3)
            {
                if(text)
                {
                    try
                    {
                        local script = compilestring( text );
                        script();
                    }
                    catch(e)
                    {
                        MessagePlayer(COLOR_RED + "Error: " + COLOR_WHITE + e, player);
                    }
                }
                else MessagePlayer(COLOR_RED + "Correct usage: /exec <code>", player);
            }
            break;
        }
        case "deletevehicle":
        {
            if(adminlevel == 3)
            {
                if(text && IsNum(text))
                {
                    text = text.tointeger();
                    local q = QuerySQL(vehiclesDb, "DELETE FROM vehicles WHERE id='"+text+"'");
                    SendMessageToStaffChat("Server", player.Name + " has deleted vehicle with id " + text + " from vehicle database.");
                }
                else MessagePlayer(COLOR_RED + "Correct usage: /deletevehicle <id>",player);
            }
            break;
        }
        default:
        {
            return false; 
        }
    }
    return true;
}