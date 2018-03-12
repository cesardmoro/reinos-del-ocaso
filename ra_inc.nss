/********************** Replicador de Apariencia - include *********************
Author: Inquisidor
Descripcion: El código del replicador de apariencia esta en los handlers de las
conversaciones de los mercaderes. Este include existe solo para centralizar
las pocas cosas comunes que hay entre esos hanlers.
********************************************************************************/
#include "IPS_inc"


////////////////////////////// CONSTANTS ///////////////////////////////////////

const string RA_TEMPORARY_CONTAINER_TAG = "IPS_temporaryContainer"; // De usarse el IPS, este tag debe ser IPS_TEMPORARY_CONTAINER_TAG (ver 'IPS_Pj_onAcquire(..)'). Sino se usa el IPS, el tag de algún contenedor inaccesible


////////////////////////////// variables locales al módulo /////////////////////

const string RA_temporaryContainer_PN = "RAtc";


/////////////////////////// propiedades del mercader //////////////////////////

const string RA_idInventorySlot_PN = "RAiis"; // identificador del inventory slot donde se ubica el ítem que el mercader es capaz de replicar

///////////////// variables locales al mercader ///////////////////////////////

const string RA_itemOriginal_VN = "RAio"; // item original
const string RA_precioReplicacion_VN = "RApr"; // precio de la replicación


//////////////// operaciones ///////////////////////////////////

// Calcula el precio de la replicacion, lo recuerda y actualiza el custom token 5800.
void RA_actualizarPrecioReplicacion( object item, object mercader=OBJECT_SELF );
void RA_actualizarPrecioReplicacion( object item, object mercader=OBJECT_SELF ) {
    int valorGenuino = IPS_Item_getIsAdept( item ) ? IPS_Item_getGenuineGoldValue( item ) : GetGoldPieceValue( item );
    int precioReplicacion = 1 + valorGenuino/100;
    SetCustomToken( 5800, IntToString( precioReplicacion ) );
    SetLocalInt( mercader, RA_precioReplicacion_VN, precioReplicacion );
}

// Cobra la replicación.
// Debe ser llamada en un punto del diálogo posterior a la llamada de 'RA_actualizarPrecioReplicacion(...)'
// Se asume que OBJECT_SELF es el mercader
void RA_cobrarReplicacion( object cliente );
void RA_cobrarReplicacion( object cliente ) {
    int precioReplicacion = GetLocalInt( OBJECT_SELF, RA_precioReplicacion_VN );
    TakeGoldFromCreature( precioReplicacion, cliente );
}



void RA_proceder_paso2( object cliente, object itemDestino, int idInventorySlot );
void RA_proceder_paso2( object cliente, object itemDestino, int idInventorySlot ) {
    object mercader = OBJECT_SELF;
    object temporaryContainer = GetLocalObject( GetModule(), RA_temporaryContainer_PN );
    object tempItem = CopyItem( itemDestino, temporaryContainer, TRUE );
    object itemOriginal = GetLocalObject( mercader, RA_itemOriginal_VN );
    int esOperacionExitosa = FALSE;

    switch( idInventorySlot ) {

        case INVENTORY_SLOT_CHEST: {
            if( GetBaseAC(itemDestino) == GetBaseAC(itemOriginal) ) {
                struct Item_ArmorAppearance originalAA = Item_getArmorAppearance( itemOriginal );
                tempItem = Item_applyAppearanceToArmor( tempItem, originalAA );
                esOperacionExitosa = TRUE;
            }
        } break;

        case INVENTORY_SLOT_CLOAK:
            // TODO
            break;

        case INVENTORY_SLOT_HEAD:
            // TODO
            break;

        case INVENTORY_SLOT_LEFTHAND:
            // TODO
            break;

        case INVENTORY_SLOT_RIGHTHAND: {
            struct Item_WeaponAppearance originalWA = Item_getWeaponAppearance( itemOriginal );
            tempItem = Item_applyAppearanceToWeapon( tempItem, originalWA );
            esOperacionExitosa = TRUE;
        } break;
    }

    DestroyObject( tempItem ); // notar que recien se destruye al finalizar el script

    if( esOperacionExitosa ) {
        tempItem = CopyItem( tempItem, cliente, TRUE );

        if( GetIsObjectValid( tempItem ) ) {
            DestroyObject( itemDestino );
            itemDestino = tempItem;
        }
    }

    if( IPS_Item_getIsAdept( itemDestino ) )
        IPS_Item_enableProperties( itemDestino, OBJECT_INVALID );

    AssignCommand( cliente, ActionEquipItem( itemDestino, idInventorySlot ) );
}


void RA_proceder( object cliente, object mercader=OBJECT_SELF );
void RA_proceder( object cliente, object mercader=OBJECT_SELF ) {

    int idInventorySlot = GetLocalInt( mercader, RA_idInventorySlot_PN );
    object itemDestino = GetItemInSlot( idInventorySlot, cliente );
    if( IPS_Item_getIsAdept( itemDestino ) )
        IPS_Item_disableProperties( itemDestino, cliente );
    AssignCommand( mercader, RA_proceder_paso2( cliente, itemDestino, idInventorySlot ) );
}


// Debe ser llamada desde el onModuleLoad event handler para que las funciones modifican la apariencia  funcionen.
void RA_onModuleLoad();
void RA_onModuleLoad() {
    SetLocalObject( GetModule(), RA_temporaryContainer_PN, GetObjectByTag( RA_TEMPORARY_CONTAINER_TAG ) );
}
