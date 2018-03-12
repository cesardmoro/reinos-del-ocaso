/*:://////////////////////////////////////////////
//:: Spell Name Freezing Sphere
//:: Spell FileName phs_s_freezesphe
//:://////////////////////////////////////////////
//:: In Game Spell desctiption
//:://////////////////////////////////////////////
    40M range, 10 foot, 3.3M radius burst. Reflex half damage for 1d6 damage/
    caster level (max 15d6) water elementals take 1d8 damage. All cold.

    Can hold for up to 1 round/level. (NOT IN YET)
//:://////////////////////////////////////////////
//:: Spell Effects Applied / Notes
//:://////////////////////////////////////////////
    Nearly the same as fireball. Note that it is possible to refrain from
    firing (NOT IN YET)
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

#include "PHS_INC_SPELLS"

void main()
{
    // Spell Hook Check.
    if(!PHS_SpellHookCheck(PHS_SPELL_FREEZING_SPHERE)) return;

    // Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget;
    location lTarget = GetSpellTargetLocation();
    int nCasterLevel = PHS_GetCasterLevel();
    int nSpellSaveDC = PHS_GetSpellSaveDC();
    int nMetaMagic = GetMetaMagicFeat();
    int nDamage;
    int nAppearance;
    float fDelay;

    // Declare Effects
    effect eVis = EffectVisualEffect(VFX_IMP_FROST_L);

    // Are we holding it back or not?
    //if(!NOT IN YET) return;

    // Apply AOE location explosion
    effect eExplode = EffectVisualEffect(PHS_VFX_FNF_FREEZING_SPHERE);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);

    // Get all targets in a sphere, medium (3.3) radius, objects
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    // Loop targets
    while(GetIsObjectValid(oTarget))
    {
        // PvP Check
        if(!GetIsReactionTypeFriendly(oTarget, oCaster))
        {
            // Fire cast spell at event for the specified target
            PHS_SignalSpellCastAt(oTarget, PHS_SPELL_FREEZING_SPHERE);

            // Get the distance between the explosion and the target to calculate delay
            fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;

            // Spell resistance And immunity checking.
            if(!PHS_SpellResistanceCheck(oCaster, oTarget, fDelay))
            {
                // Damage - it is 1d8 for water elementals!
                nAppearance = GetAppearanceType(oTarget);

                // Elemental
                if(GetObjectType(oTarget) == OBJECT_TYPE_CREATURE &&
                  (nAppearance == APPEARANCE_TYPE_ELEMENTAL_WATER ||
                   nAppearance == APPEARANCE_TYPE_ELEMENTAL_WATER_ELDER ||
                   FindSubString(GetStringUpperCase(GetSubRace(oTarget)), "WATER ELEMENTAL") >= 0))
                {
                    // 1d8/level
                    nDamage = PHS_MaximizeOrEmpower(8, nCasterLevel, nMetaMagic);
                }
                // Not an elemental
                else
                {
                    // 1d6/level
                    nDamage = PHS_MaximizeOrEmpower(6, nCasterLevel, nMetaMagic);
                }

                // Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
                nDamage = GetReflexAdjustedDamage(nDamage, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_COLD);

                // Need to do damage to apply visuals
                if(nDamage > 0)
                {
                    // Apply effects to the currently selected target.
                    DelayCommand(fDelay, PHS_ApplyDamageVFXToObject(oTarget, eVis, nDamage, DAMAGE_TYPE_COLD));
                }
            }
        }
        // Get Next Target
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
}
