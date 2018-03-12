#include "x2_inc_itemprop"
#include "x2_inc_craft"
#include "mk_inc_craft"

void main()
{
    object oPC = GetPCSpeaker();
    object oChest = IPGetIPWorkContainer(oPC);

//    int iItemToDye = GetLocalInt(oPC, "ItemToDye");
//    object oItem = GetItemInSlot(iItemToDye, oPC);
    object oItem = CIGetCurrentModItem(oPC);

    if (!GetIsObjectValid(oItem))
    {
        return;
    }

    int iMaterialToDye = GetLocalInt(oPC, "MaterialToDye");

    int iColor = GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, iMaterialToDye);

    iColor = (iColor+1) % 176;

    DyeItem(oPC,iMaterialToDye,iColor,oChest);

//    DisplayColors(oPC,oItem);
}
