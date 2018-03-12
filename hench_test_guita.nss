int StartingConditional()
{
    if(GetLocalInt(OBJECT_SELF, "Precio") > GetGold(GetPCSpeaker()))
        return FALSE;

    return TRUE;
}
