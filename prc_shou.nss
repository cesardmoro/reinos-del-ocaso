//::///////////////////////////////////////////////
//:: Shou Disciple
//:: prc_shou.nss
//:://////////////////////////////////////////////
//:: Check to see which Shou Disciple feats a PC
//:: has and apply the appropriate bonuses.
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: June 28, 2004
//:://////////////////////////////////////////////

#include "inc_item_props"
#include "nw_i0_spells"
#include "prc_inc_unarmed"


/*
it_crewpb006 - 1d6
it_crewpb011 - 1d8
it_crewpb015 - 1d10
it_crewpb016 - 2d6
*/


void DodgeBonus(object oPC, object oSkin)
{

//SendMessageToPC(OBJECT_SELF, "DodgeBonus is called");

     int ACBonus = 0;
     int iShou = GetLevelByClass(CLASS_TYPE_SHOU, oPC);

//SendMessageToPC(OBJECT_SELF, "Shou Class Level: " + IntToString(iShou));

     if(iShou > 0 && iShou < 2)
     {
          ACBonus = 1;
     }
     else if(iShou >= 2 && iShou < 4)
     {
          ACBonus = 2;
     }
     else if(iShou >= 4)
     {
          ACBonus = 3;
     }

//SendMessageToPC(OBJECT_SELF, "Dodge Bonus to AC: " + IntToString(ACBonus));

     SetCompositeBonus(oSkin, "ShouDodge", ACBonus, ITEM_PROPERTY_AC_BONUS);
     SetLocalInt(oPC, "HasShouDodge", 2);
}


void RemoveDodge(object oPC, object oSkin)
{
     SetCompositeBonus(oSkin, "ShouDodge", 0, ITEM_PROPERTY_AC_BONUS);
     SetLocalInt(oPC, "HasShouDodge", 1);
}

void main()
{
    //Declare main variables.
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);

    object oWeapR = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
    object oWeapL = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
    
    int iBase = GetBaseItemType(oWeapL);
    int iEquip = GetLocalInt(oPC,"ONEQUIP");
    string nMes = "";

SendMessageToPC(OBJECT_SELF, "prc_shou is called");

    if( GetBaseAC(oArmor)>3 )
    {
         RemoveDodge(oPC, oSkin);

         if(GetHasSpellEffect(SPELL_MARTIAL_FLURRY, oPC) )
         {
              RemoveSpellEffects(SPELL_MARTIAL_FLURRY, oPC, oPC);
         }

         SendMessageToPC(OBJECT_SELF, "*Shou Disciple Abilities Disabled Due To Equipped Armor*");
    }
    else if(iBase == BASE_ITEM_SMALLSHIELD || iBase == BASE_ITEM_LARGESHIELD || iBase == BASE_ITEM_TOWERSHIELD)
    {
         RemoveDodge(oPC, oSkin);

         if(GetHasSpellEffect(SPELL_MARTIAL_FLURRY, oPC) )
         {
              RemoveSpellEffects(SPELL_MARTIAL_FLURRY, oPC, oPC);
         }

         SendMessageToPC(OBJECT_SELF, "*Shou Disciple Abilities Disabled Due To Equipped Shield*");
    }
    else
    {
          if(GetLevelByClass(CLASS_TYPE_SHOU, oPC) > 1 )
          {
               RemoveDodge(oPC, oSkin);
               DodgeBonus(oPC, oSkin);
          }
     }

    //Evaluate The Unarmed Strike Feats
    UnarmedFeats(oPC);

    //Evaluate Fists
    UnarmedFists(oPC);


}
