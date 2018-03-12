//::///////////////////////////////////////////////
//:: Greater TWF
//:://////////////////////////////////////////////
/*
    Script to modify player that has GTWF
*/
//:://////////////////////////////////////////////
//:: Created By: Oni5115
//:: Created On: Mar 5, 2004
//:://////////////////////////////////////////////
#include "prc_alterations"
#include "prc_inc_clsfunc"
#include "prc_feat_const"
#include "prc_class_const"
#include "prc_spell_const"

void ApplyExtraAttacks(object oPC)
{
     if(!GetHasSpellEffect(SPELL_T_TWO_WEAPON_FIGHTING, oPC) )
     {
          ActionCastSpellOnSelf(SPELL_T_TWO_WEAPON_FIGHTING);
     }

     SetLocalInt(oPC, "HasGTWF", 2);
}

void main()
{
    //Declare main variables.
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);

    object oWeapR = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
    object oWeapL = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);

    int iEquip = GetLocalInt(oPC,"ONEQUIP");
    int bOnOrOff = GetLocalInt(oPC, "HasTwoWeapON");
    string nMes = "";

    // On Error Remove effects
    // This typically occurs On Load
    // Because the variables are not yet set.
    if(GetLocalInt(oPC, "HasGTWF") == 0 )
    {
         if(GetHasSpellEffect(SPELL_T_TWO_WEAPON_FIGHTING, oPC) )
         {
              RemoveEffectsFromSpell(oPC, SPELL_T_TWO_WEAPON_FIGHTING);
         }
    }
    // Remove effects if weapons are not correct
    if(oWeapR == OBJECT_INVALID || oWeapL == OBJECT_INVALID ||
            GetBaseItemType(oWeapL) == BASE_ITEM_LARGESHIELD ||
            GetBaseItemType(oWeapL) == BASE_ITEM_TOWERSHIELD ||
            GetBaseItemType(oWeapL) == BASE_ITEM_SMALLSHIELD ||
            GetBaseItemType(oWeapL) == BASE_ITEM_TORCH)
    {
         if(GetHasSpellEffect(SPELL_T_TWO_WEAPON_FIGHTING, oPC) )
         {
              RemoveEffectsFromSpell(oPC, SPELL_T_TWO_WEAPON_FIGHTING);
              FloatingTextStringOnCreature("*Greater Two-Weapon Fighting Disabled*", oPC, FALSE);
         }
    }
    // Apply effects if it passes all other checks
    else
    {
         // inserts a random delay before calling this function
         // this should prevent some errors caused by equipping
         // two weapons in rapid succession.
         float fDelay = IntToFloat(d6(1)) * 0.1;
         DelayCommand(fDelay, ApplyExtraAttacks(oPC) );
    }
}
