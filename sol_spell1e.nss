//::///////////////////////////////////////////////
//:: Shield of Faith
//:: x0_s0_ShieldFait.nss
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
 +2 deflection AC bonus, +1 every 6 levels (max +5)
 Duration: 1 turn/level
*/
//:://////////////////////////////////////////////
//:: Created By: Brent Knowles
//:: Created On: September 6, 2002
//:://////////////////////////////////////////////
//:: VFX Pass By:

//:: altered by mr_bumpkin Dec 4, 2003 for prc stuff
#include "spinc_common"

#include "NW_I0_SPELLS"
#include "prc_inc_clsfunc"
#include "x2_inc_spellhook"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_ABJURATION);
/*
  Spellcast Hook Code
  Added 2003-06-20 by Georg
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!CanCastSpell(1)) return;

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Declare major variables
    object oTarget = GetSpellTargetObject();
    effect eVis = EffectVisualEffect(VFX_IMP_AC_BONUS);
    int nMetaMagic = GetMetaMagicFeat();
    int Sol = GetLevelByClass(CLASS_TYPE_SOLDIER_OF_LIGHT,OBJECT_SELF);
    int nCasterLvl = Sol;

    int nValue = 2 + (nCasterLvl)/6;
    if (nValue > 5)
     nValue = 5; // * Max of 5

    effect eAC = EffectACIncrease(nValue, AC_DEFLECTION_BONUS);

    effect eDur = EffectVisualEffect(VFX_DUR_PROTECTION_GOOD_MINOR);
    effect eLink = EffectLinkEffects(eAC, eDur);

    int nDuration = Sol; // * Duration 1 turn/level
     if (nMetaMagic == METAMAGIC_EXTEND)    //Duration is +100%
    {
         nDuration = nDuration * 2;
    }

    //Fire spell cast at event for target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 421, FALSE));
    //Apply VFX impact and bonus effects
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration),TRUE,-1,Sol);


DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Erasing the variable used to store the spell's spell school

}
