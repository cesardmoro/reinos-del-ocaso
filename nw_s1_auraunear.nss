//::///////////////////////////////////////////////
//:: Aura Unearthly Visage
//:: NW_S1_AuraUnEar.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Upon entering the aura of the creature the player
    must make a will save or be killed because of the
    sheer ugliness or beauty of the creature.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 25, 2001
//:://////////////////////////////////////////////

// Modified 2004/01/30 (Brian Greinke)
// Added disable/reenable support
#include "nw_i0_spells"

void main()
{
    //first, look to see if effect is already activated
    if ( GetHasSpellEffect(SPELLABILITY_AURA_UNEARTHLY_VISAGE, OBJECT_SELF) )
    {
        RemoveSpellEffects( SPELLABILITY_AURA_UNEARTHLY_VISAGE, OBJECT_SELF, OBJECT_SELF );
        return;
    }

    //Set and apply the AOE object
    effect eAOE = EffectAreaOfEffect(AOE_MOB_UNEARTHLY);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, OBJECT_SELF, HoursToSeconds(100));
}
