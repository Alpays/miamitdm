COLOR_RED       <- "[#FF3333]";
COLOR_BLACK     <- "[#000000]";
COLOR_YELLOW    <- "[#FFFF00]";
COLOR_GREEN     <- "[#00FF00]";
COLOR_BLUE      <- "[#00FFFF]";
COLOR_ORANGE    <- "[#FF8000]";
COLOR_PINK      <- "[#FF99FF]";
COLOR_PURPLE    <- "[#CC00CC]";
COLOR_WHITE     <- "[#FFFFFF]";
COLOR_GRAY      <- "[#C0C0C0]";

function GetLocation(x, y)
{
    local locationname = GetDistrictName(x, y);
    if(locationname == "Downtown Vice City") locationname = "Downtown";
    return locationname;    
}

function GetBodypartName(bodypart)
{
    switch(bodypart)
    {
        case 0: return "Body";
        case 1: return "Torso";
        case 2: return "Left Arm";
        case 3: return "Right Arm";
        case 4: return "Left Leg";
        case 5: return "Right Leg";
        case 6: return "Head";
        default: return "Unknown";
    }
}

function GetWeaponType(weapon)
{
    switch(weapon)
    {
        case 0:
            return "Fist";
        case 1: case 2: case 3: 
        case 4: case 5: case 6: case 7:
        case 8: case 9: case 10: case 11:
            return "Melee";
        case 12: case 13: case 14: case 15:
            return "Grenade";
        case 17: case 18:
            return "Pistol";
        case 19: case 20: case 21:
            return "Shotgun";
        case 22: case 23: case 24: case 25:
            return "Submachine";
        case 26: case 27: 
            return "Rifle";
        case 28: case 29: 
            return "Sniper";
        case 30: case 31: case 32: case 33:
            return "Heavy";
        default:
            return "Unknown";
    }
}

function Random(min, max)
{
    if ( min < max )
        return rand() % (max - min + 1) + min.tointeger();
    else if ( min > max )
        return rand() % (min - max + 1) + max.tointeger();
    else if ( min == max )
        return min.tointeger();
}

function GetTok(string, separator, n, ...)
{
    if(string != null) {
        local m = vargv.len() > 0 ? vargv[0] : n,
        tokenized = split(string, separator),
        text = "";
        if (n > tokenized.len() || n < 1) return null;
        for (; n <= m; n++)
        {
            text += text == "" ? tokenized[n-1] : separator + tokenized[n-1];
        }
        return text;
    }
}

function NumTok(string, separator) 
{ 
    local tokenized = split(string, separator); return tokenized.len(); 
}

function GetPlayer(plr) 
{
    switch(typeof(plr))
    {
        case "integer": return FindPlayer(plr);
        case "string":
        {
            if(IsNum(plr)) plr = plr.tointeger();
            return FindPlayer(plr);
        }
        default:
        {
            return null;
        }
    }
}

// Different message as per weapon type.
function getKillMessage(weapon)
{
    switch(GetWeaponType(weapon))
    {
        case "Fist":       return "fisted";
        case "Sniper":     return "sniped";
        default:           return "killed";
    }
}

function GetWeaponSlot(weaponid)
{
    if(weaponid <= 1) return 0;
    else if(weaponid <= 11) return 1;
    else if(weaponid <= 15) return 2;
    else if(weaponid <= 18) return 3;
    else if(weaponid <= 21) return 4;
    else if(weaponid <= 25) return 5;
    else if(weaponid <= 27) return 6;
    else if(weaponid <= 29) return 8;
    else if(weaponid <= 33) return 7;
}