int StartingConditional()
{
    object oPC = GetPCSpeaker();

    return ( GetIsDM(oPC) || GetIsDMPossessed(oPC) );
}
