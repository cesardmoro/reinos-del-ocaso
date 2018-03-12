int StartingConditional()
{
    int iResult;
    object oPC = GetLastSpeaker();
    if(GetAlignmentLawChaos(oPC) == ALIGNMENT_LAWFUL  || GetAlignmentLawChaos(oPC) == ALIGNMENT_NEUTRAL)
    {
    return TRUE;
    }
    return FALSE;

}
