void main()
{
    location lRevivir = GetLocation(GetWaypointByTag("inicio2"));
    location lRevivirDruida = GetLocation(GetWaypointByTag("DruidaSpawn"));
    object oPC = GetPCSpeaker();
    string sID = GetName(oPC);
    if(GetStringLength(sID))
        sID = GetStringLeft(sID, 25);

    if(GetLevelByClass(CLASS_TYPE_DRUID, oPC) > 0)
        SetCampaignLocation("respawn", "lugar"+sID, lRevivirDruida);
    else
        SetCampaignLocation("respawn", "lugar"+sID, lRevivir);
}
