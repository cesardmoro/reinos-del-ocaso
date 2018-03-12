int StartingConditional()
{
    int iResult;

    iResult = GetIsObjectValid(GetLocalObject(GetModule(), "2003"));
    if(GetCampaignInt("PVP", "Assasin", GetLocalObject(GetModule(), "2003")) == 1)
    {
    return iResult;
    }
    return FALSE;
}
