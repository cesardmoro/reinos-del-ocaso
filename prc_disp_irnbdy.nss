/*
  Iron Body
*/

#include "NW_I0_SPELLS"

void main()
{

    int nDuration = 18;

    effect eEResist;
    effect eFResist;
    effect eAResist;
    effect eVis = EffectVisualEffect(VFX_IMP_HOLY_AID);
    effect eDur = EffectVisualEffect(VFX_DUR_PROT_SHADOW_ARMOR);

    effect eStr,eDex;
    effect eCrit,eBlnd,ePois,eAbil,eDeaf,eDise,eStun;
    effect eDrow,eDamRed,eSpell,eMove;

    eStr = EffectAbilityIncrease(ABILITY_STRENGTH,6);
    eDex = EffectAbilityDecrease(ABILITY_DEXTERITY,6);

    eCrit = EffectImmunity(IMMUNITY_TYPE_CRITICAL_HIT);
    eBlnd = EffectImmunity(IMMUNITY_TYPE_BLINDNESS);
    ePois = EffectImmunity(IMMUNITY_TYPE_POISON);
    eAbil = EffectImmunity(IMMUNITY_TYPE_ABILITY_DECREASE);
    eDeaf = EffectImmunity(IMMUNITY_TYPE_DEAFNESS);
    eDise = EffectImmunity(IMMUNITY_TYPE_DISEASE);
    eStun = EffectImmunity(IMMUNITY_TYPE_STUN);

    eDrow = EffectSpellImmunity(SPELL_DROWN);

    eEResist = EffectDamageImmunityIncrease(DAMAGE_TYPE_ELECTRICAL,100);
    eFResist = EffectDamageImmunityIncrease(DAMAGE_TYPE_FIRE,50);
    eAResist = EffectDamageImmunityIncrease(DAMAGE_TYPE_ACID,50);

    eDamRed = EffectDamageReduction(15,DAMAGE_POWER_PLUS_TWENTY);
    eSpell = EffectSpellFailure(50,SPELL_SCHOOL_GENERAL);
    eMove = EffectMovementSpeedDecrease(50);

    //Link Aspect
    //effect eLink = EffectLinkEffects(, eDur);
    effect eLink = EffectLinkEffects(eStr,eDex);
    eLink = EffectLinkEffects(eLink,eCrit);
    eLink = EffectLinkEffects(eLink,eBlnd);
    eLink = EffectLinkEffects(eLink,ePois);
    eLink = EffectLinkEffects(eLink,eAbil);
    eLink = EffectLinkEffects(eLink,eDeaf);
    eLink = EffectLinkEffects(eLink,eDise);
    eLink = EffectLinkEffects(eLink,eStun);
    eLink = EffectLinkEffects(eLink,eDrow);
    eLink = EffectLinkEffects(eLink,eEResist);
    eLink = EffectLinkEffects(eLink,eFResist);
    eLink = EffectLinkEffects(eLink,eAResist);
    eLink = EffectLinkEffects(eLink,eDamRed);
    eLink = EffectLinkEffects(eLink,eSpell);
    eLink = EffectLinkEffects(eLink,eMove);
    eLink = EffectLinkEffects(eLink,eDur);

      //Apply Bonus's
      ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis,OBJECT_SELF);
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink,OBJECT_SELF, RoundsToSeconds(nDuration));

}
