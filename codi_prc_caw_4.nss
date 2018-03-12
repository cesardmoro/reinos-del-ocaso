int StartingConditional()
{
    object oPC = GetPCSpeaker();
    if (GetGold(oPC) + GetLocalInt(oPC,"CODI_SAM_SACRIFICE") < GetLocalInt(oPC, "CODI_SAM_WEAPON_COST"))
    {
        return TRUE;
    }
    else
    {
        return FALSE;
    }
}

