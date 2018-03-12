/*:://////////////////////////////////////////////
//:: Spell Name Chaos Hammer
//:: Spell FileName PHS_S_ChaosHammr
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    20M range, 6.67M radius burst (huge), and plenty of stuff to damage non-chaotic
    people. Will save partial, SR on.

    The power takes the form of a multicolored explosion of leaping, ricocheting
    energy. No chaotics harmed.

    1d8/2 levels to lawful (1d6/level to lawful outsiders) + slow for 1d6 rounds
    (Will negates, half damage). Neturals are not slowed, and only deals half damage.
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Hits non-chatoic people.

    Hits for up to 5d6 damage, or 10d6 VS outsiders.

    Neutrals take /2 damage.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_CHAOS_HAMMER)) return;

    // Delcare major variables.
    object oCaster = OBJECT_SELF;
    object oTarget;
    location lTarget = GetSpellTargetLocation();
    int nCasterLevel = GetCasterLevel(oCaster);
    int nMetaMagic = GetMetaMagicFeat();
    int nAlignment, nDam;
    int nSpellSaveDC = GetSpellSaveDC();
    float fDuration, fDelay;

    // Delcare Effects
    effect eVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
    effect eVisSlow = EffectVisualEffect(VFX_IMP_SLOW);
    effect eSlow = EffectSlow();
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eLink = EffectLinkEffects(eSlow, eDur);
    eLink = EffectLinkEffects(eLink, eVisSlow);

    // how much damage dice?
    // 1d8 damage/2 caster levels. We do 1d6/caster level to outsiders
    int nOutsiderDice = PHS_LimitInteger(nCasterLevel, 10);

    // Normal dice will be nOutsiderDice/2, or 1 per 2 caster levels.
    int nNormalDice = PHS_LimitInteger(nOutsiderDice/2);

    // Apply AOE burst effect
    effect eAOE = EffectVisualEffect(PHS_VFX_FNF_CHAOS_HAMMER); //VFX_FNF_LOS_EVIL_20
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eAOE, lTarget);

    // Loop all targets in the area.
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE);
    while(GetIsObjectValid(oTarget))
    {
        // Alignment check
        nAlignment = GetAlignmentLawChaos(oTarget);
        if(nAlignment != ALIGNMENT_CHAOTIC)
        {
            // Delay
            fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;

            // Get random damage
            if(GetRacialType(oTarget) == RACIAL_TYPE_OUTSIDER)
            {
                nDam = PHS_MaximizeOrEmpower(6, nOutsiderDice, nMetaMagic);
            }
            else
            {
                nDam = PHS_MaximizeOrEmpower(8, nNormalDice, nMetaMagic);
            }
            // Half damage if only neutral
            if(nAlignment == ALIGNMENT_NEUTRAL)
            {
                // Divide by 2.
                nDam /= 2;
            }
            // Will saving throw for half damage, and no slow.
            // - Chaos Saving throw.
            if(!PHS_SavingThrow(SAVING_THROW_WILL, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_CHAOS))
            {
                nDam /= 2;
                if(nDam > 0)
                {
                    // Do damage and VFX
                    DelayCommand(fDelay, PHS_ApplyDamageVFXToObject(oTarget, eVis, nDam, DAMAGE_TYPE_DIVINE));
                }
            }
            else
            {
                // Else, full damage. If not neutral, slow for 1d6 rounds

                // Do damage and VFX
                DelayCommand(fDelay, PHS_ApplyDamageVFXToObject(oTarget, eVis, nDam, DAMAGE_TYPE_DIVINE));
                // If not alignment neutral, we apply slow as they failed the save.
                if(nAlignment != ALIGNMENT_NEUTRAL)
                {
                    // Apply slow instantly.
                    fDuration = PHS_GetRandomDuration(PHS_ROUNDS, 6, 1, nMetaMagic);

                    // Apply slow for fDuration, and instantly!
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration);
                }
            }
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE);
    }
}
