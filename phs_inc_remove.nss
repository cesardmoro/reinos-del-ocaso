/*:://////////////////////////////////////////////
//:: Name Spell Removal of Effects include
//:: FileName phs_inc_remove
//:://////////////////////////////////////////////
    All the removal of effects

    - All return 1 or 0 if it removes spell effects
    - Ones which remove only effects cast by the caster
    - Ones which remove only 1 interation of the spell

    Also includes all dispel functions, and spell stripping functions.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//:: Created On: October
//::////////////////////////////////////////////*/

//Searchs through a persons effects and removes those from a particular spell by a particular caster.
// - Removes if after fDelay
// - Returns TRUE if it removes any
int PHS_RemoveSpellEffects(int nSpell_ID, object oCaster, object oTarget, float fDelay = 0.0);
//Searchs through a persons effects and removes all those of a specific type.
// - Returns TRUE if it removes any effect of nEffecTypeID
int PHS_RemoveSpecificEffect(int nEffectTypeID, object oTarget, int iSubtype = SUBTYPE_MAGICAL);
// Remove all protections from nSpell_ID on oTarget, any caster.
// TRUE if it does remove any.
//  - Checks for them before it does it.
//  - Will not remove extraodinary effects
//  - fDelay - Is the delay for the effect to be removed.
int PHS_RemoveSpellEffectsFromTarget(int nSpell_ID, object oTarget = OBJECT_SELF, float fDelay = 0.0);
// Remove all spell protections from a specific spell on oTarget.
// TRUE if it does remove any.
//  - Checks for them before it does it.
//  - Will not remove extraodinary effects
//  - fDelay - Is the delay for the effect to be removed.
int PHS_RemoveMultipleSpellEffectsFromTarget(object oTarget, int nSpell_ID1, int nSpell_ID2, int nSpell_ID3 = 0, int nSpell_ID4 = 0, int nSpell_ID5 = 0, int nSpell_ID6 = 0);

// This will dispel magic (All, IE targeted) on oTarget.
// - Checks spell effects for special things when ended.
// - No special reaction checks.
// - Uses default effect.
void PHS_DispelMagicAll(object oTarget, int nCasterLevel);

// This will dispel magic (Best, IE Area-of-effect) on oTarget.
// - Checks spell effects for special things when ended.
// - No special reaction checks.
// - Uses default effect.
void PHS_DispelMagicBest(object oTarget, int nCasterLevel);

// This will dispel magic - on an area of effect. Each one will need a seperate
// caster check to destroy and must be from a spell, of course.
void PHS_DispelMagicAreaOfEffect(object oTarget, int nCasterLevel);

//Searchs through a persons effects and removes those from a particular spell by a particular caster.
// - Removes if after fDelay
// - Returns TRUE if it removes any
int PHS_RemoveSpellEffects(int nSpell_ID, object oCaster, object oTarget, float fDelay = 0.0)
{
    //Declare major variables
    effect eCheck;
    int iReturn = FALSE;
    if(GetHasSpellEffect(nSpell_ID, oTarget))
    {
        //Search through the valid effects on the target.
        eCheck = GetFirstEffect(oTarget);
        while(GetIsEffectValid(eCheck))
        {
            if(GetEffectCreator(eCheck) == oCaster)
            {
                //If the effect was created by the spell then remove it
                if(GetEffectSpellId(eCheck) == nSpell_ID)
                {
                    RemoveEffect(oTarget, eCheck);
                    iReturn = TRUE;
                }
            }
            //Get next effect on the target
            eCheck = GetNextEffect(oTarget);
        }
    }
    return iReturn;
}
//Searchs through a persons effects and removes all those of a specific type.
// - Returns TRUE if it removes any effect of nEffecTypeID
int PHS_RemoveSpecificEffect(int nEffectTypeID, object oTarget, int iSubtype = SUBTYPE_MAGICAL)
{
    //Declare major variables
    effect eCheck;
    int nReturn = FALSE;
//    int nSpellEffectCheckFor;
    //Search through the valid effects on the target.
    // We also remove all spell effects that generated nEffectTypeID, if any.
    eCheck = GetFirstEffect(oTarget);
    while(GetIsEffectValid(eCheck))
    {
        if(GetEffectType(eCheck) == nEffectTypeID)
        {
            if(GetEffectSubType(eCheck) == iSubtype)
            {
                // We remove all spell effects if it was from a spell too.
//                nSpellId = GetEffectSpellId(eCheck);
//                if(nSpellId >= 0)
//                {
//                    nSpellEffectCheckFor++;
//                    SetLocalInt(OBJECT_SELF, "TEMP_SPELL_ID_REMOVE" + IntToString(nSpellEffectCheckFor), nSpellId);
//                }
                //If the effect was created by the spell then remove it
                RemoveEffect(oTarget, eCheck);
                nReturn = TRUE;
            }
        }
        //Get next effect on the target
        eCheck = GetNextEffect(oTarget);
    }
    // Remove all under TEMP_SPELL_ID_REMOVE
//    if(nSpellEffectCheckFor > 0)
//    {
//        int nCnt;
//        for(nCnt = 1; nCnt <= nSpellEffectCheckFor; nCnt++)
//        {
            // Remove this spell effect's effects
//            nSpellId = GetLocalInt(OBJECT_SELF, "TEMP_SPELL_ID_REMOVE" + IntToString(nCnt));
//            PHS_RemoveSpellEffectsFromTarget(nSpellId, oTarget);
//            DeleteLocalInt(OBJECT_SELF, "TEMP_SPELL_ID_REMOVE" + IntToString(nCnt));
//        }
//    }
    return nReturn;
}
// Remove all spell protections from a specific spell on oTarget.
// TRUE if it does remove any.
//  - Checks for them before it does it.
//  - Will not remove extraodinary effects
//  - fDelay - Is the delay for the effect to be removed.
int PHS_RemoveSpellEffectsFromTarget(int nSpell_ID, object oTarget, float fDelay)
{
    //Declare major variables
    effect eProtection;
    int iReturn = FALSE;
    if(GetHasSpellEffect(nSpell_ID, oTarget))
    {
        //Search through the valid effects on the target.
        eProtection = GetFirstEffect(oTarget);
        while(GetIsEffectValid(eProtection))
        {
            //If the effect was created by the spell then remove it (after fDelay)
            if(GetEffectSpellId(eProtection) == nSpell_ID)
            {
                DelayCommand(fDelay, RemoveEffect(oTarget, eProtection));
                //return TRUE
                iReturn = TRUE;
            }
            //Get next effect on the target
            eProtection = GetNextEffect(oTarget);
        }
    }
    return iReturn;
}

// Remove all spell protections from a specific spell on oTarget.
// TRUE if it does remove any.
//  - Checks for them before it does it.
//  - Will not remove extraodinary effects
//  - fDelay - Is the delay for the effect to be removed.
int PHS_RemoveMultipleSpellEffectsFromTarget(object oTarget, int nSpell_ID1, int nSpell_ID2, int nSpell_ID3 = 0, int nSpell_ID4 = 0, int nSpell_ID5 = 0, int nSpell_ID6 = 0)
{
    // Check validness
    if(nSpell_ID2 == FALSE) nSpell_ID2 = -1;
    if(nSpell_ID3 == FALSE) nSpell_ID3 = -1;
    if(nSpell_ID4 == FALSE) nSpell_ID4 = -1;
    if(nSpell_ID5 == FALSE) nSpell_ID5 = -1;
    if(nSpell_ID6 == FALSE) nSpell_ID6 = -1;

    //Declare major variables
    effect eProtection;
    int iEffectID;
    int iReturn = FALSE;
    if(GetHasSpellEffect(nSpell_ID1, oTarget) ||
       GetHasSpellEffect(nSpell_ID2, oTarget) ||
       GetHasSpellEffect(nSpell_ID3, oTarget) ||
       GetHasSpellEffect(nSpell_ID4, oTarget) ||
       GetHasSpellEffect(nSpell_ID5, oTarget) ||
       GetHasSpellEffect(nSpell_ID6, oTarget))
    {
        //Search through the valid effects on the target.
        eProtection = GetFirstEffect(oTarget);
        while(GetIsEffectValid(eProtection))
        {
            iEffectID = GetEffectSpellId(eProtection);
            //If the effect was created by the spell then remove it (after fDelay)
            if(iEffectID == nSpell_ID1 || iEffectID == nSpell_ID2 ||
               iEffectID == nSpell_ID3 || iEffectID == nSpell_ID4 ||
               iEffectID == nSpell_ID5 || iEffectID == nSpell_ID6)
            {
                RemoveEffect(oTarget, eProtection);
                //return TRUE
                iReturn = TRUE;
            }
            //Get next effect on the target
            eProtection = GetNextEffect(oTarget);
        }
    }
    return iReturn;
}

// This will dispel magic (All, IE targeted) on oTarget.
// - Checks spell effects for special things when ended.
// - No special reaction checks.
// - Uses default effect.
void PHS_DispelMagicAll(object oTarget, int nCasterLevel)
{
    // Declare effects
    effect eDispel = EffectDispelMagicAll(nCasterLevel);
    effect eVis = EffectVisualEffect(VFX_IMP_DISPEL);

    // Set if the target has any spell effects that have effects applied
    // when ended.

    // - Stuff

    // Apply dispel
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDispel, oTarget);


    // And apply the effects of spells removed.

    // - Stuff
}


// This will dispel magic (Best, IE Area-of-effect) on oTarget.
// - Checks spell effects for special things when ended.
// - No special reaction checks.
// - Uses default effect.
void PHS_DispelMagicBest(object oTarget, int nCasterLevel)
{
    // Declare effects
    effect eDispel = EffectDispelMagicBest(nCasterLevel);
    effect eVis = EffectVisualEffect(VFX_IMP_DISPEL);

    // Set if the target has any spell effects that have effects applied
    // when ended.

    // - Stuff

    // Apply dispel
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDispel, oTarget);


    // And apply the effects of spells removed.

    // - Stuff
}

// This will dispel magic - on an area of effect. Each one will need a seperate
// caster check to destroy and must be from a spell, of course.
void PHS_DispelMagicAreaOfEffect(object oTarget, int nCasterLevel)
{
    // Dispel the AOE
}
