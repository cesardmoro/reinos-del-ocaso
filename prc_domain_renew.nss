//::///////////////////////////////////////////////
//:: Renewal Domain Power
//:: prc_domain_renew.nss
//::///////////////////////////////////////////////
/*
    Heals 1d8 + Charisma hit points
    Free Action
*/
//:://////////////////////////////////////////////
//:: Modified By: Stratovarius
//:: Modified On: 19.12.2005
//:://////////////////////////////////////////////

#include "prc_feat_const"
#include "prc_alterations"

void main()
{
    DecrementRemainingFeatUses(OBJECT_SELF, FEAT_DOMAIN_POWER_RENEWAL);

    object oPC = OBJECT_SELF;
        effect eVis = EffectVisualEffect(VFX_IMP_HEALING_M);
        effect eHeal = EffectHeal(d8() + GetAbilityModifier(ABILITY_CHARISMA, oPC));
        effect eLink = EffectLinkEffects(eVis, eHeal);

    ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oPC);
}

