int StartingConditional()
{
    int iResult;

    iResult = GetIsObjectValid(GetLocalObject(GetModule(), "2008"));
    if(GetCampaignInt("PVP", "Assasin", GetLocalObject(GetModule(), "2008")) == 1)
    {
    return iResult;
    }
    return FALSE;
}
