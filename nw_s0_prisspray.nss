//::///////////////////////////////////////////////
//:: Prismatic Spray
//:: [NW_S0_PrisSpray.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Sends out a prismatic cone that has a random
//:: effect for each target struck.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Dec 19, 2000
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 11, 2001
//:: Last Updated By: Aidan Scanlan On: April 11, 2001
//:: Last Updated By: Preston Watamaniuk, On: June 11, 2001



int ApplyPrismaticEffect(int nEffect, object oTarget,int nDC,int CasterLvl);

//:: modified by mr_bumpkin Dec 4, 2003 for PRC stuff
#include "spinc_common"
//:: left its elemental damage alone, since it's already determined randomly.

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_EVOCATION);
/*
  Spellcast Hook Code
  Added 2003-06-20 by Georg
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Declare major variables
    object oTarget;
    int CasterLvl = PRCGetCasterLevel(OBJECT_SELF);

   

    int nMetaMagic = GetMetaMagicFeat();
    int nRandom;
    int nHD;
    int nVisual;
    effect eVisual;
    int bTwoEffects;
    int nPenetr = CasterLvl + SPGetPenetr();
    
    //Set the delay to apply to effects based on the distance to the target
    float fDelay = 0.5 + GetDistanceBetween(OBJECT_SELF, oTarget)/20;
    //Get first target in the spell area
    oTarget = MyFirstObjectInShape(SHAPE_SPELLCONE, 11.0, GetSpellTargetLocation());
    while (GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_PRISMATIC_SPRAY));
            //Make an SR check
            if (!MyPRCResistSpell(OBJECT_SELF, oTarget,nPenetr, fDelay) && (oTarget != OBJECT_SELF))
            {
                 int nDC = GetChangesToSaveDC(oTarget,OBJECT_SELF);
                //Blind the target if they are less than 9 HD
                nHD = GetHitDice(oTarget);
                if (nHD <= 8)
                {
                    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBlindness(), oTarget, RoundsToSeconds(CasterLvl),TRUE,-1,CasterLvl);
                }
                //Determine if 1 or 2 effects are going to be applied
                nRandom = d8();
                if(nRandom == 8)
                {
                    //Get the visual effect
                    nVisual = ApplyPrismaticEffect(Random(7) + 1, oTarget,nDC,CasterLvl);
                    nVisual = ApplyPrismaticEffect(Random(7) + 1, oTarget,nDC,CasterLvl);
                }
                else
                {
                    //Get the visual effect
                    nVisual = ApplyPrismaticEffect(nRandom, oTarget,nDC,CasterLvl);
                }
                //Set the visual effect
                if(nVisual != 0)
                {
                    eVisual = EffectVisualEffect(nVisual);
                    //Apply the visual effect
                    DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVisual, oTarget));
                }
            }
        }
        //Get next target in the spell area
        oTarget = MyNextObjectInShape(SHAPE_SPELLCONE, 11.0, GetSpellTargetLocation());
    }



DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the integer used to hold the spells spell school

}

///////////////////////////////////////////////////////////////////////////////
//  ApplyPrismaticEffect
///////////////////////////////////////////////////////////////////////////////
/*  Given a reference integer and a target, this function will apply the effect
    of corresponding prismatic cone to the target.  To have any effect the
    reference integer (nEffect) must be from 1 to 7.*/
///////////////////////////////////////////////////////////////////////////////
//  Created By: Aidan Scanlan On: April 11, 2001
///////////////////////////////////////////////////////////////////////////////

int ApplyPrismaticEffect(int nEffect, object oTarget,int nDC,int CasterLvl)
{
    int nDamage;
    effect ePrism;
    effect eVis;
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eLink;
    int nVis;
    float fDelay = 0.5 + GetDistanceBetween(OBJECT_SELF, oTarget)/20;
    //Based on the random number passed in, apply the appropriate effect and set the visual to
    //the correct constant
    switch(nEffect)
    {
        case 1://fire
            nDamage = 20;
            nVis = VFX_IMP_FLAME_S;
            nDamage = PRCGetReflexAdjustedDamage(nDamage, oTarget, (GetSpellSaveDC()+ nDC),SAVING_THROW_TYPE_FIRE);
            ePrism = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
            DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, ePrism, oTarget));
        break;
        case 2: //Acid
            nDamage = 40;
            nVis = VFX_IMP_ACID_L;
            nDamage = PRCGetReflexAdjustedDamage(nDamage, oTarget, (GetSpellSaveDC()+ nDC),SAVING_THROW_TYPE_ACID);
            ePrism = EffectDamage(nDamage, DAMAGE_TYPE_ACID);
            DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, ePrism, oTarget));
        break;
        case 3: //Electricity
            nDamage = 80;
            nVis = VFX_IMP_LIGHTNING_S;
            nDamage = PRCGetReflexAdjustedDamage(nDamage, oTarget, (GetSpellSaveDC()+ nDC),SAVING_THROW_TYPE_ELECTRICITY);
            ePrism = EffectDamage(nDamage, DAMAGE_TYPE_ELECTRICAL);
            DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, ePrism, oTarget));
        break;
        case 4: //Poison
            {
                effect ePoison = EffectPoison(POISON_BEBILITH_VENOM);
                DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, ePoison, oTarget));
            }
        break;
        case 5: //Paralyze
            {
                effect eDur2 = EffectVisualEffect(VFX_DUR_PARALYZED);
                if (PRCMySavingThrow(SAVING_THROW_FORT, oTarget, (GetSpellSaveDC()+ nDC)) == 0)
                {
                    ePrism = EffectParalyze();
                    eLink = EffectLinkEffects(eDur, ePrism);
                    eLink = EffectLinkEffects(eLink, eDur2);
                    DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(10),TRUE,-1,CasterLvl));
                }
            }
        break;
        case 6: //Confusion
            {
                effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED);
                ePrism = EffectConfused();
                eLink = EffectLinkEffects(eMind, ePrism);
                eLink = EffectLinkEffects(eLink, eDur);

                if (!/*Will Save*/ PRCMySavingThrow(SAVING_THROW_WILL, oTarget, (GetSpellSaveDC()+ nDC), SAVING_THROW_TYPE_MIND_SPELLS, OBJECT_SELF, fDelay))
                {
                    nVis = VFX_IMP_CONFUSION_S;
                    DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(10),TRUE,-1,CasterLvl));
                }
            }
        break;
        case 7: //Death
            {
                if (!/*Will Save*/ PRCMySavingThrow(SAVING_THROW_WILL, oTarget, (GetSpellSaveDC()+ nDC), SAVING_THROW_TYPE_DEATH, OBJECT_SELF, fDelay))
                {
                    DeathlessFrenzyCheck(oTarget);
                    
                    //nVis = VFX_IMP_DEATH;
                    ePrism = EffectDeath();
                    DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, ePrism, oTarget));
                }
            }
        break;
    }
    return nVis;
}

