//::///////////////////////////////////////////////
//:: Enervation
//:: NW_S0_Enervat.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Target Loses 1d4 levels for 1 hour per caster
    level
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////

//:: modified by mr_bumpkin Dec 4, 2003 for PRC stuff

//::Added code to maximize for Faith Healing and Blast Infidel
//::Aaon Graywolf - Jan 7, 2003

#include "spinc_common"

#include "NW_I0_SPELLS"

#include "x2_inc_spellhook"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_NECROMANCY);
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


    //Declare major variables
    effect eVis = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
    object oTarget = GetSpellTargetObject();
    int nMetaMagic = GetMetaMagicFeat();
    int nDrain = d4();
    int CasterLvl = PRCGetCasterLevel(OBJECT_SELF);

    int nDuration = CasterLvl;
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    int nPenetr = CasterLvl + SPGetPenetr();

    //Undead Gain HP from Enervation
    int nHP = ((CasterLvl/2) * 5);
    if (nHP > 25)
    {
    nHP = 25;
    }

    effect eHP = EffectTemporaryHitpoints(nHP);
    
    //Enter Metamagic conditions
    int iBlastFaith = BlastInfidelOrFaithHeal(OBJECT_SELF, oTarget, DAMAGE_TYPE_NEGATIVE, TRUE);
    if (nMetaMagic == METAMAGIC_MAXIMIZE || iBlastFaith)
    {
        nDrain = 4;//Damage is at max
    }
    if (CheckMetaMagic(nMetaMagic, METAMAGIC_EMPOWER))
    {
        nDrain = nDrain + (nDrain/2); //Damage/Healing is +50%
    }
    if (CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND))
    {
        nDuration = nDuration *2; //Duration is +100%
    }

    effect eDrain = EffectNegativeLevel(nDrain);
    effect eLink = EffectLinkEffects(eDrain, eDur);

        
        if (MyPRCGetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
        {
            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHP, oTarget, HoursToSeconds(1),TRUE,-1,CasterLvl);
        }


    if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_ENERVATION));
        //Resist magic check
        if(!MyPRCResistSpell(OBJECT_SELF, oTarget,nPenetr))
        {
            if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, (GetSpellSaveDC()+ GetChangesToSaveDC(oTarget,OBJECT_SELF)), SAVING_THROW_TYPE_NEGATIVE))
            {
                //Apply the VFX impact and effects
                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(nDuration),TRUE,-1,CasterLvl);
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            }
        }
    }

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name
}

