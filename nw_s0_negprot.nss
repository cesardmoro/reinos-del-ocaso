//::///////////////////////////////////////////////
//:: Negative Energy Protection
//:: NW_S0_NegProt.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Grants immunity to negative damage, level drain
    and Ability Score Damage
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////

//:: modified by mr_bumpkin Dec 4, 2003 for PRC stuff

//::Added code to maximize for Faith Healing and Blast Infidel
//::Aaon Graywolf - Jan 7, 2004

#include "spinc_common"

#include "x2_inc_spellhook"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_ABJURATION);
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
    effect eVis = EffectVisualEffect(VFX_IMP_HOLY_AID);

    effect eNeg = EffectDamageImmunityIncrease(DAMAGE_TYPE_NEGATIVE, 100);
    effect eLevel = EffectImmunity(IMMUNITY_TYPE_NEGATIVE_LEVEL);
    effect eAbil = EffectImmunity(IMMUNITY_TYPE_ABILITY_DECREASE);

    int CasterLvl = PRCGetCasterLevel(OBJECT_SELF);
    int nDuration = CasterLvl;
    int nMetaMagic = GetMetaMagicFeat();

    //Enter Metamagic conditions
    if (CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND))
    {
        nDuration = nDuration *2; //Duration is +100%
    }
    if( !GetIsPC(OBJECT_SELF) || GetIsDMPossessed(OBJECT_SELF) || GetGold(OBJECT_SELF) >= 10 )
    {
        TakeGoldFromCreature(10, OBJECT_SELF, TRUE);
        //Link Effects
        effect eLink = EffectLinkEffects(eNeg, eLevel);
        eLink = EffectLinkEffects(eLink, eAbil);
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_NEGATIVE_ENERGY_PROTECTION, FALSE));

        //Apply the VFX impact and effects
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration),TRUE,-1,CasterLvl);
    }
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    // Getting rid of the integer used to hold the spells spell school
}

