/******************* IPSystem - Item Convertion Tools **************************
package: Item Properties System - standard to IPS conversor
Autor: Inquisidor
Descripcion: herramientas para convertir un item con propiedades standard, a uno con el
mecanismo de propiedades usado por el IPS (ver "IPS_inc").
*******************************************************************************/
#include "IPS_RPG_inc"
//#include "Item_inc"


const string IPS_ICT_ORIGINAL_CONTAINER_TAG_PREFIX = "IPS_ICT_originalContainer";
const string IPS_ICT_DESTINATION_CONTAINER_TAG_PREFIX = "IPS_ICT_destinationContainer";
const string IPS_ICT_TEMPORARY_CONTAINER_TAG = "IPS_ICT_temporaryContainer";
const int IPS_ICT_CONTAINER_TAG_INDEX_WIDTH = 2;
const string IPS_ICT_destinationContainer_VN = "IPSdc";
const string IPS_ICT_originalContainer_VN = "IPSoc";
const string IPS_ICT_temporaryContainer_VN = "IPStc";
const string IPS_ICT_original_VN = "IPSoi";
const string IPS_ICT_convertedCopy_VN = "IPSci";



////////////////////////////////////////////////////////////////////////////////
//// RELACION ENTRE CALIDAD Y LOS PARAMETROS QUALITATIVOS DE UNA PROPIEDAD /////
////////////////////////////////////////////////////////////////////////////////

// calcula el costo de un feature cuyos parametros de qualitativos son 'level', 'factor' y 'exponent'.
// 'level' es el nivel de apilamiento o intensidad; 'factor' y 'exponent' son dos coeficientes.
// Esta funcion es inversa a IPS_Feature_calculateLevel() si los parametros 'factor' y 'exponent' se mantienen constantes.
float IPS_ICT_calculateCost( int level, struct IPS_FeatureCostParams fcp );
float IPS_ICT_calculateCost( int level, struct IPS_FeatureCostParams fcp ) {
    if( level > fcp.maxLevel ) level = fcp.maxLevel;
    return IPS_Feature_calculateCost( level, fcp.factor, fcp.exponent );
}


////////////////////////////////////////////////////////////////////////////////
///////////////////// HANDLERS /////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

// funcion privada usada por IPS_ICT_OriginalContainer_onDisturbed(..)
void IPS_ICT_copyConverting_step2( object originalItem, object temporayItem, object destinationContainer, string descriptors, float propertiesQuality ) {
    float baseItemQuality =  IPS_levelToQuality( Item_getValueAttributes( originalItem ).baseGoldValue / IntToFloat(IPS_ITEM_VALUE_PER_LEVEL) );
    int itemLevelX31 = FloatToInt( 31.0*IPS_qualityToLevel( baseItemQuality + propertiesQuality ) ); //31 = 62 / 2
    // crear el item convertido y destruir la copia temporal de trabajo
    object convertedItem = CopyObject( temporayItem, GetLocation( OBJECT_INVALID ), destinationContainer, IPS_ITEM_TAG_PREFIX + B62_build2(itemLevelX31) + "00" + descriptors );
    DestroyObject( temporayItem );
    if( !GetIsObjectValid( convertedItem ) )
        WriteTimestampedLogEntry( "IPS_ICT_copyConverting: error 1" );
    // poner el item en condiciones para que se vean todas sus propiedades.
    IPS_Item_setIsKnown( convertedItem, TRUE );
    IPS_Item_setIsVirgin( convertedItem, FALSE );
    SetStolenFlag( convertedItem, TRUE );
    IPS_Item_activateChosenProperties( convertedItem, OBJECT_INVALID, 0, IPS_ItemProperty_Attribute_IS_DYNAMIC ); // activa las propiedades STATIC. Notar que las propiedades IRREMOVABLE son STATIC
    IPS_Item_activateChosenProperties( convertedItem, OBJECT_INVALID, IPS_ItemProperty_Attribute_IS_DYNAMIC, IPS_ItemProperty_Attribute_IS_DYNAMIC ); // activa las propiedades DYNAMIC. Notar que las propiedades AWARE e INTERACT son DYNAMIC

    // asociar mutuamente el orginal y la copia convertida.
    SetLocalObject( convertedItem, IPS_ICT_original_VN, originalItem );
    SetLocalObject( originalItem, IPS_ICT_convertedCopy_VN, convertedItem );
}


// funcion privada usada por IPS_ICT_OriginalContainer_onDisturbed(..)
// Crea una copia del item original pero usando el nuevo sistema de propiedades IPS
// Nota: las propiedades desconocidas para el nuevo IPS son copiadas al nuevo item tal cual estaban.
void IPS_ICT_copyConverting( object originalItem, object destinationContainer, object temporaryContainer ) {
    object temporaryItem = CopyItem( originalItem, temporaryContainer, TRUE );
    int baseItemType = GetBaseItemType( temporaryItem );
    string descriptors;
    float quality;
    itemproperty itemPropertyIterator = GetFirstItemProperty( temporaryItem );
    while( GetIsItemPropertyValid( itemPropertyIterator ) ) {
        if( GetItemPropertyDurationType( itemPropertyIterator ) == DURATION_TYPE_PERMANENT ) {
            struct IPS_FeatureCostParams fcp;
            int propertyPrimaryType = GetItemPropertyType( itemPropertyIterator );
            int propertySecundaryType = GetItemPropertySubType( itemPropertyIterator );
            int propertyLevel = GetItemPropertyCostTableValue( itemPropertyIterator );
            switch( propertyPrimaryType ) {

                case ITEM_PROPERTY_ATTACK_BONUS:
                    fcp = IPS_Feature_AttackBonus_getCostParams( baseItemType );
                    if( propertyLevel > fcp.maxLevel ) propertyLevel = fcp.maxLevel;
                    descriptors += IPS_ItemProperty_AttackBonus_buildDescriptor( propertyLevel );
                    quality += IPS_ICT_calculateCost( propertyLevel, fcp );
                    RemoveItemProperty( temporaryItem, itemPropertyIterator );
                    break;

                case ITEM_PROPERTY_DAMAGE_BONUS:
                    if( propertySecundaryType <= IP_CONST_DAMAGETYPE_PHYSICAL )
                        fcp = IPS_Feature_FisicalDamageBonus_getCostParams( baseItemType );
                    else
                        fcp = IPS_Feature_ElementalDamageBonus_getCostParams( baseItemType );
                    if( propertyLevel >= DAMAGE_BONUS_1d4 ) propertyLevel -= DAMAGE_BONUS_1d4 - 2;
                    if( propertyLevel > fcp.maxLevel ) propertyLevel = fcp.maxLevel;
                    descriptors += IPS_ItemProperty_DamageBonus_buildDescriptor( propertySecundaryType, propertyLevel );
                    quality += IPS_ICT_calculateCost( propertyLevel, fcp );
                    RemoveItemProperty( temporaryItem, itemPropertyIterator );
                    break;

                case ITEM_PROPERTY_BONUS_FEAT:
                    descriptors += IPS_ItemProperty_BonusFeat_buildDescriptor( propertySecundaryType );
                    quality += IPS_Feature_Feat_getCost( baseItemType, propertySecundaryType );
                    RemoveItemProperty( temporaryItem, itemPropertyIterator );
                    break;

                case ITEM_PROPERTY_MIGHTY:
                    fcp = IPS_Feature_MaxRangeStrengthMod_getCostParams( baseItemType );
                    if( propertyLevel > fcp.maxLevel ) propertyLevel = fcp.maxLevel;
                    descriptors += IPS_ItemProperty_MaxRangeStrengthMod_buildDescriptor( propertyLevel );
                    quality += IPS_ICT_calculateCost( propertyLevel, fcp );
                    RemoveItemProperty( temporaryItem, itemPropertyIterator );
                    break;

                case ITEM_PROPERTY_KEEN:
                    descriptors += IPS_ItemProperty_Keen_buildDescriptor();
                    quality += IPS_Feature_Keen_getCost( baseItemType );
                    RemoveItemProperty( temporaryItem, itemPropertyIterator );
                    break;

                case ITEM_PROPERTY_CAST_SPELL:
                    if( 521 <= propertyPrimaryType && propertyPrimaryType <= 523 ) { // spell sequencer capacity: 521 -> 1 spell, 522 -> 2 spells, 523 -> 3 spells
                        fcp = IPS_Feature_SpellSequencer_getCostParams( baseItemType, GetBaseAC(temporaryItem) );
                        if( propertyLevel > fcp.maxLevel ) propertyLevel = fcp.maxLevel;
                        descriptors += IPS_ItemProperty_CastSpell_buildDescriptor( propertySecundaryType, propertyLevel );
                        quality += IPS_ICT_calculateCost( propertyLevel, fcp );
                        RemoveItemProperty( temporaryItem, itemPropertyIterator );
                    }
                    break;

                case ITEM_PROPERTY_ABILITY_BONUS:
                    fcp = IPS_Feature_AbilityBonus_getCostParams( baseItemType );
                    if( propertyLevel > fcp.maxLevel ) propertyLevel = fcp.maxLevel;
                    descriptors += IPS_ItemProperty_AbilityBonus_buildDescriptor( propertySecundaryType, propertyLevel );
                    quality += IPS_ICT_calculateCost( propertyLevel, fcp );
                    RemoveItemProperty( temporaryItem, itemPropertyIterator );
                    break;

                case ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC:
                    fcp = IPS_Feature_BonusSavingThrow_getCostParams( baseItemType, propertySecundaryType );
                    if( propertyLevel > fcp.maxLevel ) propertyLevel = fcp.maxLevel;
                    descriptors += IPS_ItemProperty_BonusSavingThrow_buildDescriptor( propertySecundaryType, propertyLevel );
                    quality += IPS_ICT_calculateCost( propertyLevel, fcp );
                    RemoveItemProperty( temporaryItem, itemPropertyIterator );
                    break;

                case ITEM_PROPERTY_AC_BONUS:
                    fcp = IPS_Feature_ACBonus_getCostParams( baseItemType, GetBaseAC( temporaryItem ) );
                    if( propertyLevel > fcp.maxLevel ) propertyLevel = fcp.maxLevel;
                    descriptors += IPS_ItemProperty_ACBonus_buildDescriptor( propertyLevel );
                    quality += IPS_ICT_calculateCost( propertyLevel, fcp );
                    RemoveItemProperty( temporaryItem, itemPropertyIterator );
                    break;

                case ITEM_PROPERTY_ENHANCEMENT_BONUS:
                    fcp = IPS_Feature_EnhancementBonus_getCostParams( baseItemType );
                    if( propertyLevel > fcp.maxLevel ) propertyLevel = fcp.maxLevel;
                    descriptors += IPS_ItemProperty_EnhancementBonus_buildDescriptor( propertyLevel );
                    quality += IPS_ICT_calculateCost( propertyLevel, fcp );
                    RemoveItemProperty( temporaryItem, itemPropertyIterator );
                    break;

                case ITEM_PROPERTY_SKILL_BONUS:
                    fcp = IPS_Feature_SkillBonus_getCostParams( baseItemType );
                    if( propertyLevel > fcp.maxLevel ) propertyLevel = fcp.maxLevel;
                    descriptors += IPS_ItemProperty_SkillBonus_buildDescriptor( propertySecundaryType, propertyLevel );
                    quality += IPS_ICT_calculateCost( propertyLevel, fcp );
                    RemoveItemProperty( temporaryItem, itemPropertyIterator );
                    break;

                case ITEM_PROPERTY_BASE_ITEM_WEIGHT_REDUCTION:
                    fcp = IPS_Feature_WeightReduction_getCostParams( baseItemType, GetBaseAC( temporaryItem ) );
                    if( propertyLevel > fcp.maxLevel ) propertyLevel = fcp.maxLevel;
                    descriptors += IPS_ItemProperty_WeightReduction_buildDescriptor( propertyLevel );
                    quality += IPS_ICT_calculateCost( propertyLevel, fcp ); // no hay items viejos con esta propiedad
                    RemoveItemProperty( temporaryItem, itemPropertyIterator );
                    break;

                case ITEM_PROPERTY_IMMUNITY_DAMAGE_TYPE:
                    if( propertySecundaryType <= IP_CONST_DAMAGETYPE_PHYSICAL ) {
                        fcp = IPS_Feature_DamageImmunityFisical_getCostParams( baseItemType, GetBaseAC( temporaryItem ) );
                        if( propertyLevel > fcp.maxLevel ) propertyLevel = fcp.maxLevel;
                        descriptors += IPS_ItemProperty_DamageImmunityFisical_buildDescriptor( propertySecundaryType, propertyLevel );
                    } else {
                        fcp = IPS_Feature_DamageImmunityElemental_getCostParams( baseItemType, GetBaseAC( temporaryItem ) );
                        if( propertyLevel > fcp.maxLevel ) propertyLevel = fcp.maxLevel;
                        descriptors += IPS_ItemProperty_DamageImmunityElemental_buildDescriptor( propertySecundaryType - IP_CONST_DAMAGETYPE_MAGICAL, propertyLevel );
                    }
                    quality += IPS_ICT_calculateCost( propertyLevel, fcp );
                    RemoveItemProperty( temporaryItem, itemPropertyIterator );
                    break;

                case ITEM_PROPERTY_IMMUNITY_MISCELLANEOUS: {
                    int baseAC = GetBaseAC( originalItem );
                    int percentageIdx = (baseAC*5+20)/10; // esto hace que las tunicas tengan 20% y las armaduras completas 60%
                    descriptors += IPS_ItemProperty_Fortification_buildDescriptor( percentageIdx );
                    quality += IPS_ICT_calculateCost( percentageIdx, IPS_Feature_Fortification_getCostParams( baseItemType, baseAC ) );
                    RemoveItemProperty( temporaryItem, itemPropertyIterator );
                } break;

            }
        }
        itemPropertyIterator = GetNextItemProperty( temporaryItem );
    }
    // El siguiente AssignCommand es neceario para que se realicen las RemoveItemProperty(..) programadas arriba
    AssignCommand( OBJECT_SELF, IPS_ICT_copyConverting_step2( originalItem, temporaryItem, destinationContainer, descriptors, quality ) );
}


// IPS - Item Convertion Tool - Original Container - onDisturbed event handler
// Debe ser llamada desde el onDisturbed event-handler correspondiente al contenedor
// donde se pone el item que se pretende convertir del viejo al nuevo sistema de
// propiedades
void IPS_ICT_OriginalContainer_onDisturbed();
void IPS_ICT_OriginalContainer_onDisturbed() {
    object originalItem = GetInventoryDisturbItem();

    // obtener el contenedor destino donde aparece el item convertido.
    object destinationContainer = GetLocalObject( OBJECT_SELF, IPS_ICT_destinationContainer_VN );
    if( destinationContainer == OBJECT_INVALID ) {
        destinationContainer = GetObjectByTag( IPS_ICT_DESTINATION_CONTAINER_TAG_PREFIX + GetStringRight( GetTag(OBJECT_SELF), IPS_ICT_CONTAINER_TAG_INDEX_WIDTH ) );
        if( destinationContainer == OBJECT_INVALID ) {
            SendMessageToPC( GetLastDisturbed(), "Error: este conversor no funciona porque falta el contenedor destino" );
            return;
        }
        SetLocalObject( OBJECT_SELF, IPS_ICT_destinationContainer_VN, destinationContainer );
    }

    // si un item es agregado al contenedor de entrada de items originales:
    if( GetInventoryDisturbType() == INVENTORY_DISTURB_TYPE_ADDED ) {
        // si el item requiere conversion
        int itemType = GetBaseItemType( originalItem );
        if(
            GetTag(originalItem) == Tesoro_ITEM_TAG // si es un ítem generado por el viejo sistema
            || (
                GetPCPublicCDKey(GetLastDisturbed()) == "" // o se esta jugando en modo single player y el ítem requiere conversion
                && !IPS_Item_getIsAdept( originalItem )
                && itemType != BASE_ITEM_ENCHANTED_WAND
                && itemType != BASE_ITEM_ENCHANTED_POTION
                && itemType != BASE_ITEM_ENCHANTED_SCROLL
            )
        ) {
            itemproperty firstProperty = GetFirstItemProperty( originalItem );
            if(
                GetIsItemPropertyValid( firstProperty )
                //&& ( // esto dentro del parentesis hace que se excluyan de la conversion los items que tienen solo una propiedad de tipo ITEM_PROPERTY_CAST_SPELL y subtipo IP_CONST_CASTSPELL_UNIQUE_POWER_SELF_ONLY
                //    GetIsItemPropertyValid( GetNextItemProperty( originalItem ) )
                //    || GetItemPropertyType( firstProperty ) != ITEM_PROPERTY_CAST_SPELL
                //    || GetItemPropertySubType( firstProperty ) != IP_CONST_CASTSPELL_UNIQUE_POWER_SELF_ONLY
                //)
            ) {
                // obtener el contenedor temporario que necesita el convertidor.
                object temporaryContainer = GetLocalObject( OBJECT_SELF, IPS_ICT_temporaryContainer_VN );
                if( temporaryContainer == OBJECT_INVALID ) {
                    temporaryContainer = GetObjectByTag( IPS_ICT_TEMPORARY_CONTAINER_TAG );
                    if( temporaryContainer == OBJECT_INVALID ) {
                        SendMessageToPC( GetLastDisturbed(), "Error: los conversores no funcionan porque falta el contenedor temporario" );
                        return;
                    }
                    SetLocalObject( OBJECT_SELF, IPS_ICT_destinationContainer_VN, destinationContainer );
                }

                // crear la copia convertida en el contenedor destino
                IPS_ICT_copyConverting( originalItem, destinationContainer, temporaryContainer );
            }
        }
        // si no requiere conversion
        else
            SendMessageToPC( GetLastDisturbed(), "El ítem que acaba de poner no requiere conversión" );
    }
    // si un item es quitado del contenedor de entrada de items originales:
    else {
        // destruir la copia convertida
        object convertedItem = GetLocalObject( originalItem, IPS_ICT_convertedCopy_VN );
        DeleteLocalObject( originalItem, IPS_ICT_convertedCopy_VN );
        DestroyObject( convertedItem );
    }
}


// IPS - Item Convertion Tool - Original Container - onDisturbed event handler
// Debe ser llamada desde el onDisturbed event-handler correspondiente al contenedor
// de donde se toma el item convertido del viejo al nuevo sistema de propiedades
void IPS_ICT_DestinationContainer_onDisturbed();
void IPS_ICT_DestinationContainer_onDisturbed() {

    if( GetInventoryDisturbType() == INVENTORY_DISTURB_TYPE_REMOVED || GetInventoryDisturbType() == INVENTORY_DISTURB_TYPE_STOLEN ) {
        object convertedItem = GetInventoryDisturbItem();
        object originalItem = GetLocalObject( convertedItem, IPS_ICT_original_VN );
        if( GetIsObjectValid( originalItem ) ) {
            DeleteLocalObject( convertedItem, IPS_ICT_original_VN );
            DestroyObject( originalItem );
        }
    }
}
