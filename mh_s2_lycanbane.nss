//::///////////////////////////////////////////////
//:: Lycanbane
//:: NW_S2_Lycanbane.nss
//:://////////////////////////////////////////////
/*
    Le maitre menesrel transmet sa protection contre
    les metamorphe pendant 1 minute.
*/
//:://////////////////////////////////////////////
//:: Created By: Age
//:: Created On: Jan 23, 2004
//:://////////////////////////////////////////////

#include "NW_I0_SPELLS"

void main()
{
    //Declare major variables
    object oTarget = GetSpellTargetObject();
    effect eVisual = EffectVisualEffect(VFX_IMP_AC_BONUS);
    //This feat is meant for allies.
    if(oTarget == OBJECT_SELF)
    {
        FloatingTextStringOnCreature("You must target an ally.  You already permanently have this effect.",OBJECT_SELF,TRUE);
        IncrementRemainingFeatUses(OBJECT_SELF,FEAT_LYCANBANE);
        return;
    }
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVisual, oTarget);
    effect eACBonus = VersusRacialTypeEffect(EffectACIncrease(5), RACIAL_TYPE_SHAPECHANGER);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eACBonus, oTarget, 60.0);
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_LYCANBANE, FALSE));
}
