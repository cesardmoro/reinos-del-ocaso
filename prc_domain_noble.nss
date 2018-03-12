//::///////////////////////////////////////////////
//:: Nobility Domain Power
//:: prc_domain_noble.nss
//::///////////////////////////////////////////////
/*
    Grants +2 Attack, Saving Throws, Skills and Damage to all allies.
    Does not affect the caster
    Lasts Charisma modifier rounds.
*/
//:://////////////////////////////////////////////
//:: Modified By: Stratovarius
//:: Modified On: 19.12.2005
//:://////////////////////////////////////////////

#include "prc_feat_const"
#include "prc_alterations"

void main()
{
    DecrementRemainingFeatUses(OBJECT_SELF, FEAT_DOMAIN_POWER_NOBILITY);

    if (GetHasEffect(EFFECT_TYPE_SILENCE, OBJECT_SELF))
    {
        FloatingTextStrRefOnCreature(85764,OBJECT_SELF); // not useable when silenced
        return;
    }

    effect eAttack = EffectAttackIncrease(2);
    effect eDamage = EffectDamageIncrease(DAMAGE_BONUS_2, DAMAGE_TYPE_BLUDGEONING);
    effect eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, 2);
    effect eSkill = EffectSkillIncrease(SKILL_ALL_SKILLS, 2);

    effect eLink = EffectLinkEffects(eAttack, eDamage);
    eLink = EffectLinkEffects(eLink, eSave);
    eLink = EffectLinkEffects(eLink, eSkill);

    effect eVis = EffectVisualEffect(VFX_IMP_MAGBLUE, FALSE);

    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));

    while(GetIsObjectValid(oTarget) )
    {
         // Does not gain benefit if silenced or deaf
         if (!GetHasEffect(EFFECT_TYPE_SILENCE, oTarget) && !GetHasEffect(EFFECT_TYPE_DEAF, oTarget))
         {
              if(GetIsFriend(oTarget) && oTarget != OBJECT_SELF)
              {
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(GetAbilityModifier(ABILITY_CHARISMA, OBJECT_SELF)));
              }
         }
         oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
    }
}
