/******************* Item Properties System ************************************
package: Item Properties System - low level include
Autor: Inquisidor
Descripcion: sistema manejador de propiedades de items.
Este permite asociar a un item propiedades no visibles que se activan al equiparse.
Ademas soporta el agregado de restricciones inter items, como por ejemplo el no
apilamiento de habilidades y skills dados por items distintos.
*******************************************************************************/

#include "Base62_inc"
#include "Item_inc"


// Determina el precio de los items adeptos al IPS.
const int IPS_ITEM_VALUE_PER_LEVEL = 100; // el valor en oro de un ítem es proporcional al nivel, con esta constante de proporcionalidad.

// La relacion entre el CR y el nivel es: nivel = CR^(5/4) <=> CR = nivel^(4/5). Ver IPS_levelToCr(..)
// El CR de un ítem se usa como base para determinar el DC para identificarlo, y para las tiradas de salvación de los ítems malditos.
// En la generación de tesoros los ítems generados son de calidad tal que la esperanza del CR del ítem genrado sea igual al CR del encuentro.
// O sea que, la esperanza del valor de un item dropeado por un encuentro de CR X sera: nivel*IPS_ITEM_VALUE_PER_LEVEL = X^(6/5)*IPS_ITEM_VALUE_PER_LEVEL.
// Matematicamente: sea V(cr) la variable aleatoria que da el valor del item cuando el nivel de dificultad del encuentro es 'cr', y sea dp(cr,v) la distribucion de probabilidad de V(cr), el máximo de dp(cr,v) y la esperanza de V(cr) coinciden en 'v == cr*IPS_ITEM_VALUE_PER_LEVEL/IPS_ITEM_CR_LEVEL_RATIO'.
const float IPS_ITEM_CR_TO_LEVEL_EXPONENT = 1.25;
const float IPS_ITEM_LEVEL_TO_CR_EXPONENT = 0.8; // = 1/IPS_ITEM_CR_TO_LEVEL_EXPONENT

// Divisores del valor en oro de las armas lanzables y las municiones
const int IPS_AMMO_VALUE_DIVISOR = 2500;

// Determina la calidad de los items adeptos al IPS.
const float IPS_ITEM_QUALITY_PER_LEVEL = 1.4; // estaba en 0.8 y se subió a 1.4 cuando se incrementó el exponente de

const string IPS_ITEM_TAG_PREFIX = "IPS0";
const int    IPS_ITEM_TAG_PREFIX_WIDTH = 4;
const int    IPS_ITEM_TAG_GOLD_VALUE_OFFSET = 4;
const int    IPS_ITEM_TAG_GOLD_VALUE_WIDTH = 2;
const int    IPS_ITEM_TAG_FLAGS_OFFSET = 6; // aun no es usando. Reservado para el futuro
const int    IPS_ITEM_TAG_FLAGS_WIDTH = 2;
const int    IPS_ITEM_TAG_PROPERTIES_OFFSET = 8;

const string IPS_PACKET_NAME_PREFIX = "paquete con ";
const int IPS_PACKET_NAME_PREFIX_LENGTH = 12; // = GetStringLength( IPS_PACKET_NAME_PREFIX )

const int IPS_ITEM_FLAG_IS_CURSED = 1;

const string IPS_FLEETING_ITEM_RESREF = "ips_fleeting"; // item fugaz creado y destruido en el inventorio de los PJs al entrar y salir de una tienda para que se actualice el peso. Esta acción es un workarround del bug gracias al cual no se actualiza el peso de un PJ cuando se cambia el tamanio de una pila de objetos apilables.

const string Tesoro_ITEM_TAG = "Drop"; // viejo tag del viejo sistema generador de ítems



////////////////////////////////////////////////////////////////////////////////
////////////////////////// Miscelaneos /////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

// funcion publica
// El grado de calidad de un item es funcion de su valor monetario.
// La calidad se mide en feature points.
// Esta funcion traduce de nivel a grado de calidad.
float IPS_levelToQuality( float level );
float IPS_levelToQuality( float level ) {
    return pow( IPS_ITEM_QUALITY_PER_LEVEL*level, 0.75 );
}

// funcion publica
// El grado de calidad de un item es funcion de su nivel.
// La calidad se mide en feature points.
// Esta funcion traduce de grado de calidad a nivel.
float IPS_qualityToLevel( float quality );
float IPS_qualityToLevel( float quality ) {
    return pow( quality, 1.3333333 )/IPS_ITEM_QUALITY_PER_LEVEL;
}

// funcion publica
// Da el nivel de ítem resultante de sumar la calidad 'quality' al nivel de ítem 'level'.
// Sirve para averiguar a que nivel pasaría el ítem si se le agregaran/quitaran los feature points recibidos en 'quality'.
float IPS_addQualityToALevel( float level, float quality );
float IPS_addQualityToALevel( float level, float quality ) {
    return IPS_qualityToLevel( IPS_levelToQuality( level ) + quality );
}

// funcion publica
// El CR de un ítem es funcion de su nivel
// Esta función traduce de nivel a CR
float IPS_levelToCr( float itemLevel );
float IPS_levelToCr( float itemLevel ) {
    return pow( itemLevel, IPS_ITEM_LEVEL_TO_CR_EXPONENT );
}

// funcion publica
// El CR de un ítem es funcion de su nivel
// Esta función traduce de CR al nivel
float IPS_crToLevel( float itemCr );
float IPS_crToLevel( float itemCr ) {
    return pow( itemCr, IPS_ITEM_CR_TO_LEVEL_EXPONENT );
}


////////////////////////////////////////////////////////////////////////////////
///////////////////////////////// Item /////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

// funcion publica
// Da TRUE si 'item' es adepto al IPS
int IPS_Item_getIsAdept( object item );
int IPS_Item_getIsAdept( object item ) {
    return GetStringLeft( GetTag(item), IPS_ITEM_TAG_PREFIX_WIDTH ) == IPS_ITEM_TAG_PREFIX;
}

// Da TRUE si 'item' es un paquete de municiones
// Se asume que 'item' es adepto al IPS
int IPS_Item_getIsAmmoPacket( object item );
int IPS_Item_getIsAmmoPacket( object item ) {
    return GetStringRight( GetName(item), IPS_PACKET_NAME_PREFIX_LENGTH ) == IPS_PACKET_NAME_PREFIX;
}

// funcion publica
// Da la cantidad de municiones que contiene el 'packet'.
// Se asume que 'packet' es un paquete de municiones adepto al IPS.
int IPS_Item_getAmmoPacketStackSize( object packet );
int IPS_Item_getAmmoPacketStackSize( object packet ) {
    return StringToInt( GetSubString( GetName(packet), IPS_PACKET_NAME_PREFIX_LENGTH, 2 ) );
}


// Da los flags del ítem.
// Advertencia: Se asume que 'item' es adepto al IPS.
int IPS_Item_getFlags( object item );
int IPS_Item_getFlags( object item ) {
    return B62_toInt( GetSubString( GetTag(item), IPS_ITEM_TAG_FLAGS_OFFSET, IPS_ITEM_TAG_FLAGS_WIDTH ) );
}

// funcion privada
// Da 31 veces el nivel del item
// Para un mismo tipo de item, el nivel es proporcional al precio.
int IPS_Item_getLevelx31( object item ) {
    return B62_toInt( GetSubString( GetTag(item), IPS_ITEM_TAG_GOLD_VALUE_OFFSET, IPS_ITEM_TAG_GOLD_VALUE_WIDTH ) );
}

// funcion publica
// Da el nivel del item.
// Para un mismo tipo de item, el nivel es proporcional al precio.
float IPS_Item_getLevel( object item );
float IPS_Item_getLevel( object item ) {
    return IPS_Item_getLevelx31( item )/31.0;
}

// funcion publica
// Da el CR del item usado para identificar, y tiradas de salvacion para items malditos
float IPS_Item_getCr( object item );
float IPS_Item_getCr( object item ) {
    return pow( IPS_Item_getLevelx31(item)/31.0, IPS_ITEM_LEVEL_TO_CR_EXPONENT );
}


// funcion privada
// Convierte de nivel a valor en oro. El nivel debe estar multiplicado por 31
// Se asume que el item es adepto al IPS
int IPS_Item_levelx31ToGenuineGoldValue( object item, int levelx31 ) {
    int genuineValue;
    if( Item_getIsAmmo( item ) ) {
        int ammoAmount;
        if( GetStringLeft( GetName(item), IPS_PACKET_NAME_PREFIX_LENGTH ) == IPS_PACKET_NAME_PREFIX )
            ammoAmount = IPS_Item_getAmmoPacketStackSize( item );
        else
            ammoAmount = GetItemStackSize( item );
        genuineValue = ( levelx31 * IPS_ITEM_VALUE_PER_LEVEL * ammoAmount ) / ( 31 * IPS_AMMO_VALUE_DIVISOR );
    }
    else
        genuineValue = ( levelx31 * IPS_ITEM_VALUE_PER_LEVEL ) / 31;
    return genuineValue;
}

// funcion publica
// Da el valor en oro del item. Este valor esta guardado en el tag del item, y fue establecido durante la creacion del item.
// Se asume que el item es adepto al IPS
// Si 'item' es una pila de items apilables, da el valor de uno de ellos.
int IPS_Item_getGenuineGoldValue( object item );
int IPS_Item_getGenuineGoldValue( object item ) {
    return IPS_Item_levelx31ToGenuineGoldValue( item, IPS_Item_getLevelx31( item ) );
}


// funcion publica
// Obtiene el valor aparente del item, el cual depende del appraise del sujeto que
// lo inspecione.
// Se asume que el item es adepto al IPS
// Si 'item' es una pila de items apilables, da el valor de uno de ellos.
int IPS_Item_getApparentGoldValue( object item, object inspector );
int IPS_Item_getApparentGoldValue( object item, object inspector ) {
    int levelx31 = IPS_Item_getLevelx31( item );
    int precioGenuino = IPS_Item_levelx31ToGenuineGoldValue( item, levelx31 );
    float relacion = IntToFloat( GetSkillRank( SKILL_APPRAISE, inspector )*31 + 155 ) / IntToFloat( levelx31 + 155 );  // = (appraise+5)/(level+5)
    return relacion >= 1.0 ? precioGenuino : FloatToInt( IntToFloat(precioGenuino) * pow( relacion, 0.666667 ) );
}

// Le pone al item el valor en oro que le corresponde segun su calidad.
// Si 'inspector' es OBJECT_INVALID le pone el valor genuino, sino le pone el valor
// aparente visto por 'inspector'.
// Se asume que el item es adepto al IPS
// ADVERTENCIA: esta operacion no es instantanea
void IPS_Item_adjustGoldValue( object item, object inspector=OBJECT_INVALID );
void IPS_Item_adjustGoldValue( object item, object inspector=OBJECT_INVALID ) {
    if( inspector == OBJECT_INVALID )
        Item_setGoldValue( item, IPS_Item_getGenuineGoldValue( item ) );
    else
        Item_setGoldValue( item, IPS_Item_getApparentGoldValue( item, inspector ) );
}



////////////////////////////////////////////////////////////////////////////////
////////////////////////////// Subject /////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

// Quita de todos los items equipados por 'subject', las propiedades que sean del tipo especificado.
// Esta funcion es llamada cuando se equipa un item con alguna propiedad no apilable que tenga un bonus alineal (por ejemplo: DamageInmunity).
// Nota: los items que no son parte de este sistema (IPS), no son afectados.
void IPS_Subject_removePropertyOfAllEquipedItems( object subject, int propertyPrimaryType, int propertySecundaryType );
void IPS_Subject_removePropertyOfAllEquipedItems( object subject, int propertyPrimaryType, int propertySecundaryType ) {
    int slotIdIterator = NUM_INVENTORY_SLOTS;
    while( --slotIdIterator >= 0 ) {
        object item = GetItemInSlot( slotIdIterator, subject );
        if(
            GetIsObjectValid( item )
            && IPS_Item_getIsAdept( item )
        )
            Item_removeProperty( item, propertyPrimaryType, propertySecundaryType );
    }
}


