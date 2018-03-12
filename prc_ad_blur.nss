//::///////////////////////////////////////////////
//:: Blur
//:: prc_ad_blur.nss
//:://////////////////////////////////////////////
/*
    20% concealment to all attacks

    Duration: 1 turn/level

*/
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: August 20, 2004
//:://////////////////////////////////////////////

#include "spinc_common"



void main()
{


     //Declare major variables
    object oTarget = OBJECT_SELF;
    int nDuration = GetLevelByClass(CLASS_TYPE_ARCANE_DUELIST, OBJECT_SELF);
    int CasterLvl = nDuration;
    effect eVis = EffectVisualEffect(VFX_IMP_AC_BONUS);
    
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

    effect eShield =  EffectConcealment(20);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    effect eLink = EffectLinkEffects(eShield, eDur);
//    RemoveEffectsFromSpell(oTarget, GetSpellId());

    //Apply the armor bonuses and the VFX impact
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration),TRUE,-1,CasterLvl);
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Erasing the variable used to store the spell's spell school
}

