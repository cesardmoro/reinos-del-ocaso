//::///////////////////////////////////////////////
//:: Slayer of Domiel
//:: prc_slayerdomiel.nss
//:://////////////////////////////////////////////
//:: Applies Slayer of Domiel Bonuses
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: Jan 27, 2006
//:://////////////////////////////////////////////

#include "prc_inc_clsfunc"

void main()
{
        // Does not stack with the paladin feat of the same name
        if (GetHasFeat(FEAT_DIVINE_GRACE)) return;
        // Does the Charisma to saves
        ActionCastSpellOnSelf(SPELL_SLAYER_DOMIEL_DIVINE_GRACE);    
}