//script for deciding if the entry in the forms list should be shown

int StartingConditional()
{
    object oPC = GetPCSpeaker();
    object oMimicForms = GetItemPossessedBy( oPC, "soul_prism" );
    int num_creatures = GetLocalInt( oMimicForms, "num_creatures" );
    int nStartIndex = GetLocalInt(oPC,"ShifterListIndex");
    if (nStartIndex+5>num_creatures) //if the entry is past the total number of known forms dont show
    {
        return FALSE;
    }
    else
    {
        return TRUE;
    }
}
