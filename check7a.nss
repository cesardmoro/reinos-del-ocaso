int StartingConditional()
{
    int iResult;

    iResult = GetIsObjectValid(GetLocalObject(GetModule(), "2006"));
    if(GetCampaignInt("PVP", "Assasin", GetLocalObject(GetModule(), "2006")) == 1)
    {
    return iResult;
    }
    return FALSE;
}
