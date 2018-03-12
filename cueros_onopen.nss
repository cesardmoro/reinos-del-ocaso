////////////
// Evento OnOpened para el merchant Curtiembre
// Author: Inquisidor
//
// ADVERTENCIA: La clave formada con los primeros 16 caracteres del tag de una instancia de Store, debe ser única dentro del area donde este ubicada.
////////////////

#include "IPS_RTG_inc"
#include "Store_inc"

const int Store_DESIRED_ITEMS_QUANTITY = 5;

void Store_generateItems( int actualTime, int expectedItemsQuality, int lacking ) {

    if ( lacking > Store_MAXIMUM_ITEMS_TO_GENERATE_IN_ONE_STEP ) {
        DelayCommand( 5.0, Store_generateItems( actualTime, expectedItemsQuality, lacking - Store_MAXIMUM_ITEMS_TO_GENERATE_IN_ONE_STEP ) );
        lacking = Store_MAXIMUM_ITEMS_TO_GENERATE_IN_ONE_STEP;
    }

    object item;
    while( --lacking >= 0 ) {
        float quality = Random_generateLevel( expectedItemsQuality );
        item = IPS_Item_generateArmor( OBJECT_SELF, quality, LIGHT_ARMOR_DESCRIPTORS_ARRAY, TRUE );
        Store_setExpirationDate( item, actualTime );
    }
}


void main() {
    if( !GetLocalInt( OBJECT_SELF, Store_wasOpenedBefore_VN ) )
        Store_initialize( OBJECT_SELF );

    object cliente = GetLastOpenedBy();
    if( GetIsPC( cliente ) ) {
        Store_actualizarPrecioItemsArrivoCliente( cliente );
        IPS_Subject_onOpenStore( GetLastOpenedBy() );
    }

    int expectedItemsQuality = GetLocalInt(OBJECT_SELF, Store_itemsExpectedQuality_PN );
    int actualTime = Time_secondsSince1300();
    int lacking = Store_DESIRED_ITEMS_QUANTITY - Store_getNumberOfNotExpiredItemsAndDestroyTheOthers( actualTime );
    Store_generateItems( actualTime, expectedItemsQuality, lacking );
}
