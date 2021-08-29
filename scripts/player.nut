class Player 
{
    constructor()
    {
        // Set player's spawnwep list to m60, m4, uzi, stubby by default. They can change it later with /spawnwep.
        spawnweps = array( 4, null ); 
        spawnweps.insert(0, WEP_M60); 
        spawnweps.insert(1, WEP_M4); 
        spawnweps.insert(2, WEP_UZI); 
        spawnweps.insert(3, WEP_STUBBY); 

        healPos = Vector(0,0,0);
        deathpos = Vector(0,0,0);
    }
    kills = 0;
    deaths = 0;
    headshots = 0;
    topspree = 0;
    adminlevel = 0;

    spree = 0;

    session_kills = 0;
    session_deaths = 0;

    registered = false;
    logged = false;

    diepos = false;
    deathpos = null;
    isDieposSet = false;

    muted = false;
    nogoto = false;
    spawnweps = null;

    jitter = 0;

    wrongpass_warn = 0;
    teamkilling_warn = 0;
    fps_warn = 0;
    ping_warn = 0;
    jitter_warn = 0;
    recent_ping = 0;
    
    healingProcess = false;
    fix = true;
    buymode = false;
    healPos = null;

    healTimer = null;
    spawnTimer = null;

    personalVehicle = null;
}

function CPlayer::Mute(admin, duration)
{
    ::playerData[ID].muted = true;
    ::Message(::COLOR_BLUE + "Admin " + ::COLOR_WHITE + admin + ::COLOR_BLUE + " muted " + ::COLOR_WHITE + Name + ::COLOR_BLUE + " duration: " + ::COLOR_WHITE + duration + ::COLOR_BLUE + " seconds." ); 
    ::NewTimer("Unmute", duration * 1000, 1, "Server", ID);
}

function CPlayer::Drown(admin, reason)
{
    Pos = ::Vector(-636,376,10);
    ::Announce("Drowned!", this, 3);
    ::Message(::COLOR_BLUE + "Admin " + ::COLOR_WHITE + admin + ::COLOR_BLUE + " drowned " + ::COLOR_WHITE + Name + ::COLOR_BLUE + " reason: ( " + ::COLOR_WHITE + reason + ::COLOR_BLUE + " )");
}


function CPlayer::Slap(admin, reason)
{
    Pos = ::Vector(Pos.x, Pos.y, Pos.z + 5);
    ::Message(::COLOR_BLUE + "Admin " + ::COLOR_WHITE + admin + ::COLOR_BLUE + " slapped " + ::COLOR_WHITE + Name + ::COLOR_BLUE + " reason: ( " + ::COLOR_WHITE + reason + ::COLOR_BLUE + " )");
}

function CPlayer::Kick(admin, reason)
{
    ::Message(::COLOR_BLUE + "Admin " + ::COLOR_WHITE + admin + ::COLOR_BLUE + " kicked " + ::COLOR_WHITE + Name + ::COLOR_BLUE + " reason: ( " + ::COLOR_WHITE + reason + ::COLOR_BLUE + " )");
    ::KickPlayer(this);
}

function CPlayer::Unmute()
{
    ::playerData[ID].muted = false;
}

function CPlayer::GiveArmour(amount)
{
    if(Armour + amount > 100) Armour = 100;
    else Armour+=amount; 
}

function CPlayer::SetSpawnWeps()
{
    for(local i = 0; i < ::playerData[ID].spawnweps.len(); ++i) 
    {
        if(::playerData[ID].spawnweps[i] != null) 
            SetWeapon( ::playerData[ID].spawnweps[i],9999)
    }
}

function CPlayer::IncCash(amount)
{
    if(Cash <= 99999999)
        Cash+=amount;
        ::accounts.SaveData(this);
}

function CPlayer::DecCash(amount)
{
    if(Cash - amount < 0) Cash = 0;
    else Cash = Cash - amount;
    ::accounts.SaveData(this);
}

function CPlayer::IsBanned()
{
    local q = ::QuerySQL(::banDb, "SELECT * FROM bans WHERE banned='"+Name+"' or uid='"+UniqueID+"' or uid2='"+UniqueID2+"' or banned_ip='"+IP+"'");
    if(q)
    {
        local isPerma   = ::GetSQLColumnData(q, 4)
        local admin     = ::GetSQLColumnData(q, 5)
        local reason    = ::GetSQLColumnData(q, 6)
        if(isPerma) {
            ::Message(::COLOR_RED + "Enforcing permanent ban on: " + ::COLOR_WHITE + Name + ::COLOR_RED + " admin banned: " + ::COLOR_WHITE + admin + ::COLOR_RED + " reason: " + ::COLOR_WHITE + reason );
            ::KickPlayer(this);
        }
        else {
            if(::time() >= ::GetSQLColumnData(q, 3)) // If ban time is expired.
            {
                ::QuerySQL(::banDb, "DELETE FROM bans WHERE id='"+::GetSQLColumnData(q, 0)+"'");
            }
            else 
            {
                ::Message(::COLOR_RED + "Enforcing temporary ban on: " + ::COLOR_WHITE + Name + ::COLOR_RED + " admin banned: " + ::COLOR_WHITE + admin + ::COLOR_RED + " reason: " + ::COLOR_WHITE + reason + ::COLOR_RED + " time left: " + ::COLOR_WHITE + ::bans.ConvertSecondsToDate(::GetSQLColumnData(q, 3) - ::time()));
                ::KickPlayer(this);
            }
        }
        ::FreeSQLQuery(q);
    }
}

function Unmute(admin, playerid)
{
    local player = GetPlayer(playerid)
    if(player && playerData[player.ID].muted)
    {
        player.Unmute();
    }
}
