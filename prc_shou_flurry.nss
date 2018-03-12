//::///////////////////////////////////////////////
//:: Shou Disciple - Martial Flurry
//:://////////////////////////////////////////////
/*
    Gives and removes extra attack from PC
*/
//:://////////////////////////////////////////////
//:: Created By: Oni5115
//:: Created On: Aug 23, 2004
//:://////////////////////////////////////////////

#include "nw_i0_spells"

#include "prc_feat_const"
#include "prc_class_const"
#include "prc_spell_const"
#include "Item_inc"

void FlurryLight(object oPC)
{
          string nMesL = "";
          object oArmorL = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
          object oWeapRL = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
          object oWeapLL = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
          object oWeapCR = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oPC);

          int armorTypeL = GetArmorType(oArmorL);
          int iShouL = GetLevelByClass(CLASS_TYPE_SHOU, oPC);
          int monkLevelL = GetLevelByClass(CLASS_TYPE_MONK, oPC);
          int numAddAttacksL = 0;
          int attackPenaltyL = 0;


           if(iShouL >= 3 )
          {
              numAddAttacksL = 1;
              attackPenaltyL = 2;
          }

          if(monkLevelL > 0 && GetBaseItemType(oWeapRL) == BASE_ITEM_KAMA)
          {
              numAddAttacksL = 0;
              attackPenaltyL = 0;
              nMesL = "*No Extra Attacks Gained by Kama Monks!*";
          }

    if (GetBaseItemType(oWeapRL) == BASE_ITEM_DAGGER || GetBaseItemType(oWeapRL) == BASE_ITEM_HANDAXE ||
    GetBaseItemType(oWeapRL) == BASE_ITEM_LIGHTHAMMER || GetBaseItemType(oWeapRL) == BASE_ITEM_LIGHTMACE ||
    GetBaseItemType(oWeapRL) == BASE_ITEM_KUKRI || GetBaseItemType(oWeapRL) == BASE_ITEM_SICKLE ||
    GetBaseItemType(oWeapRL) == BASE_ITEM_WHIP || GetBaseItemType(oWeapRL) == BASE_ITEM_SHORTSWORD || GetBaseItemType(oWeapCR) == BASE_ITEM_CBLUDGWEAPON)
    {
            if (GetBaseItemType(oWeapLL) == BASE_ITEM_DAGGER || GetBaseItemType(oWeapLL) == BASE_ITEM_HANDAXE ||
            GetBaseItemType(oWeapLL) == BASE_ITEM_LIGHTHAMMER || GetBaseItemType(oWeapLL) == BASE_ITEM_LIGHTMACE ||
            GetBaseItemType(oWeapLL) == BASE_ITEM_KUKRI || GetBaseItemType(oWeapLL) == BASE_ITEM_SICKLE ||
            GetBaseItemType(oWeapLL) == BASE_ITEM_WHIP || GetBaseItemType(oWeapLL) == BASE_ITEM_SHORTSWORD || GetBaseItemType(oWeapCR) == BASE_ITEM_CBLUDGWEAPON)
            {

            //check armor type
            if(armorTypeL < ARMOR_TYPE_MEDIUM)
            {
                if(isNotShield(oWeapLL) )
                {
                    effect addAttL = SupernaturalEffect( EffectModifyAttacks(numAddAttacksL) );
                    effect attPenL = SupernaturalEffect( EffectAttackDecrease(attackPenaltyL) );
                    effect eLinkL = EffectLinkEffects(addAttL, attPenL);
                    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLinkL, oPC);
                    SetLocalInt(oPC, "HasMFlurry", 2);
                            nMesL = "*Martial Flurry Activated*";
                }
            }
        }
    }
    else
    {
        nMesL = "*Invalid Weapon.  Ability Not Activated!*";
    }

    FloatingTextStringOnCreature(nMesL, oPC, FALSE);
}

void FlurryAll(object oPC)
{
          string nMesA = "";
          object oArmorA = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
          object oWeapRA = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
          object oWeapLA = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);

          int armorTypeA = GetArmorType(oArmorA);
          int iShouA = GetLevelByClass(CLASS_TYPE_SHOU, oPC);
          int monkLevelA = GetLevelByClass(CLASS_TYPE_MONK, oPC);
          int numAddAttacksA = 0;
          int attackPenaltyA = 0;


           if(iShouA >= 3 )
          {
              numAddAttacksA = 1;
              attackPenaltyA = 2;
          }

          if(monkLevelA > 0 && GetBaseItemType(oWeapRA) == BASE_ITEM_KAMA)
          {
              numAddAttacksA = 0;
              attackPenaltyA = 0;
              nMesA = "*No Extra Attacks Gained by Kama Monks!*";
          }




    //check armor type
    if(armorTypeA < ARMOR_TYPE_MEDIUM)
    {
        if(isNotShield(oWeapLA) )
        {
            effect addAttA = SupernaturalEffect( EffectModifyAttacks(numAddAttacksA) );
            effect attPenA = SupernaturalEffect( EffectAttackDecrease(attackPenaltyA) );
            effect eLinkA = EffectLinkEffects(addAttA, attPenA);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLinkA, oPC);
            SetLocalInt(oPC, "HasMFlurry", 2);
                    nMesA = "*Martial Flurry Activated*";
        }
    }
    else
    {
        nMesA = "*Invalid Weapon.  Ability Not Activated!*";
    }

    FloatingTextStringOnCreature(nMesA, oPC, FALSE);
}


void main()
{
     object oPC = OBJECT_SELF;
     string nMes = "";

     if(!GetHasSpellEffect(SPELL_MARTIAL_FLURRY) )
     {
            if ( GetLevelByClass(CLASS_TYPE_SHOU, oPC) == 5)
            {
                FlurryAll(oPC);
            }
            else if ( GetLevelByClass(CLASS_TYPE_SHOU, oPC) >= 3  && GetLevelByClass(CLASS_TYPE_SHOU, oPC) < 5)
            {
                FlurryLight(oPC);
            }
     }
     else
     {
          // Removes effects
          RemoveSpellEffects(SPELL_MARTIAL_FLURRY, oPC, oPC);

          // Display message to player
          nMes = "*Martial Flurry Deactivated*";
          FloatingTextStringOnCreature(nMes, oPC, FALSE);
     }

}
