int StartingConditional()
{
    object oChest = GetNearestObjectByTag("ChestofNames",OBJECT_SELF);
    object oItem  = GetFirstItemInInventory(oChest);

    if (!GetIsObjectValid(oItem))
        return TRUE;

    switch (GetBaseItemType(oItem)) {
        case BASE_ITEM_ARROW:
        case BASE_ITEM_BOLT:
        case BASE_ITEM_BULLET:  return TRUE;
    }

    return FALSE;
}
