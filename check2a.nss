int StartingConditional()
{
    int iResult;

    iResult = GetIsObjectValid(GetLocalObject(GetModule(), "2001"));
    if(GetCampaignInt("PVP", "Assasin", GetLocalObject(GetModule(), "2001")) == 1)
    {
    return iResult;
    }
    return FALSE;
}
