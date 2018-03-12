int StartingConditional()
{
    object oPC = GetPCSpeaker();;
    object oItem = GetItemPossessedBy(oPC,"codi_sam_mw");
    if(oItem == OBJECT_INVALID)
    {
        return FALSE;
    }
    else
    {
        return TRUE;
    }
}

