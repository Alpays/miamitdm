bans <-
{
    function Ban(name, admin, reason)
    {
        local player = GetPlayer(name);
        QuerySQL(banDb, format("INSERT INTO bans(banned, banned_ip, isPerma, admin, reason,uid,uid2) VALUES('%s','%s','%d','%s','%s','%s','%s')", name.tolower(), GetPlayer(name).IP, 1, admin, reason,GetPlayer(name).UniqueID, GetPlayer(name).UniqueID2));
        MessagePlayer(COLOR_RED + "Banned!", player);
        Message(COLOR_BLUE + "Admin " + COLOR_WHITE + admin + COLOR_BLUE + " banned " + COLOR_WHITE + player.Name + COLOR_BLUE + " reason: " + COLOR_WHITE + reason);
        KickPlayer(GetPlayer(name));
    }
    function TempBan(name, admin, duration, reason)
    {
        local player = GetPlayer(name)
        duration = ConvertBanTime(duration);
        if(duration)
        {
            QuerySQL(banDb, format("INSERT INTO bans(banned, banned_ip, ban_expire, isPerma, admin, reason, uid, uid2) VALUES('%s','%s','%d','%d','%s','%s','%s','%s')", name.tolower(), player.IP, time() + duration, 0, admin, reason, player.UniqueID, player.UniqueID2));
            MessagePlayer(COLOR_RED + "Banned!", player);
            Message(COLOR_BLUE + "Admin " + COLOR_WHITE + admin + COLOR_BLUE +" banned " + COLOR_WHITE + player.Name + COLOR_BLUE + " reason: " + COLOR_WHITE + reason + COLOR_BLUE + " time left: " + COLOR_WHITE + ConvertSecondsToDate(duration));
            KickPlayer(GetPlayer(name));
            return true;
        }
        return false;
    }
    function IsBanned(name)
    {
        local q = QuerySQL(banDb, "SELECT * FROM bans WHERE banned='"+name.tolower()+"'");
        if(q)
        {
            FreeSQLQuery(q);
            return true;
        }
        return false;
    }
    function IsBannedIP(ip)
    {
        local q = QuerySQL(banDb, "SELECT * FROM bans WHERE banned_ip='"+ip+"'");
        if(q)
        {
            FreeSQLQuery(q);
            return true;
        }
        return false;
    }
    function Unban(name)
    {
        local q = QuerySQL(banDb, "SELECT * FROM bans WHERE banned='"+name.tolower()+"'");
        if(q)
        {
            QuerySQL(banDb, "DELETE FROM bans WHERE banned='"+name.tolower()+"'");
            FreeSQLQuery(q);
            return true;
        }
        else return false;
    }
    function UnbanIP(ip)
    {
        local q = QuerySQL(banDb, "SELECT * FROM bans WHERE banned_ip='"+ip+"'");
        if(q)
        {
            local banid = GetSQLColumnData(q, 0);
            FreeSQLQuery(q);
            QuerySQL(banDb, "DELETE * FROM bans WHERE id='"+banid+"'");
            return true;
        }
        else return false;        
    }
    function ConvertBanTime(duration)
    {
        if(duration.find("m"))
        {
            duration = duration.slice(0, duration.find("m"));
            if(duration && IsNum(duration))
            {
                duration = duration.tointeger();
                duration = duration * 60
                return duration;
            }
        }
        else if(duration.find("h"))
        {
            duration = duration.slice(0, duration.find("h"));
            if(duration && IsNum(duration))
            {
                duration = duration.tointeger();
                duration = duration * 60
                duration = duration * 60
                return duration;
            }
        }    
        else if(duration.find("d"))
        {
            duration = duration.slice(0, duration.find("d"));
            if(duration && IsNum(duration))
            {
                duration = duration.tointeger();
                duration = duration * 60;
                duration = duration * 60;
                duration = duration * 24;
                return duration;
            }
        }
        else if(duration.find("w"))
        {
            duration = duration.slice(0, duration.find("w"));
            if(duration && IsNum(duration))
            {
                duration = duration.tointeger();
                duration = duration * 60;
                duration = duration * 60;
                duration = duration * 24;
                duration = duration * 7;
                return duration;
            }
        }
    }
    function ConvertSecondsToDate(seconds)
    {
        local weekcount = 0;
        local daycount = 0;
        local hourcount = 0;
        local minutecount = 0;
        weekcount = seconds / 604800;
        seconds-= weekcount * 604800;

        daycount = seconds / 86400;
        seconds-= daycount * 86400;

        hourcount = seconds / 3600;
        seconds-= hourcount * 3600;

        minutecount = seconds / 60;
        seconds-= minutecount * 60;
        
        if(weekcount) 
        {
            if(daycount)
            {
                return weekcount.tostring() + " weeks " + daycount + " days.";
            }
            return weekcount.tostring() + " weeks ";
        } 
        else if(daycount)
        {
            if(hourcount)
            {
                return daycount.tostring() + " days " + hourcount + " hours.";
            }
            return daycount.tostring() + " days.";
        }
        else if(hourcount)
        {
            return hourcount.tostring() + " hours " + minutecount + " minutes.";
        }
        else if(minutecount) 
        { 
            return minutecount.tostring() + " minutes.";
        }
        else return seconds.tostring() + " seconds.";
    }    
}