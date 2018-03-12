////////////
// Evento OnOpened para el merchant de municiones
// Author: Inquisidor
//
// ADVERTENCIA: La clave formada con los primeros 16 caracteres del tag de una instancia de Store, debe ser única dentro del area donde este ubicada.
//
// Los mercaderes de armas a distancias siempre tienen Store_AMMO_QUANTITY packs de flechas, virotes y piedras a la venta.
// No deben ser contados en la cantidad de items guardada en la variable local.
////////////////

#include "IPS_RTG_inc"
#include "Store_inc"

void main() {
    if( !GetLocalInt( OBJECT_SELF, Store_wasOpenedBefore_VN ) )
        Store_initialize( OBJECT_SELF );

    object cliente = GetLastOpenedBy();
    if( GetIsPC( cliente ) ) {
        Store_actualizarPrecioItemsArrivoCliente( cliente );
        IPS_Subject_onOpenStore( GetLastOpenedBy() );
    }

    int actualTime = Time_secondsSince1300();
    int generatedThrowingCounter  = 0;
    int generatedArrowCounter  = 0;
    int generatedBoltCounter   = 0;
    int generatedBulletCounter = 0;
    object itemIterator = GetFirstItemInInventory();
    while( itemIterator != OBJECT_INVALID ) {
        if( IPS_Item_getIsAdept( itemIterator ) && !Store_hasItemExpiredOrIsCursed( itemIterator, actualTime ) ) {
            switch ( GetBaseItemType( itemIterator ) ) {
                case BASE_ITEM_THROWINGAXE:
                case BASE_ITEM_DART:
                case BASE_ITEM_SHURIKEN:    ++generatedThrowingCounter; break;
                case BASE_ITEM_ARROW:       ++generatedArrowCounter;    break;
                case BASE_ITEM_BOLT:        ++generatedBoltCounter;     break;
                case BASE_ITEM_BULLET:      ++generatedBulletCounter;   break;
            }
        }
        itemIterator = GetNextItemInInventory();
    }
    int expectedItemsQuality = GetLocalInt(OBJECT_SELF, Store_itemsExpectedQuality_PN );
    object item;
    float quality;
    while( generatedThrowingCounter < 6 ) {
        quality = Random_generateLevel( expectedItemsQuality );
        item = IPS_Item_generateThrowingWeapon( OBJECT_SELF, quality, ALL_THROWING_WEAPONS_DESCRIPTORS_ARRAY, TRUE );
        Store_setExpirationDate( item, actualTime );
        ++generatedThrowingCounter;
    }
    while( generatedArrowCounter < 8 ) {
        quality = Random_generateLevel( expectedItemsQuality );
        item = IPS_Item_generateArrowsPack( OBJECT_SELF, quality, TRUE );
        Store_setExpirationDate( item, actualTime );
        ++generatedArrowCounter;
    }
    while( generatedBoltCounter < 6 ) {
        quality = Random_generateLevel( expectedItemsQuality );
        item = IPS_Item_generateBoltsPack( OBJECT_SELF, quality, TRUE );
        Store_setExpirationDate( item, actualTime );
        ++generatedBoltCounter;
    }
    while( generatedBulletCounter < 2 ) {
        quality = Random_generateLevel( expectedItemsQuality );
        item = IPS_Item_generateBulletsPack( OBJECT_SELF, quality, TRUE );
        Store_setExpirationDate( item, actualTime );
        ++generatedBulletCounter;
    }

}
