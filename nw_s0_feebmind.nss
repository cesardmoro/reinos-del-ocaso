//::///////////////////////////////////////////////
//:: Feeblemind
//:: [NW_S0_FeebMind.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Target must make a Will save or take ability
//:: damage to Intelligence equaling 1d4 per 4 levels.
//:: Duration of 1 rounds per 2 levels.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Feb 2, 2001
//:://////////////////////////////////////////////

//:: modified by mr_bumpkin Dec 4, 2003 for PRC stuff
#include "spinc_common"

#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_DIVINATION);
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
    object oTarget = GetSpellTargetObject();
    int CasterLvl = PRCGetCasterLevel(OBJECT_SELF);

    int nDuration = CasterLvl/2;
    int nLoss = CasterLvl/4;
    //Check to make at least 1d4 damage is done
    if (nLoss < 1)
    {
        nLoss = 1;
    }
    nLoss = d4(nLoss);
    //Check to make sure the duration is 1 or greater
    if (nDuration < 1)
    {
        nDuration == 1;
    }
    int nMetaMagic = GetMetaMagicFeat();
    effect eFeeb;
    effect eVis = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
    effect eRay = EffectBeam(VFX_BEAM_MIND, OBJECT_SELF, BODY_NODE_HAND);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    int nPenetr = CasterLvl + SPGetPenetr();
    
    if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_FEEBLEMIND));
        //Make SR check
        if (!MyPRCResistSpell(OBJECT_SELF, oTarget,nPenetr))
        {
            //Make an will save

            int nWillResult =  WillSave(oTarget, (GetSpellSaveDC()+ GetChangesToSaveDC(oTarget,OBJECT_SELF)), SAVING_THROW_TYPE_MIND_SPELLS);
            if (nWillResult == 0)
            {
                 //Enter Metamagic conditions
                  if (CheckMetaMagic(nMetaMagic, METAMAGIC_MAXIMIZE))
                  {
                     nLoss = nLoss * 4;
                  }
                  if (CheckMetaMagic(nMetaMagic, METAMAGIC_EMPOWER))
                  {
                     nLoss = nLoss + (nLoss/2);
                  }
                  if (CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND))
                  {
                     nDuration = nDuration * 2;
                  }
                  //Set the ability damage
                  eFeeb = EffectAbilityDecrease(ABILITY_INTELLIGENCE, nLoss);
                  effect eLink = EffectLinkEffects(eFeeb, eDur);

                  //Apply the VFX impact and ability damage effect.
                  SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration),TRUE,-1,CasterLvl);
                  SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.0,FALSE);
                  SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            }
            else
            // * target was immune
            if (nWillResult == 2)
            {
                SpeakStringByStrRef(40105, TALKVOLUME_WHISPER);
            }
        }
    }

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name
}
