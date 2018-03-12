//::///////////////////////////////////////////////
//:: Combat Simulation System
//:://////////////////////////////////////////////
//:: Created By: Oni5115
//:: Created On: July 16, 2004
//:://////////////////////////////////////////////
//:: Code based on Aaon Graywolf's older inc_combat.nss
//:: and Soul Taker's Additions in inc_combat2.nss
//:://////////////////////////////////////////////
//:: Attempts to add additional functionality to the
//:: older combat system to make combat simulation
//:: a little more accurate and easy to use.
//:://////////////////////////////////////////////
//:: Current Limitations:
//::
//:: System does not add many magical effects on weapons.
//:: Examples would be Vorpal, On hit: Daze/Stun/Sleep, Poison, etc.
//::
//:: All weapon/spell damage bonuses are counted though.
//:://////////////////////////////////////////////
//:: Tested:
//:: Weapon Information and Damage
//:: Elemental Information and Damage
//:: Perform Attack Round
//:: Sneak Attack Functions
//:://////////////////////////////////////////////
//:: Things to Test:
//:: Attack Bonuses - enchanted and non.
//:: Dark Fire and Flame Weapon
//:: Unarmed Damage
//:: Cleave, Great Cleave, and Cirlce Kick
//:://////////////////////////////////////////////
//:: Known Issues:
//:: Tempests seem to get an additional +2 with off-hand light weapons
//:: when they have Absolute Ambidexterity, not sure if this is an issue specifically
//:: with tempests, or if it's for all two-weapon fighting
//:://////////////////////////////////////////////

// #include "prc_feat_const"   <-- Inherited
// #include "prc_class_const"  <-- Inherited
// #include "prc_spell_const"  <-- Inherited
// #include "x2_inc_switches"  <-- Inherited
// #include "prc_alterations"  <-- Inherited
// #include "X2_I0_SPELLS"     <-- Inherited
// #include "x2_inc_spellhook" <-- Inherited
// #include "prc_ipfeat_const" <-- Inherited
// #include "nw_i0_generic"    <-- Inherited

#include "x2_inc_itemprop"
#include "prc_inc_racial"
#include "prc_inc_function"
#include "prc_inc_sneak"
#include "prc_inc_unarmed"
#include "prc_inc_util"

//:://////////////////////////////////////////////
//::  Weapon Information Functions
//:://////////////////////////////////////////////

// Returns DAMAGE_TYPE_* const of weapon
int GetWeaponDamageType(object oWeap);

// returns true if weapon is two-handed
// does not include double weapons
int GetIsTwoHandedMeleeWeapon(object oWeap);

// Returns the appropriate weapon feat given a weapon type
// iType = BASE_ITEM_*
// sFeat = "Focus", "Specialization", EpicFocus", "EpicSpecialization", "ImprovedCrit"
//         "OverwhelmingCrit", "DevastatingCrit", "WeaponOfChoice"
int GetFeatByWeaponType(int iType, string sFeat);

// Returns the low end of oWeap's critical threat range
// Accounts for Keen and Improved Critical bonuses
int GetWeaponCriticalRange(object oPC, object oWeap);

// Returns the players critical hit damage multiplier
// takes into account weapon master's increased critical feat
int GetWeaponCritcalMultiplier(object oPC, object oWeap);

// Return the proper ammunition based on the weapon
object GetAmmunitionFromWeapon(object oWeapon, object oAttacker);

//:://////////////////////////////////////////////
//::  Combat Information Functions
//:://////////////////////////////////////////////

// Returns true if melee attacker within 15 feet
int GetMeleeAttackers15ft(object oPC = OBJECT_SELF);

// Returns true if melee attacker is in range to attack target
int GetIsInMeleeRange(object oDefender, object oAttacker);

// Returns true/false if player is a monk and has a monk weapon equipped
int GetHasMonkWeaponEquipped(object oPC);

// Returns number of attacks per round for main hand
int GetMainHandAttacks(object oPC);

// Returns number of attacks per round for off-hand
int GetOffHandAttacks(object oPC);

// Returns an  Alignment Group
// Used to determine the attack and damage bonuses vs. alignments
int ConvAlignGr(int iGoodEvil,int iLawChaos);

//:://////////////////////////////////////////////
//::  Attack Bonus Functions
//:://////////////////////////////////////////////

// Returns the magical attack bonus modifier on the attacker
// checks for all the spells and determines the proper bonuses/penalties
int GetMagicalAttackBonus(object oAttacker);

// Returns Weapon Attack bonus or penalty
// inlcuding race and alignment checks
int GetWeaponAttackBonusItemProperty(object oWeap, object oDefender);

// Returns the Attack Bonus for oAttacker attacking oDefender
// iMainHand = 0 means attack is from main hand (default)
// iMainHand = 1 for an off-hand attack
int GetAttackBonus(object oDefender, object oAttacker, object oWeap, int iMainHand = 0);

// Returns 0 on miss, 1 on hit, and 2 on Critical hit
// Works for both Ranged and Melee Attacks
// iMainHand 0 = main; 1 = off-hand
// iAttackBonus 0 = calculate it; Anything else and it will use that value and will not calculate it.
// This is mainly for when you call PerformAttackRound to do multiple attacks,
// so that it does not have to recalculate all the bonuses for every attack made.
// int iMod = 0;  iMod just modifies the attack roll.
// If you are coding an attack that reduces the attack roll, put the number in the iMod slot.
// bShowFeedback tells the script to show the script feedback
// fDelay is the amount of time to delay the display of feedback
int GetAttackRoll(object oDefender, object oAttacker, object oWeapon, int iMainHand = 0, int iAttackBonus = 0, int iMod = 0, int bShowFeedback = TRUE, float fDelay = 0.0);

//:://////////////////////////////////////////////
//::  Damage Bonus Functions
//:://////////////////////////////////////////////

// Returns Favored Enemy Bonus Damage
int GetFavoredEnemeyDamageBonus(object oDefender, object oAttacker);

// Get Mighty Weapon Bonus
int GetMightyWeaponBonus(object oWeap);

// Returns the Enhancement Bonus of oWeapon
// Can also return - enhancements (penalties)
int GetWeaponEnhancement(object oWeapon, object oDefender, object oAttacker);

// Used to return the Enhancement Bonus for monks
// called by GetAttackDamage to make sure monks
// get proper damage power for cutting through DR
// Note: Calls GetWeaponEnhancement as well, so when determining Damage Power
//       Just use GetMonkEnhancement instead.
int GetMonkEnhancement(object oWeapon, object oDefender, object oAttacker);

// Returns the DAMAGE_POWER_* of a weapon
// For monks send gloves instead of weapon
// function makes use of above enhancement functions
// to determine Enhancement vs. Alignment and everything
int GetDamagePowerConstant(object oWeapon, object oDefender, object oAttacker);

// Returns Enhancement bonus on Ammunition
// oWeap = Weapon used by Attacker
int GetAmmunitionEnhancement(object oWeapon, object oDefender, object oAttacker);

// Returns an integer amount of damage from a constant
// iDamageConst = DAMAGE_BONUS_* or IP_CONST_DAMAGEBONUS_*
int GetDamageByConstant(int iDamageConst, int iItemProp);

// Utility function used by GetWeaponBonusDamage to store the damage constants
// Prevents same code from being written multiple times for various damage properties
struct BonusDamage  GetItemPropertyDamageConstant(int iDamageType, int iTemp, struct BonusDamage weapBonusDam);

// Returns a struct filled with IP damage constants for the given weapon.
// Used to add elemental damage to combat system.
// Can also get information from Weapon Ammunition if used in place of oWeapon
struct BonusDamage GetWeaponBonusDamage(object oWeapon, object oTarget);

// Stores bonus damage from spells into the struct
struct BonusDamage GetMagicalBonusDamage(object oAttacker);

// Returns damage caused by each attack that should remain constant the whole round
// Mainly things from feat, strength bonus, etc.
// iMainHand = 0 means attack is from main hand (default)
// iMainHand = 1 for an off-hand attack
int GetWeaponDamagePerRound(object oDefender, object oAttacker, object oWeap, int iMainHand = 0);

// Returns Damage dealt by weapon
// Works for both Ranged and Melee Attacks
// Defaults typically calculate everything for you, but cacheing the data and reusing it
// can make things run faster so I left them as optional parameters.
// sWeaponBonusDamage = result of a call to GetWeaponBonusDamage
// sSpellBonusDamage  = result of a call to GetMagicalBonusDamage
// iMainHand 0 = main; 1 = off-hand
// iDamage 0 = calculate the GetWeaponDamagePerRound; Anything else and it will use that value
// and will not calculate it.  This is mainly for when you call PerformAttackRound
// to do multiple attacks,  so that it does not have to recalculate all the bonuses
// for every attack made.
// bIsCritical = FALSE is not a critical; true is a critcal hit.
// iNumDice  0 = calculate it; Anything else is the number of dice rolled
// iNumSides 0 = calculate it; Anything else is the sides of the dice rolled
// iCriticalMultiplier 0 = calculate itl Anything else is the damage multiplier on a critical hit
effect GetAttackDamage(object oDefender, object oAttacker, object oWeapon, struct BonusDamage sWeaponBonusDamage, struct BonusDamage sSpellBonusDamage, int iMainHand = 0, int iDamage = 0, int bIsCritical = FALSE, int iNumDice = 0, int iNumSides = 0, int iCriticalMultiplier = 0);

// Due to the lack of a proper sleep function in order to delay attacks properly
// I needed to make a separate function to control the logic of each attack.
// AttackLoopMain calls this function, which in turn uses a delay and calls AttackLoopMain.
// This allowed a proper way to delay the function.
void AttackLoopLogic(object oDefender, object oAttacker, int iBonusAttacks, int iMainAttacks, int iOffHandAttacks, int iMod, struct AttackLoopVars sAttackVars, struct BonusDamage sMainWeaponDamage, struct BonusDamage sOffHandWeaponDamage, struct BonusDamage sSpellBonusDamage, int iMainHand, int bIsCleaveAttack);

// Function used by PerformAttackRound to control the flow of logic
// this function calls AttackLoopLogic which then calls this function again
// making them recursive until the AttackLoopMain stops calling AttackLoopLogic
void AttackLoopMain(object oDefender, object oAttacker, int iBonusAttacks, int iMainAttacks, int iOffHandAttacks, int iMod, struct AttackLoopVars sAttackVars, struct BonusDamage sMainWeaponDamage, struct BonusDamage sOffHandWeaponDamage, struct BonusDamage sSpellBonusDamage);

// Performs a full attack round and can add in bonus damage damage/effects
// Will perform all attacks and accounts for weapontype, haste, twf, tempest twf, etc.
//
// eSpecialEffect -  any special Vfx or other effects the attack should use IF successful.
// eDuration - Changes the duration of the applied effect(s)
//           0.0 = DURATION_TYPE_INSTANT, effect lasts 0.0 seconds.
//          >0.0 = DURATION_TYPE_TEMPORARY, effect lasts the amount of time put in here.
//          <0.0 = DURATION_TYPE_PERMAMENT!!!!!  Effect lasts until dispelled.
// iAttackBonusMod is the attack modifier - Will effect all attacks if bEffectAllAttacks is on
// iDamageModifier - should be either a DAMAGE_BONUS_* constant or an int of damage.
//                   Give an int if the attack effects ONLY the first attack!
// iDamageType = DAMAGE_TYPE_*
// bEffectAllAttacks - If FALSE will only effect first attack, otherwise effects all attacks.
// sMessageSuccess - message to display on a successful hit. (i.e. "*Sneak Attack Hit*")
// sMessageFailure - message to display on a failure to hit. (i.e. "*Sneak Attack Miss*")
void PerformAttackRound(object oDefender, object oAttacker, effect eSpecialEffect, float eDuration = 0.0, int iAttackBonusMod = 0, int iDamageModifier = 0, int iDamageType = 0, int bEffectAllAttacks = FALSE, string sMessageSuccess = "", string sMessageFailure = "");

// Performs a single attack and can add in bonus damage damage/effects
// If the first attack hits, a local int called "PRCCombat_StruckByAttack" will be TRUE
// on the target for 1 second.
//
// eSpecialEffect -  any special Vfx or other effects the attack should use IF successful.
// eDuration - Changes the duration of the applied effect(s)
//           0.0 = DURATION_TYPE_INSTANT, effect lasts 0.0 seconds.
//          >0.0 = DURATION_TYPE_TEMPORARY, effect lasts the amount of time put in here.
//          <0.0 = DURATION_TYPE_PERMAMENT!!!!!  Effect lasts until dispelled.
// iAttackBonusMod is the attack modifier - Will effect all attacks if bEffectAllAttacks is on
// iDamageModifier - should be either a DAMAGE_BONUS_* constant or an int of damage.
//                   Give an int if the attack effects ONLY the first attack!
// iDamageType = DAMAGE_TYPE_*
// sMessageSuccess - message to display on a successful hit. (i.e. "*Sneak Attack Hit*")
// sMessageFailure - message to display on a failure to hit. (i.e. "*Sneak Attack Miss*")
// iTouchAttackType - TOUCH_ATTACK_* const - melee, ranged, spell melee, spell ranged
// oRightHandOverride - item to use as if in the right hand
// oLeftHandOverride - item to use as if in the left hand
void PerformAttack(object oDefender, object oAttacker, effect eSpecialEffect, float eDuration = 0.0, int iAttackBonusMod = 0, int iDamageModifier = 0, int iDamageType = 0, string sMessageSuccess = "", string sMessageFailure = "", int iTouchAttackType = FALSE, object oRightHandOverride = OBJECT_INVALID, object oLeftHandOverride = OBJECT_INVALID);

//:://///////////////////////////////////////
//::  Structs
//:://///////////////////////////////////////

struct BonusDamage
{
     // dice_* vars are for the damage bonus IP that are NdX dice elemental damage
     int dice_Acid, dice_Cold, dice_Fire, dice_Elec, dice_Son;
     int dice_Div, dice_Neg, dice_Pos;
     int dice_Mag;
     int dice_Slash, dice_Pier, dice_Blud;

     // dam_* vars are for +/- X damage bonuses
     int dam_Acid, dam_Cold, dam_Fire, dam_Elec, dam_Son;
     int dam_Div, dam_Neg, dam_Pos;
     int dam_Mag;
     int dam_Slash, dam_Pier, dam_Blud;
};

struct AttackLoopVars
{
     // these variables don't change during the attack loop logic, they are just
     // recursively passed back to the function.

     // the delay of the functions recursion and the duration of the eSpecialEffect
     float fDelay, eDuration;

     // does the special effect apply to all attacks? is it a ranged weapon?
     int bEffectAllAttacks, bIsRangedWeapon;

     // Ammo if it is a ranged weapon, and both main and off-hand weapons
     object oAmmo, oWeaponR, oWeaponL;

     // all the main hand weapon data
     int iMainNumDice, iMainNumSides, iMainCritMult, iMainAttackBonus, iMainWeaponDamageRound;

     // all the off hand weapon data
     int iOffHandNumDice, iOffHandNumSides, iOffHandCritMult, iOffHandAttackBonus, iOffHandWeaponDamageRound;

     // special effect applied on first attack, or all attacks
     effect eSpecialEffect;

     //  the damage modifier and damage type for extra damage from special attacks
     int iDamageModifier, iDamageType;

     // string displayed on a successful hit, or a miss
     string sMessageSuccess, sMessageFailure;
};

// Vars needed to pass between AttackLoopMain and AttackLoopLogic
int iCleaveAttacks = 0;
int iCircleKick = 0;
int bFirstAttack = TRUE;

//:://////////////////////////////////////////////
//::  Weapon Information Functions
//:://////////////////////////////////////////////

int GetWeaponDamageType(object oWeap)
{
    int iType = GetBaseItemType(oWeap);

    switch(iType)
    {
        case BASE_ITEM_BASTARDSWORD:
        case BASE_ITEM_BATTLEAXE:
        case BASE_ITEM_DOUBLEAXE:
        case BASE_ITEM_DWARVENWARAXE:
        case BASE_ITEM_GREATAXE:
        case BASE_ITEM_GREATSWORD:
        case BASE_ITEM_HALBERD:
        case BASE_ITEM_HANDAXE:
        case BASE_ITEM_KAMA:
        case BASE_ITEM_KATANA:
        case BASE_ITEM_KUKRI:
        case BASE_ITEM_LONGSWORD:
        case BASE_ITEM_SCIMITAR:
        case BASE_ITEM_SCYTHE:
        case BASE_ITEM_SICKLE:
        case BASE_ITEM_THROWINGAXE:
        case BASE_ITEM_TWOBLADEDSWORD:
        case BASE_ITEM_WHIP:
        case BASE_ITEM_CSLASHWEAPON:
        case BASE_ITEM_CSLSHPRCWEAP:
           return DAMAGE_TYPE_SLASHING;

        case BASE_ITEM_DAGGER:
        case BASE_ITEM_DART:
        case BASE_ITEM_SHORTSPEAR:
        case BASE_ITEM_RAPIER:
        case BASE_ITEM_LONGBOW:
        case BASE_ITEM_SHORTBOW:
        case BASE_ITEM_SHORTSWORD:
        case BASE_ITEM_SHURIKEN:
        case BASE_ITEM_LIGHTCROSSBOW:
        case BASE_ITEM_HEAVYCROSSBOW:
        case BASE_ITEM_CPIERCWEAPON:
        case BASE_ITEM_BOLT:
        case BASE_ITEM_ARROW:
           return DAMAGE_TYPE_PIERCING;

        case BASE_ITEM_CLUB:
        case BASE_ITEM_WARHAMMER:
        case BASE_ITEM_MORNINGSTAR:
        case BASE_ITEM_QUARTERSTAFF:
        case BASE_ITEM_LIGHTFLAIL:
        case BASE_ITEM_LIGHTHAMMER:
        case BASE_ITEM_LIGHTMACE:
        case BASE_ITEM_HEAVYFLAIL:
        case BASE_ITEM_DIREMACE:
        case BASE_ITEM_SLING:
        case BASE_ITEM_CBLUDGWEAPON:
        case BASE_ITEM_BULLET:
           return DAMAGE_TYPE_BLUDGEONING;
    }

    if(oWeap == OBJECT_INVALID)
    {
         // For Fists
         return DAMAGE_TYPE_BLUDGEONING;
    }

    return -1;
}

int GetIsTwoHandedMeleeWeapon(object oWeap)
{
   int iReturn = 0;
   int iType = GetBaseItemType(oWeap);

    switch(iType)
    {
        case BASE_ITEM_GREATAXE:
             iReturn = 1;
             break;
        case BASE_ITEM_GREATSWORD:
             iReturn = 1;
             break;
        case BASE_ITEM_HALBERD:
             iReturn = 1;
             break;
        case BASE_ITEM_SHORTSPEAR:
             iReturn = 1;
             break;
        case BASE_ITEM_HEAVYFLAIL:
    }

    return iReturn;
}

int GetFeatByWeaponType(int iType, string sFeat)
{
        if(sFeat == "Focus")
            switch(iType)
            {
                case BASE_ITEM_BASTARDSWORD: return FEAT_WEAPON_FOCUS_BASTARD_SWORD;
                case BASE_ITEM_BATTLEAXE: return FEAT_WEAPON_FOCUS_BATTLE_AXE;
                case BASE_ITEM_CLUB: return FEAT_WEAPON_FOCUS_CLUB;
                case BASE_ITEM_DAGGER: return FEAT_WEAPON_FOCUS_DAGGER;
                case BASE_ITEM_DART: return FEAT_WEAPON_FOCUS_DART;
                case BASE_ITEM_DIREMACE: return FEAT_WEAPON_FOCUS_DIRE_MACE;
                case BASE_ITEM_DOUBLEAXE: return FEAT_WEAPON_FOCUS_DOUBLE_AXE;
                case BASE_ITEM_DWARVENWARAXE: return FEAT_WEAPON_FOCUS_DWAXE;
                case BASE_ITEM_GREATAXE: return FEAT_WEAPON_FOCUS_GREAT_AXE;
                case BASE_ITEM_GREATSWORD: return FEAT_WEAPON_FOCUS_GREAT_SWORD;
                case BASE_ITEM_HALBERD: return FEAT_WEAPON_FOCUS_HALBERD;
                case BASE_ITEM_HANDAXE: return FEAT_WEAPON_FOCUS_HAND_AXE;
                case BASE_ITEM_HEAVYCROSSBOW: return FEAT_WEAPON_FOCUS_HEAVY_CROSSBOW;
                case BASE_ITEM_HEAVYFLAIL: return FEAT_WEAPON_FOCUS_HEAVY_FLAIL;
                case BASE_ITEM_KAMA: return FEAT_WEAPON_FOCUS_KAMA;
                case BASE_ITEM_KATANA: return FEAT_WEAPON_FOCUS_KATANA;
                case BASE_ITEM_KUKRI: return FEAT_WEAPON_FOCUS_KUKRI;
                case BASE_ITEM_LIGHTCROSSBOW: return FEAT_WEAPON_FOCUS_LIGHT_CROSSBOW;
                case BASE_ITEM_LIGHTFLAIL: return FEAT_WEAPON_FOCUS_LIGHT_FLAIL;
                case BASE_ITEM_LIGHTHAMMER: return FEAT_WEAPON_FOCUS_LIGHT_HAMMER;
                case BASE_ITEM_LIGHTMACE: return FEAT_WEAPON_FOCUS_LIGHT_MACE;
                case BASE_ITEM_LONGBOW: return FEAT_WEAPON_FOCUS_LONG_SWORD;
                case BASE_ITEM_LONGSWORD: return FEAT_WEAPON_FOCUS_LONGBOW;
                case BASE_ITEM_MORNINGSTAR: return FEAT_WEAPON_FOCUS_MORNING_STAR;
                case BASE_ITEM_QUARTERSTAFF: return FEAT_WEAPON_FOCUS_STAFF;
                case BASE_ITEM_RAPIER: return FEAT_WEAPON_FOCUS_RAPIER;
                case BASE_ITEM_SCIMITAR: return FEAT_WEAPON_FOCUS_SCIMITAR;
                case BASE_ITEM_SCYTHE: return FEAT_WEAPON_FOCUS_SCYTHE;
                case BASE_ITEM_SHORTBOW: return FEAT_WEAPON_FOCUS_SHORTBOW;
                case BASE_ITEM_SHORTSPEAR: return FEAT_WEAPON_FOCUS_SPEAR;
                case BASE_ITEM_SHORTSWORD: return FEAT_WEAPON_FOCUS_SHORT_SWORD;
                case BASE_ITEM_SHURIKEN: return FEAT_WEAPON_FOCUS_SHURIKEN;
                case BASE_ITEM_SICKLE: return FEAT_WEAPON_FOCUS_SICKLE;
                case BASE_ITEM_SLING: return FEAT_WEAPON_FOCUS_SLING;
                case BASE_ITEM_THROWINGAXE: return FEAT_WEAPON_FOCUS_THROWING_AXE;
                case BASE_ITEM_TWOBLADEDSWORD: return FEAT_WEAPON_FOCUS_TWO_BLADED_SWORD;
                case BASE_ITEM_WARHAMMER: return FEAT_WEAPON_FOCUS_WAR_HAMMER;
                case BASE_ITEM_WHIP: return -1;
                //case BASE_ITEM_WHIP: return FEAT_WEAPON_FOCUS_WHIP;
            }

        else if(sFeat == "Specialization")
            switch(iType)
            {
                case BASE_ITEM_BASTARDSWORD: return FEAT_WEAPON_SPECIALIZATION_BASTARD_SWORD;
                case BASE_ITEM_BATTLEAXE: return FEAT_WEAPON_SPECIALIZATION_BATTLE_AXE;
                case BASE_ITEM_CLUB: return FEAT_WEAPON_SPECIALIZATION_CLUB;
                case BASE_ITEM_DAGGER: return FEAT_WEAPON_SPECIALIZATION_DAGGER;
                case BASE_ITEM_DART: return FEAT_WEAPON_SPECIALIZATION_DART;
                case BASE_ITEM_DIREMACE: return FEAT_WEAPON_SPECIALIZATION_DIRE_MACE;
                case BASE_ITEM_DOUBLEAXE: return FEAT_WEAPON_SPECIALIZATION_DOUBLE_AXE;
                case BASE_ITEM_DWARVENWARAXE: return FEAT_WEAPON_SPECIALIZATION_DWAXE ;
                case BASE_ITEM_GREATAXE: return FEAT_WEAPON_SPECIALIZATION_GREAT_AXE;
                case BASE_ITEM_GREATSWORD: return FEAT_WEAPON_SPECIALIZATION_GREAT_SWORD;
                case BASE_ITEM_HALBERD: return FEAT_WEAPON_SPECIALIZATION_HALBERD;
                case BASE_ITEM_HANDAXE: return FEAT_WEAPON_SPECIALIZATION_HAND_AXE;
                case BASE_ITEM_HEAVYCROSSBOW: return FEAT_WEAPON_SPECIALIZATION_HEAVY_CROSSBOW;
                case BASE_ITEM_HEAVYFLAIL: return FEAT_WEAPON_SPECIALIZATION_HEAVY_FLAIL;
                case BASE_ITEM_KAMA: return FEAT_WEAPON_SPECIALIZATION_KAMA;
                case BASE_ITEM_KATANA: return FEAT_WEAPON_SPECIALIZATION_KATANA;
                case BASE_ITEM_KUKRI: return FEAT_WEAPON_SPECIALIZATION_KUKRI;
                case BASE_ITEM_LIGHTCROSSBOW: return FEAT_WEAPON_SPECIALIZATION_LIGHT_CROSSBOW;
                case BASE_ITEM_LIGHTFLAIL: return FEAT_WEAPON_SPECIALIZATION_LIGHT_FLAIL;
                case BASE_ITEM_LIGHTHAMMER: return FEAT_WEAPON_SPECIALIZATION_LIGHT_HAMMER;
                case BASE_ITEM_LIGHTMACE: return FEAT_WEAPON_SPECIALIZATION_LIGHT_MACE;
                case BASE_ITEM_LONGBOW: return FEAT_WEAPON_SPECIALIZATION_LONG_SWORD;
                case BASE_ITEM_LONGSWORD: return FEAT_WEAPON_SPECIALIZATION_LONGBOW;
                case BASE_ITEM_MORNINGSTAR: return FEAT_WEAPON_SPECIALIZATION_MORNING_STAR;
                case BASE_ITEM_QUARTERSTAFF: return FEAT_WEAPON_SPECIALIZATION_STAFF;
                case BASE_ITEM_RAPIER: return FEAT_WEAPON_SPECIALIZATION_RAPIER;
                case BASE_ITEM_SCIMITAR: return FEAT_WEAPON_SPECIALIZATION_SCIMITAR;
                case BASE_ITEM_SCYTHE: return FEAT_WEAPON_SPECIALIZATION_SCYTHE;
                case BASE_ITEM_SHORTBOW: return FEAT_WEAPON_SPECIALIZATION_SHORTBOW;
                case BASE_ITEM_SHORTSPEAR: return FEAT_WEAPON_SPECIALIZATION_SPEAR;
                case BASE_ITEM_SHORTSWORD: return FEAT_WEAPON_SPECIALIZATION_SHORT_SWORD;
                case BASE_ITEM_SHURIKEN: return FEAT_WEAPON_SPECIALIZATION_SHURIKEN;
                case BASE_ITEM_SICKLE: return FEAT_WEAPON_SPECIALIZATION_SICKLE;
                case BASE_ITEM_SLING: return FEAT_WEAPON_SPECIALIZATION_SLING;
                case BASE_ITEM_THROWINGAXE: return FEAT_WEAPON_SPECIALIZATION_THROWING_AXE;
                case BASE_ITEM_TWOBLADEDSWORD: return FEAT_WEAPON_SPECIALIZATION_TWO_BLADED_SWORD;
                case BASE_ITEM_WARHAMMER: return FEAT_WEAPON_SPECIALIZATION_WAR_HAMMER;
                case BASE_ITEM_WHIP: return -1;
                //case BASE_ITEM_WHIP: return FEAT_WEAPON_SPECIALIZATION_WHIP;
            }

        else if(sFeat == "EpicFocus")
            switch(iType)
            {
                case BASE_ITEM_BASTARDSWORD: return FEAT_EPIC_WEAPON_FOCUS_BASTARDSWORD;
                case BASE_ITEM_BATTLEAXE: return FEAT_EPIC_WEAPON_FOCUS_BATTLEAXE;
                case BASE_ITEM_CLUB: return FEAT_EPIC_WEAPON_FOCUS_CLUB;
                case BASE_ITEM_DAGGER: return FEAT_EPIC_WEAPON_FOCUS_DAGGER;
                case BASE_ITEM_DART: return FEAT_EPIC_WEAPON_FOCUS_DART;
                case BASE_ITEM_DIREMACE: return FEAT_EPIC_WEAPON_FOCUS_DIREMACE;
                case BASE_ITEM_DOUBLEAXE: return FEAT_EPIC_WEAPON_FOCUS_DOUBLEAXE;
                case BASE_ITEM_DWARVENWARAXE: return FEAT_EPIC_WEAPON_FOCUS_DWAXE;
                case BASE_ITEM_GREATAXE: return FEAT_EPIC_WEAPON_FOCUS_GREATAXE;
                case BASE_ITEM_GREATSWORD: return FEAT_EPIC_WEAPON_FOCUS_GREATSWORD;
                case BASE_ITEM_HALBERD: return FEAT_EPIC_WEAPON_FOCUS_HALBERD;
                case BASE_ITEM_HANDAXE: return FEAT_EPIC_WEAPON_FOCUS_HANDAXE;
                case BASE_ITEM_HEAVYCROSSBOW: return FEAT_EPIC_WEAPON_FOCUS_HEAVYCROSSBOW;
                case BASE_ITEM_HEAVYFLAIL: return FEAT_EPIC_WEAPON_FOCUS_HEAVYFLAIL;
                case BASE_ITEM_KAMA: return FEAT_EPIC_WEAPON_FOCUS_KAMA;
                case BASE_ITEM_KATANA: return FEAT_EPIC_WEAPON_FOCUS_KATANA;
                case BASE_ITEM_KUKRI: return FEAT_EPIC_WEAPON_FOCUS_KUKRI;
                case BASE_ITEM_LIGHTCROSSBOW: return FEAT_EPIC_WEAPON_FOCUS_LIGHTCROSSBOW;
                case BASE_ITEM_LIGHTFLAIL: return FEAT_EPIC_WEAPON_FOCUS_LIGHTFLAIL;
                case BASE_ITEM_LIGHTHAMMER: return FEAT_EPIC_WEAPON_FOCUS_LIGHTHAMMER;
                case BASE_ITEM_LIGHTMACE: return FEAT_EPIC_WEAPON_FOCUS_LIGHTMACE;
                case BASE_ITEM_LONGBOW: return FEAT_EPIC_WEAPON_FOCUS_LONGSWORD;
                case BASE_ITEM_LONGSWORD: return FEAT_EPIC_WEAPON_FOCUS_LONGBOW;
                case BASE_ITEM_MORNINGSTAR: return FEAT_EPIC_WEAPON_FOCUS_MORNINGSTAR;
                case BASE_ITEM_QUARTERSTAFF: return FEAT_EPIC_WEAPON_FOCUS_QUARTERSTAFF;
                case BASE_ITEM_RAPIER: return FEAT_EPIC_WEAPON_FOCUS_RAPIER;
                case BASE_ITEM_SCIMITAR: return FEAT_EPIC_WEAPON_FOCUS_SCIMITAR;
                case BASE_ITEM_SCYTHE: return FEAT_EPIC_WEAPON_FOCUS_SCYTHE;
                case BASE_ITEM_SHORTBOW: return FEAT_EPIC_WEAPON_FOCUS_SHORTBOW;
                case BASE_ITEM_SHORTSPEAR: return FEAT_EPIC_WEAPON_FOCUS_SHORTSPEAR;
                case BASE_ITEM_SHORTSWORD: return FEAT_EPIC_WEAPON_FOCUS_SHORTSWORD;
                case BASE_ITEM_SHURIKEN: return FEAT_EPIC_WEAPON_FOCUS_SHURIKEN;
                case BASE_ITEM_SICKLE: return FEAT_EPIC_WEAPON_FOCUS_SICKLE;
                case BASE_ITEM_SLING: return FEAT_EPIC_WEAPON_FOCUS_SLING;
                case BASE_ITEM_THROWINGAXE: return FEAT_EPIC_WEAPON_FOCUS_THROWINGAXE;
                case BASE_ITEM_TWOBLADEDSWORD: return FEAT_EPIC_WEAPON_FOCUS_TWOBLADEDSWORD;
                case BASE_ITEM_WARHAMMER: return FEAT_EPIC_WEAPON_FOCUS_WARHAMMER;
                case BASE_ITEM_WHIP: return -1;
                //case BASE_ITEM_WHIP: return FEAT_EPIC_WEAPON_FOCUS_WHIP;
            }

        else if(sFeat == "EpicSpecialization")
            switch(iType)
            {
                case BASE_ITEM_BASTARDSWORD: return FEAT_EPIC_WEAPON_SPECIALIZATION_BASTARDSWORD;
                case BASE_ITEM_BATTLEAXE: return FEAT_EPIC_WEAPON_SPECIALIZATION_BATTLEAXE;
                case BASE_ITEM_CLUB: return FEAT_EPIC_WEAPON_SPECIALIZATION_CLUB;
                case BASE_ITEM_DAGGER: return FEAT_EPIC_WEAPON_SPECIALIZATION_DAGGER;
                case BASE_ITEM_DART: return FEAT_EPIC_WEAPON_SPECIALIZATION_DART;
                case BASE_ITEM_DIREMACE: return FEAT_EPIC_WEAPON_SPECIALIZATION_DIREMACE;
                case BASE_ITEM_DOUBLEAXE: return FEAT_EPIC_WEAPON_SPECIALIZATION_DOUBLEAXE;
                case BASE_ITEM_DWARVENWARAXE: return FEAT_EPIC_WEAPON_SPECIALIZATION_DWAXE;
                case BASE_ITEM_GREATAXE: return FEAT_EPIC_WEAPON_SPECIALIZATION_GREATAXE;
                case BASE_ITEM_GREATSWORD: return FEAT_EPIC_WEAPON_SPECIALIZATION_GREATSWORD;
                case BASE_ITEM_HALBERD: return FEAT_EPIC_WEAPON_SPECIALIZATION_HALBERD;
                case BASE_ITEM_HANDAXE: return FEAT_EPIC_WEAPON_SPECIALIZATION_HANDAXE;
                case BASE_ITEM_HEAVYCROSSBOW: return FEAT_EPIC_WEAPON_SPECIALIZATION_HEAVYCROSSBOW;
                case BASE_ITEM_HEAVYFLAIL: return FEAT_EPIC_WEAPON_SPECIALIZATION_HEAVYFLAIL;
                case BASE_ITEM_KAMA: return FEAT_EPIC_WEAPON_SPECIALIZATION_KAMA;
                case BASE_ITEM_KATANA: return FEAT_EPIC_WEAPON_SPECIALIZATION_KATANA;
                case BASE_ITEM_KUKRI: return FEAT_EPIC_WEAPON_SPECIALIZATION_KUKRI;
                case BASE_ITEM_LIGHTCROSSBOW: return FEAT_EPIC_WEAPON_SPECIALIZATION_LIGHTCROSSBOW;
                case BASE_ITEM_LIGHTFLAIL: return FEAT_EPIC_WEAPON_SPECIALIZATION_LIGHTFLAIL;
                case BASE_ITEM_LIGHTHAMMER: return FEAT_EPIC_WEAPON_SPECIALIZATION_LIGHTHAMMER;
                case BASE_ITEM_LIGHTMACE: return FEAT_EPIC_WEAPON_SPECIALIZATION_LIGHTMACE;
                case BASE_ITEM_LONGBOW: return FEAT_EPIC_WEAPON_SPECIALIZATION_LONGSWORD;
                case BASE_ITEM_LONGSWORD: return FEAT_EPIC_WEAPON_SPECIALIZATION_LONGBOW;
                case BASE_ITEM_MORNINGSTAR: return FEAT_EPIC_WEAPON_SPECIALIZATION_MORNINGSTAR;
                case BASE_ITEM_QUARTERSTAFF: return FEAT_EPIC_WEAPON_SPECIALIZATION_QUARTERSTAFF;
                case BASE_ITEM_RAPIER: return FEAT_EPIC_WEAPON_SPECIALIZATION_RAPIER;
                case BASE_ITEM_SCIMITAR: return FEAT_EPIC_WEAPON_SPECIALIZATION_SCIMITAR;
                case BASE_ITEM_SCYTHE: return FEAT_EPIC_WEAPON_SPECIALIZATION_SCYTHE;
                case BASE_ITEM_SHORTBOW: return FEAT_EPIC_WEAPON_SPECIALIZATION_SHORTBOW;
                case BASE_ITEM_SHORTSPEAR: return FEAT_EPIC_WEAPON_SPECIALIZATION_SHORTSPEAR;
                case BASE_ITEM_SHORTSWORD: return FEAT_EPIC_WEAPON_SPECIALIZATION_SHORTSWORD;
                case BASE_ITEM_SHURIKEN: return FEAT_EPIC_WEAPON_SPECIALIZATION_SHURIKEN;
                case BASE_ITEM_SICKLE: return FEAT_EPIC_WEAPON_SPECIALIZATION_SICKLE;
                case BASE_ITEM_SLING: return FEAT_EPIC_WEAPON_SPECIALIZATION_SLING;
                case BASE_ITEM_THROWINGAXE: return FEAT_EPIC_WEAPON_SPECIALIZATION_THROWINGAXE;
                case BASE_ITEM_TWOBLADEDSWORD: return FEAT_EPIC_WEAPON_SPECIALIZATION_TWOBLADEDSWORD;
                case BASE_ITEM_WARHAMMER: return FEAT_EPIC_WEAPON_SPECIALIZATION_WARHAMMER;
                case BASE_ITEM_WHIP: return -1;
                //case BASE_ITEM_WHIP: return FEAT_EPIC_WEAPON_SPECIALIZATION_WHIP;
            }

        else if(sFeat == "ImprovedCrit")
            switch(iType)
            {
                case BASE_ITEM_BASTARDSWORD: return FEAT_IMPROVED_CRITICAL_BASTARD_SWORD;
                case BASE_ITEM_BATTLEAXE: return FEAT_IMPROVED_CRITICAL_BATTLE_AXE;
                case BASE_ITEM_CLUB: return FEAT_IMPROVED_CRITICAL_CLUB;
                case BASE_ITEM_DAGGER: return FEAT_IMPROVED_CRITICAL_DAGGER;
                case BASE_ITEM_DART: return FEAT_IMPROVED_CRITICAL_DART;
                case BASE_ITEM_DIREMACE: return FEAT_IMPROVED_CRITICAL_DIRE_MACE;
                case BASE_ITEM_DOUBLEAXE: return FEAT_IMPROVED_CRITICAL_DOUBLE_AXE;
                case BASE_ITEM_DWARVENWARAXE: return FEAT_IMPROVED_CRITICAL_DWAXE ;
                case BASE_ITEM_GREATAXE: return FEAT_IMPROVED_CRITICAL_GREAT_AXE;
                case BASE_ITEM_GREATSWORD: return FEAT_IMPROVED_CRITICAL_GREAT_SWORD;
                case BASE_ITEM_HALBERD: return FEAT_IMPROVED_CRITICAL_HALBERD;
                case BASE_ITEM_HANDAXE: return FEAT_IMPROVED_CRITICAL_HAND_AXE;
                case BASE_ITEM_HEAVYCROSSBOW: return FEAT_IMPROVED_CRITICAL_HEAVY_CROSSBOW;
                case BASE_ITEM_HEAVYFLAIL: return FEAT_IMPROVED_CRITICAL_HEAVY_FLAIL;
                case BASE_ITEM_KAMA: return FEAT_IMPROVED_CRITICAL_KAMA;
                case BASE_ITEM_KATANA: return FEAT_IMPROVED_CRITICAL_KATANA;
                case BASE_ITEM_KUKRI: return FEAT_IMPROVED_CRITICAL_KUKRI;
                case BASE_ITEM_LIGHTCROSSBOW: return FEAT_IMPROVED_CRITICAL_LIGHT_CROSSBOW;
                case BASE_ITEM_LIGHTFLAIL: return FEAT_IMPROVED_CRITICAL_LIGHT_FLAIL;
                case BASE_ITEM_LIGHTHAMMER: return FEAT_IMPROVED_CRITICAL_LIGHT_HAMMER;
                case BASE_ITEM_LIGHTMACE: return FEAT_IMPROVED_CRITICAL_LIGHT_MACE;
                case BASE_ITEM_LONGBOW: return FEAT_IMPROVED_CRITICAL_LONG_SWORD;
                case BASE_ITEM_LONGSWORD: return FEAT_IMPROVED_CRITICAL_LONGBOW;
                case BASE_ITEM_MORNINGSTAR: return FEAT_IMPROVED_CRITICAL_MORNING_STAR;
                case BASE_ITEM_QUARTERSTAFF: return FEAT_IMPROVED_CRITICAL_STAFF;
                case BASE_ITEM_RAPIER: return FEAT_IMPROVED_CRITICAL_RAPIER;
                case BASE_ITEM_SCIMITAR: return FEAT_IMPROVED_CRITICAL_SCIMITAR;
                case BASE_ITEM_SCYTHE: return FEAT_IMPROVED_CRITICAL_SCYTHE;
                case BASE_ITEM_SHORTBOW: return FEAT_IMPROVED_CRITICAL_SHORTBOW;
                case BASE_ITEM_SHORTSPEAR: return FEAT_IMPROVED_CRITICAL_SPEAR;
                case BASE_ITEM_SHORTSWORD: return FEAT_IMPROVED_CRITICAL_SHORT_SWORD;
                case BASE_ITEM_SHURIKEN: return FEAT_IMPROVED_CRITICAL_SHURIKEN;
                case BASE_ITEM_SICKLE: return FEAT_IMPROVED_CRITICAL_SICKLE;
                case BASE_ITEM_SLING: return FEAT_IMPROVED_CRITICAL_SLING;
                case BASE_ITEM_THROWINGAXE: return FEAT_IMPROVED_CRITICAL_THROWING_AXE;
                case BASE_ITEM_TWOBLADEDSWORD: return FEAT_IMPROVED_CRITICAL_TWO_BLADED_SWORD;
                case BASE_ITEM_WARHAMMER: return FEAT_IMPROVED_CRITICAL_WAR_HAMMER;
                case BASE_ITEM_WHIP: return -1;
                //case BASE_ITEM_WHIP: return FEAT_IMPROVED_CRITICAL_WHIP;
            }

        else if(sFeat == "OverwhelmingCrit")
            switch(iType)
            {
                case BASE_ITEM_BASTARDSWORD: return FEAT_EPIC_OVERWHELMING_CRITICAL_BASTARDSWORD;
                case BASE_ITEM_BATTLEAXE: return FEAT_EPIC_OVERWHELMING_CRITICAL_BATTLEAXE;
                case BASE_ITEM_CLUB: return FEAT_EPIC_OVERWHELMING_CRITICAL_CLUB;
                case BASE_ITEM_DAGGER: return FEAT_EPIC_OVERWHELMING_CRITICAL_DAGGER;
                case BASE_ITEM_DART: return FEAT_EPIC_OVERWHELMING_CRITICAL_DART;
                case BASE_ITEM_DIREMACE: return FEAT_EPIC_OVERWHELMING_CRITICAL_DIREMACE;
                case BASE_ITEM_DOUBLEAXE: return FEAT_EPIC_OVERWHELMING_CRITICAL_DOUBLEAXE;
                case BASE_ITEM_DWARVENWARAXE: return FEAT_EPIC_OVERWHELMING_CRITICAL_DWAXE ;
                case BASE_ITEM_GREATAXE: return FEAT_EPIC_OVERWHELMING_CRITICAL_GREATAXE;
                case BASE_ITEM_GREATSWORD: return FEAT_EPIC_OVERWHELMING_CRITICAL_GREATSWORD;
                case BASE_ITEM_HALBERD: return FEAT_EPIC_OVERWHELMING_CRITICAL_HALBERD;
                case BASE_ITEM_HANDAXE: return FEAT_EPIC_OVERWHELMING_CRITICAL_HANDAXE;
                case BASE_ITEM_HEAVYCROSSBOW: return FEAT_EPIC_OVERWHELMING_CRITICAL_HEAVYCROSSBOW;
                case BASE_ITEM_HEAVYFLAIL: return FEAT_EPIC_OVERWHELMING_CRITICAL_HEAVYFLAIL;
                case BASE_ITEM_KAMA: return FEAT_EPIC_OVERWHELMING_CRITICAL_KAMA;
                case BASE_ITEM_KATANA: return FEAT_EPIC_OVERWHELMING_CRITICAL_KATANA;
                case BASE_ITEM_KUKRI: return FEAT_EPIC_OVERWHELMING_CRITICAL_KUKRI;
                case BASE_ITEM_LIGHTCROSSBOW: return FEAT_EPIC_OVERWHELMING_CRITICAL_LIGHTCROSSBOW;
                case BASE_ITEM_LIGHTFLAIL: return FEAT_EPIC_OVERWHELMING_CRITICAL_LIGHTFLAIL;
                case BASE_ITEM_LIGHTHAMMER: return FEAT_EPIC_OVERWHELMING_CRITICAL_LIGHTHAMMER;
                case BASE_ITEM_LIGHTMACE: return FEAT_EPIC_OVERWHELMING_CRITICAL_LIGHTMACE;
                case BASE_ITEM_LONGBOW: return FEAT_EPIC_OVERWHELMING_CRITICAL_LONGSWORD;
                case BASE_ITEM_LONGSWORD: return FEAT_EPIC_OVERWHELMING_CRITICAL_LONGBOW;
                case BASE_ITEM_MORNINGSTAR: return FEAT_EPIC_OVERWHELMING_CRITICAL_MORNINGSTAR;
                case BASE_ITEM_QUARTERSTAFF: return FEAT_EPIC_OVERWHELMING_CRITICAL_QUARTERSTAFF;
                case BASE_ITEM_RAPIER: return FEAT_EPIC_OVERWHELMING_CRITICAL_RAPIER;
                case BASE_ITEM_SCIMITAR: return FEAT_EPIC_OVERWHELMING_CRITICAL_SCIMITAR;
                case BASE_ITEM_SCYTHE: return FEAT_EPIC_OVERWHELMING_CRITICAL_SCYTHE;
                case BASE_ITEM_SHORTBOW: return FEAT_EPIC_OVERWHELMING_CRITICAL_SHORTBOW;
                case BASE_ITEM_SHORTSPEAR: return FEAT_EPIC_OVERWHELMING_CRITICAL_SHORTSPEAR;
                case BASE_ITEM_SHORTSWORD: return FEAT_EPIC_OVERWHELMING_CRITICAL_SHORTSWORD;
                case BASE_ITEM_SHURIKEN: return FEAT_EPIC_OVERWHELMING_CRITICAL_SHURIKEN;
                case BASE_ITEM_SICKLE: return FEAT_EPIC_OVERWHELMING_CRITICAL_SICKLE;
                case BASE_ITEM_SLING: return FEAT_EPIC_OVERWHELMING_CRITICAL_SLING;
                case BASE_ITEM_THROWINGAXE: return FEAT_EPIC_OVERWHELMING_CRITICAL_THROWINGAXE;
                case BASE_ITEM_TWOBLADEDSWORD: return FEAT_EPIC_OVERWHELMING_CRITICAL_TWOBLADEDSWORD;
                case BASE_ITEM_WARHAMMER: return FEAT_EPIC_OVERWHELMING_CRITICAL_WARHAMMER;
                case BASE_ITEM_WHIP: return -1;
                //case BASE_ITEM_WHIP: return FEAT_EPIC_OVERWHELMING_CRITICAL_WHIP;
            }

        else if(sFeat == "DevastatingCrit")
            switch(iType)
            {
                case BASE_ITEM_BASTARDSWORD: return FEAT_EPIC_DEVASTATING_CRITICAL_BASTARDSWORD;
                case BASE_ITEM_BATTLEAXE: return FEAT_EPIC_DEVASTATING_CRITICAL_BATTLEAXE;
                case BASE_ITEM_CLUB: return FEAT_EPIC_DEVASTATING_CRITICAL_CLUB;
                case BASE_ITEM_DAGGER: return FEAT_EPIC_DEVASTATING_CRITICAL_DAGGER;
                case BASE_ITEM_DART: return FEAT_EPIC_DEVASTATING_CRITICAL_DART;
                case BASE_ITEM_DIREMACE: return FEAT_EPIC_DEVASTATING_CRITICAL_DIREMACE;
                case BASE_ITEM_DOUBLEAXE: return FEAT_EPIC_DEVASTATING_CRITICAL_DOUBLEAXE;
                case BASE_ITEM_DWARVENWARAXE: return FEAT_EPIC_DEVASTATING_CRITICAL_DWAXE ;
                case BASE_ITEM_GREATAXE: return FEAT_EPIC_DEVASTATING_CRITICAL_GREATAXE;
                case BASE_ITEM_GREATSWORD: return FEAT_EPIC_DEVASTATING_CRITICAL_GREATSWORD;
                case BASE_ITEM_HALBERD: return FEAT_EPIC_DEVASTATING_CRITICAL_HALBERD;
                case BASE_ITEM_HANDAXE: return FEAT_EPIC_DEVASTATING_CRITICAL_HANDAXE;
                case BASE_ITEM_HEAVYCROSSBOW: return FEAT_EPIC_DEVASTATING_CRITICAL_HEAVYCROSSBOW;
                case BASE_ITEM_HEAVYFLAIL: return FEAT_EPIC_DEVASTATING_CRITICAL_HEAVYFLAIL;
                case BASE_ITEM_KAMA: return FEAT_EPIC_DEVASTATING_CRITICAL_KAMA;
                case BASE_ITEM_KATANA: return FEAT_EPIC_DEVASTATING_CRITICAL_KATANA;
                case BASE_ITEM_KUKRI: return FEAT_EPIC_DEVASTATING_CRITICAL_KUKRI;
                case BASE_ITEM_LIGHTCROSSBOW: return FEAT_EPIC_DEVASTATING_CRITICAL_LIGHTCROSSBOW;
                case BASE_ITEM_LIGHTFLAIL: return FEAT_EPIC_DEVASTATING_CRITICAL_LIGHTFLAIL;
                case BASE_ITEM_LIGHTHAMMER: return FEAT_EPIC_DEVASTATING_CRITICAL_LIGHTHAMMER;
                case BASE_ITEM_LIGHTMACE: return FEAT_EPIC_DEVASTATING_CRITICAL_LIGHTMACE;
                case BASE_ITEM_LONGBOW: return FEAT_EPIC_DEVASTATING_CRITICAL_LONGSWORD;
                case BASE_ITEM_LONGSWORD: return FEAT_EPIC_DEVASTATING_CRITICAL_LONGBOW;
                case BASE_ITEM_MORNINGSTAR: return FEAT_EPIC_DEVASTATING_CRITICAL_MORNINGSTAR;
                case BASE_ITEM_QUARTERSTAFF: return FEAT_EPIC_DEVASTATING_CRITICAL_QUARTERSTAFF;
                case BASE_ITEM_RAPIER: return FEAT_EPIC_DEVASTATING_CRITICAL_RAPIER;
                case BASE_ITEM_SCIMITAR: return FEAT_EPIC_DEVASTATING_CRITICAL_SCIMITAR;
                case BASE_ITEM_SCYTHE: return FEAT_EPIC_DEVASTATING_CRITICAL_SCYTHE;
                case BASE_ITEM_SHORTBOW: return FEAT_EPIC_DEVASTATING_CRITICAL_SHORTBOW;
                case BASE_ITEM_SHORTSPEAR: return FEAT_EPIC_DEVASTATING_CRITICAL_SHORTSPEAR;
                case BASE_ITEM_SHORTSWORD: return FEAT_EPIC_DEVASTATING_CRITICAL_SHORTSWORD;
                case BASE_ITEM_SHURIKEN: return FEAT_EPIC_DEVASTATING_CRITICAL_SHURIKEN;
                case BASE_ITEM_SICKLE: return FEAT_EPIC_DEVASTATING_CRITICAL_SICKLE;
                case BASE_ITEM_SLING: return FEAT_EPIC_DEVASTATING_CRITICAL_SLING;
                case BASE_ITEM_THROWINGAXE: return FEAT_EPIC_DEVASTATING_CRITICAL_THROWINGAXE;
                case BASE_ITEM_TWOBLADEDSWORD: return FEAT_EPIC_DEVASTATING_CRITICAL_TWOBLADEDSWORD;
                case BASE_ITEM_WARHAMMER: return FEAT_EPIC_DEVASTATING_CRITICAL_WARHAMMER;
                case BASE_ITEM_WHIP: return -1;
                //case BASE_ITEM_WHIP: return FEAT_EPIC_DEVASTATING_CRITICAL_WHIP;
            }

        else if(sFeat == "WeaponOfChoice")
            switch(iType)
            {
                case BASE_ITEM_BASTARDSWORD: return FEAT_WEAPON_OF_CHOICE_BASTARDSWORD;
                case BASE_ITEM_BATTLEAXE: return FEAT_WEAPON_OF_CHOICE_BATTLEAXE;
                case BASE_ITEM_CLUB: return FEAT_WEAPON_OF_CHOICE_CLUB;
                case BASE_ITEM_DAGGER: return FEAT_WEAPON_OF_CHOICE_DAGGER;
                case BASE_ITEM_DART: return -1;
                case BASE_ITEM_DIREMACE: return FEAT_WEAPON_OF_CHOICE_DIREMACE;
                case BASE_ITEM_DOUBLEAXE: return FEAT_WEAPON_OF_CHOICE_DOUBLEAXE;
                case BASE_ITEM_DWARVENWARAXE: return FEAT_WEAPON_OF_CHOICE_DWAXE ;
                case BASE_ITEM_GREATAXE: return FEAT_WEAPON_OF_CHOICE_GREATAXE;
                case BASE_ITEM_GREATSWORD: return FEAT_WEAPON_OF_CHOICE_GREATSWORD;
                case BASE_ITEM_HALBERD: return FEAT_WEAPON_OF_CHOICE_HALBERD;
                case BASE_ITEM_HANDAXE: return FEAT_WEAPON_OF_CHOICE_HANDAXE;
                case BASE_ITEM_HEAVYCROSSBOW: return -1;
                case BASE_ITEM_HEAVYFLAIL: return FEAT_WEAPON_OF_CHOICE_HEAVYFLAIL;
                case BASE_ITEM_KAMA: return FEAT_WEAPON_OF_CHOICE_KAMA;
                case BASE_ITEM_KATANA: return FEAT_WEAPON_OF_CHOICE_KATANA;
                case BASE_ITEM_KUKRI: return FEAT_WEAPON_OF_CHOICE_KUKRI;
                case BASE_ITEM_LIGHTCROSSBOW: return -1;
                case BASE_ITEM_LIGHTFLAIL: return FEAT_WEAPON_OF_CHOICE_LIGHTFLAIL;
                case BASE_ITEM_LIGHTHAMMER: return FEAT_WEAPON_OF_CHOICE_LIGHTHAMMER;
                case BASE_ITEM_LIGHTMACE: return FEAT_WEAPON_OF_CHOICE_LIGHTMACE;
                case BASE_ITEM_LONGBOW: return FEAT_WEAPON_OF_CHOICE_LONGSWORD;
                case BASE_ITEM_LONGSWORD: return -1;
                case BASE_ITEM_MORNINGSTAR: return FEAT_WEAPON_OF_CHOICE_MORNINGSTAR;
                case BASE_ITEM_QUARTERSTAFF: return FEAT_WEAPON_OF_CHOICE_QUARTERSTAFF;
                case BASE_ITEM_RAPIER: return FEAT_WEAPON_OF_CHOICE_RAPIER;
                case BASE_ITEM_SCIMITAR: return FEAT_WEAPON_OF_CHOICE_SCIMITAR;
                case BASE_ITEM_SCYTHE: return FEAT_WEAPON_OF_CHOICE_SCYTHE;
                case BASE_ITEM_SHORTBOW: return -1;
                case BASE_ITEM_SHORTSPEAR: return FEAT_WEAPON_OF_CHOICE_SHORTSPEAR;
                case BASE_ITEM_SHORTSWORD: return FEAT_WEAPON_OF_CHOICE_SHORTSWORD;
                case BASE_ITEM_SHURIKEN: return -1;
                case BASE_ITEM_SICKLE: return FEAT_WEAPON_OF_CHOICE_SICKLE;
                case BASE_ITEM_SLING: return -1;
                case BASE_ITEM_THROWINGAXE: return -1;
                case BASE_ITEM_TWOBLADEDSWORD: return FEAT_WEAPON_OF_CHOICE_TWOBLADEDSWORD;
                case BASE_ITEM_WARHAMMER: return FEAT_WEAPON_OF_CHOICE_WARHAMMER;
                case BASE_ITEM_WHIP: return -1;
                //case BASE_ITEM_WHIP: return FEAT_WEAPON_OF_CHOICE_WHIP;
            }

    return -1;
}

int GetWeaponCriticalRange(object oPC, object oWeap)
{
    int iType = GetBaseItemType(oWeap);
    int nThreat = StringToInt(Get2DAString("baseitems", "CritThreat", iType));
    int bKeen = GetItemHasItemProperty(oWeap, ITEM_PROPERTY_KEEN);
    int bImpCrit = GetHasFeat(GetFeatByWeaponType(iType, "ImprovedCrit"), oPC);
    int bIsWeaponOfChoice = GetHasFeat(GetFeatByWeaponType(iType, "WeaponOfChoice"), oPC);
    int bRangedWeap = FALSE;
    object oAmmo;

    if( GetBaseItemType(oWeap) == BASE_ITEM_LONGBOW || GetBaseItemType(oWeap) == BASE_ITEM_SHORTBOW )
    {
          oAmmo = GetItemInSlot(INVENTORY_SLOT_ARROWS, oPC);
          bRangedWeap = TRUE;
    }
    else if(GetBaseItemType(oWeap) == BASE_ITEM_LIGHTCROSSBOW || GetBaseItemType(oWeap) == BASE_ITEM_HEAVYCROSSBOW)
    {
         oAmmo = GetItemInSlot(INVENTORY_SLOT_BOLTS, oPC);
         bRangedWeap = TRUE;
    }
    else if(GetBaseItemType(oWeap) == BASE_ITEM_SLING)
    {
         oAmmo = GetItemInSlot(INVENTORY_SLOT_BULLETS, oPC);
         bRangedWeap = TRUE;
    }

    if(bRangedWeap)
    {
         // check ammo for keen
         bKeen = GetItemHasItemProperty(oAmmo, ITEM_PROPERTY_KEEN);
    }

    if(bIsWeaponOfChoice && GetLevelByClass(CLASS_TYPE_WEAPON_MASTER, oPC) > 7)
                 nThreat *= 2;
    if(bKeen)    nThreat *= 2;
    if(bImpCrit) nThreat *= 2;

    return (21 - nThreat);
}

int GetWeaponCritcalMultiplier(object oPC, object oWeap)
{
     int iWeaponType = GetBaseItemType(oWeap);
     int iCriticalMultiplier = StringToInt(Get2DAString("baseitems", "CritHitMult", iWeaponType));
     int bIsWeaponOfChoice = GetHasFeat(GetFeatByWeaponType(iWeaponType, "WeaponOfChoice"), oPC);

     if(bIsWeaponOfChoice && GetHasFeat(FEAT_INCREASE_MULTIPLIER, oPC) )
     {
          iCriticalMultiplier += 1;
     }

     return iCriticalMultiplier;
}

object GetAmmunitionFromWeapon(object oWeapon, object oAttacker)
{
     object oAmmo;

     // returns the proper ammunition slot based on oWeapon
     switch (GetBaseItemType(oWeapon) )
     {
          case BASE_ITEM_LIGHTCROSSBOW:
          case BASE_ITEM_HEAVYCROSSBOW:
               oAmmo = GetItemInSlot(INVENTORY_SLOT_BOLTS, oAttacker);
               break;
          case BASE_ITEM_SLING:
               oAmmo = GetItemInSlot(INVENTORY_SLOT_BULLETS, oAttacker);
               break;
          case BASE_ITEM_SHORTBOW:
          case BASE_ITEM_LONGBOW:
               oAmmo = GetItemInSlot(INVENTORY_SLOT_ARROWS, oAttacker);
               break;

          case BASE_ITEM_DART:
          case BASE_ITEM_SHURIKEN:
          case BASE_ITEM_THROWINGAXE:
               oAmmo = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oAttacker);
               break;
     }

     return oAmmo;
}

//:://////////////////////////////////////////////
//::  Combat Information Functions
//:://////////////////////////////////////////////

int GetMeleeAttackers15ft(object oPC = OBJECT_SELF)
{
    object oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION,REPUTATION_TYPE_ENEMY,oPC,1,CREATURE_TYPE_IS_ALIVE,TRUE);

   if (oTarget == OBJECT_INVALID) return FALSE;
   if ( GetDistanceBetween(oPC,oTarget)>3.0) return FALSE;

   return TRUE;
}

int GetIsInMeleeRange(object oDefender, object oAttacker)
{
     int bReturn = TRUE;
     float fDistance = GetDistanceBetween(oDefender, oAttacker);
     if(fDistance >= FeetToMeters(10.0) ) bReturn = FALSE;

     return bReturn;
}

int GetHasMonkWeaponEquipped(object oPC)
{
    int bIsMonkWeapon = FALSE;
    int iMonkLevel = GetLevelByClass(CLASS_TYPE_MONK, oPC);
    object oWeapR = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);

    if(iMonkLevel > 1 && GetBaseItemType(oWeapR) == BASE_ITEM_INVALID || GetBaseItemType(oWeapR) == BASE_ITEM_KAMA || GetBaseItemType(oWeapR) == BASE_ITEM_QUARTERSTAFF)
    {
         bIsMonkWeapon = TRUE;
    }

    return bIsMonkWeapon;
}

int GetMainHandAttacks(object oPC)
{
    int iBAB = GetBaseAttackBonus(oPC);
    int iCharLevel = GetHitDice(oPC);

    if (iCharLevel > 20)
    {
         iCharLevel -= 20;
         iCharLevel /= 2;
         iBAB -= iCharLevel;
    }

    int iNumAttacks = ( (iBAB - 1) / 5 ) + 1;
    if(iNumAttacks > 4)  iNumAttacks = 4;

    int iNumMonkAttack = 0;
    if( GetHasMonkWeaponEquipped(oPC) )
    {
         int iMonkLevel = GetLevelByClass(CLASS_TYPE_MONK, oPC);
         switch(iMonkLevel)
         {
              case 1:  iNumMonkAttack = 1;
              case 6:  iNumMonkAttack = 2;
              case 10: iNumMonkAttack = 3;
              case 14: iNumMonkAttack = 4;
              case 18: iNumMonkAttack = 5;
         }
    }

    if(iNumMonkAttack > iNumAttacks) iNumAttacks = iNumMonkAttack;

    return iNumAttacks;
}

int GetOffHandAttacks(object oPC)
{
     object oWeapR = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
     object oWeapL = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);

     int iMainHandAttacks =  GetMainHandAttacks(oPC);
     int iOffHandAttacks = 0;

     int bIsMeleeWeaponR = FALSE;
     int bIsMeleeWeaponL = FALSE;

     if(oWeapR != OBJECT_INVALID &&
        oWeapL != OBJECT_INVALID &&
        !GetWeaponRanged(oWeapR) &&
        GetBaseItemType(oWeapL) != BASE_ITEM_LARGESHIELD &&
        GetBaseItemType(oWeapL) != BASE_ITEM_SMALLSHIELD &&
        GetBaseItemType(oWeapL) != BASE_ITEM_TOWERSHIELD)
     {
          // they are wielding two weapons so at least 1 off-hand attack
          iOffHandAttacks = 1;

          if(GetLevelByClass(CLASS_TYPE_RANGER, oPC) > 8 )      iOffHandAttacks = 2;
          if(GetHasFeat(FEAT_IMPROVED_TWO_WEAPON_FIGHTING) )     iOffHandAttacks = 2;
          if(GetHasFeat(FEAT_GREATER_TWO_WEAPON_FIGHTING) ) iOffHandAttacks = 3;
          if(GetHasFeat(FEAT_SUPREME_TWO_WEAPON_FIGHTING) ) iOffHandAttacks = 4;

          if(iOffHandAttacks > iMainHandAttacks)
          {
               iOffHandAttacks = iMainHandAttacks;
          }
     }

     if( GetHasMonkWeaponEquipped(oPC) )
     {
          // prevents dual kama monk abuse
          iOffHandAttacks = 0;
     }

     return iOffHandAttacks;
}

int ConvAlignGr(int iGoodEvil,int iLawChaos)
{
   int Align;

   switch(iGoodEvil)
   {
    case ALIGNMENT_GOOD:
        Align = 0;
        break;
    case ALIGNMENT_NEUTRAL:
        Align = 1;
        break;
    case ALIGNMENT_EVIL:
        Align = 2;
        break;
   }
    switch(iLawChaos)
   {
    case ALIGNMENT_LAWFUL:
        Align += 0;
        break;
    case ALIGNMENT_NEUTRAL:
        Align += 3;
        break;
    case ALIGNMENT_CHAOTIC:
        Align += 6;
        break;
   }
   return Align;
}

//:://////////////////////////////////////////////
//::  Attack Bonus Functions
//:://////////////////////////////////////////////

int GetMagicalAttackBonus(object oAttacker)
{
     int iMagicBonus = 0;
     int nType = 0;
     int nSpell = 0;
     int iVal = 0;

     object eCaster;

     effect eEffect = GetFirstEffect(oAttacker);

     while(GetIsEffectValid(eEffect))
     {
          nType = GetEffectType(eEffect);
          nSpell = GetEffectSpellId(eEffect);

          if(nType == EFFECT_TYPE_ATTACK_INCREASE)
          {
                int iBonus = 0;
               switch(nSpell)
               {
                    case SPELL_AID:
                         iMagicBonus += 1;
                         break;

                    case SPELL_BLESS:
                         iMagicBonus += 1;
                         break;

                    case SPELL_PRAYER:
                         iMagicBonus += 1;
                         break;

                    case SPELL_WAR_CRY:
                         iMagicBonus += 2;
                         break;

                    case SPELL_BATTLETIDE:
                         iMagicBonus += 2;
                         break;

                    case SPELL_TRUE_STRIKE:
                         iMagicBonus += 20;
                         break;

                    case SPELL_DIVINE_PROTECTION:
                         iMagicBonus += 1;
                         break;

                    case SPELL_CREATE_MAGIC_TATOO:
                         iMagicBonus += 2;
                         break;

                    case SPELL_RECITATION:
                         iMagicBonus += 2;
                         break;

                    case SPELL_DIVINE_FAVOR:
                         iBonus = GetLevelByClass(CLASS_TYPE_PALADIN, oAttacker) + GetLevelByClass(CLASS_TYPE_CLERIC, oAttacker);
                         iBonus /= 3;
                         if(iBonus == 0) iBonus = 1;
                         if(iBonus > 5) iBonus = 5;

                         iMagicBonus += iBonus;
                         break;

                    case SPELL_DIVINE_POWER:
                         iBonus = GetHitDice(oAttacker) - GetBaseAttackBonus(oAttacker);
                         iMagicBonus += iBonus;
                         break;

                    // Cleric War Domain Power
                    case 380:
                          iBonus = GetLevelByClass(CLASS_TYPE_CLERIC, oAttacker);
                          iBonus /= 5;
                          iBonus = iBonus + 1;

                          iMagicBonus += iBonus;
                          break;

                     // SPELL_DIVINE_WRATH
                    case 622:
                         iBonus = GetLevelByClass(CLASS_TYPE_DIVINECHAMPION, oAttacker);
                         iBonus /= 5;
                         iBonus -= 1;
                         if(iBonus < 0) iBonus = 0;
                         else           iBonus *= 2;

                         iBonus += 3;
                         iMagicBonus += iBonus;
                         break;

                    case SPELL_TENSERS_TRANSFORMATION:
                         iBonus = GetLevelByClass(CLASS_TYPE_SORCERER, oAttacker) + GetLevelByClass(CLASS_TYPE_WIZARD, oAttacker);
                         iBonus /= 2;
                         iMagicBonus += iBonus;
                         break;

                     // Bard's Song
                    case 411:
                         eCaster = GetEffectCreator(eEffect);
                         if(GetIsObjectValid(eCaster))
                         {
                              int nLvl = GetLevelByClass(CLASS_TYPE_BARD, eCaster);
                              int iPerform = GetSkillRank(SKILL_PERFORM, eCaster);

                              if(nLvl >= 8 && iPerform >= 15) iMagicBonus += 2;
                              else                            iMagicBonus += 1;
                         }
                         else
                         {
                              iMagicBonus += 1;
                         }
                         break;
               }
          }

          else if(nType == EFFECT_TYPE_ATTACK_DECREASE)
          {
               switch(nSpell)
               {
                    case SPELL_BANE:
                         iMagicBonus -= 1;
                         break;

                    case SPELL_PRAYER:
                         iMagicBonus -= 1;
                         break;

                    case SPELL_FLARE:
                         iMagicBonus -= 1;
                         break;

                    case SPELL_GHOUL_TOUCH:
                         iMagicBonus -= 2;
                         break;

                    case SPELL_DOOM:
                         iMagicBonus -= 2;
                         break;

                    case SPELL_SCARE:
                         iMagicBonus -= 2;
                         break;

                    case SPELL_RECITATION:
                         iMagicBonus -= 2;
                         break;

                     case SPELL_BATTLETIDE:
                          iMagicBonus -= 2;
                          break;

                    case SPELL_CURSE_OF_PETTY_FAILING:
                         iMagicBonus -= 2;
                         break;

                    case SPELL_LEGIONS_CURSE_OF_PETTY_FAILING:
                         iMagicBonus -= 2;
                         break;

                    case SPELL_BESTOW_CURSE:
                         iMagicBonus -= 4;
                         break;

                    // SPELL_HELLINFERNO
                    case 762:
                         iMagicBonus -= 4;
                         break;

                    case SPELL_BIGBYS_INTERPOSING_HAND:
                         iMagicBonus -= 10;
                         break;

                    // Bard's Curse Song
                    case 644:
                         eCaster = GetEffectCreator(eEffect);
                         if(GetIsObjectValid(eCaster))
                         {
                              int nLvl = GetLevelByClass(CLASS_TYPE_BARD, eCaster);
                              int iPerform = GetSkillRank(SKILL_PERFORM, eCaster);

                              if(nLvl >= 8 && iPerform >= 15) iMagicBonus -= 2;
                              else                            iMagicBonus -= 1;
                         }
                         else
                         {
                              iMagicBonus -= 1;
                         }
                         break;

                    // Power Shot
                    case SPELL_PA_POWERSHOT:
                         iMagicBonus -= 5;
                         break;

                    case SPELL_PA_IMP_POWERSHOT:
                         iMagicBonus -= 10;
                         break;

                    case SPELL_PA_SUP_POWERSHOT:
                         iMagicBonus -= 15;
                         break;
               }

               // prevents power shot and power attack from stacking
               if(!GetHasFeatEffect(FEAT_PA_POWERSHOT, oAttacker) &&
                  !GetHasFeatEffect(FEAT_PA_IMP_POWERSHOT, oAttacker) &&
                  !GetHasFeatEffect(FEAT_PA_SUP_POWERSHOT, oAttacker) )
               {
                    switch(nSpell)
                    {
                         case SPELL_POWER_ATTACK10:
                              iMagicBonus -= 10;
                              break;
                         case SPELL_POWER_ATTACK9:
                              iMagicBonus -= 9;
                              break;
                         case SPELL_POWER_ATTACK8:
                              iMagicBonus -= 8;
                              break;
                         case SPELL_POWER_ATTACK7:
                              iMagicBonus -= 7;
                              break;
                         case SPELL_POWER_ATTACK6:
                              iMagicBonus -= 6;
                              break;
                         case SPELL_POWER_ATTACK5:
                              iMagicBonus -= 5;
                              break;
                         case SPELL_POWER_ATTACK4:
                              iMagicBonus -= 4;
                              break;
                         case SPELL_POWER_ATTACK3:
                              iMagicBonus -= 3;
                              break;
                         case SPELL_POWER_ATTACK2:
                              iMagicBonus -= 2;
                              break;
                         case SPELL_POWER_ATTACK1:
                              iMagicBonus -= 1;
                              break;
                         case SPELL_SUPREME_POWER_ATTACK:
                              iMagicBonus -= 10;
                              break;
                    }
               }
          }

          eEffect = GetNextEffect(oAttacker);
     }

     return iVal;
}

int GetWeaponAttackBonusItemProperty(object oWeap, object oDefender)
{
    int iBonus = 0;
    int iTemp;
    int bIsPenalty = FALSE;

    int iRace = MyPRCGetRacialType(oDefender);

    int iGoodEvil = GetAlignmentGoodEvil(oDefender);
    int iLawChaos = GetAlignmentLawChaos(oDefender);
    int iAlignSpecific = ConvAlignGr(iGoodEvil, iLawChaos);
    int iAlignGroup;

    itemproperty ip = GetFirstItemProperty(oWeap);
    while(GetIsItemPropertyValid(ip))
    {
        int iIp=GetItemPropertyType(ip);
        switch(iIp)
        {
            case ITEM_PROPERTY_ATTACK_BONUS:
                iTemp = GetItemPropertyCostTableValue(ip);
                bIsPenalty = FALSE;
                break;

            case ITEM_PROPERTY_DECREASED_ATTACK_MODIFIER:
                iTemp = GetItemPropertyCostTableValue(ip);
                bIsPenalty = TRUE;
                break;

            case ITEM_PROPERTY_ATTACK_BONUS_VS_ALIGNMENT_GROUP:
                iAlignGroup = GetItemPropertySubType(ip);

                if (iAlignGroup == ALIGNMENT_NEUTRAL)
                {
                   if (iAlignGroup == iLawChaos)   iTemp = GetItemPropertyCostTableValue(ip);
                   bIsPenalty = FALSE;
                }
                else if (iAlignGroup == iGoodEvil || iAlignGroup == iLawChaos || iAlignGroup == IP_CONST_ALIGNMENTGROUP_ALL)
                {
                   iTemp = GetItemPropertyCostTableValue(ip);
                   bIsPenalty = FALSE;
                }
                break;

            case ITEM_PROPERTY_ATTACK_BONUS_VS_RACIAL_GROUP:
                if(GetItemPropertySubType(ip) == iRace )
                {
                     iTemp = GetItemPropertyCostTableValue(ip);
                     bIsPenalty = FALSE;
                }
                else
                {
                     iTemp = 0;
                }
                break;

            case ITEM_PROPERTY_ATTACK_BONUS_VS_SPECIFIC_ALIGNMENT:
                if(GetItemPropertySubType(ip) == iAlignSpecific )
                {
                     iTemp = GetItemPropertyCostTableValue(ip);
                     bIsPenalty = FALSE;
                }
                else
                {
                     iTemp = 0;
                }
                break;
        }

        if(iTemp > iBonus || bIsPenalty)  iBonus = iTemp;
        ip = GetNextItemProperty(oWeap);
    }

    return iBonus;
}

int GetAttackBonus(object oDefender, object oAttacker, object oWeap, int iMainHand = 0)
{
     int iAttackBonus = 0;
     int iStatMod = 0;
     int iBAB = GetBaseAttackBonus(oAttacker);
     int iWeaponAttackBonus = GetWeaponAttackBonusItemProperty(oWeap, oDefender);
     int iWeaponType = GetBaseItemType(oWeap);

     int iStr = GetAbilityModifier(ABILITY_STRENGTH, oAttacker);
     int iDex = GetAbilityModifier(ABILITY_DEXTERITY, oAttacker);
     int iCha = GetAbilityModifier(ABILITY_CHARISMA, oAttacker);
     int iWis = GetAbilityModifier(ABILITY_WISDOM, oAttacker);

     int bIsRangedWeapon = GetWeaponRanged(oWeap);

     int bFinesse = GetHasFeat(FEAT_WEAPON_FINESSE, oAttacker);
     int bKatanaFinesse = GetHasFeat(FEAT_KATANA_FINESSE, oAttacker);
     int bInuitiveAttack = GetHasFeat(FEAT_INTUITIVE_ATTACK, oAttacker);
     int bZenArchery = GetHasFeat(FEAT_ZEN_ARCHERY, oAttacker);
     int bPointBlankShot = GetHasFeat(FEAT_POINT_BLANK_SHOT,oAttacker);
     int bIsInMelee = GetMeleeAttackers15ft(oAttacker);

     // cache result, might increase speed if this is an issue
     int bLight = StringToInt(Get2DAString("baseitems", "WeaponSize", iWeaponType)) <= 2 || iWeaponType == BASE_ITEM_RAPIER;

     int iEnhancement = GetWeaponEnhancement(oWeap, oDefender, oAttacker);

     int bFocus = GetHasFeat(GetFeatByWeaponType(iWeaponType, "Focus"), oAttacker);
     int bEpicFocus = GetHasFeat(GetFeatByWeaponType(iWeaponType, "EpicFocus"), oAttacker);
     int bEpicProwess = GetHasFeat(FEAT_EPIC_PROWESS, oAttacker);

     int bWeaponOfChoice = GetHasFeat(GetFeatByWeaponType(iWeaponType, "WeaponOfChoice"), oAttacker);

     // increases attack bonus from feats
     iAttackBonus += iBAB;
     iAttackBonus += iWeaponAttackBonus;
     if(bFocus) iAttackBonus       += 1;
     if(bEpicFocus) iAttackBonus   += 2;
     if(bEpicProwess) iAttackBonus += 1;

     int bTempBonus = 0;
     // increases attack bonus from stats for melee
     // first check for weapon finesse or katana finesse and if str or dex is greater
     if((bFinesse && bLight && !bIsRangedWeapon) || (bKatanaFinesse && !bIsRangedWeapon))
     {
          if(iStr > bTempBonus) bTempBonus = iStr;
          if(iDex > bTempBonus) bTempBonus = iDex;
     }

     // if they have intuitive attack feat, checks if wisdom is highest
     if(bInuitiveAttack &&  !bIsRangedWeapon)
     {
          if(iWis > bTempBonus) bTempBonus = iWis;
     }

     iAttackBonus += bTempBonus;

     // Melee Specific Rules
     if(!bIsRangedWeapon)
     {
           // Two Weapon Fighting Penalties
           // NwN only allows melee weapons to be dual wielded

           object oWeapL = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oAttacker);

           if(oWeapL != OBJECT_INVALID)
           {
                // has two weapons
                // Absolute ambidex is covered in AB on player scripts

                object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oAttacker);
                int armorType = GetArmorType(oArmor);
                int bHasTWF;
                int bHasAmbidex;

                // since there is no way to determine the value of AB effects
                // applied to a PC, I had to add Absolute Ambidexterity here

                int bHasAbsoluteAmbidex;

                if(GetHasFeat(FEAT_AMBIDEXTERITY, oAttacker) )        bHasTWF = TRUE;
                if(GetHasFeat(FEAT_TWO_WEAPON_FIGHTING, oAttacker) )  bHasAmbidex = TRUE;
                if(GetHasFeat(FEAT_ABSOLUTE_AMBIDEX, oAttacker) )     bHasAbsoluteAmbidex = TRUE;

                if(GetLevelByClass(CLASS_TYPE_RANGER, oAttacker) > 1 && armorType < ARMOR_TYPE_MEDIUM)
                {
                     bHasTWF = TRUE;
                     bHasAmbidex = TRUE;
                }

                int iOffHandWeapType = GetBaseItemType(oWeapL);
                int bOffHandLight = StringToInt(Get2DAString("baseitems", "WeaponSize", iOffHandWeapType)) <= 2 || iOffHandWeapType == BASE_ITEM_RAPIER;

                int iAttackPenalty;

                if(iMainHand)   iAttackPenalty = 6;
                else            iAttackPenalty = 10;

                if(bHasAmbidex && !iMainHand)  iAttackPenalty -= 4;
                if(bHasTWF)                    iAttackPenalty -= 2;
                if(bOffHandLight)              iAttackPenalty -= 2;
                if(bHasAbsoluteAmbidex)        iAttackPenalty -= 2;

                iAttackBonus -= iAttackPenalty;
           }
     }
     // Ranged Specific Rules
     else if(bIsRangedWeapon)
     {
          // range penalty not yet accounted for as the 2da's are messed up
          // the range increment for throwing axes is 63, while it's 20 for bows???

          // dex or wis bonus
          if(bZenArchery && iWis > iDex)   iAttackBonus += iWis;
          else                             iAttackBonus += iDex;

          if(bIsInMelee)
          {
               if(bPointBlankShot)         iAttackBonus += 1;
               else                        iAttackBonus -= 4;
          }

          // Halfling +1 bonus for throwing weapons
          int bHasGoodAIM = GetHasFeat(FEAT_GOOD_AIM, oAttacker);
          int bHasThrowingWeapon = FALSE;


          int itemType = GetBaseItemType(oWeap);
          // returns Throwing Weapons
          switch ( itemType )
          {
               case BASE_ITEM_DART:
                    bHasThrowingWeapon = TRUE;
                    break;
               case BASE_ITEM_SHURIKEN:
                    bHasThrowingWeapon = TRUE;
                    break;
               case BASE_ITEM_THROWINGAXE:
                    bHasThrowingWeapon = TRUE;
                    break;
          }

          if(bHasGoodAIM && bHasThrowingWeapon)  iAttackBonus += 1;

          // Archer Primary Weapon: Bow
          if (itemType == BASE_ITEM_SHORTBOW || itemType == BASE_ITEM_LONGBOW)
          {
               if (GetHasFeat(FEAT_BOWSPEC9, oAttacker))
                    iAttackBonus += 9;
               else if (GetHasFeat(FEAT_BOWSPEC8, oAttacker))
                    iAttackBonus += 8;
               else if (GetHasFeat(FEAT_BOWSPEC7, oAttacker))
                    iAttackBonus += 7;
               else if (GetHasFeat(FEAT_BOWSPEC6, oAttacker))
                    iAttackBonus += 6;
               else if (GetHasFeat(FEAT_BOWSPEC5, oAttacker))
                    iAttackBonus += 5;
               else if (GetHasFeat(FEAT_BOWSPEC4, oAttacker))
                    iAttackBonus += 4;
               else if (GetHasFeat(FEAT_BOWSPEC3, oAttacker))
                    iAttackBonus += 3;
               else if (GetHasFeat(FEAT_BOWSPEC2, oAttacker))
                    iAttackBonus += 2;

               if (GetHasFeat(FEAT_BOWMASTERY, oAttacker))
                    iAttackBonus += 1;
          }

     }

     // adds weapon enhancement to the bonus
     iAttackBonus += iEnhancement;

     // code for adding bonus of Weapon of Choice
     if(bWeaponOfChoice)  iAttackBonus += (GetLevelByClass(CLASS_TYPE_WEAPON_MASTER, oAttacker) / 5);

     // Adds all spell bonuses / penalties on the PC
     iAttackBonus += GetMagicalAttackBonus(oAttacker);

     // support for power attack and expertise modes
     int iCombatMode = GetLastAttackMode(oAttacker);
     if( iCombatMode == COMBAT_MODE_POWER_ATTACK &&
         !GetHasSpellEffect(SPELL_SUPREME_POWER_ATTACK) &&
         !GetHasSpellEffect(SPELL_POWER_ATTACK10) &&
         !GetHasSpellEffect(SPELL_POWER_ATTACK9)  &&
         !GetHasSpellEffect(SPELL_POWER_ATTACK8)  &&
         !GetHasSpellEffect(SPELL_POWER_ATTACK7)  &&
         !GetHasSpellEffect(SPELL_POWER_ATTACK6)  &&
         !GetHasSpellEffect(SPELL_POWER_ATTACK5)  &&
         !GetHasSpellEffect(SPELL_POWER_ATTACK4)  &&
         !GetHasSpellEffect(SPELL_POWER_ATTACK3)  &&
         !GetHasSpellEffect(SPELL_POWER_ATTACK2)  &&
         !GetHasSpellEffect(SPELL_POWER_ATTACK1) )
     {
          iAttackBonus -= 5;
     }
     else if( iCombatMode == COMBAT_MODE_IMPROVED_POWER_ATTACK &&
         !GetHasSpellEffect(SPELL_SUPREME_POWER_ATTACK) &&
         !GetHasSpellEffect(SPELL_POWER_ATTACK10) &&
         !GetHasSpellEffect(SPELL_POWER_ATTACK9)  &&
         !GetHasSpellEffect(SPELL_POWER_ATTACK8)  &&
         !GetHasSpellEffect(SPELL_POWER_ATTACK7)  &&
         !GetHasSpellEffect(SPELL_POWER_ATTACK6)  &&
         !GetHasSpellEffect(SPELL_POWER_ATTACK5)  &&
         !GetHasSpellEffect(SPELL_POWER_ATTACK4)  &&
         !GetHasSpellEffect(SPELL_POWER_ATTACK3)  &&
         !GetHasSpellEffect(SPELL_POWER_ATTACK2)  &&
         !GetHasSpellEffect(SPELL_POWER_ATTACK1) )
     {
          iAttackBonus -= 10;
     }

     if(iCombatMode == COMBAT_MODE_EXPERTISE) iAttackBonus -= 5;
     else if(iCombatMode == COMBAT_MODE_IMPROVED_EXPERTISE) iAttackBonus -= 10;

     return iAttackBonus;
}

int GetAttackRoll(object oDefender, object oAttacker, object oWeapon, int iMainHand = 0, int iAttackBonus = 0, int iMod = 0, int bShowFeedback = TRUE, float fDelay = 0.0)
{
     if (iAttackBonus == 0)
     {
         iAttackBonus = GetAttackBonus(oDefender, oAttacker, oWeapon, iMainHand);
     }

     iAttackBonus += iMod;

     // Moved this to GetAttackRoll since it needs to be checked
     // every attack instead of each round.
     // add bonus for flanking +2 or invisible +4
     if( GetIsFlanked(oDefender, oAttacker) ) iAttackBonus += 2;
     if( GetHasEffect(EFFECT_TYPE_INVISIBILITY, oAttacker) ||
         GetHasEffect(EFFECT_TYPE_IMPROVEDINVISIBILITY, oAttacker)  ) iAttackBonus += 4;

     // Battle training (Gnomes and Dwarves)
     // adds +1 based on enemy race
     if(MyPRCGetRacialType(oAttacker) == RACIAL_TYPE_DWARF || MyPRCGetRacialType(oAttacker) == RACIAL_TYPE_GNOME)
     {
          int bOrcTrain = GetHasFeat(FEAT_BATTLE_TRAINING_VERSUS_ORCS, oAttacker);
          int bGobTrain = GetHasFeat(FEAT_BATTLE_TRAINING_VERSUS_GOBLINS, oAttacker);
          int bLizTrain = GetHasFeat(FEAT_BATTLE_TRAINING_VERSUS_REPTILIANS, oAttacker);
          int iEnemyRace = MyPRCGetRacialType(oDefender);

          if(bOrcTrain && iEnemyRace == RACIAL_TYPE_HUMANOID_ORC)         iAttackBonus += 1;
          if(bGobTrain && iEnemyRace == RACIAL_TYPE_HUMANOID_GOBLINOID)   iAttackBonus += 1;
          if(bLizTrain && iEnemyRace == RACIAL_TYPE_HUMANOID_REPTILIAN)   iAttackBonus += 1;
     }

     int iDiceRoll = d20();
     int iEnemyAC = GetAC(oDefender);

     int iType = GetBaseItemType(oWeapon);
     int iCritThreat = GetWeaponCriticalRange(oAttacker, oWeapon);

     string sFeedback ="";
     if(iMainHand == 1) sFeedback += "<cþf >Off Hand : ";

     sFeedback += "<c™þþ>" + GetName(oAttacker) + "<cþf > attacks " + GetName(oDefender) + ": ";
     int iReturn = 0;

     //Check for a critical threat
     if(iDiceRoll >= iCritThreat && iDiceRoll + iAttackBonus > iEnemyAC && iDiceRoll != 1)
     {
          sFeedback += "*Critical Hit*: (" + IntToString(iDiceRoll) + " + " + IntToString(iAttackBonus) + " = " + IntToString(iDiceRoll + iAttackBonus) + "): ";
          //Roll again to see if we scored a critical hit
          iDiceRoll = d20();

          if(!GetIsImmune(oDefender, IMMUNITY_TYPE_CRITICAL_HIT) )
          {
               sFeedback += "*Threat Roll*: (" + IntToString(iDiceRoll) + " + " + IntToString(iAttackBonus) + " = " + IntToString(iDiceRoll + iAttackBonus) + ")";
               if(iDiceRoll + iAttackBonus > iEnemyAC)  iReturn = 2;
               else                                     iReturn = 1;
          }
          else
          {
               sFeedback += "*Target Immune to Critical Hits*";
               iReturn = 1;
          }
     }

     //Just a regular hit
     else if(iDiceRoll + iAttackBonus > iEnemyAC && iDiceRoll != 1)
     {
         sFeedback += "*Hit*: (" + IntToString(iDiceRoll) + " + " + IntToString(iAttackBonus) + " = " + IntToString(iDiceRoll + iAttackBonus) + ")";
         iReturn = 1;
     }

     //Missed
     else
     {
         sFeedback += "*Miss*: (" + IntToString(iDiceRoll) + " + " + IntToString(iAttackBonus) + " = " + IntToString(iDiceRoll + iAttackBonus) + ")";
         iReturn = 0;
     }

     if(bShowFeedback) DelayCommand(fDelay, SendMessageToPC(oAttacker, sFeedback));
     return iReturn;
}

//:://////////////////////////////////////////////
//::  Damage Bonus Functions
//:://////////////////////////////////////////////

int GetFavoredEnemeyDamageBonus(object oDefender, object oAttacker)
{
     int iDamageBonus = 0;
     int bIsFavoredEnemy = FALSE;
     int bCanHaveFavoredEnemy = FALSE;

     if(GetLevelByClass(CLASS_TYPE_HARPER, oAttacker) )   bCanHaveFavoredEnemy = TRUE;
     else if(GetLevelByClass(CLASS_TYPE_RANGER, oAttacker) )   bCanHaveFavoredEnemy = TRUE;

     // Additional PRC's
     // else if(GetLevelByClass(CLASS_TYPE_*, oAttacker) )   bCanHaveFavoredEnemy = TRUE;


     // Exit if the class can not have a favored enemy
     // Prevents lots of useless code from running
     if(!bCanHaveFavoredEnemy)
     {
          return iDamageBonus;
     }

     float fDistance = GetDistanceBetween(oAttacker, oDefender);
     if(fDistance <= FeetToMeters(30.0f) )
     {
          if(GetHasFeat(FEAT_FAVORED_ENEMY_DWARF, oAttacker))
          {
               iDamageBonus += 1;
               if(MyPRCGetRacialType(oDefender) == RACIAL_TYPE_DWARF)     bIsFavoredEnemy = TRUE;
          }
          if(GetHasFeat(FEAT_FAVORED_ENEMY_ELF, oAttacker))
          {
               iDamageBonus += 1;
               if(MyPRCGetRacialType(oDefender) == RACIAL_TYPE_ELF)     bIsFavoredEnemy = TRUE;
          }
          if(GetHasFeat(FEAT_FAVORED_ENEMY_GNOME, oAttacker))
          {
               iDamageBonus += 1;
               if(MyPRCGetRacialType(oDefender) == RACIAL_TYPE_GNOME)     bIsFavoredEnemy = TRUE;
          }
          if(GetHasFeat(FEAT_FAVORED_ENEMY_HALFLING, oAttacker))
          {
               iDamageBonus += 1;
               if(MyPRCGetRacialType(oDefender) == RACIAL_TYPE_HALFLING)     bIsFavoredEnemy = TRUE;
          }
          if(GetHasFeat(FEAT_FAVORED_ENEMY_HALFELF, oAttacker))
          {
               iDamageBonus += 1;
               if(MyPRCGetRacialType(oDefender) == RACIAL_TYPE_HALFELF)     bIsFavoredEnemy = TRUE;
          }
          if(GetHasFeat(FEAT_FAVORED_ENEMY_HALFORC, oAttacker))
          {
               iDamageBonus += 1;
               if(MyPRCGetRacialType(oDefender) == RACIAL_TYPE_HALFORC)     bIsFavoredEnemy = TRUE;
          }
          if(GetHasFeat(FEAT_FAVORED_ENEMY_HUMAN, oAttacker))
          {
               iDamageBonus += 1;
               if(MyPRCGetRacialType(oDefender) == RACIAL_TYPE_HUMAN)     bIsFavoredEnemy = TRUE;
          }
          if(GetHasFeat(FEAT_FAVORED_ENEMY_ABERRATION, oAttacker))
          {
               iDamageBonus += 1;
               if(MyPRCGetRacialType(oDefender) == RACIAL_TYPE_ABERRATION)     bIsFavoredEnemy = TRUE;
          }
          if(GetHasFeat(FEAT_FAVORED_ENEMY_ANIMAL, oAttacker))
          {
               iDamageBonus += 1;
               if(MyPRCGetRacialType(oDefender) == RACIAL_TYPE_ANIMAL)     bIsFavoredEnemy = TRUE;
          }
          if(GetHasFeat(FEAT_FAVORED_ENEMY_BEAST, oAttacker))
          {
               iDamageBonus += 1;
               if(MyPRCGetRacialType(oDefender) == RACIAL_TYPE_BEAST)     bIsFavoredEnemy = TRUE;
          }
          if(GetHasFeat(FEAT_FAVORED_ENEMY_CONSTRUCT, oAttacker))
          {
               iDamageBonus += 1;
               if(MyPRCGetRacialType(oDefender) == RACIAL_TYPE_CONSTRUCT)     bIsFavoredEnemy = TRUE;
          }
          if(GetHasFeat(FEAT_FAVORED_ENEMY_DRAGON, oAttacker))
          {
               iDamageBonus += 1;
               if(MyPRCGetRacialType(oDefender) == RACIAL_TYPE_DRAGON)     bIsFavoredEnemy = TRUE;
          }
          if(GetHasFeat(FEAT_FAVORED_ENEMY_GOBLINOID, oAttacker))
          {
               iDamageBonus += 1;
               if(MyPRCGetRacialType(oDefender) == RACIAL_TYPE_HUMANOID_GOBLINOID)     bIsFavoredEnemy = TRUE;
          }
          if(GetHasFeat(FEAT_FAVORED_ENEMY_MONSTROUS, oAttacker))
          {
               iDamageBonus += 1;
               if(MyPRCGetRacialType(oDefender) == RACIAL_TYPE_HUMANOID_MONSTROUS)     bIsFavoredEnemy = TRUE;
          }
          if(GetHasFeat(FEAT_FAVORED_ENEMY_ORC, oAttacker))
          {
               iDamageBonus += 1;
               if(MyPRCGetRacialType(oDefender) == RACIAL_TYPE_HUMANOID_ORC)     bIsFavoredEnemy = TRUE;
          }
          if(GetHasFeat(FEAT_FAVORED_ENEMY_REPTILIAN, oAttacker))
          {
               iDamageBonus += 1;
               if(MyPRCGetRacialType(oDefender) == RACIAL_TYPE_HUMANOID_REPTILIAN)     bIsFavoredEnemy = TRUE;
          }
          if(GetHasFeat(FEAT_FAVORED_ENEMY_ELEMENTAL, oAttacker))
          {
               iDamageBonus += 1;
               if(MyPRCGetRacialType(oDefender) == RACIAL_TYPE_ELEMENTAL)     bIsFavoredEnemy = TRUE;
          }
          if(GetHasFeat(FEAT_FAVORED_ENEMY_FEY, oAttacker))
          {
               iDamageBonus += 1;
               if(MyPRCGetRacialType(oDefender) == RACIAL_TYPE_FEY)     bIsFavoredEnemy = TRUE;
          }
          if(GetHasFeat(FEAT_FAVORED_ENEMY_GIANT, oAttacker))
          {
               iDamageBonus += 1;
               if(MyPRCGetRacialType(oDefender) == RACIAL_TYPE_GIANT)     bIsFavoredEnemy = TRUE;
          }
          if(GetHasFeat(FEAT_FAVORED_ENEMY_MAGICAL_BEAST, oAttacker))
          {
               iDamageBonus += 1;
               if(MyPRCGetRacialType(oDefender) == RACIAL_TYPE_MAGICAL_BEAST)     bIsFavoredEnemy = TRUE;
          }
          if(GetHasFeat(FEAT_FAVORED_ENEMY_OUTSIDER, oAttacker))
          {
               iDamageBonus += 1;
               if(MyPRCGetRacialType(oDefender) == RACIAL_TYPE_OUTSIDER)     bIsFavoredEnemy = TRUE;
          }
          if(GetHasFeat(FEAT_FAVORED_ENEMY_SHAPECHANGER, oAttacker))
          {
               iDamageBonus += 1;
               if(MyPRCGetRacialType(oDefender) == RACIAL_TYPE_SHAPECHANGER)     bIsFavoredEnemy = TRUE;
          }
          if(GetHasFeat(FEAT_FAVORED_ENEMY_UNDEAD, oAttacker))
          {
               iDamageBonus += 1;
               if(MyPRCGetRacialType(oDefender) == RACIAL_TYPE_UNDEAD)     bIsFavoredEnemy = TRUE;
          }
          if(GetHasFeat(FEAT_FAVORED_ENEMY_VERMIN, oAttacker))
          {
               iDamageBonus += 1;
               if(MyPRCGetRacialType(oDefender) == RACIAL_TYPE_VERMIN)     bIsFavoredEnemy = TRUE;
          }
     }

     if(!bIsFavoredEnemy)
     {
          iDamageBonus = 0;
     }

     return iDamageBonus;
}

int GetMightyWeaponBonus(object oWeap)
{
     int iMighty = 0;
     int iTemp = 0;
     itemproperty ip = GetFirstItemProperty(oWeap);
     while(GetIsItemPropertyValid(ip))
     {
          if(GetItemPropertyType(ip) == ITEM_PROPERTY_MIGHTY)
               iTemp = GetItemPropertyCostTableValue(ip);

          if(iTemp > iMighty) iMighty = iTemp;

          ip = GetNextItemProperty(oWeap);
     }
     return iMighty;
}

int GetWeaponEnhancement(object oWeapon, object oDefender, object oAttacker)
{
     int iEnhancement = -1;
     int iTemp;
     int bIsPenalty = FALSE;

     int iRace = MyPRCGetRacialType(oDefender);

     int iGoodEvil = GetAlignmentGoodEvil(oDefender);
     int iLawChaos = GetAlignmentLawChaos(oDefender);
     int iAlignSp  = ConvAlignGr(iGoodEvil,iLawChaos);
     int iAlignGr;

     itemproperty ip = GetFirstItemProperty(oWeapon);
     while(GetIsItemPropertyValid(ip))
     {
         int iItemPropType = GetItemPropertyType(ip);
         switch(iItemPropType)
         {
             case ITEM_PROPERTY_ENHANCEMENT_BONUS:
                 iTemp = GetDamageByConstant(GetItemPropertyCostTableValue(ip), TRUE);
                 bIsPenalty = FALSE;
                 break;

             case ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_SPECIFIC_ALIGNEMENT:
                  if(GetItemPropertySubType(ip) == iAlignSp) iTemp = GetItemPropertyCostTableValue(ip);
                  else                                       iTemp = 0;
                  break;

             case ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_ALIGNMENT_GROUP:
                  iAlignGr = GetItemPropertySubType(ip);
                  if (iAlignGr == ALIGNMENT_NEUTRAL)
                  {
                       if (iAlignGr == iLawChaos)  iTemp = GetDamageByConstant(GetItemPropertyCostTableValue(ip), TRUE);
                  }
                  else if (iAlignGr == iGoodEvil || iAlignGr == iLawChaos || iAlignGr == IP_CONST_ALIGNMENTGROUP_ALL)
                         iTemp = GetDamageByConstant(GetItemPropertyCostTableValue(ip), TRUE);
                  break;

             case ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_RACIAL_GROUP:
                  if(GetItemPropertySubType(ip) == iRace) iTemp = GetItemPropertyCostTableValue(ip);
                  else                                    iTemp = 0;
                  break;

             // detects holy avenger property and adds proper enhancement bonus
             case ITEM_PROPERTY_HOLY_AVENGER:
                  iTemp = 5;
                  break;

             case ITEM_PROPERTY_DECREASED_ENHANCEMENT_MODIFIER:
                  iTemp = (GetDamageByConstant(GetItemPropertyCostTableValue(ip), TRUE)) * -1;
                  bIsPenalty = TRUE;
                  break;
         }

         if(iTemp > iEnhancement || bIsPenalty)   iEnhancement = iTemp;

         ip = GetNextItemProperty(oWeapon);
     }

     // if defaults are still set then the bonus is 0
     if(iEnhancement == -1 && !bIsPenalty) iEnhancement == 0;

     //if ranged check for ammo
     if(GetWeaponRanged(oWeapon) )
     {
         // Adds ammo bonus if it is higher than weapon bonus
         int iAmmoEnhancement = GetAmmunitionEnhancement(oWeapon, oDefender, oAttacker);
         if(iAmmoEnhancement > iEnhancement) iEnhancement = iAmmoEnhancement;

         // Arcane Archer Enchant Arrow Bonus
         int iAALevel = GetLevelByClass(CLASS_TYPE_ARCANE_ARCHER, oAttacker);
         int iAAEnchantArrow = 0;

         if(iAALevel > 0) iAAEnchantArrow = ((iAALevel + 1) / 2);
         if(iAAEnchantArrow > iEnhancement) iEnhancement = iAAEnchantArrow;
     }

     return iEnhancement;
}

int GetMonkEnhancement(object oWeapon, object oDefender, object oAttacker)
{
     int iMonkEnhancement = GetWeaponEnhancement(oWeapon, oDefender, oAttacker);
     int iTemp;

     // returns enhancement bonus for ki strike
     if(GetBaseItemType(oWeapon) == BASE_ITEM_GLOVES ||
        GetBaseItemType(oWeapon) == BASE_ITEM_CBLUDGWEAPON ||
        GetBaseItemType(oWeapon) == BASE_ITEM_CSLASHWEAPON ||
        GetBaseItemType(oWeapon) == BASE_ITEM_CSLSHPRCWEAP )
     {
          if(GetHasFeat(FEAT_EPIC_IMPROVED_KI_STRIKE_5, oAttacker)) iTemp = 5;
          else if(GetHasFeat(FEAT_EPIC_IMPROVED_KI_STRIKE_4, oAttacker)) iTemp = 4;
          else if(GetHasFeat(FEAT_KI_STRIKE, oAttacker) )
          {
               int iMonkLevel = GetLevelByClass(CLASS_TYPE_MONK, oAttacker);
               iTemp = 1;
               if(iMonkLevel > 12) iTemp = 2;
               if(iMonkLevel > 15) iTemp = 3;
          }
          if(iTemp > iMonkEnhancement) iMonkEnhancement = iTemp;
     }

     return iMonkEnhancement;
}

int GetDamagePowerConstant(object oWeapon, object oDefender, object oAttacker)
{
     int iDamagePower = GetMonkEnhancement(oWeapon, oDefender, oAttacker);

     // Determine Damage Power (Enhancement Bonus of Weapon)
     // Damage Power 6 is Magical and hits everything
     // So for +6 and higher are actually 7-21, so add +1
     if(iDamagePower > 5) iDamagePower += 1;
     if(iDamagePower <0 ) iDamagePower = 0;

     return iDamagePower;
}

int GetAmmunitionEnhancement(object oWeapon, object oDefender, object oAttacker)
{
    int iTemp;
    int iBonus, iDamageType;
    int iType = GetBaseItemType(oWeapon);


    int iRace = MyPRCGetRacialType(oDefender);

    int iGoodEvil = GetAlignmentGoodEvil(oDefender);
    int iLawChaos = GetAlignmentLawChaos(oDefender);
    int iAlignSp  = ConvAlignGr(iGoodEvil, iLawChaos);
    int iAlignGr;

    object oAmmu = GetAmmunitionFromWeapon(oWeapon, oAttacker);
    int iBase = GetBaseItemType(oAmmu);

    //Get Damage Bonus Properties from oWeapon
    itemproperty ip = GetFirstItemProperty(oWeapon);
    while(GetIsItemPropertyValid(ip))
    {
          int iCostVal = GetItemPropertyCostTableValue(ip);
          int iPropType = GetItemPropertyType(ip);
          if(iPropType == ITEM_PROPERTY_DAMAGE_BONUS)
          {
               iDamageType = GetItemPropertyParam1Value(ip);

               if ( (iBase == BASE_ITEM_BOLT || iBase == BASE_ITEM_ARROW) && iDamageType == IP_CONST_DAMAGETYPE_PIERCING )
               {
                    iTemp = GetDamageByConstant(iCostVal, TRUE);
                    iBonus = iTemp> iBonus ? iTemp:iBonus ;
               }
                    else if ( iBase == BASE_ITEM_BULLET && iDamageType == IP_CONST_DAMAGETYPE_BLUDGEONING )
               {
                    iTemp = GetDamageByConstant(iCostVal, TRUE);
                    iBonus = iTemp> iBonus ? iTemp:iBonus ;
               }
          }
          if(iPropType == ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP)
          {
               iAlignGr = GetItemPropertySubType(ip);
               iDamageType = GetItemPropertyParam1Value(ip);

               int bIsAttackingAlignment = FALSE;

               if (iAlignGr == ALIGNMENT_NEUTRAL)
               {
                    if (iAlignGr == iLawChaos)  bIsAttackingAlignment = TRUE;
               }
               else if (iAlignGr == iGoodEvil || iAlignGr == iLawChaos || iAlignGr == IP_CONST_ALIGNMENTGROUP_ALL)
                    bIsAttackingAlignment = FALSE;

               if(bIsAttackingAlignment)
               {
                    if ( (iBase == BASE_ITEM_BOLT || iBase == BASE_ITEM_ARROW) && iDamageType == IP_CONST_DAMAGETYPE_PIERCING )
                    {
                         iTemp = GetDamageByConstant(iCostVal, TRUE);
                         iBonus = iTemp> iBonus ? iTemp:iBonus ;
                    }
                         else if ( iBase == BASE_ITEM_BULLET && iDamageType == IP_CONST_DAMAGETYPE_BLUDGEONING )
                    {
                         iTemp = GetDamageByConstant(iCostVal, TRUE);
                         iBonus = iTemp> iBonus ? iTemp:iBonus ;
                    }
               }
          }
          if(iPropType == ITEM_PROPERTY_DAMAGE_BONUS_VS_SPECIFIC_ALIGNMENT)
          {
               if(GetItemPropertySubType(ip) == iAlignSp) iTemp = GetItemPropertyCostTableValue(ip);
               else                                       iTemp = 0;

               iDamageType = GetItemPropertyParam1Value(ip);

               if ( (iBase == BASE_ITEM_BOLT || iBase == BASE_ITEM_ARROW) && iDamageType == IP_CONST_DAMAGETYPE_PIERCING )
               {
                    iTemp = GetDamageByConstant(iCostVal, TRUE);
                    iBonus = iTemp> iBonus ? iTemp:iBonus ;
               }
                    else if ( iBase == BASE_ITEM_BULLET && iDamageType == IP_CONST_DAMAGETYPE_BLUDGEONING )
               {
                    iTemp = GetDamageByConstant(iCostVal, TRUE);
                    iBonus = iTemp> iBonus ? iTemp:iBonus ;
               }
          }
          if(iPropType == ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP)
          {
               if(GetItemPropertySubType(ip) == iRace) iTemp = GetItemPropertyCostTableValue(ip);
               else                                    iTemp = 0;                                      iTemp = 0;

               iDamageType = GetItemPropertyParam1Value(ip);

               if ( (iBase == BASE_ITEM_BOLT || iBase == BASE_ITEM_ARROW) && iDamageType == IP_CONST_DAMAGETYPE_PIERCING )
               {
                    iTemp = GetDamageByConstant(iCostVal, TRUE);
                    iBonus = iTemp> iBonus ? iTemp:iBonus ;
               }
                    else if ( iBase == BASE_ITEM_BULLET && iDamageType == IP_CONST_DAMAGETYPE_BLUDGEONING )
               {
                    iTemp = GetDamageByConstant(iCostVal, TRUE);
                    iBonus = iTemp> iBonus ? iTemp:iBonus ;
               }
          }
          ip = GetNextItemProperty(oWeapon);
     }
     return iBonus;
}

int GetDamageByConstant(int iDamageConst, int iItemProp)
{
    if(iItemProp)
    {
        switch(iDamageConst)
        {
            case IP_CONST_DAMAGEBONUS_1:
                return 1;
            case IP_CONST_DAMAGEBONUS_2:
                return 2;
            case IP_CONST_DAMAGEBONUS_3:
                return 3;
            case IP_CONST_DAMAGEBONUS_4:
                return 4;
            case IP_CONST_DAMAGEBONUS_5:
                return 5;
            case IP_CONST_DAMAGEBONUS_6:
                return 6;
            case IP_CONST_DAMAGEBONUS_7:
                return 7;
            case IP_CONST_DAMAGEBONUS_8:
                return 8;
            case IP_CONST_DAMAGEBONUS_9:
                return 9;
            case IP_CONST_DAMAGEBONUS_10:
                return 10;
            case IP_CONST_DAMAGEBONUS_11:
                return 11;
            case IP_CONST_DAMAGEBONUS_12:
                return 12;
            case IP_CONST_DAMAGEBONUS_13:
                return 13;
            case IP_CONST_DAMAGEBONUS_14:
                return 14;
            case IP_CONST_DAMAGEBONUS_15:
                return 15;
            case IP_CONST_DAMAGEBONUS_16:
                return 16;
            case IP_CONST_DAMAGEBONUS_17:
                return 17;
            case IP_CONST_DAMAGEBONUS_18:
                return 18;
            case IP_CONST_DAMAGEBONUS_19:
                return 19;
            case IP_CONST_DAMAGEBONUS_20:
                return 20;
            case IP_CONST_DAMAGEBONUS_1d4:
                return d4(1);
            case IP_CONST_DAMAGEBONUS_1d6:
                return d6(1);
            case IP_CONST_DAMAGEBONUS_1d8:
                return d8(1);
            case IP_CONST_DAMAGEBONUS_1d10:
                return d10(1);
            case IP_CONST_DAMAGEBONUS_1d12:
                return d12(1);
            case IP_CONST_DAMAGEBONUS_2d4:
                return d4(2);
            case IP_CONST_DAMAGEBONUS_2d6:
                return d6(2);
            case IP_CONST_DAMAGEBONUS_2d8:
                return d8(2);
            case IP_CONST_DAMAGEBONUS_2d10:
                return d10(2);
            case IP_CONST_DAMAGEBONUS_2d12:
                return d12(2);
        }
    }
    else
    {
        switch(iDamageConst)
        {
            case DAMAGE_BONUS_1:
                return 1;
            case DAMAGE_BONUS_2:
                return 2;
            case DAMAGE_BONUS_3:
                return 3;
            case DAMAGE_BONUS_4:
                return 4;
            case DAMAGE_BONUS_5:
                return 5;
            case DAMAGE_BONUS_6:
                return 6;
            case DAMAGE_BONUS_7:
                return 7;
            case DAMAGE_BONUS_8:
                return 8;
            case DAMAGE_BONUS_9:
                return 9;
            case DAMAGE_BONUS_10:
                return 10;
            case DAMAGE_BONUS_11:
                return 10;
            case DAMAGE_BONUS_12:
                return 10;
            case DAMAGE_BONUS_13:
                return 10;
            case DAMAGE_BONUS_14:
                return 10;
            case DAMAGE_BONUS_15:
                return 10;
            case DAMAGE_BONUS_16:
                return 10;
            case DAMAGE_BONUS_17:
                return 10;
            case DAMAGE_BONUS_18:
                return 10;
            case DAMAGE_BONUS_19:
                return 10;
            case DAMAGE_BONUS_20:
                return 10;
            case DAMAGE_BONUS_1d4:
                return d4(1);
            case DAMAGE_BONUS_1d6:
                return d6(1);
            case DAMAGE_BONUS_1d8:
                return d8(1);
            case DAMAGE_BONUS_1d10:
                return d10(1);
            case DAMAGE_BONUS_1d12:
                return d12(1);
            case DAMAGE_BONUS_2d4:
                return d4(2);
            case DAMAGE_BONUS_2d6:
                return d6(2);
            case DAMAGE_BONUS_2d8:
                return d8(2);
            case DAMAGE_BONUS_2d10:
                return d10(2);
            case DAMAGE_BONUS_2d12:
                return d12(2);
        }
    }
    return 0;
}

struct BonusDamage GetItemPropertyDamageConstant(int iDamageType, int iTemp, struct BonusDamage weapBonusDam)
{
     switch (iDamageType)
     {
          case -1:
               break;
          case IP_CONST_DAMAGETYPE_ACID:
               if (iTemp > 5 && iTemp < 16) // is a dice constant
               {
                    if(iTemp > weapBonusDam.dice_Acid) weapBonusDam.dice_Acid = iTemp;
               }
               else // is +1 to +20
               {
                    if(iTemp > weapBonusDam.dam_Acid) weapBonusDam.dam_Acid = iTemp;
               }
               break;
          case IP_CONST_DAMAGETYPE_COLD:
               if (iTemp > 5 && iTemp < 16) // is a dice constant
               {
                    if(iTemp > weapBonusDam.dice_Cold) weapBonusDam.dice_Cold = iTemp;
               }
               else // is +1 to +20
               {
                    if(iTemp > weapBonusDam.dam_Cold) weapBonusDam.dam_Cold = iTemp;
               }
               break;
          case IP_CONST_DAMAGETYPE_FIRE:
               if (iTemp > 5 && iTemp < 16) // is a dice constant
               {
                    if(iTemp > weapBonusDam.dice_Fire) weapBonusDam.dice_Fire = iTemp;
               }
               else // is +1 to +20
               {
                    if(iTemp > weapBonusDam.dam_Fire) weapBonusDam.dam_Fire = iTemp;
               }
               break;
          case IP_CONST_DAMAGETYPE_ELECTRICAL:
               if (iTemp > 5 && iTemp < 16) // is a dice constant
               {
                    if(iTemp > weapBonusDam.dice_Elec) weapBonusDam.dice_Elec = iTemp;
               }
               else // is +1 to +20
               {
                    if(iTemp > weapBonusDam.dam_Elec) weapBonusDam.dam_Elec = iTemp;
               }
               break;
          case IP_CONST_DAMAGETYPE_SONIC:
               if (iTemp > 5 && iTemp < 16) // is a dice constant
               {
                    if(iTemp > weapBonusDam.dice_Son) weapBonusDam.dice_Son = iTemp;
               }
               else // is +1 to +20
               {
                    if(iTemp > weapBonusDam.dam_Son) weapBonusDam.dam_Son = iTemp;
               }
               break;
          case IP_CONST_DAMAGETYPE_DIVINE:
               if (iTemp > 5 && iTemp < 16) // is a dice constant
               {
                    if(iTemp > weapBonusDam.dice_Div) weapBonusDam.dice_Div = iTemp;
               }
               else // is +1 to +20
               {
                    if(iTemp > weapBonusDam.dam_Div) weapBonusDam.dam_Div = iTemp;
               }
               break;
          case IP_CONST_DAMAGETYPE_NEGATIVE:
               if (iTemp > 5 && iTemp < 16) // is a dice constant
               {
                    if(iTemp > weapBonusDam.dice_Neg) weapBonusDam.dice_Neg = iTemp;
               }
               else // is +1 to +20
               {
                    if(iTemp > weapBonusDam.dam_Neg) weapBonusDam.dam_Neg = iTemp;
               }
               break;
          case IP_CONST_DAMAGETYPE_POSITIVE:
               if (iTemp > 5 && iTemp < 16) // is a dice constant
               {
                    if(iTemp > weapBonusDam.dice_Pos) weapBonusDam.dice_Pos = iTemp;
               }
               else // is +1 to +20
               {
                    if(iTemp > weapBonusDam.dam_Pos) weapBonusDam.dam_Pos = iTemp;
               }
               break;
          case IP_CONST_DAMAGETYPE_MAGICAL:
               if (iTemp > 5 && iTemp < 16) // is a dice constant
               {
                    if(iTemp > weapBonusDam.dice_Mag) weapBonusDam.dice_Mag = iTemp;
               }
               else // is +1 to +20
               {
                    if(iTemp > weapBonusDam.dam_Mag) weapBonusDam.dam_Mag = iTemp;
               }
               break;
          case IP_CONST_DAMAGETYPE_BLUDGEONING:
               if (iTemp > 5 && iTemp < 16) // is a dice constant
               {
                    if(iTemp > weapBonusDam.dice_Blud) weapBonusDam.dice_Blud = iTemp;
               }
               else // is +1 to +20
               {
                    if(iTemp > weapBonusDam.dam_Blud) weapBonusDam.dam_Blud = iTemp;
               }
               break;
          case IP_CONST_DAMAGETYPE_PIERCING:
               if (iTemp > 5 && iTemp < 16) // is a dice constant
               {
                    if(iTemp > weapBonusDam.dice_Pier) weapBonusDam.dice_Pier = iTemp;
               }
               else // is +1 to +20
               {
                    if(iTemp > weapBonusDam.dam_Pier) weapBonusDam.dam_Pier = iTemp;
               }
               break;
          case IP_CONST_DAMAGETYPE_SLASHING:
               if (iTemp > 5 && iTemp < 16) // is a dice constant
               {
                    if(iTemp > weapBonusDam.dice_Slash) weapBonusDam.dice_Slash = iTemp;
               }
               else // is +1 to +20
               {
                    if(iTemp > weapBonusDam.dam_Slash) weapBonusDam.dam_Slash = iTemp;
               }
               break;
     }

     return weapBonusDam;
}

struct BonusDamage GetWeaponBonusDamage(object oWeapon, object oTarget)
{
     struct BonusDamage weapBonusDam;

     int iDamageType;
     int iTemp;

     int iRace = MyPRCGetRacialType(oTarget);

     int iGoodEvil = GetAlignmentGoodEvil(oTarget);
     int iLawChaos = GetAlignmentLawChaos(oTarget);
     int iAlignSp  = ConvAlignGr(iGoodEvil,iLawChaos);
     int iAlignGr;

     int iSpellType;

  itemproperty ip = GetFirstItemProperty(oWeapon);

     while(GetIsItemPropertyValid(ip))
     {
          int ipType = GetItemPropertyType(ip);
          switch(ipType)
          {
               // Checks weapon for Holy Avenger property
               case ITEM_PROPERTY_HOLY_AVENGER:
                    iAlignGr = GetItemPropertySubType(ip);
                    if (iAlignGr == ALIGNMENT_EVIL)
                    {
                         iDamageType = IP_CONST_DAMAGETYPE_DIVINE;
                         iTemp = IP_CONST_DAMAGEBONUS_1d6;
                         weapBonusDam = GetItemPropertyDamageConstant(iDamageType, iTemp, weapBonusDam);
                    }
                    break;

               case ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP:
                    iAlignGr = GetItemPropertySubType(ip);
                    iDamageType = -1;

                    if (iAlignGr == ALIGNMENT_NEUTRAL)
                    {
                         if (iAlignGr == iLawChaos)  iDamageType = GetItemPropertyParam1Value(ip);
                    }
                    else if (iAlignGr == iGoodEvil || iAlignGr == iLawChaos || iAlignGr == IP_CONST_ALIGNMENTGROUP_ALL)
                         iDamageType = GetItemPropertyParam1Value(ip);

                    // changed so that it returns the ItemProperty Value instead of the actualy damage
                    //iTemp = GetDamageByConstant(GetItemPropertyCostTableValue(ip),TRUE);
                    iTemp = GetItemPropertyCostTableValue(ip);

                    // stores the constants in the struct file
                    // utility function that prevents the same code from being rewritten for each property.
                    weapBonusDam = GetItemPropertyDamageConstant(iDamageType, iTemp, weapBonusDam);
                    break;

               case ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP:
                    if(GetItemPropertySubType(ip) == iRace) iTemp = GetItemPropertyCostTableValue(ip);
                    else                                    iTemp = 0;

                    iDamageType = GetItemPropertyParam1Value(ip);

                    weapBonusDam = GetItemPropertyDamageConstant(iDamageType, iTemp, weapBonusDam);
                    break;

               case ITEM_PROPERTY_DAMAGE_BONUS_VS_SPECIFIC_ALIGNMENT:
                    if(GetItemPropertySubType(ip) == iAlignSp) iTemp = GetItemPropertyCostTableValue(ip);
                    else                                       iTemp = 0;

                    iDamageType = GetItemPropertyParam1Value(ip);

                    weapBonusDam = GetItemPropertyDamageConstant(iDamageType, iTemp, weapBonusDam);
                    break;

               case ITEM_PROPERTY_DAMAGE_BONUS:
                    iTemp = GetItemPropertyCostTableValue(ip);
                    iDamageType = GetItemPropertySubType(ip);

                    weapBonusDam = GetItemPropertyDamageConstant(iDamageType, iTemp, weapBonusDam);
                    break;

               case ITEM_PROPERTY_ONHITCASTSPELL:
                    iSpellType = GetItemPropertySubType(ip);
                    iDamageType = GetItemPropertyCostTableValue(ip);

                    switch(iSpellType)
                    {
                         // dark fire 1d6 + X dmg.  X = CasterLevel/2
                         case IP_CONST_ONHIT_CASTSPELL_ONHIT_DARKFIRE:
                              if(weapBonusDam.dice_Fire == 0)
                              {
                                   iDamageType = IP_CONST_DAMAGETYPE_FIRE;
                                   iTemp = IP_CONST_DAMAGEBONUS_1d6;
                                   weapBonusDam = GetItemPropertyDamageConstant(iDamageType, iTemp, weapBonusDam);

                                   iTemp = iDamageType;
                                   iTemp /= 2;
                                   if(iTemp > 10) iTemp = 10;
                                   iTemp = IPGetDamageBonusConstantFromNumber(iTemp);
                                   weapBonusDam.dam_Fire = 0;
                                   weapBonusDam = GetItemPropertyDamageConstant(iDamageType, iTemp, weapBonusDam);
                              }
                              break;
                         // flame blade 1d4 + X dmg.  X = CasterLevel/2
                         case IP_CONST_ONHIT_CASTSPELL_ONHIT_FIREDAMAGE:
                              if(weapBonusDam.dice_Fire == 0)
                              {
                                   iDamageType = IP_CONST_DAMAGETYPE_FIRE;
                                   iTemp = IP_CONST_DAMAGEBONUS_1d4;
                                   weapBonusDam = GetItemPropertyDamageConstant(iDamageType, iTemp, weapBonusDam);

                                   iTemp = iDamageType;
                                   iTemp /= 2;
                                   if(iTemp > 10) iTemp = 10;
                                   iTemp = IPGetDamageBonusConstantFromNumber(iTemp);
                                   weapBonusDam.dam_Fire = 0;
                                   weapBonusDam = GetItemPropertyDamageConstant(iDamageType, iTemp, weapBonusDam);
                              }
                              break;
                    }

                    break;
            }
            ip = GetNextItemProperty(oWeapon);
     }

     return weapBonusDam;
}

struct BonusDamage GetMagicalBonusDamage(object oAttacker)
{
     struct BonusDamage spellBonusDam;

     effect eEffect;
     int nDamage, eType, eSpellID;

     object eEffectCreator;
     int nCharismaBonus, nLvl;

     eEffect = GetFirstEffect(oAttacker);
     while (GetIsEffectValid(eEffect) )
     {
          eType = GetEffectType(eEffect);

          if (eType == EFFECT_TYPE_DAMAGE_INCREASE)
          {
               eSpellID = GetEffectSpellId(eEffect);

               switch(eSpellID)
               {
                    case SPELL_PRAYER:
                         spellBonusDam.dam_Slash += 1;
                         break;

                    case SPELL_WAR_CRY:
                         spellBonusDam.dam_Slash += 2;
                         break;

                    case SPELL_BATTLETIDE:
                         spellBonusDam.dam_Mag += 2;
                         break;

                    // Bard Song
                    case 411:
                         eEffectCreator = GetEffectCreator(eEffect);
                         nDamage = 1;
                         if (GetIsObjectValid(eEffectCreator))
                         {
                              int nLvl = GetLevelByClass(CLASS_TYPE_BARD, eEffectCreator);
                              int iPerform = GetSkillRank(SKILL_PERFORM, eEffectCreator);

                              if (nLvl>=14 && iPerform>= 21)      nDamage = 3;
                              else if (nLvl>= 3 && iPerform>= 9)  nDamage = 2;
                         }
                         spellBonusDam.dam_Blud += nDamage;
                         break;

                    case SPELL_DIVINE_MIGHT:
                         nDamage = 1 + GetHasFeat(FEAT_EPIC_DIVINE_MIGHT, GetEffectCreator(eEffect));
                         nCharismaBonus = GetAbilityModifier(ABILITY_CHARISMA,GetEffectCreator(eEffect)) * nDamage;

                         if(nCharismaBonus > 1) nDamage = nCharismaBonus;
                         else                   nDamage = 1;

                         spellBonusDam.dam_Div += nDamage;
                         break;

                    // Divine Wrath
                    case 622:
                         //  magical
                         nDamage = 3;
                         eEffectCreator =GetEffectCreator(eEffect);
                         nLvl = GetLevelByClass(CLASS_TYPE_DIVINECHAMPION, eEffectCreator);
                         nLvl = (nLvl / 5)-1;

                         if (nLvl > 6)       nDamage = 15;
                         else if (nLvl > 5)  nDamage = 12;
                         else if (nLvl > 4)  nDamage = 10;
                         else if (nLvl > 3)  nDamage = 8;
                         else if (nLvl > 2)  nDamage = 6;
                         else if (nLvl > 1)  nDamage = 4;

                         spellBonusDam.dam_Mag += nDamage;
                         break;

                    // Double check the class levels later
                    case SPELL_DIVINE_FAVOR:
                         //  divine
                         eEffectCreator = GetEffectCreator(eEffect);

                         nDamage = 1;
                         if (GetIsObjectValid(eEffectCreator))
                         {
                               nLvl = GetLevelByClass(CLASS_TYPE_PALADIN, oAttacker) + GetLevelByClass(CLASS_TYPE_CLERIC, oAttacker);
                               nDamage = nLvl/3;

                               if(nDamage < 1) nDamage = 1;
                               if(nDamage > 5) nDamage = 5;
                         }
                         spellBonusDam.dam_Div += nDamage;
                         break;

                    // Power Shot
                    case SPELL_PA_POWERSHOT:
                         spellBonusDam.dam_Pier += 5;
                         break;

                    case SPELL_PA_IMP_POWERSHOT:
                         spellBonusDam.dam_Pier += 10;
                         break;

                    case SPELL_PA_SUP_POWERSHOT:
                         spellBonusDam.dam_Pier += 15;
                         break;
               }

               // prevents power shot and power attack from stacking
               if(!GetHasFeatEffect(FEAT_PA_POWERSHOT, oAttacker) &&
                  !GetHasFeatEffect(FEAT_PA_IMP_POWERSHOT, oAttacker) &&
                  !GetHasFeatEffect(FEAT_PA_SUP_POWERSHOT, oAttacker) )
               {
                    switch(eSpellID)
                    {
                         case SPELL_POWER_ATTACK10:
                              spellBonusDam.dam_Slash += 10;
                              break;
                         case SPELL_POWER_ATTACK9:
                              spellBonusDam.dam_Slash += 9;
                              break;
                         case SPELL_POWER_ATTACK8:
                              spellBonusDam.dam_Slash += 8;
                              break;
                         case SPELL_POWER_ATTACK7:
                              spellBonusDam.dam_Slash += 7;
                              break;
                         case SPELL_POWER_ATTACK6:
                              spellBonusDam.dam_Slash += 6;
                              break;
                         case SPELL_POWER_ATTACK5:
                              spellBonusDam.dam_Slash += 5;
                              break;
                         case SPELL_POWER_ATTACK4:
                              spellBonusDam.dam_Slash += 4;
                              break;
                         case SPELL_POWER_ATTACK3:
                              spellBonusDam.dam_Slash += 3;
                              break;
                         case SPELL_POWER_ATTACK2:
                              spellBonusDam.dam_Slash += 2;
                              break;
                         case SPELL_POWER_ATTACK1:
                              spellBonusDam.dam_Slash += 1;
                              break;
                         case SPELL_SUPREME_POWER_ATTACK:
                              spellBonusDam.dam_Slash += 20;
                              break;
                    }
               }

          }
          else if (eType == EFFECT_TYPE_DAMAGE_DECREASE)
          {
               switch(eSpellID)
               {
                    case SPELLABILITY_HOWL_DOOM:
                    case SPELLABILITY_GAZE_DOOM:
                    case SPELL_DOOM:
                         spellBonusDam.dam_Mag -= 2;
                         break;

                    case SPELL_GHOUL_TOUCH:
                         spellBonusDam.dam_Mag -= 2;
                         break;

                    case SPELL_BATTLETIDE:
                         spellBonusDam.dam_Mag -= 2;
                         break;

                    case SPELL_PRAYER:
                         spellBonusDam.dam_Slash -= 1;
                         break;

                    case SPELL_SCARE:
                         spellBonusDam.dam_Mag -= 2;
                         break;

                    // Hell Inferno
                    case 762:
                         spellBonusDam.dam_Mag -= 4;
                         break;

                    // Curse Song
                    case 644:
                         eEffectCreator = GetEffectCreator(eEffect);
                         nDamage = 1;

                         if (GetIsObjectValid(eEffectCreator))
                         {
                              nLvl = GetLevelByClass(CLASS_TYPE_BARD, eEffectCreator);
                              int iPerform = GetSkillRank(SKILL_PERFORM, eEffectCreator);

                              if (nLvl>=14 && iPerform>= 21)      nDamage = 3;
                              else if (nLvl>= 3 && iPerform>= 9)  nDamage = 2;
                         }
                         spellBonusDam.dam_Blud -= nDamage;
               }
          }
          eEffect = GetNextEffect(oAttacker);
     }
     return spellBonusDam;
}

int GetWeaponDamagePerRound(object oDefender, object oAttacker, object oWeap, int iMainHand = 0)
{
     int iDamage = 0;
     int iWeaponType = GetBaseItemType(oWeap);
     int bSpec = GetHasFeat(GetFeatByWeaponType(iWeaponType, "Specialization"), oAttacker);
     int bESpec = GetHasFeat(GetFeatByWeaponType(iWeaponType, "EpicSpecialization"), oAttacker);

     int iStr = GetAbilityModifier(ABILITY_STRENGTH, oAttacker);
     int iEnhancement = GetWeaponEnhancement(oWeap, oDefender, oAttacker);

     int bIsRangedWeapon = GetWeaponRanged(oWeap);
     int bIsTwoHandedMelee = GetIsTwoHandedMeleeWeapon(oWeap);

     // ranged weapon specific rules
     if(bIsRangedWeapon)
     {
          // add mighty weapon strength damage
          int iMighty = GetMightyWeaponBonus(oWeap);
          if(iMighty > 0)
          {
               if(iStr > iMighty) iStr = iMighty;
               iDamage += iStr;
          }
     }
     // melee weapon rules
     else
     {
          // double str bonus to damage
          if(bIsTwoHandedMelee)  iStr *= 2;

          // off-hand weapons deal half str bonus
          if(iMainHand == 1)     iStr /= 2;

          iDamage += iStr;
     }

     // weapon specializations
     if(bSpec) iDamage += 2;
     if(bESpec) iDamage += 4;

     // adds enhancement bonus to damage
     iDamage += iEnhancement;

     // support for power attack and expertise modes
     int iCombatMode = GetLastAttackMode(oAttacker);
     if( iCombatMode == COMBAT_MODE_POWER_ATTACK &&
         !GetHasSpellEffect(SPELL_SUPREME_POWER_ATTACK) &&
         !GetHasSpellEffect(SPELL_POWER_ATTACK10) &&
         !GetHasSpellEffect(SPELL_POWER_ATTACK9)  &&
         !GetHasSpellEffect(SPELL_POWER_ATTACK8)  &&
         !GetHasSpellEffect(SPELL_POWER_ATTACK7)  &&
         !GetHasSpellEffect(SPELL_POWER_ATTACK6)  &&
         !GetHasSpellEffect(SPELL_POWER_ATTACK5)  &&
         !GetHasSpellEffect(SPELL_POWER_ATTACK4)  &&
         !GetHasSpellEffect(SPELL_POWER_ATTACK3)  &&
         !GetHasSpellEffect(SPELL_POWER_ATTACK2)  &&
         !GetHasSpellEffect(SPELL_POWER_ATTACK1) )
     {
          iDamage += 5;
     }
     else if( iCombatMode == COMBAT_MODE_IMPROVED_POWER_ATTACK &&
         !GetHasSpellEffect(SPELL_SUPREME_POWER_ATTACK) &&
         !GetHasSpellEffect(SPELL_POWER_ATTACK10) &&
         !GetHasSpellEffect(SPELL_POWER_ATTACK9)  &&
         !GetHasSpellEffect(SPELL_POWER_ATTACK8)  &&
         !GetHasSpellEffect(SPELL_POWER_ATTACK7)  &&
         !GetHasSpellEffect(SPELL_POWER_ATTACK6)  &&
         !GetHasSpellEffect(SPELL_POWER_ATTACK5)  &&
         !GetHasSpellEffect(SPELL_POWER_ATTACK4)  &&
         !GetHasSpellEffect(SPELL_POWER_ATTACK3)  &&
         !GetHasSpellEffect(SPELL_POWER_ATTACK2)  &&
         !GetHasSpellEffect(SPELL_POWER_ATTACK1) )
     {
          iDamage += 10;
     }

     // calculates bonus damage for Favored Enemies
     // this is just added each round to help prevent lag
     // can be moved if this becomes an issue of course.
     iDamage += GetFavoredEnemeyDamageBonus(oDefender, oAttacker);

     return iDamage;
}

effect GetAttackDamage(object oDefender, object oAttacker, object oWeapon, struct BonusDamage sWeaponBonusDamage, struct BonusDamage sSpellBonusDamage, int iMainHand = 0, int iDamage = 0, int bIsCritical = FALSE, int iNumDice = 0, int iNumSides = 0, int iCriticalMultiplier = 0)
{
     int iWeaponDamage = 0;
     int iBonusWeaponDamage = 0;
     int iMassCritBonusDamage = 0;

     int iWeaponType = GetBaseItemType(oWeapon);

     // only read the data if it is not already given
     if(iNumSides == 0) iNumSides = StringToInt(Get2DAString("baseitems", "DieToRoll", iWeaponType));
     if(iNumDice  == 0) iNumDice  = StringToInt(Get2DAString("baseitems", "NumDice", iWeaponType));
     if(iCriticalMultiplier == 0)  iCriticalMultiplier = GetWeaponCritcalMultiplier(oAttacker, oWeapon);

     // Returns proper unarmed damage if they are a monk
     // or have a creature weapon from a PrC class. - Brawler, Shou, IoDM, etc.
     // Note: When using PerformAttackRound gloves are passed to this function
     //       as oWeapon, so this will not be called twice.
     if(iWeaponType == BASE_ITEM_INVALID && GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oAttacker) != OBJECT_INVALID ||
        iWeaponType == BASE_ITEM_INVALID && GetLevelByClass(CLASS_TYPE_MONK, oAttacker) )
     {
          int iDamage = FindUnarmedDamage(oAttacker);
          switch(iDamage)
          {
               case MONST_DAMAGE_1D2:
                    iNumSides = 2;
                    iNumDice = 1;
                    break;
               case MONST_DAMAGE_1D3:
                    iNumSides = 3;
                    iNumDice = 1;
                    break;
               case MONST_DAMAGE_1D4:
                    iNumSides = 4;
                    iNumDice  = 1;
                    break;
               case MONST_DAMAGE_1D6:
                    iNumSides = 6;
                    iNumDice  = 1;
                    break;
               case MONST_DAMAGE_1D8:
                    iNumSides = 8;
                    iNumDice  = 1;
                    break;
               case MONST_DAMAGE_1D10:
                    iNumSides = 10;
                    iNumDice  = 1;
                    break;
               case MONST_DAMAGE_1D12:
                    iNumSides = 12;
                    iNumDice  = 1;
                    break;
               case MONST_DAMAGE_1D20:
                    iNumSides = 20;
                    iNumDice  = 1;
                    break;
               case MONST_DAMAGE_2D6:
                    iNumSides = 6;
                    iNumDice  = 2;
                    break;
               case MONST_DAMAGE_2D8:
                    iNumSides = 8;
                    iNumDice  = 2;
                    break;
               case MONST_DAMAGE_2D10:
                    iNumSides = 10;
                    iNumDice  = 2;
                    break;
               case MONST_DAMAGE_2D12:
                    iNumSides = 12;
                    iNumDice  = 2;
                    break;
               case MONST_DAMAGE_3D6:
                    iNumSides = 6;
                    iNumDice  = 3;
                    break;
               case MONST_DAMAGE_3D8:
                    iNumSides = 8;
                    iNumDice  = 3;
                    break;
               case MONST_DAMAGE_3D10:
                    iNumSides = 10;
                    iNumDice  = 3;
                    break;
               case MONST_DAMAGE_3D12:
                    iNumSides = 12;
                    iNumDice  = 3;
                    break;
          }
     }
     else if(iWeaponType == BASE_ITEM_INVALID)
     {
          // unarmed non-monk 1d3 damage
          iNumSides = 3;
          iNumDice  = 1;
     }

     //Roll the base damage dice.
     if(iNumSides == 2)  iWeaponDamage += d2(iNumDice);
     if(iNumSides == 3)  iWeaponDamage += d3(iNumDice);
     if(iNumSides == 4)  iWeaponDamage += d4(iNumDice);
     if(iNumSides == 6)  iWeaponDamage += d6(iNumDice);
     if(iNumSides == 8)  iWeaponDamage += d8(iNumDice);
     if(iNumSides == 10) iWeaponDamage += d10(iNumDice);
     if(iNumSides == 12) iWeaponDamage += d12(iNumDice);
     if(iNumSides == 20) iWeaponDamage += d20(iNumDice);

     // Determine Masssive Critcal Bonuses
     if(bIsCritical)
     {
          itemproperty ip = GetFirstItemProperty(oWeapon);
          while(GetIsItemPropertyValid(ip))
          {
               int tempConst = 0;
               int iCostVal = GetItemPropertyCostTableValue(ip);

               if(GetItemPropertyType(ip) == ITEM_PROPERTY_MASSIVE_CRITICALS)
               {
                    if(iCostVal > tempConst)
                    {
                         iMassCritBonusDamage = GetDamageByConstant(iCostVal, TRUE);
                         tempConst = iCostVal;
                    }
               }
               ip = GetNextItemProperty(oWeapon);
          }

          if(GetHasFeat(FEAT_EPIC_THUNDERING_RAGE, oAttacker) && GetHasFeatEffect(FEAT_BARBARIAN_RAGE, oAttacker) )
          {
               iMassCritBonusDamage += d6(2);
          }
     }

     // Get bonus damage
     if(iDamage != 0) iBonusWeaponDamage = iDamage;
     else             iBonusWeaponDamage = GetWeaponDamagePerRound(oDefender, oAttacker, oWeapon, iMainHand);

     iWeaponDamage += iBonusWeaponDamage;

     // PnP Rules State:
     // Extra Damage over and above a weapons normal damage
     // such as that dealt by a sneak attack or special ability of
     // a flaming sword are not multiplied when you score a critical hit
     // so no magical effects or bonuses are doubled.

     if(bIsCritical)
     {
          // determine critical damage
          iWeaponDamage *= iCriticalMultiplier;
          iWeaponDamage += iMassCritBonusDamage;
     }

     // add weapon bonus melee damage
     iWeaponDamage += GetDamageByConstant(sWeaponBonusDamage.dam_Blud, TRUE);
     iWeaponDamage += GetDamageByConstant(sWeaponBonusDamage.dam_Pier, TRUE);
     iWeaponDamage += GetDamageByConstant(sWeaponBonusDamage.dam_Slash, TRUE);

     // add bonus damage dice from weapon damage bonuses
     iWeaponDamage += GetDamageByConstant(sWeaponBonusDamage.dice_Blud, TRUE);
     iWeaponDamage += GetDamageByConstant(sWeaponBonusDamage.dice_Pier, TRUE);
     iWeaponDamage += GetDamageByConstant(sWeaponBonusDamage.dice_Slash, TRUE);

     // damage from spells is stored as solid number
     // currently, no spells add ndX damage
     iWeaponDamage += sSpellBonusDamage.dam_Blud;
     iWeaponDamage += sSpellBonusDamage.dam_Pier;
     iWeaponDamage += sSpellBonusDamage.dam_Slash;

     // Logic to determine if enemy can be sneak attacked
     // and to add sneak attack damage
     if(GetCanSneakAttack(oDefender, oAttacker) )
     {
          int iSneakDice = GetTotalSneakAttackDice(oAttacker);
          if(iSneakDice > 0)
          {
               iWeaponDamage += GetSneakAttackDamage(iSneakDice);
               string nMes = "*Sneak Attack*";
               FloatingTextStringOnCreature(nMes, OBJECT_SELF, FALSE);
          }
     }

     int iDamagePower = GetDamagePowerConstant(oWeapon, oDefender, oAttacker);
     int iDamageType = GetWeaponDamageType(oWeapon);

     // just in case damage is somehow less than 1
     if(iWeaponDamage < 1) iWeaponDamage = 1;

     effect eEffect = EffectDamage(iWeaponDamage, iDamageType, iDamagePower);

     // Elemental damage effects
     int iAcid, iCold, iFire, iElec, iSon;
     int iDiv, iNeg, iPos;
     int iMag;

     iAcid  = sSpellBonusDamage.dam_Acid;
     iAcid += GetDamageByConstant(sWeaponBonusDamage.dam_Acid, TRUE);

     iCold  = sSpellBonusDamage.dam_Cold;
     iCold += GetDamageByConstant(sWeaponBonusDamage.dam_Cold, TRUE);

     iFire  = sSpellBonusDamage.dam_Fire;
     iFire += GetDamageByConstant(sWeaponBonusDamage.dam_Fire, TRUE);

     iElec  = sSpellBonusDamage.dam_Elec;
     iElec += GetDamageByConstant(sWeaponBonusDamage.dam_Elec, TRUE);

     iSon  = sSpellBonusDamage.dam_Son;
     iSon += GetDamageByConstant(sWeaponBonusDamage.dam_Son, TRUE);

     iDiv  = sSpellBonusDamage.dam_Div;
     iDiv += GetDamageByConstant(sWeaponBonusDamage.dam_Div, TRUE);

     iNeg  = sSpellBonusDamage.dam_Neg;
     iNeg += GetDamageByConstant(sWeaponBonusDamage.dam_Neg, TRUE);

     iPos  = sSpellBonusDamage.dam_Pos;
     iPos += GetDamageByConstant(sWeaponBonusDamage.dam_Pos, TRUE);

     iMag  = sSpellBonusDamage.dam_Mag;
     iMag += GetDamageByConstant(sWeaponBonusDamage.dam_Mag, TRUE);

     // magical damage is not multiplied by criticals
     // at least not in PnP
     //if(bIsCritical)
     //{
     //     iAcid *= iCriticalMultiplier;
     //     iCold *= iCriticalMultiplier;
     //     iFire *= iCriticalMultiplier;
     //     iElec *= iCriticalMultiplier;
     //     iSon *= iCriticalMultiplier;
     //
     //     iDiv *= iCriticalMultiplier;
     //     iNeg *= iCriticalMultiplier;
     //     iPos *= iCriticalMultiplier;
     //
     //     iMag *= iCriticalMultiplier;
     //}

     iAcid += GetDamageByConstant(sSpellBonusDamage.dice_Acid, TRUE);
     iAcid += GetDamageByConstant(sWeaponBonusDamage.dice_Acid, TRUE);

     iCold += GetDamageByConstant(sSpellBonusDamage.dice_Cold, TRUE);
     iCold += GetDamageByConstant(sWeaponBonusDamage.dice_Cold, TRUE);

     iFire += GetDamageByConstant(sSpellBonusDamage.dice_Fire, TRUE);
     iFire += GetDamageByConstant(sWeaponBonusDamage.dice_Fire, TRUE);

     iElec += GetDamageByConstant(sSpellBonusDamage.dice_Elec, TRUE);
     iElec += GetDamageByConstant(sWeaponBonusDamage.dice_Elec, TRUE);

     iSon += GetDamageByConstant(sSpellBonusDamage.dice_Son, TRUE);
     iSon += GetDamageByConstant(sWeaponBonusDamage.dice_Son, TRUE);

     iDiv += GetDamageByConstant(sSpellBonusDamage.dice_Div, TRUE);
     iDiv += GetDamageByConstant(sWeaponBonusDamage.dice_Div, TRUE);

     iNeg += GetDamageByConstant(sSpellBonusDamage.dice_Neg, TRUE);
     iNeg += GetDamageByConstant(sWeaponBonusDamage.dice_Neg, TRUE);

     iPos += GetDamageByConstant(sSpellBonusDamage.dice_Pos, TRUE);
     iPos += GetDamageByConstant(sWeaponBonusDamage.dice_Pos, TRUE);

     iMag += GetDamageByConstant(sSpellBonusDamage.dice_Mag, TRUE);
     iMag += GetDamageByConstant(sWeaponBonusDamage.dice_Mag, TRUE);

     // create eLink starting with the melee weapon damage effect
     // then add all the other possible effects.
     effect eLink = eEffect;
     if (iAcid > 0) eLink = EffectLinkEffects(EffectLinkEffects(eLink, EffectDamage(iAcid, DAMAGE_TYPE_ACID, iDamagePower)), EffectVisualEffect(VFX_COM_HIT_ACID));
     if (iCold > 0) eLink = EffectLinkEffects(EffectLinkEffects(eLink, EffectDamage(iCold, DAMAGE_TYPE_COLD, iDamagePower)), EffectVisualEffect(VFX_COM_HIT_FROST ));
     if (iFire > 0) eLink = EffectLinkEffects(EffectLinkEffects(eLink, EffectDamage(iFire, DAMAGE_TYPE_FIRE, iDamagePower)), EffectVisualEffect(VFX_IMP_FLAME_S));
     if (iElec > 0) eLink = EffectLinkEffects(EffectLinkEffects(eLink, EffectDamage(iElec, DAMAGE_TYPE_ELECTRICAL, iDamagePower)), EffectVisualEffect(VFX_COM_HIT_ELECTRICAL ));
     if (iSon  > 0) eLink = EffectLinkEffects(EffectLinkEffects(eLink, EffectDamage(iSon, DAMAGE_TYPE_SONIC, iDamagePower)), EffectVisualEffect(VFX_COM_HIT_SONIC ));

     if (iDiv  > 0) eLink = EffectLinkEffects(EffectLinkEffects(eLink, EffectDamage(iDiv, DAMAGE_TYPE_DIVINE, iDamagePower)), EffectVisualEffect(VFX_COM_HIT_DIVINE));
     if (iNeg  > 0) eLink = EffectLinkEffects(EffectLinkEffects(eLink, EffectDamage(iNeg, DAMAGE_TYPE_NEGATIVE, iDamagePower)), EffectVisualEffect(VFX_COM_HIT_NEGATIVE ));
     if (iPos  > 0) eLink = EffectLinkEffects(EffectLinkEffects(eLink, EffectDamage(iPos, DAMAGE_TYPE_POSITIVE, iDamagePower)), EffectVisualEffect(VFX_COM_HIT_DIVINE));

     if (iMag  > 0) eLink = EffectLinkEffects(EffectLinkEffects(eLink, EffectDamage(iMag, DAMAGE_TYPE_MAGICAL, iDamagePower)), EffectVisualEffect(VFX_COM_HIT_DIVINE));

     return eLink;
}

void AttackLoopLogic(object oDefender, object oAttacker, int iBonusAttacks, int iMainAttacks, int iOffHandAttacks, int iMod, struct AttackLoopVars sAttackVars, struct BonusDamage sMainWeaponDamage, struct BonusDamage sOffHandWeaponDamage, struct BonusDamage sSpellBonusDamage, int iMainHand, int bIsCleaveAttack)
{
     // if there is no valid target, then no attack
     if( !GetIsObjectValid(oDefender) )
     {
         return;
     }

     // If they are not within melee range
     // Move to the new target so that you can attack next round.
     if(!GetIsInMeleeRange(oDefender, oAttacker) && !sAttackVars.bIsRangedWeapon )
     {
         AssignCommand(oAttacker, ActionMoveToLocation(GetLocation(oDefender), TRUE) );
         return;
     }

     effect eDamage;
     string sMes = "";
     int iAttackRoll = 0;
     int bIsCritcal = FALSE;

     // set duration type of special effect based on passed value
     int iDurationType = DURATION_TYPE_INSTANT;
     if (sAttackVars.eDuration > 0.0) iDurationType = DURATION_TYPE_TEMPORARY;
     if (sAttackVars.eDuration < 0.0) iDurationType = DURATION_TYPE_PERMANENT;

     // check defender HP and validity before attacking
     if(GetCurrentHitPoints(oDefender) > 0 || GetIsObjectValid(oDefender))
     {
          // set weapon variables to right hand
          object oWeapon   = sAttackVars.oWeaponR;
          int iAttackBonus = sAttackVars.iMainAttackBonus;
          int iWeaponDamageRound = sAttackVars.iMainWeaponDamageRound;
          int iNumDice  = sAttackVars.iMainNumDice;
          int iNumSides = sAttackVars.iMainNumSides;
          int iCritMult = sAttackVars.iMainCritMult;
          struct BonusDamage sWeaponDamage = sMainWeaponDamage;

          // if attack is from left hand set vars to left hand values
          if (iMainHand == 1)
          {
              oWeapon   = sAttackVars.oWeaponL;
              iAttackBonus = sAttackVars.iOffHandAttackBonus;
              iWeaponDamageRound = sAttackVars.iOffHandWeaponDamageRound;
              iNumDice  = sAttackVars.iOffHandNumDice;
              iNumSides = sAttackVars.iOffHandNumSides;
              iCritMult = sAttackVars.iOffHandCritMult;
              sWeaponDamage = sOffHandWeaponDamage;
          }

          // animation code
          if(!sAttackVars.bIsRangedWeapon)
          {
          }
          else
          {
          }

          // code to perform actual attack
          iAttackRoll = GetAttackRoll(oDefender, oAttacker, oWeapon, iMainHand, iAttackBonus, iMod, TRUE, 0.0);

          if (iAttackRoll == 2) bIsCritcal = TRUE;
          eDamage = GetAttackDamage(oDefender, oAttacker, oWeapon, sWeaponDamage, sSpellBonusDamage, iMainHand, iWeaponDamageRound, bIsCritcal, iNumDice, iNumSides, iCritMult);

          if(iAttackRoll > 0)
          {
              ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oDefender);
          }

          // if special effect applies to all attacks and you hit them
          if(sAttackVars.bEffectAllAttacks && iAttackRoll > 0)
          {
               if(sAttackVars.iDamageModifier > 0)
               {
                    int iDamagePower = GetDamagePowerConstant(oWeapon, oDefender, oAttacker);
                    effect eBonusDamage = EffectDamage(sAttackVars.iDamageModifier, sAttackVars.iDamageType, iDamagePower);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eBonusDamage, oDefender);
               }

               ApplyEffectToObject(iDurationType, sAttackVars.eSpecialEffect, oDefender, sAttackVars.eDuration);
               FloatingTextStringOnCreature(sAttackVars.sMessageSuccess, oAttacker, FALSE);
          }
          // if special applies to all attacks and you miss
          else if(sAttackVars.bEffectAllAttacks && iAttackRoll == 0)
          {
               FloatingTextStringOnCreature(sAttackVars.sMessageFailure, oAttacker, FALSE);
          }
          // first attack in main hand, apply special effect
          else if(bFirstAttack && !sAttackVars.bEffectAllAttacks &&  iAttackRoll > 0)
          {
               if(sAttackVars.iDamageModifier > 0)
               {
                    int iDamagePower = GetDamagePowerConstant(oWeapon, oDefender, oAttacker);
                    effect eBonusDamage = EffectDamage(sAttackVars.iDamageModifier, sAttackVars.iDamageType, iDamagePower);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eBonusDamage, oDefender);
               }

               ApplyEffectToObject(iDurationType, sAttackVars.eSpecialEffect, oDefender, sAttackVars.eDuration);
               FloatingTextStringOnCreature(sAttackVars.sMessageSuccess, oAttacker, FALSE);
               bFirstAttack = FALSE;
          }
          // first attack, only applies to first attack, and you miss
          else if(bFirstAttack && !sAttackVars.bEffectAllAttacks && iAttackRoll == 0)
          {
               FloatingTextStringOnCreature(sAttackVars.sMessageFailure, oAttacker, FALSE);
               bFirstAttack = FALSE;
          }

          // if this attack is a cleave attack
          if(bIsCleaveAttack && iAttackRoll > 0)
          {
              if(GetHasFeat(FEAT_GREAT_CLEAVE, oAttacker)) sMes = "*Great Cleave Hit*";
              else if(GetHasFeat(FEAT_CLEAVE, oAttacker))  sMes = "*Cleave Attack Hit*";
              FloatingTextStringOnCreature(sMes, oAttacker, FALSE);
          }
          else if(bIsCleaveAttack)
          {
              if(GetHasFeat(FEAT_GREAT_CLEAVE, oAttacker)) sMes = "*Great Cleave Miss*";
              else if(GetHasFeat(FEAT_CLEAVE, oAttacker))  sMes = "*Cleave Attack Miss*";
              FloatingTextStringOnCreature(sMes, oAttacker, FALSE);
          }

          // Code to remove ammo from inventory after an attack is made
          if( sAttackVars.bIsRangedWeapon )
          {
               SetItemStackSize(sAttackVars.oAmmo, (GetItemStackSize(sAttackVars.oAmmo) - 1) );
          }

          // code for circle kick
          if(GetHasFeat(FEAT_CIRCLE_KICK, oAttacker) &&
             GetHasMonkWeaponEquipped(oAttacker) &&
             iCircleKick == 0 &&
             iAttackRoll > 0 )
          {
               // Find nearest enemy creature within 10 feet
               int iVal = 1;
               int bNoEnemyInRange = FALSE;
               object oTarget = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, TRUE, oAttacker, iVal, CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, -1, -1);
               while(oTarget != oDefender || !bNoEnemyInRange )
               {
                    iVal += 1;
                    oTarget = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, TRUE, oAttacker, iVal, CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, -1, -1);
                    if(!GetIsInMeleeRange(oDefender, oAttacker) )
                         bNoEnemyInRange = TRUE;
               }

               if(!bNoEnemyInRange)
               {
                    iAttackRoll = GetAttackRoll(oTarget, oAttacker, oWeapon, iMainHand, iAttackBonus, iMod, TRUE, 0.0);
                    if(iAttackRoll == 2)      eDamage = GetAttackDamage(oTarget, oAttacker, oWeapon, sWeaponDamage, sSpellBonusDamage, iMainHand, iWeaponDamageRound, TRUE, iNumDice, iNumSides, iCritMult);
                    else if(iAttackRoll == 1) eDamage = GetAttackDamage(oTarget, oAttacker, oWeapon, sWeaponDamage, sSpellBonusDamage, iMainHand, iWeaponDamageRound, FALSE, iNumDice, iNumSides, iCritMult);

                    if(iAttackRoll > 0)
                    {
                         ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
                         sMes = "*Circle Kick Hit*";
                         FloatingTextStringOnCreature(sMes, oAttacker, FALSE);
                    }
                    else
                    {
                         sMes = "*Circle Kick Miss*";
                         FloatingTextStringOnCreature(sMes, oAttacker, FALSE);
                    }
               }
               iCircleKick = 1;
          }
     }

     // checks hp of enemy to see if they are alive still or not
     if(GetCurrentHitPoints(oDefender) < 1 || !GetIsObjectValid(oDefender))
     {
          // if enemy is dead find a new target
          int iVal = 1;
          object oNewDefender = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, TRUE, oAttacker, iVal, CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, -1, -1);
          while( !GetIsObjectValid(oNewDefender) || GetCurrentHitPoints(oNewDefender) < 1)
          {
               iVal += 1;
               oNewDefender = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, TRUE, oAttacker, iVal, CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, -1, -1);
          }

          oDefender = oNewDefender;

          // if there is no new valid target, then no more attacks
          if( !GetIsObjectValid(oDefender) )
          {
              oDefender = OBJECT_INVALID;
              oNewDefender = OBJECT_INVALID;
              SendMessageToPC(oAttacker, "No new valid targets to attack!");
              return;
          }

          if(!GetIsInMeleeRange(oDefender, oAttacker) && !sAttackVars.bIsRangedWeapon )
          {
              // if no enemy is close enough, run to the nearest target
              AssignCommand(oAttacker, ActionMoveToLocation(GetLocation(oDefender), TRUE) );
              return;
          }
          else if(!sAttackVars.bIsRangedWeapon)
          {
               //check for cleave
               if( GetHasFeat(FEAT_GREAT_CLEAVE, oAttacker) ||
                   (GetHasFeat(FEAT_CLEAVE, oAttacker) && iCleaveAttacks == 0)
                 )
               {
                    // perform cleave
                    // recall this function with Cleave = TRUE
                    iCleaveAttacks += 1;

                    AttackLoopLogic(oDefender, oAttacker, iBonusAttacks, iMainAttacks, iOffHandAttacks, iMod, sAttackVars, sMainWeaponDamage, sOffHandWeaponDamage, sSpellBonusDamage, iMainHand, TRUE);
                    return;
               }
          }
     }

     // Has the same number of main and off-hand attacks left
     // thus the player has attacked with both main and off-hand
     // and should now have -5 to their next attack iterations.
     if(iOffHandAttacks > 0 && iMainAttacks == iOffHandAttacks && !bIsCleaveAttack)
     {
          iMod -= 5;
     }
     else if(iOffHandAttacks == 0 && iBonusAttacks == 0 && !bIsCleaveAttack)
     {
          // if iOffHandAttacks = 0  and iBonusAttacks <= 0
          // then the player only has main hand attacks
          // thus they should have their attack decremented
          iMod -= 5;
     }

     // go back to main part of loop
     DelayCommand(sAttackVars.fDelay, AttackLoopMain(oDefender, oAttacker, iBonusAttacks, iMainAttacks, iOffHandAttacks, iMod, sAttackVars, sMainWeaponDamage, sOffHandWeaponDamage, sSpellBonusDamage) );
}

void AttackLoopMain(object oDefender, object oAttacker, int iBonusAttacks, int iMainAttacks, int iOffHandAttacks, int iMod, struct AttackLoopVars sAttackVars, struct BonusDamage sMainWeaponDamage, struct BonusDamage sOffHandWeaponDamage, struct BonusDamage sSpellBonusDamage)
{
     // perform all bonus attacks
     if(iBonusAttacks > 0)
     {
          iBonusAttacks --;
          AttackLoopLogic(oDefender, oAttacker, iBonusAttacks, iMainAttacks, iOffHandAttacks, iMod, sAttackVars, sMainWeaponDamage, sOffHandWeaponDamage, sSpellBonusDamage, 0, FALSE);
     }

     // perform main attack first, then off-hand attack
     if(iBonusAttacks == 0 && iMainAttacks > 0 && iMainAttacks >= iOffHandAttacks)
     {
          iMainAttacks --;
          AttackLoopLogic(oDefender, oAttacker, iBonusAttacks, iMainAttacks, iOffHandAttacks, iMod, sAttackVars, sMainWeaponDamage, sOffHandWeaponDamage, sSpellBonusDamage, 0, FALSE);
     }
     else if(iOffHandAttacks > 0)
     {
          iOffHandAttacks --;
          AttackLoopLogic(oDefender, oAttacker, iBonusAttacks, iMainAttacks, iOffHandAttacks, iMod, sAttackVars, sMainWeaponDamage, sOffHandWeaponDamage, sSpellBonusDamage, 1, FALSE);
     }
}

void PerformAttackRound(object oDefender, object oAttacker, effect eSpecialEffect, float eDuration = 0.0, int iAttackBonusMod = 0, int iDamageModifier = 0, int iDamageType = 0, int bEffectAllAttacks = FALSE, string sMessageSuccess = "", string sMessageFailure = "")
{
     // create struct for attack loop logic
     struct AttackLoopVars sAttackVars;

     // set variables required in attack loop logic
     sAttackVars.oWeaponR = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oAttacker);
     sAttackVars.oWeaponL = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oAttacker);
     sAttackVars.bIsRangedWeapon = GetWeaponRanged(sAttackVars.oWeaponR);

     sAttackVars.iDamageModifier = iDamageModifier;
     sAttackVars.iDamageType = iDamageType;

     sAttackVars.eSpecialEffect = eSpecialEffect;
     sAttackVars.eDuration = eDuration;
     sAttackVars.bEffectAllAttacks = bEffectAllAttacks;
     sAttackVars.sMessageSuccess = sMessageSuccess;
     sAttackVars.sMessageFailure = sMessageFailure;

     // are they using a two handed weapon?
     int bIsTwoHandedMeleeWeapon = GetIsTwoHandedMeleeWeapon(sAttackVars.oWeaponR);

     // are they unarmed?
     int bIsUnarmed = FALSE;
     if(GetBaseItemType(sAttackVars.oWeaponR) == BASE_ITEM_INVALID) bIsUnarmed = TRUE;

     // if player is unarmed use gloves as weapon
     if(bIsUnarmed) sAttackVars.oWeaponR = GetItemInSlot(INVENTORY_SLOT_ARMS, oAttacker);

     // is the player is using two weapons?
     int bIsUsingTwoWeapons = FALSE;
     if(!sAttackVars.bIsRangedWeapon && !bIsUnarmed && GetBaseItemType(sAttackVars.oWeaponL) != BASE_ITEM_INVALID )  bIsUsingTwoWeapons = TRUE;

     // determine attack bonus and num attacks
     sAttackVars.iMainAttackBonus = GetAttackBonus(oDefender, oAttacker, sAttackVars.oWeaponR, 0);

     // number of attacks with main hand
     int iMainHandAttacks = GetMainHandAttacks(oAttacker);

     // Determine physical damage per round (cached for multiple use)
     sAttackVars.iMainWeaponDamageRound = GetWeaponDamagePerRound(oDefender, oAttacker, sAttackVars.oWeaponR, 0);

     // varaibles that store extra damage dealt
     struct BonusDamage sSpellBonusDamage = GetMagicalBonusDamage(oAttacker);
     struct BonusDamage sMainWeaponDamage = GetWeaponBonusDamage(sAttackVars.oWeaponR, oDefender);

     // get weapon information
     int iMainWeaponType = GetBaseItemType(sAttackVars.oWeaponR);
     sAttackVars.iMainNumSides = StringToInt(Get2DAString("baseitems", "DieToRoll", iMainWeaponType));
     sAttackVars.iMainNumDice = StringToInt(Get2DAString("baseitems", "NumDice", iMainWeaponType));
     sAttackVars.iMainCritMult = GetWeaponCritcalMultiplier(oAttacker, sAttackVars.oWeaponR);

     // Returns proper unarmed damage if they are a monk
     // or have a creature weapon from a PrC class. - Brawler, Shou, IoDM, etc.
     if(bIsUnarmed && GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oAttacker) != OBJECT_INVALID ||
        bIsUnarmed && GetLevelByClass(CLASS_TYPE_MONK, oAttacker) )
     {
          int iDamage = FindUnarmedDamage(oAttacker);
          switch(iDamage)
          {
               case MONST_DAMAGE_1D2:
                    sAttackVars.iMainNumSides = 2;
                    sAttackVars.iMainNumDice = 1;
                    break;
               case MONST_DAMAGE_1D3:
                    sAttackVars.iMainNumSides = 3;
                    sAttackVars.iMainNumDice = 1;
                    break;
               case MONST_DAMAGE_1D4:
                    sAttackVars.iMainNumSides = 4;
                    sAttackVars.iMainNumDice  = 1;
                    break;
               case MONST_DAMAGE_1D6:
                    sAttackVars.iMainNumSides = 6;
                    sAttackVars.iMainNumDice  = 1;
                    break;
               case MONST_DAMAGE_1D8:
                    sAttackVars.iMainNumSides = 8;
                    sAttackVars.iMainNumDice  = 1;
                    break;
               case MONST_DAMAGE_1D10:
                    sAttackVars.iMainNumSides = 10;
                    sAttackVars.iMainNumDice  = 1;
                    break;
               case MONST_DAMAGE_1D12:
                    sAttackVars.iMainNumSides = 12;
                    sAttackVars.iMainNumDice  = 1;
                    break;
               case MONST_DAMAGE_1D20:
                    sAttackVars.iMainNumSides = 20;
                    sAttackVars.iMainNumDice  = 1;
                    break;
               case MONST_DAMAGE_2D6:
                    sAttackVars.iMainNumSides = 6;
                    sAttackVars.iMainNumDice  = 2;
                    break;
               case MONST_DAMAGE_2D8:
                    sAttackVars.iMainNumSides = 8;
                    sAttackVars.iMainNumDice  = 2;
                    break;
               case MONST_DAMAGE_2D10:
                    sAttackVars.iMainNumSides = 10;
                    sAttackVars.iMainNumDice  = 2;
                    break;
               case MONST_DAMAGE_2D12:
                    sAttackVars.iMainNumSides = 12;
                    sAttackVars.iMainNumDice  = 2;
                    break;
               case MONST_DAMAGE_3D6:
                    sAttackVars.iMainNumSides = 6;
                    sAttackVars.iMainNumDice  = 3;
                    break;
               case MONST_DAMAGE_3D8:
                    sAttackVars.iMainNumSides = 8;
                    sAttackVars.iMainNumDice  = 3;
                    break;
               case MONST_DAMAGE_3D10:
                    sAttackVars.iMainNumSides = 10;
                    sAttackVars.iMainNumDice  = 3;
                    break;
               case MONST_DAMAGE_3D12:
                    sAttackVars.iMainNumSides = 12;
                    sAttackVars.iMainNumDice  = 3;
                    break;
          }
     }
     else if(bIsUnarmed)
     {
          // unarmed non-monk 1d3 damage
          sAttackVars.iMainNumSides = 3;
          sAttackVars.iMainNumDice  = 1;
     }

     //SendMessageToPC(oAttacker, "Weapon does " + IntToString(iMainNumDice) + "d" + IntToString(iMainNumSides) + "Damage and has a crit multiplier of " + IntToString(iMainCritMult));

     // off-hand variables
     int iOffHandWeaponType = 0;
     sAttackVars.iOffHandAttackBonus = 0;
     int iOffHandAttacks = 0;

     sAttackVars.iOffHandWeaponDamageRound = 0;
     struct BonusDamage sOffHandWeaponDamage;

     sAttackVars.iOffHandNumSides = 0;
     sAttackVars.iOffHandNumDice = 0;
     sAttackVars.iOffHandCritMult = 0;

     // only run if using two weapons
     if(bIsUsingTwoWeapons)
     {
          sAttackVars.iOffHandAttackBonus = GetAttackBonus(oDefender, oAttacker, sAttackVars.oWeaponL, 1);
          iOffHandAttacks = GetOffHandAttacks(oAttacker);
          sOffHandWeaponDamage = GetWeaponBonusDamage(sAttackVars.oWeaponL, oDefender);
          sAttackVars.iOffHandWeaponDamageRound = GetWeaponDamagePerRound(oDefender, oAttacker, sAttackVars.oWeaponL, 1);

          iOffHandWeaponType = GetBaseItemType(sAttackVars.oWeaponL);
          sAttackVars.iOffHandNumSides = StringToInt(Get2DAString("baseitems", "DieToRoll", iOffHandWeaponType));
          sAttackVars.iOffHandNumDice = StringToInt(Get2DAString("baseitems", "NumDice", iOffHandWeaponType));
          sAttackVars.iOffHandCritMult = GetWeaponCritcalMultiplier(oAttacker, sAttackVars.oWeaponL);

          //SendMessageToPC(oAttacker, "Off Hand Weapon does " + IntToString(iOffHandNumDice) + "d" + IntToString(iOffHandNumSides) + "Damage and has a crit multiplier of " + IntToString(iOffHandCritMult));
     }

     int iAttackPenalty = 0;

     int bHasHaste = FALSE;
     int nInventorySlot;
     object oItem;

     // Check for extra main hand attacks
     int iBonusMainHandAttacks = 0;
     for (nInventorySlot = 0; nInventorySlot < NUM_INVENTORY_SLOTS; nInventorySlot++)
     {
          oItem = GetItemInSlot(nInventorySlot, oAttacker);

        if(GetIsObjectValid(oItem) )
        {
             if(GetItemHasItemProperty(oItem, ITEM_PROPERTY_HASTE) )  bHasHaste = TRUE;
        }
     }
     if( GetHasEffect(EFFECT_TYPE_HASTE, oAttacker) || bHasHaste)
     {
          iBonusMainHandAttacks += 1;
     }
     if( GetHasSpellEffect(SPELL_FURIOUS_ASSAULT, oAttacker) )
     {
          iBonusMainHandAttacks += 1;
          iAttackPenalty -= 2;
     }
     if( GetHasSpellEffect(SPELL_MARTIAL_FLURRY, oAttacker) )
     {
          iBonusMainHandAttacks += 1;
          iAttackPenalty -= 2;
     }
     if( GetLastAttackMode(oAttacker) ==  COMBAT_MODE_FLURRY_OF_BLOWS )
     {
          iBonusMainHandAttacks += 1;
          iAttackPenalty -= 2;
     }
     if( GetLastAttackMode(oAttacker) ==  COMBAT_MODE_RAPID_SHOT )
     {
          iBonusMainHandAttacks += 1;
          iAttackPenalty -= 2;
     }

     // Code to equip new ammo
     // Equips new ammo if they don't have enough ammo for the whole attack round
     // or if they have no ammo equipped.
     if(sAttackVars.bIsRangedWeapon)
     {
          sAttackVars.oAmmo = GetAmmunitionFromWeapon(sAttackVars.oWeaponR, oAttacker);
          // if there is no ammunition search inventory for ammo
          if(sAttackVars.oAmmo == OBJECT_INVALID ||
             GetItemStackSize(sAttackVars.oAmmo) <= (iMainHandAttacks + iBonusMainHandAttacks) )
          {
               int bNotEquipped = TRUE;
               int iNeededAmmoType;
               int iAmmoSlot;

               switch (GetBaseItemType(sAttackVars.oWeaponR))
               {
                    case BASE_ITEM_LIGHTCROSSBOW:
                    case BASE_ITEM_HEAVYCROSSBOW:
                         iNeededAmmoType = BASE_ITEM_BOLT;
                         iAmmoSlot = INVENTORY_SLOT_BOLTS;
                         break;
                    case BASE_ITEM_SLING:
                         iNeededAmmoType = BASE_ITEM_BULLET;
                         iAmmoSlot = INVENTORY_SLOT_BULLETS;
                         break;
                    case BASE_ITEM_SHORTBOW:
                    case BASE_ITEM_LONGBOW:
                         iNeededAmmoType = BASE_ITEM_ARROW;
                         iAmmoSlot = INVENTORY_SLOT_ARROWS;
                         break;
                    case BASE_ITEM_DART:
                         iNeededAmmoType = BASE_ITEM_DART;
                         iAmmoSlot = INVENTORY_SLOT_RIGHTHAND;
                         break;
                    case BASE_ITEM_SHURIKEN:
                         iNeededAmmoType = BASE_ITEM_SHURIKEN;
                         iAmmoSlot = INVENTORY_SLOT_RIGHTHAND;
                         break;
                    case BASE_ITEM_THROWINGAXE:
                         iNeededAmmoType = BASE_ITEM_THROWINGAXE;
                         iAmmoSlot = INVENTORY_SLOT_RIGHTHAND;
                         break;
               }

               object oItem = GetFirstItemInInventory(oAttacker);
               while (GetIsObjectValid(oItem) == TRUE && bNotEquipped)
               {
                    int iAmmoType = GetBaseItemType(oItem);
                    if( iAmmoType == iNeededAmmoType)
                    {
                         AssignCommand(oAttacker, ActionEquipItem(oItem, iAmmoSlot));
                         bNotEquipped = FALSE;
                    }
                    oItem = GetNextItemInInventory(oAttacker);
               }
          }

          sAttackVars.oAmmo = GetAmmunitionFromWeapon(sAttackVars.oWeaponR, oAttacker);
          struct BonusDamage sAmmoDamage = GetWeaponBonusDamage(sAttackVars.oAmmo, oDefender);

          // if these values are better than the weapon, then use these.
          if(sAmmoDamage.dam_Acid > sMainWeaponDamage.dam_Acid) sMainWeaponDamage.dam_Acid = sAmmoDamage.dam_Acid;
          if(sAmmoDamage.dam_Cold > sMainWeaponDamage.dam_Cold) sMainWeaponDamage.dam_Cold = sAmmoDamage.dam_Cold;
          if(sAmmoDamage.dam_Fire > sMainWeaponDamage.dam_Fire) sMainWeaponDamage.dam_Fire = sAmmoDamage.dam_Fire;
          if(sAmmoDamage.dam_Elec > sMainWeaponDamage.dam_Elec) sMainWeaponDamage.dam_Elec = sAmmoDamage.dam_Elec;
          if(sAmmoDamage.dam_Son  > sMainWeaponDamage.dam_Son)  sMainWeaponDamage.dam_Son  = sAmmoDamage.dam_Son;

          if(sAmmoDamage.dam_Div > sMainWeaponDamage.dam_Div) sMainWeaponDamage.dam_Div = sAmmoDamage.dam_Div;
          if(sAmmoDamage.dam_Neg > sMainWeaponDamage.dam_Neg) sMainWeaponDamage.dam_Neg = sAmmoDamage.dam_Neg;
          if(sAmmoDamage.dam_Pos > sMainWeaponDamage.dam_Pos) sMainWeaponDamage.dam_Pos = sAmmoDamage.dam_Pos;

          if(sAmmoDamage.dam_Mag > sMainWeaponDamage.dam_Mag) sMainWeaponDamage.dam_Mag = sAmmoDamage.dam_Mag;

          if(sAmmoDamage.dam_Blud > sMainWeaponDamage.dam_Blud) sMainWeaponDamage.dam_Blud = sAmmoDamage.dam_Blud;
          if(sAmmoDamage.dam_Pier > sMainWeaponDamage.dam_Pier) sMainWeaponDamage.dam_Pier = sAmmoDamage.dam_Pier;
          if(sAmmoDamage.dam_Slash > sMainWeaponDamage.dam_Slash) sMainWeaponDamage.dam_Slash = sAmmoDamage.dam_Slash;

          if(sAmmoDamage.dice_Acid > sMainWeaponDamage.dice_Acid) sMainWeaponDamage.dice_Acid = sAmmoDamage.dice_Acid;
          if(sAmmoDamage.dice_Cold > sMainWeaponDamage.dice_Cold) sMainWeaponDamage.dice_Cold = sAmmoDamage.dice_Cold;
          if(sAmmoDamage.dice_Fire > sMainWeaponDamage.dice_Fire) sMainWeaponDamage.dice_Fire = sAmmoDamage.dice_Fire;
          if(sAmmoDamage.dice_Elec > sMainWeaponDamage.dice_Elec) sMainWeaponDamage.dice_Elec = sAmmoDamage.dice_Elec;
          if(sAmmoDamage.dice_Son  > sMainWeaponDamage.dice_Son)  sMainWeaponDamage.dice_Son  = sAmmoDamage.dice_Son;

          if(sAmmoDamage.dice_Div > sMainWeaponDamage.dice_Div) sMainWeaponDamage.dice_Div = sAmmoDamage.dice_Div;
          if(sAmmoDamage.dice_Neg > sMainWeaponDamage.dice_Neg) sMainWeaponDamage.dice_Neg = sAmmoDamage.dice_Neg;
          if(sAmmoDamage.dice_Pos > sMainWeaponDamage.dice_Pos) sMainWeaponDamage.dice_Pos = sAmmoDamage.dice_Pos;

          if(sAmmoDamage.dice_Mag > sMainWeaponDamage.dice_Mag) sMainWeaponDamage.dice_Mag = sAmmoDamage.dice_Mag;

          if(sAmmoDamage.dice_Blud > sMainWeaponDamage.dice_Blud) sMainWeaponDamage.dice_Blud = sAmmoDamage.dice_Blud;
          if(sAmmoDamage.dice_Pier > sMainWeaponDamage.dice_Pier) sMainWeaponDamage.dice_Pier = sAmmoDamage.dice_Pier;
          if(sAmmoDamage.dice_Slash > sMainWeaponDamage.dice_Slash) sMainWeaponDamage.dice_Slash = sAmmoDamage.dice_Slash;
     }

     int iMod = 0;

     // determines the delay between effect application
     // to make the system run like the normal combat system.
     sAttackVars.fDelay = (6.0 / (iMainHandAttacks + iBonusMainHandAttacks + iOffHandAttacks));
     sAttackVars.iMainAttackBonus = sAttackVars.iMainAttackBonus + iAttackPenalty;
     sAttackVars.iOffHandAttackBonus = sAttackVars.iOffHandAttackBonus + iAttackPenalty;

     // sets iMods to iAttackBonusMod
     // used in AttackLoopLogic to decrement attack bonus for attacks.
     if(bEffectAllAttacks)  iMod += iAttackBonusMod;

     AttackLoopMain(oDefender, oAttacker, iBonusMainHandAttacks, iMainHandAttacks, iOffHandAttacks, iMod, sAttackVars, sMainWeaponDamage, sOffHandWeaponDamage, sSpellBonusDamage);
}

void PerformAttack(object oDefender, object oAttacker, effect eSpecialEffect, float eDuration = 0.0, int iAttackBonusMod = 0, int iDamageModifier = 0, int iDamageType = 0, string sMessageSuccess = "", string sMessageFailure = "", int iTouchAttackType = FALSE, object oRightHandOverride = OBJECT_INVALID, object oLeftHandOverride = OBJECT_INVALID)
{
     // create struct for attack loop logic
     struct AttackLoopVars sAttackVars;

     // set variables required in attack loop logic
     sAttackVars.oWeaponR = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oAttacker);
     sAttackVars.oWeaponL = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oAttacker);
     //apply hand overrides
     if(GetIsObjectValid(oRightHandOverride))
        sAttackVars.oWeaponR = oRightHandOverride;
     if(GetIsObjectValid(oLeftHandOverride))
        sAttackVars.oWeaponR = oLeftHandOverride;
     sAttackVars.bIsRangedWeapon = GetWeaponRanged(sAttackVars.oWeaponR);


     sAttackVars.iDamageModifier = iDamageModifier;
     sAttackVars.iDamageType = iDamageType;

     sAttackVars.eSpecialEffect = eSpecialEffect;
     sAttackVars.eDuration = eDuration;
     sAttackVars.bEffectAllAttacks = FALSE;
     sAttackVars.sMessageSuccess = sMessageSuccess;
     sAttackVars.sMessageFailure = sMessageFailure;

     // are they using a two handed weapon?
     int bIsTwoHandedMeleeWeapon = GetIsTwoHandedMeleeWeapon(sAttackVars.oWeaponR);

     // are they unarmed?
     int bIsUnarmed = FALSE;
     if(GetBaseItemType(sAttackVars.oWeaponR) == BASE_ITEM_INVALID) bIsUnarmed = TRUE;

     // if player is unarmed use gloves as weapon
     if(bIsUnarmed) sAttackVars.oWeaponR = GetItemInSlot(INVENTORY_SLOT_ARMS, oAttacker);

     // is the player is using two weapons?
     int bIsUsingTwoWeapons = FALSE;
     if(!sAttackVars.bIsRangedWeapon && !bIsUnarmed && GetBaseItemType(sAttackVars.oWeaponL) != BASE_ITEM_INVALID )  bIsUsingTwoWeapons = TRUE;

     // determine attack bonus and num attacks
     sAttackVars.iMainAttackBonus = GetAttackBonus(oDefender, oAttacker, sAttackVars.oWeaponR, 0);

     // number of attacks with main hand
     // only 1 attack is made period
     int iMainHandAttacks = 1;

     // Determine physical damage per round (cached for multiple use)
     sAttackVars.iMainWeaponDamageRound = GetWeaponDamagePerRound(oDefender, oAttacker, sAttackVars.oWeaponR, 0);

     // varaibles that store extra damage dealt
     struct BonusDamage sSpellBonusDamage = GetMagicalBonusDamage(oAttacker);
     struct BonusDamage sMainWeaponDamage = GetWeaponBonusDamage(sAttackVars.oWeaponR, oDefender);

     // get weapon information
     int iMainWeaponType = GetBaseItemType(sAttackVars.oWeaponR);
     sAttackVars.iMainNumSides = StringToInt(Get2DAString("baseitems", "DieToRoll", iMainWeaponType));
     sAttackVars.iMainNumDice = StringToInt(Get2DAString("baseitems", "NumDice", iMainWeaponType));
     sAttackVars.iMainCritMult = GetWeaponCritcalMultiplier(oAttacker, sAttackVars.oWeaponR);

     // Returns proper unarmed damage if they are a monk
     // or have a creature weapon from a PrC class. - Brawler, Shou, IoDM, etc.
     if(bIsUnarmed && GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oAttacker) != OBJECT_INVALID ||
        bIsUnarmed && GetLevelByClass(CLASS_TYPE_MONK, oAttacker) )
     {
          int iDamage = FindUnarmedDamage(oAttacker);
          switch(iDamage)
          {
               case MONST_DAMAGE_1D2:
                    sAttackVars.iMainNumSides = 2;
                    sAttackVars.iMainNumDice = 1;
                    break;
               case MONST_DAMAGE_1D3:
                    sAttackVars.iMainNumSides = 3;
                    sAttackVars.iMainNumDice = 1;
                    break;
               case MONST_DAMAGE_1D4:
                    sAttackVars.iMainNumSides = 4;
                    sAttackVars.iMainNumDice  = 1;
                    break;
               case MONST_DAMAGE_1D6:
                    sAttackVars.iMainNumSides = 6;
                    sAttackVars.iMainNumDice  = 1;
                    break;
               case MONST_DAMAGE_1D8:
                    sAttackVars.iMainNumSides = 8;
                    sAttackVars.iMainNumDice  = 1;
                    break;
               case MONST_DAMAGE_1D10:
                    sAttackVars.iMainNumSides = 10;
                    sAttackVars.iMainNumDice  = 1;
                    break;
               case MONST_DAMAGE_1D12:
                    sAttackVars.iMainNumSides = 12;
                    sAttackVars.iMainNumDice  = 1;
                    break;
               case MONST_DAMAGE_1D20:
                    sAttackVars.iMainNumSides = 20;
                    sAttackVars.iMainNumDice  = 1;
                    break;
               case MONST_DAMAGE_2D6:
                    sAttackVars.iMainNumSides = 6;
                    sAttackVars.iMainNumDice  = 2;
                    break;
               case MONST_DAMAGE_2D8:
                    sAttackVars.iMainNumSides = 8;
                    sAttackVars.iMainNumDice  = 2;
                    break;
               case MONST_DAMAGE_2D10:
                    sAttackVars.iMainNumSides = 10;
                    sAttackVars.iMainNumDice  = 2;
                    break;
               case MONST_DAMAGE_2D12:
                    sAttackVars.iMainNumSides = 12;
                    sAttackVars.iMainNumDice  = 2;
                    break;
               case MONST_DAMAGE_3D6:
                    sAttackVars.iMainNumSides = 6;
                    sAttackVars.iMainNumDice  = 3;
                    break;
               case MONST_DAMAGE_3D8:
                    sAttackVars.iMainNumSides = 8;
                    sAttackVars.iMainNumDice  = 3;
                    break;
               case MONST_DAMAGE_3D10:
                    sAttackVars.iMainNumSides = 10;
                    sAttackVars.iMainNumDice  = 3;
                    break;
               case MONST_DAMAGE_3D12:
                    sAttackVars.iMainNumSides = 12;
                    sAttackVars.iMainNumDice  = 3;
                    break;
          }
     }
     else if(bIsUnarmed)
     {
          // unarmed non-monk 1d3 damage
          sAttackVars.iMainNumSides = 3;
          sAttackVars.iMainNumDice  = 1;
     }

     // off-hand variables set to null, just to make sure they are there
     int iOffHandWeaponType = 0;
     sAttackVars.iOffHandAttackBonus = 0;
     int iOffHandAttacks = 0;

     sAttackVars.iOffHandWeaponDamageRound = 0;
     struct BonusDamage sOffHandWeaponDamage;

     sAttackVars.iOffHandNumSides = 0;
     sAttackVars.iOffHandNumDice = 0;
     sAttackVars.iOffHandCritMult = 0;

     int iAttackPenalty = 0;
     int iBonusAttacks = 0;

     // Code to equip new ammo
     // Equips new ammo if they don't have enough ammo for the whole attack round
     // or if they have no ammo equipped.
     if(sAttackVars.bIsRangedWeapon)
     {
          sAttackVars.oAmmo = GetAmmunitionFromWeapon(sAttackVars.oWeaponR, oAttacker);
          // if there is no ammunition search inventory for ammo
          if(sAttackVars.oAmmo == OBJECT_INVALID ||
             GetItemStackSize(sAttackVars.oAmmo) <= (iMainHandAttacks + iBonusAttacks) )
          {
               int bNotEquipped = TRUE;
               int iNeededAmmoType;
               int iAmmoSlot;

               switch (GetBaseItemType(sAttackVars.oWeaponR))
               {
                    case BASE_ITEM_LIGHTCROSSBOW:
                    case BASE_ITEM_HEAVYCROSSBOW:
                         iNeededAmmoType = BASE_ITEM_BOLT;
                         iAmmoSlot = INVENTORY_SLOT_BOLTS;
                         break;
                    case BASE_ITEM_SLING:
                         iNeededAmmoType = BASE_ITEM_BULLET;
                         iAmmoSlot = INVENTORY_SLOT_BULLETS;
                         break;
                    case BASE_ITEM_SHORTBOW:
                    case BASE_ITEM_LONGBOW:
                         iNeededAmmoType = BASE_ITEM_ARROW;
                         iAmmoSlot = INVENTORY_SLOT_ARROWS;
                         break;
                    case BASE_ITEM_DART:
                         iNeededAmmoType = BASE_ITEM_DART;
                         iAmmoSlot = INVENTORY_SLOT_RIGHTHAND;
                         break;
                    case BASE_ITEM_SHURIKEN:
                         iNeededAmmoType = BASE_ITEM_SHURIKEN;
                         iAmmoSlot = INVENTORY_SLOT_RIGHTHAND;
                         break;
                    case BASE_ITEM_THROWINGAXE:
                         iNeededAmmoType = BASE_ITEM_THROWINGAXE;
                         iAmmoSlot = INVENTORY_SLOT_RIGHTHAND;
                         break;
               }

               object oItem = GetFirstItemInInventory(oAttacker);
               while (GetIsObjectValid(oItem) == TRUE && bNotEquipped)
               {
                    int iAmmoType = GetBaseItemType(oItem);
                    if( iAmmoType == iNeededAmmoType)
                    {
                         AssignCommand(oAttacker, ActionEquipItem(oItem, iAmmoSlot));
                         bNotEquipped = FALSE;
                    }
                    oItem = GetNextItemInInventory(oAttacker);
               }
          }

          sAttackVars.oAmmo = GetAmmunitionFromWeapon(sAttackVars.oWeaponR, oAttacker);
          struct BonusDamage sAmmoDamage = GetWeaponBonusDamage(sAttackVars.oAmmo, oDefender);

          // if these values are better than the weapon, then use these.
          if(sAmmoDamage.dam_Acid > sMainWeaponDamage.dam_Acid) sMainWeaponDamage.dam_Acid = sAmmoDamage.dam_Acid;
          if(sAmmoDamage.dam_Cold > sMainWeaponDamage.dam_Cold) sMainWeaponDamage.dam_Cold = sAmmoDamage.dam_Cold;
          if(sAmmoDamage.dam_Fire > sMainWeaponDamage.dam_Fire) sMainWeaponDamage.dam_Fire = sAmmoDamage.dam_Fire;
          if(sAmmoDamage.dam_Elec > sMainWeaponDamage.dam_Elec) sMainWeaponDamage.dam_Elec = sAmmoDamage.dam_Elec;
          if(sAmmoDamage.dam_Son  > sMainWeaponDamage.dam_Son)  sMainWeaponDamage.dam_Son  = sAmmoDamage.dam_Son;

          if(sAmmoDamage.dam_Div > sMainWeaponDamage.dam_Div) sMainWeaponDamage.dam_Div = sAmmoDamage.dam_Div;
          if(sAmmoDamage.dam_Neg > sMainWeaponDamage.dam_Neg) sMainWeaponDamage.dam_Neg = sAmmoDamage.dam_Neg;
          if(sAmmoDamage.dam_Pos > sMainWeaponDamage.dam_Pos) sMainWeaponDamage.dam_Pos = sAmmoDamage.dam_Pos;

          if(sAmmoDamage.dam_Mag > sMainWeaponDamage.dam_Mag) sMainWeaponDamage.dam_Mag = sAmmoDamage.dam_Mag;

          if(sAmmoDamage.dam_Blud > sMainWeaponDamage.dam_Blud) sMainWeaponDamage.dam_Blud = sAmmoDamage.dam_Blud;
          if(sAmmoDamage.dam_Pier > sMainWeaponDamage.dam_Pier) sMainWeaponDamage.dam_Pier = sAmmoDamage.dam_Pier;
          if(sAmmoDamage.dam_Slash > sMainWeaponDamage.dam_Slash) sMainWeaponDamage.dam_Slash = sAmmoDamage.dam_Slash;

          if(sAmmoDamage.dice_Acid > sMainWeaponDamage.dice_Acid) sMainWeaponDamage.dice_Acid = sAmmoDamage.dice_Acid;
          if(sAmmoDamage.dice_Cold > sMainWeaponDamage.dice_Cold) sMainWeaponDamage.dice_Cold = sAmmoDamage.dice_Cold;
          if(sAmmoDamage.dice_Fire > sMainWeaponDamage.dice_Fire) sMainWeaponDamage.dice_Fire = sAmmoDamage.dice_Fire;
          if(sAmmoDamage.dice_Elec > sMainWeaponDamage.dice_Elec) sMainWeaponDamage.dice_Elec = sAmmoDamage.dice_Elec;
          if(sAmmoDamage.dice_Son  > sMainWeaponDamage.dice_Son)  sMainWeaponDamage.dice_Son  = sAmmoDamage.dice_Son;

          if(sAmmoDamage.dice_Div > sMainWeaponDamage.dice_Div) sMainWeaponDamage.dice_Div = sAmmoDamage.dice_Div;
          if(sAmmoDamage.dice_Neg > sMainWeaponDamage.dice_Neg) sMainWeaponDamage.dice_Neg = sAmmoDamage.dice_Neg;
          if(sAmmoDamage.dice_Pos > sMainWeaponDamage.dice_Pos) sMainWeaponDamage.dice_Pos = sAmmoDamage.dice_Pos;

          if(sAmmoDamage.dice_Mag > sMainWeaponDamage.dice_Mag) sMainWeaponDamage.dice_Mag = sAmmoDamage.dice_Mag;

          if(sAmmoDamage.dice_Blud > sMainWeaponDamage.dice_Blud) sMainWeaponDamage.dice_Blud = sAmmoDamage.dice_Blud;
          if(sAmmoDamage.dice_Pier > sMainWeaponDamage.dice_Pier) sMainWeaponDamage.dice_Pier = sAmmoDamage.dice_Pier;
          if(sAmmoDamage.dice_Slash > sMainWeaponDamage.dice_Slash) sMainWeaponDamage.dice_Slash = sAmmoDamage.dice_Slash;
     }

     int iMod = 0;

     // determines the delay between effect application
     // to make the system run like the normal combat system.
     sAttackVars.fDelay = 0.1;
     sAttackVars.iMainAttackBonus = sAttackVars.iMainAttackBonus + iAttackPenalty;
     sAttackVars.iOffHandAttackBonus = sAttackVars.iOffHandAttackBonus + iAttackPenalty;

     // sets iMods to iAttackBonusMod
     // used in AttackLoopLogic to decrement attack bonus for attacks.
     iMod += iAttackBonusMod;

     // run this with no bonus or off-hand attacks, and only 1 main hand attack
     AttackLoopMain(oDefender, oAttacker, 0, 1, 0, iMod, sAttackVars, sMainWeaponDamage, sOffHandWeaponDamage, sSpellBonusDamage);
}

