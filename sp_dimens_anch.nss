//::///////////////////////////////////////////////
//:: Spell: Dimensional Anchor
//:: sp_dimens_anch
//::///////////////////////////////////////////////
/** @ file
    Dimensional Anchor

    Abjuration
    Level: Clr 4, Sor/Wiz 4
    Components: V, S
    Casting Time: 1 standard action
    Range: Medium (100 ft. + 10 ft./level)
    Effect: Ray
    Duration: 1 min./level
    Saving Throw: None
    Spell Resistance: Yes (object)

    A green ray springs from your outstretched hand. You must make a ranged
    touch attack to hit the target. Any creature or object struck by the ray is
    covered with a shimmering emerald field that completely blocks
    extradimensional travel. Forms of movement barred by a dimensional anchor
    include astral projection, blink, dimension door, ethereal jaunt,
    etherealness, gate, maze, plane shift, shadow walk, teleport, and similar
    spell-like or psionic abilities. The spell also prevents the use of a gate
    or teleportation circle for the duration of the spell.

    A dimensional anchor does not interfere with the movement of creatures
    already in ethereal or astral form when the spell is cast, nor does it block
    extradimensional perception or attack forms. Also, dimensional anchor does
    not prevent summoned creatures from disappearing at the end of a summoning
    spell.


    @author Ornedan
    @date   Created  - 2005.10.20
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "spinc_common"
#include "prc_inc_teleport"


void DispelMonitor(object oCaster, object oTarget, int nSpellID, int nBeatsRemaining);

void main()
{
    SPSetSchool(SPELL_SCHOOL_ABJURATION);
    // Spellhook
    if(!X2PreSpellCastCode()) return;

    /* Main spellscript */
    object oCaster = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nCasterLvl = PRCGetCasterLevel();
    int nSpellID   = PRCGetSpellId();
    effect eVis    = EffectVisualEffect(VFX_DUR_GLOBE_INVULNERABILITY);
    float fDur     = 20.0f;//SPGetMetaMagicDuration(60.0 * nCasterLvl);

    // Let the AI know
    SPRaiseSpellCastAt(oTarget, TRUE, nSpellID, oCaster);

    // Touch Attack
    int nTouchAttack = PRCDoRangedTouchAttack(oTarget);

    // Shoot the ray
    effect eRay = EffectBeam(VFX_BEAM_DISINTEGRATE, oCaster, BODY_NODE_HAND, !(nTouchAttack > 0));
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.7, FALSE);

    // Apply effect if hit
    if(nTouchAttack > 0)
    {
        // Spell Resistance
        if(!SPResistSpell(oCaster, oTarget))
        {
            // No duplicate dimensional anchor spell effects
            if(!GetLocalInt(oTarget, "PRC_DimAnch"))
            {
                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget, fDur, TRUE, nSpellID, nCasterLvl);
                // Increase the teleportation prevention counter
                DisallowTeleport(oTarget);
                // Set a marker so the power won't apply duplicate effects
                SetLocalInt(oTarget, "PRC_DimAnch", TRUE);
                // Start the monitor
                DelayCommand(6.0f, DispelMonitor(oCaster, oTarget, nSpellID, (FloatToInt(fDur) / 6) - 1));

                if(DEBUG) DoDebug("sp_dimens_anch: The anchoring will wear off in " + IntToString(FloatToInt(fDur)) + "s");
            }
        }
    }

    // Cleanup
    SPSetSchool();
}

void DispelMonitor(object oCaster, object oTarget, int nSpellID, int nBeatsRemaining)
{
    // Has the power ended since the last beat, or does the duration run out now
    if((--nBeatsRemaining == 0) ||
       GZGetDelayedSpellEffectsExpired(nSpellID, oTarget, oCaster)
       )
    {
        if(DEBUG) DoDebug("sp_dimens_anch: The anchoring effect has been removed");
        // Reduce the teleport prevention counter
        AllowTeleport(oTarget);
        // Clear the effect presence marker
        DeleteLocalInt(oTarget, "PRC_DimAnch");
    }
    else
       DelayCommand(6.0f, DispelMonitor(oCaster, oTarget, nSpellID, nBeatsRemaining));
}