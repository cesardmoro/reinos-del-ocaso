/////////////////////////////////////////////////
// Bull's Strength
//-----------------------------------------------
// Created By: Brenon Holmes
// Created On: 10/12/2000
// Description: This script changes someone's strength
// Updated 2003-07-17 to fix stacking issue with blackguard
/////////////////////////////////////////////////


//:: modified by mr_bumpkin Dec 4, 2003
//#include "spinc_common"

//#include "x2_inc_spellhook"
//#include "nw_i0_spells"
#include "spinc_common"
#include "spinc_massbuff"
#include "prc_inc_clsfunc"

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

    if (!CanCastSpell(2)) return;
    
    //Declare major variables
    object oTarget = GetSpellTargetObject();
    effect eStr;
    effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    int CasterLvl = GetLevelByClass(CLASS_TYPE_ANTI_PALADIN)/2;
    if (GetLocalInt(OBJECT_SELF, "Apal_DeathKnell") == TRUE)
    {
        CasterLvl = CasterLvl + 1;
    }    
    int nModify = d4() + 1;
    float fDuration = HoursToSeconds(CasterLvl);
    int nMetaMagic = GetMetaMagicFeat();
    //Signal the spell cast at event
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_BULLS_STRENGTH, FALSE));
    //Enter Metamagic conditions
    if (nMetaMagic == METAMAGIC_MAXIMIZE)
    {
    nModify = 5;//Damage is at max
    }
    if (nMetaMagic == METAMAGIC_EMPOWER)
    {
    nModify = nModify + (nModify/2);
    }
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        fDuration = fDuration * 2.0;    //Duration is +100%
    }

    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    // This code was there to prevent stacking issues, but programming says thats handled in code...
/*    if (GetHasSpellEffect(SPELL_GREATER_BULLS_STRENGTH))
    {
        return;
    }

    //Apply effects and VFX to target
    RemoveSpellEffects(SPELL_BULLS_STRENGTH, OBJECT_SELF, oTarget);
    RemoveSpellEffects(SPELLABILITY_BG_BULLS_STRENGTH, OBJECT_SELF, oTarget);
*/
	// bleedingedge - Strip old spell off to deal with mass buffs.
	StripBuff(oTarget, SPELL_BULLS_STRENGTH, SPELL_MASS_BULLS_STRENGTH);
	StripBuff(oTarget, SPELL_ANTIPAL_BULLS_STRENGTH, SPELL_MASS_BULLS_STRENGTH);
	
    eStr = EffectAbilityIncrease(ABILITY_STRENGTH,nModify);
    effect eLink = EffectLinkEffects(eStr, eDur);
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration,TRUE,-1,CasterLvl);


DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name
}
