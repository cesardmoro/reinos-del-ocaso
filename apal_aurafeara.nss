//::///////////////////////////////////////////////
//:: Aura of Fear On Enter
//:: NW_S1_AuraFearA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Upon entering the aura of the creature the player
    must make a will save or be struck with fear because
    of the creatures presence.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 25, 2001
//:://////////////////////////////////////////////


// shaken   -2 attack,weapon dmg,save.
// panicked -2 save + flee away ,50 % drop object holding
#include "prc_alterations"

void main()
{
    //Declare major variables
    object oTarget = GetEnteringObject();


    effect eVis = EffectVisualEffect(VFX_IMP_FEAR_S);
    effect eDur3 = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);

    effect eSave = EffectSavingThrowDecrease(SAVING_THROW_ALL,4,SAVING_THROW_TYPE_FEAR);
    effect eLink = EffectLinkEffects(eSave, eDur3);

    
    if(GetIsEnemy(oTarget, GetAreaOfEffectCreator()))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(), SPELLABILITY_AURA_FEAR));
  
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(eSave), oTarget);
        
    }
}
