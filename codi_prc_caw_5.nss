#include "prc_feat_const"
int StartingConditional()
{
    object oPC = GetPCSpeaker();
    return GetHasFeat(FEAT_EPIC_SAMURAI,oPC);
}

