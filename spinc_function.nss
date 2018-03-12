/* 
   ----------------
   spinc_function
   ----------------
   
   4/9/05 by Stratovarius
   
   This is a consolidation of all the old spinc_ files into one larger file.
*/

/*
    Commented out Sections: GetCanTeleport in Transpose
*/

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
//      nSpellID - ID of spell being cast, if -1 PRCGetSpellId() is used.
//      nCasterLevel - effective caster level, if -1 GetCasterLevel() is used.
//      oCaster - caster object.

///////////////////////////////////////////////////////////////////////////


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
    return PRCGetSaveDC(oTarget,oCaster);
}

// Get altered damage type for energy sub feats.
//      nDamageType - The DAMAGE_TYPE_xxx constant of the damage. All types other
//          than elemental damage types are ignored.
//      oCaster - caster object.
int SPGetElementalDamageType(int nDamageType, object oCaster = OBJECT_SELF)
{
    // Only apply change to elemental damages.
    int nOldDamageType = nDamageType;
    switch (nDamageType)
    {
    case DAMAGE_TYPE_ACID:
    case DAMAGE_TYPE_COLD:
    case DAMAGE_TYPE_ELECTRICAL:
    case DAMAGE_TYPE_FIRE:
    case DAMAGE_TYPE_SONIC:
        nDamageType = ChangedElementalDamage(oCaster, nDamageType);
    }
    
    return nDamageType;
}

// This function gets the meta magic int value
int SPGetMetaMagic()
{
    // Get the meta magic value from the engine then let the PRC code override.
    int nMetaMagic = PRCGetMetaMagicFeat();
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
    int nDamage = PRCMaximizeOrEmpower(nDieSize, nDice, nMetaMagic, (nBonusPerDie * nDice) + nBonus);
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
    if (nMetaMagic & METAMAGIC_EXTEND) fDuration *= 2.0;
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
//      nSpellID - Spell ID or -1 if PRCGetSpellId() should be used.
//      oCaster - Object doing the casting.
void SPRaiseSpellCastAt(object oTarget, int bHostile = TRUE, int nSpellID = -1, object oCaster = OBJECT_SELF)
{
    if (-1 == nSpellID) nSpellID = PRCGetSpellId();
    
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


/////////////////////////////////////////////////////////////////////////
//
// DoBolt - Function to apply an elemental bolt damage effect given
// the following arguments:
//
//        nDieSize - die size to roll (d4, d6, or d8)
//        nBonusDam - bonus damage per die, or 0 for none
//        nDice = number of dice to roll.
//        nBoltEffect - visual effect to use for bolt(s)
//        nVictimEffect - visual effect to apply to target(s)
//        nDamageType - elemental damage type of the cone (DAMAGE_TYPE_xxx)
//        nSaveType - save type used for cone (SAVING_THROW_TYPE_xxx)
//        nSchool - spell school, defaults to SPELL_SCHOOL_EVOCATION.
//        fDoKnockdown - flag indicating whether spell does knockdown, defaults to FALSE.
//        nSpellID - spell ID to use for events
//
/////////////////////////////////////////////////////////////////////////

void DoBolt(int nCasterLevel, int nDieSize, int nBonusDam, int nDice, int nBoltEffect,
     int nVictimEffect, int nDamageType, int nSaveType, 
     int nSchool = SPELL_SCHOOL_EVOCATION, int fDoKnockdown = FALSE, int nSpellID = -1)
{
     // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
     //if (!X2PreSpellCastCode()) return;
    
     SPSetSchool(nSchool);
     
     // Get the spell ID if it was not given.
     if (-1 == nSpellID) nSpellID = PRCGetSpellId();
     
     // Adjust the damage type of necessary.
     nDamageType = SPGetElementalDamageType(nDamageType, OBJECT_SELF);

    int nDamage;
    
    int nPenetr = nCasterLevel + SPGetPenetr();
    
    // Set the lightning stream to start at the caster's hands
    effect eBolt = EffectBeam(nBoltEffect, OBJECT_SELF, BODY_NODE_HAND);
    effect eVis  = EffectVisualEffect(nVictimEffect);
     effect eKnockdown = EffectKnockdown();
    effect eDamage;
    
    object oTarget = PRCGetSpellTargetObject();
    location lTarget = GetLocation(oTarget);
    object oNextTarget, oTarget2;
    float fDelay;
    int nCnt = 1;
    int fKnockdownTarget = FALSE;
    
    
    
    oTarget2 = GetNearestObject(OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, OBJECT_SELF, nCnt);
    while(GetIsObjectValid(oTarget2) && GetDistanceToObject(oTarget2) <= 30.0)
    {
        //Get first target in the lightning area by passing in the location of first target and the casters vector (position)
        oTarget = GetFirstObjectInShape(SHAPE_SPELLCYLINDER, 30.0, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, GetPosition(OBJECT_SELF));
        while (GetIsObjectValid(oTarget))
        {
               // Reset the knockdown target flag.
               fKnockdownTarget = FALSE;
               
               // Exclude the caster from the damage effects
               if (oTarget != OBJECT_SELF && oTarget2 == oTarget)
               {
               if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
               {
                   //Fire cast spell at event for the specified target
                   SPRaiseSpellCastAt(oTarget, TRUE, nSpellID);
                   
                   //Make an SR check
                   if (!SPResistSpell(OBJECT_SELF, oTarget,nPenetr))
                 {
                    int nSaveDC = PRCGetSaveDC(oTarget,OBJECT_SELF);
                              // Roll damage for each target
                              int nDamage = SPGetMetaMagicDamage(nDamageType, nDice, nDieSize, nBonusDam);
                              
                        //Adjust damage based on Reflex Save, Evasion and Improved Evasion
                        int nFullDamage = nDamage;
                        nDamage += ApplySpellBetrayalStrikeDamage(oTarget, OBJECT_SELF);
                        nDamage = PRCGetReflexAdjustedDamage(nDamage, oTarget, nSaveDC, nSaveType);

                        //Set damage effect
                        eDamage = SPEffectDamage(nDamage, nDamageType);
                        if(nDamage > 0)
                        {
                            // Apply VFX, damage effect and lightning effect
                            //fDelay = GetSpellEffectDelay(GetLocation(oTarget), oTarget);
                            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
                            PRCBonusDamage(oTarget);
                            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                        }

                              // Determine if the target needs to be knocked down.  The target is knocked down
                              // if all of the following criteria are met:
                              //    - Knockdown is enabled.
                              //    - The damage from the spell didn't kill the creature
                              //    - The creature is large or smaller
                              //    - The creature failed it's reflex save.
                              // If the spell does knockdown we need to figure out whether the target made or failed
                              // the reflex save.  If the target doesn't have improved evasion this is easy, if the
                              // damage is the same as the original damage then the target failed it's save.  If the
                              // target has improved evasion then it's harder as the damage is halved even on a failed
                              // save, so we have to catch that case.
                              fKnockdownTarget = fDoKnockdown && !GetIsDead(oTarget) &&
                                   PRCGetCreatureSize(oTarget) <= CREATURE_SIZE_LARGE &&
                                   (nFullDamage == nDamage || (0 != nDamage && GetHasFeat(FEAT_IMPROVED_EVASION, oTarget)));
                         }
                    
                         SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBolt, oTarget, 1.0,FALSE);
                    
                         // If we're supposed to apply knockdown then do so for 1 round.
                         if (fKnockdownTarget)
                              SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnockdown, oTarget, RoundsToSeconds(1),TRUE,-1,nCasterLevel);
                         
                         //Set the currect target as the holder of the lightning effect
                         oNextTarget = oTarget;
                         eBolt = EffectBeam(nBoltEffect, oNextTarget, BODY_NODE_CHEST);
                    }
               }
           
               //Get the next object in the lightning cylinder
               oTarget = GetNextObjectInShape(SHAPE_SPELLCYLINDER, 30.0, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, GetPosition(OBJECT_SELF));
          }
        
          nCnt++;
        oTarget2 = GetNearestObject(OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE, OBJECT_SELF, nCnt);
     }
     
     SPSetSchool();
}

////////////////////////////////////////////////////////////////////////////////////
//
// DoBurst() - Do a damaging burst at the spell's target location.
//        nDieSize - size of die to roll.
//        nBonusDam - bonus damage per die.
//        nDice - number of dice to roll
//        nBurstEffect - VFX_xxx or AOE_xxx of burst vfx.
//        nVictimEffect - VFX_xxx of target impact.
//        nDamageType - DAMAGE_TYPE_xxx of the type of damage dealt
//        nSaveType - SAVING_THROW_xxx of type of save to use
//        bCasterImmune - Indicates whether the caster is immune to the spell
//        nSchool - SPELL_SCHOOL_xxx of the spell's school
//        nSpellID - ID # of the spell, if -1 PRCGetSpellId() is used
//        fAOEDuration - if > 0, then nBurstEffect should be an AOE_xxx vfx, it
//             will be played at the target location for this duration.  If this is
//             0 then nBurstEffect should be a VFX_xxx vfx.
//
////////////////////////////////////////////////////////////////////////////////////

void DoBurst (int nCasterLvl, int nDieSize, int nBonusDam, int nDice, int nBurstEffect, 
     int nVictimEffect, float fRadius, int nDamageType, int nBonusDamageType, int nSaveType,
     int bCasterImmune = FALSE,
     int nSchool = SPELL_SCHOOL_EVOCATION, int nSpellID = -1,
     float fAOEDuration = 0.0f)
{
     SPSetSchool(nSchool);
     
     // Get the spell ID if it was not given.
     if (-1 == nSpellID) nSpellID = PRCGetSpellId();
     
     // Get the spell target location as opposed to the spell target.
     location lTarget = PRCGetSpellTargetLocation();

        int nPenetr = nCasterLvl + SPGetPenetr();
     // Get the effective caster level and hand it to the SR engine.

     
     // Adjust the damage type of necessary, if the damage & bonus damage types are the
     // same we need to copy the adjusted damage type to the bonus damage type.
     int nSameDamageType = nDamageType == nBonusDamageType;
     nDamageType = SPGetElementalDamageType(nDamageType, OBJECT_SELF);
     if (nSameDamageType) nBonusDamageType = nDamageType;
     
     // Apply the specified vfx to the location.  If we were given an aoe vfx then
     // fAOEDuration will be > 0.
     if (fAOEDuration > 0.0)
          ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, 
               EffectAreaOfEffect(nBurstEffect, "****", "****", "****"), lTarget, fAOEDuration);
     else
          ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(nBurstEffect), lTarget);
     
     effect eVis = EffectVisualEffect(nVictimEffect);
     effect eDamage, eBonusDamage;
     float fDelay;
     
     // Declare the spell shape, size and the location.  Capture the first target object in the shape.
     // Cycle through the targets within the spell shape until an invalid object is captured.
     object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
     while (GetIsObjectValid(oTarget))
     {
          // Filter out the caster if he is supposed to be immune to the burst.
          if (!(bCasterImmune && OBJECT_SELF == oTarget))
          {
               if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
               {
                    //Fire cast spell at event for the specified target
                    SPRaiseSpellCastAt(oTarget, TRUE, nSpellID);

                    fDelay = GetSpellEffectDelay(lTarget, oTarget);
                    if (!SPResistSpell(OBJECT_SELF, oTarget,nPenetr, fDelay))
                    {
                         int nSaveDC = PRCGetSaveDC(oTarget, OBJECT_SELF);

                         int nDam = 0;
                         int nDam2 = 0;
                         if (nSameDamageType)
                         {
                              // Damage damage type is the simple case, just get the total damage
                              // of the spell's type, apply metamagic and roll the save.
                              
                              // Roll damage for each target
                              nDam = SPGetMetaMagicDamage(nDamageType, nDice, nDieSize, nBonusDam);
                              nDam += ApplySpellBetrayalStrikeDamage(oTarget, OBJECT_SELF, FALSE);
                                   
                              // Adjust damage for reflex save / evasion / imp evasion
                              nDam = PRCGetReflexAdjustedDamage(nDam, oTarget, nSaveDC, nSaveType);
                         }
                         else
                         {
                              // Damage of different types is a bit more complicated, we need to
                              // calculate the bonus damage ourselves, figure out if the save was
                              // 1/2 or no damage, and apply appropriately to the secondary damage
                              // type.

                              // Calculate base and bonus damage.                              
                              nDam = SPGetMetaMagicDamage(nDamageType, nDice, nDieSize, 0);
                              nDam2 = nDice * nBonusDam;

                              // Adjust damage for reflex save / evasion / imp evasion.  We need to
                              // deal with damage being constant, damage being 0, and damage being
                              // some percentage of the total (should be 1/2).
                              int nAdjustedDam = PRCGetReflexAdjustedDamage(nDam, oTarget, nSaveDC, nSaveType);
                              if (0 == nAdjustedDam)
                              {
                                   // Evasion zero'ed out the damage, clear both damage values.
                                   nDam = 0;
                                   nDam2 = 0;
                              }
                              else if (nAdjustedDam < nDam)
                              {
                                   // Assume 1/2 damage, and half the bonus damage.
                                   nDam = nAdjustedDam;
                                   nDam2 /= 2;
                              }
                         }

                         //Set the damage effect
                         if (nDam > 0)
                         {
                              eDamage = SPEffectDamage(nDam, nDamageType);
                              
                              // Apply effects to the currently selected target.
                              DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
                              PRCBonusDamage(oTarget);
                              
                              // This visual effect is applied to the target object not the location as above.
                              DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                         }

                         // Apply bonus damage if it is a different type.
                         if (nDam2 > 0)
                         {
                              DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, 
                                   SPEffectDamage(nDam2, nBonusDamageType), oTarget));
                         }
                    }
               }
          }
                    
          oTarget = GetNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
     }
     
     // Let the SR engine know that we are done and clear out school local var.

     SPSetSchool();
}


/////////////////////////////////////////////////////////////////////
//
// DoCone - Function to apply an elemental cone damage effect given
// the following arguments:
//
//        nDieSize - die size to roll (d4, d6, or d8)
//        nBonusDam - bonus damage per die, or 0 for none
//        nConeEffect - unused (this is in 2da)
//        nVictimEffect - visual effect to apply to target(s)
//        nDamageType - elemental damage type of the cone (DAMAGE_TYPE_xxx)
//        nSaveType - save type used for cone (SAVE_TYPE_xxx)
//        nSchool - spell school, defaults to SPELL_SCHOOL_EVOCATION
//        nSpellID - spell ID to use for events
//
/////////////////////////////////////////////////////////////////////

void DoCone (int nDieSize, int nBonusDam, int nDieCap, int nConeEffect /* unused */, 
     int nVictimEffect, int nDamageType, int nSaveType,
     int nSchool = SPELL_SCHOOL_EVOCATION, int nSpellID = -1)
{
     SPSetSchool(nSchool);
     
     // Get the spell ID if it was not given.
     if (-1 == nSpellID) nSpellID = PRCGetSpellId();
     
     // Get effective caster level and hand it to the SR engine.  Then
     // cap it at our die cap.
     int nCasterLvl = PRCGetCasterLevel(OBJECT_SELF);
     int nPenetr = nCasterLvl + SPGetPenetr();
     

     if (nCasterLvl > nDieCap) nCasterLvl = nDieCap;
     
     // Figure out where the cone was targetted.
     location lTargetLocation = PRCGetSpellTargetLocation();
     
     // Adjust the damage type of necessary.
     nDamageType = SPGetElementalDamageType(nDamageType, OBJECT_SELF);

     
     
     //Declare major variables
     int nDamage;
     float fDelay;
     object oTarget;

     // Declare the spell shape, size and the location.  Capture the first target object in the shape.
     // Cycle through the targets within the spell shape until an invalid object is captured.
     oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 11.0, lTargetLocation, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
     while(GetIsObjectValid(oTarget))
     {
          if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
          {
               //Fire cast spell at event for the specified target
               SPRaiseSpellCastAt(oTarget, TRUE, nSpellID);
               
               //Get the distance between the target and caster to delay the application of effects
               fDelay = GetSpellEffectDelay(lTargetLocation, oTarget);
               
               //Make SR check, and appropriate saving throw(s).
               if(!SPResistSpell(OBJECT_SELF, oTarget,nPenetr, fDelay) && (oTarget != OBJECT_SELF))
               {
                       int nSaveDC = PRCGetSaveDC(oTarget,OBJECT_SELF);
                    // Roll damage for each target
                    int nDamage = SPGetMetaMagicDamage(nDamageType, nCasterLvl, nDieSize, nBonusDam);
                    nDamage += ApplySpellBetrayalStrikeDamage(oTarget, OBJECT_SELF, FALSE);
                    
                    // Adjust damage according to Reflex Save, Evasion or Improved Evasion
                    nDamage = PRCGetReflexAdjustedDamage(nDamage, oTarget, nSaveDC, nSaveType);

                    // Apply effects to the currently selected target.
                    if(nDamage > 0)
                    {
                         effect eDamage = SPEffectDamage(nDamage, nDamageType);
                         effect eVis = EffectVisualEffect(nVictimEffect);
                         DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                         DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
                         PRCBonusDamage(oTarget);
                    }
               }
          }
          
          //Select the next target within the spell shape.
          oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 11.0, lTargetLocation, FALSE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
     }
     
     // Let the SR engine know that we are done and clear out school local var.

     SPSetSchool();
}

////////////////Begin Greenfire//////////////////////

//
// Returns TRUE if the greenfire heartbeat has fired at least once.
//
int HasHeartbeatFired()
{
     return GetLocalInt(OBJECT_SELF, "SP_GREENFIRE_HBFIRED");
}

//
// Saves the fact that the greenfire heartbeat has fired.
//
void SetHeartbeatFired()
{
     SetLocalInt(OBJECT_SELF, "SP_GREENFIRE_HBFIRED", TRUE);
}

//
// Gets the greenfire spell ID.
//
int GetGreenfireSpellID()
{
     return GetLocalInt(GetAreaOfEffectCreator(), "SP_GREENFIRE_SPELLID");
}

//
// Saves the specified spell ID as the greenfire spell ID.
//
void SetGreenfireSpellID(int nSpellID)
{
     SetLocalInt(OBJECT_SELF, "SP_GREENFIRE_SPELLID", nSpellID);
}


//
// Runs the greenfire spell effect against the specified target for the specified
// caster.
//
void DoGreenfire(int nDamageType, object oCaster, object oTarget)
{
     // Get the spell ID for greenfire, which is stored as a local int on the caster.
     int nSpellID = GetLocalInt(oCaster, "SP_GREENFIRE_SPELLID");

     // Get the amount of bonus damage, based on caster level.
     int nCasterLevel = PRCGetCasterLevel(oCaster);
     int nBonus = nCasterLevel;
     if (nBonus > 10) nBonus = 10;
     
     if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))
     {
          // Fire cast spell at event for the specified target
          SPRaiseSpellCastAt(oTarget, TRUE, nSpellID, oCaster);
          
          int nPenetr = nCasterLevel + SPGetPenetr();

          if (!SPResistSpell(oCaster, oTarget,nPenetr))
          {
               // Roll the damage and let the target make a reflex save if the
               // heartbeat hasn't fired yet, once that happens targets get no save.
               int nDamage = SPGetMetaMagicDamage(nDamageType, 2, 6, 0, nBonus);
               nDamage += ApplySpellBetrayalStrikeDamage(oTarget, OBJECT_SELF);
               if (!HasHeartbeatFired())
                    nDamage = PRCGetReflexAdjustedDamage(nDamage, oTarget, 
                         PRCGetSaveDC(oTarget,oCaster), SAVING_THROW_TYPE_ACID);
                         
               // If we really did damage apply it to the target.
               if (nDamage > 0)
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, 
                         SPEffectDamage(nDamage, nDamageType), oTarget);
          }
     }
}

////////////////End Greenfire//////////////////////

////////////////Begin Lesser Orb//////////////////////

void DoLesserOrb(effect eVis, int nDamageType, int nSpellID = -1)
{
     SPSetSchool(SPELL_SCHOOL_CONJURATION);

     object oTarget = PRCGetSpellTargetObject();
     int nCasterLvl = PRCGetCasterLevel(OBJECT_SELF);
     int nMetaMagic = PRCGetMetaMagicFeat();

     int nDice = (nCasterLvl + 1)/2;
     if (nDice > 5) nDice = 5;

     // Get the spell ID if it was not given.
     if (-1 == nSpellID) nSpellID = GetSpellId();
     
     // Adjust the damage type of necessary.
     nDamageType = SPGetElementalDamageType(nDamageType, OBJECT_SELF);

     if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
     {
          // Fire cast spell at event for the specified target
          SPRaiseSpellCastAt(oTarget, TRUE, nSpellID);

          // Note that this spell has no spell resistance intentionally in the WotC Miniatures
          // Handbook, bit powerful but that's how it is in the PnP book.
          
          // Make touch attack, saving result for possible critical
          int nTouchAttack = PRCDoRangedTouchAttack(oTarget);;
          if (nTouchAttack > 0)
          {
               // Roll the damage, doing double damage on a crit.
               int nDamage = SPGetMetaMagicDamage(nDamageType, 1 == nTouchAttack ? nDice : (nDice * 2), 8);
               nDamage += SpellSneakAttackDamage(OBJECT_SELF, oTarget);
               nDamage += ApplySpellBetrayalStrikeDamage(oTarget, OBJECT_SELF);
               
               // Apply the damage and the damage visible effect to the target.                
               SPApplyEffectToObject(DURATION_TYPE_INSTANT, SPEffectDamage(nDamage, nDamageType), oTarget);
               PRCBonusDamage(oTarget);
               SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
          }
     }
     
     SPSetSchool();
}

////////////////End Lesser Orb//////////////////////

/////////////////////////////////////////////////////////////////////////////////
//
// DoMassBuff - Casts a mass buff spell on the specified target location, buffing
// all friendly creatures within a huge radius.
//      nBuffType - The type of buff to do, one of the MASSBUFF_xxx defines.
//      nSubBuffType - Depends on the value of nBuffType, for stat buffs this
//      is ABILITY_xxx to buff, for vision buffs it's unused.
//      nVfx - The visual effect to apply at cast time.
//      nDurVfx - The visual effect to apply during the spell's duration.
//
/////////////////////////////////////////////////////////////////////////////////

const int MASSBUFF_STAT =           0;
const int MASSBUFF_VISION =         1;

void StripBuff(object oTarget, int nBuffSpellID, int nMassBuffSpellID)
{
    // Loop through all of the effects looking for our stat buff.
    effect eEffect = GetFirstEffect(oTarget);
    while (GetIsEffectValid(eEffect))
    {
        // Get the effect's spell ID and if it is one of the buffs passed in
        // then strip it.
        int nSpellID = GetEffectSpellId(eEffect);
        if (nBuffSpellID == nSpellID || nMassBuffSpellID == nBuffSpellID)
            RemoveEffect(oTarget, eEffect);
            
        // Get the effect.
        eEffect = GetNextEffect(oTarget);
    }
}

void DoMassBuff (int nBuffType, int nBuffSubType, int nBuffSpellID, int nSpellID = -1)
{
    SPSetSchool(SPELL_SCHOOL_TRANSMUTATION);
    
    // Get the spell target location as opposed to the spell target.
    location lTarget = PRCGetSpellTargetLocation();

    // Get the spell ID if it was not given.
    if (-1 == nSpellID) nSpellID = GetSpellId();
    
    // Get the effective caster level.
    int nCasterLvl = PRCGetCasterLevel(OBJECT_SELF);

    // Load the visual effects.
    effect eVis;
    effect eDur;
    switch (nBuffType)
    {
    case MASSBUFF_STAT:
        eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
        eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
        break;
    case MASSBUFF_VISION:
        // No visible effect for this?
        eDur = EffectVisualEffect(VFX_DUR_ULTRAVISION);
        eDur = EffectLinkEffects(eDur, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
        eDur = EffectLinkEffects(eDur, EffectVisualEffect(VFX_DUR_MAGICAL_SIGHT));
        break;
    }

    float fDelay;

    // Determine the spell's duration.
    float fDuration = SPGetMetaMagicDuration(HoursToSeconds(PRCGetCasterLevel(OBJECT_SELF)));
    
    // Declare the spell shape, size and the location.  Capture the first target object in the shape.
    // Cycle through the targets within the spell shape until an invalid object is captured.
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    while (GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, OBJECT_SELF))
//      if (GetIsReactionTypeFriendly(oTarget))
        {
            //Fire cast spell at event for the specified target
            SPRaiseSpellCastAt(oTarget, FALSE);

            fDelay = GetSpellEffectDelay(lTarget, oTarget);

            // Calculate stat mod and adjust for metamagic.         
            int nStatMod = SPGetMetaMagicDamage(-1, 1, 4, 0, 1);

            // Create the appropriate buff effect and link the duration visual fx to it.
            effect eBuff;           
            switch (nBuffType)
            {
            case MASSBUFF_STAT:
                // Strip the regular or mass buff from the target before 
                // applying the new one.
                StripBuff(oTarget, nBuffSpellID, nSpellID);
                
                eBuff = EffectLinkEffects (EffectAbilityIncrease(nBuffSubType, nStatMod), eDur);
                DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBuff, oTarget, fDuration,TRUE,-1,nCasterLvl));
                DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                break;
            case MASSBUFF_VISION:
                eBuff = EffectLinkEffects (EffectUltravision(), eDur);
                DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBuff, oTarget, fDuration,TRUE,-1,nCasterLvl));
                break;
            }
        }
        
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }

    SPSetSchool();
}

/////////////////////////////////////////////////////////////////////////////////
//
// This is a copy of the spellsCure() function from nw_s0_spells.nss, with the
// following changes:
//
//      - modified to accept the target of the spell as an argument 
//      - modified to not do a touch attack to land on undead
//      - modified to return 0 if the target was not effected, 1 if it is
//      - modified the effect arguments to be effect objects rather than ints
//
/////////////////////////////////////////////////////////////////////////////////

int biowareSpellsCure(int nCasterLvl,object oTarget, int nDamage, int nMaxExtraDamage, int nMaximized, effect vfx_impactHurt, effect vfx_impactHeal, int nSpellID)
{
    // NEW CODE
    int nEffected = 0;
    
    //Declare major variables
    // COMMENT OUT BIOWARE CODE
    //object oTarget = PRCGetSpellTargetObject();
    int nHeal;
    int nMetaMagic = PRCGetMetaMagicFeat();
    // CHANGED CODE
    effect eVis = vfx_impactHurt;
    effect eVis2 = vfx_impactHeal;
    //effect eVis = EffectVisualEffect(vfx_impactHurt);
    //effect eVis2 = EffectVisualEffect(vfx_impactHeal);
    effect eHeal, eDam;

    int nExtraDamage = nCasterLvl; // * figure out the bonus damage
    if (nExtraDamage > nMaxExtraDamage)
    {
        nExtraDamage = nMaxExtraDamage;
    }
    // * if low or normal difficulty is treated as MAXIMIZED
    if(GetIsPC(oTarget) && GetGameDifficulty() < GAME_DIFFICULTY_CORE_RULES)
    {
        nDamage = nMaximized + nExtraDamage;
    }
    else
    {
        nDamage = nDamage + nExtraDamage;
    }


    //Make metamagic checks
    int iBlastFaith = BlastInfidelOrFaithHeal(OBJECT_SELF, oTarget, DAMAGE_TYPE_POSITIVE, TRUE);
    if((nMetaMagic & METAMAGIC_MAXIMIZE) || iBlastFaith)
    {
        nDamage = nMaximized + nExtraDamage;
        // * if low or normal difficulty then MAXMIZED is doubled.
        if(GetIsPC(OBJECT_SELF) && GetGameDifficulty() < GAME_DIFFICULTY_CORE_RULES)
        {
            nDamage = nDamage + nExtraDamage;
        }
    }
    if((nMetaMagic & METAMAGIC_EMPOWER) || GetHasFeat(FEAT_HEALING_DOMAIN_POWER))
    {
        nDamage = nDamage + (nDamage/2);
    }

    // The caster is the one who called the script, so OBJECT_SELF should work
    // Applies the Augment Healing feat, which adds 2 points of healing per spell level.
    if (GetHasFeat(FEAT_AUGMENT_HEALING, OBJECT_SELF)) nDamage += (StringToInt(lookup_spell_cleric_level(PRCGetSpellId())) * 2);

    if (MyPRCGetRacialType(oTarget) != RACIAL_TYPE_UNDEAD)
    {
        // NEW CODE
        // Add target check since we only want this to land on friendly targets and
        // it's not targetted.
        if (spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, OBJECT_SELF))
        {
            // NEW CODE
            nEffected = 1;
            
            //Figure out the amount of damage to heal
            nHeal = nDamage;
            //Set the heal effect
            eHeal = EffectHeal(nHeal);
            //Apply heal effect and VFX impact
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget);
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
            //Fire cast spell at event for the specified target
            SPRaiseSpellCastAt(oTarget, FALSE, nSpellID);
        }
    }
    //Check that the target is undead
    else
    {
        // COMMENT OUT BIOWARE CODE
        int nTouch = 1;
        //int nTouch = PRCDoMeleeTouchAttack(oTarget);;
        if (nTouch > 0)
        {
            if(!GetIsReactionTypeFriendly(oTarget))
            {
                // NEW CODE
                nEffected = 1;
            
                //Fire cast spell at event for the specified target
                SPRaiseSpellCastAt(oTarget, TRUE, nSpellID);
                if (!SPResistSpell(OBJECT_SELF, oTarget,nCasterLvl+SPGetPenetr()))
                {
                    eDam = SPEffectDamage(nDamage,DAMAGE_TYPE_NEGATIVE);
                    //Apply the VFX impact and effects
                    DelayCommand(1.0, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                }
            }
        }
    }
    
    
    // NEW CODE
    return nEffected;
}

/////////////////////////////////////////////////////////////////////////////////
//
// DoMassCure - Does a mass cure spell effect on the spell's location.
//      nDice - the number of d8 to roll for healing.
//      nBonusCap - the cap on bonus hp, bonus hp equal to caster level up to
//      the cap is added.
//      nHealEffect - the vfx to apply to the target(s).
//      nSpellID - the spell ID to use for event firing.
//
/////////////////////////////////////////////////////////////////////////////////

void DoMassCure (int nDice, int nBonusCap, int nHealEffect, int nSpellID = -1)
{
    SPSetSchool(SPELL_SCHOOL_CONJURATION);
    
    // Get the spell target location as opposed to the spell target.
    location lTarget = PRCGetSpellTargetLocation();

    // Get the effective caster level.
    int nCasterLvl = PRCGetCasterLevel(OBJECT_SELF);
//  int nBonusHP = nCasterLvl > nBonusCap ? nBonusCap : nCasterLvl;

    // Get the spell ID if it was not given.
    if (-1 == nSpellID) nSpellID = PRCGetSpellId();
    
    // Apply the burst vfx.
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_LOS_HOLY_20), PRCGetSpellTargetLocation());
    
    effect eVisCure = EffectVisualEffect(nHealEffect);
    effect eVisHarm = EffectVisualEffect(VFX_IMP_SUNSTRIKE);
    float fDelay;
    
    // Declare the spell shape, size and the location.  Capture the first target object in the shape.
    // Cycle through the targets within the spell shape until an invalid object is captured.
    int nHealed = 0;
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    while (GetIsObjectValid(oTarget))
    {
        // Call our modified bioware cure logic to do the actual cure/harm effect.
        if (biowareSpellsCure(nCasterLvl,oTarget, d8(nDice), nBonusCap, 8 * nDice, 
            eVisHarm, eVisCure, nSpellID))
            nHealed++;
        
        // If we've healed as manay targets as we can we're done.
        if (nHealed >= nCasterLvl) break;
        
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }
    
    SPSetSchool();
}

////////////////Begin Orb//////////////////////

void DoOrb(effect eVis, effect eFailSave, int nSaveType, int nDamageType, int nSpellID = -1)
{
     SPSetSchool(SPELL_SCHOOL_EVOCATION);

     object oTarget = PRCGetSpellTargetObject();
     int nCasterLvl = PRCGetCasterLevel(OBJECT_SELF);

     int nDice = nCasterLvl;
     if (nDice > 15) nDice = 15;
     
     int nPenetr = nCasterLvl + SPGetPenetr();

     // Get the spell ID if it was not given.
     if (-1 == nSpellID) nSpellID = PRCGetSpellId();
     
     // Adjust the damage type of necessary.
     nDamageType = SPGetElementalDamageType(nDamageType, OBJECT_SELF);

     effect eMissile = EffectVisualEffect(VFX_IMP_MIRV);

     if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
     {
          //Fire cast spell at event for the specified target
          SPRaiseSpellCastAt(oTarget, TRUE, nSpellID);

          //Make SR Check
          if (!SPResistSpell(OBJECT_SELF, oTarget,nPenetr))
          {
               //Roll damage for each target
               int nDamage = SPGetMetaMagicDamage(nDamageType, nDice, 6);
               nDamage += ApplySpellBetrayalStrikeDamage(oTarget, OBJECT_SELF);

               // Let the target make a fort save, if they succeed half damage and no bad effect, if they fail
               // then full damage and the bad effect.
               int nSaved = 0;
               if (FortitudeSave(oTarget, PRCGetSaveDC(oTarget,OBJECT_SELF), nSaveType))
               {
                    nSaved = 1;
                    nDamage /= 2;
               }

               // Apply the damage and the damage visible effect to the target.                
               SPApplyEffectToObject(DURATION_TYPE_INSTANT, SPEffectDamage(nDamage, nDamageType), oTarget);
               PRCBonusDamage(oTarget);
               SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

               // If the target failed it's save then apply the failed save effect as well for 1 round.
               if (!nSaved)
                    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFailSave, oTarget, RoundsToSeconds(1),TRUE,-1,nCasterLvl);
          }
     }
     
     SPSetSchool();
}

////////////////End Orb//////////////////////

////////////////Begin Serpents Sigh//////////////////////

void DamageSelf (int nDamageCap, int nVfx)
{
    // Now that the spell has gone off we have to take our damage.
    int nDamage = PRCGetCasterLevel(OBJECT_SELF);
    nDamage = nDamage > nDamageCap ? nDamageCap : nDamage;
    
    // Apply the damage and appropriate visual effect.
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, SPEffectDamage(nDamage, DAMAGE_TYPE_MAGICAL), OBJECT_SELF);
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(nVfx), OBJECT_SELF);
}

////////////////End Serpents Sigh//////////////////////

////////////////Begin Summon//////////////////////

void sp_summon(string creature, int impactVfx)
{
    SPSetSchool(SPELL_SCHOOL_CONJURATION);

    // Check to see if the spell hook cancels the spell.
    if (!X2PreSpellCastCode()) return;

    // Get the duration, base of 24 hours, modified by metamagic
    float fDuration = SPGetMetaMagicDuration(HoursToSeconds(24));

    // Apply impact VFX and summon effects.
    MultisummonPreSummon();
    if(GetPRCSwitch(PRC_SUMMON_ROUND_PER_LEVEL))
        fDuration = SPGetMetaMagicDuration(RoundsToSeconds(PRCGetCasterLevel()*GetPRCSwitch(PRC_SUMMON_ROUND_PER_LEVEL)));
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectVisualEffect(impactVfx),
                          PRCGetSpellTargetLocation());
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectSummonCreature(creature),
                          PRCGetSpellTargetLocation(), fDuration);

    SPSetSchool();
}

////////////////End Summon//////////////////////

//::///////////////////////////////////////////////
//:: Spell Include: Transposition
//:: spinc_trans
//::///////////////////////////////////////////////
/** @file
    Common code for Benign Transposition and
    Baleful Transposition.
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

/////////////////////////
// Function Prototypes //
/////////////////////////

/**
 * Changes the positions of current spellcaster and spell target.
 *
 * @param bAllowHostile  If this flag is FALSE then the target creature
 *                       must be a member of the caster's party (have the same faction
 *                       leader). If this flag is false then it may be a party member
 *                       or a hostile creature.
 */
void DoTransposition(int bAllowHostile);



//////////////////////////
// Function Definitions //
//////////////////////////

//
// Displays transposition VFX.
//
void TransposeVFX(object o1, object o2)
{
    // Apply vfx to the creatures moving.
    effect eVis = EffectVisualEffect(VFX_IMP_HEALING_X);
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, o1);
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, o2);
}


//
// Transposes the 2 creatures.
//
void Transpose(object o1, object o2)
{
    // Get the locations of the 2 creatures to swap, keeping the facings
    // the same.
    location loc1 = Location(GetArea(o1), GetPosition(o1), GetFacing(o2));
    location loc2 = Location(GetArea(o2), GetPosition(o2), GetFacing(o1));

 /*   // Make sure both creatures are capable of being teleported
    if(!(GetCanTeleport(o1, loc2) && GetCanTeleport(o2, loc1)))
        return;*/

    // Swap the creatures.
    AssignCommand(o2, JumpToLocation(loc1));
    AssignCommand(o1, JumpToLocation(loc2));

    DelayCommand(0.1, TransposeVFX(o1, o2));
}


void DoTransposition(int bAllowHostile)
{
    SPSetSchool(SPELL_SCHOOL_CONJURATION);
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
    if (!X2PreSpellCastCode()) return;
    
    
    object oTarget = PRCGetSpellTargetObject();
    if (!GetIsDead(oTarget))
    {
        // Get the spell target.  If he has the same faction leader we do (i.e. he's in the party)
        // or he's a hostile target and hostiles are allowed then we will do the switch.
        int bParty = GetFactionLeader(oTarget) == GetFactionLeader(OBJECT_SELF);
        if (bParty || (bAllowHostile && spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF)))
        {
            // Targets outside the party get a will save and SR to resist.
            if (bParty || 
                (!SPResistSpell(OBJECT_SELF, oTarget) && !PRCMySavingThrow(SAVING_THROW_WILL, oTarget, PRCGetSaveDC(oTarget,OBJECT_SELF))))
            {
                //Fire cast spell at event for the specified target
                SPRaiseSpellCastAt(oTarget, !bParty);

                // Move the creatures.
                DelayCommand(0.1, Transpose(OBJECT_SELF, oTarget));
            }
        }       
    }
        
    SPSetSchool();
}
