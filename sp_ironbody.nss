/*
  Iron Body

Iron Body
Transmutation
Level: Earth 8, Sor/Wiz 8
Components: V, S, M/DF
Casting Time: 1 standard action
Range: Personal
Target: You
Duration: 1 min./level (D)

This spell transforms your body into living iron, which grants you several
powerful resistances and abilities.

You gain damage reduction 15/adamantine. You are immune to blindness, critical hits,
ability score damage, deafness, disease, drowning, electricity, poison, stunning,
and all spells or attacks that affect your physiology or respiration, because you
have no physiology or respiration while this spell is in effect. You take only half
damage from acid and fire of all kinds. However, you also become vulnerable to all
special attacks that affect iron golems.

You gain a +6 enhancement bonus to your Strength score, but you take a -6 penalty to
Dexterity as well (to a minimum Dexterity score of 1), and your speed is reduced to
half normal. You have an arcane spell failure chance of 50% and a -8 armor check
penalty, just as if you were clad in full plate armor. You cannot drink (and thus
can’t use potions) or play wind instruments.

Your unarmed attacks deal damage equal to a club sized for you (1d4 for Small
characters or 1d6 for Medium characters), and you are considered armed when making
unarmed attacks.

Your weight increases by a factor of ten, causing you to sink in water like a stone.
However, you could survive the crushing pressure and lack of air at the bottom of
the ocean at least until the spell duration expires.
Arcane Material Component

A small piece of iron that was once part of either an iron golem, a hero’s armor, or a war machine.

*/

#include "spinc_common"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_ENCHANTMENT);

/*
  Spellcast Hook Code
  Added 2004-11-02 by Stratovarius
  If you want to make changes to all powers,
  check psi_spellhook to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PrePowerCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook
    int nLevel = PRCGetCasterLevel();
    int nDuration = nLevel;
    //Enter Metamagic conditions
    int nMetaMagic = PRCGetMetaMagicFeat();
    if (CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND))
    {
        nDuration = nDuration *2; //Duration is +100%
    }

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
    eDrow = EffectSpellImmunity(SPELL_MASS_DROWN);

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
    //effect eLink = EffectLinkEffects(eStr,eCrit);
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
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis,OBJECT_SELF);
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink,OBJECT_SELF, RoundsToSeconds(nDuration), TRUE, -1, nLevel);
    //ApplyAbilityDamage(OBJECT_SELF, ABILITY_DEXTERITY, 6, DURATION_TYPE_TEMPORARY, TRUE, RoundsToSeconds(nDuration));

    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}
