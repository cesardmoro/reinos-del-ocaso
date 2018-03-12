int StartingConditional()
{
    object oPC = GetPCSpeaker();
    return (GetLocalInt(oPC, "CODI_SAM_WEAPON_VALUE") >= 20);
}

