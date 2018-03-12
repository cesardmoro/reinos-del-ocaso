int StartingConditional()
{
    int nSeek = GetLocalInt(OBJECT_SELF, "ITEM_SEEK");
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
            SetLocalInt(OBJECT_SELF, "ITEM_SLOT", 0);
            return TRUE;
        }
        object oItem = GetNextItemInInventory();
    }
    return FALSE;
}
