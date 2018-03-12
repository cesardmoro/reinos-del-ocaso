int StartingConditional()
{
    object oPC = GetPCSpeaker();
    object oWeap = GetItemPossessedBy(oPC,"codi_sam_mw");
    if(oWeap == OBJECT_INVALID)
    {
        return TRUE;
    }
    else
    {
        return FALSE;
    }
}

