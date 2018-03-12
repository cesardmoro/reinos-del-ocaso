//::///////////////////////////////////////////////
//:: Premonition
//:: NW_S0_Premo
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Gives the gives the creature touched 30/+5
    damage reduction.  This lasts for 1 hour per
    caster level or until 10 * Caster Level
    is dealt to the person.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: March 16 , 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 11, 2001

//:: modified by mr_bumpkin Dec 4, 2003 for PRC stuff
#include "spinc_common"

#include "nw_i0_spells"
#include "x2_inc_spellhook"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_DIVINATION);
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

    object oTarget = GetSpellTargetObject();

    //Declare major variables
    int CasterLvl = PRCGetCasterLevel(OBJECT_SELF);
    int nDuration = CasterLvl;
    int nLimit = nDuration * 10;
    int nMetaMagic = GetMetaMagicFeat();
    effect eStone = EffectDamageReduction(30, DAMAGE_POWER_PLUS_FIVE, nLimit);
    effect eVis = EffectVisualEffect(VFX_DUR_PROT_PREMONITION);
    //Link the visual and the damage reduction effect
    effect eLink = EffectLinkEffects(eStone, eVis);
    //Enter Metamagic conditions
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_PREMONITION, FALSE));
    if (CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND))
    {
        nDuration = nDuration *2; //Duration is +100%
    }

    RemoveEffectsFromSpell(oTarget, SPELL_PREMONITION);
    //Apply the linked effect
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(nDuration),TRUE,-1,CasterLvl);

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the integer used to hold the spells spell school
}
