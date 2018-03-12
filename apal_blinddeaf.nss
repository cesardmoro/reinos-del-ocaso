//::///////////////////////////////////////////////
//:: Blindness and Deafness
//:: [NW_S0_BlindDead.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Causes the target creature to make a Fort
//:: save or be blinded and deafened.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 12, 2001
//:://////////////////////////////////////////////


//:: modified by mr_bumpkin Dec 4, 2003
#include "spinc_common"
#include "prc_inc_clsfunc"
#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_ENCHANTMENT);
/*
  Spellcast Hook Code
  Added 2003-06-23 by GeorgZ
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook
    if (!CanCastSpell(3)) return;

    //Declare major varibles
    object oTarget = GetSpellTargetObject();
    int nMetaMagic = GetMetaMagicFeat();
    int CasterLvl = GetLevelByClass(CLASS_TYPE_ANTI_PALADIN)/2;
    if (GetLocalInt(OBJECT_SELF, "Apal_DeathKnell") == TRUE)
    {
        CasterLvl = CasterLvl + 1;
    }
    
    int nDuration = CasterLvl;
    effect eBlind =  EffectBlindness();
    effect eDeaf = EffectDeaf();
    effect eVis = EffectVisualEffect(VFX_IMP_BLIND_DEAF_M);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    effect eLink = EffectLinkEffects(eBlind, eDeaf);
    eLink = EffectLinkEffects(eLink, eDur);
    int nPenetr = CasterLvl + SPGetPenetr();
    int nDC = GetSpellDCSLA(OBJECT_SELF,3);
            
    if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Fire cast spell at event
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_BLINDNESS_AND_DEAFNESS));
        //Do SR check
        if (!MyPRCResistSpell(OBJECT_SELF, oTarget,nPenetr))
        {
            // Make Fortitude save to negate
            if (!/*Fort Save*/ PRCMySavingThrow(SAVING_THROW_FORT, oTarget, (nDC+ GetChangesToSaveDC(oTarget,OBJECT_SELF))))
            {
                //Metamagic check for duration
                if (nMetaMagic == METAMAGIC_EXTEND)
                {
                    nDuration = nDuration * 2;
                }
                //Apply visual and effects
                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration),TRUE,-1,CasterLvl);
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            }
        }
    }

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name
}
