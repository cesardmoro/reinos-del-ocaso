void main()
    /* Hace que el cliente guarde en su mochila lo que lleva puesto en la cabeza */
{
    object cliente = GetPCSpeaker();
    AssignCommand( cliente, ActionUnequipItem( GetItemInSlot( INVENTORY_SLOT_HEAD, cliente ) ) );
}
