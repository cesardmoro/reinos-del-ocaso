int StartingConditional()
{
    int iResult;

    iResult = GetIsObjectValid(GetLocalObject(GetModule(), "2002"));
    if(GetCampaignInt("PVP", "Assasin", GetLocalObject(GetModule(), "2002")) == 1)
    {
    return iResult;
    }
    return FALSE;
}
