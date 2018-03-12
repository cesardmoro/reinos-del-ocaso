/*********************************** Item **************************************
Autor: Inquisidor
Descripcion: Funciones varias que aplican a un item
*******************************************************************************/

#include "prc_ipfeat_const"
#include "inc_item_props"
#include "rdo_const_skill"

/////////////////////////////////// SetGoldValue - BEGIN ///////////////////////////////

const int CR_MODIFIER_Digit0_SUB = 571; //  debe valer -1/100*2^0  = -0.01
const int CR_MODIFIER_Digit0_ADD = 572; //  debe valer +1/100*2^0  = +0.01
const int CR_MODIFIER_Digit1_SUB = 573; //  debe valer -1/100*2^1  = -0.02
const int CR_MODIFIER_Digit1_ADD = 574; //  debe valer +1/100*2^1  = +0.02
const int CR_MODIFIER_Digit2_SUB = 575; //  debe valer -1/100*2^2  = -0.04
const int CR_MODIFIER_Digit2_ADD = 576; //  debe valer +1/100*2^2  = +0.04
const int CR_MODIFIER_Digit9_SUB = 590; //  debe valer -1/100*2^9  = -5.12
const int CR_MODIFIER_Digit9_ADD = 591; //  debe valer +1/100*2^9  = +5.12
const int CR_MODIFIER_Digit10_SUB = 592; // debe valer -1/100*2^10 = -10.24
const int CR_MODIFIER_Digit10_ADD = 593; // debe valer +1/100*2^10 = +10.24
const int CR_MODIFIER_Digit11_SUB = 594; // debe valer -1/100*2^11 = -20.48
const int CR_MODIFIER_Digit11_ADD = 595; // debe valer +1/100*2^11 = +20.48
const int CR_MODIFIER_NUM_DIGITS = 12; // del 0 al 11


// funcion privada usada por Item_setGoldValue(..)
// El CR de un item lo dan las propiedades que tiene. Cada propiedad tiene un
// costo que se obtiene de los 2da. El CR del item es la suma de los costos
// de cada propiedad que tiene el item.
// Esta funcion averigua el CR del item a partir del precio del item
// correspondiente a las propiedades y del multiplicador de costo del item.
// El parametro 'goldValue' debe ser el obtenido usando GetGoldPieceValue()
// menos el valor del item base.
// El parametro 'multiplier' es una propiedad del item que se obtiene del 2da.
// Este permite que la misma propiedad cueste distinto según en que item base esté.
float Item_goldValueToCr( int goldValue, float multiplier ) {
    return pow( IntToFloat(goldValue)/(1000.0*multiplier), 0.5 );
}

// funcion privada usada por Item_setGoldValue(..)
// El CR de un item lo dan las propiedades que tiene. Cada propiedad tiene un
// costo que se obtiene de los 2da. El CR del item es la suma de los costos
// de cada propiedad que tiene el item.
// Esta funcion averigua el presio del item correspondiente a las propiedades,
// a partir del CR y el multtiplicador de costo del item.
// correspondiente a las propiedades.
// El parametro 'multiplier' es una propiedad del item que se obtiene del 2da.
// Este permite que la misma propiedad cueste distinto según en que item base esté.
int Item_crToGoldValue( float cr, float multiplier );
int Item_crToGoldValue( float cr, float multiplier ) {
    return FloatToInt( 1000.0 * multiplier * cr * cr );
}


// Conjunto de datos concernientes al precio de un item, que averigua la funcion
// Item_getValueAttributes(..)
struct Item_ValueAttributes {
    int totalGoldValue;
    int baseGoldValue;
    float valueMultiplier;
    float cr;
};

// funcion privada usada por Item_setGoldValue(..)
// Da los atributos de los que depende el valor en oro del item.
// Nota: el cr dado es incorrecto si el item tiene conbina propiedades que suman valor y propiedades que restan valor.
// Esto se debe a que en realidad son dos CR. El correspondiente a las propiedades que suman valor, y el
// correspondiente a las propiedades que restan valor.
struct Item_ValueAttributes Item_getValueAttributes( object item );
struct Item_ValueAttributes Item_getValueAttributes( object item ) {
    struct Item_ValueAttributes valueAttributes;
    valueAttributes.totalGoldValue = GetGoldPieceValue(item)/GetItemStackSize(item);
    int baseType = GetBaseItemType( item );
    valueAttributes.valueMultiplier = StringToFloat( Get2DAString( "baseitems", "ItemMultiplier", baseType ) );
    if( baseType == BASE_ITEM_ARMOR ) {
        int bIdentified = GetIdentified(item);
        SetIdentified(item,FALSE);
        valueAttributes.baseGoldValue = GetGoldPieceValue(item);
        SetIdentified(item,bIdentified);
    }
    else
        valueAttributes.baseGoldValue = FloatToInt( StringToFloat( Get2DAString( "baseitems", "BaseCost", baseType ) )*valueAttributes.valueMultiplier );
    valueAttributes.cr = Item_goldValueToCr( valueAttributes.totalGoldValue - valueAttributes.baseGoldValue, valueAttributes.valueMultiplier );
    return valueAttributes;
}


// Quita todas las propiedades modificadoras de precio agregadas por 'Item_setGoldValue(..)'
// Se la utiliza para quitar las propiedades modificadoras de precio cuando no es posible
// vender el item, por las dudas consuman recursos de procesador. Quien haga esto, deberá
// responsabilizarse de llamar a 'Item_setGoldValue(..)' cuando sea posible vender el item.
// Recordar que cuando se trata de un item adepto al IPS, el CIB usa el precio dado por
// IPS (ignora el valor dado en oro dado por el motor).
void Item_removeCrModifiers( object item );
void Item_removeCrModifiers( object item ) {
    itemproperty itemPropertyIterator = GetFirstItemProperty(item);
    while( GetIsItemPropertyValid( itemPropertyIterator ) ) {
        if(
            GetItemPropertyType( itemPropertyIterator ) == ITEM_PROPERTY_BONUS_FEAT
            && CR_MODIFIER_Digit0_SUB <= GetItemPropertySubType( itemPropertyIterator )
            && GetItemPropertySubType( itemPropertyIterator ) < CR_MODIFIER_Digit0_SUB + 2*CR_MODIFIER_NUM_DIGITS
        ) {
            RemoveItemProperty( item, itemPropertyIterator );
        }
        itemPropertyIterator = GetNextItemProperty(item);
    }
}


// funcion privada usada por Item_setGoldValue(..)
void Item_setGoldValue_step3() {
//    SendMessageToPC( GetFirstPC(), "Item_setGoldValue: setValue="+IntToString( GetGoldPieceValue( OBJECT_SELF ) ) );
}

// funcion privada usada por Item_setGoldValue(..)
void Item_setGoldValue_step2( int desiredGoldValue ) {
    struct Item_ValueAttributes valueAttributes = Item_getValueAttributes( OBJECT_SELF );
//    SendMessageToPC( GetFirstPC(), "Item_setGoldValue: total="+IntToString( valueAttributes.totalGoldValue )+", base="+IntToString( valueAttributes.baseGoldValue )+", cr="+FloatToString( valueAttributes.cr )+", multiplier="+FloatToString( valueAttributes.valueMultiplier ) );
    int crModifierDigitPtr;
    float crChange;
    if( desiredGoldValue > valueAttributes.totalGoldValue ) {
        float desiredCr = Item_goldValueToCr( desiredGoldValue - valueAttributes.baseGoldValue, valueAttributes.valueMultiplier );
        crChange = desiredCr - valueAttributes.cr;
        crModifierDigitPtr = CR_MODIFIER_Digit0_ADD;
//        SendMessageToPC( GetFirstPC(), "Item_setGoldValue: desiredCr="+FloatToString(desiredCr) );
    }
    else if( desiredGoldValue < valueAttributes.totalGoldValue ) {
        crChange = Item_goldValueToCr( valueAttributes.totalGoldValue - desiredGoldValue, valueAttributes.valueMultiplier );
        crModifierDigitPtr = CR_MODIFIER_Digit0_SUB;
    }

//    string borrame;
    int transformedCrChange = FloatToInt( 100.0*( crChange ) + 0.5 );
//    SendMessageToPC( GetFirstPC(), "Item_setGoldValue: crChange="+FloatToString(crChange)+", transformedCrChange="+IntToString(transformedCrChange)  );
    while( transformedCrChange != 0 ) {
        int binaryDigitValue = transformedCrChange % 2;
//        borrame = IntToString( binaryDigitValue ) + borrame;
        if( binaryDigitValue == 1 )
            AddItemProperty( DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat( crModifierDigitPtr ), OBJECT_SELF );
        crModifierDigitPtr += 2;
        transformedCrChange /= 2;
    }

//    SendMessageToPC( GetFirstPC(), "Item_setGoldValue: binaryDigitValue="+borrame );
//    AssignCommand( OBJECT_SELF, Item_setGoldValue_step3() );
}

// Hace que el valor en oro del 'item' sea el especificado por 'desiredGoldValue'.
// Nota: El valor del item cambiara recien despues de ejecutarse el script.
void Item_setGoldValue( object item, int desiredGoldValue );
void Item_setGoldValue( object item, int desiredGoldValue ) {
//    SendMessageToPC( GetFirstPC(), "Item_setGoldValue: desiredValue="+IntToString(desiredGoldValue)+", initialValue="+IntToString( GetGoldPieceValue( OBJECT_SELF ) ) );
    Item_removeCrModifiers( item );
    AssignCommand( item, Item_setGoldValue_step2( desiredGoldValue ) ); // este AssignCommand es necesario para que hagan efecto los cambos en el item hechos por 'Item_removeCrModifiers(...)'. Recordar que los cambios en las propiedades de un item hacen efecto cuanto termina de ejecutarse el script.
}

/////////////////////////////////// SetGoldValue - END //////////////////////////////////////////////////////////


// Da TRUE si el 'item' recibido tiene alguna propiedad permanente
int Item_tieneItemAlgunaPropiedadPermanente( object item );
int Item_tieneItemAlgunaPropiedadPermanente( object item ) {
    itemproperty propertyIterator = GetFirstItemProperty( item );
    while( GetIsItemPropertyValid( propertyIterator ) ) {
        if( GetItemPropertyDurationType( propertyIterator ) == DURATION_TYPE_PERMANENT )
            return TRUE;
        propertyIterator = GetNextItemProperty( item );
    }
    return FALSE;
}


// Quita de 'item' las propiedades cuyo tipo primario sea 'propertyPrimaryType' y su tipo secundario sea 'propertySecundaryType'.
// Da la cantidad de propiedades que quitó.
// Se usa generalmente para quitar una propiedad dado que, si no me equivoco, es en vano que un item tenga dos propieades del mismo tipo y subtipo.
int Item_removeProperty( object item, int propertyPrimaryType, int propertySecundaryType=-1 );
int Item_removeProperty( object item, int propertyPrimaryType, int propertySecundaryType=-1 ) {
//    SendMessageToPC( GetFirstPC(), "Item_removeProperty: propertyPrimaryType="+IntToString(propertyPrimaryType)+", propertySecundaryType="+IntToString( propertySecundaryType ) );
    int removedPropertiesCounter = 0;
    itemproperty itemPropertyIterator = GetFirstItemProperty(item);
    while( GetIsItemPropertyValid( itemPropertyIterator ) ) {
//        SendMessageToPC( GetFirstPC(), "Item_removeProperty: Type="+IntToString(GetItemPropertyType( itemPropertyIterator ))+", subType="+IntToString(GetItemPropertySubType( itemPropertyIterator )) );
        if( GetItemPropertyType( itemPropertyIterator ) == propertyPrimaryType
            && ( propertySecundaryType == -1 || GetItemPropertySubType( itemPropertyIterator ) == propertySecundaryType )
        ) {
            RemoveItemProperty( item, itemPropertyIterator );
            removedPropertiesCounter += 1;
        }
        itemPropertyIterator = GetNextItemProperty(item);
    }
    return removedPropertiesCounter;
}


int Item_hasProperty( object item, int propertyPrimaryType, int propertySecundaryType=-1 );
int Item_hasProperty( object item, int propertyPrimaryType, int propertySecundaryType=-1 ) {
//    SendMessageToPC( GetFirstPC(), "Item_removeProperty: propertyPrimaryType="+IntToString(propertyPrimaryType)+", propertySecundaryType="+IntToString( propertySecundaryType ) );
    itemproperty itemPropertyIterator = GetFirstItemProperty(item);
    while( GetIsItemPropertyValid( itemPropertyIterator ) ) {
//        SendMessageToPC( GetFirstPC(), "Item_removeProperty: Type="+IntToString(GetItemPropertyType( itemPropertyIterator ))+", subType="+IntToString(GetItemPropertySubType( itemPropertyIterator )) );
        if( GetItemPropertyType( itemPropertyIterator ) == propertyPrimaryType
            && ( propertySecundaryType == -1 || GetItemPropertySubType( itemPropertyIterator ) == propertySecundaryType )
        )
            return TRUE;

        itemPropertyIterator = GetNextItemProperty(item);
    }
    return FALSE;
}

// da el Id del slot donde este equipado el 'item' portado por 'subject'.
// De no estar equipado por subject, da -1;
int Item_getEquipedSlotId( object item, object subject );
int Item_getEquipedSlotId( object item, object subject ) {
    int slotIdIterator = NUM_INVENTORY_SLOTS;
    while( --slotIdIterator >= 0 ) {
        if( item == GetItemInSlot( slotIdIterator, subject ) )
            return slotIdIterator;
    }
    return -1;
}


const string Item_burladorTirar_VN = "ItemBt";

// funcion privada usada solo por 'Item_tirar(..)'
void Item_tirar_step2( object item, effect immovilization, string cheatHandler ) {
    object itemPossessor = GetItemPossessor( item );
    if( GetIsObjectValid( item ) && itemPossessor == OBJECT_SELF ) {
        ClearAllActions();
        ActionPutDownItem( item );
        DelayCommand( 1.0, Item_tirar_step2( item, immovilization, cheatHandler ) );
    }
    else {
        RemoveEffect( OBJECT_SELF, immovilization );
        // si el ítem fue a parar a la ventana de trade, o esta dentro de un item contenedor
        if( itemPossessor == OBJECT_INVALID && GetArea(item) == OBJECT_INVALID && GetIsObjectValid( item ) ) {
            SetLocalObject( OBJECT_SELF, Item_burladorTirar_VN, item );
            ExecuteScript( cheatHandler, OBJECT_SELF  );
        }
    }
}

// Es como el ActionPutDownItem(..) pero inomviliza momentaneamente a 'possessor' para forzar que la acción se complete.
// Si 'possessor' no es poseedor de 'item', nada sucede.
// Si al intentar tirar el 'item' éste termina en la ventana de trueque en lugar de algún área, el script 'cheatHandler' es ejecutado con OBJECT_SELF=possessor, y la variable local 'Item_burladorTirar_VN' con 'item'.
void Item_tirar( object item, object possessor, string cheatHandler="" );
void Item_tirar( object item, object possessor, string cheatHandler="" ) {
    effect immovilizaton = EffectCutsceneImmobilize();
    ApplyEffectToObject( DURATION_TYPE_PERMANENT, immovilizaton, possessor );
    AssignCommand( possessor, Item_tirar_step2( item, immovilizaton, cheatHandler ) );
}




////////////////////////////////////////////////////////////////////////////////
//////////////////////// Desglosadores /////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

// Da TRUE si 'item' es munición. Sea arrojada con la mano o mediante un dispositivo.
int Item_getIsAmmo( object item );
int Item_getIsAmmo( object item ) {
    switch( GetBaseItemType( item ) ) {
    case BASE_ITEM_ARROW:
    case BASE_ITEM_BOLT:
    case BASE_ITEM_BULLET:
    case BASE_ITEM_DART:
    case BASE_ITEM_SHURIKEN:
    case BASE_ITEM_THROWINGAXE:
        return TRUE;
    }
    return FALSE;
}

// Devuelve si el objeto 'item' es un arma cuerpo a cuerpo o no
// Cabe señalar que ya existe un script asi en x2_inc_itemprop
int Item_GetIsMeleeWeapon( object item );
int Item_GetIsMeleeWeapon(object item)
{
    switch (GetBaseItemType(item)) {
        case BASE_ITEM_BASTARDSWORD:
        case BASE_ITEM_BATTLEAXE:
        case BASE_ITEM_CLUB:
        case BASE_ITEM_DAGGER:
        case BASE_ITEM_DIREMACE:
        case BASE_ITEM_DOUBLEAXE:
        case BASE_ITEM_DWARVENWARAXE:
        case BASE_ITEM_HALBERD:
        case BASE_ITEM_GREATSWORD:
        case BASE_ITEM_GREATAXE:
        case BASE_ITEM_HANDAXE:
        case BASE_ITEM_HEAVYFLAIL:
        case BASE_ITEM_KAMA:
        case BASE_ITEM_KATANA:
        case BASE_ITEM_KUKRI:
        case BASE_ITEM_LIGHTFLAIL:
        case BASE_ITEM_LIGHTHAMMER:
        case BASE_ITEM_LIGHTMACE:
        case BASE_ITEM_LONGSWORD:
        case BASE_ITEM_QUARTERSTAFF:
        case BASE_ITEM_MORNINGSTAR:
        case BASE_ITEM_RAPIER:
        case BASE_ITEM_SCIMITAR:
        case BASE_ITEM_SHORTSPEAR:
        case BASE_ITEM_SHORTSWORD:
        case BASE_ITEM_SICKLE:
        case BASE_ITEM_TWOBLADEDSWORD:
        case BASE_ITEM_WARHAMMER:
        case BASE_ITEM_WHIP:
            return TRUE;
    }
    return FALSE;
}


// Devuelve si el objeto 'item' es un arma de distancia o no
// Cabe señalar que existe una funcion igual en x2_inc_itemprop llamada IPGetIsRangedWeapon()
int Item_GetIsRangedWeapon( object item );
int Item_GetIsRangedWeapon(object item)
{
    switch (GetBaseItemType(item)) {
        case BASE_ITEM_LONGBOW:
        case BASE_ITEM_SHORTBOW:
        case BASE_ITEM_SHURIKEN:
        case BASE_ITEM_SLING:
        case BASE_ITEM_THROWINGAXE:
        case BASE_ITEM_LIGHTCROSSBOW:
        case BASE_ITEM_HEAVYCROSSBOW:
        case BASE_ITEM_DART:
            return TRUE;
    }
    return FALSE;
}

// Devuelve TRUE si el 'item' es un arma a 2 manos (a distancia o cuerpo a cuerpo)
int Item_GetIsTwoHandedWeapon( object item );
int Item_GetIsTwoHandedWeapon( object item )
{
    switch (GetBaseItemType(item)) {
        case BASE_ITEM_DIREMACE:
        case BASE_ITEM_DOUBLEAXE:
        case BASE_ITEM_HALBERD:
        case BASE_ITEM_GREATSWORD:
        case BASE_ITEM_GREATAXE:
        case BASE_ITEM_HEAVYFLAIL:
        case BASE_ITEM_QUARTERSTAFF:
        case BASE_ITEM_TWOBLADEDSWORD:
        case BASE_ITEM_LONGBOW:
        case BASE_ITEM_SHORTBOW:
            return TRUE;
    }
    return FALSE;
}


// Devuelve el tipo de danio que hace un arma
int Item_GetWeaponDamageType( object weapon );
int Item_GetWeaponDamageType( object weapon )
{
    int damageType;
    switch (GetBaseItemType(weapon)) {
            case BASE_ITEM_BASTARDSWORD:
            case BASE_ITEM_DOUBLEAXE:
            case BASE_ITEM_DWARVENWARAXE:
            case BASE_ITEM_GREATAXE:
            case BASE_ITEM_GREATSWORD:
            case BASE_ITEM_HALBERD:
            case BASE_ITEM_HANDAXE:
            case BASE_ITEM_BATTLEAXE:
            case BASE_ITEM_KATANA:
            case BASE_ITEM_LONGSWORD:
            case BASE_ITEM_SCIMITAR:
            case BASE_ITEM_SCYTHE:
            case BASE_ITEM_THROWINGAXE:
            case BASE_ITEM_TWOBLADEDSWORD:      damageType = DAMAGE_TYPE_SLASHING; break;
            case BASE_ITEM_DAGGER:
            case BASE_ITEM_DART:
            case BASE_ITEM_HEAVYCROSSBOW:
            case BASE_ITEM_KUKRI:
            case BASE_ITEM_LIGHTCROSSBOW:
            case BASE_ITEM_LONGBOW:
            case BASE_ITEM_RAPIER:
            case BASE_ITEM_SHORTBOW:
            case BASE_ITEM_SHORTSPEAR:
            case BASE_ITEM_SHORTSWORD:
            case BASE_ITEM_SHURIKEN:
            case BASE_ITEM_SICKLE:              damageType = DAMAGE_TYPE_PIERCING; break;
            default:                            damageType = DAMAGE_TYPE_BLUDGEONING;
    }
    return damageType;
}

// Devuelve la constante IP_CONST_BONUS_FEAT_* del bonus feat correspondiente al arma
// En caso de ser una flecha, devuelve IP_CONST_FEAT_IMPROVED_CRITICAL_LONGBOW
// En caso de ser un virote, deuvelve IP_CONST_FEAT_IMPROVED_CRITICAL_HEAVY_CROSSBOW
int Item_GetWeaponImprovedCriticalBonusFeat( object item );
int Item_GetWeaponImprovedCriticalBonusFeat( object item )
{
    int featId;
    switch (GetBaseItemType(item)) {
        case BASE_ITEM_ARROW:                   featId = IP_CONST_FEAT_IMPROVED_CRITICAL_LONGBOW; break;
        case BASE_ITEM_BASTARDSWORD:            featId = IP_CONST_FEAT_IMPROVED_CRITICAL_BASTARD_SWORD; break;
        case BASE_ITEM_BATTLEAXE:               featId = IP_CONST_FEAT_IMPROVED_CRITICAL_BATTLE_AXE; break;
        case BASE_ITEM_BOLT:                    featId = IP_CONST_FEAT_IMPROVED_CRITICAL_HEAVY_CROSSBOW; break;
        case BASE_ITEM_DAGGER:                  featId = IP_CONST_FEAT_IMPROVED_CRITICAL_DAGGER; break;
        case BASE_ITEM_DART:                    featId = IP_CONST_FEAT_IMPROVED_CRITICAL_DART; break;
        case BASE_ITEM_DOUBLEAXE:               featId = IP_CONST_FEAT_IMPROVED_CRITICAL_DOUBLE_AXE; break;
        case BASE_ITEM_DWARVENWARAXE:           featId = IP_CONST_FEAT_IMPROVED_CRITICAL_DWAXE; break;
        case BASE_ITEM_GREATAXE:                featId = IP_CONST_FEAT_IMPROVED_CRITICAL_GREAT_AXE; break;
        case BASE_ITEM_GREATSWORD:              featId = IP_CONST_FEAT_IMPROVED_CRITICAL_GREAT_SWORD; break;
        case BASE_ITEM_HALBERD:                 featId = IP_CONST_FEAT_IMPROVED_CRITICAL_HALBERD; break;
        case BASE_ITEM_HANDAXE:                 featId = IP_CONST_FEAT_IMPROVED_CRITICAL_HAND_AXE; break;
        case BASE_ITEM_KATANA:                  featId = IP_CONST_FEAT_IMPROVED_CRITICAL_KATANA; break;
        case BASE_ITEM_KUKRI:                   featId = IP_CONST_FEAT_IMPROVED_CRITICAL_KUKRI; break;
        case BASE_ITEM_LONGSWORD:               featId = IP_CONST_FEAT_IMPROVED_CRITICAL_LONG_SWORD; break;
        case BASE_ITEM_MORNINGSTAR:             featId = IP_CONST_FEAT_IMPROVED_CRITICAL_MORNING_STAR; break;
        case BASE_ITEM_RAPIER:                  featId = IP_CONST_FEAT_IMPROVED_CRITICAL_RAPIER; break;
        case BASE_ITEM_SCIMITAR:                featId = IP_CONST_FEAT_IMPROVED_CRITICAL_SCIMITAR; break;
        case BASE_ITEM_SCYTHE:                  featId = IP_CONST_FEAT_IMPROVED_CRITICAL_SCYTHE; break;
        case BASE_ITEM_SHORTSWORD:              featId = IP_CONST_FEAT_IMPROVED_CRITICAL_SHORT_SWORD; break;
        case BASE_ITEM_SHURIKEN:                featId = IP_CONST_FEAT_IMPROVED_CRITICAL_SHURIKEN; break;
        case BASE_ITEM_SICKLE:                  featId = IP_CONST_FEAT_IMPROVED_CRITICAL_SICKLE; break;
        case BASE_ITEM_SHORTSPEAR:              featId = IP_CONST_FEAT_IMPROVED_CRITICAL_SPEAR; break;
        case BASE_ITEM_THROWINGAXE:             featId = IP_CONST_FEAT_IMPROVED_CRITICAL_THROWING_AXE; break;
        case BASE_ITEM_TWOBLADEDSWORD:          featId = IP_CONST_FEAT_IMPROVED_CRITICAL_TWO_BLADED_SWORD; break;
        default:                                featId = -1;
    }
    return featId;
}

// Devuelve la dote Weapon Focus correspondiente al arma de tipo base weaponBaseItemType
// Devuelve -1 en caso de error
int Item_GetWeaponFocusFeat( int weaponBaseItemType );
int Item_GetWeaponFocusFeat( int weaponBaseItemType )
{
    int feat;
    switch (weaponBaseItemType) {
        case BASE_ITEM_BASTARDSWORD:            feat = FEAT_WEAPON_FOCUS_BASTARD_SWORD; break;
        case BASE_ITEM_BATTLEAXE:               feat = FEAT_WEAPON_FOCUS_BATTLE_AXE; break;
        case BASE_ITEM_CLUB:                    feat = FEAT_WEAPON_FOCUS_CLUB; break;
        case BASE_ITEM_DAGGER:                  feat = FEAT_WEAPON_FOCUS_DAGGER; break;
        case BASE_ITEM_DART:                    feat = FEAT_WEAPON_FOCUS_DART; break;
        case BASE_ITEM_DIREMACE:                feat = FEAT_WEAPON_FOCUS_DIRE_MACE; break;
        case BASE_ITEM_DOUBLEAXE:               feat = FEAT_WEAPON_FOCUS_DOUBLE_AXE; break;
        case BASE_ITEM_DWARVENWARAXE:           feat = FEAT_WEAPON_FOCUS_DWAXE; break;
        case BASE_ITEM_GREATAXE:                feat = FEAT_WEAPON_FOCUS_GREAT_AXE; break;
        case BASE_ITEM_GREATSWORD:              feat = FEAT_WEAPON_FOCUS_GREAT_SWORD; break;
        case BASE_ITEM_HALBERD:                 feat = FEAT_WEAPON_FOCUS_HALBERD; break;
        case BASE_ITEM_HANDAXE:                 feat = FEAT_WEAPON_FOCUS_HAND_AXE; break;
        case BASE_ITEM_HEAVYCROSSBOW:           feat = FEAT_WEAPON_FOCUS_HEAVY_CROSSBOW; break;
        case BASE_ITEM_HEAVYFLAIL:              feat = FEAT_WEAPON_FOCUS_HEAVY_FLAIL; break;
        case BASE_ITEM_KAMA:                    feat = FEAT_WEAPON_FOCUS_KAMA; break;
        case BASE_ITEM_KATANA:                  feat = FEAT_WEAPON_FOCUS_KATANA; break;
        case BASE_ITEM_KUKRI:                   feat = FEAT_WEAPON_FOCUS_KUKRI; break;
        case BASE_ITEM_LIGHTCROSSBOW:           feat = FEAT_WEAPON_FOCUS_LIGHT_CROSSBOW; break;
        case BASE_ITEM_LIGHTFLAIL:              feat = FEAT_WEAPON_FOCUS_LIGHT_FLAIL; break;
        case BASE_ITEM_LIGHTHAMMER:             feat = FEAT_WEAPON_FOCUS_LIGHT_HAMMER; break;
        case BASE_ITEM_LIGHTMACE:               feat = FEAT_WEAPON_FOCUS_LIGHT_MACE; break;
        case BASE_ITEM_LONGBOW:                 feat = FEAT_WEAPON_FOCUS_LONGBOW; break;
        case BASE_ITEM_LONGSWORD:               feat = FEAT_WEAPON_FOCUS_LONG_SWORD; break;
        case BASE_ITEM_MORNINGSTAR:             feat = FEAT_WEAPON_FOCUS_MORNING_STAR; break;
        case BASE_ITEM_QUARTERSTAFF:            feat = FEAT_WEAPON_FOCUS_STAFF; break;
        case BASE_ITEM_RAPIER:                  feat = FEAT_WEAPON_FOCUS_RAPIER; break;
        case BASE_ITEM_SCIMITAR:                feat = FEAT_WEAPON_FOCUS_SCIMITAR; break;
        case BASE_ITEM_SCYTHE:                  feat = FEAT_WEAPON_FOCUS_SCYTHE; break;
        case BASE_ITEM_SHORTBOW:                feat = FEAT_WEAPON_FOCUS_SHORTBOW; break;
        case BASE_ITEM_SHORTSPEAR:              feat = FEAT_WEAPON_FOCUS_SPEAR; break;
        case BASE_ITEM_SHORTSWORD:              feat = FEAT_WEAPON_FOCUS_SHORT_SWORD; break;
        case BASE_ITEM_SHURIKEN:                feat = FEAT_WEAPON_FOCUS_SHURIKEN; break;
        case BASE_ITEM_SICKLE:                  feat = FEAT_WEAPON_FOCUS_SICKLE; break;
        case BASE_ITEM_SLING:                   feat = FEAT_WEAPON_FOCUS_SLING; break;
        case BASE_ITEM_THROWINGAXE:             feat = FEAT_WEAPON_FOCUS_THROWING_AXE; break;
        case BASE_ITEM_TWOBLADEDSWORD:          feat = FEAT_WEAPON_FOCUS_TWO_BLADED_SWORD; break;
        case BASE_ITEM_WARHAMMER:               feat = FEAT_WEAPON_FOCUS_WAR_HAMMER; break;
        case BASE_ITEM_WHIP:                    feat = FEAT_WEAPON_FOCUS_WHIP; break;
        default:                                feat = -1;
    }
    return feat;
}

// Devuelve la proficiencia necesaria para usar el item
// Solo devuelve SIMPLE, MARTIAL y EXOTIC
// Devuelve -1 en caso de error
int Item_GetWeaponProficiencyNeeded_v1( int weaponBaseItemType );
int Item_GetWeaponProficiencyNeeded_v1( int weaponBaseItemType )
{
    switch (weaponBaseItemType) {
        case BASE_ITEM_CLUB:
        case BASE_ITEM_DAGGER:
        case BASE_ITEM_DART:
        case BASE_ITEM_HANDAXE:
        case BASE_ITEM_HEAVYCROSSBOW:
        case BASE_ITEM_LIGHTCROSSBOW:
        case BASE_ITEM_QUARTERSTAFF:
        case BASE_ITEM_SICKLE:
        case BASE_ITEM_SLING:                   return FEAT_WEAPON_PROFICIENCY_SIMPLE; break;

        case BASE_ITEM_BATTLEAXE:
        case BASE_ITEM_GREATAXE:
        case BASE_ITEM_GREATSWORD:
        case BASE_ITEM_HALBERD:
        case BASE_ITEM_HEAVYFLAIL:
        case BASE_ITEM_LIGHTFLAIL:
        case BASE_ITEM_LIGHTHAMMER:
        case BASE_ITEM_LIGHTMACE:
        case BASE_ITEM_LONGBOW:
        case BASE_ITEM_LONGSWORD:
        case BASE_ITEM_MORNINGSTAR:
        case BASE_ITEM_RAPIER:
        case BASE_ITEM_SCIMITAR:
        case BASE_ITEM_THROWINGAXE:
        case BASE_ITEM_WARHAMMER:               return FEAT_WEAPON_PROFICIENCY_MARTIAL; break;

        case BASE_ITEM_BASTARDSWORD:
        case BASE_ITEM_DIREMACE:
        case BASE_ITEM_DOUBLEAXE:
        case BASE_ITEM_DWARVENWARAXE:
        case BASE_ITEM_KAMA:
        case BASE_ITEM_KATANA:
        case BASE_ITEM_KUKRI:
        case BASE_ITEM_SCYTHE:
        case BASE_ITEM_SHORTBOW:
        case BASE_ITEM_SHORTSPEAR:
        case BASE_ITEM_SHORTSWORD:
        case BASE_ITEM_SHURIKEN:
        case BASE_ITEM_TWOBLADEDSWORD:
        case BASE_ITEM_WHIP:                    return FEAT_WEAPON_PROFICIENCY_EXOTIC; break;
    }
    return -1;
}

int isNotShield(object oItem)
{
     int isNotAShield = 1;

     if(GetBaseItemType(oItem) == BASE_ITEM_LARGESHIELD)       isNotAShield == 0;
     else if (GetBaseItemType(oItem) == BASE_ITEM_TOWERSHIELD) isNotAShield == 0;
     else if (GetBaseItemType(oItem) == BASE_ITEM_SMALLSHIELD) isNotAShield == 0;

     return isNotAShield;
}

// Devuelve el Check Penalty de una armadura
// Si no es armadura, devuelve 0
int Item_GetArmorCheckPenalty( object oArmor );
int Item_GetArmorCheckPenalty( object oArmor )
{
    int checkPenalty;
    switch (GetBaseAC(oArmor)) {
        case 3:     checkPenalty = SKILL_CHECK_PENALTY_STUDDED_ARMOR; break;
        case 4:     checkPenalty = SKILL_CHECK_PENALTY_CHAINSHIRT_ARMOR; break;
        case 5:     checkPenalty = SKILL_CHECK_PENALTY_BREASTPLATE_ARMOR; break;
        case 6:     checkPenalty = SKILL_CHECK_PENALTY_SPLINTMAIL_ARMOR; break;
        case 7:     checkPenalty = SKILL_CHECK_PENALTY_HALFPLATE_ARMOR; break;
        case 8:     checkPenalty = SKILL_CHECK_PENALTY_FULLPLATE_ARMOR; break;
    }
    return checkPenalty;
}




////////////////////////////////////////////////////////////////////////////////
//////////////////////////////// apariencia ////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

struct Item_ArmorAppearance {
    int neck;
    int torso;
    int belt;
    int pelvis;
    int rShoulder;
    int lShoulder;
    int rBicep;
    int lBicep;
    int rForearm;
    int lForearm;
    int rHand;
    int lHand;
    int rThigh;
    int lThigh;
    int rShin;
    int lShin;
    int rFoot;
    int lFoot;
    int robe;
    int colorCloth1;
    int colorCloth2;
    int colorLeather1;
    int colorLeather2;
    int colorMetal1;
    int colorMetal2;
};

struct Item_ArmorAppearance Item_getArmorAppearance( object item );
struct Item_ArmorAppearance Item_getArmorAppearance( object item ) {
    struct Item_ArmorAppearance aa;

    aa.neck =       GetItemAppearance( item, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_NECK );
    aa.torso =      GetItemAppearance( item, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_TORSO );
    aa.belt =       GetItemAppearance( item, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_BELT );
    aa.pelvis =     GetItemAppearance( item, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_PELVIS );
    aa.rShoulder =  GetItemAppearance( item, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RSHOULDER );
    aa.lShoulder =  GetItemAppearance( item, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LSHOULDER );
    aa.rBicep =     GetItemAppearance( item, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RBICEP );
    aa.lBicep =     GetItemAppearance( item, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LBICEP );
    aa.rForearm =   GetItemAppearance( item, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RFOREARM );
    aa.lForearm =   GetItemAppearance( item, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LFOREARM );
    aa.rHand =      GetItemAppearance( item, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RHAND );
    aa.lHand =      GetItemAppearance( item, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LHAND );
    aa.rThigh =     GetItemAppearance( item, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RTHIGH );
    aa.lThigh =     GetItemAppearance( item, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LTHIGH );
    aa.rShin =      GetItemAppearance( item, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RSHIN );
    aa.lShin =      GetItemAppearance( item, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LSHIN );
    aa.rFoot =      GetItemAppearance( item, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RFOOT );
    aa.lFoot =      GetItemAppearance( item, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LFOOT );
    aa.robe =       GetItemAppearance( item, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_ROBE );

    aa.colorCloth1 =    GetItemAppearance( item, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_CLOTH1 );
    aa.colorCloth2 =    GetItemAppearance( item, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_CLOTH2 );
    aa.colorLeather1 =  GetItemAppearance( item, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_LEATHER1 );
    aa.colorLeather2 =  GetItemAppearance( item, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_LEATHER2 );
    aa.colorMetal1 =    GetItemAppearance( item, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_METAL1 );
    aa.colorMetal2 =    GetItemAppearance( item, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_METAL2 );

    return aa;
}

object Item_applyAppearanceToArmor( object item, struct Item_ArmorAppearance daa );
object Item_applyAppearanceToArmor( object item, struct Item_ArmorAppearance daa ) {
    int currentModel;

    currentModel =  GetItemAppearance( item, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_NECK );
    if( daa.neck != currentModel ) {
        DestroyObject( item );
        item =      CopyItemAndModify( item, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_NECK,    daa.neck,    TRUE );
    }

    currentModel =  GetItemAppearance( item, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_TORSO );
    if( daa.torso != currentModel ) {
        DestroyObject( item );
        item =      CopyItemAndModify( item, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_TORSO,    daa.torso,    TRUE );
    }

    currentModel =  GetItemAppearance( item, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_BELT );
    if( daa.belt != currentModel ) {
        DestroyObject( item );
        item =      CopyItemAndModify( item, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_BELT,    daa.belt,    TRUE );
    }

    currentModel =  GetItemAppearance( item, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_PELVIS );
    if( daa.pelvis != currentModel ) {
        DestroyObject( item );
        item =      CopyItemAndModify( item, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_PELVIS,    daa.pelvis,    TRUE );
    }

    currentModel =  GetItemAppearance( item, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RSHOULDER );
    if( daa.rShoulder != currentModel ) {
        DestroyObject( item );
        item =      CopyItemAndModify( item, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RSHOULDER,    daa.rShoulder,    TRUE );
    }

    currentModel =  GetItemAppearance( item, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LSHOULDER );
    if( daa.lShoulder != currentModel ) {
        DestroyObject( item );
        item =      CopyItemAndModify( item, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LSHOULDER,    daa.lShoulder,    TRUE );
    }

    currentModel =  GetItemAppearance( item, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RBICEP );
    if( daa.rBicep != currentModel ) {
        DestroyObject( item );
        item =      CopyItemAndModify( item, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RBICEP,    daa.rBicep,    TRUE );
    }

    currentModel =  GetItemAppearance( item, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LBICEP );
    if( daa.lBicep != currentModel ) {
        DestroyObject( item );
        item =      CopyItemAndModify( item, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LBICEP,    daa.lBicep,    TRUE );
    }

    currentModel =  GetItemAppearance( item, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RFOREARM );
    if( daa.rForearm != currentModel ) {
        DestroyObject( item );
        item =      CopyItemAndModify( item, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RFOREARM,    daa.rForearm,    TRUE );
    }

    currentModel =  GetItemAppearance( item, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LFOREARM );
    if( daa.lForearm != currentModel ) {
        DestroyObject( item );
        item =      CopyItemAndModify( item, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LFOREARM,    daa.lForearm,    TRUE );
    }

    currentModel =  GetItemAppearance( item, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RHAND );
    if( daa.rHand != currentModel ) {
        DestroyObject( item );
        item =      CopyItemAndModify( item, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RHAND,    daa.rHand,    TRUE );
    }

    currentModel =  GetItemAppearance( item, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LHAND );
    if( daa.lHand != currentModel ) {
        DestroyObject( item );
        item =      CopyItemAndModify( item, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LHAND,    daa.lHand,    TRUE );
    }

    currentModel =  GetItemAppearance( item, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RTHIGH );
    if( daa.rThigh != currentModel ) {
        DestroyObject( item );
        item =      CopyItemAndModify( item, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RTHIGH,    daa.rThigh,    TRUE );
    }

    currentModel =  GetItemAppearance( item, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LTHIGH );
    if( daa.lThigh != currentModel ) {
        DestroyObject( item );
        item =      CopyItemAndModify( item, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LTHIGH,    daa.lThigh,    TRUE );
    }

    currentModel =  GetItemAppearance( item, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RSHIN );
    if( daa.rShin != currentModel ) {
        DestroyObject( item );
        item =      CopyItemAndModify( item, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RSHIN,    daa.rShin,    TRUE );
    }

    currentModel =  GetItemAppearance( item, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LSHIN );
    if( daa.lShin != currentModel ) {
        DestroyObject( item );
        item =      CopyItemAndModify( item, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LSHIN,    daa.lShin,    TRUE );
    }

    currentModel =  GetItemAppearance( item, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RFOOT );
    if( daa.rFoot != currentModel ) {
        DestroyObject( item );
        item =      CopyItemAndModify( item, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_RFOOT,    daa.rFoot,    TRUE );
    }

    currentModel =  GetItemAppearance( item, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LFOOT );
    if( daa.lFoot != currentModel ) {
        DestroyObject( item );
        item =      CopyItemAndModify( item, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_LFOOT,    daa.lFoot,    TRUE );
    }

    currentModel =  GetItemAppearance( item, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_ROBE );
    if( daa.robe != currentModel ) {
        DestroyObject( item );
        item =      CopyItemAndModify( item, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_ROBE,    daa.robe,    TRUE );
    }

    int currentColor;

    currentColor =  GetItemAppearance( item, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_CLOTH1 );
    if( daa.colorCloth1 != currentColor ) {
        DestroyObject( item );
        item =      CopyItemAndModify( item, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_CLOTH1,    daa.colorCloth1,    TRUE );
    }

    currentColor =  GetItemAppearance( item, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_CLOTH2 );
    if( daa.colorCloth2 != currentColor ) {
        DestroyObject( item );
        item =      CopyItemAndModify( item, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_CLOTH2,    daa.colorCloth2,    TRUE );
    }

    currentColor =  GetItemAppearance( item, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_LEATHER1 );
    if( daa.colorLeather1 != currentColor ) {
        DestroyObject( item );
        item =      CopyItemAndModify( item, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_LEATHER1,    daa.colorLeather1,    TRUE );
    }

    currentColor =  GetItemAppearance( item, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_LEATHER2 );
    if( daa.colorLeather2 != currentColor ) {
        DestroyObject( item );
        item =      CopyItemAndModify( item, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_LEATHER2,    daa.colorLeather2,    TRUE );
    }

    currentColor =  GetItemAppearance( item, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_METAL1 );
    if( daa.colorMetal1 != currentColor ) {
        DestroyObject( item );
        item =      CopyItemAndModify( item, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_METAL1,    daa.colorMetal1,    TRUE );
    }

    currentColor =  GetItemAppearance( item, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_METAL2 );
    if( daa.colorMetal2 != currentColor ) {
        DestroyObject( item );
        item =      CopyItemAndModify( item, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_METAL2,    daa.colorMetal2,    TRUE );
    }

    return item;
}


struct Item_WeaponAppearance {
    int modelTop;
    int modelMiddle;
    int modelBottom;
    int colorTop;
    int colorMiddle;
    int colorBottom;
};

struct Item_WeaponAppearance Item_getWeaponAppearance( object item );
struct Item_WeaponAppearance Item_getWeaponAppearance( object item ) {
    struct Item_WeaponAppearance wa;

    wa.modelTop =       GetItemAppearance( item, ITEM_APPR_TYPE_WEAPON_MODEL, ITEM_APPR_WEAPON_MODEL_TOP );
    wa.modelMiddle =    GetItemAppearance( item, ITEM_APPR_TYPE_WEAPON_MODEL, ITEM_APPR_WEAPON_MODEL_MIDDLE );
    wa.modelBottom =    GetItemAppearance( item, ITEM_APPR_TYPE_WEAPON_MODEL, ITEM_APPR_WEAPON_MODEL_BOTTOM );

    wa.colorTop =       GetItemAppearance( item, ITEM_APPR_TYPE_WEAPON_COLOR, ITEM_APPR_WEAPON_COLOR_TOP );
    wa.colorMiddle =    GetItemAppearance( item, ITEM_APPR_TYPE_WEAPON_COLOR, ITEM_APPR_WEAPON_COLOR_MIDDLE );
    wa.colorBottom =    GetItemAppearance( item, ITEM_APPR_TYPE_WEAPON_COLOR, ITEM_APPR_WEAPON_COLOR_BOTTOM );

    return wa;
}

// aplica a un arma 'item' la apariencia recibida 'dwa'
object Item_applyAppearanceToWeapon( object item, struct Item_WeaponAppearance dwa );
object Item_applyAppearanceToWeapon( object item, struct Item_WeaponAppearance dwa ) {
    struct Item_WeaponAppearance cwa = Item_getWeaponAppearance( item );

    if( dwa.modelTop != cwa.modelTop ) {
        DestroyObject( item );
        item = CopyItemAndModify( item, ITEM_APPR_TYPE_WEAPON_MODEL, ITEM_APPR_WEAPON_MODEL_TOP,       dwa.modelTop, TRUE );
    }

    if( dwa.modelMiddle != cwa.modelMiddle ) {
        DestroyObject( item );
        item = CopyItemAndModify( item, ITEM_APPR_TYPE_WEAPON_MODEL, ITEM_APPR_WEAPON_MODEL_MIDDLE,    dwa.modelMiddle, TRUE );
    }

    if( dwa.modelBottom != cwa.modelBottom ) {
        DestroyObject( item );
        item = CopyItemAndModify( item, ITEM_APPR_TYPE_WEAPON_MODEL, ITEM_APPR_WEAPON_MODEL_BOTTOM,    dwa.modelBottom, TRUE );
    }


    if( dwa.colorTop != cwa.colorTop ) {
        DestroyObject( item );
        item = CopyItemAndModify( item, ITEM_APPR_TYPE_WEAPON_COLOR, ITEM_APPR_WEAPON_COLOR_TOP,       dwa.colorTop, TRUE );
    }

    if( dwa.colorMiddle != cwa.colorMiddle ) {
        DestroyObject( item );
        item = CopyItemAndModify( item, ITEM_APPR_TYPE_WEAPON_COLOR, ITEM_APPR_WEAPON_COLOR_MIDDLE,    dwa.colorMiddle, TRUE );
    }

    if( dwa.colorBottom != cwa.colorBottom ) {
        DestroyObject( item );
        item = CopyItemAndModify( item, ITEM_APPR_TYPE_WEAPON_COLOR, ITEM_APPR_WEAPON_COLOR_BOTTOM,    dwa.colorBottom, TRUE );
    }

    return item;
}


// Genera una apariencia al azar para un arma de tipo base 'baseItemType'
struct Item_WeaponAppearance Item_generateRandomAppearanceForWeapon( int baseItemType );
struct Item_WeaponAppearance Item_generateRandomAppearanceForWeapon( int baseItemType ) {
    int maxColorBottom = 4;
    int maxColorMiddle = 4;
    int maxColorTop = 4;
    int maxModelBottom = 4;
    int maxModelMiddle = 4;
    int maxModelTop = 4;
    switch ( baseItemType ) {
        case BASE_ITEM_ARROW:                   maxModelBottom = 3; maxModelMiddle = 3; maxModelTop = 3; break;
        case BASE_ITEM_BASTARDSWORD:            maxModelBottom = 6; maxModelMiddle = 6; maxModelTop = 6; break;
        case BASE_ITEM_BATTLEAXE:               maxModelBottom = 6; maxModelMiddle = 6; maxModelTop = 8; break;
        case BASE_ITEM_BOLT:                    maxModelBottom = 3; maxModelMiddle = 6; maxModelTop = 3; break;
        case BASE_ITEM_BOOTS:                   maxColorBottom = 8; maxModelBottom = 5; maxModelTop = 7; break;
        case BASE_ITEM_CLUB:                    maxModelMiddle = 3; maxModelTop = 5; break;
        case BASE_ITEM_DAGGER:                  maxModelBottom = 6; maxModelMiddle = 6; maxModelTop = 6; break;
        case BASE_ITEM_DIREMACE:                break;
        case BASE_ITEM_DOUBLEAXE:               maxModelBottom = 3; maxModelMiddle = 3; maxModelTop = 3; break;
        case BASE_ITEM_DWARVENWARAXE:           maxModelBottom = 6; maxModelMiddle = 6; maxModelTop = 8; break;
        case BASE_ITEM_GREATAXE:                break;
        case BASE_ITEM_GREATSWORD:              maxModelMiddle = 5; maxModelTop = 5; break;
        case BASE_ITEM_HALBERD:                 break;
        case BASE_ITEM_HANDAXE:                 break;
        case BASE_ITEM_HEAVYCROSSBOW:           break;
        case BASE_ITEM_HEAVYFLAIL:              break;
        case BASE_ITEM_KAMA:                    maxModelBottom = 1; maxModelMiddle = 1; maxModelTop = 1; break;
        case BASE_ITEM_KATANA:                  break;
        case BASE_ITEM_KUKRI:                   maxModelBottom = 1; maxModelMiddle = 1; maxModelTop = 1; break;
        case BASE_ITEM_LIGHTCROSSBOW:           break;
        case BASE_ITEM_LIGHTFLAIL:              break;
        case BASE_ITEM_LIGHTHAMMER:             break;
        case BASE_ITEM_LIGHTMACE:               break;
        case BASE_ITEM_LONGBOW:                 break;
        case BASE_ITEM_LONGSWORD:               maxModelBottom = 9; maxModelMiddle = 9; maxModelTop = 9; break;
        case BASE_ITEM_MAGICROD:                break;
        case BASE_ITEM_MAGICSTAFF:              maxModelBottom = 6; maxModelMiddle = 6; maxModelTop = 6; break;
        case BASE_ITEM_MAGICWAND:               maxModelBottom = 6; maxModelMiddle = 6; maxModelTop = 6; break;
        case BASE_ITEM_MORNINGSTAR:             break;
        case BASE_ITEM_QUARTERSTAFF:            break;
        case BASE_ITEM_RAPIER:                  break;
        case BASE_ITEM_SCIMITAR:                maxModelBottom = 5; maxModelMiddle = 5; maxModelTop = 5; break;
        case BASE_ITEM_SCYTHE:                  maxModelBottom = 3; maxModelMiddle = 3; maxModelTop = 3; break;
        case BASE_ITEM_SHORTBOW:                maxModelBottom = 6; maxModelMiddle = 6; maxModelTop = 6; break;
        case BASE_ITEM_SHORTSWORD:              maxModelBottom = 6; maxModelMiddle = 6; maxModelTop = 6; break;
        case BASE_ITEM_SHORTSPEAR:              break;
        case BASE_ITEM_SICKLE:                  maxModelBottom = 1; maxModelMiddle = 1; maxModelTop = 1; break;
        case BASE_ITEM_THROWINGAXE:             break;
        //case BASE_ITEM_TRIDENT:                 break;
        case BASE_ITEM_TWOBLADEDSWORD:          maxModelBottom = 3; maxModelMiddle = 3; maxModelTop = 3; break;
        case BASE_ITEM_WARHAMMER:               maxModelBottom = 6; maxModelMiddle = 6; maxModelTop = 6; break;

        default:                                maxColorBottom = 1; maxColorMiddle = 1; maxColorTop = 1;
                                                maxModelBottom = 1; maxModelMiddle = 1; maxModelTop = 1; break;
    }

    struct Item_WeaponAppearance appearance;
    appearance.colorBottom = Random(maxColorBottom) + 1;
    appearance.colorMiddle = Random(maxColorMiddle) + 1;
    appearance.colorTop =    Random(maxColorTop) + 1;
    appearance.modelBottom = Random(maxModelBottom) + 1;
    appearance.modelMiddle = Random(maxModelMiddle) + 1;
    appearance.modelTop =    Random(maxModelTop) + 1;

    return appearance;
}


// Cambia la apariencia del arma por una al azar.
// Devuelve el item con la nueva apariencia.
// En caso de no ser un arma, solo devuelve el item sin modificarlo.
// Falta definir algunas armas que no estan en el spawn
object Item_applyRandomAppearanceToWeapon( object item );
object Item_applyRandomAppearanceToWeapon( object item ) {
    object modifiedItem;
    do {
//        SendMessageToPC( GetFirstPC(), "Item_applyRandomAppearanceToWeapon: bucle" );
        modifiedItem = Item_applyAppearanceToWeapon( item, Item_generateRandomAppearanceForWeapon( GetBaseItemType( item ) ) );
    } while( !GetIsObjectValid( modifiedItem ) );
    return modifiedItem;
}


// Cambia la apariencia del anillo por una al azar.
// Devuelve el item con la nueva apariencia.
// En caso de no ser un anillo, solo devuelve el item sin modificarlo.
object Item_applyRandomAppearanceToRing( object item );
object Item_applyRandomAppearanceToRing( object item ) {
    int modelBase = GetItemAppearance(item, ITEM_APPR_TYPE_SIMPLE_MODEL, 0);
    while( TRUE ) {
        // rangos de modelos validos segun draco: 1-36, 38-130, 138-141, 157-164, 166-238
        // total de modelos posibles: 36-1+1 + 130-38+1 + 141-138+1 +  164-157+1 +  238-166+1 = 214
        int model = Random(214)+1;
        if( model > 36 ) model += 38 - 36 - 1;
        if( model > 130 ) model += 138 - 130 - 1;
        if( model > 141 ) model += 157 - 141 - 1;
        if( model > 164 ) model += 166 - 164 - 1;

        if( model == modelBase )
            return item;
        else {
            object modifiedItem = CopyItemAndModify( item, ITEM_APPR_TYPE_SIMPLE_MODEL, 0, model, TRUE);
            if( GetIsObjectValid(modifiedItem) ) {
                DestroyObject( item );
                return modifiedItem;
            }
        }
//        SendMessageToPC( GetFirstPC(), "Item_applyRandomAppearanceToRing: model="+IntToString(model) );
    }
    return OBJECT_INVALID; // nunca se ejecuta, esta para que el compilador no chille
}


// Cambia la apariencia del collar por una al azar.
// Devuelve el item con la nueva apariencia.
// En caso de no ser un collar, solo devuelve el item sin modificarlo.
object Item_applyRandomAppearanceToNecklace( object item );
object Item_applyRandomAppearanceToNecklace( object item ) {
    int modelBase = GetItemAppearance(item, ITEM_APPR_TYPE_SIMPLE_MODEL, 0);
    while( TRUE ) {

        // rangos de modelos validos segun draco: 1-74, 129-130, 157-184, 226-254
        // total de modelos posibles: 74-1+1 + 130-129+1 + 184-157+1 + 254-226+1 = 133
        int model = Random(133)+1;
        if( model > 74 ) model += 129 - 74 - 1;
        if( model > 130 ) model += 157 - 130 - 1;
        if( model > 184 ) model += 226 - 184 - 1;

        if( model == modelBase )
            return item;
        else {
            object modifiedItem = CopyItemAndModify( item, ITEM_APPR_TYPE_SIMPLE_MODEL, 0, model, TRUE);
            if( GetIsObjectValid( modifiedItem ) ) {
                DestroyObject( item );
                return modifiedItem;
            }
        }
//        SendMessageToPC( GetFirstPC(), "Item_applyRandomAppearanceToNecklace: model="+IntToString(model) );
    }
    return OBJECT_INVALID; // nunca se ejecuta, esta para que el compilador no chille
}


// Cambia la apariencia del brazalete por una al azar.
// Devuelve el item con la nueva apariencia.
object Item_applyRandomAppearanceToBracer( object item );
object Item_applyRandomAppearanceToBracer( object item ) {
    int modelBase = GetItemAppearance(item, ITEM_APPR_TYPE_SIMPLE_MODEL, 0);
    while( TRUE ) {
        // rangos de modelos validos segun draco: 1-12, 51-60, 113-116, 127-178
        // total de modelos posibles: 12-1+1 + 60-51+1 + 116-113+1 + 178-127+1 = 78
        int model = Random(78)+1;
        if( model > 12 ) model += 51 - 12 - 1;
        if( model > 60 ) model += 113 - 60 - 1;
        if( model > 116 ) model += 127 - 116 - 1;

        if( model == modelBase )
            return item;
        else {
            object modifiedItem = CopyItemAndModify( item, ITEM_APPR_TYPE_SIMPLE_MODEL, 0, model, TRUE);
            if( GetIsObjectValid(modifiedItem) ) {
                DestroyObject( item );
                return modifiedItem;
            }
        }
//        SendMessageToPC( GetFirstPC(), "Item_applyRandomAppearanceToBracer: model="+IntToString(model) );
    }
    return OBJECT_INVALID; // nunca se ejecuta, esta para que el compilador no chille
}


// Cambia la apariencia del guante por una al azar.
// Devuelve el item con la nueva apariencia.
object Item_applyRandomAppearanceToGloves( object item );
object Item_applyRandomAppearanceToGloves( object item ) {

    int modelBase = GetItemAppearance(item, ITEM_APPR_TYPE_SIMPLE_MODEL, 0);
    while( TRUE ) {
        // rangos de modelos validos segun draco: 1-11, 51-62, 97-112, 125-200
        // total de modelos posibles: 11-1+1 + 62-51+1 + 112-97+1 + 200-125+1 = 115
        int model = Random(115)+1;
        if( model > 11 ) model += 51 - 11 - 1;
        if( model > 62 ) model += 97 - 62 - 1;
        if( model > 112 ) model += 125 - 112 - 1;

        if( model == modelBase )
            return item;
        else {
            object modifiedItem = CopyItemAndModify( item, ITEM_APPR_TYPE_SIMPLE_MODEL, 0, model, TRUE);
            if( GetIsObjectValid( modifiedItem ) ) {
                DestroyObject( item );
                return modifiedItem;
            }
        }
//        SendMessageToPC( GetFirstPC(), "Item_applyRandomAppearanceToGloves: model="+IntToString(model) );
    }
    return OBJECT_INVALID; // nunca se ejecuta, esta para que el compilador no chille
}


// Cambia la apariencia del cinturon por una al azar.
// Devuelve el item con la nueva apariencia.
// En caso de no ser un cinturon, solo devuelve el item sin modificarlo.
object Item_applyRandomAppearanceToBelt( object item );
object Item_applyRandomAppearanceToBelt( object item ) {

    int modelBase = GetItemAppearance( item, ITEM_APPR_TYPE_SIMPLE_MODEL, 0 );
    while( TRUE ) {

        // rangos de modelos validos segun draco: 1-9, 51-58, 110-111, 120-173, 219-256
        // total de modelos posibles = 9-1+1 + 58-51+1 + 111-110+1 + 173-120+1 + 256-219+1 = 121
        int model = Random(121)+1;
        if( model > 9 ) model += 51 - 9 - 1;
        if( model > 58 ) model += 110 - 58 - 1;
        if( model > 111 ) model += 120 - 111 - 1;
        if( model > 173 ) model += 219 - 173 - 1;

        if( model == modelBase )
            return item;
        else {
            object modifiedItem = CopyItemAndModify( item, ITEM_APPR_TYPE_SIMPLE_MODEL, 0, model, TRUE);
            if( GetIsObjectValid( modifiedItem ) ) {
                DestroyObject( item );
                return modifiedItem;
            }
        }
//        SendMessageToPC( GetFirstPC(), "Item_applyRandomAppearanceToBelt: model="+IntToString(model) );
    }
    return OBJECT_INVALID; // nunca se ejecuta, esta para que el compilador no chille
}


// Cambia la apariencia del escudo pequeño por una al azar.
// Devuelve el item con la nueva apariencia.
object Item_applyRandomAppearanceToSmallShield( object item );
object Item_applyRandomAppearanceToSmallShield( object item ) {

    int modelBase = GetItemAppearance(item, ITEM_APPR_TYPE_SIMPLE_MODEL, 0);
    while(TRUE) {
        // rangos de modelos segun Inquisidor: 11-13, 21-23, 31-33, 41-43, 51-57, 86-88
        // rangos de modelos de luz: 34-39, 44-49, 61-64
        // total de modelos posibles: 13-11+1 + 23-21+1 + 33-31+1 + 43-41+1 + 67-51+1 + 88-86+1 = 32
        int model = Random(32)+11;
        if( model > 13 ) model += 21 - 13 - 1;
        if( model > 23 ) model += 31 - 23 - 1;
        if( model > 33 ) model += 41 - 33 - 1;
        if( model > 43 ) model += 51 - 43 - 1;
        if( model > 57 ) model += 86 - 57 - 1;

        if( model == modelBase )
            return item;
        else {
            object modifiedItem = CopyItemAndModify( item, ITEM_APPR_TYPE_SIMPLE_MODEL, 0, model, TRUE);
            if( GetIsObjectValid(modifiedItem) ) {
                DestroyObject( item );
                return modifiedItem;
            }
        }
//        SendMessageToPC( GetFirstPC(), "Item_applyRandomAppearanceToSmallShield: model="+IntToString(model) );
    }
    return OBJECT_INVALID; // nunca se ejecuta, solo esta para que el compilador no chille
}

// Cambia la apariencia del escudo grande por una al azar.
// Devuelve el item con la nueva apariencia.
object Item_applyRandomAppearanceToLargeShield( object item );
object Item_applyRandomAppearanceToLargeShield( object item ) {
    int randomModel;

    int modelBase = GetItemAppearance(item, ITEM_APPR_TYPE_SIMPLE_MODEL, 0);
    while(TRUE) {
        // rangos de modelos segun draco: 11-19, 21-29, 31-35, 41-43, 51-105
        // rangos de modelos de luz: 44-49
        // total de modelos posibles: 19-11+1 + 29-21+1 + 35-31+1 + 49-41+1 + 105-51+1 = 81
        int model = Random(81)+11;
        if( model > 19 ) model += 21 - 19 - 1;
        if( model > 29 ) model += 31 - 29 - 1;
        if( model > 35 ) model += 41 - 35 - 1;
        if( model > 43 ) model += 51 - 43 - 1;

        if( model == modelBase )
            return item;
        else {
            object modifiedItem = CopyItemAndModify( item, ITEM_APPR_TYPE_SIMPLE_MODEL, 0, model, TRUE);
            if( GetIsObjectValid( modifiedItem ) ) {
                DestroyObject( item );
                return modifiedItem;
            }
        }
//        SendMessageToPC( GetFirstPC(), "Item_applyRandomAppearanceToLargeShield: model="+IntToString(model) );
    }
    return OBJECT_INVALID; // nunca se ejecuta, esta para que el compilador no chille
}

// Cambia la apariencia del escudo pavés por una al azar.
// Devuelve el item con la nueva apariencia.
object Item_applyRandomAppearanceToTowerShield( object item );
object Item_applyRandomAppearanceToTowerShield( object item ) {

    int modelBase = GetItemAppearance(item, ITEM_APPR_TYPE_SIMPLE_MODEL, 0);
    while( TRUE ) {
        // rangos de modelos segun draco: 11-13, 21-23, 31-49, 51- 105
        // rango de escudos de luz: 14-19
        // total de modelos posibles: 13-11+1 + 23-21+1 + 49-31+1 + 105-51+1 = 80
        int model = Random(80)+11;
        if( model > 13 ) model += 21 - 13 - 1;
        if( model > 23 ) model += 31 - 23 - 1;
        if( model > 49 ) model += 51 - 49 - 1;

        if( model == modelBase )
            return item;
        else {
            object modifiedItem = CopyItemAndModify( item, ITEM_APPR_TYPE_SIMPLE_MODEL, 0, model, TRUE);
            if( GetIsObjectValid( modifiedItem ) ) {
                DestroyObject( item );
                return modifiedItem;
            }
        }
//        SendMessageToPC( GetFirstPC(), "Item_applyRandomAppearanceToTowerShield: model="+IntToString(model) );
    }
    return OBJECT_INVALID; // nunca se ejecuta, esta para que el compilador no chille
}



// Cambia la apariencia de dardos por una al azar.
// Devuelve el item con la nueva apariencia.
object Item_applyRandomAppearanceToDart( object item );
object Item_applyRandomAppearanceToDart( object item ) {
    int modelBase = GetItemAppearance( item, ITEM_APPR_TYPE_SIMPLE_MODEL, 0);
    while( TRUE ) {
        int model = Random(3)+1 + (Random(4)+1)*10;
        if( model == modelBase )
            return item;
        else {
            object modifiedItem = CopyItemAndModify( item, ITEM_APPR_TYPE_SIMPLE_MODEL, 0, model, TRUE);
            if( GetIsObjectValid( modifiedItem ) ) {
                DestroyObject( item );
                return modifiedItem;
            }
        }
//        SendMessageToPC( GetFirstPC(), "Item_applyRandomAppearanceToDart: model="+IntToString(model) );
    }
    return OBJECT_INVALID;
}


// Cambia al azar la apariencia de las municiones.
// Devuelve el item con la nueva apariencia.
object Item_applyRandomAppearanceToBullet( object item );
object Item_applyRandomAppearanceToBullet( object item ) {
    int modelBase = GetItemAppearance( item, ITEM_APPR_TYPE_SIMPLE_MODEL, 0);
    while( TRUE ) {
        int model;
        do {
            model = d10()*10 + d8();
        } while( model == 72 );

        if( model == modelBase )
            return item;
        else {
            object modifiedItem = CopyItemAndModify( item, ITEM_APPR_TYPE_SIMPLE_MODEL, 0, model, TRUE );
            if( GetIsObjectValid( modifiedItem ) ) {
                DestroyObject(item);
                return modifiedItem;
            }
        }
//        SendMessageToPC( GetFirstPC(), "Item_applyRandomAppearanceToBullet: model="+IntToString(model) );
    }
    return OBJECT_INVALID;
}


object Item_applyRandomAppearance( object item );
object Item_applyRandomAppearance( object item ) {
    switch( GetBaseItemType( item ) ) {

//TODO  case BASE_ITEM_ARMOR:

        case BASE_ITEM_BULLET:      return Item_applyRandomAppearanceToBullet( item );
//TODO  case BASE_ITEM_SHURIKEN:
        case BASE_ITEM_DART:       return Item_applyRandomAppearanceToDart( item );

        case BASE_ITEM_AMULET:      return Item_applyRandomAppearanceToNecklace( item );
        case BASE_ITEM_BELT:        return Item_applyRandomAppearanceToBelt( item );
        case BASE_ITEM_BRACER:      return Item_applyRandomAppearanceToBracer( item );
        case BASE_ITEM_GLOVES:      return Item_applyRandomAppearanceToGloves( item );
//TODO  case BASE_ITEM_HELMET:
        case BASE_ITEM_RING:        return Item_applyRandomAppearanceToRing( item );

        case BASE_ITEM_LARGESHIELD: return Item_applyRandomAppearanceToLargeShield( item );
        case BASE_ITEM_SMALLSHIELD: return Item_applyRandomAppearanceToSmallShield( item );
        case BASE_ITEM_TOWERSHIELD: return Item_applyRandomAppearanceToTowerShield( item );


        case BASE_ITEM_ARROW:
        case BASE_ITEM_BASTARDSWORD:
        case BASE_ITEM_BATTLEAXE:
        case BASE_ITEM_BOLT:
        case BASE_ITEM_BOOTS: // correcto: el modelo de apariencia de las boots es como el de las armas
        case BASE_ITEM_CLUB:
        case BASE_ITEM_DAGGER:
        case BASE_ITEM_DIREMACE:
        case BASE_ITEM_DOUBLEAXE:
        case BASE_ITEM_DWARVENWARAXE:
        case BASE_ITEM_GREATAXE:
        case BASE_ITEM_GREATSWORD:
        case BASE_ITEM_HALBERD:
        case BASE_ITEM_HANDAXE:
        case BASE_ITEM_HEAVYCROSSBOW:
        case BASE_ITEM_HEAVYFLAIL:
        case BASE_ITEM_KAMA:
        case BASE_ITEM_KATANA:
        case BASE_ITEM_KUKRI:
        case BASE_ITEM_LIGHTCROSSBOW:
        case BASE_ITEM_LIGHTFLAIL:
        case BASE_ITEM_LIGHTHAMMER:
        case BASE_ITEM_LIGHTMACE:
        case BASE_ITEM_LONGBOW:
        case BASE_ITEM_LONGSWORD:
        case BASE_ITEM_MAGICROD:
        case BASE_ITEM_MAGICSTAFF:
        case BASE_ITEM_MAGICWAND:
        case BASE_ITEM_MORNINGSTAR:
        case BASE_ITEM_QUARTERSTAFF:
        case BASE_ITEM_RAPIER:
        case BASE_ITEM_SCIMITAR:
        case BASE_ITEM_SCYTHE:
        case BASE_ITEM_SHORTBOW:
        case BASE_ITEM_SHORTSPEAR:
        case BASE_ITEM_SHORTSWORD:
        case BASE_ITEM_SICKLE:
        case BASE_ITEM_THROWINGAXE:
        //case BASE_ITEM_TRIDENT:
        case BASE_ITEM_TWOBLADEDSWORD:
        case BASE_ITEM_WARHAMMER:
        case BASE_ITEM_WHIP:
                                    return Item_applyRandomAppearanceToWeapon( item );
    }
    return item;
}


