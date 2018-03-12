/**
 * True Necromancer: Create Greater Undead
 * 2004/04/14
 * Stratovarius
 */

#include "prc_class_const"
#include "prc_feat_const"

void main()
{
    if (GetMaxHenchmen() < 4)
    {
    SetMaxHenchmen(4);
    }
    string sSummon;
    effect eSummonB = EffectVisualEffect( VFX_FNF_LOS_EVIL_30);
    object oCreature;
    effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_UNDEAD);
    int nClass = GetLevelByClass(CLASS_TYPE_TRUENECRO, OBJECT_SELF);

    if (nClass > 27)	        sSummon = "prc_sum_dbl";
    else if (nClass > 24)	sSummon = "prc_sum_dk";
    else if (nClass > 21)	sSummon = "prc_sum_vamp2";
    else if (nClass > 18)	sSummon = "prc_sum_bonet";
    else if (nClass > 15)	sSummon = "prc_sum_wight";
    else if (nClass > 12)	sSummon = "prc_sum_vamp1";
    else if (nClass > 9)	sSummon = "prc_sum_grav";
    else if (nClass > 6)	sSummon = "prc_tn_fthug";
  	


   oCreature = CreateObject(OBJECT_TYPE_CREATURE, sSummon, GetSpellTargetLocation());
   AddHenchman(OBJECT_SELF, oCreature);
   ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetSpellTargetLocation());
}
