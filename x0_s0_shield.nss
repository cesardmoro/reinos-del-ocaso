//::///////////////////////////////////////////////
//:: Shield
//:: x0_s0_shield.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Immune to magic Missile
    +4 general AC
    DIFFERENCES: should be +7 against one opponent
    but this cannot be done.
    Duration: 1 turn/level
*/
//:://////////////////////////////////////////////
//:: Created By: Brent Knowles
//:: Created On: July 15, 2002
//:://////////////////////////////////////////////
//:: Last Update By: Andrew Nobbs May 01, 2003

//:: altered by mr_bumpkin Dec 4, 2003 for prc stuff
#include "spinc_common"

#include "NW_I0_SPELLS"

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

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Declare major variables
    object oTarget = OBJECT_SELF;
    effect eVis = EffectVisualEffect(VFX_IMP_AC_BONUS);
    int nMetaMagic = GetMetaMagicFeat();

    effect eArmor = EffectACIncrease(4, AC_SHIELD_ENCHANTMENT_BONUS);
    effect eSpell = EffectSpellImmunity(SPELL_MAGIC_MISSILE);
    effect eSpell2 = EffectSpellImmunity(SPELL_MAJOR_MAGIC_MISSILE);
    effect eDur = EffectVisualEffect(VFX_DUR_GLOBE_MINOR);

    effect eLink = EffectLinkEffects(eArmor, eDur);
    eLink = EffectLinkEffects(eLink, eSpell);
    eLink = EffectLinkEffects(eLink, eSpell2);

    int CasterLvl = PRCGetCasterLevel(OBJECT_SELF);
    int nDuration = CasterLvl; 
    if (CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND)) //Duration is +100%
    {
         nDuration = nDuration * 2;
    }
    //Fire spell cast at event for target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 417, FALSE));

    RemoveEffectsFromSpell(OBJECT_SELF, GetSpellId());

    //Apply VFX impact and bonus effects
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration),TRUE,-1,CasterLvl);


DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Erasing the variable used to store the spell's spell school
}



