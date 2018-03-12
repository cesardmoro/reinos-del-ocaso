int StartingConditional()
{
    int nSeek = GetLocalInt(OBJECT_SELF, "ITEM_SEEK");
    int nSlot = GetLocalInt(OBJECT_SELF, "ITEM_SLOT") + 1;
    SetLocalInt(OBJECT_SELF, "ITEM_SLOT", nSlot);
    if (nSeek == -1) return FALSE;
    object oItem = GetFirstItemInInventory();
    int x;
    for (x = 0; x <= nSeek; x++)
    {
        if (!GetIsObjectValid(oItem))
        {
            SetLocalInt(OBJECT_SELF, "ITEM_SEEK", -1);
            break;
        }
        if (x == nSeek)
        {
            SetLocalInt(OBJECT_SELF, "ITEM_SEEK", nSeek + 1);
            SetLocalObject(OBJECT_SELF, "ITEM_" + IntToString(nSlot), oItem);
            SetCustomToken(699 + nSlot, GetName(oItem));
            return TRUE;
        }
        oItem = GetNextItemInInventory();
    }
    return FALSE;
}
