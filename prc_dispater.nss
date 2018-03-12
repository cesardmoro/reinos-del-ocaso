#include "inc_item_props"
#include "prc_feat_const"
#include "prc_class_const"
#include "inc_combat"

// Checks to see if weapon is metal
int IsItemMetal(object oItem)
{
  int nReturnVal=0;   // Assume it's not metal until proven otherwise.
  int type=GetBaseItemType(oItem);
  
  // Any of these Base Item Types can be considered "mostly metal"
   if (type==BASE_ITEM_BASTARDSWORD ||
       type==BASE_ITEM_BATTLEAXE ||
       type==BASE_ITEM_DAGGER ||
       type==BASE_ITEM_DIREMACE ||
       type==BASE_ITEM_DOUBLEAXE ||
       type==BASE_ITEM_DWARVENWARAXE ||
       type==BASE_ITEM_GREATAXE ||
       type==BASE_ITEM_GREATSWORD ||
       type==BASE_ITEM_HALBERD ||
       type==BASE_ITEM_HANDAXE ||
       type==BASE_ITEM_HEAVYFLAIL ||
       type==BASE_ITEM_KAMA ||
       type==BASE_ITEM_KATANA ||
       type==BASE_ITEM_KUKRI ||
       type==BASE_ITEM_LIGHTFLAIL ||
       type==BASE_ITEM_LIGHTHAMMER ||
       type==BASE_ITEM_LIGHTMACE ||
       type==BASE_ITEM_LONGSWORD ||
       type==BASE_ITEM_MORNINGSTAR ||
       type==BASE_ITEM_RAPIER ||
       type==BASE_ITEM_SCIMITAR ||
       type==BASE_ITEM_SCYTHE ||
       type==BASE_ITEM_SHORTSWORD ||
       type==BASE_ITEM_SHURIKEN ||
       type==BASE_ITEM_SICKLE ||
       type==BASE_ITEM_THROWINGAXE ||
       type==BASE_ITEM_TWOBLADEDSWORD ||
       type==BASE_ITEM_WARHAMMER)
  {
    nReturnVal=2; // Mostly metal
  }
  return nReturnVal;
}

// Device Lore +2 on Search/Disable Device
void Device_Lore(object oPC ,object oSkin ,int iLevel)
{
    // if the bonus is already applied there is no need to apply it again.
    if(GetLocalInt(oSkin, "DeviceSear") == iLevel) return;

    SetCompositeBonus(oSkin, "DeviceSear", iLevel, ITEM_PROPERTY_SKILL_BONUS,SKILL_SEARCH);
    SetCompositeBonus(oSkin, "DeviceDisa", iLevel, ITEM_PROPERTY_SKILL_BONUS,SKILL_DISABLE_TRAP);
}

// Removes any temporary item properties on the weapon when unequipped.
void RemoveIronPower(object oPC, object oWeap)
{
      if (GetLocalInt(oWeap, "DispIronPowerD"))
      {
         // Set the damage bonus from the weapon enhancement to 0
         SetCompositeDamageBonusT(oWeap, "IPEnh", 0);
         // Set the damage bonus from Iron Power to 0
         SetCompositeDamageBonusT(oWeap, "DispIronPowerD", 0);
         // Remove all temporary keen properties (sometimes they pile up, thus we'll go with 99)
         RemoveSpecificProperty(oWeap, ITEM_PROPERTY_KEEN,-1,-1, 99,"",-1,DURATION_TYPE_TEMPORARY);
      }
}

// Adds damage property and keenness
void IronPower(object oPC, object oWeap, int iBonusType)
{
   int iBonus = 0;
   int iLev = GetLevelByClass(CLASS_TYPE_DISPATER, oPC);


   // Level 4: +1 bonus.  Level 8: +2 bonus.
   if (iLev >= 4) iBonus++;
   if (iLev >= 8) iBonus++;

   // This string identifies that each hand has its own attack bonus.
   string sIronPower = "DispIronPowerA"+IntToString(iBonusType);

   // Before we start we want to remove all the properties.  If the
   // weapon/character qualifies we'll add them again.
   RemoveIronPower(oPC, oWeap);

   if (IsItemMetal(oWeap) == 2 && iBonus)
   {
         // (See inc_item_props.nss)
         // If a weapon does piercing and slashing, we do not want to add the damage.
         // in the baseitems.2da, if a weapon's type is "4", it does piercing AND slashing.
         if (StringToInt(Get2DAString("baseitems","WeaponType",GetBaseItemType(oWeap))) != 4)
         {
             IPEnhancementBonusToDamageBonus(oWeap);
         }
         
         // Add the +1 or +2 to the weapon's damage rolls
         SetCompositeDamageBonusT(oWeap, "DispIronPowerD", iBonus);
         
         // Make the weapon keen
         AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyKeen(), oWeap,9999.0);
         
         // Add a hand-specific attack roll bonus using effects (so that it doesn't go through DR)
         SetCompositeAttackBonus(oPC, sIronPower, iBonus, iBonusType);
   }
}

void main()
{

        object oPC = OBJECT_SELF;
        object oSkin = GetPCSkin(oPC);
        object oWeap1 = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
        object oWeap2 = GetItemInSlot(INVENTORY_SLOT_LEFTHAND);
        
        // make sure it doesn't mess with non-weapons
        if (GetBaseItemType(oWeap2) == BASE_ITEM_SMALLSHIELD ||
            GetBaseItemType(oWeap2) == BASE_ITEM_LARGESHIELD ||
            GetBaseItemType(oWeap2) == BASE_ITEM_TOWERSHIELD ||
            GetBaseItemType(oWeap2) == BASE_ITEM_TORCH)
                oWeap2 = OBJECT_INVALID;

        int bDivLor = GetHasFeat(FEAT_DEVICE_LORE, oPC) ? 2 : 0;

        // remove any bonuses from SetCompositeAttackBonus, we'll add them later
        // the charcter qualifies
        string sIronPowerR = "DispIronPowerA"+IntToString(ATTACK_BONUS_ONHAND);
        string sIronPowerL = "DispIronPowerA"+IntToString(ATTACK_BONUS_OFFHAND);
        SetCompositeAttackBonus(oPC, sIronPowerR, 0, ATTACK_BONUS_ONHAND);
        SetCompositeAttackBonus(oPC, sIronPowerL, 0, ATTACK_BONUS_OFFHAND);

        // Apply any iron power bonuses
        IronPower(oPC, oWeap1, ATTACK_BONUS_ONHAND);
        IronPower(oPC, oWeap2, ATTACK_BONUS_OFFHAND);

        // Remove any bonuses from items unequipped
        if (GetLocalInt(oPC,"ONEQUIP") == 1)
            RemoveIronPower(oPC, GetPCItemLastUnequipped());

        // Add device lore bonus
        if(bDivLor > 0) Device_Lore(oPC,oSkin,bDivLor);
}
