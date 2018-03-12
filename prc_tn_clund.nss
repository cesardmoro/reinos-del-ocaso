/**
 * True Necromancer: Create Lesser Undead
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
    object oCreature;
    effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_UNDEAD);
    int nClass = GetLevelByClass(CLASS_TYPE_TRUENECRO, OBJECT_SELF);

    if (nClass > 9)	        sSummon = "prc_sum_sklch";
    else if (nClass > 6)	sSummon = "prc_sum_zlord";
    else if (nClass > 3)	sSummon = "prc_sum_mohrg";

   oCreature = CreateObject(OBJECT_TYPE_CREATURE, sSummon, GetSpellTargetLocation());
   AddHenchman(OBJECT_SELF, oCreature);
   ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetSpellTargetLocation());
}