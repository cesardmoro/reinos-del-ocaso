int StartingConditional()
{
    int nSlot = GetLocalInt(OBJECT_SELF, "ITEM_SLOT");
    SetLocalInt(OBJECT_SELF, "ITEM_SLOT", nSlot + 1);
    object oItem = GetItemInSlot(nSlot);
    if (!GetIsObjectValid(oItem)) return FALSE;
    SetCustomToken(700 + nSlot, GetName(oItem));
    return TRUE;
}
