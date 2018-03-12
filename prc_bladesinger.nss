#include "inc_item_props"
#include "prc_feat_const"
#include "prc_class_const"
#include "nw_i0_spells"
#include "prc_spell_const"

int GetIPASF(int asf)
{
   switch ( asf)
   {
     case 5:  return IP_CONST_ARCANE_SPELL_FAILURE_MINUS_5_PERCENT;
     case 10: return IP_CONST_ARCANE_SPELL_FAILURE_MINUS_10_PERCENT;
     case 15: return IP_CONST_ARCANE_SPELL_FAILURE_MINUS_15_PERCENT;
     case 20: return IP_CONST_ARCANE_SPELL_FAILURE_MINUS_20_PERCENT;
     case 25: return IP_CONST_ARCANE_SPELL_FAILURE_MINUS_25_PERCENT;
     case 30: return IP_CONST_ARCANE_SPELL_FAILURE_MINUS_30_PERCENT;
     case 35: return IP_CONST_ARCANE_SPELL_FAILURE_MINUS_35_PERCENT;
     case 40: return IP_CONST_ARCANE_SPELL_FAILURE_MINUS_40_PERCENT;
     case 45: return IP_CONST_ARCANE_SPELL_FAILURE_MINUS_45_PERCENT;
     case 50: return IP_CONST_ARCANE_SPELL_FAILURE_MINUS_50_PERCENT;
    }

   return -1;
}

int GetASF(int  IP_ASF)
{
   switch ( IP_ASF)
   {
     case IP_CONST_ARCANE_SPELL_FAILURE_MINUS_5_PERCENT:  return -5;
     case IP_CONST_ARCANE_SPELL_FAILURE_MINUS_10_PERCENT: return -10;
     case IP_CONST_ARCANE_SPELL_FAILURE_MINUS_15_PERCENT: return -15;
     case IP_CONST_ARCANE_SPELL_FAILURE_MINUS_20_PERCENT: return -20;
     case IP_CONST_ARCANE_SPELL_FAILURE_MINUS_25_PERCENT: return -25;
     case IP_CONST_ARCANE_SPELL_FAILURE_MINUS_30_PERCENT: return -30;
     case IP_CONST_ARCANE_SPELL_FAILURE_MINUS_35_PERCENT: return -35;
     case IP_CONST_ARCANE_SPELL_FAILURE_MINUS_40_PERCENT: return -40;
     case IP_CONST_ARCANE_SPELL_FAILURE_MINUS_45_PERCENT: return -45;
     case IP_CONST_ARCANE_SPELL_FAILURE_MINUS_50_PERCENT: return -50;
     case IP_CONST_ARCANE_SPELL_FAILURE_PLUS_5_PERCENT:   return 5;
     case IP_CONST_ARCANE_SPELL_FAILURE_PLUS_10_PERCENT:  return 10;
     case IP_CONST_ARCANE_SPELL_FAILURE_PLUS_15_PERCENT:  return 15;
     case IP_CONST_ARCANE_SPELL_FAILURE_PLUS_20_PERCENT:  return 20;
     case IP_CONST_ARCANE_SPELL_FAILURE_PLUS_25_PERCENT:  return 25;
     case IP_CONST_ARCANE_SPELL_FAILURE_PLUS_30_PERCENT:  return 30;
     case IP_CONST_ARCANE_SPELL_FAILURE_PLUS_35_PERCENT:  return 35;
     case IP_CONST_ARCANE_SPELL_FAILURE_PLUS_40_PERCENT:  return 40;
     case IP_CONST_ARCANE_SPELL_FAILURE_PLUS_45_PERCENT:  return 45;
     case IP_CONST_ARCANE_SPELL_FAILURE_PLUS_50_PERCENT:  return 50;
   }

   return -1;

}

int checkASF(object oItem)
{
   itemproperty ip = GetFirstItemProperty(oItem);
   int total = 0;


    while(GetIsItemPropertyValid(ip))
    {
        if(GetItemPropertyType(ip) == ITEM_PROPERTY_ARCANE_SPELL_FAILURE)
        {
           total += GetASF(GetItemPropertyCostTableValue(ip));
        }
        ip = GetNextItemProperty(oItem);
    }
    return total;
}

void RemoveSpellEffectSong(object oPC)
{

  effect eff = GetFirstEffect(oPC);

  while (GetIsEffectValid(eff) )
  {
     if(GetEffectSpellId(eff) ==SPELL_SONG_OF_FURY)
         RemoveEffect(oPC, eff);

     eff = GetNextEffect(oPC);

  }
}

void IPAddSpellFailure50(object oArmor)
{

  int iBase = GetBaseAC(oArmor);

  if ( GetBaseItemType(oArmor)!=BASE_ITEM_ARMOR) return;

  if  (GetBaseAC(oArmor)>3 ) return ;

  int ASFArmor = checkASF(oArmor);
  if (iBase == 1) ASFArmor+=5;
  else if (iBase == 2) ASFArmor+=10;
  else if (iBase == 3) ASFArmor+=20;

  if (GetLocalInt(oArmor,"BladeASF")== ASFArmor||ASFArmor<1  ) return;

  SetLocalInt(oArmor,"BladeASF",ASFArmor);

  while ( ASFArmor)
  {
    if (ASFArmor>50)
    {
      AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyArcaneSpellFailure(IP_CONST_ARCANE_SPELL_FAILURE_MINUS_50_PERCENT),oArmor,9999.0);
      ASFArmor-=50;
    }
    else
    {
      AddItemProperty(DURATION_TYPE_TEMPORARY,ItemPropertyArcaneSpellFailure(GetIPASF(ASFArmor)),oArmor,9999.0);
      ASFArmor =0;
    }

  }

}

void IPRemoveSpellFailure50(object oItem)
{

  if  (!GetLocalInt(oItem,"BladeASF")) return ;

  int ASFArmor = GetLocalInt(oItem,"BladeASF");

   while ( ASFArmor)
  {
    if (ASFArmor>50)
    {
      RemoveSpecificProperty(oItem, ITEM_PROPERTY_ARCANE_SPELL_FAILURE, -1, IP_CONST_ARCANE_SPELL_FAILURE_MINUS_50_PERCENT, 1,"",-1,DURATION_TYPE_TEMPORARY);
      ASFArmor-=50;
    }
    else
    {
      RemoveSpecificProperty(oItem, ITEM_PROPERTY_ARCANE_SPELL_FAILURE, -1, GetIPASF(ASFArmor), 1,"",-1,DURATION_TYPE_TEMPORARY);
      ASFArmor =0;
    }

  }
  DeleteLocalInt(oItem,"BladeASF");
}


void OnEquip(object oPC,object oSkin)
{

  object oArmor=GetItemInSlot(INVENTORY_SLOT_CHEST,oPC);
  object oWeapL=GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC);
  object oWeapR=GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);

  if  (GetBaseAC(oArmor)>4)
  {
     if (GetHasFeatEffect(FEAT_SONG_OF_FURY,oPC))
     {
       RemoveSpellEffectSong(oPC);
     }
     SetCompositeBonus(oSkin, "BladesAC", 0, ITEM_PROPERTY_AC_BONUS);
     SetCompositeBonus(oSkin, "BladesCon", 0, ITEM_PROPERTY_SKILL_BONUS,SKILL_CONCENTRATION);
     return;
  }
  //if ( GetHasFeat(FEAT_GREATER_SPELLSONG,oPC)) IPAddSpellFailure50(oArmor);


  // only 1 weapon
  if (
       (GetIsObjectValid(oWeapL) && GetIsObjectValid(oWeapR) ) ||
       (!GetIsObjectValid(oWeapL) && !GetIsObjectValid(oWeapR) )
     )
     {
        if (GetHasFeatEffect(FEAT_SONG_OF_FURY,oPC))
       {
         RemoveSpellEffectSong(oPC);
       }

        SetCompositeBonus(oSkin, "BladesAC", 0, ITEM_PROPERTY_AC_BONUS);
        SetCompositeBonus(oSkin, "BladesCon", 0, ITEM_PROPERTY_SKILL_BONUS,SKILL_CONCENTRATION);
        return;
     }

   // only rapier or longsword
  if (  !(GetBaseItemType(oWeapL)==BASE_ITEM_RAPIER    ||
          GetBaseItemType(oWeapR)==BASE_ITEM_RAPIER    ||
          GetBaseItemType(oWeapL)==BASE_ITEM_LONGSWORD ||
          GetBaseItemType(oWeapR)==BASE_ITEM_LONGSWORD) )
     {
       if (GetHasFeatEffect(FEAT_SONG_OF_FURY,oPC))
       {
         RemoveSpellEffectSong(oPC);
       }

        SetCompositeBonus(oSkin, "BladesAC", 0, ITEM_PROPERTY_AC_BONUS);
        SetCompositeBonus(oSkin, "BladesCon", 0, ITEM_PROPERTY_SKILL_BONUS,SKILL_CONCENTRATION);
        return;
     }


   int BladeLv=GetLevelByClass(CLASS_TYPE_BLADESINGER,oPC);
   int Intb=GetAbilityModifier(ABILITY_INTELLIGENCE,oPC);

   // Bonus Lvl BladeSinger Max Bonus Int
   if ( BladeLv>Intb) BladeLv=Intb;

   SetCompositeBonus(oSkin, "BladesAC", BladeLv, ITEM_PROPERTY_AC_BONUS);

   if ( GetHasFeat(FEAT_LESSER_SPELLSONG,oPC))
     SetCompositeBonus(oSkin, "BladesCon", 5, ITEM_PROPERTY_SKILL_BONUS,SKILL_CONCENTRATION);

}

void  OnUnEquip(object oPC,object oSkin)
{
  object oItem=GetPCItemLastUnequipped();

  object oArmor=GetItemInSlot(INVENTORY_SLOT_CHEST,oPC);
  object oWeapL=GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC);
  object oWeapR=GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);

  IPRemoveSpellFailure50(oItem);

  if  (GetBaseAC(oArmor)>3)
  {
        if (GetHasFeatEffect(FEAT_SONG_OF_FURY,oPC))
       {
         RemoveSpellEffectSong(oPC);
       }

     SetCompositeBonus(oSkin, "BladesAC", 0, ITEM_PROPERTY_AC_BONUS);
     SetCompositeBonus(oSkin, "BladesCon", 0, ITEM_PROPERTY_SKILL_BONUS,SKILL_CONCENTRATION);
     return;
  }


  if (
       (GetIsObjectValid(oWeapL) && GetIsObjectValid(oWeapR) ) ||
       (!GetIsObjectValid(oWeapL) && !GetIsObjectValid(oWeapR) )
     )
     {
       if (GetHasFeatEffect(FEAT_SONG_OF_FURY,oPC))
       {
         RemoveSpellEffectSong(oPC);
       }

        SetCompositeBonus(oSkin, "BladesAC", 0, ITEM_PROPERTY_AC_BONUS);
        SetCompositeBonus(oSkin, "BladesCon", 0, ITEM_PROPERTY_SKILL_BONUS,SKILL_CONCENTRATION);
        return;
     }


  if (  !(GetBaseItemType(oWeapL)==BASE_ITEM_RAPIER    ||
          GetBaseItemType(oWeapR)==BASE_ITEM_RAPIER    ||
          GetBaseItemType(oWeapL)==BASE_ITEM_LONGSWORD ||
          GetBaseItemType(oWeapR)==BASE_ITEM_LONGSWORD) )
     {
       if (GetHasFeatEffect(FEAT_SONG_OF_FURY,oPC))
       {
         RemoveSpellEffectSong(oPC);
       }

        SetCompositeBonus(oSkin, "BladesAC", 0, ITEM_PROPERTY_AC_BONUS);
        SetCompositeBonus(oSkin, "BladesCon", 0, ITEM_PROPERTY_SKILL_BONUS,SKILL_CONCENTRATION);

        return;
     }



   int BladeLv=GetLevelByClass(CLASS_TYPE_BLADESINGER,oPC);
   int Intb=GetAbilityModifier(ABILITY_INTELLIGENCE,oPC);

   if ( BladeLv>Intb)
        BladeLv=Intb;

   SetCompositeBonus(oSkin, "BladesAC", BladeLv, ITEM_PROPERTY_AC_BONUS);

   if ( GetHasFeat(FEAT_LESSER_SPELLSONG,oPC))
     SetCompositeBonus(oSkin, "BladesCon", 5, ITEM_PROPERTY_SKILL_BONUS,SKILL_CONCENTRATION);

}


void main()
{

  //Declare main variables.
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);

    int iEquip = GetLocalInt(oPC,"ONEQUIP");


    if (GetLocalInt(oPC,"ONREST"))
    {
        object oArmor=GetItemInSlot(INVENTORY_SLOT_CHEST,oPC);
        DeleteLocalInt(oArmor,"BladeASF");
    }
       if (iEquip !=1) OnEquip(oPC,oSkin);
       if (iEquip ==1) OnUnEquip(oPC,oSkin);

}
