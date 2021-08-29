pinglimit <- 350;
fpslimit <- 23;
warnlimit <- 5;
jitterlimit <- 100;

function CheckPlayer()
{   
    for(local i = 0; i < GetMaxPlayers(); ++i)
    {
        local player = GetPlayer(i);
        if(player && player.IsSpawned)
        {
            if(player.Ping > pinglimit)
            {
                playerData[player.ID].ping_warn++;
                MessagePlayer(COLOR_RED + "Warning: Your Ping is higher than the limit (" + player.Ping + "/" + pinglimit + ") fix it avoid to getting kicked. (" + playerData[player.ID].ping_warn + "/" + warnlimit + ")", player);
            }
            if(player.FPS < fpslimit)
            {
                playerData[player.ID].fps_warn++;
                MessagePlayer(COLOR_RED + "Warning: Your FPS is lower than the limit (" + player.FPS + "/" + fpslimit + ") fix it avoid to getting kicked. (" + playerData[player.ID].fps_warn + "/" + warnlimit + ")", player);
            }
            if(playerData[player.ID].recent_ping > 0)
            {
                local jitter = player.Ping - playerData[player.ID].recent_ping;
                if(jitter > jitterlimit)
                {
                    playerData[player.ID].jitter_warn++;
                    MessagePlayer(COLOR_RED + "Warning: Your jitter is higher than the limit (" + jitter + "/" + jitterlimit + ") fix it avoid to getting kicked. (" + playerData[player.ID].jitter_warn + "/" + warnlimit + ")", player);
                }
                if(playerData[player.ID].jitter_warn == warnlimit) player.Kick("Server", "Jitter is higher than the limit. (" + jitter + "/" + jitterlimit + ")");
            }
            if(playerData[player.ID].fps_warn == warnlimit) player.Kick("Server", "FPS is lower than the limit. Minimum FPS: " + fpslimit);
            if(playerData[player.ID].ping_warn == warnlimit) player.Kick("Server", "Ping is higher than the limit. Maximum Ping: " + pinglimit);
            playerData[player.ID].recent_ping = player.Ping;
        }
    }
}

NewTimer("CheckPlayer", 15 * 1000, 0)