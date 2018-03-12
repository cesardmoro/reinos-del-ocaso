int StartingConditional()
{
    int iResult;
    object oPC = GetLastSpeaker();
    if(GetAlignmentGoodEvil(oPC) == ALIGNMENT_GOOD || GetAlignmentLawChaos(oPC) == ALIGNMENT_CHAOTIC || GetAlignmentGoodEvil(oPC) == ALIGNMENT_NEUTRAL || GetAlignmentLawChaos(oPC) == ALIGNMENT_NEUTRAL)
    {
    return TRUE;
    }
    return FALSE;

}
