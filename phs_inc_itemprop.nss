/*:://////////////////////////////////////////////
//:: Name Magical Item Properties Include
//:: FileName phs_inc_itemprop
//:://////////////////////////////////////////////
    This holds all the things for applying, removing and checking magical item
    propreties.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

// Check if oItem is enchanted.
int PHS_IP_GetIsEnchanted(object oItem);


// Check if oItem is enchanted.
int PHS_IP_GetIsEnchanted(object oItem)
{
    // Check with GetItemHasProperty.
    // - Checks for magical enchantments.
    // - Misses out ones that could be considered mundane. Of course, if it has, say,
    //   keen ANY AC bonus, it will be considered magical
    if(GetItemHasItemProperty(oItem, ITEM_PROPERTY_ABILITY_BONUS) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_AC_BONUS) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_AC_BONUS_VS_ALIGNMENT_GROUP) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_AC_BONUS_VS_DAMAGE_TYPE) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_AC_BONUS_VS_RACIAL_GROUP) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_AC_BONUS_VS_SPECIFIC_ALIGNMENT) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_ARCANE_SPELL_FAILURE) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_ATTACK_BONUS) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_ATTACK_BONUS_VS_ALIGNMENT_GROUP) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_ATTACK_BONUS_VS_RACIAL_GROUP) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_ATTACK_BONUS_VS_SPECIFIC_ALIGNMENT) ||
//       GetItemHasItemProperty(oItem, ITEM_PROPERTY_BASE_ITEM_WEIGHT_REDUCTION) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_BONUS_FEAT) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_BONUS_SPELL_SLOT_OF_LEVEL_N) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_CAST_SPELL) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_DAMAGE_BONUS) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_DAMAGE_BONUS_VS_SPECIFIC_ALIGNMENT) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_DAMAGE_REDUCTION) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_DAMAGE_RESISTANCE) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_DAMAGE_VULNERABILITY) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_DARKVISION) ||
//       GetItemHasItemProperty(oItem, ITEM_PROPERTY_DECREASED_ABILITY_SCORE) ||
//       GetItemHasItemProperty(oItem, ITEM_PROPERTY_DECREASED_AC) ||
//       GetItemHasItemProperty(oItem, ITEM_PROPERTY_DECREASED_ATTACK_MODIFIER) ||
//       GetItemHasItemProperty(oItem, ITEM_PROPERTY_DECREASED_DAMAGE) ||
//       GetItemHasItemProperty(oItem, ITEM_PROPERTY_DECREASED_ENHANCEMENT_MODIFIER) ||
//       GetItemHasItemProperty(oItem, ITEM_PROPERTY_DECREASED_SAVING_THROWS) ||
//       GetItemHasItemProperty(oItem, ITEM_PROPERTY_DECREASED_SAVING_THROWS_SPECIFIC) ||
//       GetItemHasItemProperty(oItem, ITEM_PROPERTY_DECREASED_SKILL_MODIFIER) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_ENHANCED_CONTAINER_REDUCED_WEIGHT) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_ENHANCEMENT_BONUS) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_ALIGNMENT_GROUP) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_RACIAL_GROUP) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_SPECIFIC_ALIGNEMENT) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_EXTRA_MELEE_DAMAGE_TYPE) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_EXTRA_RANGED_DAMAGE_TYPE) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_FREEDOM_OF_MOVEMENT) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_HASTE) ||
//       GetItemHasItemProperty(oItem, ITEM_PROPERTY_HEALERS_KIT) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_HOLY_AVENGER) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_IMMUNITY_DAMAGE_TYPE) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_IMMUNITY_MISCELLANEOUS) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_IMMUNITY_SPECIFIC_SPELL) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_IMMUNITY_SPELL_SCHOOL) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_IMMUNITY_SPELLS_BY_LEVEL) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_IMPROVED_EVASION) ||
//       GetItemHasItemProperty(oItem, ITEM_PROPERTY_KEEN) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_LIGHT) ||
//       GetItemHasItemProperty(oItem, ITEM_PROPERTY_MASSIVE_CRITICALS) ||
//       GetItemHasItemProperty(oItem, ITEM_PROPERTY_MIGHTY) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_MIND_BLANK) ||
//       GetItemHasItemProperty(oItem, ITEM_PROPERTY_MONSTER_DAMAGE) ||
//       GetItemHasItemProperty(oItem, ITEM_PROPERTY_NO_DAMAGE) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_ON_HIT_PROPERTIES) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_ON_MONSTER_HIT) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_ONHITCASTSPELL) ||
//       GetItemHasItemProperty(oItem, ITEM_PROPERTY_POISON) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_REGENERATION) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_REGENERATION_VAMPIRIC) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_SAVING_THROW_BONUS) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_SKILL_BONUS) ||
//       GetItemHasItemProperty(oItem, ITEM_PROPERTY_SPECIAL_WALK) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_SPELL_RESISTANCE) ||
//       GetItemHasItemProperty(oItem, ITEM_PROPERTY_THIEVES_TOOLS) ||
//       GetItemHasItemProperty(oItem, ITEM_PROPERTY_TRAP) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_TRUE_SEEING) ||
//       GetItemHasItemProperty(oItem, ITEM_PROPERTY_TURN_RESISTANCE) ||
       GetItemHasItemProperty(oItem, ITEM_PROPERTY_UNLIMITED_AMMUNITION))

//       GetItemHasItemProperty(oItem, ITEM_PROPERTY_USE_LIMITATION_ALIGNMENT_GROUP) ||
//       GetItemHasItemProperty(oItem, ITEM_PROPERTY_USE_LIMITATION_RACIAL_TYPE) ||
//       GetItemHasItemProperty(oItem, ITEM_PROPERTY_USE_LIMITATION_SPECIFIC_ALIGNMENT) ||
//       GetItemHasItemProperty(oItem, ITEM_PROPERTY_USE_LIMITATION_TILESET) ||
//       GetItemHasItemProperty(oItem, ITEM_PROPERTY_VISUALEFFECT) ||
//       GetItemHasItemProperty(oItem, ITEM_PROPERTY_WEIGHT_INCREASE) ||

    {
        return TRUE;
    }
    return FALSE;
}
