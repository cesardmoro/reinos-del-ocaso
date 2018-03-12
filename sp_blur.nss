//::///////////////////////////////////////////////
//:: Blur
//:: sp_blur.nss
//:://////////////////////////////////////////////
/*
Caster Level(s): Bard 2, Wizard 2, Sorcerer 2
Innate Level: 2
School: Illusion
Component(s): Verbal
Range: Touch
Area of Effect / Target: Creature touched
Duration: 1 min/level
Save: harmless
Spell Resistance: harmless

The subject’s outline appears blurred, shifting and wavering.
This distortion grants the subject concealment (20% miss chance).

*/
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: August 20, 2004
//:://////////////////////////////////////////////

#include "spinc_common"



void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_ILLUSION);
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
    object oTarget = PRCGetSpellTargetObject();
    int nDuration = PRCGetCasterLevel(OBJECT_SELF);
    int CasterLvl = nDuration;
    effect eVis = EffectVisualEffect(VFX_IMP_AC_BONUS);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

    effect eShield =  EffectConcealment(20);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    effect eLink = EffectLinkEffects(eShield, eDur);
//    RemoveEffectsFromSpell(oTarget, GetSpellId());
    //Enter Metamagic conditions
    int nMetaMagic = PRCGetMetaMagicFeat();
    if (CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND))
    {
        nDuration = nDuration *2; //Duration is +100%
    }
    //Apply the armor bonuses and the VFX impact
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration),TRUE,-1,CasterLvl);
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Erasing the variable used to store the spell's spell school
}

