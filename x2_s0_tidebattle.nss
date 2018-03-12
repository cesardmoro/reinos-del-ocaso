//::///////////////////////////////////////////////
//:: Tide of Battle
//:: x2_s0_TideBattle
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Uses spell effect to cause d100 damage to
    all enemies and friends around pc, including pc.
    (Area effect always centered on PC)
    Minimum 30 points of damage will be done to each target
*/
//:://////////////////////////////////////////////
//:: Created By: Keith Warner
//:: Created On: Jan 2/03
//:://////////////////////////////////////////////
//:: Updated by: Andrew Nobbs
//:: Updated on: March 28, 2003

//:: altered by mr_bumpkin Dec 4, 2003 for prc stuff
#include "spinc_common"

#include "nw_i0_spells"
#include "x0_i0_spells"

#include "x2_inc_spellhook"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_EVOCATION);
/*
  Spellcast Hook Code
  Added 2003-07-07 by Georg Zoeller
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
    object oTarget;
    effect eVis = EffectVisualEffect(VFX_IMP_DEATH_WARD);
    effect eVis2 = EffectVisualEffect(VFX_FNF_METEOR_SWARM);
    effect eDamage;
    effect eLink;
    int nDamage;

    //Apply Spell Effects
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis2, GetLocation(OBJECT_SELF));

    //ApplyDamage and Effects to all targets in area
    oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF), FALSE, OBJECT_TYPE_CREATURE);
    float fDelay;
    while(GetIsObjectValid(oTarget))
    {
        fDelay = GetRandomDelay();
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
        nDamage = d100();
        if (nDamage < 30)
        {
            nDamage = 30;
        }
        //Set damage type and amount
        eDamage = EffectDamage(nDamage, DAMAGE_TYPE_DIVINE);
        //Link visual and damage effects
        eLink = EffectLinkEffects(eVis, eDamage);
        //Apply effects to oTarget
        DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget));

        //Get next target in shape
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF), FALSE, OBJECT_TYPE_CREATURE);
    }


DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Erasing the variable used to store the spell's spell school
}
