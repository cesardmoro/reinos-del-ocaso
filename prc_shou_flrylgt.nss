//::///////////////////////////////////////////////
//:: Shou Disciple - Martial Flurry Light
//:://////////////////////////////////////////////
/*
    This is the spell cast on the Shou to apply the effects
*/
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: March 4, 2006
//:://////////////////////////////////////////////

#include "nw_i0_spells"

void main()
{
    object oPC = PRCGetSpellTargetObject();
    
    // Removes effects
    RemoveEffectsFromSpell(oPC, GetSpellId());
    if(DEBUG) DoDebug("Shou Flurry Light: Removing Spell Effects");
    

          string nMesL = "";
          object oArmorL = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
          object oWeapRL = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
          object oWeapLL = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);

          int armorTypeL = GetArmorType(oArmorL);
          int iShouL = GetLevelByClass(CLASS_TYPE_SHOU, oPC);
          int monkLevelL = GetLevelByClass(CLASS_TYPE_MONK, oPC);
          int numAddAttacksL = 0;
          int attackPenaltyL = 0;


           if(iShouL >= 3 )
          {
              numAddAttacksL = 1;
              attackPenaltyL = 2;
              if(DEBUG) DoDebug("Shou Flurry Light: Shou level is greater or equal to 3");
          }

          if(monkLevelL > 0 && GetBaseItemType(oWeapRL) == BASE_ITEM_KAMA)
          {
              numAddAttacksL = 0;
              attackPenaltyL = 0;
              nMesL = "*No Extra Attacks Gained by Kama Monks!*";
              if(DEBUG) DoDebug("Shou Flurry Light: Kama Monk");
          }

    if (GetBaseItemType(oWeapRL) == BASE_ITEM_DAGGER || GetBaseItemType(oWeapRL) == BASE_ITEM_HANDAXE ||
    GetBaseItemType(oWeapRL) == BASE_ITEM_LIGHTHAMMER || GetBaseItemType(oWeapRL) == BASE_ITEM_LIGHTMACE ||
    GetBaseItemType(oWeapRL) == BASE_ITEM_KUKRI || GetBaseItemType(oWeapRL) == BASE_ITEM_SICKLE ||
    GetBaseItemType(oWeapRL) == BASE_ITEM_WHIP || GetBaseItemType(oWeapRL) == BASE_ITEM_SHORTSWORD ||
    GetBaseItemType(oWeapRL) == BASE_ITEM_INVALID)
    {
        if(DEBUG) DoDebug("Shou Flurry Light: Right hand weapon is light");
            if (GetBaseItemType(oWeapLL) == BASE_ITEM_DAGGER || GetBaseItemType(oWeapLL) == BASE_ITEM_HANDAXE ||
            GetBaseItemType(oWeapLL) == BASE_ITEM_LIGHTHAMMER || GetBaseItemType(oWeapLL) == BASE_ITEM_LIGHTMACE ||
            GetBaseItemType(oWeapLL) == BASE_ITEM_KUKRI || GetBaseItemType(oWeapLL) == BASE_ITEM_SICKLE ||
            GetBaseItemType(oWeapLL) == BASE_ITEM_WHIP || GetBaseItemType(oWeapLL) == BASE_ITEM_SHORTSWORD ||
            GetBaseItemType(oWeapLL) == BASE_ITEM_INVALID)
            {
                if(DEBUG) DoDebug("Shou Flurry Light: Left hand weapon is light");

            //check armor type
            if(armorTypeL < ARMOR_TYPE_MEDIUM)
            {   
                if(DEBUG) DoDebug("Shou Flurry Light: Armour is light");
                effect addAttL = SupernaturalEffect( EffectModifyAttacks(numAddAttacksL) );
                effect attPenL = SupernaturalEffect( EffectAttackDecrease(attackPenaltyL) );
                effect eLinkL = EffectLinkEffects(addAttL, attPenL);
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLinkL, oPC);
                SetLocalInt(oPC, "HasMFlurry", 2);
                        nMesL = "*Martial Flurry Activated*";
                        if(DEBUG) DoDebug("Shou Flurry Light: Applied Shou Flurry Effects");
            }
        }
    }
    else
    {
        nMesL = "*Invalid Weapon.  Ability Not Activated!*";
    }
          
    FloatingTextStringOnCreature(nMesL, oPC, FALSE);    
    if(DEBUG) DoDebug("Shou Flurry Light: Exiting Script");
}