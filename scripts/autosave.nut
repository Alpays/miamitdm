function AutoSave()
{
    for(local i = 0; i < GetMaxPlayers(); ++i)
    {
        accounts.SaveData(GetPlayer(i));
    }
}

NewTimer("AutoSave", 60 * 1000, 0);