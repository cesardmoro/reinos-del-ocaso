/*
    When the player is not high enough in level.
*/
int StartingConditional()
{
    object oPC = GetPCSpeaker();
    int iLevel = GetHitDice(oPC);
    if (iLevel/2 <= GetLocalInt(oPC, "CODI_SAM_WEAPON_VALUE"))
    {
        return TRUE;
    }
    else
    {
        return FALSE;
    }
}

