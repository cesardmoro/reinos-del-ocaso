int StartingConditional()
{
    int iResult;

    iResult = GetIsObjectValid(GetLocalObject(GetModule(), "2004"));
    if(GetCampaignInt("PVP", "Assasin", GetLocalObject(GetModule(), "2004")) == 1)
    {
    return iResult;
    }
    return FALSE;
}
