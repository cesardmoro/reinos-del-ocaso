int StartingConditional()
{
    int iResult;

    iResult = GetIsObjectValid(GetLocalObject(GetModule(), "2005"));
    if(GetCampaignInt("PVP", "Assasin", GetLocalObject(GetModule(), "2005")) == 1)
    {
    return iResult;
    }
    return FALSE;
}
