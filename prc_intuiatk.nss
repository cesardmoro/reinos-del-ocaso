#include "inc_item_props"
#include "prc_feat_const"
#include "inc_combat"
#include "prc_ipfeat_const"
#include "nw_i0_spells"

const int SPELL_INTUITIVE_ATK = 2090;

int isSimple(object oItem)
{
      int iType= GetBaseItemType(oItem);

      switch (iType)
      {            
        case BASE_ITEM_MORNINGSTAR:
        case BASE_ITEM_QUARTERSTAFF:
        case BASE_ITEM_SHORTSPEAR:
        case BASE_ITEM_HEAVYCROSSBOW:
          return 1;
          break;
        case BASE_ITEM_CLUB:  
        case BASE_ITEM_DAGGER:
        case BASE_ITEM_LIGHTMACE:
        case BASE_ITEM_SICKLE:
        case BASE_ITEM_SLING:
        case BASE_ITEM_DART:
        case BASE_ITEM_LIGHTCROSSBOW:
          return 2;
          break;

      }
      return 0;
}

int isLight(object oItem)
{
     // weapon finesse works with dagger, handaxe, kama,
     // kukri, light hammer, mace, rapier, short sword,
     // whip, and unarmed strike.
     int iType = GetBaseItemType(oItem);
     
     switch (iType)
     {
        case BASE_ITEM_DAGGER:
        case BASE_ITEM_HANDAXE:
        case BASE_ITEM_KAMA:
        case BASE_ITEM_KUKRI:
        case BASE_ITEM_LIGHTHAMMER:
        case BASE_ITEM_LIGHTMACE:
        case BASE_ITEM_RAPIER:
        case BASE_ITEM_SHORTSWORD:
        case BASE_ITEM_WHIP:
            return TRUE;
            break;
     }
     return FALSE;
}

void main()
{
   object oPC = OBJECT_SELF;
   object oSkin = GetPCSkin(oPC);

   if (GetHasFeat(FEAT_RAVAGEGOLDENICE, oPC))
   {

       int iEquip = GetLocalInt(oPC,"ONEQUIP") ;
       object oItem;
       
       if (iEquip == 1)
            oItem = GetPCItemLastUnequipped();
       else
            oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);
      
       
       if (iEquip == 1||GetAlignmentGoodEvil(oPC)!= ALIGNMENT_GOOD)
       {
          if (GetBaseItemType(oItem)==BASE_ITEM_GLOVES)
             RemoveSpecificProperty(oItem,ITEM_PROPERTY_ONHITCASTSPELL,IP_CONST_ONHIT_CASTSPELL_RAVAGEGOLDENICE);
       }
       else
       {
         oItem = GetItemInSlot(INVENTORY_SLOT_ARMS,oPC);
         RemoveSpecificProperty(oItem,ITEM_PROPERTY_ONHITCASTSPELL,IP_CONST_ONHIT_CASTSPELL_RAVAGEGOLDENICE);
         AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_RAVAGEGOLDENICE,2),oItem);
       }

        object oCweapB = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B,oPC);
        object oCweapL = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L,oPC);
        object oCweapR = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R,oPC);
        RemoveSpecificProperty(oCweapB,ITEM_PROPERTY_ONHITCASTSPELL,IP_CONST_ONHIT_CASTSPELL_RAVAGEGOLDENICE);
        RemoveSpecificProperty(oCweapL,ITEM_PROPERTY_ONHITCASTSPELL,IP_CONST_ONHIT_CASTSPELL_RAVAGEGOLDENICE);
        RemoveSpecificProperty(oCweapR,ITEM_PROPERTY_ONHITCASTSPELL,IP_CONST_ONHIT_CASTSPELL_RAVAGEGOLDENICE);

        if (GetAlignmentGoodEvil(oPC)== ALIGNMENT_GOOD)
        {
          AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_RAVAGEGOLDENICE,2),oCweapB);
          AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_RAVAGEGOLDENICE,2),oCweapL);
          AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_RAVAGEGOLDENICE,2),oCweapR);
        }


   }

   if(GetHasFeat(FEAT_INTUITIVE_ATTACK, oPC) || GetHasFeat(FEAT_WEAPON_FINESSE, oPC))
   {
      // shorthand - IA is intuitive attack and WF is weapon finesse   
      object oItem ;
      int iEquip = GetLocalInt(oPC,"ONEQUIP") ;
      int iStr = GetAbilityModifier(ABILITY_STRENGTH,oPC);
      int iDex = GetAbilityModifier(ABILITY_DEXTERITY,oPC);
      int iWis = GetAbilityModifier(ABILITY_WISDOM,oPC);
      int iIABonus = 0;
      int iWFBonus = 0;
      int bHasIA = GetHasFeat(FEAT_INTUITIVE_ATTACK, oPC);
      int bHasWF = GetHasFeat(FEAT_WEAPON_FINESSE, oPC);
      int bUseIA = FALSE;
      int bUseWF = FALSE;
      int bIsSimpleR = isSimple(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC));
      int bIsSimpleL = isSimple(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC));
      int bIsLightR = isLight(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC));
      int bIsLightL = isLight(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC));
      int bXBowEq = GetBaseItemType(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) == BASE_ITEM_LIGHTCROSSBOW ||
                    GetBaseItemType(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) == BASE_ITEM_HEAVYCROSSBOW;
      int bUnarmed = GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC)) == FALSE;
      int bCreWeap = bUnarmed && GetLocalInt(oPC, "UsingCreature") == TRUE;

      // Initialize all these values to 0:
      SetCompositeAttackBonus(oPC, "IntuitiveAttackR", 0, ATTACK_BONUS_ONHAND);
      SetCompositeAttackBonus(oPC, "IntuitiveAttackL", 0, ATTACK_BONUS_OFFHAND);
      SetCompositeAttackBonus(oPC, "InutitiveAttackUnarmed", 0);
      SetLocalInt(oPC, "UnarmedWeaponFinesseBonus", 0);

      // only consider Weapon Finesse if Dex is higher than Str
      if (bHasWF && iDex > iStr)
      {
          bUseWF = TRUE;
          iWFBonus = iDex - iStr;
      }

      // only consider Intuitive Attack if Wis is higher than Str and character is good
      if (bHasIA && iWis > iStr && GetAlignmentGoodEvil(oPC) == ALIGNMENT_GOOD)
      {
          bUseIA = TRUE;
          iIABonus = iWis - iStr;
      }
      
      // do not consider Intuitive Attack if the character is using a crossbow and the zen archery feat.
      if (GetHasFeat(FEAT_ZEN_ARCHERY, oPC) && bXBowEq)
      {
          bUseIA = FALSE;
      }

      // If the character only has intuitive attack, add appropriate bonuses.
      if (bUseIA && !bUseWF)
      {
          if (bIsSimpleR)
              SetCompositeAttackBonus(oPC, "IntuitiveAttackR", iIABonus, ATTACK_BONUS_ONHAND);
          else if (bUnarmed)
              SetCompositeAttackBonus(oPC, "IntuitiveAttackUnarmed", iIABonus);

          if (bIsSimpleL)
              SetCompositeAttackBonus(oPC, "IntuitiveAttackL", iIABonus, ATTACK_BONUS_OFFHAND);
      }
      // If the character has both intuitive attack and weapon finesse, things can get hairy:
      else if (bUseWF && bUseIA)
      {
          int iMod = (iWis > iDex) ? (iWis - iDex) : (0);
          
          if (bIsSimpleR && !bIsLightR)
              SetCompositeAttackBonus(oPC, "IntuitiveAttackR", iIABonus, ATTACK_BONUS_ONHAND);
          else if (bIsSimpleR && bIsLightR)
              SetCompositeAttackBonus(oPC, "IntuitiveAttackR", iMod, ATTACK_BONUS_ONHAND);

          if (bIsSimpleL && !bIsLightL)
              SetCompositeAttackBonus(oPC, "IntuitiveAttackL", iIABonus, ATTACK_BONUS_OFFHAND);
          else if (bIsSimpleL && bIsLightL)
              SetCompositeAttackBonus(oPC, "IntuitiveAttackL", iMod, ATTACK_BONUS_OFFHAND);

          if (bCreWeap)
          {
              if (iMod > 0)
                  SetLocalInt(oPC, "UnarmedWeaponFinesseBonus", iIABonus); // This will be added by SPELL_UNARMED_ATTACK_PEN
              else
                  SetLocalInt(oPC, "UnarmedWeaponFinesseBonus", iWFBonus); // This will be added by SPELL_UNARMED_ATTACK_PEN
          }
          else if (!bCreWeap && bUnarmed)
          {
              SetCompositeAttackBonus(oPC, "IntuitiveAttackUnarmed", iMod);
          }
      }
      // If the character has only weapon finesse and a creature weapon
      else if (bUseWF && !bUseIA && bCreWeap)
      {
          SetLocalInt(oPC, "UnarmedWeaponFinesseBonus", iWFBonus); // This will be added by SPELL_UNARMED_ATTACK_PEN
      }
   }
}
