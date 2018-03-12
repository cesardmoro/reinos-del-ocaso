////////////
// 07/04/07 Script by Inquisidor and Dragoncin
//
// Funciones para ser usadas en los handlers de los shop (normalmente "store_*")
// ADVERTENCIA: La clave formada con los primeros 16 caracteres del tag de una instancia de Store, debe ser única dentro del area donde este ubicada.
/////////////////////////////
#include "Store_basic"
#include "IPS_inc"
#include "CIB_frente"
#include "Time_inc"

/////////////////////////////// FUNCIONES DE INSTANCIA /////////////////////////

string Store_getGoldDatabaseId( object this ) {
    return GetStringLeft( GetResRef(GetArea(this)) + GetTag(this), Store_GOLD_DATABASE_ID_MAX_LENGTH );
}


// Obtiene de la base de datos persistentes
// ADVERTENCIA: solo debe ser llamada una vez, y debe ser antes de cualquier
// otro acceso a esta instancia
void Store_initialize( object this );
void Store_initialize( object this ) {
    int databaseGold = GetCampaignInt( Store_GOLD_DATABASE_FILE_NAME, Store_getGoldDatabaseId( this ) );
    if( databaseGold > 0 )
        SetStoreGold( this, databaseGold );
}


// Actualiza en la DB los datos persistentes de esta instancia de Store
void Store_actualizePersistence( object this );
void Store_actualizePersistence( object this ) {
    SetCampaignInt( Store_GOLD_DATABASE_FILE_NAME, Store_getGoldDatabaseId( this ), GetStoreGold(this) );
}


/////////////////////////// FUNCIONES DE CLASE /////////////////////////////////

// Debe ser llamada desde el handler del evento onItemAcquire si se pretende que
// los mercaderes consuman oro.
void Store_Subject_onAcquire( object item, object acquirer, object giver );
void Store_Subject_onAcquire( object item, object acquirer, object giver ) {
    if( GetObjectType( giver ) == OBJECT_TYPE_STORE ) {
        int goldAcquired = GetGoldPieceValue( item );
        SetStoreGold( giver, GetStoreGold( giver ) - goldAcquired/2 );
    }
    else
        SetStolenFlag( item, TRUE );
}

// da permiso de venta a cualquier item que no tenga propiedades agregadas.
struct Store_PermisoVenta Store_onItemArrivesStore( object item, object cliente );
struct Store_PermisoVenta Store_onItemArrivesStore( object item, object cliente ) {
    struct Store_PermisoVenta permiso;
    permiso.concedido = !GetIsItemPropertyValid( GetFirstItemProperty( item ) );
    return permiso;
}

// Cuando un cliente entra a una tienda, esta funcion es llamada para cada uno de los
// items poseidos por el cliente.
// El objetivo de esta funcion es que todo subsistema que quiera controlar la
// vendivilidad y/o precio de items, mientras se esta dentro de una tienda, agregue
// su correspondiente handler de onItemArrivesStore en la lista de abajo.
// Un item es vendible solo si, de todos los subsistemas que agregaron un handler,
// alguno concede la venta y ninguno la prohibe.
// Notar que si un handler prohibe la venta, los handlers que estan debajo de él en
// la lista, no son llamados.
// Nota: OBJECT_SELF es la tienda a la que se entra.
// IMPORTANTE: Para que este sistema de vendibilidad y precio funcione, no debe haber
// nada que cambie el StolenFlag de un item de TRUE a FALSE, excepto por esta funcion.
void Store_onOpenForEachItemOfTheClient( object item, object cliente, int isEquiped );
void Store_onOpenForEachItemOfTheClient( object item, object cliente, int isEquiped ) {
    struct Store_PermisoVenta permiso;
    int tieneAlgunaConcesion = FALSE;

    // LISTA DE HANDLERS del evento onItemArrivesStore
    if( !permiso.prohibido ) { // este primer if es en vano. Solo esta para que la estructura del código sea homogenea
        permiso = CIB_onItemArrivesStore( item, cliente );
        tieneAlgunaConcesion |= permiso.concedido;
    }
    if( !permiso.prohibido ) {
        permiso = IPS_onItemArrivesStore( item, cliente, isEquiped );
        tieneAlgunaConcesion |= permiso.concedido;
    }
    if( !permiso.prohibido ) {
        permiso = Store_onItemArrivesStore( item, cliente );
        tieneAlgunaConcesion |= permiso.concedido;
    }

    SetStolenFlag( item,  permiso.prohibido || !tieneAlgunaConcesion );
}


// Cuando un cliente sale de una tienda, esta funcion es llamada para cada uno de los
// items poseidos por el cliente.
// El objetivo de esta funcion es que todo subsistema que quiera controlar la
// vendivilidad y/o precio de items, mientras se esta fuera de una tienda, agregue
// su correspondiente handler de onItemDepartsStore en la lista de abajo.
// Un item es vendible solo si de todos los subsistemas que agregaron un handler
// ninguno prohibe la venta. O sea, si todos handlers agregados a la lista dan FALSE.
// Notar que si un handler da TRUE (prohibiendo la venta del item), los handlers
// que estan debajo en la lista, no son llamados.
// Nota: OBJECT_SELF es la tienda a la que se entra.
// IMPORTANTE: Para que este sistema de vendibilidad y precio funcione, no debe haber
// nada que cambie el StolenFlag de un item de TRUE a FALSE, excepto por esta funcion.
void Store_onCloseForEachItemOfTheClient( object item, object cliente, int isEquiped );
void Store_onCloseForEachItemOfTheClient( object item, object cliente, int isEquiped ) {
    int tieneProhibicionDeVenta = FALSE;

    // LISTA DE HANDLERS del evento onItemDepartsStore
    tieneProhibicionDeVenta = tieneProhibicionDeVenta || IPS_onItemDepartsStore( item, cliente, isEquiped );

    SetStolenFlag( item, tieneProhibicionDeVenta );
}


// Toda tienda cuyo onStoreOpen y onCloseStore event handlers llamen a
// Store_actualizarPrecioItemsArrivoCliente(..) y a Store_actualizarPrecioItemsPartidaCliente(..),
// se dice que es adepta a Store.
// Llama a 'Store_onOpenForEachItemOfTheClient(..)' para cada item que posea el cliente.
void Store_actualizarPrecioItemsArrivoCliente( object cliente );
void Store_actualizarPrecioItemsArrivoCliente( object cliente ) {

    // A todo item equipado: hacerlo vendible si no tiene ninguna prohibicion de venta
    int slotIdIterator = NUM_INVENTORY_SLOTS;
    while( --slotIdIterator >= 0 ) {
        object item = GetItemInSlot( slotIdIterator, cliente );
        Store_onOpenForEachItemOfTheClient( item, cliente, TRUE );
    }

    // A todo item en el inventario: hacerlo vendible si no tiene ninguna prohibicion de venta
    object itemIterator = GetFirstItemInInventory( cliente );
    while( itemIterator != OBJECT_INVALID ) {
        Store_onOpenForEachItemOfTheClient( itemIterator, cliente, FALSE );
        itemIterator = GetNextItemInInventory( cliente );
    }
}


// Toda tienda cuyo onStoreOpen y onCloseStore event handlers llamen a
// Store_actualizarPrecioItemsArrivoCliente(..) y a Store_actualizarPrecioItemsPartidaCliente(..),
// se dice que es adepta a Store.
// Llama a 'Store_onOpenForEachItemOfTheClient(..)' para cada item que posea el cliente.
void Store_actualizarPrecioItemsPartidaCliente( object cliente );
void Store_actualizarPrecioItemsPartidaCliente( object cliente ) {

    // A todo item equipado: hacerlo vendible si no tiene ninguna prohibicion de venta
    int slotIdIterator = NUM_INVENTORY_SLOTS;
    while( --slotIdIterator >= 0 ) {
        object item = GetItemInSlot( slotIdIterator, cliente );
        Store_onCloseForEachItemOfTheClient( item, cliente, TRUE );
    }

    // A todo item en el inventario: hacerlo vendible si no tiene ninguna prohibicion de venta
    object itemIterator = GetFirstItemInInventory( cliente );
    while( itemIterator != OBJECT_INVALID ) {
        Store_onCloseForEachItemOfTheClient( itemIterator, cliente, FALSE );
        itemIterator = GetNextItemInInventory( cliente );
    }
}


// genera una fecha de expiracion para el 'item'
void Store_setExpirationDate( object item, int actualTime );
void Store_setExpirationDate( object item, int actualTime ) {
    SetLocalInt( item, Store_expirationDate_VN, actualTime + Time_SECONDS_IN_A_DAY + Time_SECONDS_IN_AN_HOUR * Random( 49 ) );
}


// Si el items esta malidito o la fecha de vencimiento del item ha pasado, destruye el item y da TRUE. Sino da FALSE.
// Nota: a los items sin fecha de vencimiento les asigna una.
// Advertencia: Se asume que 'item' es adepto al IPS.
int Store_hasItemExpiredOrIsCursed( object item, int actualTime );
int Store_hasItemExpiredOrIsCursed( object item, int actualTime ) {
    int hasExpired = FALSE;
    int isCursed = (IPS_Item_getFlags( item ) & IPS_ITEM_FLAG_IS_CURSED) != 0;
    int expirationDate = GetLocalInt( item, Store_expirationDate_VN );
    if( !isCursed && expirationDate == 0 )
        Store_setExpirationDate( item, actualTime );
    else if( isCursed || actualTime > expirationDate ) {
        DestroyObject( item );
        hasExpired = TRUE;
    }
    return hasExpired;
}

// Cuenta cuantos items adeptos al IPS que no pasaron la fecha de vencimiento y no estan malditos.
// Destruye los items malditos o vencidos.
// Nota: a los items sin fecha de vencimiento les asigna una.
int Store_getNumberOfNotExpiredItemsAndDestroyTheOthers( int actualTime, object store = OBJECT_SELF );
int Store_getNumberOfNotExpiredItemsAndDestroyTheOthers( int actualTime, object store = OBJECT_SELF ) {
    int notExpiredItemsCounter = 0;
    object itemIterator = GetFirstItemInInventory( store );
    while( itemIterator != OBJECT_INVALID ) {
        if( IPS_Item_getIsAdept( itemIterator ) && !Store_hasItemExpiredOrIsCursed( itemIterator, actualTime ) )
            ++notExpiredItemsCounter;
        itemIterator = GetNextItemInInventory( store );
    }
    return notExpiredItemsCounter;
}


/*
const string Store_LAST_STOCK_RENEWAL_TIME = "Store_LAST_STOCK_RENEWAL_TIME";

// Devuelve si el shop debe renovar su stock o no
// Guarda en una variable local el horario de la proxima renovacion
int Store_mustRenewStock( object oStore = OBJECT_SELF );
int Store_mustRenewStock( object oStore = OBJECT_SELF )
{
    int lastStockRenewalTime = GetLocalInt(oStore, Store_LAST_STOCK_RENEWAL_TIME);
    int actualTime = Time_secondsSince1300();
    int mustRenewStock = FALSE;
    if (lastStockRenewalTime <= actualTime) {
        SetLocalInt(oStore, Store_LAST_STOCK_RENEWAL_TIME, actualTime+3600+Random(7200)); //Proxima renovacion en un tiempo entre 1 y 3 horas
        mustRenewStock = TRUE;
    }
    return mustRenewStock;
}
*/
