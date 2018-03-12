//::///////////////////////////////////////////////
//:: Protection Domain Power
//:: prc_domain_prtct.nss
//::///////////////////////////////////////////////
/*
    Grants Char level to saves for 1 round
*/
//:://////////////////////////////////////////////
//:: Modified By: Stratovarius
//:: Modified On: 19.12.2005
//:://////////////////////////////////////////////

#include "prc_feat_const"
#include "prc_alterations"

void main()
{
    DecrementRemainingFeatUses(OBJECT_SELF, FEAT_PROTECTION_DOMAIN_POWER);

        object oPC = OBJECT_SELF;
        object oTarget = PRCGetSpellTargetObject();
        effect eDur = EffectVisualEffect(VFX_DUR_MAGIC_RESISTANCE);
        effect eCha = EffectSavingThrowIncrease(SAVING_THROW_ALL, GetHitDice(oPC));
        effect eLink = EffectLinkEffects(eCha, eDur);

        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(1));
}

