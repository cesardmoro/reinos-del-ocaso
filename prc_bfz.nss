//::///////////////////////////////////////////////
//:: Black Flame Zealot
//:: prc_bfz.nss
//:://////////////////////////////////////////////
//:: Check to see which Black Flame Zealot feats a PC
//:: has and apply the appropriate bonuses.
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: July 6, 2004
//:://////////////////////////////////////////////

#include "inc_item_props"
#include "prc_feat_const"

void RemoveSacredFlame(object oPC, object oWeap);

void ZealousHeart(object oPC, object oSkin)
{
    if(GetLocalInt(oSkin, "BFZHeart") == TRUE) return;

    AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_FEAR), oSkin);
    SetLocalInt(oSkin, "BFZHeart", TRUE);
}

void SacredFlame(object oPC, object oWeap)
{
    if(GetLocalInt(oWeap, "BFZFlame") == TRUE) return;

    //SendMessageToPC(oPC, "Add Sacred Flame is run");

    RemoveSacredFlame(oPC, oWeap);
    DelayCommand(0.1, AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGEBONUS_1d6), oWeap, 999999.0));
    SetLocalInt(oWeap, "BFZFlame", TRUE);
}

void RemoveSacredFlame(object oPC, object oWeap)
{
    //SendMessageToPC(oPC, "Remove Sacred Flame is run");

    RemoveSpecificProperty(oWeap, ITEM_PROPERTY_DAMAGE_BONUS, IP_CONST_DAMAGETYPE_FIRE, IP_CONST_DAMAGEBONUS_1d6, 1, "BFZFlame", -1, DURATION_TYPE_TEMPORARY);
    DeleteLocalInt(oWeap, "BFZFlame");
}


void main()
{
    //Declare main variables.
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    object oWeap = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
    object oUnequip = GetPCItemLastUnequipped();
    int iEquip = GetLocalInt(oPC, "ONEQUIP");

    ZealousHeart(oPC, oSkin);

    if(GetHasFeat(FEAT_SACRED_FLAME, oPC))
    {
       	if (iEquip == 1)    RemoveSacredFlame(oPC, oUnequip);
        if (iEquip == 2)    SacredFlame(oPC, oWeap);
    }
}
