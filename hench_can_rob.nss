int StartingConditional()
{
    string sID = GetName(GetPCSpeaker()); if(GetStringLength(sID) > 0) { sID = GetStringLeft(sID, 25); }
    if (GetLocalInt(OBJECT_SELF, "Rob"+sID)!=1)
        return FALSE;

    return TRUE;
}
