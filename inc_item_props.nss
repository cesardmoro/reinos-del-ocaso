//::///////////////////////////////////////////////
//:: [Item Property Function]
//:: [inc_item_props.nss]
//:://////////////////////////////////////////////
//:: This file defines several functions used to
//:: manipulate item properties.  In particular,
//:: It defines functions used in the prc_* files
//:: to apply passive feat bonuses.
//::
//:: Take special note of SetCompositeBonus.  This
//:: function is crucial for allowing bonuses of the
//:: same type from different PRCs to stack.
//:://////////////////////////////////////////////
//:: Created By: Aaon Graywolf
//:: Created On: Dec 19, 2003
//:://////////////////////////////////////////////
//:: Update: Jan 4 2002
//::    - Extended Composite bonus function to handle pretty much
//::      every property that can possibly be composited.

// * Checks to see if oPC has an item created by sRes in his/her inventory
int GetHasItem(object oPC, string sRes);

// * Sets up the pcskin object on oPC
// * If it already exists, simply return it
// * Otherwise, create and equip it
object GetPCSkin(object oPC);

// * Checks oItem for all properties matching iType and iSubType
// * Removes all these properties and returns their total CostTableVal.
// * This function should only be used for Item Properties that have
// * simple integer CostTableVals, such as AC, Save/Skill Bonuses, etc.
// * iType = ITEM_PROPERTY_* of bonus
// * iSubType = IP_CONST_* of bonus SubType if applicable
int TotalAndRemoveProperty(object oItem, int iType, int iSubType = -1);

// * Used to roll bonuses from multiple sources into a single property
// * Only supports properties which have simple integer CostTableVals.
// * See the switch for a list of supported types.  Some important properties
// * that CANNOT be composited are SpellResistance, DamageBonus, DamageReduction
// * DamageResistance and MassiveCritical, as these use constants instead of
// * integers for CostTableVals.
// *
// * oPC = Object wearing / using the item
// * oItem = Object to apply bonus to
// * sBonus = String name of the source for this bonus
// * iVal = Integer value to set this bonus to
// * iType: ITEM_PROPERTY_* of bonus
// * iSubType: IP_CONST_* of bonus SubType if applicable
// * 
// * LocalInts from SetCompositeBonus() when applied to the skin need to be
// * added to DeletePRCLocalInts() in prc_inc_function. When applied to equipment,
// * the LocalInts need to be added to DeletePRCLocalIntsT() in inc_item_props.
// *
// * Use SetCompositeBonus for the skin, SetCompositeBonusT for other equipment.
void SetCompositeBonus(object oItem, string sBonus, int iVal, int iType, int iSubType = -1);
void SetCompositeBonusT(object oItem, string sBonus, int iVal, int iType, int iSubType = -1); // for temporary bonuses

// * Returns the total Bonus AC of oItem
int GetACBonus(object oItem);

// * Returns the Base AC (i.e. AC without bonuses) of oItem
int GetBaseAC(object oItem);

// * Returns the opposite element from iElem or -1 if iElem is not valid
// * Can be useful for determining elemental strengths and weaknesses
// * iElem = IP_CONST_DAMAGETYPE_*
int GetOppositeElement(int iElem);

// * Used to find the damage type done by any given weapon using 2da lookups.  Returns
// * IP_CONST_DAMAGETYPE_BLUDGEONING
// * IP_CONST_DAMAGETYPE_PIERCING
// * IP_CONST_DAMAGETYPE_SLASHING
// * 
// * If this is given a non-weapon item, it returns -1.  It will probably screw up if it is not an item.
// * Only useful for item properties!
int GetItemPropertyDamageType(object oItem);

// * Used to find the damage type done by any given weapon using 2da lookups.  Returns
// * DAMAGE_TYPE_BLUDGEONING
// * DAMAGE_TYPE_PIERCING
// * DAMAGE_TYPE_SLASHING
// * 
// * If this is given a non-weapon item, it returns -1.  It will probably screw up if it is not an item.
// * Only useful for damage effects!
int GetItemDamageType(object oItem);

// * To ensure a damage bonus stacks with any existing enhancement bonus,
// * create a temporary damage bonus on the weapon.  You do not want to do this
// * if the weapon is of the "slashing and piercing" type, because the
// * enhancement bonus is considered "physical", not "slashing" or "piercing".
// *
// * Because of this strange Bioware behavior, you'll want to only call this code as such:
// *
// * if (StringToInt(Get2DAString("baseitems","WeaponType",GetBaseItemType(oWeapon))) != 4)
// * {
// *     IPEnhancementBonusToDamageBonus(oWeapon);
// * }
void IPEnhancementBonusToDamageBonus(object oWeap);

// * Used to roll bonuses from multiple sources into a single property
// * Only supports damage bonuses in a linear fashion - +1 through +20.
// *
// * Note: If you do not define iSubType, the damage applied will most likely not
// * stack with any enhancement bonus.  See IPEnhancementBonusToDamageBonus() above.
// *
// * oItem = Object to apply bonus to
// * sBonus = String name of the source for this bonus
// * iVal = Integer value to set this bonus to (damage +1 through +20)
// * iSubType: IP_CONST_DAMAGETYPE*  -- leave blank to use the weapon's damage type.
// * 
// * LocalInts from SetCompositeDamageBonus() need to be added to
// * DeletePRCLocalIntsT() in inc_item_props.
void SetCompositeDamageBonusT(object oItem, string sBonus, int iVal, int iSubType = -1); // for temporary bonuses

// Removes a specific property from an item
void RemoveSpecificProperty(object oItem, int iType, int iSubType = -1, int iCostVal = -1, int iNum = 1, string sFlag = "", int iParam1 = -1, int iDuration = DURATION_TYPE_PERMANENT);

// * Keeps track of Attack Bonus effects and stacks them appropriately... you cannot set up
// * "special" attack bonuses against races or alignments, but it will keep seperate tabs on
// * on-hand attack bonuses and off-hand attack bonuses.
// *
// * NOTE: This attack bonus is an effect on the creature, not an item property.  Item Property
// * attacks have the downside that they pierce DR, whereas effects do not.
// *
// * NOTE: DO *NOT* USE THIS FUNCTION WITH SPELL/SLA EFFECTS.  They stack fine on their own.
// *
// * oPC - PC/NPC you wish to apply an attack bonus effect to
// * sBonus - the unique name you wish to give this attack bonus
// * iVal - the amount the attack bonus should be (there is a hardcoded limit of 20)
// * iSubType - ATTACK_BONUS_MISC applies to both hands, ATTACK_BONUS_ONHAND applies to the right (main)
// *    hand, and ATTACK_BONUS_OFFHAND applies to the left (off) hand
// * 
// * LocalInts in and finally SetCompositeAttackBonus() need to be added to
// * DeletePRCLocalInts() in prc_inc_function.
void SetCompositeAttackBonus(object oPC, string sBonus, int iVal, int iSubType = ATTACK_BONUS_MISC);

int GetHasItem(object oPC, string sRes)
{
    object oItem = GetFirstItemInInventory(oPC);

    while(GetIsObjectValid(oItem) && GetResRef(oItem) != sRes)
        oItem = GetNextItemInInventory(oPC);

    return GetResRef(oItem) == sRes;
}

/*
object GetPCSkin(object oPC)
{
    object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPC);

    //Added GetHasItem check to prevent creation of extra skins on module entry
    if(!GetIsObjectValid(oSkin) && !GetHasItem(oPC, "base_prc_skin")){
        oSkin = CreateItemOnObject("base_prc_skin", oPC);
        AssignCommand(oPC, ActionEquipItem(oSkin, INVENTORY_SLOT_CARMOUR));
    }
    return oSkin;
}
*/
object GetPCSkin(object oPC)
{
    object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPC);
    if (!GetIsObjectValid(oSkin))
    {
      if ( GetHasItem(oPC, "base_prc_skin"))
      {
         oSkin = GetItemPossessedBy(oPC,"base_prc_skin");
         AssignCommand(oPC, ActionEquipItem(oSkin, INVENTORY_SLOT_CARMOUR));
      }

    //Added GetHasItem check to prevent creation of extra skins on module entry
      else {
        oSkin = CreateItemOnObject("base_prc_skin", oPC);
        AssignCommand(oPC, ActionEquipItem(oSkin, INVENTORY_SLOT_CARMOUR));
        }
    }
    return oSkin;
}

int TotalAndRemoveProperty(object oItem, int iType, int iSubType = -1)
{
    itemproperty ip = GetFirstItemProperty(oItem);
    int total = 0;

    while(GetIsItemPropertyValid(ip)){
        if(GetItemPropertyType(ip) == iType && (GetItemPropertySubType(ip) == iSubType || iSubType == -1)){
            total += GetItemPropertyCostTableValue(ip);
            RemoveItemProperty(oItem, ip);
        }
        ip = GetNextItemProperty(oItem);
    }
    return total;
}

void RemoveSpecificProperty(object oItem, int iType, int iSubType = -1, int iCostVal = -1, int iNum = 1, string sFlag = "", int iParam1 = -1, int iDuration = DURATION_TYPE_PERMANENT)
{
    int iRemoved = 0;
    itemproperty ip = GetFirstItemProperty(oItem);
    while(GetIsItemPropertyValid(ip) && iRemoved < iNum){
        int bMatch = GetItemPropertyType(ip) == iType;
            bMatch = GetItemPropertySubType(ip) == iSubType || iSubType == -1 ? bMatch : FALSE;
            bMatch = GetItemPropertyCostTableValue(ip) == iCostVal || iCostVal == -1 ? bMatch : FALSE;
            bMatch = GetItemPropertyParam1Value(ip) == iParam1 || iParam1 == -1 ? bMatch : FALSE;
            bMatch = GetItemPropertyDurationType(ip) == iDuration ? bMatch : FALSE;
        if(bMatch){
            RemoveItemProperty(oItem, ip);
            iRemoved++;
        }
        ip = GetNextItemProperty(oItem);
    }
    SetLocalInt(oItem, sFlag, 0);
}

void SetCompositeBonus(object oItem, string sBonus, int iVal, int iType, int iSubType = -1)
{
    int iOldVal = GetLocalInt(oItem, sBonus);
    int iChange = iVal - iOldVal;
    int iCurVal = 0;

    if(iChange == 0) return;

    //Moved TotalAndRemoveProperty into switch to prevent
    //accidental deletion of unsupported property types
    switch(iType)
    {
        case ITEM_PROPERTY_ABILITY_BONUS:
            iCurVal = TotalAndRemoveProperty(oItem, iType, iSubType);
            if ((iCurVal + iChange)  > 12)
            {
                iVal -= iCurVal + iChange - 12;
                iCurVal = 12;
                iChange = 0;
            }
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyAbilityBonus(iSubType, iCurVal + iChange), oItem);
            break;
        case ITEM_PROPERTY_AC_BONUS:
            iCurVal = TotalAndRemoveProperty(oItem, iType);
            if ((iCurVal + iChange)  > 20)
            {
                iVal -= iCurVal + iChange - 20;
                iCurVal = 20;
                iChange = 0;
            }
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyACBonus(iCurVal + iChange), oItem);
            break;
        case ITEM_PROPERTY_AC_BONUS_VS_ALIGNMENT_GROUP:
            iCurVal = TotalAndRemoveProperty(oItem, iType, iSubType);
            if ((iCurVal + iChange)  > 20)
            {
                iVal -= iCurVal + iChange - 20;
                iCurVal = 20;
                iChange = 0;
            }
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyACBonusVsAlign(iSubType, iCurVal + iChange), oItem);
            break;
        case ITEM_PROPERTY_AC_BONUS_VS_DAMAGE_TYPE:
            iCurVal = TotalAndRemoveProperty(oItem, iType, iSubType);
            if ((iCurVal + iChange)  > 20)
            {
                iVal -= iCurVal + iChange - 20;
                iCurVal = 20;
                iChange = 0;
            }
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyACBonusVsDmgType(iSubType, iCurVal + iChange), oItem);
            break;
        case ITEM_PROPERTY_AC_BONUS_VS_RACIAL_GROUP:
            iCurVal = TotalAndRemoveProperty(oItem, iType, iSubType);
            if ((iCurVal + iChange)  > 20)
            {
                iVal -= iCurVal + iChange - 20;
                iCurVal = 20;
                iChange = 0;
            }
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyACBonusVsRace(iSubType, iCurVal + iChange), oItem);
            break;
        case ITEM_PROPERTY_AC_BONUS_VS_SPECIFIC_ALIGNMENT:
            iCurVal = TotalAndRemoveProperty(oItem, iType, iSubType);
            if ((iCurVal + iChange)  > 20)
            {
                iVal -= iCurVal + iChange - 20;
                iCurVal = 20;
                iChange = 0;
            }
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyACBonusVsSAlign(iSubType, iCurVal + iChange), oItem);
            break;
        case ITEM_PROPERTY_ATTACK_BONUS:
            iCurVal = TotalAndRemoveProperty(oItem, iType);
            if ((iCurVal + iChange)  > 20)
            {
                iVal -= iCurVal + iChange - 20;
                iCurVal = 20;
                iChange = 0;
            }
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyAttackBonus(iCurVal + iChange), oItem);
            break;
        case ITEM_PROPERTY_ATTACK_BONUS_VS_ALIGNMENT_GROUP:
            iCurVal = TotalAndRemoveProperty(oItem, iType, iSubType);
            if ((iCurVal + iChange)  > 20)
            {
                iVal -= iCurVal + iChange - 20;
                iCurVal = 20;
                iChange = 0;
            }
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyAttackBonusVsAlign(iSubType, iCurVal + iChange), oItem);
            break;
        case ITEM_PROPERTY_ATTACK_BONUS_VS_RACIAL_GROUP:
            iCurVal = TotalAndRemoveProperty(oItem, iType, iSubType);
            if ((iCurVal + iChange)  > 20)
            {
                iVal -= iCurVal + iChange - 20;
                iCurVal = 20;
                iChange = 0;
            }
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyAttackBonusVsRace(iSubType, iCurVal + iChange), oItem);
            break;
        case ITEM_PROPERTY_ATTACK_BONUS_VS_SPECIFIC_ALIGNMENT:
            iCurVal = TotalAndRemoveProperty(oItem, iType, iSubType);
            if ((iCurVal + iChange)  > 20)
            {
                iVal -= iCurVal + iChange - 20;
                iCurVal = 20;
                iChange = 0;
            }
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyAttackBonusVsSAlign(iSubType, iCurVal + iChange), oItem);
            break;
        case ITEM_PROPERTY_DECREASED_ABILITY_SCORE:
            iCurVal = TotalAndRemoveProperty(oItem, iType, iSubType);
            if ((iCurVal + iChange)  > 20)
            {
                iVal -= iCurVal + iChange - 20;
                iCurVal = 20;
                iChange = 0;
            }
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDecreaseAbility(iSubType, iCurVal + iChange), oItem);
            break;
        case ITEM_PROPERTY_DECREASED_AC:
            iCurVal = TotalAndRemoveProperty(oItem, iType, iSubType);
            if ((iCurVal + iChange)  > 5)
            {
                iVal -= iCurVal + iChange - 5;
                iCurVal = 5;
                iChange = 0;
            }
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDecreaseAC(iSubType, iCurVal + iChange), oItem);
            break;
        case ITEM_PROPERTY_DECREASED_ATTACK_MODIFIER:
            iCurVal = TotalAndRemoveProperty(oItem, iType);
            if ((iCurVal + iChange)  > 5)
            {
                iVal -= iCurVal + iChange - 5;
                iCurVal = 5;
                iChange = 0;
            }
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyAttackPenalty(iCurVal + iChange), oItem);
            break;
        case ITEM_PROPERTY_DECREASED_ENHANCEMENT_MODIFIER:
            iCurVal = TotalAndRemoveProperty(oItem, iType);
            if ((iCurVal + iChange)  > 5)
            {
                iVal -= iCurVal + iChange - 5;
                iCurVal = 5;
                iChange = 0;
            }
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyEnhancementPenalty(iCurVal + iChange), oItem);
            break;
        case ITEM_PROPERTY_DECREASED_SAVING_THROWS:
            iCurVal = TotalAndRemoveProperty(oItem, iType, iSubType);
            if ((iCurVal + iChange)  > 20)
            {
                iVal -= iCurVal + iChange - 20;
                iCurVal = 20;
                iChange = 0;
            }
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyReducedSavingThrowVsX(iSubType, iCurVal + iChange), oItem);
            break;
        case ITEM_PROPERTY_DECREASED_SAVING_THROWS_SPECIFIC:
            iCurVal = TotalAndRemoveProperty(oItem, iType, iSubType);
            if ((iCurVal + iChange)  > 20)
            {
                iVal -= iCurVal + iChange - 20;
                iCurVal = 20;
                iChange = 0;
            }
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyReducedSavingThrow(iSubType, iCurVal + iChange), oItem);
            break;
        case ITEM_PROPERTY_DECREASED_SKILL_MODIFIER:
            iCurVal = TotalAndRemoveProperty(oItem, iType, iSubType);
            if ((iCurVal + iChange)  > 10)
            {
                iVal -= iCurVal + iChange - 10;
                iCurVal = 10;
                iChange = 0;
            }
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDecreaseSkill(iSubType, iCurVal + iChange), oItem);
            break;
        case ITEM_PROPERTY_ENHANCEMENT_BONUS:
            iCurVal = TotalAndRemoveProperty(oItem, iType);
            if ((iCurVal + iChange)  > 20)
            {
                iVal -= iCurVal + iChange - 20;
                iCurVal = 20;
                iChange = 0;
            }
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyEnhancementBonus(iCurVal + iChange), oItem);
            break;
        case ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_ALIGNMENT_GROUP:
            iCurVal = TotalAndRemoveProperty(oItem, iType, iSubType);
            if ((iCurVal + iChange)  > 20)
            {
                iVal -= iCurVal + iChange - 20;
                iCurVal = 20;
                iChange = 0;
            }
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyEnhancementBonusVsAlign(iSubType, iCurVal + iChange), oItem);
            break;
        case ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_RACIAL_GROUP:
            iCurVal = TotalAndRemoveProperty(oItem, iType);
            if ((iCurVal + iChange)  > 20)
            {
                iVal -= iCurVal + iChange - 20;
                iCurVal = 20;
                iChange = 0;
            }
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyEnhancementBonusVsRace(iSubType, iCurVal + iChange), oItem);
            break;
        case ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_SPECIFIC_ALIGNEMENT:
            iCurVal = TotalAndRemoveProperty(oItem, iType, iSubType);
            if ((iCurVal + iChange)  > 20)
            {
                iVal -= iCurVal + iChange - 20;
                iCurVal = 20;
                iChange = 0;
            }
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyEnhancementBonusVsSAlign(iSubType, iCurVal + iChange), oItem);
            break;
        case ITEM_PROPERTY_MIGHTY:
            iCurVal = TotalAndRemoveProperty(oItem, iType);
            if ((iCurVal + iChange)  > 20)
            {
                iVal -= iCurVal + iChange - 20;
                iCurVal = 20;
                iChange = 0;
            }
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyMaxRangeStrengthMod(iCurVal + iChange), oItem);
            break;
        case ITEM_PROPERTY_REGENERATION:
            iCurVal = TotalAndRemoveProperty(oItem, iType);
            if ((iCurVal + iChange)  > 20)
            {
                iVal -= iCurVal + iChange - 20;
                iCurVal = 20;
                iChange = 0;
            }
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyRegeneration(iCurVal + iChange), oItem);
            break;
        case ITEM_PROPERTY_REGENERATION_VAMPIRIC:
            iCurVal = TotalAndRemoveProperty(oItem, iType);
            if ((iCurVal + iChange)  > 20)
            {
                iVal -= iCurVal + iChange - 20;
                iCurVal = 20;
                iChange = 0;
            }
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyVampiricRegeneration(iCurVal + iChange), oItem);
            break;
        case ITEM_PROPERTY_SAVING_THROW_BONUS:
            iCurVal = TotalAndRemoveProperty(oItem, iType, iSubType);
            if ((iCurVal + iChange)  > 20)
            {
                iVal -= iCurVal + iChange - 20;
                iCurVal = 20;
                iChange = 0;
            }
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusSavingThrowVsX(iSubType, iCurVal + iChange), oItem);
            break;
        case ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC:
            iCurVal = TotalAndRemoveProperty(oItem, iType, iSubType);
            if ((iCurVal + iChange)  > 20)
            {
                iVal -= iCurVal + iChange - 20;
                iCurVal = 20;
                iChange = 0;
            }
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusSavingThrow(iSubType, iCurVal + iChange), oItem);
            break;
        case ITEM_PROPERTY_SKILL_BONUS:
            iCurVal = TotalAndRemoveProperty(oItem, iType, iSubType);
            if ((iCurVal + iChange)  > 50)
            {
                iVal -= iCurVal + iChange - 50;
                iCurVal = 50;
                iChange = 0;
            }
            AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertySkillBonus(iSubType, iCurVal + iChange), oItem);
            break;
    }
    SetLocalInt(oItem, sBonus, iVal);
}

int GetACBonus(object oItem)
{
    if(!GetIsObjectValid(oItem)) return 0;

    itemproperty ip = GetFirstItemProperty(oItem);
    int iTotal = 0;

    while(GetIsItemPropertyValid(ip)){
        if(GetItemPropertyType(ip) == ITEM_PROPERTY_AC_BONUS)
            iTotal += GetItemPropertyCostTableValue(ip);
        ip = GetNextItemProperty(oItem);
    }
    return iTotal;
}

int GetBaseAC(object oItem){ return GetItemACValue(oItem) - GetACBonus(oItem); }

int GetOppositeElement(int iElem)
{
    switch(iElem){
        case IP_CONST_DAMAGETYPE_ACID:
            return DAMAGE_TYPE_ELECTRICAL;
        case IP_CONST_DAMAGETYPE_COLD:
            return IP_CONST_DAMAGETYPE_FIRE;
        case IP_CONST_DAMAGETYPE_DIVINE:
            return IP_CONST_DAMAGETYPE_NEGATIVE;
        case IP_CONST_DAMAGETYPE_ELECTRICAL:
            return IP_CONST_DAMAGETYPE_ACID;
        case IP_CONST_DAMAGETYPE_FIRE:
            return IP_CONST_DAMAGETYPE_COLD;
        case IP_CONST_DAMAGETYPE_NEGATIVE:
            return IP_CONST_DAMAGETYPE_POSITIVE;
     }
     return -1;
}

int TotalAndRemovePropertyT(object oItem, int iType, int iSubType = -1)
{
    itemproperty ip = GetFirstItemProperty(oItem);
    int total = 0;
    int iTemp;

    while(GetIsItemPropertyValid(ip)){
        if(GetItemPropertyType(ip) == iType && (GetItemPropertySubType(ip) == iSubType || iSubType == -1)){
             iTemp = GetItemPropertyCostTableValue(ip);
            total = iTemp > total ? iTemp : total;
            if (GetItemPropertyDurationType(ip)== DURATION_TYPE_TEMPORARY) RemoveItemProperty(oItem, ip);
        }
        ip = GetNextItemProperty(oItem);
    }
    return total;
}

void SetCompositeBonusT(object oItem, string sBonus, int iVal, int iType, int iSubType = -1)
{
    int iOldVal = GetLocalInt(oItem, sBonus);
    if (GetLocalInt(GetItemPossessor(oItem),"ONREST")) iOldVal =0;
    int iChange = iVal - iOldVal;
    int iCurVal = 0;

    if(iChange == 0) return;

    //Moved TotalAndRemoveProperty into switch to prevent
    //accidental deletion of unsupported property types
    switch(iType)
    {
        case ITEM_PROPERTY_ABILITY_BONUS:
            iCurVal = TotalAndRemovePropertyT(oItem, iType, iSubType);
            if ((iCurVal + iChange)  > 12)
            {
                iVal -= iCurVal + iChange - 12;
                iCurVal = 12;
                iChange = 0;
            }
            AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyAbilityBonus(iSubType, iCurVal + iChange), oItem,9999.0);
            break;
        case ITEM_PROPERTY_AC_BONUS:
            iCurVal = TotalAndRemovePropertyT(oItem, iType);
            if ((iCurVal + iChange)  > 20)
            {
                iVal -= iCurVal + iChange - 20;
                iCurVal = 20;
                iChange = 0;
            }
            AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyACBonus(iCurVal + iChange), oItem,9999.0);
            break;
        case ITEM_PROPERTY_AC_BONUS_VS_ALIGNMENT_GROUP:
            iCurVal = TotalAndRemovePropertyT(oItem, iType, iSubType);
            if ((iCurVal + iChange)  > 20)
            {
                iVal -= iCurVal + iChange - 20;
                iCurVal = 20;
                iChange = 0;
            }
            AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyACBonusVsAlign(iSubType, iCurVal + iChange), oItem,9999.0);
            break;
        case ITEM_PROPERTY_AC_BONUS_VS_DAMAGE_TYPE:
            iCurVal = TotalAndRemovePropertyT(oItem, iType, iSubType);
            if ((iCurVal + iChange)  > 20)
            {
                iVal -= iCurVal + iChange - 20;
                iCurVal = 20;
                iChange = 0;
            }
            AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyACBonusVsDmgType(iSubType, iCurVal + iChange), oItem,9999.0);
            break;
        case ITEM_PROPERTY_AC_BONUS_VS_RACIAL_GROUP:
            iCurVal = TotalAndRemovePropertyT(oItem, iType, iSubType);
            if ((iCurVal + iChange)  > 20)
            {
                iVal -= iCurVal + iChange - 20;
                iCurVal = 20;
                iChange = 0;
            }
            AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyACBonusVsRace(iSubType, iCurVal + iChange), oItem,9999.0);
            break;
        case ITEM_PROPERTY_AC_BONUS_VS_SPECIFIC_ALIGNMENT:
            iCurVal = TotalAndRemovePropertyT(oItem, iType, iSubType);
            if ((iCurVal + iChange)  > 20)
            {
                iVal -= iCurVal + iChange - 20;
                iCurVal = 20;
                iChange = 0;
            }
            AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyACBonusVsSAlign(iSubType, iCurVal + iChange), oItem,9999.0);
            break;
        case ITEM_PROPERTY_ATTACK_BONUS:
            iCurVal = TotalAndRemovePropertyT(oItem, iType);
            if ((iCurVal + iChange)  > 20)
            {
                iVal -= iCurVal + iChange - 20;
                iCurVal = 20;
                iChange = 0;
            }
            AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyAttackBonus(iCurVal + iChange), oItem,9999.0);
            break;
        case ITEM_PROPERTY_ATTACK_BONUS_VS_ALIGNMENT_GROUP:
            iCurVal = TotalAndRemovePropertyT(oItem, iType, iSubType);
            if ((iCurVal + iChange)  > 20)
            {
                iVal -= iCurVal + iChange - 20;
                iCurVal = 20;
                iChange = 0;
            }
            AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyAttackBonusVsAlign(iSubType, iCurVal + iChange), oItem,9999.0);
            break;
        case ITEM_PROPERTY_ATTACK_BONUS_VS_RACIAL_GROUP:
            iCurVal = TotalAndRemovePropertyT(oItem, iType, iSubType);
            if ((iCurVal + iChange)  > 20)
            {
                iVal -= iCurVal + iChange - 20;
                iCurVal = 20;
                iChange = 0;
            }
            AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyAttackBonusVsRace(iSubType, iCurVal + iChange), oItem,9999.0);
            break;
        case ITEM_PROPERTY_ATTACK_BONUS_VS_SPECIFIC_ALIGNMENT:
            iCurVal = TotalAndRemovePropertyT(oItem, iType, iSubType);
            if ((iCurVal + iChange)  > 20)
            {
                iVal -= iCurVal + iChange - 20;
                iCurVal = 20;
                iChange = 0;
            }
            AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyAttackBonusVsSAlign(iSubType, iCurVal + iChange), oItem,9999.0);
            break;
        case ITEM_PROPERTY_DECREASED_ABILITY_SCORE:
            iCurVal = TotalAndRemovePropertyT(oItem, iType, iSubType);
            if ((iCurVal + iChange)  > 20)
            {
                iVal -= iCurVal + iChange - 20;
                iCurVal = 20;
                iChange = 0;
            }
            AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyDecreaseAbility(iSubType, iCurVal + iChange), oItem,9999.0);
            break;
        case ITEM_PROPERTY_DECREASED_AC:
            iCurVal = TotalAndRemovePropertyT(oItem, iType, iSubType);
            if ((iCurVal + iChange)  > 5)
            {
                iVal -= iCurVal + iChange - 5;
                iCurVal = 5;
                iChange = 0;
            }
            AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyDecreaseAC(iSubType, iCurVal + iChange), oItem,9999.0);
            break;
        case ITEM_PROPERTY_DECREASED_ATTACK_MODIFIER:
            iCurVal = TotalAndRemovePropertyT(oItem, iType);
            if ((iCurVal + iChange)  > 5)
            {
                iVal -= iCurVal + iChange - 5;
                iCurVal = 5;
                iChange = 0;
            }
            AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyAttackPenalty(iCurVal + iChange), oItem,9999.0);
            break;
        case ITEM_PROPERTY_DECREASED_ENHANCEMENT_MODIFIER:
            iCurVal = TotalAndRemovePropertyT(oItem, iType);
            if ((iCurVal + iChange)  > 5)
            {
                iVal -= iCurVal + iChange - 5;
                iCurVal = 5;
                iChange = 0;
            }
            AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyEnhancementPenalty(iCurVal + iChange), oItem,9999.0);
            break;
        case ITEM_PROPERTY_DECREASED_SAVING_THROWS:
            iCurVal = TotalAndRemovePropertyT(oItem, iType, iSubType);
            if ((iCurVal + iChange)  > 20)
            {
                iVal -= iCurVal + iChange - 20;
                iCurVal = 20;
                iChange = 0;
            }
            AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyReducedSavingThrowVsX(iSubType, iCurVal + iChange), oItem,9999.0);
            break;
        case ITEM_PROPERTY_DECREASED_SAVING_THROWS_SPECIFIC:
            iCurVal = TotalAndRemovePropertyT(oItem, iType, iSubType);
            if ((iCurVal + iChange)  > 20)
            {
                iVal -= iCurVal + iChange - 20;
                iCurVal = 20;
                iChange = 0;
            }
            AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyReducedSavingThrow(iSubType, iCurVal + iChange), oItem,9999.0);
            break;
        case ITEM_PROPERTY_DECREASED_SKILL_MODIFIER:
            iCurVal = TotalAndRemovePropertyT(oItem, iType, iSubType);
            if ((iCurVal + iChange)  > 10)
            {
                iVal -= iCurVal + iChange - 10;
                iCurVal = 10;
                iChange = 0;
            }
            AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyDecreaseSkill(iSubType, iCurVal + iChange), oItem,9999.0);
            break;
        case ITEM_PROPERTY_ENHANCEMENT_BONUS:
            iCurVal = TotalAndRemovePropertyT(oItem, iType);
            if ((iCurVal + iChange)  > 20)
            {
                iVal -= iCurVal + iChange - 20;
                iCurVal = 20;
                iChange = 0;
            }
            AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyEnhancementBonus(iCurVal + iChange), oItem,9999.0);
            break;
        case ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_ALIGNMENT_GROUP:
            iCurVal = TotalAndRemovePropertyT(oItem, iType, iSubType);
            if ((iCurVal + iChange)  > 20)
            {
                iVal -= iCurVal + iChange - 20;
                iCurVal = 20;
                iChange = 0;
            }
            AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyEnhancementBonusVsAlign(iSubType, iCurVal + iChange), oItem,9999.0);
            break;
        case ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_RACIAL_GROUP:
            iCurVal = TotalAndRemovePropertyT(oItem, iType);
            if ((iCurVal + iChange)  > 20)
            {
                iVal -= iCurVal + iChange - 20;
                iCurVal = 20;
                iChange = 0;
            }
            AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyEnhancementBonusVsRace(iSubType, iCurVal + iChange), oItem,9999.0);
            break;
        case ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_SPECIFIC_ALIGNEMENT:
            iCurVal = TotalAndRemovePropertyT(oItem, iType, iSubType);
            if ((iCurVal + iChange)  > 20)
            {
                iVal -= iCurVal + iChange - 20;
                iCurVal = 20;
                iChange = 0;
            }
            AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyEnhancementBonusVsSAlign(iSubType, iCurVal + iChange), oItem,9999.0);
            break;
        case ITEM_PROPERTY_MIGHTY:
            iCurVal = TotalAndRemovePropertyT(oItem, iType);
            if ((iCurVal + iChange)  > 20)
            {
                iVal -= iCurVal + iChange - 20;
                iCurVal = 20;
                iChange = 0;
            }
            AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyMaxRangeStrengthMod(iCurVal + iChange), oItem,9999.0);
            break;
        case ITEM_PROPERTY_REGENERATION:
            iCurVal = TotalAndRemovePropertyT(oItem, iType);
            if ((iCurVal + iChange)  > 20)
            {
                iVal -= iCurVal + iChange - 20;
                iCurVal = 20;
                iChange = 0;
            }
            AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyRegeneration(iCurVal + iChange), oItem,9999.0);
            break;
        case ITEM_PROPERTY_REGENERATION_VAMPIRIC:
            iCurVal = TotalAndRemovePropertyT(oItem, iType);
            if ((iCurVal + iChange)  > 20)
            {
                iVal -= iCurVal + iChange - 20;
                iCurVal = 20;
                iChange = 0;
            }
            AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyVampiricRegeneration(iCurVal + iChange), oItem,9999.0);
            break;
        case ITEM_PROPERTY_SAVING_THROW_BONUS:
            iCurVal = TotalAndRemovePropertyT(oItem, iType, iSubType);
            if ((iCurVal + iChange)  > 20)
            {
                iVal -= iCurVal + iChange - 20;
                iCurVal = 20;
                iChange = 0;
            }
            AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyBonusSavingThrowVsX(iSubType, iCurVal + iChange), oItem,9999.0);
            break;
        case ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC:
            iCurVal = TotalAndRemovePropertyT(oItem, iType, iSubType);
            if ((iCurVal + iChange)  > 20)
            {
                iVal -= iCurVal + iChange - 20;
                iCurVal = 20;
                iChange = 0;
            }
            AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyBonusSavingThrow(iSubType, iCurVal + iChange), oItem,9999.0);
            break;
        case ITEM_PROPERTY_SKILL_BONUS:
            iCurVal = TotalAndRemovePropertyT(oItem, iType, iSubType);
            if ((iCurVal + iChange)  > 50)
            {
                iVal -= iCurVal + iChange - 50;
                iCurVal = 50;
                iChange = 0;
            }
            AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertySkillBonus(iSubType, iCurVal + iChange), oItem,9999.0);
            break;
    }
    SetLocalInt(oItem, sBonus, iVal);
}

int GetItemPropertyDamageType(object oItem)
{
   int iWeaponType = GetBaseItemType(oItem);
   int iDamageType = StringToInt(Get2DAString("baseitems","WeaponType",iWeaponType));
   switch(iDamageType)
   {
      case 0: return -1; break;
      case 1: return IP_CONST_DAMAGETYPE_PIERCING; break;
      case 2: return IP_CONST_DAMAGETYPE_BLUDGEONING; break;
      case 3: return IP_CONST_DAMAGETYPE_SLASHING; break;
      case 4: return IP_CONST_DAMAGETYPE_SLASHING; break; // slashing & piercing... slashing bonus.
   }
   return -1;
}

int GetItemDamageType(object oItem)
{
   int iWeaponType = GetBaseItemType(oItem);
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

// To ensure the damage bonus stacks with any existing enhancement bonus,
// we create a temporary damage bonus on the weapon.  We do not want to do this
// if the weapon is of the "slashing and piercing" type, because the
// enhancement bonus is considered "physical", not "slashing" or "piercing".
// If you borrow this code, make sure to keep the "IPEnh" and realize that
// "slashing and piercing" weapons need a special case.
void IPEnhancementBonusToDamageBonus(object oWeap)
{
    int iBonus = 0;
    int iTemp;

    if (GetLocalInt(oWeap, "IPEnh") || !GetIsObjectValid(oWeap)) return;    

    itemproperty ip = GetFirstItemProperty(oWeap);
    while(GetIsItemPropertyValid(ip))
    {
        if(GetItemPropertyType(ip) == ITEM_PROPERTY_ENHANCEMENT_BONUS)
            iTemp = GetItemPropertyCostTableValue(ip);
            iBonus = iTemp > iBonus ? iTemp : iBonus;
        ip = GetNextItemProperty(oWeap);
    }
    
    SetCompositeDamageBonusT(oWeap,"IPEnh",iBonus);
}

int TotalAndRemoveDamagePropertyT(object oItem, int iSubType)
{
    itemproperty ip = GetFirstItemProperty(oItem);
    int iPropertyValue;
    int total = 0;
    int iTemp;

    while(GetIsItemPropertyValid(ip))
    {
    	iPropertyValue = GetItemPropertyCostTableValue(ip);
    	
        if((GetItemPropertyType(ip) == ITEM_PROPERTY_DAMAGE_BONUS) &&
           (GetItemPropertySubType(ip) == iSubType) &&
           ((iPropertyValue < 6) || (iPropertyValue > 15)))
        {           
            total = iPropertyValue > total ? iPropertyValue : total;
            if (GetItemPropertyDurationType(ip)== DURATION_TYPE_TEMPORARY) RemoveItemProperty(oItem, ip);
       }
        ip = GetNextItemProperty(oItem);
        
    }
    return total;
}

void SetCompositeDamageBonusT(object oItem, string sBonus, int iVal, int iSubType = -1)
{
    int iOldVal = GetLocalInt(oItem, sBonus);
    int iChange = iVal - iOldVal;
    int iLinearDamage = 0;
    int iCurVal = 0;

    
    if(iChange == 0) return;

    if (iSubType == -1) iSubType = GetItemPropertyDamageType(oItem);
    if (iSubType == -1) return;  // if it's still -1 we're not dealing with a weapon.

    iCurVal = TotalAndRemoveDamagePropertyT(oItem, iSubType);

    if (iCurVal > 15) iCurVal -= 10; // values 6-20 are in the 2da as lines 16-30
    iLinearDamage = iCurVal + iChange;
    if (iLinearDamage > 20)
    {
        iVal = iLinearDamage - 20; // Change the stored value to reflect the fact that we overflowed
        iLinearDamage = 20; // This is prior to adjustment due to non-linear values
    }
    if (iLinearDamage > 5) iLinearDamage += 10; // values 6-20 are in the 2da as lines 16-30
    AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyDamageBonus(iSubType, iLinearDamage), oItem,9999.0);

    SetLocalInt(oItem, sBonus, iVal);
}

void TotalRemovePropertyT(object oItem)
{
    itemproperty ip = GetFirstItemProperty(oItem);
    while(GetIsItemPropertyValid(ip)){
            if (GetItemPropertyDurationType(ip)== DURATION_TYPE_TEMPORARY) RemoveItemProperty(oItem, ip);
          ip = GetNextItemProperty(oItem);
        }
}

void DeletePRCLocalIntsT(object oPC, object oItem = OBJECT_INVALID)
{
   int iValid = GetIsObjectValid(oItem);
   
   // RIGHT HAND
   if (!iValid)
     oItem=GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);
   TotalRemovePropertyT(oItem);

   //Stormlord
   DeleteLocalInt(oItem,"STShock");
   DeleteLocalInt(oItem,"STThund");
   //Archer
   DeleteLocalInt(oItem,"ArcherSpec");
   //ManAtArms
   DeleteLocalInt(oItem,"ManArmsGenSpe");
   DeleteLocalInt(oItem,"ManArmsDmg");
   DeleteLocalInt(oItem,"ManArmsCore");
   //Vile/Sanctify & Un/Holy Martial Strike
   DeleteLocalInt(oItem,"SanctMar");
   DeleteLocalInt(oItem,"MartialStrik");
   DeleteLocalInt(oItem,"UnholyStrik");
   DeleteLocalInt(oItem,"USanctMar");
   // Feats
   DeleteLocalInt(oItem,"WpMasBow");
   DeleteLocalInt(oItem,"WpMasXBow");
   DeleteLocalInt(oItem,"WpMasShu");
   //Duelist Precise Strike
   DeleteLocalInt(oItem,"DuelistPreciseSlash");
   DeleteLocalInt(oItem,"DuelistPreciseSmash");
   //Duelist Elaborate Parry
   DeleteLocalInt(oItem,"ElaborateParryACBonus");
   DeleteLocalInt(oItem,"ElaborateParryAttackPenalty");
   // Blood Archer
   DeleteLocalInt(oItem,"BloodBowAttackBonus");
   DeleteLocalInt(oItem,"BloodBowMightyBonus");
   // Black Flame Zealot
   DeleteLocalInt(oItem,"BFZFlame");
   // Other
   DeleteLocalInt(oItem,"IPEnh");
   DeleteLocalInt(oItem,"IPEnhA");
   // Dispater
   DeleteLocalInt(oItem,"DispIronPowerA");
   DeleteLocalInt(oItem,"DispIronPowerD");
   // Iaijutsu Master
   DeleteLocalInt(oItem,"KatFinBonus");
   // knight Chalice
   DeleteLocalInt(oItem,"DSlayBonusDiv");
   DeleteLocalInt(oItem,"DSlayingAttackBonus");
   // prc_battledance
   DeleteLocalInt(oItem,"BADanAtk");
   // Katana Finesse
   DeleteLocalInt(oItem,"KatFinBonus");
   // Dragonwrack
   DeleteLocalInt(oItem,"DWright");
   // Holy Avenger
   DeleteLocalInt(oItem,"HolyAvAntiStack");
   // Azer Heat Damage
   DeleteLocalInt(oItem,"AzerFlameDamage");
   // Arcane Duelist
   DeleteLocalInt(oItem,"ADEnchant");

   // LEFT HAND
   if (!iValid){
     oItem=GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC);
     TotalRemovePropertyT(oItem);}
     
   //ManAtArms
   DeleteLocalInt(oItem,"ManArmsGenSpe");
   DeleteLocalInt(oItem,"ManArmsDmg");
   //Vile/Sanctify & Un/Holy Martial Strike
   DeleteLocalInt(oItem,"SanctMar");
   DeleteLocalInt(oItem,"MartialStrik");
   DeleteLocalInt(oItem,"UnholyStrik");
   DeleteLocalInt(oItem,"USanctMar");
   // Other
   DeleteLocalInt(oItem,"IPEnh");
   DeleteLocalInt(oItem,"IPEnhA");
   // Katana Finesse
   DeleteLocalInt(oItem,"KatFinBonus");
   // Demonslaying
   DeleteLocalInt(oItem,"DSlayingAttackBonus");
   // Dragonwrack
   DeleteLocalInt(oItem,"DWleft");
   // Holy Avenger
   DeleteLocalInt(oItem,"HolyAvAntiStack");
   // Dispater
   DeleteLocalInt(oItem,"DispIronPowerA");
   DeleteLocalInt(oItem,"DispIronPowerD");
   // Azer Heat Damage
   DeleteLocalInt(oItem,"AzerFlameDamage");
   
   // CHEST
   if (!iValid){
     oItem=GetItemInSlot(INVENTORY_SLOT_CHEST,oPC);
     TotalRemovePropertyT(oItem);}

   // Bladesinger
   DeleteLocalInt(oItem,"BladeASF");
   // Frenzied Berzerker
   DeleteLocalInt(oItem,"AFrenzy");
   // Shadowlord
   DeleteLocalInt(oItem,"ShaDiscorp");
   // Dragonwrack
   DeleteLocalInt(oItem,"Dragonwrack");
   
   // LEFT RING
   if (!iValid){
     oItem=GetItemInSlot(INVENTORY_SLOT_LEFTRING,oPC);
     TotalRemovePropertyT(oItem);}

   // Bladesinger
   DeleteLocalInt(oItem,"NewPowAtk");

   // ARMS
   if (!iValid){
     oItem=GetItemInSlot(INVENTORY_SLOT_ARMS,oPC);
     TotalRemovePropertyT(oItem);}
   
   // Disciple of Mephistopheles
   DeleteLocalInt(oItem,"DiscMephGlove");
   // Azer fire
   DeleteLocalInt(oItem,"AzerFlameDamage");
}

void SetCompositeAttackBonus(object oPC, string sBonus, int iVal, int iSubType = ATTACK_BONUS_MISC)
{
    object oCastingObject = CreateObject(OBJECT_TYPE_PLACEABLE, "x0_rodwonder", GetLocation(oPC));

    int iSpl = 2732; //SPELL_SET_COMPOSITE_ATTACK_BONUS;

    SetLocalString(oCastingObject, "SET_COMPOSITE_STRING", sBonus);
    SetLocalInt(oCastingObject, "SET_COMPOSITE_VALUE", iVal);
    SetLocalInt(oCastingObject, "SET_COMPOSITE_SUBTYPE", iSubType);

    DelayCommand(0.1, AssignCommand(oCastingObject, ActionCastSpellAtObject(iSpl, oPC, METAMAGIC_NONE, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE)));

    DestroyObject(oCastingObject, 6.0);
}
