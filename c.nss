int StartingConditional()
{
    int iResult;
    object oPC = GetLastSpeaker();
    return GetAlignmentLawChaos(oPC) == ALIGNMENT_CHAOTIC  || GetAlignmentLawChaos(oPC) == ALIGNMENT_NEUTRAL;
}
