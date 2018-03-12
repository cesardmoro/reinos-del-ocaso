//::///////////////////////////////////////////////
//:: Fireball
//:: NW_S0_Fireball
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
// A fireball is a burst of flame that detonates with
// a low roar and inflicts 1d6 points of damage per
// caster level (maximum of 10d6) to all creatures
// within the area. Unattended objects also take
// damage. The explosion creates almost no pressure.
*/
//:://////////////////////////////////////////////
//:: Created By: Noel Borstad
//:: Created On: Oct 18 , 2000
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 6, 2001
//:: Last Updated By: AidanScanlan, On: April 11, 2001
//:: Last Updated By: Preston Watamaniuk, On: May 25, 2001

//:: modified by mr_bumpkin Dec 4, 2003 for PRC stuff
#include "prc_alterations"
#include "prc_class_const"

void main()
{
    //Declare major variables
    object oCaster = OBJECT_SELF;
    int nClassLevel = GetLevelByClass(CLASS_TYPE_SOUL_EATER, oCaster);
    int nDC = 10 + nClassLevel + GetAbilityModifier(ABILITY_CHARISMA, oCaster);
    effect eVis = EffectVisualEffect(VFX_IMP_PULSE_NEGATIVE);
    object oTarget = PRCGetSpellTargetObject();

    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
    int nDamage = d6(nClassLevel);
    nDamage = PRCGetReflexAdjustedDamage(nDamage, oTarget, nDC, SAVING_THROW_TYPE_NONE);
    effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL);
    if (nDamage > 0)
    {
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
    }

}

