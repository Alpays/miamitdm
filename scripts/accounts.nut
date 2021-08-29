accounts <-
{
    function Register(player, password)
    {
        if(player)
        {
            QuerySQL(accountDb, format("INSERT INTO accounts(username,password,autologin,ip,uid,uid2) VALUES('%s','%s','%d','%s','%s','%s')",player.Name, SHA512(password), 1, player.IP, player.UniqueID, player.UniqueID2));
            playerData[player.ID].registered = true;
            playerData[player.ID].logged = true;
            MessagePlayer(COLOR_GREEN + "You have successfully registered!", player);
        }
    }
    function AutoLogin(player)
    {
        if(player)
        {
            local q = QuerySQL(accountDb, "SELECT * FROM accounts WHERE username='"+player.Name+"' COLLATE NOCASE");
            playerData[player.ID].logged = true;
            playerData[player.ID].kills = GetSQLColumnData(q, 3);
            playerData[player.ID].deaths = GetSQLColumnData(q, 4);
            playerData[player.ID].topspree = GetSQLColumnData(q, 5);
            playerData[player.ID].headshots = GetSQLColumnData(q, 6);
            playerData[player.ID].adminlevel = GetSQLColumnData(q, 7);
            player.Cash = GetSQLColumnData(q, 8);
            MessagePlayer(COLOR_GREEN + "You have successfully auto logged in to your account!", player);
            FreeSQLQuery(q);
        }
    }
    function Login(player, password)
    {
        if(player)
        {
            local q = QuerySQL(accountDb, "SELECT * FROM accounts WHERE username='"+player.Name+"' COLLATE NOCASE");
            if(q)
            {
                local cryptedpass = GetSQLColumnData(q, 2);
                if(SHA512(password) == cryptedpass)
                {
                    playerData[player.ID].logged = true;
                    playerData[player.ID].kills = GetSQLColumnData(q, 3);
                    playerData[player.ID].deaths = GetSQLColumnData(q, 4);
                    playerData[player.ID].topspree = GetSQLColumnData(q, 5);
                    playerData[player.ID].headshots = GetSQLColumnData(q, 6);
                    playerData[player.ID].adminlevel = GetSQLColumnData(q, 7);
                    player.Cash = GetSQLColumnData(q, 8);
                    MessagePlayer(COLOR_GREEN + "You have successfully logged in to your account!", player);
                    FreeSQLQuery(q);
                }
                else 
                {
                    MessagePlayer(COLOR_RED + "Wrong password entered!", player);
                    FreeSQLQuery(q);
                    return false;
                }
            }
            else MessagePlayer(COLOR_RED +"This nickname is not registered!", player);
        }
    }
    function IsRegistered(player)
    {
        if(player)
        {
            local q = QuerySQL(accountDb, "SELECT * FROM accounts WHERE username='"+player.Name+"' COLLATE NOCASE");
            if(q)
            {
                FreeSQLQuery(q);
                return true;
            }
        }
        return false;
    }
    function LogOut(player)
    {
        if(player)
        {
            if(playerData[player.ID].logged)
            {
                SaveData(player.ID);
                playerData[player.ID].logged = false;
            }
        }
    }
    function SaveData(playerid)
    {
        local player = GetPlayer(playerid);
        if(player && playerData[player.ID].logged)
        {
            QuerySQL(accountDb, "UPDATE accounts SET kills='"+playerData[player.ID].kills+"', deaths='"+playerData[player.ID].deaths+"', topspree='"+playerData[player.ID].topspree+"', headshots='"+playerData[player.ID].headshots+"', adminlevel='"+playerData[player.ID].adminlevel+"', cash='"+player.Cash+"', ip='"+player.IP+"',uid='"+player.UniqueID+"',uid2='"+player.UniqueID2+"' WHERE username='"+player.Name+"' COLLATE NOCASE");
        }
    }
}