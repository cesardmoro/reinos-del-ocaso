int StartingConditional()
{
    int iResult;

    iResult = GetIsObjectValid(GetLocalObject(GetModule(), "2007"));
    if(GetCampaignInt("PVP", "Assasin", GetLocalObject(GetModule(), "2007")) == 1)
    {
    return iResult;
    }
    return FALSE;
}
