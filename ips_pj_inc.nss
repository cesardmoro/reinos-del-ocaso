/******************* Item Properties System - Pj handlers **********************
package: Item Properties System - include
Autor: Inquisidor
Descripcion: handlers de para PJs
*******************************************************************************/
#include "IPS_inc"
#include "CIB_frente"



// Debe ser llamado desde el Mod_onWorldEnter handler para actualizar las propiedades de los ítems al momento de entrar al mundo.
void IPS_Pj_onWorldEnter( object pj );
void IPS_Pj_onWorldEnter( object pj ) {
    // Para todos los ítems en el inventario: poner el ítem en estado no equipado.
    object itemIterator = GetFirstItemInInventory( pj );
    while( itemIterator != OBJECT_INVALID ) {
        if( IPS_Item_getIsAdept( itemIterator ) ) {
            DeleteLocalInt( itemIterator, IPS_Item_isDisabled_VN );
            SetIdentified( itemIterator, TRUE );
            // poner el items como si estuviera desequipado. Si esta equipado, luego se disparará el onEquip que lo volverá a poner como equipado. Esto es necesario para refrescar el estado de los items despues de una caida del servidor.
            IPS_Item_pasivateChosenProperties( itemIterator, pj, IPS_ItemProperty_Attribute_IS_DYNAMIC, IPS_ItemProperty_Attribute_IS_DYNAMIC );
            if( IPS_Item_getIsKnown( itemIterator ) )
                IPS_Item_activateChosenProperties( itemIterator, OBJECT_INVALID, IPS_ItemProperty_Attribute_IS_DYNAMIC, IPS_ItemProperty_Attribute_IS_DYNAMIC );
        }
        itemIterator = GetNextItemInInventory( pj );
    }
    // Para todos los items equipados: resetear variables del ítem, desequipar virtualmente el ítem, y actualizar el flag de identificado
    int slotIdIterator = NUM_INVENTORY_SLOTS;
    while( --slotIdIterator >= 0 ) {
        itemIterator = GetItemInSlot( slotIdIterator, pj );
        if( IPS_Item_getIsAdept( itemIterator ) ) {
            // por las dudas la la variable isDisabled haya quedado guardada, borrarla. La macana de esto es que relogueando se reabilitan las propiedades.
            DeleteLocalInt( itemIterator, IPS_Item_isDisabled_VN );
            IPS_Item_pasivateChosenProperties( itemIterator, pj, IPS_ItemProperty_Attribute_IS_DYNAMIC, IPS_ItemProperty_Attribute_IS_DYNAMIC );
            SetIdentified( itemIterator, IPS_Item_getIsKnown( itemIterator ) );
        }
    }
    // Para todos los items equipados: equipar virtualmente el ítem.
    slotIdIterator = NUM_INVENTORY_SLOTS;
    while( --slotIdIterator >= 0 ) {
        itemIterator = GetItemInSlot( slotIdIterator, pj );
        if( IPS_Item_getIsAdept( itemIterator ) ) {
            if( IPS_Item_getIsVirgin( itemIterator ) ) {
                IPS_Item_setIsVirgin( itemIterator, FALSE );
                IPS_Item_activateChosenProperties( itemIterator, pj, IPS_ItemProperty_Attribute_IS_IRREMOVABLE, IPS_ItemProperty_Attribute_IS_IRREMOVABLE );
            }
            IPS_Item_activateChosenProperties( itemIterator, pj, IPS_ItemProperty_Attribute_IS_DYNAMIC, IPS_ItemProperty_Attribute_IS_DYNAMIC );
        }
    }

}


// Debe ser llamada desde el onAquireItem event handler cuando un PJ adquiere un item
// adepto al IPS
// Hace que los items pierdan su estado de conocido cuando lo recibe un sujeto que no
// tiene UMD suficiente para para usarlo, o no tenga el lore necesario para identificar
// el item.
// IMPORTANTE: solo debe ser llamada si 'item' es adepto al IPS
void IPS_Pj_onAcquire( object acquirer, object item, object giver );
void IPS_Pj_onAcquire( object acquirer, object item, object giver ) {

    if(
        GetObjectType( giver ) != OBJECT_TYPE_STORE
        && GetTag( giver ) != IPS_TEMPORARY_CONTAINER_TAG
        && GetResRef(giver) != "ppis_invis_store"
    ) {
//        SendMessageToPC( GetFirstPC(), "IPS_Pj_onAcquire: giver="+GetTag( giver )+", acquirer="+GetTag(acquirer)+", item="+GetTag(item) );

        // Todo item adepto al IPS debe ser invendible excepto cuando el poseedor esta en una tienda adepta al IPS. Las tiendas adeptas al IPS, ajustan el preco de todos los items adeptos al IPS cuando el poseedor entra a una tienda. Los items adeptos al IPS adquiridos mientras se esta en una tienda cualquiera, que no provengan de la tienda, tambien deben ser invendibles.
        SetStolenFlag( item, TRUE );

        // Desempaquetar las municiones. Esto esta porque es posible soltar paquetes mientras se esta en una tienda.
        if( Item_getIsAmmo(item) && GetStringLeft( GetName(item), IPS_PACKET_NAME_PREFIX_LENGTH ) == IPS_PACKET_NAME_PREFIX ) {
            IPS_Item_unpacketize( item );
            IPS_Subject_refreshWeight( acquirer );
        }

        // Si el ítem adquirido esta en estado conocido, mantenerlo conocido si el receptor es capaz de identificarlo o de usarlo.
        if( IPS_Item_getIsKnown( item ) && CIB_getNombrePropietario( item ) != GetName( acquirer ) && Mod_isPcInitialized( acquirer ) ) {
            // Asi que para mantener identificado un item recibido, seria:
            struct IPS_ItemInspectionReport report = IPS_Item_inspect( item, 60, IPS_Subject_getInspectSkill( acquirer, TRUE ) ); // EL DC para mantener identificado se busca sea cercano un 60% del CR del encuentro cuyas criaturas dropearon el item. Notar que el modificador es 60% en lugar de 75% como es para identificarlo desde cero (ver 'IPS_Subject_onInspectItem(..)')
            if( report.successfulIdentificationsCounter < report.propertiesCounter )
                IPS_Item_setAsUnknown( item, OBJECT_INVALID );
        }
    }
}


// Debe ser llamada desde el onUnaquireItem event handler cuando un PJ desadquiere un item.
// Hace dos cosas:
// 1) Poner el valor genuino a los items vendidos (tenia el valor aparente que
// que es funcion del apraise del cliente).
// 2) Hacer que pierdan su estado de conocidos los items tirados al suelo
// IMPORTANTE: solo debe ser llamada si 'item' es adepto al IPS
void IPS_Pj_onUnacquire( object subject, object item );
void IPS_Pj_onUnacquire( object subject, object item ) {
    if( IPS_Item_getIsAdept( item ) ) {

        // si se esta en una tienda
        if( GetLocalInt( subject, IPS_Subject_isInAStore_VN ) ) {
            // poner el valor genuino a los items vendidos. Si lo tira al piso no importa porque se ajusta antes de poder ser vendido.
            IPS_Item_adjustGoldValue( item, OBJECT_INVALID );
        }

        // hacer que pierdan su estado de conocidos despues de pasado un tiempo en el suelo
        if( IPS_Item_getIsKnown( item ) )
            AssignCommand( item, DelayCommand( 120.0, IPS_Item_setAsUnknownIfNotPossessed() ) );
    }
}


// Debe ser llamado desde el handler del evento onModuleEnter.
void IPS_Pj_onModuleEnter( object subject );
void IPS_Pj_onModuleEnter( object subject ) {
    // quitar permiso de quite de Items malditos que pudo haber quedado despues de una caida del servidor.
    DeleteLocalInt( subject, IPS_Subject_isAutoReequipDisabled_VN );

    // borrar flag de item maldito que puediera quedar despues de una caida de servidor.
    object itemIterator = GetFirstItemInInventory( subject );
    while( itemIterator != OBJECT_INVALID ) {
        if( IPS_Item_getIsAdept( itemIterator ) )
            SetItemCursedFlag( itemIterator, FALSE );
        if( GetResRef( itemIterator ) == IPS_FLEETING_ITEM_RESREF ) {
            SetPlotFlag( itemIterator, FALSE );
            DestroyObject( itemIterator );
        }
        itemIterator = GetNextItemInInventory( subject );
    }
}


// Desequipa todos los ítems de OBJECT_SELF.
// debe ser llamado al menos una vez (al entrar por ejemplo) cuando el PJ 'OBJECT_SELF'
// esta en el área donde se espere para volver a la vida.
void IPS_Pj_onFugueEnter();
void IPS_Pj_onFugueEnter() {

    // permitir el quite de Items malditos aqui en el fugue
    SetLocalInt( OBJECT_SELF, IPS_Subject_isAutoReequipDisabled_VN, TRUE );

    // por las dudas se haya interrumpido un handler de maldicion mientras se esta con la pantalla oscura.
    FadeFromBlack( OBJECT_SELF );

    int slotIdIterator = NUM_INVENTORY_SLOTS;
    while( --slotIdIterator >= 0 ) {
        if( slotIdIterator != INVENTORY_SLOT_CARMOUR ) {
            object item = GetItemInSlot( slotIdIterator, OBJECT_SELF );
             ActionUnequipItem( item );
        }
    }
}

