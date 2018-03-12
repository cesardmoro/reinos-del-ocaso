int StartingConditional()
{
    object oPC = GetPCSpeaker();

    if (GetIsDM(oPC))
        return TRUE;

    return FALSE;
}
