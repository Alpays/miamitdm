function TeleportPlayer(playerId, x, y, z, a)
{
    local player = GetPlayer(playerId)
    if(player)
    {
        player.Frozen = false;
        player.Angle = a;
        player.Pos = Vector(x,y,z)
        Message(COLOR_YELLOW + player.Name + COLOR_WHITE + " teleported to " + COLOR_YELLOW + GetLocation(player.Pos.x, player.Pos.y));
    }
}

function GetVehiclePrice(vehiclemodel)
{
    switch(vehiclemodel)
    {
        case 130: return 70000;
        case 131: return 85000;       
        case 132: return 150000;
        case 135: return 100000;
        case 141: return 200000;
        case 142: return 95000;
        case 143: return 75000;
        case 145: return 175000;
        case 150: return 90000;
        case 156: return 72500;
        case 159: return 125000;
        case 164: return 110000;
        case 166: return 135000;
        case 168: case 216: return 97500;
        case 174: return 115000;
        case 178: return 85000;
        case 179: return 100000;
        case 188: return 116000;
        case 191: return 190000;
        case 198: return 144000;
        case 205: return 67000;
        case 206: return 87000;
        case 208: return 40000;
        case 210: return 132000;
        case 211: return 130000;
        case 224: case 232: case 233: return 215000;
        default: return 0;
    }
}

function fixTimer(playerid)
{
    local player = GetPlayer(playerid)
    if(player) playerData[player.ID].fix = true;
}

function SetServerSettings()
{
    SetWallglitch( false );
    SetJoinMessages( false );
    SetDeathMessages( false );
    SetTimeRate( 1000 );
    SetTaxiBoostJump( true );
    SetStuntBike( false );
    SetWeather( WEATHER_CLEAR );
    SetDrivebyEnabled( false );
	SetServerName( "[0.4] Miami Team Deathmatch" );
	SetGameModeName( "v1.0 (Squirrel)" );
    SetVehiclesForcedRespawnHeight( 1000 );
}

function SetSpawnSettings()
{
    SetSpawnPlayerPos(230.047,-1262.99,20.1109);
    SetSpawnCameraPos( 229.017, -1268.03, 20.5001 );
    SetSpawnCameraLook( 229.42, -1266.19, 20.1137 ); 
}

function AddClasses()
{
    AddClass( 1,  RGB(204, 102, 0), 87, Vector(8.07, 1120.51, 16.6703), -3.06, 26,9999,0,0,0,0 ); // Shark 
    AddClass( 1,  RGB(204, 102, 0), 88, Vector(8.07, 1120.51, 16.6703), -3.06, 26,9999,0,0,0,0 ); // Shark
    AddClass( 2,  RGB(247,239,3), 74, Vector(-993.331, 198.032, 15.2197), 1.50, 26,9999,0,0,0,0 ); // Taxi driver
    AddClass( 2,  RGB(247,239,3), 28, Vector(-993.331, 198.032, 15.2197), 1.50, 26,9999,0,0,0,0 ); // Taxi driver
    AddClass( 3,  RGB(239,238,215), 83, Vector(-1169, -616, 11.82), 0.12, 26,9999,0,0,0,0 ); // Cuban
    AddClass( 3,  RGB(239,238,215), 84, Vector(-1169, -616, 11.82), 0.12, 26,9999,0,0,0,0 ); // Cuban
    AddClass( 4,  RGB(51,24,226), 85, Vector(-998.031, 97.5387, 9.72), 0, 26,9999,0,0,0,0 ); // Haitian
    AddClass( 4,  RGB(51,24,226), 86, Vector(-998.031, 97.5387, 9.72), 0, 26,9999,0,0,0,0 ); // Haitian
    AddClass( 5,  RGB(16,199,255), 0, Vector(-378.637, -590.752, 25.3263), 0, 26,9999,0,0,0,0 ); // Vercetti Family
    AddClass( 5,  RGB(16,199,255), 95, Vector(-378.637, -590.752, 25.3263), 0, 26,9999,0,0,0,0 ); // Vercetti Family
    AddClass( 6,  RGB(255,55,16), 1, Vector(399.914, -468.505, 11.74), -0.65, 26,9999,0,0,0,0 ); // Cop
    AddClass( 6,  RGB(255,55,16), 3, Vector(399.914, -468.505, 11.74), -0.65, 26,9999,0,0,0,0 ); // F.B.I.
    AddClass( 7,  RGB(255,16,191), 6, Vector(-694.795, 766.058, 11.08), -2.26, 26,9999,0,0,0,0 ); // Fireman
    AddClass( 8,  RGB(183,255,16), 56, Vector(-575.725, 794.523, 22.87), 1.59, 26,9999,0,0,0,0 ); // Businessman
    AddClass( 8,  RGB(183,255,16), 68, Vector(-575.725, 794.523, 22.87), 1.59, 26,9999,0,0,0,0 ); // Businessman 
    AddClass( 9,  RGB(128,128,128), 93, Vector(-597.688, 654.14, 11.07), 0.19, 26,9999,0,0,0,0 ); // Biker
    AddClass( 9,  RGB(128,128,128), 94, Vector(-597.688, 654.14, 11.07), 0.19, 26,9999,0,0,0,0 ); // Biker
    AddClass( 10, RGB(236,41,138), 49, Vector(87.74, -841, 10.31), -0.95, 26, 9999, 0,0,0,0); // Lady
    AddClass( 10, RGB(236,41,138), 22, Vector(87.74, -841, 10.31), -0.95, 26, 9999, 0,0,0,0); // Lady
}

function HealPlayer(playerid)
{
    local player = GetPlayer(playerid);
    if(player)
    {
        if(player.Health < 100)
        {
            if(player.Cash >= 500)
            {
                local startPosX = playerData[player.ID].healPos.x;
                local startPosY = playerData[player.ID].healPos.y;
                local startPosZ = playerData[player.ID].healPos.z;
                if(player.Pos.x == startPosX && player.Pos.y == startPosY && player.Pos.z == startPosZ)
                {
                    player.DecCash(500);
                    player.Health = 100;
                    MessagePlayer(COLOR_GREEN + "You've successfully healed! Cost: 500$", player);
                }
                else MessagePlayer(COLOR_RED + "Healing failed, you moved.", player);
            }
            else MessagePlayer(COLOR_RED + "You need 500$ to heal!", player);
        }
        else MessagePlayer(COLOR_RED + "Your health is already full!", player);
        playerData[player.ID].healTimer.Delete();
        playerData[player.ID].healTimer = null;
    }
}


function endSpawnProtection(playerid)
{
    local player = GetPlayer(playerid)
    if(player)
    {
        playerData[player.ID].spawnTimer = null;
        player.World = 1;
        MessagePlayer(COLOR_YELLOW + "Info:" + COLOR_WHITE + " spawn protection ended.", player);
    }
}

function SendMessageToStaffChat(adminNickname, message)
{
    for(local i = 0; i < GetMaxPlayers(); ++i)
    {
        local player = GetPlayer(i)
        if(player)
        {
            if(playerData[player.ID].adminlevel >= 1)
            {
                MessagePlayer("[#1FD53D][STAFF CHAT] " + adminNickname + ": " + message, player);
            }
        }
    }
}

function SendMessageToTeamChat(playerid, message)
{
    local player = GetPlayer(playerid)
    if(player)
    {
        for(local i = 0; i < GetMaxPlayers(); ++i)
        {
            local targetplr = GetPlayer(i)
            if(targetplr && player.Team == targetplr.Team)
            {
                if(player.Team != 255) MessagePlayer("[#FFFF99][Team] " + player.Name + ": " + message, targetplr);
            }
        }
    }
}
