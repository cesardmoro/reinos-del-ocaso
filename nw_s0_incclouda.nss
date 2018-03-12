//::///////////////////////////////////////////////
//:: Incendiary Cloud
//:: NW_S0_IncCloud.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Person within the AoE take 4d6 fire damage
    per round.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 17, 2001
//:://////////////////////////////////////////////
//:: March 2003: Removed movement speed penalty

//:: modified by mr_bumpkin Dec 4, 2003 for PRC stuff
#include "spinc_common"

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_EVOCATION);
 ActionDoCommand(SetAllAoEInts(SPELL_INCENDIARY_CLOUD,OBJECT_SELF, GetSpellSaveDC()));

    //Declare major variables
    int nMetaMagic = GetMetaMagicFeat();
    int nDamage;
    effect eDam;
    object oTarget;
    //Declare and assign personal impact visual effect.
    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_S);
   // effect eSpeed = EffectMovementSpeedDecrease(50);
    effect eVis2 = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eLink = eVis2; //EffectLinkEffects(eSpeed, eVis2);
    float fDelay;
    //Capture the first target object in the shape.
    oTarget = GetEnteringObject();

    int nPenetr = SPGetPenetrAOE(GetAreaOfEffectCreator());


    //Declare the spell shape, size and the location.
    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_INCENDIARY_CLOUD));
        //Make SR check, and appropriate saving throw(s).
        if(!MyPRCResistSpell(GetAreaOfEffectCreator(), oTarget,nPenetr, fDelay))
        {
            fDelay = GetRandomDelay(0.5, 2.0);
            //Roll damage.
            nDamage = d6(4);
            //Enter Metamagic conditions
                if (CheckMetaMagic(nMetaMagic, METAMAGIC_MAXIMIZE))
                {
                   nDamage = 24;//Damage is at max
                }
                if (CheckMetaMagic(nMetaMagic, METAMAGIC_EMPOWER))
                {
                     nDamage = nDamage + (nDamage/2); //Damage/Healing is +50%
                }
            //Adjust damage for Reflex Save, Evasion and Improved Evasion
            nDamage = PRCGetReflexAdjustedDamage(nDamage, oTarget, GetSpellSaveDC(), SPGetElementalSavingThrowType(SAVING_THROW_TYPE_FIRE), GetAreaOfEffectCreator());
            // Apply effects to the currently selected target.
            eDam = EffectDamage(nDamage, SPGetElementalDamageType(DAMAGE_TYPE_FIRE, GetAreaOfEffectCreator()));
            if(nDamage > 0)
            {
                DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
            }
        }
       // SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eSpeed, oTarget);
    }

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name
}
