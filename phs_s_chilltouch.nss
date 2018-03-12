/*:://////////////////////////////////////////////
//:: Spell Name Chill Touch
//:: Spell FileName PHS_S_ChillTouch
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    1 creature touched/level (class item does the stored stuff). 1d6 neg. damage
    on touch attack, and 1 point of strength (save VS fort for none).
    Undead flee for 1d4 rounds + 1/caster level (save VS willfor none)
    SR works.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    As spell description.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell hook check
    if(!PHS_SpellHookCheck(PHS_SPELL_CHILL_TOUCH)) return;

    // Declare Major Variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nMetaMagic = GetMetaMagicFeat();
    int nCasterLevel = PHS_GetCasterLevel();
    int nSpellSaveDC = PHS_GetSpellSaveDC();

    // Check if it was caster item etc.
    if(!PHS_CheckChargesForSpell(PHS_SPELL_CHILL_TOUCH, nCasterLevel - 1, RoundsToSeconds(nCasterLevel), oCaster)) return;

    // Do touch attack
    int nTouch = PHS_SpellTouchAttack(PHS_TOUCH_MELEE, oTarget, TRUE);

    // Duration of the fear is random - 1d4 + 1 round/level.
    float fDuration = PHS_GetRandomDuration(PHS_ROUNDS, 4, 1, nMetaMagic, nCasterLevel);

    // Get damage
    int nDam = PHS_MaximizeOrEmpower(6, 1, nMetaMagic, 0, nTouch);

    // Delcare Effects
    effect eStrength = EffectAbilityDecrease(ABILITY_STRENGTH, 1);
    effect eFear = EffectFrightened();
    effect eDur = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR);
    effect eCessate = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    // Link effects for fear
    effect eLink = EffectLinkEffects(eFear, eDur);
    eLink = EffectLinkEffects(eLink, eCessate);
    effect eStrengthLink = EffectLinkEffects(eStrength, eCessate);

    // Signal spell cast at event
    PHS_SignalSpellCastAt(oTarget, PHS_SPELL_CHILL_TOUCH);

    // Do hit or miss visual effect
    PHS_ApplyTouchVisual(oTarget, VFX_IMP_NEGATIVE_ENERGY, nTouch);

    // Melee Touch attack
    if(nTouch)
    {
        // PvP Check
        if(!GetIsReactionTypeFriendly(oTarget))
        {
            // Spell resistance and immunity check
            if(!PHS_SpellResistanceCheck(oCaster, oTarget))
            {
                // Check if undead or not
                if(GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
                {
                    // Undead, so apply fear against a will save
                    if(!PHS_SavingThrow(SAVING_THROW_WILL, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_NEGATIVE))
                    {
                        // Fear applied.
                        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
                    }
                }
                else
                {
                    // Non-undead, Damage + Strength damage.
                    PHS_ApplyDamageToObject(oTarget, nDam, DAMAGE_TYPE_NEGATIVE);

                    // Save - fortitude
                    if(!PHS_SavingThrow(SAVING_THROW_FORT, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_NEGATIVE))
                    {
                        // Apply strength damage - permament
                        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eStrengthLink, oTarget);
                    }
                }
            }
        }
    }
}
