//::///////////////////////////////////////////////
//:: Cat's Grace
//:: NW_S0_CatGrace
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
// The transmuted creature becomes more graceful,
// agile, and coordinated. The spell grants an
// enhancement  bonus to Dexterity of 1d4+1
// points, adding the usual benefits to AC,
// Reflex saves, Dexterity-based skills, etc.
*/
//:://////////////////////////////////////////////
//:: Created By: Noel Borstad
//:: Created On: Oct 18, 2000
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk
//:: Last Updated On: April 5th, 2001


//:: modified by mr_bumpkin Dec 4, 2003
//#include "spinc_common"
//#include "x2_inc_spellhook"
#include "spinc_common"
#include "spinc_massbuff"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_TRANSMUTATION);
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
    object oTarget = GetSpellTargetObject();
    effect eDex;
    effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    int CasterLvl = PRCGetCasterLevel(OBJECT_SELF);
    int nModify = d4() + 1;
    float fDuration = HoursToSeconds(CasterLvl);
    int nMetaMagic = GetMetaMagicFeat();
    //Signal spell cast at event to fire on the target.
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_CATS_GRACE, FALSE));
    //Enter Metamagic conditions
    if (CheckMetaMagic(nMetaMagic, METAMAGIC_MAXIMIZE))
    {
        nModify = 5;//Damage is at max
    }
    if (CheckMetaMagic(nMetaMagic, METAMAGIC_EMPOWER))
    {
        nModify = FloatToInt( IntToFloat(nModify) * 1.5 ); //Damage/Healing is +50%
    }
    if (CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND))
    {
        fDuration = fDuration * 2.0;    //Duration is +100%
    }
    //Create the Ability Bonus effect with the correct modifier
    eDex = EffectAbilityIncrease(ABILITY_DEXTERITY,nModify);
    effect eLink = EffectLinkEffects(eDex, eDur);

	// bleedingedge - Strip old spell off to deal with mass buffs.
	StripBuff(oTarget, SPELL_CATS_GRACE, SPELL_MASS_CATS_GRACE);
	
    //Apply visual and bonus effects
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration,TRUE,-1,CasterLvl);
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
}
