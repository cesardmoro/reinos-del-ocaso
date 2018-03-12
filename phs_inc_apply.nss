/*:://////////////////////////////////////////////
//:: Name Apply Include
//:: FileName PHS_INC_APPLY
//:://////////////////////////////////////////////
    This holds all applying functions - of effects, visuals and so on. Anything
    that applys using ApplyEffectToObject is put here.

    This can be used for passing damage through for shield other (low level, but
    cool spell!)
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//:: Created On: January 2004
//::////////////////////////////////////////////*/

#include "PHS_INC_CONSTANT"
#include "PHS_INC_REMOVE"

// Returns the first caster of nSpell on oTarget. Should really only be used
// for spells which only 1 can be applied at once.
object PHS_FirstCasterOfSpellEffect(int nSpell, object oTarget);

// This will instanlty apply EffectDamage using the parameters.
// - This is used for all applying damage effects.
// - Used for Shield Other.
void PHS_ApplyDamageToObject(object oTarget, int nDamageAmount, int nDamageType = DAMAGE_TYPE_MAGICAL, int nDamagePower = DAMAGE_POWER_NORMAL);

// This will instanlty apply EffectDamage using the parameters.
// - This is used for all applying damage effects.
// - Used for Shield Other.
// It also applys eVis to oTarget.
void PHS_ApplyDamageVFXToObject(object oTarget, effect eVis, int nDamageAmount, int nDamageType = DAMAGE_TYPE_MAGICAL, int nDamagePower = DAMAGE_POWER_NORMAL);

// Apply both eVis and eInstant on oTarget at once
void PHS_ApplyInstantAndVFX(object oTarget, effect eVis, effect eInstant);
// Apply eVis instantly, and eDur for fDuration, on oTarget
void PHS_ApplyDurationAndVFX(object oTarget, effect eVis, effect eDur, float fDuration);

// Apply an instant visual that misses or hits oTarget, depending on nTouchResult.
void PHS_ApplyTouchVisual(object oTarget, int nVis, int nTouchResult);
// Apply an instant beam that misses or hits oTarget, depending on nTouchResult.
void PHS_ApplyTouchBeam(object oTarget, int nBeam, int nTouchResult);

// Returns the first caster of nSpell on oTarget. Should really only be used
// for spells which only 1 can be applied at once.
object PHS_FirstCasterOfSpellEffect(int nSpell, object oTarget)
{
    //Search through the valid effects on the target.
    effect eCheck = GetFirstEffect(oTarget);
    while(GetIsEffectValid(eCheck))
    {
        if(GetEffectSpellId(eCheck) == nSpell)
        {
            return GetEffectCreator(eCheck);
        }
        //Get next effect on the target
        eCheck = GetNextEffect(oTarget);
    }
    return OBJECT_INVALID;
}
// This will instanlty apply EffectDamage using the parameters.
// - This is used for all applying damage effects.
// - Used for Shield Other.
void PHS_ApplyDamageToObject(object oTarget, int nDamageAmount, int nDamageType = DAMAGE_TYPE_MAGICAL, int nDamagePower = DAMAGE_POWER_NORMAL)
{
    if(nDamageAmount <= 0) return;
    // Define damage + type + power
    effect eDamage = EffectDamage(nDamageAmount, nDamageType, nDamagePower);
    if(nDamageAmount > 0 && GetHasSpellEffect(PHS_SPELL_SHIELD_OTHER, oTarget))
    {
        object oCaster = PHS_FirstCasterOfSpellEffect(PHS_SPELL_SHIELD_OTHER, oTarget);
        if(GetIsObjectValid(oCaster) && !GetIsDead(oCaster))
        {
            // Half damage to each
            eDamage = EffectDamage(nDamageAmount/2, nDamageType, nDamagePower);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oCaster);
        }
        else
        {
            PHS_RemoveSpellEffectsFromTarget(PHS_SPELL_SHIELD_OTHER, oTarget);
        }
    }
    // Damage applied (weather it is half or not)
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
}
// This will instanlty apply EffectDamage using the parameters.
// - This is used for all applying damage effects.
// - Used for Shield Other.
// It also applys eVis to oTarget.
void PHS_ApplyDamageVFXToObject(object oTarget, effect eVis, int nDamageAmount, int nDamageType = DAMAGE_TYPE_MAGICAL, int nDamagePower = DAMAGE_POWER_NORMAL)
{
    if(nDamageAmount <= 0) return;
    // Visual then damage
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    PHS_ApplyDamageToObject(oTarget, nDamageAmount, nDamageType, nDamagePower);
}

// Apply both eVis and eInstant on oTarget at once
void PHS_ApplyInstantAndVFX(object oTarget, effect eVis, effect eInstant)
{
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eInstant, oTarget);
}
// Apply eVis instantly, and eDur for fDuration, on oTarget
void PHS_ApplyDurationAndVFX(object oTarget, effect eVis, effect eDur, float fDuration)
{
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, fDuration);
}
// Apply an instant visual that misses or hits oTarget, depending on nTouchResult.
void PHS_ApplyTouchVisual(object oTarget, int nVis, int nTouchResult)
{
    effect eVis = EffectVisualEffect(nVis, (nTouchResult == FALSE));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
}
// Apply an instant beam that misses or hits oTarget, depending on nTouchResult.
void PHS_ApplyTouchBeam(object oTarget, int nBeam, int nTouchResult)
{
    effect eBeam = EffectBeam(nBeam, OBJECT_SELF, BODY_NODE_HAND, (nTouchResult == FALSE));
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBeam, oTarget, 1.5);
}
