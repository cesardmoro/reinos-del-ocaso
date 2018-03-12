/*:://////////////////////////////////////////////
//:: Name Spell Saves include
//:: FileName phs_inc_saves
//:://////////////////////////////////////////////
    This includes all the spell save functions, for easy reference

    Things like Spell Craft, special save or whatnot can be used.

    It does, of course, have the default way of doing it too.

    There is a special save function for non-spells :-D
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//:: Created On: October
//::////////////////////////////////////////////*/

#include "PHS_INC_CONSTANT"

// Required for spell saves. If they haven't got the diamond, the spell is lost
void PHS_RemoveProtectionSpellEffects(object oTarget);

// Returns the spell's Save DC, mainly using GetSpellSaveDC()
// (10 + spell level + relevant ability bonus).
int PHS_GetSpellSaveDC();

// Returns the caster level of oCaster, commonly OBJECT_SELF.
// - Wrappered so it can be changed at any time
// - Returns at least 1
int PHS_GetCasterLevel(object oCaster = OBJECT_SELF);

// This will return the location of the spell being cast.
// * Wrapper. It will return the wild magic location if wild magic went awry!
// * This normally returns GetSpellTargetLocation();
location PHS_GetSpellTargetLocation();

// This will return the object the spell is cast at.
// * Wrapper. It will return the wild magic target if wild magic went awry!
// * This normally returns GetSpellTargetObject();
object PHS_GetSpellTargetObject();

// Get the caster level of an AOE (Being OBJECT_SELF). Stores in a local for futher use.
int PHS_GetAOECasterLevel();

// Returns FALSE if there is no AOE creator and the object is destroyed.
// - Only put this ON ENTER and ON HEARTBEAT
int PHS_CheckAOECreator();

// Returns the meta magic feat associated with the spell. Stores in a local for futher use.
int PHS_GetAOEMetaMagic();

// "Used to route the saving throws through this function to check for spell
// countering by a saving throw." - Bioware
// This uses most of the Bioware default commands and things.
// - Uses     SAVING_THROW_WILL, SAVING_THROW_REFLEX, SAVING_THROW_FORT.
// functions: WillSave           ReflexSave           FortitudeSave.
// - This will INCLUDE getting a result 2, IE: Immunity to iSaveType (EG: Mind save)
// - This does NOT include added effect VFX_IMP_DEATH for cirtain spells. Done in spell scripts.
int PHS_SavingThrow(int nSavingThrow, object oTarget, int nDC, int nSaveType = SAVING_THROW_TYPE_NONE, object oSaveVersus = OBJECT_SELF, float fDelay = 0.0);

// Saves against nSavingThrow, using nDC.
// - Uses FortitudeSave, ReflexSave and WillSave.
// - This will NOT include spell resistance (Getting a 2 on the FortitudeSave ETC.)
int PHS_SavingThrowNoResist(int nSavingThrow, object oTarget, int nDC, int nSaveType = SAVING_THROW_TYPE_NONE, object oSaveVersus = OBJECT_SELF, float fDelay = 0.0);

// Monster non-spell ability save.
// - Uses     SAVING_THROW_WILL, SAVING_THROW_REFLEX, SAVING_THROW_FORT.
// functions: WillSave           ReflexSave           FortitudeSave.
int PHS_NotSpellSavingThrow(int nSavingThrow, object oTarget, int nDC, int nSaveType = SAVING_THROW_TYPE_NONE, object oSaveVersus = OBJECT_SELF, float fDelay = 0.0);

// Wrapper for GetReflexAdjustedDamage.
// Use this in spell scripts to get nDamage adjusted by oTarget's reflex and
// evasion saves.
// - nDamage
// - oTarget
// - nDC: Difficulty check
// - nSaveType: SAVING_THROW_TYPE_*
int PHS_GetReflexAdjustedDamage(int nDamage, object oTarget, int nDC, int nSaveType=SAVING_THROW_TYPE_NONE, object oSaveVersus=OBJECT_SELF);

// This will return a damage amount.
// - If oTarget is not a creature, it will half nDamage (can be 0).
// - This is used to be closer to PHB - all elemental damage only does half to non-creatures.
// - It also removes an amout set to PHS_ELEMENTAL_RESISTANCE, if oTarget has any.
int PHS_GetElementalDamage(int nDamage, object oTarget);

// Checks GetIsImmune(oTarget, nImmunityType), and will apply a special visual
// if TRUE.
// * If TRUE, immune to nImmunityType.
int PHS_ImmunityCheck(object oTarget, int nImmunityType, float fDelay = 0.0);

// Required for spell saves. If they haven't got the diamond, the spell is lost
void PHS_RemoveProtectionSpellEffects(object oTarget)
{
    effect eCheck = GetFirstEffect(oTarget);
    while(GetIsEffectValid(eCheck))
    {
        // Check spell
        if(GetEffectSpellId(eCheck) == PHS_SPELL_PROTECTION_FROM_SPELLS)
        {
            RemoveEffect(oTarget, eCheck);
        }
    }
}

// Returns the spell's Save DC, mainly using GetSpellSaveDC()
// (10 + spell level + relevant ability bonus).
int PHS_GetSpellSaveDC()
{
    return GetSpellSaveDC();
}

// Returns the caster level of oCaster, commonly OBJECT_SELF.
// - Wrappered so it can be changed at any time
int PHS_GetCasterLevel(object oCaster = OBJECT_SELF)
{
    int iReturn = GetCasterLevel(oCaster);
    // Error checking
    if(iReturn < 0)
    {
        iReturn = 1;
    }
    // If we have Death Knell, we get +1 effective caster level!
    if(GetHasSpellEffect(PHS_SPELL_DEATH_KNELL, oCaster))
    {
        iReturn++;
    }
    return iReturn;
}

// This will return the location of the spell being cast.
// * Wrapper. It will return the wild magic location if wild magic went awry!
// * This normally returns GetSpellTargetLocation();
location PHS_GetSpellTargetLocation()
{
    // Wild magic override
    if(GetLocalInt(OBJECT_SELF, PHS_WILD_MAGIC_CHECK))
    {
        DeleteLocalInt(OBJECT_SELF, PHS_WILD_MAGIC_CHECK);
        return GetLocalLocation(OBJECT_SELF, PHS_WILD_MAGIC_OVERRIDE_THING);
    }
    return GetSpellTargetLocation();
}

// This will return the object the spell is cast at.
// * Wrapper. It will return the wild magic target if wild magic went awry!
// * This normally returns GetSpellTargetObject();
object PHS_GetSpellTargetObject()
{
    // Wild magic override
    if(GetLocalInt(OBJECT_SELF, PHS_WILD_MAGIC_CHECK))
    {
        DeleteLocalInt(OBJECT_SELF, PHS_WILD_MAGIC_CHECK);
        return GetLocalObject(OBJECT_SELF, PHS_WILD_MAGIC_OVERRIDE_THING);
    }
    return GetSpellTargetObject();
}

// Get the caster level of an AOE (Being OBJECT_SELF). Stores in a local for futher use.
int PHS_GetAOECasterLevel()
{
    // Check for previous values
    int iLevel = GetLocalInt(OBJECT_SELF, PHS_AOE_CASTER_LEVEL);
    if(iLevel >= 1)
    {
        // Stop and return
        return iLevel;
    }
    // Else get it - first time
    // Get the creator of OBJECT_SELF - the AOE
    object oCreator = GetAreaOfEffectCreator();

    // If it is a placeable, the caster level is going to be special
    if(GetObjectType(oCreator) != OBJECT_TYPE_CREATURE)
    {
        // Get the caster level
        iLevel = GetCasterLevel(oCreator);
    }
    else
    {
        // Get the caster level
        iLevel = GetCasterLevel(oCreator);
    }

    // Make sure it is not 0 (Placeable casting maybe)
    if(iLevel < 1)
    {
        iLevel = 1;
    }

    // Set the local, and return the value
    SetLocalInt(OBJECT_SELF, PHS_AOE_CASTER_LEVEL, iLevel);

    // Return value
    return iLevel;
}

// Get the spell save DC of an AOE (Being OBJECT_SELF). Stores in a local for futher use.
int PHS_GetAOESpellSaveDC()
{
    // Check for previous values
    int iDC = GetLocalInt(OBJECT_SELF, PHS_AOE_SPELL_SAVE_DC);
    if(iDC >= 1)
    {
        // Stop and return
        return iDC;
    }
    // Else get it - first time
    // Get the creator of OBJECT_SELF - the AOE
    object oCreator = GetAreaOfEffectCreator();

    // If it is a placeable, the caster level is going to be special
    if(GetObjectType(oCreator) != OBJECT_TYPE_CREATURE)
    {
        // Get the save DC
        iDC = GetSpellSaveDC();
    }
    else
    {
        // Get the save DC
        iDC = GetSpellSaveDC();
    }

    // Make sure it is not 0 (Placeable casting maybe)
    if(iDC < 1)
    {
        iDC = 1;
    }

    // Set the local, and return the value
    SetLocalInt(OBJECT_SELF, PHS_AOE_SPELL_SAVE_DC, iDC);

    // Return value
    return iDC;
}

// Returns the meta magic feat associated with the spell. Stores in a local for futher use.
int PHS_GetAOEMetaMagic()
{
    // Check for previous values
    int iMeta = GetLocalInt(OBJECT_SELF, PHS_AOE_SPELL_METAMAGIC);
    if(iMeta >= 1)
    {
        // Stop and return
        return iMeta;
    }

    // Get metamagic
    iMeta = GetMetaMagicFeat();

    // If it is 0, we set it to 99, an invalid metamagic number, so the local sets.
    if(iMeta < 1)
    {
        iMeta = 99;// 99 is not a valid metamagic, but
    }

    // Set the local, and return the value
    SetLocalInt(OBJECT_SELF, PHS_AOE_SPELL_METAMAGIC, iMeta);

    // Return value
    return iMeta;
}

// Returns FALSE if there is no AOE creator and the object is destroyed.
int PHS_CheckAOECreator()
{
    if(!GetIsObjectValid(GetAreaOfEffectCreator()))
    {
        DestroyObject(OBJECT_SELF);
        return FALSE;
    }
    return TRUE;
}

// "Used to route the saving throws through this function to check for spell
// countering by a saving throw." - Bioware
// This uses most of the Bioware default commands and things.
// - Uses FortitudeSave, ReflexSave and WillSave.
// - This will INCLUDE spell resistance (Getting a 2 on the functions above)
// - This does NOT include added effect VFX_IMP_DEATH for cirtain spells. Done in spell scripts.
int PHS_SavingThrow(int nSavingThrow, object oTarget, int nDC, int nSaveType = SAVING_THROW_TYPE_NONE, object oSaveVersus = OBJECT_SELF, float fDelay = 0.0)
{
    // Change the DC based on spell effects, and spell-resisting things.
    int nNewDC = nDC;

    // Hardiness VS spells is +2 VS all SPELLS ONLY.
    if(GetHasFeat(FEAT_HARDINESS_VERSUS_SPELLS, oTarget))
    {
        nNewDC -= 2;
    }
    // Protection VS spells is +8 VS all SPELLS ONLY.
    if(GetHasSpellEffect(PHS_SPELL_PROTECTION_FROM_SPELLS, oTarget))
    {
        // Check item
        if(GetIsObjectValid(GetLocalObject(oTarget, PHS_STORED_PROT_SPELLS_ITEM)))
        {
            nNewDC -= 8;
        }
        else
        {
            // Remove effects of the spell
            PHS_RemoveProtectionSpellEffects(oTarget);
        }
    }
    // Spellcraft adds +1 VS spells, per 5 ranks in the craft
    nNewDC -= GetSkillRank(SKILL_SPELLCRAFT, oTarget) / 5;

    // Declare things
    effect eVis;
    int bValid = FALSE;
    // Fortitude saving throw
    if(nSavingThrow == SAVING_THROW_FORT)
    {
        bValid = FortitudeSave(oTarget, nNewDC, nSaveType, oSaveVersus);
        if(bValid == 1)
        {
            eVis = EffectVisualEffect(VFX_IMP_FORTITUDE_SAVING_THROW_USE);
        }
    }
    // Reflex saving throw
    else if(nSavingThrow == SAVING_THROW_REFLEX)
    {
        bValid = ReflexSave(oTarget, nNewDC, nSaveType, oSaveVersus);
        if(bValid == 1)
        {
            eVis = EffectVisualEffect(VFX_IMP_REFLEX_SAVE_THROW_USE);
        }
    }
    // Will saving throw
    else if(nSavingThrow == SAVING_THROW_WILL)
    {
        bValid = WillSave(oTarget, nNewDC, nSaveType, oSaveVersus);
        if(bValid == 1)
        {
            eVis = EffectVisualEffect(VFX_IMP_WILL_SAVING_THROW_USE);
        }
    }
    /* No error checking (keeps it fast) we'd know anyway of errors!

       Finally:
        return 0 = FAILED SAVE
        return 1 = SAVE SUCCESSFUL
        return 2 = IMMUNE TO WHAT WAS BEING SAVED AGAINST
    */

    // Spell immunity/resistance to save. (EG: Mind spell save type, immunity to mind spells)
    if(bValid == 2)
    {
        eVis = EffectVisualEffect(VFX_IMP_MAGIC_RESISTANCE_USE);
    }
    // If we save OR have immunity...
    if(bValid == 1 || bValid == 2)
    {
        if(bValid == 2)
        {
        /*  Bioware -
        If the spell is save immune then the link must be applied in order to get
        the true immunity to be resisted.  That is the reason for returing false
        and not true.  True blocks the application of effects.

        Me - This makes VERY little sense...not sure...Need testing.
        */
            bValid = FALSE;
        }
        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
    }
    return bValid;
}

// Saves against nSavingThrow, using nDC.
// - Uses FortitudeSave, ReflexSave and WillSave.
// - This will NOT include spell resistance (Getting a 2 on the functions above)
int PHS_SavingThrowNoResist(int nSavingThrow, object oTarget, int nDC, int nSaveType = SAVING_THROW_TYPE_NONE, object oSaveVersus = OBJECT_SELF, float fDelay = 0.0)
{
    // Change the DC based on spell effects, and spell-resisting things.
    int nNewDC = nDC;

    // Hardiness VS spells is +2 VS all SPELLS ONLY.
    if(GetHasFeat(FEAT_HARDINESS_VERSUS_SPELLS, oTarget))
    {
        nNewDC -= 2;
    }
    // Protection VS spells is +8 VS all SPELLS ONLY.
    if(GetHasSpellEffect(PHS_SPELL_PROTECTION_FROM_SPELLS, oTarget))
    {
        // Check item
        if(GetIsObjectValid(GetLocalObject(oTarget, PHS_STORED_PROT_SPELLS_ITEM)))
        {
            nNewDC -= 8;
        }
        else
        {
            // Remove effects of the spell
            PHS_RemoveProtectionSpellEffects(oTarget);
        }
    }
    // Spellcraft adds +1 VS spells, per 5 ranks in the craft
    nNewDC -= GetSkillRank(SKILL_SPELLCRAFT, oTarget) / 5;

    // Declare things
    effect eVis;
    int bValid = FALSE;
    // Fortitude saving throw
    if(nSavingThrow == SAVING_THROW_FORT)
    {
        bValid = FortitudeSave(oTarget, nNewDC, nSaveType, oSaveVersus);
        if(bValid == 1)
        {
            eVis = EffectVisualEffect(VFX_IMP_FORTITUDE_SAVING_THROW_USE);
        }
    }
    // Reflex saving throw
    else if(nSavingThrow == SAVING_THROW_REFLEX)
    {
        bValid = ReflexSave(oTarget, nNewDC, nSaveType, oSaveVersus);
        if(bValid == 1)
        {
            eVis = EffectVisualEffect(VFX_IMP_REFLEX_SAVE_THROW_USE);
        }
    }
    // Will saving throw
    else if(nSavingThrow == SAVING_THROW_WILL)
    {
        bValid = WillSave(oTarget, nNewDC, nSaveType, oSaveVersus);
        if(bValid == 1)
        {
            eVis = EffectVisualEffect(VFX_IMP_WILL_SAVING_THROW_USE);
        }
    }
    /* No error checking (keeps it fast) we'd know anyway of errors!

       Finally:
        return 0 = FAILED SAVE
        return 1 = SAVE SUCCESSFUL
        return 2 = IMMUNE TO WHAT WAS BEING SAVED AGAINST

        We ignore 2, and say it is 0.
    */
    // If 2, ignore
    if(bValid == 2)
    {
        bValid == 0;
    }
    // If we save, apply save effect.
    else if(bValid == 1)
    {
        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
    }
    return bValid;
}

// Monster non-spell ability save.
// - Uses     SAVING_THROW_WILL, SAVING_THROW_REFLEX, SAVING_THROW_FORT.
// functions: WillSave           ReflexSave           FortitudeSave.
int PHS_NotSpellSavingThrow(int nSavingThrow, object oTarget, int nDC, int nSaveType = SAVING_THROW_TYPE_NONE, object oSaveVersus = OBJECT_SELF, float fDelay = 0.0)
{
    // This does not decrease the save if there are things like Protection from
    // Spells.
    // Declare things
    effect eVis;
    int bValid = FALSE;
    // Fortitude saving throw
    if(nSavingThrow == SAVING_THROW_FORT)
    {
        bValid = FortitudeSave(oTarget, nDC, nSaveType, oSaveVersus);
        if(bValid == 1)
        {
            eVis = EffectVisualEffect(VFX_IMP_FORTITUDE_SAVING_THROW_USE);
        }
    }
    // Reflex saving throw
    else if(nSavingThrow == SAVING_THROW_REFLEX)
    {
        bValid = ReflexSave(oTarget, nDC, nSaveType, oSaveVersus);
        if(bValid == 1)
        {
            eVis = EffectVisualEffect(VFX_IMP_REFLEX_SAVE_THROW_USE);
        }
    }
    // Will saving throw
    else if(nSavingThrow == SAVING_THROW_WILL)
    {
        bValid = WillSave(oTarget, nDC, nSaveType, oSaveVersus);
        if(bValid == 1)
        {
            eVis = EffectVisualEffect(VFX_IMP_WILL_SAVING_THROW_USE);
        }
    }
    /* No error checking (keeps it fast) we'd know anyway of errors!

       Finally:
        return 0 = FAILED SAVE
        return 1 = SAVE SUCCESSFUL
        return 2 = IMMUNE TO WHAT WAS BEING SAVED AGAINST

        We ignore 2, and say it is 0.
    */
    // If 2, ignore
    if(bValid == 2)
    {
        bValid == 0;
    }
    // If we save, apply save effect.
    else if(bValid == 1)
    {
        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
    }
    return bValid;
}

// Wrapper for GetReflexAdjustedDamage.
// Use this in spell scripts to get nDamage adjusted by oTarget's reflex and
// evasion saves.
// - nDamage
// - oTarget
// - nDC: Difficulty check
// - nSaveType: SAVING_THROW_TYPE_*
// - oSaveVersus
int PHS_GetReflexAdjustedDamage(int nDamage, object oTarget, int nDC, int nSaveType=SAVING_THROW_TYPE_NONE, object oSaveVersus=OBJECT_SELF)
{
    // Default for now
    int iReturn = GetReflexAdjustedDamage(nDamage, oTarget, nDC, nSaveType, oSaveVersus);

    return iReturn;
}

// This will return a damage amount.
// - If oTarget is not a creature, it will half nDamage (can be 0).
// - This is used to be closer to PHB - all elemental damage only does half to non-creatures.
// - It also removes an amout set to PHS_ELEMENTAL_RESISTANCE, if oTarget has any.
int PHS_GetElementalDamage(int nDamage, object oTarget)
{
    int iReturn = nDamage;

    if(GetObjectType(oTarget) != OBJECT_TYPE_CREATURE)
    {
        iReturn /= 2;
    }
    // It also gets rid of X amount - hardyness to elemental damage.
    // - Set to PHS_ELEMENTAL_RESISTANCE
    iReturn -= GetLocalInt(oTarget, "PHS_ELEMENTAL_RESISTANCE");

    return iReturn;
}

// Checks GetIsImmune(oTarget, nImmunityType), and will apply a special visual
// if TRUE.
// * If TRUE, immune to nImmunityType.
int PHS_ImmunityCheck(object oTarget, int nImmunityType, float fDelay = 0.0)
{
    if(GetIsImmune(oTarget, nImmunityType))
    {
        // Visual on save
        effect eVis = EffectVisualEffect(VFX_IMP_MAGIC_RESISTANCE_USE);
        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
        return TRUE;
    }
    return FALSE;
}
