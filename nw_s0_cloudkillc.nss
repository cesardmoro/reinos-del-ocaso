//::///////////////////////////////////////////////
//:: Cloudkill: Heartbeat
//:: NW_S0_CloudKillC.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    All creatures with 3 or less HD die, those with
    4 to 6 HD must make a save Fortitude Save or die.
    Those with more than 6 HD take 1d10 Poison damage
    every round.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 17, 2001
//:://////////////////////////////////////////////


//:: modified by mr_bumpkin Dec 4, 2003
#include "spinc_common"

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"
void docloudkill(object oTarget, int nDam)
{
SetLocalInt(oTarget, "damage", nDam);
ExecuteScript("cloudk", oTarget);
}
void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_CONJURATION);

 ActionDoCommand(SetAllAoEInts(SPELL_CLOUDKILL,OBJECT_SELF, GetSpellSaveDC()));

    //Declare major variables
    int nMetaMagic = GetMetaMagicFeat();
    int nDam = d6(1);

    effect eDeath = EffectDeath();
    effect eVis =   EffectVisualEffect(VFX_IMP_DEATH);
    effect eNeg = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
    effect eSpeed = EffectMovementSpeedDecrease(50);
    effect eVis2 = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eLink = EffectLinkEffects(eSpeed, eVis2);

    object oTarget;
    float fDelay;

    //Enter Metamagic conditions
    if (CheckMetaMagic(nMetaMagic, METAMAGIC_MAXIMIZE))
    {
       nDam = 6;//Damage is at max
    }
    else if (CheckMetaMagic(nMetaMagic, METAMAGIC_EMPOWER))
    {
       nDam =  nDam + (nDam/2); //Damage/Healing is +50%
    }



   //--------------------------------------------------------------------------
    // GZ 2003-Oct-15
    // When the caster is no longer there, all functions calling
    // GetAreaOfEffectCreator will fail. Its better to remove the barrier then
    //--------------------------------------------------------------------------
    if (!GetIsObjectValid(GetAreaOfEffectCreator()))
    {
        DestroyObject(OBJECT_SELF);
        return;
    }

    object aoeCreator = GetAreaOfEffectCreator();
    int CasterLvl = PRCGetCasterLevel(aoeCreator);
    int nPenetr = SPGetPenetrAOE(aoeCreator,CasterLvl);


    //Set damage effect
  //  eDam = SupernaturalEffect(EffectAbilityDecrease(ABILITY_CONSTITUTION ,d4(1)));
    //Get the first object in the persistant AOE
    oTarget = GetFirstInPersistentObject();
    while(GetIsObjectValid(oTarget))
    {

            if(!GetIsImmune(oTarget, IMMUNITY_TYPE_POISON))
                {
           // nDam = nDam + GetLocalInt(oTarget, "Cloud");

            int nHD = GetHitDice(oTarget);
            fDelay = GetRandomDelay();
            if(spellsIsTarget(oTarget,SPELL_TARGET_STANDARDHOSTILE , aoeCreator) )
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_CLOUDKILL));
        //Make SR Check
        if(!MyPRCResistSpell(aoeCreator, oTarget,nPenetr, fDelay) && !GetIsImmune(oTarget, IMMUNITY_TYPE_POISON))
        {
            //Determine spell effect based on the targets HD
            if (nHD <= 3)
            {
                if(!GetIsImmune(oTarget, IMMUNITY_TYPE_DEATH))
                {
                    DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                    DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget));
                }
            }
            else if (nHD >= 4 && nHD <= 6)
            {
                //Make a save or die
                if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, (GetSpellSaveDC()+ GetChangesToSaveDC(oTarget,aoeCreator)), SAVING_THROW_TYPE_DEATH, OBJECT_SELF, fDelay))
                {
                    DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget));
                    DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                }
                else
                {
                    DelayCommand(fDelay, docloudkill(oTarget, nDam));
                    DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eNeg, oTarget));

                }
            }
            else
            {
                if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, (GetSpellSaveDC()+ GetChangesToSaveDC(oTarget,aoeCreator)), SAVING_THROW_TYPE_NONE, OBJECT_SELF, fDelay))
                    {
                DelayCommand(fDelay, docloudkill(oTarget, nDam));
                DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eNeg, oTarget));
               // SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eSpeed, oTarget,0.0f,FALSE);
                }

            }
        }}
        //Get the next target in the AOE
        oTarget = GetNextInPersistentObject();
    } }


DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name
}
