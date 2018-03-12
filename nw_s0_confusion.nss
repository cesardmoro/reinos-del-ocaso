//::///////////////////////////////////////////////
//:: [Confusion]
//:: [NW_S0_Confusion.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: All creatures within a 15 foot radius must
//:: save or be confused for a number of rounds
//:: equal to the casters level.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 30 , 2001
//:://////////////////////////////////////////////
//:: Update Pass By: Preston W, On: July 25, 2001


//:: modified by mr_bumpkin Dec 4, 2003
#include "spinc_common"

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_ENCHANTMENT);

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

    int nDuration = CasterLvl;
    int nMetaMagic = GetMetaMagicFeat();
    effect eImpact = EffectVisualEffect(VFX_FNF_LOS_NORMAL_20);
    effect eVis = EffectVisualEffect(VFX_IMP_CONFUSION_S);
    effect eConfuse = EffectConfused();
    effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    float fDelay;
    //Link duration VFX and confusion effects
    effect eLink = EffectLinkEffects(eMind, eConfuse);
    eLink = EffectLinkEffects(eLink, eDur);

    //Perform metamagic checks
    if (CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND))
    {
        nDuration = nDuration * 2;
    }

    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, GetSpellTargetLocation());

    int nPenetr = CasterLvl + SPGetPenetr();
    
 
    //Search through target area
    oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetSpellTargetLocation());
    while (GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
        {
           //Fire cast spell at event for the specified target
           SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_CONFUSION));
           fDelay = GetRandomDelay();
           //Make SR Check and faction check
           if (!MyPRCResistSpell(OBJECT_SELF, oTarget,nPenetr , fDelay))
           {
                int nDC = GetChangesToSaveDC(oTarget,OBJECT_SELF);
                //Make Will Save
                if (!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, (GetSpellSaveDC()+ nDC), SAVING_THROW_TYPE_MIND_SPELLS, OBJECT_SELF, fDelay))
                {
                   //Apply linked effect and VFX Impact
                   nDuration = GetScaledDuration(CasterLvl, oTarget);
                   DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration),TRUE,-1,CasterLvl));
                   DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                }
            }
        }
        //Get next target in the shape
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetSpellTargetLocation());
    }


DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name
}

