///////////////////////////////////////////////////////////////////////////
//
// Include file for common spell definitions.
//
//
// Functions for time that are missing from BioWare's code, to be used for
// spell durations.
//
// float MinutesToSeconds(int minutes);
// float TenMinutesToSeconds(int tenMinutes);
//
// Numerous wrappers for bioware functions are provided and should be
// called in place of the bioware functions; these hooks provide
// support for the PRC class scripts.  Below is a list of the new
// functions, see their comments for exact descriptions.
//
//  int SPResistSpell(object oCaster, object oTarget, float fDelay = 0.0)
//  int SPGetSpellSaveDC(object oCaster = OBJECT_SELF)
//  void SPApplyEffectToObject(int nDurationType, effect eEffect, object oTarget, float fDuration = 0.0f,
//      int bDispellable = TRUE, int nSpellID = -1, int nCasterLevel = -1, object oCaster = OBJECT_SELF)
//  void SPRaiseSpellCastAt(object oTarget, int bHostile = TRUE, int nSpellID = -1, object oCaster = OBJECT_SELF)
//
// Functions that have no direct bioware equivalent, but allow for hooks into the spell code.
//
//  int SPGetElementalDamageType(int nDamageType, object oCaster = OBJECT_SELF)
//  void SPSetSchool(int nSchool = SPELL_SCHOOL_GENERAL)
//
// Functions that manipulate metamagic, these have no direct bioware equivalents, but should be called
// instead of GetMetaMagic() and checking flags.
//
//  int SPGetMetaMagic()
//  int SPGetMetaMagicDamage(int nDamageType, int nDice, int nDieSize,
//      int nBonusPerDie = 0, int nBonus = 0, int nMetaMagic = -1)
//  float SPGetMetaMagicDuration(float fDuration, int nMetaMagic = -1)
//
// Functions to return effects, use any here instead of standard EffectXXX() functions.
//
//  effect SPEffectDamage(int nDamageAmount, int nDamageType = DAMAGE_TYPE_MAGICAL,
//      int nDamagePower = DAMAGE_POWER_NORMAL)
//  effect SPEffectDamageShield(int nDamageAmount, int nRandomAmount, int nDamageType)
//  effect SPEffectHeal(int nAmountToHeal)
//  effect SPEffectTemporaryHitpoints(int nHitPoints)
//
// Must be called for all spell effects.  Takes into account passing the extra spell information
// required by the PRC apply effect function, trying to keep this as transparent as possible to
// the spell scripts.
//      nDurationType - DURATION_TYPE_xxx constant for the duration type.
//      eEffect - effect to apply
//      oTarget - object to apply the effect on.
//      fDuration - duration of the effect, only used for some duration types.
//      bDispellable - flag to indicate whether spell is dispellable or not, default TRUE.
//      nSpellID - ID of spell being cast, if -1 GetSpellId() is used.
//      nCasterLevel - effective caster level, if -1 GetCasterLevel() is used.
//      oCaster - caster object.

//void SPApplyEffectToObject(int nDurationType, effect eEffect, object oTarget, float fDuration = 0.0f,
//    int bDispellable = TRUE, int nSpellID = -1, int nCasterLevel = -1, object oCaster = OBJECT_SELF);

///////////////////////////////////////////////////////////////////////////

#include "X2_I0_SPELLS"
#include "x2_inc_spellhook"
#include "prc_alterations"
#include "prc_inc_spells"


// Coding issues with this one, need a collection of targets for napalm effect.
const int SPELL_LIQUID_FIRE                 = 0;

//const int SPELL_



//
// Time duration methods that are missing from BioWare's code, to do
// minute / level and 10 minute / level spells in scaled time.
//

float MinutesToSeconds(int minutes)
{
    return TurnsToSeconds(minutes);
/*
    // Use HoursToSeconds to figure out how long a scaled minute
    // is and then calculate the number of real seconds based
    // on that.
    float scaledMinute = HoursToSeconds(1) / 60.0;
    float totalMinutes = minutes * scaledMinute;

    // Return our scaled duration, but before doing so check to make sure
    // that it is at least as long as a round / level (time scale is in
    // the module properties, it's possible a minute / level could last less
    // time than a round / level !, so make sure they get at least as much
    // time as a round / level.
    float totalRounds = RoundsToSeconds(minutes);
    float result = totalMinutes > totalRounds ? totalMinutes : totalRounds;
    return result;
*/
}

float TenMinutesToSeconds(int tenMinutes)
{
    return TurnsToSeconds(tenMinutes) * 10;
/*
    // Use HoursToSeconds to figure out how long a scaled 10 minute
    // duration is and then calculate the number of real seconds based
    // on that.
    float scaledMinute = HoursToSeconds(1) / 6.0;
    float totalMinutes = tenMinutes * scaledMinute;

    // Return our scaled duration, but before doing so check to make sure
    // that it is at least as long as a round / level (time scale is in
    // the module properties, it's possible a 10 minute / level could last less
    // time than a round / level !, so make sure they get at least as much
    // time as a round / level.
    float totalRounds = RoundsToSeconds(tenMinutes);
    float result = totalMinutes > totalRounds ? totalMinutes : totalRounds;
    return result;
*/
}



//
// Wrappers for the PRC stuff in prc_alterations.nss, to keep my scripts somewhat isolated
// just in case it needs to get ripped out or changed.
//

// New function for SR checks to take PRC levels into account.
//      oCaster - caster object.
//      oTargret - target object.
//      fDelay - delay before visual effect is played.
//      automaticCleanup - TRUE if PRCResistSpellEnd() should be called via
//      DelayCommand(), FALSE if the spell script will do it.
int SPResistSpell(object oCaster, object oTarget,int nCasterLevel = 0, float fDelay = 0.0 )
{
//  return MyResistSpell(oCaster, oTarget, fDelay);
    int result = MyPRCResistSpell(oCaster, oTarget,nCasterLevel, fDelay);
    return result;
}

// New function for adjusted save DC's. Seems like this needs more than the caster
// for things like elemental savant. (need spell damage type?)
//      oCaster - caster object.
int SPGetSpellSaveDC(object oTarget , object oCaster )
{
//  return GetSpellSaveDC();
    return GetSpellSaveDC() + GetChangesToSaveDC(oTarget,oCaster);
}

// Get altered damage type for energy sub feats and classes.
//      nDamageType - The DAMAGE_TYPE_xxx constant of the damage. All types other
//          than elemental damage types are ignored.
//      oCaster - caster object.
int SPGetElementalDamageType(int nDamageType, object oCaster = OBJECT_SELF);
int SPGetElementalDamageType(int nDamageType, object oCaster = OBJECT_SELF)
{
    // Only apply change to elemental damages.
    //int nOldDamageType = nDamageType;
    switch (nDamageType)
    {
    case DAMAGE_TYPE_ACID:
    case DAMAGE_TYPE_COLD:
    case DAMAGE_TYPE_ELECTRICAL:
    case DAMAGE_TYPE_FIRE:
    case DAMAGE_TYPE_SONIC:           nDamageType = (GetLevelByClass(CLASS_TYPE_ES_FIRE, oCaster) > 0 || GetLevelByClass(CLASS_TYPE_DIVESF, oCaster) > 0) ? DAMAGE_TYPE_FIRE :
                                                    (GetLevelByClass(CLASS_TYPE_ES_COLD, oCaster) > 0 || GetLevelByClass(CLASS_TYPE_DIVESC, oCaster) > 0) ? DAMAGE_TYPE_COLD :
                                                    (GetLevelByClass(CLASS_TYPE_ES_ELEC, oCaster) > 0 || GetLevelByClass(CLASS_TYPE_DIVESE, oCaster) > 0) ? DAMAGE_TYPE_ELECTRICAL :
                                                    (GetLevelByClass(CLASS_TYPE_ES_ACID, oCaster) > 0 || GetLevelByClass(CLASS_TYPE_DIVESA, oCaster) > 0) ? DAMAGE_TYPE_ACID :
                                                    ChangedElementalDamage(oCaster, nDamageType); //Mastery of Elements - Archmage
    }

    return nDamageType;
}

// Get altered damage type for energy sub feats and classes.
//      nSavingThrowType - The SAVING_THROW_TYPE_xxx constant of the damage. All types other
//          than elemental damage types are ignored.
//      oCaster - caster object.
int SPGetElementalSavingThrowType(int nSavingThrowType, object oCaster = OBJECT_SELF);
int SPGetElementalSavingThrowType(int nSavingThrowType, object oCaster = OBJECT_SELF)
{
    // Only apply change to elemental damages.
    //int nOldDamageType = nDamageType;
    switch (nSavingThrowType)
    {
    case SAVING_THROW_TYPE_ACID:
    case SAVING_THROW_TYPE_COLD:
    case SAVING_THROW_TYPE_ELECTRICITY:
    case SAVING_THROW_TYPE_FIRE:
    case SAVING_THROW_TYPE_SONIC:      nSavingThrowType = (GetLevelByClass(CLASS_TYPE_ES_FIRE, oCaster) > 0 || GetLevelByClass(CLASS_TYPE_DIVESF, oCaster) > 0) ? SAVING_THROW_TYPE_FIRE :
                                                    (GetLevelByClass(CLASS_TYPE_ES_COLD, oCaster) > 0 || GetLevelByClass(CLASS_TYPE_DIVESC, oCaster) > 0) ? SAVING_THROW_TYPE_COLD :
                                                    (GetLevelByClass(CLASS_TYPE_ES_ELEC, oCaster) > 0 || GetLevelByClass(CLASS_TYPE_DIVESE, oCaster) > 0) ? SAVING_THROW_TYPE_ELECTRICITY :
                                                    (GetLevelByClass(CLASS_TYPE_DIVESA, oCaster) > 0 || GetLevelByClass(CLASS_TYPE_ES_ACID, oCaster) > 0) ? SAVING_THROW_TYPE_ACID :
                                                    ChangedElementalSavingThrow(oCaster, nSavingThrowType); //Mastery of Elements - Archmage
    }

    return nSavingThrowType;
}

// Must be called for all spell effects.  Takes into account passing the extra spell information
// required by the PRC apply effect function, trying to keep this as transparent as possible to
// the spell scripts.
//      nDurationType - DURATION_TYPE_xxx constant for the duration type.
//      eEffect - effect to apply
//      oTarget - object to apply the effect on.
//      fDuration - duration of the effect, only used for some duration types.
//      bDispellable - flag to indicate whether spell is dispellable or not, default TRUE.
//      nSpellID - ID of spell being cast, if -1 GetSpellId() is used.
//      nCasterLevel - effective caster level, if -1 GetCasterLevel() is used.
//      oCaster - caster object.

/*void SPApplyEffectToObject(int nDurationType, effect eEffect, object oTarget, float fDuration = 0.0f,
    int bDispellable = TRUE, int nSpellID = -1, int nCasterLevel = -1, object oCaster = OBJECT_SELF)
{
    // PRC pack does not use version 2.0 of Bumpkin's PRC script package, so there is no
    // PRCApplyEffectToObject() method.  So just call the bioware default.
    ApplyEffectToObject(nDurationType, eEffect, oTarget, fDuration);

    // Instant duration effects can use BioWare code, the PRC code doesn't care about those, as
    // well as any non-dispellable effect.
    if (DURATION_TYPE_INSTANT == nDurationType || !bDispellable)
    {
        ApplyEffectToObject(nDurationType, eEffect, oTarget, fDuration);
    }
    else
    {
//      ApplyEffectToObject(nDurationType, eEffect, oTarget, fDuration);
        // We need the extra arguments for the PRC code, get them if defaults were passed in.
        if (-1 == nSpellID) nSpellID = GetSpellId();
        if (-1 == nCasterLevel) nCasterLevel = PRCGetCasterLevel(oCaster);

        // Invoke the PRC apply function passing the extra data.
        PRCApplyEffectToObject(nSpellID, nCasterLevel, oCaster, nDurationType, eEffect, oTarget, fDuration);
    }

} */


// This function gets the meta magic int value
int SPGetMetaMagic()
{
    // Get the meta magic value from the engine then let the PRC code override.
    int nMetaMagic = GetMetaMagicFeat();
    // PRC pack does not use version 2.0 of Bumpkin's PRC script package, so there is no
    // PRCGetMetamagic() method.  So just call the bioware default.
    //nMetaMagic = PRCGetMetamagic(nMetaMagic);
    return nMetaMagic;
}

// This function rolls damage and applies metamagic feats to the damage.
//      nDamageType - The DAMAGE_TYPE_xxx constant for the damage, or -1 for no
//          a non-damaging effect.
//      nDice - number of dice to roll.
//      nDieSize - size of dice, i.e. d4, d6, d8, etc.
//      nBonusPerDie - Amount of bonus damage per die.
//      nBonus - Amount of overall bonus damage.
//      nMetaMagic - metamagic constant, if -1 GetMetaMagic() is called.
//      returns - the damage rolled with metamagic applied.
int SPGetMetaMagicDamage(int nDamageType, int nDice, int nDieSize,
    int nBonusPerDie = 0, int nBonus = 0, int nMetaMagic = -1)
{
    // If the metamagic argument wasn't given get it.
    if (-1 == nMetaMagic) nMetaMagic = SPGetMetaMagic();

    // Roll the damage, applying metamagic.
    int nDamage = MaximizeOrEmpower(nDieSize, nDice, nMetaMagic, (nBonusPerDie * nDice) + nBonus);
    return nDamage;
}

// This function applies metamagic to a spell's duration, returning the new duration.
//      fDuration - the spell's normal duration.
//      nMetaMagic - metamagic constant, if -1 GetMetaMagic() is called.
float SPGetMetaMagicDuration(float fDuration, int nMetaMagic = -1)
{
    // If the metamagic argument wasn't given get it.
    if (-1 == nMetaMagic) nMetaMagic = SPGetMetaMagic();

    // Apply extend metamagic.
    if (nMetaMagic == METAMAGIC_EXTEND) fDuration *= 2.0;
    return fDuration;
}

// Function to save the school of the currently cast spell in a variable.  This should be
// called at the beginning of the script to set the spell school (passing the school) and
// once at the end of the script (with no arguments) to delete the variable.
//  nSchool - SPELL_SCHOOL_xxx constant to set, if general then the variable is
//      deleted.
void SPSetSchool(int nSchool = SPELL_SCHOOL_GENERAL)
{
    // Remove the last value in case it is there and set the new value if it is NOT general.
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    if (SPELL_SCHOOL_GENERAL != nSchool)
        SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", nSchool);
}

// Function to raise the spell cast at event.
//      oTarget - Target of the spell.
//      bHostile - TRUE if the spell is a hostile act.
//      nSpellID - Spell ID or -1 if GetSpellId() should be used.
//      oCaster - Object doing the casting.
void SPRaiseSpellCastAt(object oTarget, int bHostile = TRUE, int nSpellID = -1, object oCaster = OBJECT_SELF)
{
    if (-1 == nSpellID) nSpellID = GetSpellId();

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(oCaster, nSpellID, bHostile));
}


// Function to return a damage effect.
//      nDamageAmount - Amount of damage to apply.
//      nDamageType - DAMAGE_TYPE_xxx for the type of damage.
//      nDamagePower - DAMAGE_POWER_xxx power rating for the damage.
effect SPEffectDamage(int nDamageAmount, int nDamageType = DAMAGE_TYPE_MAGICAL,
    int nDamagePower = DAMAGE_POWER_NORMAL)
{
    return EffectDamage(nDamageAmount, nDamageType, nDamagePower);
    // PRC pack does not use version 2.0 of Bumpkin's PRC script package, so there is no
    // EffectPRCDamage() method.  So just call the bioware default.
    //return EffectPRCDamage(nDamageAmount, nDamageType, nDamagePower);
}


// Function to return damage shield effect
//      nDamageAmount - Amount of damage to apply.
//      nRandomAmount - DAMAGE_BONUS_xxx for amount of random bonus damage to apply.
//      nDamageType - DAMAGE_TYPE_xxx for the type of damage.
effect SPEffectDamageShield(int nDamageAmount, int nRandomAmount, int nDamageType)
{
    return EffectDamageShield(nDamageAmount, nRandomAmount, nDamageType);
    // PRC pack does not use version 2.0 of Bumpkin's PRC script package, so there is no
    // EffectPRCDamageShield() method.  So just call the bioware default.
    //return EffectPRCDamageShield(nDamageAmount, nRandomAmount, nDamageType);
}


// Function to return healing effect
//      nAmountToHeal - Amount of damage to heal.
effect SPEffectHeal(int nAmountToHeal)
{
    return EffectHeal(nAmountToHeal);
    // PRC pack does not use version 2.0 of Bumpkin's PRC script package, so there is no
    // EffectPRCHeal() method.  So just call the bioware default.
    //return EffectPRCHeal(nAmountToHeal);
}

// Function to return temporary hit points effect
//      nHitPoints - Number of temp. hit points.
effect SPEffectTemporaryHitpoints(int nHitPoints)
{
    return EffectTemporaryHitpoints(nHitPoints);
    // PRC pack does not use version 2.0 of Bumpkin's PRC script package, so there is no
    // EffectPRCTemporaryHitpoints() method.  So just call the bioware default.
    //return EffectPRCTemporaryHitpoints(nHitPoints);
}
