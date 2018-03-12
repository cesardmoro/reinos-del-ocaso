#include "x2_inc_switches"

void main()
{
    int nEvent =GetUserDefinedItemEventNumber();
    if(nEvent == X2_ITEM_EVENT_UNACQUIRE)
    {
        object oItem  = GetModuleItemLost();
        object oHolder = GetItemPossessor(oItem);
        CopyObject(oItem, GetLocation(oItem), oHolder, "codi_sam_XX");
        DestroyObject(oItem);
    }
}

