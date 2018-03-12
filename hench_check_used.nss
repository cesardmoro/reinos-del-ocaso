int StartingConditional()
{
    string sID = GetName(GetPCSpeaker()); if(GetStringLength(sID) > 0) { sID = GetStringLeft(sID, 25); }
    int iPassed = 0;
    if(GetLevelByClass(CLASS_TYPE_PALADIN, GetPCSpeaker()) >= 1)
        iPassed = 1;
    if(GetLocalInt(OBJECT_SELF, "Accion"+sID)!=0)
        iPassed = 1;
    if(iPassed == 1)
        return FALSE;

    return TRUE;
}
