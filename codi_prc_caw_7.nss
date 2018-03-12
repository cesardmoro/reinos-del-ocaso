int StartingConditional()
{
    object oPC = GetPCSpeaker();
    return (GetAlignmentLawChaos(oPC) != ALIGNMENT_LAWFUL);
}

