#include "prc_alterations"
#include "prc_inc_itmrstr"

/*
Script to handle removal of items with the ability
or skill restriction itemproperties.

Fired from prc_equip

*/

void main()
{
    object oPC = GetItemLastEquippedBy();
    object oItem = GetItemLastEquipped();
    itemproperty ipTest = GetFirstItemProperty(oItem);
    int bUnequip = CheckPRCLimitations(oItem, oPC);
    if(!bUnequip)
    {
        SendMessageToPC(oPC, "You cannot equip "+GetName(oItem));
        int i;
        object oTest = GetItemInSlot(i, oPC);
        while(oTest != oItem && i < 20)
        {
            i++;
            oTest = GetItemInSlot(i, oPC);
        }
        if(i<20)
            DelayCommand(0.3f, ForceUnequip(oPC, oItem, i));
    }
}