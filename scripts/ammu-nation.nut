/*
    Ammu-Nation weapons
    WEAPON          PRICE   AMMO
    Chainsaw        2500$      1
    Grenades        5000$     10
    RPG             9500$      7
    Flame Thrower   6500$     600
*/

ammuNations <-
[ 
    [Vector(-676.333, 1204.71, 11.10)], // Downtown ammu nation
    [Vector(364.518, 1057.24, 19.202)], // Vice Point Mall ammu nation
    [Vector(-62.78, -1481.37, 10.483)], // Ocean beach ammu nation
]

weapons <- 
[
    [11, 2500, 1],
    [12, 5000, 10],
    [30, 9500, 7],
    [31, 6500, 600],
]

function loadAmmuNations()
{
    for(local i = 0; i < ammuNations.len(); ++i)
    {
        CreateCheckpoint(null, 1, true, ammuNations[i][0], ARGB(255, 125, 255, 255), 1.8);
        CreateMarker( 1, ammuNations[i][0], 1, RGBA(255, 255, 255, 255), 16 );
    }
}

function onCheckpointExited(player, checkpoint)
{
    playerData[player.ID].buymode = false;
}