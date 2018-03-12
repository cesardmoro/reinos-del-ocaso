/*:://////////////////////////////////////////////
//:: Spell Name Power Word Stun
//:: Spell FileName PHS_S_PWStun
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    One target, up to 150HP, is stunned for a cirtain duration. SR applies

    Hit Points  Duration
    50 or less  4d4 rounds
    51-100      2d4 rounds
    101-150     1d4 rounds
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    As spell, including Bioware visual effect.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check
    if(!PHS_SpellHookCheck(PHS_SPELL_POWER_WORD_STUN)) return;

    //Declare target variables
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nMetaMagic = GetMetaMagicFeat();
    int nHitpoints = GetCurrentHitPoints(oTarget);
    float fDuration;

    // Get duration
    // Hit Points  Duration
    // ----------  --------
    // 50 or less  4d4 rounds
    // 51-100      2d4 rounds
    // 101-150     1d4 rounds
    int nDice = 1;
    if(nHitpoints <= 50)
    {
        // Duration is 4d4 rounds
        nDice = 4;
    }
    else if(nHitpoints < 100)
    {
        // Duration is 2d4 rounds
        nDice = 2;
    }
    else if(nHitpoints < 150)
    {
        // Duration is 1d4 rounds
        nDice = 1;
    }
    // Get final duration
    fDuration = PHS_GetRandomDuration(PHS_ROUNDS, 4, nDice, nMetaMagic);

    // Declare Effects
    effect eVis = EffectVisualEffect(VFX_IMP_STUN);
    effect eStun = EffectStunned();
    effect eDur = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED);
    // Link effects
    effect eLink = EffectLinkEffects(eDur, eStun);

    // Apply the VFX impact
    effect eWord =  EffectVisualEffect(VFX_FNF_PWSTUN);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eWord, oTarget);

    // PvP check
    if(!GetIsReactionTypeFriendly(oTarget))
    {
        // Make sure thier HP is <= 150
        if(nHitpoints <= 150)
        {
            // Signal Spell Cast at
            PHS_SignalSpellCastAt(oTarget, PHS_SPELL_POWER_WORD_STUN);

            // Check spell resistance and immunity
            if(!PHS_SpellResistanceCheck(oCaster, oTarget))
            {
                // Apply effects for duration
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget, fDuration);
            }
        }
    }
}
