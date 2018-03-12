/**
 * Dirgesinger: Song of Awakening
 * Stratovarius
 */

#include "prc_inc_clsfunc"

void main()
{
    string sSummon;
    object oCreature;
    int nHD = GetHitDice(OBJECT_SELF);

    if (nHD >= 34)        sSummon = "prc_sum_dbl";
    else if (nHD >= 31)   sSummon = "prc_sum_dk";
    else if (nHD >= 28)   sSummon = "prc_sum_vamp2";
    else if (nHD >= 25)   sSummon = "prc_sum_bonet";
    else if (nHD >= 22)   sSummon = "prc_sum_wight";
    else if (nHD >= 19)   sSummon = "prc_sum_vamp1";
    else if (nHD >= 16)   sSummon = "prc_sum_grav";
    else if (nHD >= 13)   sSummon = "prc_tn_fthug";
    else if (nHD >= 10)   sSummon = "prc_sum_mohrg";    
  
    effect eSummon = EffectSummonCreature(sSummon, VFX_FNF_SUMMON_UNDEAD);
    //Apply summon effect and VFX impact.
    MultisummonPreSummon();
    CorpseCrafter(OBJECT_SELF, oCreature);
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, PRCGetSpellTargetLocation(), RoundsToSeconds(10));
}
