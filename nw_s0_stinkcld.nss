//::///////////////////////////////////////////////
//:: Stinking Cloud
//:: NW_S0_StinkCld.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Those within the area of effect must make a
    fortitude save or be dazed.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 17, 2001
//:://////////////////////////////////////////////

//:: modified by mr_bumpkin  Dec 4, 2003
#include "prc_alterations"

#include "x2_inc_spellhook"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_CONJURATION);
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
    effect eAOE = EffectAreaOfEffect(AOE_PER_FOGSTINK);
    location lTarget = GetSpellTargetLocation();
    int nDuration = PRCGetCasterLevel(OBJECT_SELF);
    effect eImpact = EffectVisualEffect(259);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lTarget);
    if (nDuration < 1)
    {
        nDuration = 1;
    }
    int nMetaMagic = GetMetaMagicFeat();
    //Make metamagic check for extend
    if (CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND))
    {
        nDuration = nDuration *2;   //Duration is +100%
    }
    //Create the AOE object at the selected location
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the integer used to hold the spells spell school
}

