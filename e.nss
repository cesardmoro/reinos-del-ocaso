int StartingConditional()
{
    int iResult;
    object oPC = GetLastSpeaker();
    if(GetAlignmentGoodEvil(oPC) == ALIGNMENT_EVIL  || GetAlignmentGoodEvil(oPC) == ALIGNMENT_NEUTRAL)
    {
    return TRUE;
    }
    return FALSE;

}
