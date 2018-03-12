int StartingConditional()
    // Da TRUE si el cochero lleva puesto algo en la cabeza
{
    return GetItemInSlot( INVENTORY_SLOT_HEAD, GetPCSpeaker() ) != OBJECT_INVALID;
}
