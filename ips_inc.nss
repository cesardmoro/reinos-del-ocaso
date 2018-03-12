/******************* Item Properties System ************************************
package: Item Properties System - include
Autor: Inquisidor
Descripcion: sistema manejador de propiedades de items.
Este permite asociar a un item propiedades no visibles que se activan al equiparse.
Ademas soporta el agregado de restricciones inter items, como por ejemplo el no
apilamiento de habilidades y skills dados por items distintos.
*******************************************************************************/
#include "Store_basic"
//#include "prc_ipfeat_const"
//#include "RDO_const_skill"
//#include "SPC_itf" // quitar cuando se muevan las rutinas de las maldiciones a un script

#include "IPS_Property_inc"

////////////////////////////// CONSTANTS ///////////////////////////////////////
const int IPS_FEAT_IS_VIRGIN = 595;
const int IPS_FEAT_IS_KNOWN = 596;
const string IPS_TEMPORARY_CONTAINER_TAG = "IPS_temporaryContainer"; // Tag de algún contenedor inaccesible

const string IPS_ADJUSTMENTS_DATABASE = "adjips";

/////////////////////////// VARIABLE NAMES /////////////////////////////////////

const string IPS_Subject_isInAStore_VN = "IPSsias";
const string IPS_Subject_storeRef_VN = "IPSsr";
const string IPS_Subject_ultimoItemInspeccionado_VN = "IPSuii";
const string IPS_Store_doesIdentifyItems_PN = "IPSdii";
const string IPS_temporaryContainer_PN = "IPStc";

//////////////////////////// FORWARD DECLARATIONS //////////////////////////////

// Para todos los objetos equipados por 'subject', excepto 'unequipedItem', actualiza: (1) la intencidad de las propiedades que dependen de la intencidad de propiedades de otros items equipados, y (2) actualiza las variables que controlan los efectos inter item equipados.
// Esta operacion es llamada cuando se desequipa un item que tenga alguna propiedad CIALIPOIE (cuya intencidad afecte la intencidad de propiedades de otros items equipado)
// Nota: los items que no son parte de este sistema (IPS), no son afectados.
// Nota de implementacion: quita todas las propiedades CIDLIPOIE de todos los items equipados (excepto de unequipedItem), y luego las vuelve a poner.
void IPS_Subject_refreshEquipedItemsInteractProperties( object subject, object unequipedItem );


struct IPS_ItemInspectionReport {
    int propertiesCounter;
    int successfulIdentificationsCounter;
    string message;
};
// Accion de analizar las propiedades de un item por parte de un sujeto cuyo capacidad de inspección es 'subjectInspectSkill'.
// La dificultad del analisis esta dada por el nivel del ítem recibido, modificado por el valor porcentual 'levelModifier' [0-infinito). Si 'levelModifier' vale 100, no hay modificacion; si vale 50, la dificultad es la mitad.
// Hay propiedades que al ser analizadas envian al sujeto inspector, un mensaje con
// la descripcion de la propiedad.
struct IPS_ItemInspectionReport IPS_Item_inspect( object item, int levelModifier, int subjectInspectSkill );


////////////////////////////////////////////////////////////////////////////////
////////////////////////// Miscelaneos /////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

// Si 'isAlreadyIdentified' es falso, da la capacidad de 'subject' de descubrir e identificar las propiedades de un ítem.
// Si 'isAlreadyIdentified' es verdadero, da la capacidad de un sujeto X de entender las propiedades de un ítem cuando otro sujeto Y que ya las conoce se las explica.
int IPS_Subject_getInspectSkill( object subject, int isAlreadyIdentified );
int IPS_Subject_getInspectSkill( object subject, int isAlreadyIdentified ) {
//    return GetSkillRank( SKILL_LORE, subject ); // provisorio, borrar

    int identifySkill =
        GetAbilityModifier( ABILITY_INTELLIGENCE, subject )
        + GetSkillRank( SKILL_LORE_ARCANA, subject, TRUE )
        + GetSkillRank( SKILL_LORE_HISTORY, subject, TRUE )
        + GetSkillRank( SKILL_LORE_LOCAL, subject, TRUE )/2
        + ( GetSkillRank( SKILL_LORE_RELIGION, subject, TRUE ) * 3 )/4
        + GetSkillRank( SKILL_DESCIPHER, subject, TRUE )/2
    ;
    if( isAlreadyIdentified ) {
        int understandSkill = GetSkillRank( SKILL_USE_MAGIC_DEVICE, subject, FALSE );
        return identifySkill >= understandSkill ? identifySkill : understandSkill;
    } else {
        return identifySkill;
    }
}


///////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////// Item  //////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////

const string IPS_Item_isDisabled_VN = "IPSid"
    // cuando este booleano es TRUE, IPS_Item_activateChoosenProperties() no activa ninguna propiedad.
;
const string IPS_Item_lastEquipedSlotId_VN = "IPSlesi"
    // recuerda el id del último slot donde estuvo equipado el ítem. Solo es válido en el 'IPS_Subject_onUnequip(..)'
;
// funcion publica
// Da TRUE si el item nunca fue activado.
int IPS_Item_getIsVirgin( object item );
int IPS_Item_getIsVirgin( object item ) {
    return Item_hasProperty( item, ITEM_PROPERTY_BONUS_FEAT, IPS_FEAT_IS_VIRGIN );
}

// funcion privada
// Pone el estado del item como que ya fue activado alguna vez o nunca fue activado.
// Deuvelve el estado anterior.
int IPS_Item_setIsVirgin( object item, int flag );
int IPS_Item_setIsVirgin( object item, int flag ) {
    int previousState;
    if( !flag )
        previousState = Item_removeProperty( item, ITEM_PROPERTY_BONUS_FEAT, IPS_FEAT_IS_VIRGIN ) != 0;
    else {
        previousState = Item_hasProperty( item, ITEM_PROPERTY_BONUS_FEAT, IPS_FEAT_IS_VIRGIN );
        if( !previousState )
            AddItemProperty( DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat( IPS_FEAT_IS_VIRGIN ), item );
    }
    return previousState;
}

// funcion publica
// Da TRUE si el item no tiene el indicador de estado "desconocido" activado.
int IPS_Item_getIsKnown( object item );
int IPS_Item_getIsKnown( object item ) {
    return !Item_hasProperty( item, ITEM_PROPERTY_BONUS_FEAT, IPS_FEAT_IS_KNOWN );
}

// funcion privada
// Modifica el indicador de estado "desconocido" del item.
// Da el estado anterior del indicador.
// Nota: no modifica mas que el indicador. Ninguna propiedad del item ni ninguna
// otra cosa es modificada por esta funcion.
// ADVERTENCIA: No usar para hacer conocido o desconocido el item. Para ello
// usar IPS_Item_setAsKnow(..) y IPS_Item_setAsUnknown(..)
int IPS_Item_setIsKnown( object item, int flag );
int IPS_Item_setIsKnown( object item, int flag ) {
    int previousState;
    if( flag ) {
        SetIdentified( item, TRUE );
        previousState = Item_removeProperty( item, ITEM_PROPERTY_BONUS_FEAT, IPS_FEAT_IS_KNOWN ) == 0;
    }
    else {
        previousState = !Item_hasProperty( item, ITEM_PROPERTY_BONUS_FEAT, IPS_FEAT_IS_KNOWN );
        if( previousState )
            AddItemProperty( DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat( IPS_FEAT_IS_KNOWN ), item );
    }
    return previousState;
}


// Funcion privada usada por 'IPS_Subject_onActivatePacketizer(..)'
// Se asume que 'item' es (1) adepto al IPS, (2) de tipo municion ( Item_getIsAmmo(item)==TRUE) ),
// y (3) no es un paquete.
void IPS_Item_packetize( object item );
void IPS_Item_packetize( object item ) {
    int stackSize = GetItemStackSize( item );
    SetItemStackSize( item, 1 );
    SetName( item, IPS_PACKET_NAME_PREFIX + GetStringRight( IntToString( 100 + stackSize ), 2 ) + " " + GetName( item ) + "s" );
}


// Funcion privada usada por 'IPS_Subject_onActivatePacketizer(..)'
// Se asume que 'item' es un paquete de ammo del IPS (su nombre empieza con "paquete con ").
void IPS_Item_unpacketize( object item );
void IPS_Item_unpacketize( object item ) {
    string packetName = GetName( item );
    SetItemStackSize( item, IPS_Item_getAmmoPacketStackSize( item ) );
    SetName( item, GetSubString( packetName, IPS_PACKET_NAME_PREFIX_LENGTH + 3, GetStringLength( packetName ) - IPS_PACKET_NAME_PREFIX_LENGTH - 4 ) );
}


// Activa las propiedades del item cuyo campo 'attributes' satisfaga el filtro ('( propertyFlags & filterMask ) == filterValue').
// Nota: Se asume que el item es adepto al IPS
void IPS_Item_activateChosenProperties( object item, object subject, int filterValue, int filterMask=-1 );
void IPS_Item_activateChosenProperties( object item, object subject, int filterValue, int filterMask=-1 ) {
//    SendMessageToPC( GetFirstPC(), "IPS_Item_activateChosenProperties: item="+GetName(item)+", filterValue="+IntToString(filterValue)+", filterMask="+IntToString(filterMask) );
    if( GetLocalInt( item, IPS_Item_isDisabled_VN ) )
        return;
    string itemTag = GetTag( item );
    int itemTagLength = GetStringLength( itemTag );
    int propertyPtr = IPS_ITEM_TAG_PROPERTIES_OFFSET;
    while( propertyPtr < itemTagLength ) {
        string propertyDescriptor = GetSubString( itemTag, propertyPtr, IPS_ItemProperty_TOTAL_WIDTH );
        int propertyFlags = IPS_ItemProperty_getAttributes( propertyDescriptor );
//        SendMessageToPC( GetFirstPC(), "descriptor="+propertyDescriptor+", flags="+IntToString( propertyFlags ) );
        if( ( propertyFlags & filterMask ) == filterValue )
            IPS_ItemProperty_apply( propertyDescriptor, item, subject );
        propertyPtr += IPS_ItemProperty_TOTAL_WIDTH;
    }
//    SendMessageToPC( GetFirstPC(), "IPS_Item_activateChosenProperties: end" );
}


// Pasiva las propiedades del item cuyo campo 'special attributes' satisfaga el filtro.
// Devuelve la union de los atributos especiales de todas las propiedades que pasan el filtro.
// Nota: Se asume que el item es adepto al IPS
int IPS_Item_pasivateChosenProperties( object item, object subject, int filterValue, int filterMask=-1 );
int IPS_Item_pasivateChosenProperties( object item, object subject, int filterValue, int filterMask=-1 ) {
//    SendMessageToPC( GetFirstPC(), "IPS_Item_pasivateChosenProperties: filterValue="+IntToString(filterValue)+", filterMask="+IntToString(filterMask)+", itemName="+GetName(item) );
    // se quitan una por una las propiedades descriptas en el tag del item que sean dinamicas.
    string itemTag = GetTag( item );
    int union = 0;
    int itemTagLength = GetStringLength( itemTag );
    int propertyPtr = IPS_ITEM_TAG_PROPERTIES_OFFSET;
    while( propertyPtr < itemTagLength ) {
        string propertyDescriptor = GetSubString( itemTag, propertyPtr, IPS_ItemProperty_TOTAL_WIDTH );
        int propertyFlags = IPS_ItemProperty_getAttributes( propertyDescriptor );
//        SendMessageToPC( GetFirstPC(), "IPS_Item_pasivateChosenProperties: descriptor="+propertyDescriptor+", iflags="+IntToString( propertyFlags ) );
        if( ( propertyFlags & filterMask ) == filterValue ) {
            IPS_ItemProperty_remove( propertyDescriptor, item, subject );
            union |= propertyFlags;
        }
        propertyPtr += IPS_ItemProperty_TOTAL_WIDTH;
    }
//    SendMessageToPC( GetFirstPC(), "IPS_Item_pasivateChosenProperties: end" );
    return union;
}


// Desactiva todos las maldiciones de 'item' que esten en efecto en 'subject'.
// Nota: De nada sirve llamar a esta operacion si el ítem no esta maldito.
void IPS_Item_removeCurse( object item, object subject );
void IPS_Item_removeCurse( object item, object subject ) {
    string itemTag = GetTag( item );
    int itemTagLength = GetStringLength( itemTag );
    int propertyPtr = IPS_ITEM_TAG_PROPERTIES_OFFSET;
    while( propertyPtr < itemTagLength ) {
        string propertyDescriptor = GetSubString( itemTag, propertyPtr, IPS_ItemProperty_TOTAL_WIDTH );
        IPS_ItemProperty_removeCurse( propertyDescriptor, item, subject );
        propertyPtr += IPS_ItemProperty_TOTAL_WIDTH;
    }
}


struct Properties {
    string onCreationDescriptors; // IMPORTANTE: Las propiedades puestas en la creacion, SOLO deben afectar al item. O sea, que NO deben usar el parametro 'subject'.
    string onEquipDescriptors;
    string shownText;
    float quality;
    int flags;
};


// Nota 1: Las propiedades puestas en la creacion, SOLO deben afectar al item. O sea, que NO deben usar el parametro 'subject'.
// Nota 2: Dado que las "OnCreationProperties" no son registradas en el tag del item, es necesario
// que el item no tenga propiedades no "OnCreationProperties" del mismo tipo que una si "OnCreationProperties".
// Si esto pasara, la propiedad si "OnCreationProperties" en cuestion se perderia cuando
// la propiedad no "OnCreationProperties" sea pasivada.
void IPS_Item_addOnCreationProperties( object item, string propertiesArray );
void IPS_Item_addOnCreationProperties( object item, string propertiesArray ) {
    int afterLastPropertyPtr = GetStringLength( propertiesArray );
    int propertyPtr = 0;
    while( propertyPtr < afterLastPropertyPtr ) {
        string propertyDescriptor = GetSubString( propertiesArray, propertyPtr, IPS_ItemProperty_TOTAL_WIDTH );
        IPS_ItemProperty_apply( propertyDescriptor, item, OBJECT_INVALID );
        propertyPtr += IPS_ItemProperty_TOTAL_WIDTH;
    }
}

// Crea un item a partir de la plantilla dada por 'baseItemTemplate', y lo pone dentro de 'destinationContainer'.
// Al item creado se le agregan las propiedades dadas por 'properties'.
// ADVERTENCIA: esta funcion no ajusta el precio del ítem.
object IPS_Item_create( object destinationContainer, string baseItemTemplate, float baseItemQuality, struct Properties properties, int isForAStore=FALSE, int stackSize=1 );
object IPS_Item_create( object destinationContainer, string baseItemTemplate, float baseItemQuality, struct Properties properties, int isForAStore=FALSE, int stackSize=1 ) {
//    SendMessageToPC( GetFirstPC(), "baseItemTemplate="+baseItemTemplate );
    int itemLevelX31 = FloatToInt( 31.0*IPS_qualityToLevel( baseItemQuality + properties.quality ) ); //31 = 62 / 2
    if( itemLevelX31 > 3843 ) // 3843 = 62^2 - 1
        itemLevelX31 = 3843;
    object item = CreateItemOnObject( baseItemTemplate, destinationContainer, stackSize, IPS_ITEM_TAG_PREFIX + B62_build2(itemLevelX31) + B62_build2(properties.flags) + properties.onEquipDescriptors );
    if( !GetIsObjectValid( item ) ) {
        WriteTimestampedLogEntry( "IPS_Item_create: error, baseItemTemplate not found:" + baseItemTemplate );
        return OBJECT_INVALID;
    }
    IPS_Item_addOnCreationProperties( item, properties.onCreationDescriptors );
    IPS_Item_setIsKnown( item, isForAStore );
    IPS_Item_setIsVirgin( item, !isForAStore );
    SetStolenFlag( item, !isForAStore ); // Por convecion, los items adeptos al IPS no son vendibles mientras se esta fuera de una tienda adepta al IPS. El objetivo es evitar que un item adepto al IPS pueda ser vendido en una tienda no adepta al IPS (que no llame a IPS_onOpenStore() y IPS_onCloseStore() ).
    if( isForAStore ) {
        if( Item_getIsAmmo( item ) )
            IPS_Item_packetize( item );
        IPS_Item_activateChosenProperties( item, OBJECT_INVALID, 0, IPS_ItemProperty_Attribute_IS_DYNAMIC ); // activa las propiedades STATIC. Notar que las propiedades IRREMOVABLE son STATIC
        IPS_Item_activateChosenProperties( item, OBJECT_INVALID, IPS_ItemProperty_Attribute_IS_DYNAMIC, IPS_ItemProperty_Attribute_IS_DYNAMIC ); // activa las propiedades DYNAMIC. Notar que las propiedades AWARE e INTERACT son DYNAMIC
    }
    //SetName( item , GetName( item ) + properties.shownText );
    return item;
}


// Llamado de 'Store_onOpenForEachItemOfTheClient(..)' para determinar el precio del item.
// Prohibe la venta de municiones sueltas adeptas al IPS que este equipadas.
// Solo concede la venta a items adeptos al IPS que no sean municiones sueltas equipadas.
// Modifica el precio de los items adeptos al IPS que no sean municiones sueltas.
struct Store_PermisoVenta IPS_onItemArrivesStore( object item, object cliente, int isEquiped );
struct Store_PermisoVenta IPS_onItemArrivesStore( object item, object cliente, int isEquiped ) {
    struct Store_PermisoVenta permiso;
    int isAdept = IPS_Item_getIsAdept( item );
    int isLooseAmmo = isAdept && Item_getIsAmmo(item) && GetStringLeft( GetName(item), IPS_PACKET_NAME_PREFIX_LENGTH ) != IPS_PACKET_NAME_PREFIX;
    if( isLooseAmmo && !isEquiped )
        IPS_Item_packetize( item );
    permiso.prohibido = isLooseAmmo && isEquiped;
    permiso.concedido = isAdept && !permiso.prohibido; // concede la venta de los items adeptos al IPS.
    if( permiso.concedido )
        IPS_Item_adjustGoldValue( item, cliente );
    return permiso;
}


// Llamado de 'Store_onCloseForEachItemOfTheClient(..)' para determinar el precio del item.
// Devuelve TRUE para todos los items adeptos al IPS. O sea, los items adeptos al IPS no serán vendibles en tiendas no adeptas al IPS.
// Modifica el precio de los items adeptos al IPS, ya que les quita todos los modificadores de precio.
int IPS_onItemDepartsStore( object item, object cliente, int isEquiped );
int IPS_onItemDepartsStore( object item, object cliente, int isEquiped ) {
    int isAdept = IPS_Item_getIsAdept( item );
    if( isAdept && !isEquiped && Item_getIsAmmo(item) && GetStringLeft( GetName(item), IPS_PACKET_NAME_PREFIX_LENGTH ) == IPS_PACKET_NAME_PREFIX )
        IPS_Item_unpacketize( item );
    if( isAdept )
        Item_removeCrModifiers( item );
    return isAdept;
}


// Desabilita todas las propiedades del 'item'.
// Si 'item' esta equipado, 'equiper' debe ser válido y quien tiene equipado el 'item'.
// Se asume que 'item' es adepto al IPS, y que 'equiper' es válido si y solo si 'equiper'
// tiene a 'item' equipado.
void IPS_Item_disableProperties( object item, object equiper );
void IPS_Item_disableProperties( object item, object equiper ) {
    int anInteractPropertyWasRemoved = (IPS_Item_pasivateChosenProperties( item, equiper, 0, 0 ) & IPS_ItemProperty_Attribute_IS_INTERACT) != 0;
    if( anInteractPropertyWasRemoved && equiper != OBJECT_INVALID )
        IPS_Subject_refreshEquipedItemsInteractProperties( equiper, item ); // Por como esta definido el tipo de propiedad INTERACT, la única forma de corregir las intencidades de las propiedades INTERACT de los items equipados, es quitandolas todas y volviendolas a poner (sin importar el orden). Ver IPS_ItemProperty_Attribute_IS_INTERACT
    SetLocalInt( item, IPS_Item_isDisabled_VN, TRUE );
    SetIdentified( item, TRUE );
}


// Habilita las propiedades del 'item'. No hace nada si el ítem ya esta habilitado
// Si 'item' esta equipado, 'equiper' debe ser válido y quien tiene equipado el 'item'.
// Se asume que 'item' es adepto al IPS, y que 'equiper' es válido si y solo si 'equiper'
// tiene a 'item' equipado.
void IPS_Item_enableProperties( object item, object equiper );
void IPS_Item_enableProperties( object item, object equiper ) {
    if( GetLocalInt( item, IPS_Item_isDisabled_VN ) ) {
        DeleteLocalInt( item, IPS_Item_isDisabled_VN );
        int isKnown = IPS_Item_getIsKnown( item );
        // si es conocido, activar todas las propiedades
        if( isKnown )
            IPS_Item_activateChosenProperties( item, equiper, 0, 0 ); // activa todas las propiedades.
        // si no es conocido y esta equipado, activar todas las propiedades DYNAMIC e IRREMOVABLE (o sea todas menos las STATIC REMOVABLE)
        else if( equiper != OBJECT_INVALID ) {
            IPS_Item_activateChosenProperties( item, equiper, IPS_ItemProperty_Attribute_IS_DYNAMIC, IPS_ItemProperty_Attribute_IS_DYNAMIC ); // activa todas las propiedades DYNAMIC
            IPS_Item_activateChosenProperties( item, equiper, IPS_ItemProperty_Attribute_IS_IRREMOVABLE, IPS_ItemProperty_Attribute_IS_IRREMOVABLE ); // activa todas las propiedades IRREMOVABLE
        }
        // si no es conocido, no esta equipado, y no es virgen, activar las propiedades IRREMOVABLE
        else if( !IPS_Item_getIsVirgin( item ) )
            IPS_Item_activateChosenProperties( item, equiper, IPS_ItemProperty_Attribute_IS_IRREMOVABLE, IPS_ItemProperty_Attribute_IS_IRREMOVABLE ); // activa solo las propiedades IRREMOVABLE
        // si no es conocido, esta desequipado, y es virgen, no se activa ninguna propiedad.

        SetIdentified( item, isKnown || equiper == OBJECT_INVALID );
    }
}


// funcion publica
// Cambia el item de estado desconocido a conocido, y hace visibles a todas las propiedades.
// El parametro 'equiper' debe ser válido e igual a quien equipa el item, si y solo si el
// 'item' esta siendo equipado por un sujeto adepto al IPS. Con "siendo equipado" me refiero al estado, no a la acción.
// Activa siempre todas las propiedades STATIC; y si 'equiper' es OBJECT_INVALID, que
// indica que el item no esta equipado por un sujeto adepto al IPS, tambien activa todas
// las propiedades DYNAMIC.
// Se asume que el item es adepto al IPS. No hace efecto si es llamada cuando el ítem ya esta en estado "conocido".
// Recordatorio: si esta funcion es llamada sobre un item poseido por un sujeto que esta en
// una tienda, no olvidar de ajustar el oro luego del retorno.
void IPS_Item_setAsKnown( object item, object equiper );
void IPS_Item_setAsKnown( object item, object equiper ) {
    SetIdentified( item, TRUE ); // solo es necesario hacer visible las propiedades cuando el item esta equipado, pero no molesta hacerlo siempre.
    // marcar al item con el indicador de "conocido". Si estaba "desconocido", activar las propiedades STATIC. Y si además de "desconocido" no esta equipado, activar las propiedades DYNAMIC
    if( !IPS_Item_setIsKnown( item, TRUE ) ) {
        if( equiper == OBJECT_INVALID ) {
            IPS_Item_activateChosenProperties( item, OBJECT_INVALID, IPS_ItemProperty_Attribute_IS_DYNAMIC, IPS_ItemProperty_Attribute_IS_DYNAMIC ); // activa todas las propiedades DYNAMIC. Notar que las propiedades AWARE e INTERACT son DYNAMIC
            // si el item nunca fue equipado ni estudiado exitosamente, activar todas las propiedades STATIC.
            if( IPS_Item_setIsVirgin( item, FALSE ) )
                IPS_Item_activateChosenProperties( item, OBJECT_INVALID, 0, IPS_ItemProperty_Attribute_IS_DYNAMIC ); // activa las propiedades STATIC, independientemente de si son IRREMOVIBLE o no.
            /// si ya fue equipado o estudiado alguna vez, activar las propiedades STATIC que no sean IRREMOVABLE (ya que se asume que las IRREMOVABLE ya fueron activadas).
            else
                IPS_Item_activateChosenProperties( item, OBJECT_INVALID, 0, IPS_ItemProperty_Attribute_IS_DYNAMIC|IPS_ItemProperty_Attribute_IS_IRREMOVABLE ); // activa las instancias que no son DYNAMIC ni IRREMOVABLE, o sea que activa las que son STATIC no IRREMOVIBLES
        }
        else
            IPS_Item_activateChosenProperties( item, equiper, 0, IPS_ItemProperty_Attribute_IS_DYNAMIC|IPS_ItemProperty_Attribute_IS_IRREMOVABLE ); // activa las instancias que no son DYNAMIC ni IRREMOVABLE, o sea que activa las que son STATIC no IRREMOVIBLES
    }
}


// funcion publica
// Cambia el item de estado conocido a no conocido, y hace no visibles a todas las propiedades.
// El parametro 'equiper' debe ser válido e igual a quien equipa el item, si y solo si el
// 'item' esta siendo equipado por un sujeto adepto al IPS.  Con "siendo equipado" me refiero al estado, no a la acción.
// Pasiva siempre las propiedades STATIC que no sean IRREMOVABLE; y si 'equiper' es
// OBJECT_INVALID, que indica que el item no esta equipado por un sujeto adepto al IPS,
// tambien pasiva todas las propiedades DYNAMIC.
// Recordar que no se pueden usar las propiedades activables de un item no conocido.
// Se asume que el item es adepto al IPS.  No hace efecto si es llamada cuando el ítem ya esta en estado "desconocido".
// Recordatorio: si esta funcion es llamada sobre un item poseido por un sujeto que esta en
// una tienda, no olvidar de ajustar el oro luego del retorno.
void IPS_Item_setAsUnknown( object item, object equiper=OBJECT_INVALID );
void IPS_Item_setAsUnknown( object item, object equiper=OBJECT_INVALID ) {
    SetIdentified( item, equiper == OBJECT_INVALID || GetLocalInt( item, IPS_Item_isDisabled_VN ) );
    // marcar al item con el indicador de "desconocido". Si estaba "conocido", pasivar las propieades STATIC. Si además de "conocido" no esta equipado, pasivar las propiedades DYNAMIC.
    if( IPS_Item_setIsKnown( item, FALSE ) ) {
        IPS_Item_pasivateChosenProperties( item, equiper, 0, IPS_ItemProperty_Attribute_IS_DYNAMIC|IPS_ItemProperty_Attribute_IS_IRREMOVABLE ); // pasiva las propiedades STATIC que no son IRREMOVABLE
        if( equiper == OBJECT_INVALID )
            IPS_Item_pasivateChosenProperties( item, OBJECT_INVALID, IPS_ItemProperty_Attribute_IS_DYNAMIC, IPS_ItemProperty_Attribute_IS_DYNAMIC ); // pasiva las propiedades DYNAMIC. Notar que las propiedades AWARE e INTERACT son DYNAMIC
        // debug
        object receiver = GetItemPossessor(item);
        if( receiver == OBJECT_INVALID ) {
            receiver = GetLocalObject( item, "CIBrp" );
        }
        SendMessageToPC( receiver, "//##DEBUG: el item '"+GetName(item)+"' ha sido desidentificado. Si no corresponde, avisar a Inquisidor mediante el foro (seccion bugs, denuncias y preguntas). STATE: e="+GetName(equiper)+", p="+GetName(GetItemPossessor(item)) );
    }
}


// funcion privada
// Convierte un item de conocido a no conocido si éste no esta siendo poseido por alguien.
// Nota: Se asume que OBJECT_SELF es un item adepto al IPS, y esta en estado conocido ( IPS_getIsKnown(..)==TRUE ).
void IPS_Item_setAsUnknownIfNotPossessed();
void IPS_Item_setAsUnknownIfNotPossessed() {
//    SendMessageToPC( GetFirstPC(), "IPS_Item_setAsUnknownIfNotPossessed: begin" );
    if( GetItemPossessor( OBJECT_SELF ) == OBJECT_INVALID ) {
//        SendMessageToPC( GetFirstPC(), "IPS_Item_setAsUnknownIfNotPossessed: olvidando y pasivando" );
        IPS_Item_setAsUnknown( OBJECT_SELF );
        // por las dudas el item fue avandonado cuando su propietario estaba en una tienda, quitar los modificadores de precio. Esto no es necesario. Esta para que no perjudique la performance, en el caso que alguien tome el item y lo use con los modificadores de precio puestos.
        Item_removeCrModifiers( OBJECT_SELF );
    }
}


// Accion de analizar las propiedades de un item por parte de un sujeto.
// La dificultad del analisis esta dada por el nivel del ítem recibido, modificado por el valor porcentual 'levelModifier' [0-infinito). Si 'levelModifier' vale 100, no hay modificacion; si vale 50, la dificultad es la mitad.
// Hay propiedades que al ser analizadas envian al sujeto inspector, un mensaje con
// la descripcion de la propiedad.
struct IPS_ItemInspectionReport IPS_Item_inspect( object item, int levelModifier, int subjectInspectSkill ) {
    struct IPS_ItemInspectionReport report;
    string itemTag = GetTag( item );
    int propertyPtr = IPS_ITEM_TAG_PROPERTIES_OFFSET;
    int itemTagLength = GetStringLength( itemTag );
    while( propertyPtr < itemTagLength ) {
        string propertyDescriptor = GetSubString( itemTag, propertyPtr, IPS_ItemProperty_TOTAL_WIDTH );
        string inspectionMessage = IPS_ItemProperty_inspect( propertyDescriptor, item, levelModifier, subjectInspectSkill );
        if( inspectionMessage != "" ) {
            ++report.successfulIdentificationsCounter;
            report.message += "\n"+inspectionMessage;
        }
        ++report.propertiesCounter;
        propertyPtr += IPS_ItemProperty_TOTAL_WIDTH;
    }
    return report;
}


void IPS_Item_debug( object item, object dm ) {
    if( GetIsObjectValid( item ) ) {
        string itemTag = GetTag( item );
        string message =
            "resRef="+GetResRef( item )
            +"\ntag="+itemTag
            +"\nengineValue="+IntToString( GetGoldPieceValue( item ) )
        ;
        if( IPS_Item_getIsAdept( item ) ) {
            int genuineGoldValue = IPS_Item_getGenuineGoldValue( item );
            int isVirgin = IPS_Item_getIsVirgin( item );
            int isKnown = IPS_Item_getIsKnown( item );
            int isDisabled = GetLocalInt( item, IPS_Item_isDisabled_VN );
            int isCursed = (IPS_Item_getFlags( item ) & IPS_ITEM_FLAG_IS_CURSED) != 0;
            message +=
                ", genuineValue="+IntToString( genuineGoldValue )
                +"\nisVirgin="+IntToString( isVirgin )
                +", isKnown="+IntToString( isKnown )
                +", isDisabled="+IntToString( isDisabled )
                +", isCursed="+IntToString( isCursed )
                +"\n   Properties:"
            ;
            int itemTagLength = GetStringLength( itemTag );
            int propertyPtr = IPS_ITEM_TAG_PROPERTIES_OFFSET;
            while( propertyPtr < itemTagLength ) {
                string propertyDescriptor = GetSubString( itemTag, propertyPtr, IPS_ItemProperty_TOTAL_WIDTH );
                int propertyIndex = B62_toInt( GetSubString( propertyDescriptor, IPS_ItemProperty_INDEX_OFFSET, IPS_ItemProperty_INDEX_WIDTH ) );
                int propertyFlags = IPS_ItemProperty_getAttributes( propertyDescriptor );
                message +=
                    "\ndescriptor="+propertyDescriptor
                    +", index="+IntToString( propertyIndex )
                    +", flags="+IntToString( propertyFlags )
                ;
                propertyPtr += IPS_ItemProperty_TOTAL_WIDTH;
            }
        }
        SendMessageToPC( dm, message );
    }
}


///////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////// Subject //////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////

const string IPS_Subject_isRemoveCurseInEffect_VN = "IPSircie"
    // indica si hay un remove curse en efecto. Esta marca es puesta en TRUE cuando el sujeto es blanco de un remove curse,
    // y puesta en FALSE cuando un íteM cursed es desequipado.
;
const string IPS_Subject_isAutoReequipDisabled_VN = "IPSiard"
    // Cuando esta en TRUE, los ítems cursed no son reequipado por el IPS. Esto permite que un script desequipe los ítems cursed. Claro que tiene que responsabilizarse de volver a poner esta marca en FALSE nuevamente luego de un intervalo.
;

// descripcion arriba, en la declaracion
void IPS_Subject_refreshEquipedItemsInteractProperties( object subject, object unequipedItem ) {
    // de todos los items que permanecerán equipados por 'subject', se quitan todas las propiedades INTERACT.
    int slotIdIterator = NUM_INVENTORY_SLOTS;
    while( --slotIdIterator >= 0 ) {
        object item = GetItemInSlot( slotIdIterator, subject );
//        SendMessageToPC( GetFirstPC(), "IPS_Subject_refreshEquipedItemsInteractProperties: item="+GetName(item) );
        if( item != unequipedItem && IPS_Item_getIsAdept( item ) )
            IPS_Item_pasivateChosenProperties( item, subject, IPS_ItemProperty_Attribute_IS_INTERACT, IPS_ItemProperty_Attribute_IS_INTERACT );
    }

    // y luego se vuelven a poner. Tiene que ser despues de haber pasivado todos los items equipados para que se reseten las variables de estado de interaccion entre items equipados.
    slotIdIterator = NUM_INVENTORY_SLOTS;
    while( --slotIdIterator >= 0 ) {
        object item = GetItemInSlot( slotIdIterator, subject );
        if( item != unequipedItem && IPS_Item_getIsAdept( item ) )
            IPS_Item_activateChosenProperties( item, subject, IPS_ItemProperty_Attribute_IS_INTERACT, IPS_ItemProperty_Attribute_IS_INTERACT );
    }
}


// Debe ser llamada desde el playerOnEquip event handler de los PJs.
// Tambien debe ser llamada desde la AI de las criaturas cuando equipan items
// adeptos al IPS. De no hacerlo, aplicarían las propiedades como se ven
// en el inventario de un PJ y los efectos apilarian con los de otros items equipados
// por la criatura.
void IPS_Subject_onEquip( object subject, object item );
void IPS_Subject_onEquip( object subject, object item ) {
//    SendMessageToPC( GetFirstPC(), "IPS_Subject_onEquip: itemTag="+GetTag( item )+", itemName="+GetName(item) );

    // si no es un item generado por el IPS, ignorarlo
    if( !IPS_Item_getIsAdept( item ) )
        return;

    // si es la primera vez que el item es equipado (y no fue estudiado exitosamente), activar las propiedades IRREMOVABLE. Las propiedades IRREMOVABLE perduran eternamente una vez puestas.
    if( IPS_Item_getIsVirgin( item ) ) {
        IPS_Item_setIsVirgin( item, FALSE );
        IPS_Item_activateChosenProperties( item, subject, IPS_ItemProperty_Attribute_IS_IRREMOVABLE, IPS_ItemProperty_Attribute_IS_IRREMOVABLE );
    }
    //Tambien sucede esto cuando 'subject' entra al modulo, con todos los items que tenia equipados al salir. Para esto ultimo se asume que los PJs entran al modulo limpios de variables locales. De no ser asi, habra que setear una variable en el onClientEnter para distinguir el caso.

    // Si el item a equipar esta en estado "conocido", entonces esta activo (o sea que sus propiedades dinamicas estan activas).
    if( IPS_Item_getIsKnown( item ) ) { // Notar que un item no equipado esta activo si y solo si esta en estado "conocido".
        // Dado que el item no estaba equipado, por convencion se asume que fue activado con el parametro 'subject' igual a OBJECT_INVALID.
        // Y como las instancias de propiedades AWARE requieren que los items equipados hayan sido activados con el parametro 'subject' valido e igual al portador del item, es necesario volver a activar todas las propiedades AWARE del item a equipar. Pero como no se debe reactivar, primero hay que pasivarlas con el parametro 'subject' igual a OBJECT_INVALID. Ver propiedad AWARE y generales.
        IPS_Item_pasivateChosenProperties( item, OBJECT_INVALID, IPS_ItemProperty_Attribute_IS_AWARE, IPS_ItemProperty_Attribute_IS_AWARE ); // Notar que se uso OBJECT_INVALID en el parametro 'subject'. Esto evita que se invaliden las intencidades de las propiedades INTERACT de los items equipados. Recordar que segun la definicion de INTERACT, las implementaciones de 'IPS_ItemProperty_remove(..)' no requieren cuidarse de invalidar las intencidades de propiedades de otros items equipados. Ver IPS_ItemProperty_Attribute_IS_INTERACT.
        IPS_Item_activateChosenProperties( item, subject, IPS_ItemProperty_Attribute_IS_AWARE, IPS_ItemProperty_Attribute_IS_AWARE );
    }
    // si el item a equipar esta en estado "desconocido", entonces esta pasivo (o sea que sus propiedades dinamicas estan pasivas), por lo tanto hay que:
    else {
        // poner el flag del motor en false para impedir que el jugador vea las propiedades.
        if( !GetLocalInt( item, IPS_Item_isDisabled_VN ) )
            SetIdentified( item, FALSE );
        // activar las propiedades dinamicas. Notar que las propiedades AWARE e INTERACT tambien son DYNAMIC
        IPS_Item_activateChosenProperties( item, subject, IPS_ItemProperty_Attribute_IS_DYNAMIC, IPS_ItemProperty_Attribute_IS_DYNAMIC );
    }

    // si 'subject' esta en una tienda, ajustar el valor del ítem. Es necesario ya que el hecho de equipar el item cambia sus propiedades, y por ende, su valor
    if( GetLocalInt( subject, IPS_Subject_isInAStore_VN ) )
        IPS_Item_adjustGoldValue( item, subject );

    // recordar en que slot es equipado el ítem. Util cuando se lo quiere reequipar automaticamente (por ejemplo cuando esta cursed).
    SetLocalInt( item, IPS_Item_lastEquipedSlotId_VN, Item_getEquipedSlotId( item, subject ) );
    // borrar la marca que indica si el ítem se intento desequipar (esto sirve solo para los ítems malditos).
    DeleteLocalInt( item, IPS_Item_hasBeenTriedToRemove_VN );
}


// Debe ser llamada desde el playerOnUnequip event handler de los PJs.
// Tambien debe ser llamada desde la AI de las criaturas cuando desequipan items
// adeptos al IPS, si es que se llamo a IPS_Subject_onEquip(..) cuando el mismo
// ítem fue equipado.
void IPS_Subject_onUnequip( object subject, object item );
void IPS_Subject_onUnequip( object subject, object item ) {
//    SendMessageToPC( GetFirstPC(), "IPS_Subject_onUnequip: itemTag="+GetTag( item )+"isKnown="+IntToString( IPS_Item_getIsKnown( item ) ) );

    // si no es un item generado por el IPS, ignorarlo
    if( !IPS_Item_getIsAdept( item ) )
        return;

    // poner el flag del motor para que el item pueda ser equipado
    SetIdentified( item, TRUE );

    // si el ítem esta maldito
    if( (IPS_Item_getFlags( item ) & IPS_ITEM_FLAG_IS_CURSED) != 0 ) {
        // si el ítem tiene la maldicion despierta
        if( GetItemCursedFlag(item) ) {
            // si hay un remove curse aplicado a 'subject' o esta deshabilitado el atuo equipamiento, dormir y remover la maldiciones asociadas a este ítem del PJ y borrar la marca de que hay un remove curse aplicado
            if( GetLocalInt( subject, IPS_Subject_isRemoveCurseInEffect_VN ) || GetLocalInt( subject, IPS_Subject_isAutoReequipDisabled_VN ) ) {
                IPS_Item_removeCurse( item, subject );
                DeleteLocalInt( subject, IPS_Subject_isRemoveCurseInEffect_VN );
                SetItemCursedFlag( item, FALSE );
            }
            // si no hay remove curse aplicado, reequipar automáticamente el ítem
            else {
//                SendMessageToPC( GetFirstPC(), "IPS_Subject_onUnequip: lastEquipedSlotId="+IntToString(GetLocalInt( item, IPS_Item_lastEquipedSlotId_VN )) );
                SetLocalInt( item, IPS_Item_hasBeenTriedToRemove_VN, TRUE );
                AssignCommand( subject, ActionEquipItem( item, GetLocalInt( item, IPS_Item_lastEquipedSlotId_VN ) ) );
            }
        }
        // si el ítem no tiene la maldicion despierta, remover la maldicion
        else
            IPS_Item_removeCurse( item, subject );
    }

    // Se asume que los items equipados estan activados (todas sus propiedades DYNAMIC estan activas).
    // Entonces, si el item desequipado esta en estado "conocido", hay que reactivar las propiedades AWARE del item desequipado con el parametro 'subject' igual a OBJECT_INVALID.
    if( IPS_Item_getIsKnown( item ) ) {
        // Pasivar las propiedades AWARE del item desequipado, y si alguna es INTERACT, hacer un refresh de las intencidades de las propiedades INTERACT de los items equipados. Para una explicacion de porque es esto necesario, ver IPS_ItemProperty_Attribute_IS_INTERACT.
        if( (IPS_Item_pasivateChosenProperties( item, subject, IPS_ItemProperty_Attribute_IS_AWARE, IPS_ItemProperty_Attribute_IS_AWARE ) & IPS_ItemProperty_Attribute_IS_INTERACT) != 0 )
            IPS_Subject_refreshEquipedItemsInteractProperties( subject, item ); // Por como esta definido el tipo de propiedad INTERACT, la única forma de corregir las intencidades de las propiedades INTERACT de los items equipados, es quitandolas todas y volviendolas a poner (sin importar el orden). Ver IPS_ItemProperty_Attribute_IS_INTERACT
        // dado que al ejecutarse el evento onUnequip el item a desequipar aún sigue equipado, y a que la activacion de una propiedad INTERACT puede modificar las intencidades de otros items equipados; la reactivacion de las propiedades AWARE del item desequipado debe hacerse despues de llamar a 'IPS_Subject_refreshEquipedItemsInteractProperties(..)' dado
        IPS_Item_activateChosenProperties( item, OBJECT_INVALID, IPS_ItemProperty_Attribute_IS_AWARE, IPS_ItemProperty_Attribute_IS_AWARE );
    }
    // Si el item esta en estado "desconocido"
    else {
        // pasivar todas las propiedades DYNAMIC del item desequipado (para evitar que sean vistas), y si alguna es INTERACT. hacer un refresh de las intencidades de las propiedades INTERACT de los items equipados. Para una explicacion de porque es esto necesario, ver IPS_ItemProperty_Attribute_IS_INTERACT. Notar que las propiedades AWARE e INTERACT son DYNAMIC.
        if( (IPS_Item_pasivateChosenProperties( item, subject, IPS_ItemProperty_Attribute_IS_DYNAMIC, IPS_ItemProperty_Attribute_IS_DYNAMIC ) & IPS_ItemProperty_Attribute_IS_INTERACT ) != 0 )
            IPS_Subject_refreshEquipedItemsInteractProperties( subject, item ); // Por como esta definido el tipo de propiedad INTERACT, la única forma de corregir las intencidades de las propiedades INTERACT de los items equipados, es quitandolas todas y volviendolas a poner (sin importar el orden). Ver IPS_ItemProperty_Attribute_IS_INTERACT
    }

    if( GetLocalInt( subject, IPS_Subject_isInAStore_VN ) )
        IPS_Item_adjustGoldValue( item, subject );

    //DeleteLocalInt( item, IPS_Item_lastEquipedSlotId_VN );
}


// Debe ser llamado desde los handlers que identifiquen un 'item', sea el handler
// de un hechizo o el de una herramienta activable.
void IPS_Subject_onInspectItem( object subject, object item );
void IPS_Subject_onInspectItem( object subject, object item ) {
//    SendMessageToPC( GetFirstPC(), "level="+FloatToString( IPS_Item_getLevel( item ) ) );
    if( IPS_Item_getIsAdept( item )  ) {
        int isEquiped = Item_getEquipedSlotId( item, subject ) >= 0;

        // si 'subject' conoce el 'item'
        if( IPS_Item_getIsKnown( item ) ) {
            if( item == GetLocalObject( subject, IPS_Subject_ultimoItemInspeccionado_VN ) ) {
                SendMessageToPC( subject, "*Ocultas lo que sabes del item*" );
                IPS_Item_setAsUnknown( item, isEquiped ? subject : OBJECT_INVALID );
                if( GetLocalInt( subject, IPS_Subject_isInAStore_VN )  )
                    IPS_Item_adjustGoldValue( item, subject );
            }
            else
                SendMessageToPC( subject, "*Ya conoces este ítem.* //Para ocultar lo que sabes, vuelve a usar la lupa sobre él.\nADVERTENCIA: si ocultas lo que sabes, te costará a ti tambien volver a averiguarlo." );
        }
        // si 'subject' no conoce el 'ítem'.
        else {
            // si el item es estudiado completamente
            struct IPS_ItemInspectionReport report = IPS_Item_inspect( item, 75, IPS_Subject_getInspectSkill( subject, FALSE ) ); // EL DC para identificar se busca sea cercano al 75% del CR del encuentro cuyas criaturas dropearon el item.
            if( report.successfulIdentificationsCounter == report.propertiesCounter ) {
                if( report.propertiesCounter > 0 )
                    SendMessageToPC( subject, "Resultados del estudio del ítem:"+report.message+"\nEstás convencido que las anteriores son todas las propiedades mágicas que tiene. //nivel="+IntToString((IPS_Item_getLevelx31(item)+15)/31) );
                else
                    SendMessageToPC( subject, "Resultados del estudio del ítem: no tiene porpiedades mágicas. //nivel="+IntToString((IPS_Item_getLevelx31(item)+15)/31) );
                IPS_Item_setAsKnown( item, isEquiped ? subject : OBJECT_INVALID );

                // mientras el sujeto que lo porta esta en una tienda, debe tener el valor en oro ajustado.
                if( GetLocalInt( subject, IPS_Subject_isInAStore_VN )  )
                    IPS_Item_adjustGoldValue( item, subject );

                // si el item estudiado esta en el suelo, programar se pierda el conocimiento de él si pasa un minuto sin que nadie lo tome.
                if( GetItemPossessor( item ) == OBJECT_INVALID )
                    AssignCommand( item, DelayCommand( 60.0, IPS_Item_setAsUnknownIfNotPossessed() ) );

                DeleteLocalObject( subject, IPS_Subject_ultimoItemInspeccionado_VN );
            }
            // si no se logro estudiar completamente el ítem
            else {
                // si el posesor del 'item' es 'subject', y 'subject' esta en una tienda que identifica ítems
                object store = GetLocalObject( subject, IPS_Subject_storeRef_VN );
                if( GetItemPossessor( item ) == subject && GetLocalInt( store, IPS_Store_doesIdentifyItems_PN ) ) {
                    int isCursed = (IPS_Item_getFlags(item) & IPS_ITEM_FLAG_IS_CURSED) != 0;
                    int identificationPorcentualCost = 15 + ( isCursed ? 20 : 0 );
                    int identificationCost = (IPS_Item_getGenuineGoldValue( item ) * identificationPorcentualCost ) / 100;
                    // si es la segunda vez seguida que se usa la lupa sobre este ítem, se realiza la accion de identificacion por parte del mercader
                    if( item == GetLocalObject( subject, IPS_Subject_ultimoItemInspeccionado_VN ) ) {
                        if( GetGold( subject ) >= identificationCost ) {
                            report = IPS_Item_inspect( item, 0, 999 );
                            IPS_Item_setAsKnown( item, isEquiped ? subject : OBJECT_INVALID );
                            IPS_Item_adjustGoldValue( item, subject );
                            if( isCursed ) {
                                SendMessageToPC( subject, "*El mercader estudia el objeto un momento, y luego de revisar en algunos libros se dirige hacia ti para enumerarte sus cualidades mágicas:" + report.message );
                                SendMessageToPC( subject, "Luego te dice* ¿Entendió bien lo que le dije? ¡Está maldito! Yo que usted me quito eso de ensima." );
                            }
                            else if( report.propertiesCounter > 0 ) {
                                SendMessageToPC( subject, "*El mercader estudia el objeto un momento, y luego de revisar en algunos libros se dirige hacia ti para enumerarte sus cualidades mágicas:" + report.message );
                                SendMessageToPC( subject, "Luego te dice* Lo que tienes aquí es un objeto excepcional, una maravilla!" );
                            }
                            else {
                                SendMessageToPC( subject, "*El mercader estudia el objeto un momento para decirte* Temo decirle que esto es una baratija." );
                            }
                            AssignCommand( subject, TakeGoldFromCreature( identificationCost, subject, TRUE ) );
                            DeleteLocalObject( subject, IPS_Subject_ultimoItemInspeccionado_VN );
                        }
                        else
                            SendMessageToPC( subject, "¡No tienes suficiente dinero!" );
                    }
                    // si es la primera vez que se usa la lupa sobre este ítem, decirle a 'subject' cuanto costará el estudio.
                    else
                        SendMessageToPC( subject, "*El mercader se ofrece a identificar el item por "+IntToString( identificationCost )+ " monedas.* //usa la lupa sobre el mismo ítem para aceptar." );
                }
                // si no esta en una tienda que identifica ítems
                else {
                    if( !isEquiped ) // esto esta por las dudas un item no equipado quede unidentified y lo haga inutilizable. Con estas dos lineas las lupa sirve para solucionar si se presenta ese caso.
                        SetIdentified( item, TRUE );

                    if( report.successfulIdentificationsCounter > 0 )
                        SendMessageToPC( subject, "Resultados del estudio del ítem:"+report.message+"\nFin" );
                    else
                        SendMessageToPC( subject, "Resultados del estudio del ítem: no notas nada fuera de lo común." );
                }
            }
        }
    }
    SetLocalObject( subject, IPS_Subject_ultimoItemInspeccionado_VN, item );
}

// funcion privada.
// Por Hay un bug de bioware, el peso del personaje no se ajusta cuando se se usa 'SetItemStackSize(..)'.
// Como remedio se crea y destruye un item fugaz, ya el peso se ajusta en el onUnaquire, el cual
// es disparado cuando el item fugaz es destruido.
void IPS_Subject_refreshWeight( object subject );
void IPS_Subject_refreshWeight( object subject ) {
    DestroyObject( CreateItemOnObject( IPS_FLEETING_ITEM_RESREF, subject ), 1.0 );
}

// Una tienda es adepta al IPS cuando:
// 1) El onOpenStore event handler llama a 'IPS_Subject_onOpenStore(..)'
// 2) El onStoreClose event handler llama a 'IPS_Subject_onCloseStore(..)'
// 3) Es adepta a Store (ver 'Store_actualizarPrecioItemsArrivoCliente()' y
//    'Store_actualizarPrecioItemsPartidaCliente(..)').
// 4) La funcion 'IPS_onItemArrivesStore(..)' esta en la lista de handlers de
//    onItemArrivesStore dentro de 'Store_onOpenForEachItemOfTheClient(..)'.
// 5) La funcion 'IPS_onItemDepartsStore(..)' esta en la lista de handlers de
//    onItemDepartsStore dentro de 'Store_onCloseForEachItemOfTheClient(..)'.
// Las tiendas que no son adeptas al IPS no podran comprar items adeptos al IPS, porque
// el IPS mantiene invendibles a todos los items adeptos al IPS, excepto mientras se esta
// en una tienda adepta al IPS.
void IPS_Subject_onOpenStore( object subject );
void IPS_Subject_onOpenStore( object subject ) {
    SetLocalInt( subject, IPS_Subject_isInAStore_VN, TRUE );
    SetLocalObject( subject, IPS_Subject_storeRef_VN, OBJECT_SELF );
    DeleteLocalObject( subject, IPS_Subject_ultimoItemInspeccionado_VN );
    IPS_Subject_refreshWeight( subject );

    object itemIterator = GetFirstItemInInventory( OBJECT_SELF );
    while( itemIterator != OBJECT_INVALID ) {
        if( IPS_Item_getIsAdept( itemIterator ) && !IPS_Item_getIsKnown( itemIterator ) ) {
            IPS_Item_setAsKnown( itemIterator, OBJECT_INVALID );
            IPS_Item_adjustGoldValue( itemIterator, OBJECT_INVALID );
        }
        itemIterator = GetNextItemInInventory( OBJECT_SELF );
    }
}

// Una tienda es adepta al IPS cuando:
// 1) El onOpenStore event handler llama a 'IPS_Subject_onOpenStore(..)'
// 2) El onStoreClose event handler llama a 'IPS_Subject_onCloseStore(..)'
// 3) Es adepta a Store (ver 'Store_actualizarPrecioItemsArrivoCliente()' y
//    'Store_actualizarPrecioItemsPartidaCliente(..)').
// 4) La funcion 'IPS_onItemArrivesStore(..)' esta en la lista de handlers de
//    onItemArrivesStore dentro de 'Store_onOpenForEachItemOfTheClient(..)'.
// 5) La funcion 'IPS_onItemDepartsStore(..)' esta en la lista de handlers de
//    onItemDepartsStore dentro de 'Store_onCloseForEachItemOfTheClient(..)'.
// Las tiendas que no son adeptas al IPS no podran comprar items adeptos al IPS, porque
// el IPS mantiene invendibles a todos los items adeptos al IPS, excepto mientras se esta
// en una tienda adepta al IPS.
void IPS_Subject_onCloseStore( object subject );
void IPS_Subject_onCloseStore( object subject ) {
    DeleteLocalInt( subject, IPS_Subject_isInAStore_VN );
    DeleteLocalObject( subject, IPS_Subject_storeRef_VN );
    DeleteLocalObject( subject, IPS_Subject_ultimoItemInspeccionado_VN );
    IPS_Subject_refreshWeight( subject );
}




// Debe ser llamada desde el onModuleLoad event handler para que las funciones que generan items adeptos al IPS funcionen.
void IPS_onModuleLoad();
void IPS_onModuleLoad() {
    SetLocalObject( GetModule(), IPS_temporaryContainer_PN, GetObjectByTag( IPS_TEMPORARY_CONTAINER_TAG ) );
}

