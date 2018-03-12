int StartingConditional()
{
    int iResult;

    iResult = GetIsObjectValid(GetLocalObject(GetModule(), "2000"));
    if(GetCampaignInt("PVP", "Assasin", GetLocalObject(GetModule(), "2000")) == 1)
    {
    return iResult;
    }
    return FALSE;
}
