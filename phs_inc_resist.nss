/*:://////////////////////////////////////////////
//:: Name Spell Resistance, spell immunity checking Include
//:: FileName phs_inc_resist
//:://////////////////////////////////////////////
    This includes seperate, or all in one functions for:

    - Spell resistance only
    - Spell Immunity only
    - Spell resistance AND spell immunity

    All 3 DO include Mantals, ONLY because they are ONLY used for Globes and
    the like (Are basically an unlimited version of them).

    We use:

    // Do a Spell Resistance check between oCaster and oTarget, returning TRUE if
    // the spell was resisted.
    // * Return value if oCaster or oTarget is an invalid object: FALSE
    // * Return value if spell cast is not a player spell: - 1
    // * Return value if spell resisted: 1
    // * Return value if spell resisted via magic immunity: 2
    // * Return value if spell resisted via spell absorption: 3
    int ResistSpell(object oCaster, object oTarget)

//:://////////////////////////////////////////////
//:: Created By: Jasperre
//:: Created On: October
//::////////////////////////////////////////////*/

// Do a Spell Resistance and immunity check. TRUE if they resist the spell.
// - Most use this.
// - Checks spell resistance, Globes, and Spell Immunity.
//   - EffectSpellImmunity, EffectSpellResistanceIncrease, EffectSpellLevelAbsorption.
int PHS_SpellResistanceCheck(object oCaster, object oTarget, float fDelay = 0.0);
// Do a Spell Resistance check. TRUE if they resist the spell.
// - We check Spell Resistance, but not Immunity or Globes
int PHS_SpellResistanceOnlyCheck(object oCaster, object oTarget, float fDelay = 0.0);
// Do a Spell Immunity check. TRUE if they resist the spell.
// - We check Immunity and Globes, but not Spell Resistance
int PHS_SpellImmunityCheck(object oCaster, object oTarget, float fDelay = 0.0);

// Do a Spell Resistance and immunity check. TRUE if they resist the spell.
// - Most use this.
// - Checks spell resistance, Globes, and Spell Immunity.
//   - EffectSpellImmunity, EffectSpellResistanceIncrease, EffectSpellLevelAbsorption.
int PHS_SpellResistanceCheck(object oCaster, object oTarget, float fDelay = 0.0)
{
    // We do this for any flying projectiles to hit a barrier.
    if(fDelay > 0.5)
    {
        fDelay -= 0.1;
    }
    int nResist = ResistSpell(oCaster, oTarget);
    effect eSR = EffectVisualEffect(VFX_IMP_MAGIC_RESISTANCE_USE);
    effect eGlobe = EffectVisualEffect(VFX_IMP_GLOBE_USE);
    effect eMantle = EffectVisualEffect(VFX_IMP_SPELL_MANTLE_USE);
    if(nResist == 1) // Resisted: 1 (Spell Resistance)
    {
        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eSR, oTarget));
        return TRUE;
    }
    else if(nResist == 2) // Resisted via magic immunity: 2 (Globe, ETC - EffectSpellLevelAbsorption with no limit)
    {
        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eGlobe, oTarget));
        return TRUE;
    }
    else if(nResist == 3) // Resisted via spell absorption: 3 (Spell Mantle ETC - EffectSpellLevelAbsorption with a limit)
    {
        // More delay off. Improves how it looks.
        if(fDelay > 0.5)
        {
            fDelay -= 0.1;
        }
        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eMantle, oTarget));
        return TRUE;
    }
    return FALSE;
}

// Do a Spell Resistance check. TRUE if they resist the spell.
// - We check Spell Resistance, but not Immunity or Globes
int PHS_SpellResistanceOnlyCheck(object oCaster, object oTarget, float fDelay = 0.0)
{
    // We do this for any flying projectiles to hit a barrier.
    if(fDelay > 0.5)
    {
        fDelay -= 0.1;
    }
    int nResist = ResistSpell(oCaster, oTarget);
    effect eSR = EffectVisualEffect(VFX_IMP_MAGIC_RESISTANCE_USE);
    if(nResist == 1) //Spell Resistance - only one to check for
    {
        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eSR, oTarget));
        return TRUE;
    }
    return FALSE;
}

// Do a Spell Immunity check. TRUE if they resist the spell.
// - We check Immunity and Globes, but not Spell Resistance
int PHS_SpellImmunityCheck(object oCaster, object oTarget, float fDelay = 0.0)
{
    // We do this for any flying projectiles to hit a barrier.
    if(fDelay > 0.5)
    {
        fDelay -= 0.1;
    }
    int nResist = ResistSpell(oCaster, oTarget);
    effect eGlobe = EffectVisualEffect(VFX_IMP_GLOBE_USE);
    effect eMantle = EffectVisualEffect(VFX_IMP_SPELL_MANTLE_USE);
    if(nResist == 2) //Globe - only one to check for
    {
        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eGlobe, oTarget));
        return TRUE;
    }
    else if(nResist == 3) // Resisted via spell absorption: 3 (Spell Mantle ETC - EffectSpellLevelAbsorption with a limit)
    {
        // More delay off. Improves how it looks.
        if(fDelay > 0.5)
        {
            fDelay -= 0.1;
        }
        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eMantle, oTarget));
        return TRUE;
    }
    return FALSE;
}

