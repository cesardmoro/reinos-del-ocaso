/*:://////////////////////////////////////////////
//:: Spell Name Protection from Arrows
//:: Spell FileName PHS_S_ProtArrows
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    one creature touched, for 1 hour/level (or until discharged) gets 10/-
    damage resistance Versus piercing weapons , up to 10 * caster level, to 100.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Affects all piercing to the limit.

    Shamefully, all piercing is a bit bad, but oh well...
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check.
    if(!PHS_SpellHookCheck(PHS_SPELL_PROTECTION_FROM_ARROWS)) return;

    //Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nMetaMagic = GetMetaMagicFeat();
    int nCasterLevel = PHS_GetCasterLevel();

    // Duration in hours
    float fDuration = PHS_GetDuration(PHS_HOURS, nCasterLevel, nMetaMagic);

    // Damage is 10 * Caster level, max of 100.
    int nDamageMax = PHS_LimitInteger(nCasterLevel * 10, 100);

    // Delcare effects
    effect eDur = EffectVisualEffect(771);
    effect eDamageResistance = EffectDamageResistance(DAMAGE_TYPE_PIERCING, 10, nDamageMax);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    // Link effects
    effect eLink = EffectLinkEffects(eDur, eDamageResistance);
    eLink = EffectLinkEffects(eLink, eCessate);

    // Remove previous castings
    PHS_RemoveSpellEffectsFromTarget(PHS_SPELL_PROTECTION_FROM_ARROWS, oTarget);

    // Signal event
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_PROTECTION_FROM_ARROWS, FALSE);

    // Apply effects
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
}
