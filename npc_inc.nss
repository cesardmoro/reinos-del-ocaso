/********************** NPC include *******************************************
package: NPC - include
Autor: Inquisidor
Descripcion: funciones generias de NPCs
*******************************************************************************/

// Destruye la criatura OBJECT_SELF
void NPC_destruirse() {
    SetIsDestroyable( TRUE, FALSE );
    DestroyObject( OBJECT_SELF );
}


// Destroy all equipped slots - 0 to 18 (18 = NUM_INVENTORY_SLOTS)
void NPC_destruirTodosLosItemsEquipados( object criatura );
void NPC_destruirTodosLosItemsEquipados( object criatura ) {
    int slotIdIterator = NUM_INVENTORY_SLOTS;
    while( --slotIdIterator >= 0 ) {
        SetPlotFlag( criatura, FALSE );
        DestroyObject( GetItemInSlot( slotIdIterator, criatura ) );
    }
}


// Destroy all inventory items
void NPC_destruirTodosLosItemsContenidos( object contenedor );
void NPC_destruirTodosLosItemsContenidos( object contenedor ) {
    object itemIterator = GetFirstItemInInventory( contenedor );
    while(GetIsObjectValid(itemIterator)) {
        SetPlotFlag( itemIterator, FALSE );
        DestroyObject(itemIterator);
        itemIterator = GetNextItemInInventory( contenedor );
    }
}


// Prepara el inventario de OBJECT_SELF, haciendo que todos sus ítems esten identificados y no sean dropeables.
// Además, si 'nombreMarcaItems' no esta vacio, le pone una marca con ese nombre a todos los ítems que posea el NPC.
void NPC_prepararInventario( string nombreMarcaItem="" );
void NPC_prepararInventario( string nombreMarcaItem="" ) {

    object itemIterado = GetFirstItemInInventory( OBJECT_SELF );
    while( GetIsObjectValid(itemIterado) ) {
        if( nombreMarcaItem != "" )
            SetLocalInt(itemIterado, nombreMarcaItem, TRUE);
        SetIdentified( itemIterado, TRUE );
        SetDroppableFlag( itemIterado, FALSE );
        itemIterado = GetNextItemInInventory( OBJECT_SELF );
    }

    int slotIdIterado = NUM_INVENTORY_SLOTS;
    while( -- slotIdIterado >= 0 ) {
        itemIterado = GetItemInSlot( slotIdIterado, OBJECT_SELF );
        if( itemIterado != OBJECT_INVALID ) {
            if( nombreMarcaItem != "" )
                SetLocalInt( itemIterado, nombreMarcaItem, TRUE );
            SetIdentified( itemIterado, TRUE );
            SetDroppableFlag( itemIterado, FALSE );
        }
    }
}

