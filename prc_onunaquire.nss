//
// Stub function for possible later use.
//
//Include required for Imbue Arrow functionality.
#include "prc_inc_clsfunc"

void main()
{
    object oItem = GetModuleItemLost();
    object oPC = GetModuleItemLostBy();
    if (GetResRef(oItem) == AA_IMBUED_ARROW)
    {
        DestroyObject(oItem);
    }


    // Remove all temporary item properties when dropped/given away/stolen/sold.
    if(GetIsObjectValid(oItem))//needed for last of stack etc items
        DeletePRCLocalIntsT(oPC,oItem);
}
