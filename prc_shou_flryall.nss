//::///////////////////////////////////////////////
//:: Shou Disciple - Martial Flurry All
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
    if(DEBUG) DoDebug("Shou Flurry All: Removing Spell Effects");
    
          string nMesA = "";
          object oArmorA = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
          object oWeapRA = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
          object oWeapLA = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);

          int armorTypeA = GetArmorType(oArmorA);
          int iShouA = GetLevelByClass(CLASS_TYPE_SHOU, oPC);
          int monkLevelA = GetLevelByClass(CLASS_TYPE_MONK, oPC);
          int numAddAttacksA = 0;
          int attackPenaltyA = 0;


           if(iShouA == 5)
          {
              numAddAttacksA = 1;
              attackPenaltyA = 2;
              if(DEBUG) DoDebug("Shou Flurry All: Shou Disciple level is 5");
          }

          if(monkLevelA > 0 && GetBaseItemType(oWeapRA) == BASE_ITEM_KAMA)
          {
              numAddAttacksA = 0;
              attackPenaltyA = 0;
              nMesA = "*No Extra Attacks Gained by Kama Monks!*";
              if(DEBUG) DoDebug("Shou Flurry All: Kama Monk");
          }




    //check armor type
    if(armorTypeA < ARMOR_TYPE_MEDIUM)
    {
        if(DEBUG) DoDebug("Shou Flurry All: Armour is light");
        if(isNotShield(oWeapLA) )
        {
            if(DEBUG) DoDebug("Shou Flurry All: Shou Disciple not carrying a shield");
            effect addAttA = SupernaturalEffect( EffectModifyAttacks(numAddAttacksA) );
            effect attPenA = SupernaturalEffect( EffectAttackDecrease(attackPenaltyA) );
            effect eLinkA = EffectLinkEffects(addAttA, attPenA);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLinkA, oPC);
            SetLocalInt(oPC, "HasMFlurry", 2);
                    nMesA = "*Martial Flurry Activated*";
                    if(DEBUG) DoDebug("Shou Flurry All: Applied Spell Effects");
        }
    }
    else
    {
        nMesA = "*Invalid Weapon.  Ability Not Activated!*";
    }

    FloatingTextStringOnCreature(nMesA, oPC, FALSE);
    if(DEBUG) DoDebug("Shou Flurry All: Exiting script");
}