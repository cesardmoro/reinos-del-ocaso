int StartingConditional()
{
    int nScrollSlot = GetLocalInt(OBJECT_SELF, "ScrollSlotChosen");
    object oScroll = GetLocalObject(OBJECT_SELF, "ScrollSlotScroll_" + IntToString(nScrollSlot));
    int nId = GetLocalInt(OBJECT_SELF, "ScrollSlotId_" + IntToString(nScrollSlot));
    if (!GetIsObjectValid(oScroll) || GetItemPossessor(oScroll) != OBJECT_SELF)
    {
        return FALSE;
    }
    DestroyObject(oScroll);
    SetLocalInt(OBJECT_SELF, "Known_" + IntToString(nId), TRUE);
    return TRUE;
}
