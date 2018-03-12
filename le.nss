int StartingConditional()
{
    int iResult;
    object oPC = GetLastSpeaker();
    if(GetAlignmentGoodEvil(oPC) == ALIGNMENT_EVIL || GetAlignmentLawChaos(oPC) == ALIGNMENT_LAWFUL || GetAlignmentGoodEvil(oPC) == ALIGNMENT_NEUTRAL || GetAlignmentLawChaos(oPC) == ALIGNMENT_NEUTRAL)
    {
    return TRUE;
    }
    return FALSE;

}
