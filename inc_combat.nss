//::///////////////////////////////////////////////
//:: [Item Property Function]
//:: [inc_item_props.nss]
//:://////////////////////////////////////////////
//:: This file defines several functions used to
//:: simulate melee combat through scripting.
//:: This is useful for creating spells or feats
//:: which work in combat, such as the Smite Feats.
//:: The only problem at the moment is that the functions
//:: cannot determine bonuses derieved from Magical
//:: effects on creatures.  Other than that, these
//:: will behave exactly like normal combat.
//::
//:: Example: Creating a Smite Neutral feat
//:: In the spell script attached to the feat, check
//:: the alignment of the target, and run DoMeleeAttack
//:: entering the appropriate Smite bonus into iMod
//:: On a hit, call GetMeleeWeaponDamage and add the
//:: bonus damage from the feat.
//::
//:: Finally, simulate the rest of the combat round
//:: by calling DoMeleeAttack/GetMeleeWeaponDamage
//:: once for each remaining attack that the player
//:: should get.  Adding a -5 to iMod for each consecutive
//:: attack.
//:://////////////////////////////////////////////
//:: Created By: Aaon Graywolf
//:: Created On: Dec 19, 2003
//:://////////////////////////////////////////////
//:: Update: Jan 4 2002
//::    - Extended Composite bonus function to handle pretty much
//::      every property that can possibly be composited.

//:: Added Katana Finesse into the code for determining AB for
//:: DoMeleeAttack and therefore included prc_feat_const. aser

#include "prc_alterations"
//#include "prc_feat_const"
//#include "prc_spell_const"
#include "prc_ipfeat_const"

// * Returns an integer amount of damage from a constant
// * iDamageConst = DAMAGE_BONUS_* or IP_CONST_DAMAGEBONUS_*
int GetDamageByConstant(int iDamageConst, int iItemProp);

// * Returns the appropriate weapon feat given a weapon type
// * iType = BASE_ITEM_*
// * sFeat = "Focus", "Specialization", EpicFocus", "EpicSpecialization", "ImprovedCrit"
int GetFeatByWeaponType(int iType, string sFeat);

// * Returns the low end of oWeap's critical threat range
// * Accounts for Keen and Improved Critical bonuses
int GetMeleeWeaponCriticalRange(object oPC, object oWeap);

// * Performs a melee attack roll by oPC against oTarget.
// * Begins with BAB; to simulate multiple attacks in one round,
// * use iMod to add a -5 modifier for each consecutive attack.
// * If bShowFeedback is TRUE, display the attack roll in oPC's
// * message window after a delay of fDelay seconds.
// * Caveat: Cannot account for ATTACK_BONUS effects on oPC
int DoMeleeAttack(object oPC, object oWeap, object oTarget, int iMod = 0, int bShowFeedback = TRUE, float fDelay = 0.0);

// * Returns an integer amount of damage done by oPC with oWeap
// * Caveat: Cannot account for DAMAGE_BONUS effects on oPC
int GetMeleeWeaponDamage(object oPC, object oWeap, int bCrit = FALSE,int iDamage = 0);

// * Just like above except for ranged weapons
int DoRangedAttack(object oPC, object oWeap, object oTarget, int iMod = 0, int bShowFeedback = TRUE, float fDelay = 0.0);

// * Just like above except for ranged weapons
int GetRangedWeaponDamage(object oPC, object oWeap, int bCrit = FALSE,int iDamage = 0);

// * Returns the Enhancement Bonus of oWeap as DAMAGE_POWER_*
int GetWeaponEnhancement(object oWeap);

// * Oddly enough, Damage Types by weapon don't seem to appear in baseitems.2da
// * This funciton runs a switch that returns the appropriate damage type.
int GetWeaponDamageType(object oWeap);

// * Returns an  Alignment Group
int ConvAlignGr(int iGoodEvil,int iLawChaos);

// * Returns Weapon Attack bonus
// * With Alignement Bonus
int GetWeaponAtkBonusIP(object oWeap,object oTarget);

int AtkSpellEffect(object oPC);

const int SPELL_BARD_SONGS = 411;
const int SPELL_DIVINE_WRATH = 622;
const int SPELL_CURSE_SONG = 644;
const int SPELL_HELLINFERNO = 762;

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
                case BASE_ITEM_WHIP: return -1; //No constant (?)
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
                case BASE_ITEM_WHIP: return -1; //No constant (?)
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
                case BASE_ITEM_WHIP: return -1; //No constant (?)
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
            }

    return -1;
}

int GetMeleeWeaponCriticalRange(object oPC, object oWeap)
{
    int iType = GetBaseItemType(oWeap);
    int nThreat = StringToInt(Get2DAString("baseitems", "CritThreat", iType));
    int bKeen = GetItemHasItemProperty(oWeap, ITEM_PROPERTY_KEEN);
    int bImpCrit = GetHasFeat(GetFeatByWeaponType(iType, "ImprovedCrit"), oPC);

    nThreat *= bKeen ? 2 : 1;
    nThreat *= bImpCrit ? 2 : 1;

    return 21 - nThreat;
}

int DoMeleeAttack(object oPC, object oWeap, object oTarget, int iMod = 0, int bShowFeedback = TRUE, float fDelay = 0.0)
{
    //Declare in instantiate major variables
    int iDiceRoll = d20();
    int iBAB = GetBaseAttackBonus(oPC);
    int iAC = GetAC(oTarget);
    int iType = GetBaseItemType(oWeap);
    int iCritThreat = GetMeleeWeaponCriticalRange(oPC, oWeap);
    int bFinesse = GetHasFeat(FEAT_WEAPON_FINESSE, oPC);
    int bLight = StringToInt(Get2DAString("baseitems", "WeaponSize", iType)) <= 2 || iType == BASE_ITEM_RAPIER;
    int iEnhancement = GetWeaponEnhancement(oWeap);
        iEnhancement = iEnhancement < 0 ? 0 : iEnhancement;
    int bFocus = GetHasFeat(GetFeatByWeaponType(iType, "Focus"), oPC);
    int bEFocus = GetHasFeat(GetFeatByWeaponType(iType, "EpicFocus"), oPC);
    int bProwess = GetHasFeat(FEAT_EPIC_PROWESS, oPC);
    int iStr = GetAbilityModifier(ABILITY_STRENGTH, oPC);
        iStr = iStr < 0 ? 0 : iStr;
    int iDex = GetAbilityModifier(ABILITY_DEXTERITY, oPC);
        iDex = iStr < 0 ? 0 : iDex;
    string sFeedback = GetName(oPC) + " attacks " + GetName(oTarget) + ": ";
    int iReturn = 0;
    int bkatanafin = GetHasFeat(FEAT_KATANA_FINESSE, oPC) && iDex > iStr;

    //Add up total attack bonus
    int iAttackBonus = iBAB;
        iAttackBonus += (bFinesse && bLight) || bkatanafin ? iDex : iStr;
        iAttackBonus += bFocus ? 1 : 0;
        iAttackBonus += bEFocus ? 2 : 0;
        iAttackBonus += bProwess ? 1 : 0;
        iAttackBonus += iEnhancement;
        iAttackBonus += iMod;
        iAttackBonus += GetWeaponAtkBonusIP(oWeap,oTarget);
        iAttackBonus += AtkSpellEffect(oPC);


    //Check for a critical threat
    if(iDiceRoll >= iCritThreat && iDiceRoll + iAttackBonus > iAC)
    {
        sFeedback += "*critical hit*: (" + IntToString(iDiceRoll) + " + " + IntToString(iAttackBonus) + " = " + IntToString(iDiceRoll + iAttackBonus) + "): ";
        //Roll again to see if we scored a critical hit
        iDiceRoll = d20();

        sFeedback += "*threat roll*: (" + IntToString(iDiceRoll) + " + " + IntToString(iAttackBonus) + " = " + IntToString(iDiceRoll + iAttackBonus) + ")";

        if(!GetIsImmune(oTarget,IMMUNITY_TYPE_CRITICAL_HIT) && iDiceRoll + iAttackBonus > iAC)
            iReturn = 2;
        else
            iReturn = 1;
    }

    //Just a regular hit
    else if(iDiceRoll + iAttackBonus > iAC)
    {
        sFeedback += "*hit*: (" + IntToString(iDiceRoll) + " + " + IntToString(iAttackBonus) + " = " + IntToString(iDiceRoll + iAttackBonus) + ")";
        iReturn = 1;
    }

    //Missed
    else
    {
        sFeedback += "*miss*: (" + IntToString(iDiceRoll) + " + " + IntToString(iAttackBonus) + " = " + IntToString(iDiceRoll + iAttackBonus) + ")";
        iReturn = 0;
    }

    if(bShowFeedback) DelayCommand(fDelay, SendMessageToPC(oPC, sFeedback));
    return iReturn;
}

int GetMeleeWeaponDamage(object oPC, object oWeap, int bCrit = FALSE,int iDamage = 0)
{
    //Declare in instantiate major variables
    int iType = GetBaseItemType(oWeap);
    int nSides = StringToInt(Get2DAString("baseitems", "DieToRoll", iType));
    int nDice = StringToInt(Get2DAString("baseitems", "NumDice", iType));
    int nCritMult = StringToInt(Get2DAString("baseitems", "CritHitMult", iType));
    int nMassiveCrit;
    int iStr = GetAbilityModifier(ABILITY_STRENGTH, oPC);
        iStr = iStr < 0 ? 0 : iStr;
    int bSpec = GetHasFeat(GetFeatByWeaponType(iType, "Specialization"), oPC);
    int bESpec = GetHasFeat(GetFeatByWeaponType(iType, "EpicSpecialization"), oPC);
//    int iDamage = 0;
    int iBonus = 0;
    int iEnhancement = GetWeaponEnhancement(oWeap);
        iEnhancement = iEnhancement < 0 ? 0 : iEnhancement;

    //Get Damage Bonus and Massive Critical Properties from oWeap
    itemproperty ip = GetFirstItemProperty(oWeap);
    while(GetIsItemPropertyValid(ip))
    {
        int tempConst = 0;
        int iCostVal = GetItemPropertyCostTableValue(ip);

        if(GetItemPropertyType(ip) == ITEM_PROPERTY_MASSIVE_CRITICALS){
            if(iCostVal > tempConst){
                nMassiveCrit = GetDamageByConstant(iCostVal, TRUE);
                tempConst = iCostVal;
             }
        }

        if(GetItemPropertyType(ip) == ITEM_PROPERTY_DAMAGE_BONUS){
            iBonus += GetDamageByConstant(iCostVal, TRUE);
        }
        ip = GetNextItemProperty(oWeap);
    }

    //Roll the base damage dice.
    if(nSides == 2) iDamage += d2(nDice);
    if(nSides == 4) iDamage += d4(nDice);
    if(nSides == 6) iDamage += d6(nDice);
    if(nSides == 8) iDamage += d8(nDice);
    if(nSides == 10) iDamage += d10(nDice);
    if(nSides == 12) iDamage += d12(nDice);

    //Add any applicable bonuses
    if(bSpec) iDamage += 2;
    if(bESpec) iDamage += 2;
    iDamage += iStr;
    iDamage += iEnhancement;
    iDamage += iBonus;


    //Add critical bonuses
    if(bCrit){
        iDamage *= nCritMult;
        iDamage += nMassiveCrit;
    }

    return iDamage;
}

int GetWeaponEnhancement(object oWeap)
{
    int iBonus = 0;
    int iTemp;

    itemproperty ip = GetFirstItemProperty(oWeap);
    while(GetIsItemPropertyValid(ip))
    {
        if(GetItemPropertyType(ip) == ITEM_PROPERTY_ENHANCEMENT_BONUS)
            iTemp = GetItemPropertyCostTableValue(ip);
            iBonus = iTemp > iBonus ? iTemp : iBonus;
        ip = GetNextItemProperty(oWeap);
    }
    return iBonus;
}

int GetWeaponDamageType(object oWeap)
{
   int iWeaponType = GetBaseItemType(oWeap);
   int iDamageType = StringToInt(Get2DAString("baseitems","WeaponType",iWeaponType));
   switch(iDamageType)
   {
      case 0: return -1; break;
      case 1: return DAMAGE_TYPE_PIERCING; break;
      case 2: return DAMAGE_TYPE_BLUDGEONING; break;
      case 3: return DAMAGE_TYPE_SLASHING; break;
      case 4: return DAMAGE_TYPE_SLASHING; break; // slashing & piercing... slashing bonus.
   }
   return -1;
}

int DoRangedAttack(object oPC, object oWeap, object oTarget, int iMod = 0, int bShowFeedback = TRUE, float fDelay = 0.0)
{
    //Declare in instantiate major variables
    int iDiceRoll = d20();
    int iBAB = GetBaseAttackBonus(oPC);
    int iAC = GetAC(oTarget);
    int iType = GetBaseItemType(oWeap);
    int iCritThreat = GetMeleeWeaponCriticalRange(oPC, oWeap);
    int iEnhancement = GetWeaponEnhancement(oWeap);
        iEnhancement = iEnhancement < 0 ? 0 : iEnhancement;
    int bFocus = GetHasFeat(GetFeatByWeaponType(iType, "Focus"), oPC);
    int bEFocus = GetHasFeat(GetFeatByWeaponType(iType, "EpicFocus"), oPC);
    int bProwess = GetHasFeat(FEAT_EPIC_PROWESS, oPC);
    int iStr = GetAbilityModifier(ABILITY_STRENGTH, oPC);
        iStr = iStr < 0 ? 0 : iStr;
    int iDex = GetAbilityModifier(ABILITY_DEXTERITY, oPC);
        iDex = iStr < 0 ? 0 : iDex;
    string sFeedback = GetName(oPC) + " attacks " + GetName(oTarget) + ": ";
    int iReturn = 0;

    //Add up total attack bonus
    int iAttackBonus = iBAB;
        iAttackBonus += iDex;
        iAttackBonus += bFocus ? 1 : 0;
        iAttackBonus += bEFocus ? 2 : 0;
        iAttackBonus += bProwess ? 1 : 0;
        iAttackBonus += iEnhancement;
        iAttackBonus += iMod;

    //Include ATTACK_BONUS properties from the weapon
    itemproperty ip = GetFirstItemProperty(oWeap);
    while(GetIsItemPropertyValid(ip))
    {
        if(GetItemPropertyType(ip) == ITEM_PROPERTY_ATTACK_BONUS)
            iAttackBonus += GetItemPropertyCostTableValue(ip);
        ip = GetNextItemProperty(oWeap);
    }

    //Check for a critical threat
    if(iDiceRoll >= iCritThreat && iDiceRoll + iAttackBonus > iAC)
    {
        sFeedback += "*critical hit*: (" + IntToString(iDiceRoll) + " + " + IntToString(iAttackBonus) + " = " + IntToString(iDiceRoll + iAttackBonus) + "): ";
        //Roll again to see if we scored a critical hit
        iDiceRoll = d20();

        sFeedback += "*threat roll*: (" + IntToString(iDiceRoll) + " + " + IntToString(iAttackBonus) + " = " + IntToString(iDiceRoll + iAttackBonus) + ")";
        if(iDiceRoll + iAttackBonus > iAC)
            iReturn = 2;
        else
            iReturn = 1;
    }

    //Just a regular hit
    else if(iDiceRoll + iAttackBonus > iAC)
    {
        sFeedback += "*hit*: (" + IntToString(iDiceRoll) + " + " + IntToString(iAttackBonus) + " = " + IntToString(iDiceRoll + iAttackBonus) + ")";
        iReturn = 1;
    }

    //Missed
    else
    {
        sFeedback += "*miss*: (" + IntToString(iDiceRoll) + " + " + IntToString(iAttackBonus) + " = " + IntToString(iDiceRoll + iAttackBonus) + ")";
        iReturn = 0;
    }

    if(bShowFeedback) DelayCommand(fDelay, SendMessageToPC(oPC, sFeedback));
    return iReturn;
}

int GetRangedWeaponDamage(object oPC, object oWeap, int bCrit = FALSE,int iDamage = 0)
{
    //Declare in instantiate major variables
    int iType = GetBaseItemType(oWeap);
    int nSides = StringToInt(Get2DAString("baseitems", "DieToRoll", iType));
    int nDice = StringToInt(Get2DAString("baseitems", "NumDice", iType));
    int nCritMult = StringToInt(Get2DAString("baseitems", "CritHitMult", iType));
    int nMassiveCrit;
    int iStr = GetAbilityModifier(ABILITY_STRENGTH, oPC);
        iStr = iStr < 0 ? 0 : iStr;
    int bSpec = GetHasFeat(GetFeatByWeaponType(iType, "Specialization"), oPC);
    int bESpec = GetHasFeat(GetFeatByWeaponType(iType, "EpicSpecialization"), oPC);
    int iBonus = 0;
    int iEnhancement = GetWeaponEnhancement(oWeap);
        iEnhancement = iEnhancement < 0 ? 0 : iEnhancement;

    int iMaxStrBonus = 0;

    //Get Damage Bonus and Massive Critical Properties from oWeap
    itemproperty ip = GetFirstItemProperty(oWeap);
    while(GetIsItemPropertyValid(ip))
    {
        int tempConst = 0;
        int iCostVal = GetItemPropertyCostTableValue(ip);

        if(GetItemPropertyType(ip) == ITEM_PROPERTY_MASSIVE_CRITICALS){
            if(iCostVal > tempConst){
                nMassiveCrit = GetDamageByConstant(iCostVal, TRUE);
                tempConst = iCostVal;
             }
        }

        if(GetItemPropertyType(ip) == ITEM_PROPERTY_DAMAGE_BONUS){
            iBonus += GetDamageByConstant(iCostVal, TRUE);
        }

        if(GetItemPropertyType(ip) == ITEM_PROPERTY_MIGHTY){
            iMaxStrBonus += GetDamageByConstant(iCostVal, TRUE);
        }

        ip = GetNextItemProperty(oWeap);
    }

    //Roll the base damage dice.
    if(nSides == 2) iDamage += d2(nDice);
    if(nSides == 4) iDamage += d4(nDice);
    if(nSides == 6) iDamage += d6(nDice);
    if(nSides == 8) iDamage += d8(nDice);
    if(nSides == 10) iDamage += d10(nDice);
    if(nSides == 12) iDamage += d12(nDice);

    //Add any applicable bonuses
    if(bSpec) iDamage += 2;
    if(bESpec) iDamage += 4;
    iDamage += iEnhancement;
    iDamage += iBonus;

    if(iMaxStrBonus > 0)
    {
         if(iMaxStrBonus > iStr)
         {
              iDamage += iStr;
         }
         else
         {
              iDamage += iMaxStrBonus;
         }
    }

    //Add critical bonuses
    if(bCrit){
        iDamage *= nCritMult;
        iDamage += nMassiveCrit;
    }

    return iDamage;
}

int ConvAlignGr(int iGoodEvil,int iLawChaos)
{
   int Align;

   switch(iGoodEvil)
   {
    case ALIGNMENT_GOOD:
        Align=0;
        break;
    case ALIGNMENT_NEUTRAL:
        Align=1;
        break;
    case ALIGNMENT_EVIL:
        Align=2;
        break;
   }
    switch(iLawChaos)
   {
    case ALIGNMENT_LAWFUL:
        Align+=0;
        break;
    case ALIGNMENT_NEUTRAL:
        Align+=3;
        break;
    case ALIGNMENT_CHAOTIC:
        Align+=6;
        break;
   }
    return Align;
}


int GetWeaponAtkBonusIP(object oWeap,object oTarget)
{
    int iBonus = 0;
    int iTemp;

    int iRace=MyPRCGetRacialType(oTarget);

    int iGoodEvil=GetAlignmentGoodEvil(oTarget);
    int iLawChaos=GetAlignmentLawChaos(oTarget);
    int iAlignSp=ConvAlignGr(iGoodEvil,iLawChaos);
    int iAlignGr;

    itemproperty ip = GetFirstItemProperty(oWeap);
    while(GetIsItemPropertyValid(ip))
    {
        int iIp=GetItemPropertyType(ip);
        switch(iIp)
        {
            case ITEM_PROPERTY_ATTACK_BONUS:
                iTemp = GetItemPropertyCostTableValue(ip);
                break;

            case ITEM_PROPERTY_ATTACK_BONUS_VS_ALIGNMENT_GROUP:
                iAlignGr=GetItemPropertySubType(ip);

                if (iAlignGr==ALIGNMENT_NEUTRAL)
                {
                   if (iAlignGr==iLawChaos)
                       iTemp =GetItemPropertyCostTableValue(ip);
                }
                else if (iAlignGr==iGoodEvil || iAlignGr==iLawChaos || iAlignGr==IP_CONST_ALIGNMENTGROUP_ALL)
                   iTemp =GetItemPropertyCostTableValue(ip);

                break;
            case ITEM_PROPERTY_ATTACK_BONUS_VS_RACIAL_GROUP:
                iTemp = GetItemPropertySubType(ip)==iRace ? GetItemPropertyCostTableValue(ip):0 ;
                break;
            case ITEM_PROPERTY_ATTACK_BONUS_VS_SPECIFIC_ALIGNMENT:
                iTemp = GetItemPropertySubType(ip)==iAlignSp ? GetItemPropertyCostTableValue(ip):0 ;
                break;

        }

        iBonus = iTemp > iBonus ? iTemp : iBonus;
        ip = GetNextItemProperty(oWeap);
    }

    return iBonus;
}

int GetCastLvl (object oCaster,int nSpell ,int iTypeSpell)
{
   if (!GetIsObjectValid(oCaster)) return 0;

   if (GetObjectType(oCaster)==  OBJECT_TYPE_CREATURE)
      return GetCasterLvl(iTypeSpell,oCaster);

   return 0;
}

int AtkSpellEffect(object oPC)
{
   effect eff,eDmg ;
   int nAtk,eType,eSpellID,nLvl;
   object eCrea;
   int iBonus;
   int iBlud,iDiv,iSlash,iMag;

   
   eff = GetFirstEffect(oPC);
   while (GetIsEffectValid(eff))
   {
      eType = GetEffectType(eff);
      eSpellID = GetEffectSpellId(eff);

      if (eType == EFFECT_TYPE_ATTACK_INCREASE)
      {
         switch (eSpellID)
         {
            case SPELL_AID:
              // +1
              iBonus+= 1;
              break;

            case SPELL_BLESS:
              // +1
              iBonus+= 1;
              break;

            case SPELL_PRAYER:
              // +1
              iBonus+= 1 ;
              break;

            case SPELL_WAR_CRY:
              // +2
              iBonus+= 2;
              break;
            
            case SPELL_BATTLETIDE:
              iBonus+= 2;
              break;
                         
            case SPELL_BARD_SONGS:
              // bludgeon
              eCrea =GetEffectCreator(eff);
              nAtk = 1;
              if (GetIsObjectValid(eCrea))
              {
                int nLvl = GetLevelByClass(CLASS_TYPE_BARD,eCrea);
                int iPerform = GetSkillRank(SKILL_PERFORM,eCrea);
                if (nLvl>=8 && iPerform>= 15)
                   nAtk = 2;
              }
              iBonus+= nAtk;
              break;

            case SPELL_TENSERS_TRANSFORMATION:
              // +1/2 lvl
              nAtk = 0;
              nAtk = GetCastLvl (eCrea,SPELL_DIVINE_FAVOR,TYPE_DIVINE)/2;
              iBonus+= nAtk;
              break;

            case SPELL_DIVINE_POWER:
              //
              nAtk  = 0;
              if (GetIsObjectValid(eCrea))
              {
                 int nLvl = GetCastLvl (eCrea,SPELL_DIVINE_FAVOR,TYPE_DIVINE);
                 nAtk = nLvl - ((nLvl/4)*3);
              }
              iBonus+= nAtk;
              break;

            case SPELL_DIVINE_FAVOR:
              //  divine +1/3 lvl max5 min 1
              eCrea = GetEffectCreator(eff);

              nAtk = 1;
              if (GetIsObjectValid(eCrea))
              {
                 nLvl =GetCastLvl (eCrea,SPELL_DIVINE_FAVOR,TYPE_DIVINE);
                 nAtk = nLvl/3;
                 nAtk = nAtk <1 ? 1 :nAtk ;
                 nAtk = nAtk >5 ? 5 :nAtk ;
              }
              iBonus+= nAtk;
              break;

            case SPELL_TRUE_STRIKE:
              iBonus+=20;
              break;

            case SPELL_DIVINE_WRATH:
              nAtk =3;
              eCrea =GetEffectCreator(eff);
              nLvl = GetLevelByClass(CLASS_TYPE_DIVINECHAMPION,eCrea);
              nLvl = (nLvl / 5)-1;
              if (nAtk>0)
                  nAtk+= (nLvl*2);
              iBonus+=nAtk;
              break;
         }


      }
      
      else if (eType == EFFECT_TYPE_ATTACK_DECREASE)
      {


         switch (eSpellID)
         {

            case SPELLABILITY_HOWL_DOOM:
            case SPELLABILITY_GAZE_DOOM:
            case SPELL_DOOM:
              // -2
              iBonus-= 2 ;
              break;

            case SPELL_PRAYER:
              // +1
              iBonus+= 1 ;
              break;

            case SPELL_GHOUL_TOUCH:
              // -2
              iBonus-= 2;
              break;

            case SPELL_SCARE:
              // -2
              iBonus-= 2;
              break;

            case SPELL_BANE:
            case SPELL_FLARE:
              // -1
              iBonus-= 1;
              break;
              
            case SPELL_BATTLETIDE:
              iBonus-= 2;
              break;

            case SPELL_HELLINFERNO:
              iBonus-= 4;
              break;

           case SPELL_PA_POWERSHOT:
              iBonus-= 5;
              break;
            
            case SPELL_PA_IMP_POWERSHOT:
              iBonus-= 10;
              break;
              
            case SPELL_PA_SUP_POWERSHOT:
              iBonus-= 15;
              break;

            case SPELL_BIGBYS_INTERPOSING_HAND:
              iBonus-= 10;
              break;

            case SPELL_CURSE_SONG:
              // bludgeon
              eCrea =GetEffectCreator(eff);
              nAtk = 1;
              if (GetIsObjectValid(eCrea))
              {
                int nLvl = GetLevelByClass(CLASS_TYPE_BARD,eCrea);
                int iPerform = GetSkillRank(SKILL_PERFORM,eCrea);
                if (nLvl>=8 && iPerform>= 15)
                   nAtk = 2;
              }
              iBonus-= nAtk;
               break;

            case SPELL_CHARM_MONSTER:
            case SPELL_CHARM_PERSON:
            case SPELL_CHARM_PERSON_OR_ANIMAL:
            case SPELL_DOMINATE_MONSTER:
            case SPELL_DOMINATE_PERSON:
            case SPELLABILITY_BOLT_CHARM:
            case SPELLABILITY_BOLT_DAZE:
            case SPELLABILITY_BOLT_DOMINATE:
            case SPELLABILITY_BOLT_STUN:
            case SPELLABILITY_GAZE_CHARM:
            case SPELLABILITY_GAZE_DAZE:
            case SPELLABILITY_GAZE_DOMINATE:
            case SPELLABILITY_GAZE_STUNNED:
                nAtk = 0;
                if (eType == EFFECT_TYPE_FRIGHTENED)
                {
                   int nDiff = GetGameDifficulty();
                   if (nDiff == GAME_DIFFICULTY_VERY_EASY)
                     nAtk = 2;
                   else if (nDiff == GAME_DIFFICULTY_EASY)
                     nAtk = 4;

                }
                iBonus-= nAtk;
                break;

         }


      }
      eff = GetNextEffect(oPC);
   }

   return   iBonus;
}


