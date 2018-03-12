//::///////////////////////////////////////////////
//:: Dragon Breath Gas Cloud
//:: NW_S1_DragGas
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Calculates the proper damage and DC Save for the
    breath weapon based on the HD of the dragon.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 9, 2001
//:://////////////////////////////////////////////
#include "NW_I0_SPELLS"

void main()
{
    //Declare major variables
    int nDamage, nDC, nDamStrike;
    float fDelay;
    object oTarget;
    effect eVis, eBreath;

    nDamage = 7;
    nDC = 28;

    PlayDragonBattleCry();
    //Get first target in spell area
    oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 14.0, GetSpellTargetLocation(), TRUE);
    while(GetIsObjectValid(oTarget))
    {
        if(oTarget != OBJECT_SELF && !GetIsReactionTypeFriendly(oTarget))
        {
            //Reset the damage to full
            nDamStrike = nDamage;
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_DRAGON_BREATH_GAS));
            //Determine effect delay
            fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20;
            //Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
            if(PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_ACID))
            {
                nDamStrike = 0;
            }
            else if(GetHasFeat(FEAT_IMPROVED_EVASION, oTarget))
            {
                nDamStrike = nDamStrike/2;
            }

            if (nDamStrike > 0)
            {
                //Set Damage and VFX
                //eBreath = EffectAbilityDecrease(ABILITY_STRENGTH,nDamStrike);
                eVis = EffectVisualEffect(VFX_IMP_POISON_L);

                //Apply the VFX impact and effects
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                //DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eBreath, oTarget));
                DelayCommand(fDelay, ApplyAbilityDamage(oTarget, ABILITY_STRENGTH, nDamStrike, DURATION_TYPE_PERMANENT, TRUE));
             }
        }
        //Get next target in spell area
        oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 14.0, GetSpellTargetLocation(), TRUE);
    }
}
