/******************* Item Properties System ************************************
package: Item Properties System - item properties include
Autor: Inquisidor
Descripcion: sistema manejador de propiedades de items.
Este permite asociar a un item propiedades no visibles que se activan al equiparse.
Ademas soporta el agregado de restricciones inter items, como por ejemplo el no
apilamiento de habilidades y skills dados por items distintos.
*******************************************************************************/

#include "IPS_basic_inc"
#include "Confuse_itf"
#include "Mod_inc"
#include "SPC_itf" // quitar cuando se muevan las rutinas de las maldiciones a un script


const string IPS_Item_hasBeenTriedToRemove_VN = "IPShbtr"
    // puesto en TRUE cuando el ítem esta maldito y se lo intenta desequipar (en realidad el ítem es desequipado pero vuelve a equiparse automáticamente).
    // puesto en FALSE al final del 'IPS_Subject_onEquip(..)'
;


////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////// ItemProperty /////////////////////////////
////////////////////////////////////////////////////////////////////////////////
/* Un ItemProperty es una interface que especifica la interaccion entre el IPS (item property
system) y una propiedad de item.
Las instancias de ItemProperty correspondientes a un item son contenidas en el tag del item.
Las concecuencias de esto son:
    - que los datos de instancia deben ser traduciodos al formato que usa el contenedor para organizar sus elementos. A este formato se lo llamará 'descriptor'.
    - que las instancias son inmutables
Las operaciones son las siguientes:

string IPS_ItemProperty_PropertyName_buildDescriptor( ... )
    Crea una instancia de la propiedad y la traduce a descriptor.
;

void IPS_ItemProperty_PropertyName_apply( string itemProperty, object item, object subject )
    Llamada por el IPS cuando se requiere activar la 'itemProperty' en el 'item', cosa que sucede cuando:
        STATIC IRREMOVABLE:
            si el ítem esta virgen y es equipado o estudiado
        STATIC REMOVABLE:
            si el item es estudiado
        DYNAMIC:
            si 'subject==portador': el item esta desconocido y es equipado, o el PJ es cargado del vault con el item equipado. Independientemente de si el item estaba identificado o no.
            si 'subject==OBJECT_INVALID': el ítem esta desequipado y desconocido y es estudiado.
        AWARE: igual que DYNAMIC mas
            si 'subject==portador': el item esta conocido y es equipado.
            si 'subject==OBJECT_INVALID': el ítem esta conocido y es desequipado
        INTERACT: igual que AWARE mas
            si 'subject==portador': el item esta equipado pero fue desequiapdo virtualmente (se le quitaron todas las propiedades INTERACT), cosa que sucede despues de que algún otro ítem INTERACT sea desequipado, y es vuelto a equipar virtualmente.
    Notas:
        Si el item esta equipado, 'subject' es el sujeto portador del item. Si el item no esta equipadó, 'subject' vale OBJECT_INVALID.
        La implementacion debe poner la 'itemProperty' recibida (en formato descriptor) en el 'item'.
;

void IPS_ItemProperty_PropertyName_remove( string itemProperty, object item, object subject )
    Llamada por el IPS cuando se requiere desactivar la 'itemProperty' en el 'item', cosa que sucede cuando:
        STATIC IRREMOVABLE:
            nunca
        STATIC REMOVABLE:
            si el item esta conocido y es desestudiado
        DYNAMIC:
            el ítem esta desconocido y es desequipado, o esta desequipado y conocido y es desestudiado
        AWARE: igual que DYNAMIC mas
            el ítem esta conocido y es desequipado. Luego es vuelto a activar con el parametro 'subject' inválido.
        INTERACT: igual que AWARE mas
            el ítem esta equipado y algún otro ítem INTERACT fue desequipado. Luego es vuelto a activar con el parametro 'subject' igual al portador. Si hay otros ítems INTERACT equipados, ellos son virtualmente desequipados y reequipados (ver 'IPS_Subject_onUnequip(..)').

    Notas:
        Si el item esta equipado, 'subject' es el sujeto portador del item. Si el item no esta equipadó, 'subject' vale OBJECT_INVALID.
        La implementacion debe quitar la 'itemProperty' recibida (en formato descriptor) del 'item'.
;

string IPS_ItemProperty_PropertyName_inspect( string itemProperty, object item, object subject, int identifyBaseDC )
    Llamada por el IPS cuando se requiere examinar la 'itemProperty' en el 'item'.
    La implementacion debe determinar si 'subject' es capaz de distinguir (identificar) a 'itempProperty', y en caso afirmativo
    devolver la descripcion de la propiedad. Si falla, debe devolver un string vacio ("").
    Además, la implementacion puede realizar alguna acción sobre el PJ 'subject' o el 'item'.
    'identifyBaseDC' es la DC típica basada en la calidad del ítem. La implementacion puede usar o no este DC
;
*/
// Un par de definiciones de vocabulario:
// Sea P una instancia de propiedad contenida en el tag de un item I. Llamaremos "activar" la
// instancia de propiedad P del item I, a la accion de poner la instancia de propiedad P en
// el item I. Esto se hace llamando a 'IPS_ItemProperty_PropertyName_apply( P, I, S )'
// Y llamaremos "pasivar" la instancia de propiedad P del item I, a la accion de quitar la
// instancia de propiedad P del item I. Esto se hace llamando a 'IPS_ItemProperty_PropertyName_remove( P, I, S )'

// Existe un contrato de interaccion entre un ItemProperty y el IPS (item property system).
// Cada parte, la ItemProperty y el IPS, tiene sus responsabilidades hacia la otra; y estas
// responsabilidades varian segun unos atributos especiales de la ItemProperty.
// En general, las responsabilidades de una propiedad son las siguientes:
//  - No perturbar las instancias de otras propiedades del item.
// En general, las responsablidades del IPS son las siguientes:
//  - Cuando un item es creado, el IPS debe poner el flag de IsIdentified en TRUE, independientemente de si este en estado "conocido" o "desconocido".
//  - El IPS nunca debe activar una instancia de propiedad (llamando a 'IPS_Property_XXX_apply(..)') que ya este activada.
//  - Cuando una instancia de propiedad es activada en un item equipado, el parametro 'subject' debe ser el portador del item.
//  - Cuando una instancia de propiedad es activada en un item NO equipado, el parametro 'subject' debe ser OBJECT_INVALID.
//  - Cuando un item desconocido es equipado, el IPS debe poner el flag IsIdentified del item en FALSE. Esto es para evitar que las propiedades del item sean visibles.
//  - Cuando un item desconocido es desequipado, el IPS debe y poner el flag de IsIdentified en TRUE. Esto es para que el item sea equipable.
//  - Cuando un item desconocido es estudiado exitosamente, el IPS debe cambiar el estado del item a "conocido".
//  - Cuando un item desconocido es estudiado exitosamente mientras esta equipado, el IPS debe poner el flag de IsIdentified en TRUE.
//  - Cuando el jugador desequipa un item maldito, el IPS lo vuelve a equipar automáticamente y lo marca en 'IPS_Item_hasBeenTriedToRemove_VN' para que la implementaciones de 'IPS_ItemProperty_PropertyName_apply(..)' puedan distinguir si el ítem fue equipado voluntariamente por el PJ, o equipado a la fuerza por el IPS.

////////////////////////////////// ItemProperty Special Attributes /////////////////////////////////
// Los atributos especiales de una propiedad determinan variantes a como deben interactuar la propiedad y el IPS (item property system).

const int IPS_ItemProperty_Attribute_IS_DYNAMIC = 1
// Este atributo indica si la propiedad es DYNAMIC o STATIC.
// Una instancia de propiedad es DYNAMIC si las condiciones del sujeto, antes y despues de pasivar y activar la instancia, no difiern. Y es STATIC en caso contrario (si difieren).
// El hecho de que una instancia de propiedad DYNAMIC pueda pasivarse y volver a activarse sin concecuencias, permite al IPS activarla al equipar un item desconocido, ya que puede volver a pasivarla (para ocultar la propiedad) cuando el item desconocido es desequipado. O sea, un item equipado tendrá los agregados dados por las instancias de propiedades DYNAMIC, independientemente de si el item esta en estado "conocido" o "desconocido". Notar que un item en estado "desconocido" no deja ver sus propiedades.
// Responsabilidades de una propiedad DYNAMIC:
//  - Sea P una instancida de propiedad asociada a un item I equipado por el sujeto S; si estando P activa las condiciones de S son C, luego de pasivar P y volver a activarla, S debe volver a estar en las mismas condiciones C que tenia antes de pasivar y activar P. Notar que esto implica que el efecto resultante de las intencidades de multiples instancias de P en distintos items equipados por S, no depende del orden en que las instancias son activadas o pasivadas.
// Responsabilidades del IPS cuando trata una instancia de propiedad DYNAMIC:
//  - Cuando un item es creado, ninguna propiedad DYNAMIC es puesta en el item.
//  - Cuando un item desconocido es equipado, el IPS debe activar todas las propiedades DYNAMIC del item.
//  - Cuando un item desconocido es desequipado, el IPS debe pasivar todas las propiedades DYNAMIC del item.
//  - Cuando un item desconocido es estudiado exitosamente mientras NO esta equipado, el IPS debe activar todas las propiedades DYNAMIC del item.
// Responsabilidades de una propiedad STATIC: ninguna ademas de las generales
// Responsabilidades del IPS cuando trata una instancias de propiedad STATIC:
//  - Cuando un item es creado, ninguna propiedad STATIC es activada.
//  - Debe ser INDIFERENT.
//  - Cuando un item desconocido es estudiado exitosamente (este equipado o no), el IPS debe activar todas las propiedades STATIC del item.
;

const int IPS_ItemProperty_Attribute_IS_AWARE = 2
// Este atributo indica si la propiedad es AWARE o INDIFFERENT.
// Una instancia de propiedad es AWARE si la activacion o pasivacion es sensible al parametro 'subject'; y es INDIFERENT en caso contrario.
// Responsabilidades de una propiedad AWARE:
//  - Debe ser DYNAMIC.
//  - Cuando una propiedad es activada con el parametro 'subject' igual a un PJ valido, la intencidad de la propiedad debe ser la que se pretende cuando el PJ tiene el item equipado.
//  - Cuando una propiedad es activada con el parametro 'subject' igual a OBJECT_INVALID, la intencidad de la propiedad debe ser la que se pretende sea vista al examinar el objeto.
// Responsabilidades del IPS cuando trata una instancia de propiedad AWARE:
//  - Cuando un item conocido es desequipado, el IPS debe pasivar todas sus propiedades AWARE y luego volver a activarlas con el parametro 'subject' inválido..
//  - Al pasivar una instancia de propiedad AWARE que fue activada con el parametro 'subject' valido, el IPS debe usar el mismo valor de 'subject' que usó en la activacion. De la definicion de "activar" y "pasivar", se deduce que el parametro 'item' tambien debe ser el mismo.
// Responsabilidades de una propiedad INDIFERENT: ninguna además de las generales
// Responsabilidades del IPS cuando trata una instancia de propiedad INDIFFERENT: ninguna ademas de las generales.
;

const int IPS_ItemProperty_Attribute_IS_INTERACT = 4
// Este atributo indica si la propiedad es INTERACT o no.
// La propiedad es INTERACT si la intencidad de la propiedad depende de, y puede afectar a, la intencidad de otras instancias de la propiedad que tengan los items equipados; cumpliendose que el efecto resultante de las instancias de propiedades INTERACT sobre el sujeto portador, no depende del orden en que las instancias de propiedades INTERACT son activadas.
// A diferencia de DYNAMIC, este atributo requiere que el IPS realice trabajo extra para satisfacer lo establecido en DYNAMIC.
// Responsabilidades de una propiedad INTERACT:
//  - Debe ser AWARE (y por ende DYNAMIC). Notar que aunque una propiedad INTERACT por si sola no requiere cumplir con la responsabilidad de una propiedad DYNAMIC, si lo cumple con la ayuda del trabajo extra que realiza el IPS.
//  - La propiedad debe asegurar que el efecto resultante de las intencidades de multiples instancias de la propiedad en distintos items equipados, no dependa del orden en que las instancias son activadas. Sin embargo, a diferencia de DYNAMIC, la propiedad no es responsable de que la independencia del orden se cumpla cuando las instancias son pasivadas. O sea, que la propiedad NO esta obligada a lograr que el efecto resultante de multiples instancias en distintos items equipados sea independiente del orden en que las instancias son pasivadas.
//  - La intencidad de una instancia de la propiedad en un item no equipado, debe ser independiente de cualquier otra instancia de cualquier propiedad de cualquier item. A la intencidad de una intancia activada en un item no equipado se la llamará 'intencidad genuinda'.
// Responsabilidades del IPS cuando trata una instancia de propiedad INTERACT: cuando se trata de una propiedad INTERACT, el IPS tiene las responsabilidades que tiene cuando se trata de una propiedad STATIC, con el agregado de las siguientes resmponsabilidades:
//  - Cuando un item con alguna propiedad INTERACT es desequipado, el IPS debe pasivar todas las propiedades INTERACT de todos los items que permanecen equipados. Una vez pasivadas todas, debe volverlas a activar todas.
;

const int IPS_ItemProperty_Attribute_IS_IRREMOVABLE = 8
// Este atributo indica que una vez que la propiedad es activada en un item equipado, queda activada para siempre.
// Responsabilidades de una propiedad IRREMOVABLE:
//  - Debe ser STATIC
// Responsabilidades del IPS cuando trata una instancia de propiedad IRREMOVABLE:
//  - Cuando una instancia de propiedad IRREMOVABLE es activada en un item equipado, el IPS no debe pasivarla jamaz.
;

//Las convinaciones posibles de atributos especiales son:
const int IPS_ItemProperty_Attribute_BE_STATIC = 0;     // STATIC <=> INDIFERENT
const int IPS_ItemProperty_Attribute_BE_DYNAMIC = 1;    // DYNAMIC es mutualmente excluyente con STATIC
const int IPS_ItemProperty_Attribute_BE_AWARE = 3;      // AWARE => DYNAMIC
const int IPS_ItemProperty_Attribute_BE_INTERACT = 7;   // INTERACT => AWARE
const int IPS_ItemProperty_Attribute_BE_IRREMOVABLE = 8;// IRREMOVABLE => STATIC y INDIFERENT


//////////////////////////////// ItemProperty Descriptor ///////////////////////////////////
const int IPS_ItemProperty_INDEX_OFFSET = 0;
const int IPS_ItemProperty_INDEX_WIDTH = 1;
const int IPS_ItemProperty_ATTRIBUTES_OFFSET = 1;
const int IPS_ItemProperty_ATTRIBUTES_WIDTH = 1;
const int IPS_ItemProperty_PARAMETERS_OFFSET = 2;
const int IPS_ItemProperty_PARAMETERS_WIDTH = 3;
const int IPS_ItemProperty_TOTAL_WIDTH = 5;

const int IPS_ItemProperty_MAX_NUMBER_OF_PROPERTIES = 11; // = (63-IPS_ITEM_TAG_PROPERTIES_OFFSET)/IPS_ItemProperty_TOTAL_WIDTH

// Arma un ItemProperty dados el 'propertyIndex', 'attributes' y 'parameters'.
// 'propertyIndex' debe estar en el intervalo [0,61]
// 'attributes' debe estar en el intervalo [0,9]
// 'parameters' debe tener como maximo 3 caracteres
string IPS_ItemProperty_build( int propertyIndex, int attributes, string parameters );
string IPS_ItemProperty_build( int propertyIndex, int attributes, string parameters ) {
    int parametersLenght = GetStringLength( parameters );
    if( propertyIndex < 62 && attributes < 10 && parametersLenght <= IPS_ItemProperty_PARAMETERS_WIDTH )
        return
            B62_build1( propertyIndex )  // faltaria filtrar el 62 y 63
            + IntToString( attributes )
            + parameters
            + GetStringLeft( "___________", IPS_ItemProperty_PARAMETERS_WIDTH - parametersLenght )
        ;
    else {
        WriteTimestampedLogEntry( "IPS_ItemProperty_build: error, invalid parameters: propertyIndex="+IntToString( propertyIndex )+", attributes="+IntToString( attributes )+", parameter="+parameters );
        return "";
    }
}

// Busca en el ítem alguna propiedad cuyo indice sea 'propertyIndex'. De encontrarla, devuelve el descriptor de la propiedad. Sino, devuelve "".
string IPS_ItemProperty_getDescriptorAt( int propertyIndex, object item );
string IPS_ItemProperty_getDescriptorAt( int propertyIndex, object item ) {
    string itemTag = GetTag( item );
    int itemTagLength = GetStringLength( itemTag );
    int propertyPtr = IPS_ITEM_TAG_PROPERTIES_OFFSET;
    while( propertyPtr < itemTagLength ) {
        string propertyDescriptor = GetSubString( itemTag, propertyPtr, IPS_ItemProperty_TOTAL_WIDTH );
        if( propertyIndex == B62_toInt( GetSubString( propertyDescriptor, IPS_ItemProperty_INDEX_OFFSET, IPS_ItemProperty_INDEX_WIDTH ) ) )
            return propertyDescriptor;
        propertyPtr += IPS_ItemProperty_TOTAL_WIDTH;
    }
    return "";
}

/////////////////////////// ItemProperty Indexes ///////////////////////////////////////

const int IPS_ItemProperty_Index_ATTACK_BONUS               = 1;
const int IPS_ItemProperty_Index_DAMAGE_BONUS               = 2;
const int IPS_ItemProperty_Index_BONUS_FEAT                 = 3;
const int IPS_ItemProperty_Index_MAX_RANGE_STRENGHT_MOD     = 4;
const int IPS_ItemProperty_Index_KEEN                       = 5;
const int IPS_ItemProperty_Index_CAST_SPELL                 = 6;
const int IPS_ItemProperty_Index_ABILITY_BONUS              = 7;
const int IPS_ItemProperty_Index_BONUS_SAVING_THROW         = 8;
const int IPS_ItemProperty_Index_AC_BONUS                   = 9;
const int IPS_ItemProperty_Index_ENHANCEMENT_BONUS          = 10;
const int IPS_ItemProperty_Index_SKILL_BONUS                = 11;
const int IPS_ItemProperty_Index_WEIGHT_REDUCTION           = 12;
const int IPS_ItemProperty_Index_DAMAGE_IMMUNITY_FISICAL    = 13;
const int IPS_ItemProperty_Index_DAMAGE_IMMUNITY_ELEMENTAL  = 14;
const int IPS_ItemProperty_Index_FORTIFICATION              = 15;
const int IPS_ItemProperty_Index_CONFUSION                  = 16;
const int IPS_ItemProperty_Index_HOSTILITY                  = 17;
const int IPS_ItemProperty_Index_UNLIMITED_AMMO             = 18;
const int IPS_ItemProperty_Index_VAMPIRIC_REGENERATION      = 19;
const int IPS_ItemProperty_Index_ON_HIT_CAST_SPELL          = 20;
const int IPS_ItemProperty_Index_ON_HIT_PROPS               = 21;

/////////////////////////// ItemProperty Definitions ///////////////////////////////////////
//- - - - - - - - - - - - - - AttackBonus - - - - - - - - - - - - - - - - - - //
string IPS_ItemProperty_AttackBonus_buildDescriptor( int bonus );
string IPS_ItemProperty_AttackBonus_buildDescriptor( int bonus ) {
    return IPS_ItemProperty_build( IPS_ItemProperty_Index_ATTACK_BONUS, IPS_ItemProperty_Attribute_BE_DYNAMIC, IntToString(99-bonus) );
}
void IPS_ItemProperty_AttackBonus_apply( object item, object subject, string parameters ) {
    int bonus = 99 - StringToInt( GetSubString( parameters, 0, 2 ) );
    AddItemProperty( DURATION_TYPE_PERMANENT, ItemPropertyAttackBonus( bonus ), item );
}
void IPS_ItemProperty_AttackBonus_remove( object item, object subject, string parameters ) {
    Item_removeProperty( item, ITEM_PROPERTY_ATTACK_BONUS, -1 );
}

//- - - - - - - - - - - - - - DamageBonus - - - - - - - - - - - - - - - - - - //
string IPS_ItemProperty_DamageBonus_buildDescriptor( int damageType, int damageQuantity );
string IPS_ItemProperty_DamageBonus_buildDescriptor( int damageType, int damageQuantity ) {
    return IPS_ItemProperty_build( IPS_ItemProperty_Index_DAMAGE_BONUS, IPS_ItemProperty_Attribute_BE_DYNAMIC, IntToString(99-damageType) + B62_build1(damageQuantity) );
}
// QUITADO porque no es necesario. El motor agrega el efecto visual automáticamente.
//int IPS_ItemProperty_DamageBonus_damageType2VisualEfect( int damageType ) {
//    switch( damageType ) {
//    case IP_CONST_DAMAGETYPE_ACID:      return ITEM_VISUAL_ACID;
//    case IP_CONST_DAMAGETYPE_COLD:      return ITEM_VISUAL_COLD;
//    case IP_CONST_DAMAGETYPE_ELECTRICAL:return ITEM_VISUAL_ELECTRICAL;
//    case IP_CONST_DAMAGETYPE_FIRE:      return ITEM_VISUAL_FIRE;
//    case IP_CONST_DAMAGETYPE_SONIC:     return ITEM_VISUAL_SONIC;
//    case IP_CONST_DAMAGETYPE_DIVINE:    return ITEM_VISUAL_HOLY;
//    case IP_CONST_DAMAGETYPE_NEGATIVE:  return ITEM_VISUAL_EVIL;
//    }
//    return -1;
//}
void IPS_ItemProperty_DamageBonus_apply( object item, object subject, string parameters ) {
    int damageType = 99 - StringToInt( GetSubString( parameters, 0, 2 ) );
    int damageQuantity = B62_toInt( GetSubString( parameters, 2, 1 ) );
    AddItemProperty( DURATION_TYPE_PERMANENT, ItemPropertyDamageBonus( damageType, damageQuantity ), item );
// QUITADO porque no es necesario. El motor agrega el efecto visual automáticamente.
//    int visualEffect = IPS_ItemProperty_DamageBonus_damageType2VisualEfect( damageType );
//    if( visualEffect != -1 )
//        AddItemProperty( DURATION_TYPE_PERMANENT, ItemPropertyVisualEffect( visualEffect ), item );
}
void IPS_ItemProperty_DamageBonus_remove( object item, object subject, string parameters ) {
    int damageType = 99 - StringToInt( GetSubString( parameters, 0, 2 ) );
    Item_removeProperty( item, ITEM_PROPERTY_DAMAGE_BONUS, damageType );
// QUITADO porque no es necesario. El motor agrega el efecto visual automáticamente.
//    if( IPS_ItemProperty_DamageBonus_damageType2VisualEfect( damageType ) != -1 )
//        Item_removeProperty( item, ITEM_PROPERTY_VISUALEFFECT, -1 );
}

//- - - - - - - - - - - - - - BonusFeat - - - - - - - - - - - - - - - - - - //
// featId: IP_CONST_FEAT_*
string IPS_ItemProperty_BonusFeat_buildDescriptor( int featId );
string IPS_ItemProperty_BonusFeat_buildDescriptor( int featId ) {
    return IPS_ItemProperty_build( IPS_ItemProperty_Index_BONUS_FEAT, IPS_ItemProperty_Attribute_BE_DYNAMIC, B62_build2(featId) );
}
void IPS_ItemProperty_BonusFeat_apply( object item, object subject, string parameters ) {
    int featId = B62_toInt( GetSubString( parameters, 0, 2 ) );
//    SendMessageToPC( GetFirstPC(), "IPS_ItemProperty_BonusFeat_apply: featId="+IntToString(featId) );
    AddItemProperty( DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat( featId ), item );
}
void IPS_ItemProperty_BonusFeat_remove( object item, object subject, string parameters ) {
    int featId = B62_toInt( GetSubString( parameters, 0, 2 ) );
    Item_removeProperty( item, ITEM_PROPERTY_BONUS_FEAT, featId );
}

//- - - - - - - - - - - - - - MaxRangeStrengthMod - - - - - - - - - - - - - - - - - - //
// modifier: 1 to 20
string IPS_ItemProperty_MaxRangeStrengthMod_buildDescriptor( int modifier );
string IPS_ItemProperty_MaxRangeStrengthMod_buildDescriptor( int modifier ) {
    return IPS_ItemProperty_build( IPS_ItemProperty_Index_MAX_RANGE_STRENGHT_MOD, IPS_ItemProperty_Attribute_BE_DYNAMIC, IntToString( 99-modifier ) );
}
void IPS_ItemProperty_MaxRangeStrengthMod_apply( object item, object subject, string parameters ) {
    int modifier = 99 - StringToInt( GetSubString( parameters, 0, 2 ) );
    AddItemProperty( DURATION_TYPE_PERMANENT, ItemPropertyMaxRangeStrengthMod( modifier ), item );
}
void IPS_ItemProperty_MaxRangeStrengthMod_remove( object item, object subject, string parameters ) {
    Item_removeProperty( item, ITEM_PROPERTY_MIGHTY, -1 );
}

//- - - - - - - - - - - - - - Keen - - - - - - - - - - - - - - - - - - //
string IPS_ItemProperty_Keen_buildDescriptor();
string IPS_ItemProperty_Keen_buildDescriptor() {
    return IPS_ItemProperty_build( IPS_ItemProperty_Index_KEEN, IPS_ItemProperty_Attribute_BE_DYNAMIC, "" );
}
void IPS_ItemProperty_Keen_apply( object item, object subject, string parameters ) {
//    SendMessageToPC( GetFirstPC(), "IPS_ItemProperty_Keen_apply: paso"  );
    int featId = Item_GetWeaponImprovedCriticalBonusFeat( item );

    AddItemProperty( DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat( featId ), item );
    // Se asume que la propiedad Keen puede surgir en una municion pero no en el arma que la dispara
    if (featId == IP_CONST_FEAT_IMPROVED_CRITICAL_LONGBOW)
        AddItemProperty( DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat( IP_CONST_FEAT_IMPROVED_CRITICAL_SHORTBOW ), item );
    if (featId == IP_CONST_FEAT_IMPROVED_CRITICAL_HEAVY_CROSSBOW)
        AddItemProperty( DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat( IP_CONST_FEAT_IMPROVED_CRITICAL_LIGHT_CROSSBOW ), item );

    Item_removeProperty( item, ITEM_PROPERTY_KEEN ); // PROVISORIO HASTA QUE SE LES VAYA EL KEEN A TODAS LAS ARMAS ANTIGUAS
}
void IPS_ItemProperty_Keen_remove( object item, object subject, string parameters ) {
    int featId = Item_GetWeaponImprovedCriticalBonusFeat( item );
    Item_removeProperty( item, ITEM_PROPERTY_BONUS_FEAT, featId );
    if (featId == IP_CONST_FEAT_IMPROVED_CRITICAL_LONGBOW)
        Item_removeProperty( item, ITEM_PROPERTY_BONUS_FEAT, IP_CONST_FEAT_IMPROVED_CRITICAL_SHORTBOW );
    if (featId == IP_CONST_FEAT_IMPROVED_CRITICAL_HEAVY_CROSSBOW)
        Item_removeProperty( item, ITEM_PROPERTY_BONUS_FEAT, IP_CONST_FEAT_IMPROVED_CRITICAL_LIGHT_CROSSBOW );

    Item_removeProperty( item, ITEM_PROPERTY_KEEN ); // PROVISORIO HASTA QUE SE LES VAYA EL KEEN A TODAS LAS ARMAS ANTIGUAS
}

//- - - - - - - - - - - - - - CastSpell - - - - - - - - - - - - - - - - - - //
// spellId: IP_CONST_CASTSPELL_*
// numUsesId: IP_CONST_CASTSPELL_NUMUSES_*
string IPS_ItemProperty_CastSpell_buildDescriptor( int spellId, int numUsesId );
string IPS_ItemProperty_CastSpell_buildDescriptor( int spellId, int numUsesId ) {
    return IPS_ItemProperty_build( IPS_ItemProperty_Index_CAST_SPELL, IPS_ItemProperty_Attribute_BE_STATIC, B62_build2(spellId) + B62_build1(numUsesId) );
}
void IPS_ItemProperty_CastSpell_apply( object item, object subject, string parameters ) {
    int spellId = B62_toInt( GetSubString( parameters, 0, 2 ) );
    int numUses = B62_toInt( GetSubString( parameters, 2, 1 ) );
//    SendMessageToPC( GetFirstPC(), "IPS_ItemProperty_CastSpell_apply: spellId="+IntToString(spellId)+", numUses="+IntToString(numUses) );
    AddItemProperty( DURATION_TYPE_PERMANENT, ItemPropertyCastSpell( spellId, numUses ), item );
}
void IPS_ItemProperty_CastSpell_remove( object item, object subject, string parameters ) {
    int spellId = B62_toInt( GetSubString( parameters, 0, 2 ) );
    Item_removeProperty( item, ITEM_PROPERTY_CAST_SPELL, spellId );
}

//- - - - - - - - - - - - - - OnHitCastSpell - - - - - - - - - - - - - - - - - - //
// spellId: IP_CONST_ONHIT_CASTSPELL_*
// level: 1 to 61
string IPS_ItemProperty_OnHitCastSpell_buildDescriptor( int spellId, int level );
string IPS_ItemProperty_OnHitCastSpell_buildDescriptor( int spellId, int level ) {
    return IPS_ItemProperty_build( IPS_ItemProperty_Index_ON_HIT_CAST_SPELL, IPS_ItemProperty_Attribute_BE_DYNAMIC, B62_build2(spellId) + B62_build1(level) );
}
void IPS_ItemProperty_OnHitCastSpell_apply( object item, object subject, string parameters ) {
    int spellId = B62_toInt( GetSubString( parameters, 0, 2 ) );
    int level = B62_toInt( GetSubString( parameters, 2, 1 ) );
    AddItemProperty( DURATION_TYPE_PERMANENT, ItemPropertyOnHitCastSpell( spellId, level ), item );
}
void IPS_ItemProperty_OnHitCastSpell_remove( object item, object subject, string parameters ) {
    int spellId = B62_toInt( GetSubString( parameters, 0, 2 ) );
    Item_removeProperty( item, ITEM_PROPERTY_ONHITCASTSPELL, spellId );
}

//- - - - - - - - - - - - - - OnHitProps - - - - - - - - - - - - - - - - - - //
// propertyId: IP_CONST_ONHIT_*
// saveDC: IP_CONST_ONHIT_SAVEDC_*
// special: see 'ItemPropertyOnHitCastSpell()'
string IPS_ItemProperty_OnHitProps_buildDescriptor( int propertyId, int saveDC, int specialParam );
string IPS_ItemProperty_OnHitProps_buildDescriptor( int propertyId, int saveDC, int specialParam ) {
    return IPS_ItemProperty_build( IPS_ItemProperty_Index_ON_HIT_PROPS, IPS_ItemProperty_Attribute_BE_DYNAMIC, B62_build1(propertyId) + B62_build1(saveDC) + B62_build1(specialParam) );
}
void IPS_ItemProperty_OnHitProps_apply( object item, object subject, string parameters ) {
    int propertyId = B62_toInt( GetSubString( parameters, 0, 1 ) );
    int saveDC = B62_toInt( GetSubString( parameters, 1, 1 ) );
    int specialParam = B62_toInt( GetSubString( parameters, 2, 1 ) );
    AddItemProperty( DURATION_TYPE_PERMANENT, ItemPropertyOnHitProps( propertyId, saveDC, specialParam ), item );
}
void IPS_ItemProperty_OnHitProps_remove( object item, object subject, string parameters ) {
    int propertyId = B62_toInt( GetSubString( parameters, 0, 1 ) );
    Item_removeProperty( item, ITEM_PROPERTY_ON_HIT_PROPERTIES, propertyId );
}

//- - - - - - - - - - - - - - AbilityBonus - - - - - - - - - - - - - - - - - - //
string IPS_ItemProperty_AbilityBonus_buildDescriptor( int abilityId, int bonus );
string IPS_ItemProperty_AbilityBonus_buildDescriptor( int abilityId, int bonus ) {
    return IPS_ItemProperty_build( IPS_ItemProperty_Index_ABILITY_BONUS, IPS_ItemProperty_Attribute_BE_INTERACT, IntToString(9-abilityId) + IntToString(99-bonus) );
}
void IPS_ItemProperty_AbilityBonus_apply( object item, object subject, string parameters ) {
    string abilityIdCode = GetSubString( parameters, 0, 1 );
    int abilityId = 9 - StringToInt( abilityIdCode );
    int bonus = 99 - StringToInt( GetSubString( parameters, 1, 2 ) );
    if( subject == OBJECT_INVALID )
        AddItemProperty( DURATION_TYPE_PERMANENT, ItemPropertyAbilityBonus( abilityId, bonus ), item );
    else {
        string maxBonusRef = "AbilityBonus" + abilityIdCode;
        int maxBonus = GetLocalInt( subject, maxBonusRef );
        int bonusIncrease = bonus - maxBonus;
        if( bonusIncrease > 0 ) {
            SetLocalInt( subject, maxBonusRef, bonus );
            AddItemProperty( DURATION_TYPE_PERMANENT, ItemPropertyAbilityBonus( abilityId, bonusIncrease ), item );
        }
    }
}
void IPS_ItemProperty_AbilityBonus_remove( object item, object subject, string parameters ) {
    string abilityIdCode = GetSubString( parameters, 0, 1 );
    int abilityId = 9 - StringToInt( abilityIdCode );
    Item_removeProperty( item, ITEM_PROPERTY_ABILITY_BONUS, abilityId );
    if( subject != OBJECT_INVALID )
        DeleteLocalInt( subject, "AbilityBonus" + abilityIdCode );
}

//- - - - - - - - - - - - - - BonusSavingThrow - - - - - - - - - - - - - - - - - - //
string IPS_ItemProperty_BonusSavingThrow_buildDescriptor( int saveBaseType, int bonus );
string IPS_ItemProperty_BonusSavingThrow_buildDescriptor( int saveBaseType, int bonus ) {
    return IPS_ItemProperty_build( IPS_ItemProperty_Index_BONUS_SAVING_THROW, IPS_ItemProperty_Attribute_BE_INTERACT, IntToString(9-saveBaseType) + IntToString(99-bonus) );
}
void IPS_ItemProperty_BonusSavingThrow_applySpecific( object item, object subject, int saveBaseType, int bonus ) {
    if( subject == OBJECT_INVALID )
        AddItemProperty( DURATION_TYPE_PERMANENT, ItemPropertyBonusSavingThrow( saveBaseType, bonus ), item );
    else {
        string maxBonusRef = "BonusSavingThrow" + IntToString(saveBaseType);
        int maxBonus = GetLocalInt( subject, maxBonusRef );
        int bonusIncrease = bonus - maxBonus;
        if( bonusIncrease > 0 ) {
            SetLocalInt( subject, maxBonusRef, bonus );
            AddItemProperty( DURATION_TYPE_PERMANENT, ItemPropertyBonusSavingThrow( saveBaseType, bonusIncrease ), item );
        }
    }
}
void IPS_ItemProperty_BonusSavingThrow_apply( object item, object subject, string parameters ) {
    int saveBaseType = 9 - StringToInt( GetSubString( parameters, 0, 1 ) );
    int bonus = 99 - StringToInt( GetSubString( parameters, 1, 2 ) );
    if( saveBaseType == IP_CONST_SAVEVS_UNIVERSAL ) {
        IPS_ItemProperty_BonusSavingThrow_applySpecific( item, subject, IP_CONST_SAVEBASETYPE_FORTITUDE, bonus );
        IPS_ItemProperty_BonusSavingThrow_applySpecific( item, subject, IP_CONST_SAVEBASETYPE_REFLEX, bonus );
        IPS_ItemProperty_BonusSavingThrow_applySpecific( item, subject, IP_CONST_SAVEBASETYPE_WILL, bonus );
    }
    else
        IPS_ItemProperty_BonusSavingThrow_applySpecific( item, subject, saveBaseType, bonus );
}
void IPS_ItemProperty_BonusSavingThrow_removeSpecific( object item, object subject, int saveBaseType ) {
    string maxBonusRef = "BonusSavingThrow" + IntToString(saveBaseType);
    Item_removeProperty( item, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, saveBaseType );
    if( subject != OBJECT_INVALID )
       DeleteLocalInt( subject, maxBonusRef );
}
void IPS_ItemProperty_BonusSavingThrow_remove( object item, object subject, string parameters ) {
    int saveBaseType = 9 - StringToInt( GetSubString( parameters, 0, 1 ) );
    if( saveBaseType == IP_CONST_SAVEVS_UNIVERSAL ) {
        IPS_ItemProperty_BonusSavingThrow_removeSpecific( item, subject, IP_CONST_SAVEBASETYPE_FORTITUDE );
        IPS_ItemProperty_BonusSavingThrow_removeSpecific( item, subject, IP_CONST_SAVEBASETYPE_REFLEX );
        IPS_ItemProperty_BonusSavingThrow_removeSpecific( item, subject, IP_CONST_SAVEBASETYPE_WILL );
    }
    else
        IPS_ItemProperty_BonusSavingThrow_removeSpecific( item, subject, saveBaseType );
}

//- - - - - - - - - - - - - - ACBonus - - - - - - - - - - - - - - - - - - //
string IPS_ItemProperty_ACBonus_buildDescriptor( int bonus );
string IPS_ItemProperty_ACBonus_buildDescriptor( int bonus ) {
    return IPS_ItemProperty_build( IPS_ItemProperty_Index_AC_BONUS, IPS_ItemProperty_Attribute_BE_DYNAMIC, IntToString(99-bonus) );
}
void IPS_ItemProperty_ACBonus_apply( object item, object subject, string parameters ) {
    int bonus = 99 - StringToInt( GetSubString( parameters, 0, 2 ) );
    AddItemProperty( DURATION_TYPE_PERMANENT, ItemPropertyACBonus( bonus ), item );
}
void IPS_ItemProperty_ACBonus_remove( object item, object subject, string parameters ) {
    Item_removeProperty( item, ITEM_PROPERTY_AC_BONUS, -1 );
}

//- - - - - - - - - - - - - - EnhancementBonus - - - - - - - - - - - - - - - - - - //
string IPS_ItemProperty_EnhancementBonus_buildDescriptor( int bonus );
string IPS_ItemProperty_EnhancementBonus_buildDescriptor( int bonus ) {
    return IPS_ItemProperty_build( IPS_ItemProperty_Index_ENHANCEMENT_BONUS, IPS_ItemProperty_Attribute_BE_DYNAMIC, IntToString(99-bonus) );
}
void IPS_ItemProperty_EnhancementBonus_apply( object item, object subject, string parameters ) {
    int bonus = 99 - StringToInt( GetSubString( parameters, 0, 2 ) );
    AddItemProperty( DURATION_TYPE_PERMANENT, ItemPropertyEnhancementBonus( bonus ), item );
}
void IPS_ItemProperty_EnhancementBonus_remove( object item, object subject, string parameters ) {
    Item_removeProperty( item, ITEM_PROPERTY_ENHANCEMENT_BONUS, -1 );
}

//- - - - - - - - - - - - - - Vampiric regeneration - - - - - - - - - - - - - - - - - - //
// ammount: 1 to 20
string IPS_ItemProperty_VampiricRegeneration_buildDescriptor( int amount );
string IPS_ItemProperty_VampiricRegeneration_buildDescriptor( int amount ) {
    return IPS_ItemProperty_build( IPS_ItemProperty_Index_VAMPIRIC_REGENERATION, IPS_ItemProperty_Attribute_BE_DYNAMIC, IntToString(99-amount) );
}
void IPS_ItemProperty_VampiricRegeneration_apply( object item, object subject, string parameters ) {
    int amount = 99 - StringToInt( GetSubString( parameters, 0, 2 ) );
    AddItemProperty( DURATION_TYPE_PERMANENT, ItemPropertyVampiricRegeneration( amount ), item );
}
void IPS_ItemProperty_VampiricRegeneration_remove( object item, object subject, string parameters ) {
    Item_removeProperty( item, ITEM_PROPERTY_REGENERATION_VAMPIRIC, -1 );
}

//- - - - - - - - - - - - - - UnlimitedAmmo - - - - - - - - - - - - - - - - - - //
// ammoDamageId -> damage: 0 -> 0, 1->1, 2->2, 3->3, 4->4, 5->5
string IPS_ItemProperty_UnlimitedAmmo_buildDescriptor( int ammoDamageId );
string IPS_ItemProperty_UnlimitedAmmo_buildDescriptor( int ammoDamageId ) {
    switch( ammoDamageId ) {
        case 0: ammoDamageId = 1; break;
        case 1: case 2: case 3: case 4: case 5: ammoDamageId += 10; break;
        default: return "";
    }
    return IPS_ItemProperty_build( IPS_ItemProperty_Index_UNLIMITED_AMMO, IPS_ItemProperty_Attribute_BE_DYNAMIC, IntToString(99-ammoDamageId) );
}
void IPS_ItemProperty_UnlimitedAmmo_apply( object item, object subject, string parameters ) {
    int ammoDamageId = 99 - StringToInt( GetSubString( parameters, 0, 2 ) );
    AddItemProperty( DURATION_TYPE_PERMANENT, ItemPropertyUnlimitedAmmo( ammoDamageId ), item );
}
void IPS_ItemProperty_UnlimitedAmmo_remove( object item, object subject, string parameters ) {
    Item_removeProperty( item, ITEM_PROPERTY_UNLIMITED_AMMUNITION, -1 );
}

//- - - - - - - - - - - - - - SkillBonus - - - - - - - - - - - - - - - - - - //
string IPS_ItemProperty_SkillBonus_buildDescriptor( int skillId, int bonus );
string IPS_ItemProperty_SkillBonus_buildDescriptor( int skillId, int bonus ) {
    return IPS_ItemProperty_build( IPS_ItemProperty_Index_SKILL_BONUS, IPS_ItemProperty_Attribute_BE_INTERACT, B62_build1(skillId) + IntToString(99-bonus) );
}
void IPS_ItemProperty_SkillBonus_apply( object item, object subject, string parameters ) {
    string skillIdCode = GetSubString( parameters, 0, 1 );
    int skillId = B62_toInt( skillIdCode );
    int bonus = 99 - StringToInt( GetSubString( parameters, 1, 2 ) );
    if( subject == OBJECT_INVALID )
        AddItemProperty( DURATION_TYPE_PERMANENT, ItemPropertySkillBonus( skillId, bonus ), item );
    else {
        string maxBonusRef = "SkillBonus" + skillIdCode;
        int maxBonus = GetLocalInt( subject, maxBonusRef );
        int bonusIncrease = bonus - maxBonus;
        if( bonusIncrease > 0 ) {
            SetLocalInt( subject, maxBonusRef, bonus );
            AddItemProperty( DURATION_TYPE_PERMANENT, ItemPropertySkillBonus( skillId, bonusIncrease ), item );
        }
    }
}
void IPS_ItemProperty_SkillBonus_remove( object item, object subject, string parameters ) {
    string skillIdCode = GetSubString( parameters, 0, 1 );
    int skillId = B62_toInt( skillIdCode );
    Item_removeProperty( item, ITEM_PROPERTY_SKILL_BONUS, skillId );
    if( subject != OBJECT_INVALID )
        DeleteLocalInt( subject, "SkillBonus" + skillIdCode );
}

//- - - - - - - - - - - - - - WeightReduction - - - - - - - - - - - - - - - - - - //
// reducionIdx -> reduction: 1->20%, 2->40%, 3->60%, 4->80%, 5->100%
string IPS_ItemProperty_WeightReduction_buildDescriptor( int reductionIdx );
string IPS_ItemProperty_WeightReduction_buildDescriptor( int reductionIdx ) {
    return IPS_ItemProperty_build( IPS_ItemProperty_Index_WEIGHT_REDUCTION, IPS_ItemProperty_Attribute_BE_IRREMOVABLE, IntToString(9-reductionIdx) );
}
void IPS_ItemProperty_WeightReduction_apply( object item, object subject, string parameters ) {
    int reductionIdx = 9 - StringToInt( GetSubString( parameters, 0, 1 ) );
    AddItemProperty( DURATION_TYPE_PERMANENT, ItemPropertyWeightReduction( reductionIdx ), item );
}
void IPS_ItemProperty_WeightReduction_remove( object item, object subject, string parameters ) {
    Item_removeProperty( item, ITEM_PROPERTY_BASE_ITEM_WEIGHT_REDUCTION, -1 );
}

//- - - - - - - - - - - - - - DamageImmunityFisical - - - - - - - - - - - - - - - - - - //
// damageType: 0->bludgeoning, 1->piercing, 2->slashing, 3->subdual, 4->phisical
// percentageIdx -> %immunity : 1->10%, 2->19%, 3->27%, 4->34%, 5->41%, 6->47%, 7->52%, 8->57%, 9->61%, 10->65%
string IPS_ItemProperty_DamageImmunityFisical_buildDescriptor( int damageType, int percentageIdx );
string IPS_ItemProperty_DamageImmunityFisical_buildDescriptor( int damageType, int percentageIdx ) {
    return IPS_ItemProperty_build( IPS_ItemProperty_Index_DAMAGE_IMMUNITY_FISICAL, IPS_ItemProperty_Attribute_BE_INTERACT, IntToString(9-damageType) + IntToString(99-percentageIdx) );
}
void IPS_ItemProperty_DamageImmunityFisical_apply( object item, object subject, string parameters ) {
    string damageTypeCode = GetSubString( parameters, 0, 1 );
    int damageType = 9 - StringToInt( damageTypeCode );
    int percentageIdx = 99 - StringToInt( GetSubString( parameters, 1, 2 ) );
//    SendMessageToPC( GetFirstPC(), "IPS_ItemProperty_DamageImmunityFisical_apply: item="+GetName(item)+", damageType="+IntToString(damageType)+", percentageIdx="+IntToString(percentageIdx)+", isOI="+IntToString(subject==OBJECT_INVALID) );
    if( subject == OBJECT_INVALID )
        AddItemProperty( DURATION_TYPE_PERMANENT, ItemPropertyDamageImmunity( damageType, percentageIdx + 7 ), item ); // el 7 es porque la tabla de inmunidades usada acá empieza en la fila 8 del "iprp_immuncost.2da"
    else {
        string totalPercentageIdxRef = "DamageInmunityFisical" + damageTypeCode;
        int totalPercentageIdx = percentageIdx + GetLocalInt( subject, totalPercentageIdxRef ); // recordar que al desequipar un item, se resetean las variables...
        if( totalPercentageIdx > 10 )
            totalPercentageIdx = 10;
//        SendMessageToPC( GetFirstPC(), "totalPercentageIdx="+IntToString(percentageIdx) );
        SetLocalInt( subject, totalPercentageIdxRef, totalPercentageIdx );
        IPS_Subject_removePropertyOfAllEquipedItems( subject, ITEM_PROPERTY_IMMUNITY_DAMAGE_TYPE, damageType );
        AddItemProperty( DURATION_TYPE_PERMANENT, ItemPropertyDamageImmunity( damageType, totalPercentageIdx + 7 ), item ); // el 7 es porque la tabla de inmunidades usada acá empieza en la fila 8 del "iprp_immuncost.2da"
    }
}
void IPS_ItemProperty_DamageImmunityFisical_remove( object item, object subject, string parameters ) {
    string damageTypeCode = GetSubString( parameters, 0, 1 );
    int damageType = 9 - StringToInt( GetSubString( parameters, 0, 1 ) );
    Item_removeProperty( item, ITEM_PROPERTY_IMMUNITY_DAMAGE_TYPE, damageType );
//    SendMessageToPC( GetFirstPC(), "IPS_ItemProperty_DamageImmunityFisical_remove: item="+GetName(item)+", damageType="+IntToString(damageType) );
    if( subject != OBJECT_INVALID )
        DeleteLocalInt( subject, "DamageInmunityFisical" + damageTypeCode );
}

//- - - - - - - - - - - - - - DamageImmunityElemental - - - - - - - - - - - - - - - - - - //
// damageType: 0->magical, 1->acid, 2->cold, 3->divine, 4->electrical, 5->fire, 6->negative, 7->positive, 8->sonic
// percentageIdx -> %immunity : 1->10%, 2->19%, 3->27%, 4->34%, 5->41%, 6->47%, 7->52%, 8->57%, 9->61%, 10->65%
string IPS_ItemProperty_DamageImmunityElemental_buildDescriptor( int damageType, int percentageIdx );
string IPS_ItemProperty_DamageImmunityElemental_buildDescriptor( int damageType, int percentageIdx ) {
    return IPS_ItemProperty_build( IPS_ItemProperty_Index_DAMAGE_IMMUNITY_ELEMENTAL, IPS_ItemProperty_Attribute_BE_INTERACT, IntToString(9-damageType) + IntToString(99-percentageIdx) );
}
void IPS_ItemProperty_DamageImmunityElemental_apply( object item, object subject, string parameters ) {
    string damageTypeCode = GetSubString( parameters, 0, 1 );
    int damageType = 9 - StringToInt( damageTypeCode );
    int percentageIdx = 99 - StringToInt( GetSubString( parameters, 1, 2 ) );
    if( subject == OBJECT_INVALID )
        AddItemProperty( DURATION_TYPE_PERMANENT, ItemPropertyDamageImmunity( damageType + 5, percentageIdx + 7 ), item ); // El 5 es porque la tabla de tipos de daño usada acá empieza en MAGICAL que esta en la fila 5. El 7 es porque la tabla de inmunidades usada acá empieza en la fila 8 del "iprp_immuncost.2da"
    else {
        string totalPercentageIdxRef = "DamageInmunityElemental" + damageTypeCode;
        int totalPercentageIdx = percentageIdx + GetLocalInt( subject, totalPercentageIdxRef ); // recordar que al desequipar un item, se resetean las variables...
        if( totalPercentageIdx > 10 )
            totalPercentageIdx = 10;
//        SendMessageToPC( GetFirstPC(), "totalPercentageIdx="+IntToString(percentageIdx) );
        SetLocalInt( subject, totalPercentageIdxRef, totalPercentageIdx );
        IPS_Subject_removePropertyOfAllEquipedItems( subject, ITEM_PROPERTY_IMMUNITY_DAMAGE_TYPE, damageType + 5 );
        AddItemProperty( DURATION_TYPE_PERMANENT, ItemPropertyDamageImmunity( damageType + 5, totalPercentageIdx + 7 ), item ); // El 5 es porque la tabla de tipos de daño usada acá empieza en MAGICAL que esta en la fila 5. El 7 es porque la tabla de inmunidades usada acá empieza en la fila 8 del "iprp_immuncost.2da"
    }
}
void IPS_ItemProperty_DamageImmunityElemental_remove( object item, object subject, string parameters ) {
    string damageTypeCode = GetSubString( parameters, 0, 1 );
    int damageType = 9 - StringToInt( GetSubString( parameters, 0, 1 ) );
    Item_removeProperty( item, ITEM_PROPERTY_IMMUNITY_DAMAGE_TYPE, damageType + 5 );
    if( subject != OBJECT_INVALID )
        DeleteLocalInt( subject, "DamageInmunityElemental" + damageTypeCode );
}

//- - - - - - - - - - - - - - Fortification - - - - - - - - - - - - - - - - - - //
const string IPS_ItemProperty_Fortification_run_VN = "ipsFortificationRun";
const string IPS_ItemProperty_Fortification_isRunning_VN = "ipsFortificationIsRunning";

// percentageIdx: 1->10%, 2->20%,...,9->90%
string IPS_ItemProperty_Fortification_buildDescriptor( int percentageIdx );
string IPS_ItemProperty_Fortification_buildDescriptor( int percentageIdx ) {
    return IPS_ItemProperty_build( IPS_ItemProperty_Index_FORTIFICATION, IPS_ItemProperty_Attribute_BE_AWARE, IntToString(99-percentageIdx) );
}
void IPS_ItemProperty_Fortification_routine( int percentage, int isOn ) {
    if( GetLocalInt( OBJECT_SELF, IPS_ItemProperty_Fortification_run_VN ) ) {
        SetLocalInt( OBJECT_SELF, IPS_ItemProperty_Fortification_isRunning_VN, TRUE );
        int nextState = Random( 100 ) < percentage;
        if( !isOn && nextState )
            AddItemProperty( DURATION_TYPE_PERMANENT, ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_CRITICAL_HITS), OBJECT_SELF );
        else if( isOn && !nextState )
            Item_removeProperty( OBJECT_SELF, ITEM_PROPERTY_IMMUNITY_MISCELLANEOUS, IP_CONST_IMMUNITYMISC_CRITICAL_HITS );
        DelayCommand( 6.0, IPS_ItemProperty_Fortification_routine( percentage, nextState ) );
    }
    else {
        Item_removeProperty( OBJECT_SELF, ITEM_PROPERTY_IMMUNITY_MISCELLANEOUS, IP_CONST_IMMUNITYMISC_CRITICAL_HITS );
        SetLocalInt( OBJECT_SELF, IPS_ItemProperty_Fortification_isRunning_VN, FALSE );
    }
}
void IPS_ItemProperty_Fortification_apply( object item, object subject, string parameters ) {
    int percentageIdx = 99 - StringToInt( GetSubString( parameters, 0, 2 ) );
    AddItemProperty( DURATION_TYPE_PERMANENT, ItemPropertyImmunityMisc( percentageIdx + 9 ), item ); //  //  El 9 es porque la tabla de tipos de daño usada acá empieza en la fila 10. ver "iprp_immunity.2da"
    if( subject == OBJECT_INVALID ) // si el item esta siendo desequipado
        SetLocalInt( item, IPS_ItemProperty_Fortification_run_VN, FALSE ); // detener la rutina alternadora
    else if( Mod_isPcInitialized(subject) ) {
        if( !GetLocalInt( item, IPS_ItemProperty_Fortification_isRunning_VN ) ) { // si el item esta siendo equipado y la rutina alternadora no esta corriendo
            SetLocalInt( item, IPS_ItemProperty_Fortification_run_VN, TRUE ); // arrancar la rutina alternadora
            int percentage = percentageIdx * 10; //FloatToInt( 100.0*(1.0-pow( 0.9, IntToFloat(percentageIdx) ) ) );
            AssignCommand( item, IPS_ItemProperty_Fortification_routine( percentage, FALSE ) );
        }
    }
    else
        DeleteLocalInt( item, IPS_ItemProperty_Fortification_isRunning_VN );
}
void IPS_ItemProperty_Fortification_remove( object item, object subject, string parameters ) {
    SetLocalInt( item, IPS_ItemProperty_Fortification_run_VN, FALSE );
    Item_removeProperty( item, ITEM_PROPERTY_IMMUNITY_MISCELLANEOUS, -1 );
}
string IPS_ItemProperty_Fortification_inspect( object item, string parameters, int baseIdentifyDC, int subjectInspectSkill ) {
    if( subjectInspectSkill > baseIdentifyDC + 3 ) {
        int percentageIdx = 99 - StringToInt( GetSubString( parameters, 0, 2 ) );
        int percentage = percentageIdx * 10; //FloatToInt( 100.0*(1.0-pow( 0.9, IntToFloat(percentageIdx) ) ) );
        return "- propiedad benigna detectada: fortificación de "+IntToString(percentage)+"%";
    }
    return "";
}


///////////////////////////////////// CURSES ///////////////////////////////////
//- - - - - - - - - - - - - - ConfusionCurse - - - - - - - - - - - - - - - - - - //
const string IPS_ItemProperty_ConfusionCurse_theOnlyItemWithRoutineRuning_VN = "ipsConfusionTOIWRR"; // Usada para evitar que se aplique el efecto de esta propiedad (poner en marcha su rutina asociada) cuando ya fue aplicado por otra instancia de esta propiedad en algún otro item equipado por el 'subjet'. Hace referencia al ítem que tiene la instancia de esta propiedad con su rutina asociada en marcha. Si tal ítem es desequipado exitosamente, la referencia se cambia a otra instancia de esta propiedad que haya en un ítem equipado, y si no hay se cambia a OBJECT_INVALID..
const string IPS_ItemProperty_ConfusionCurse_run_VN = "ipsConfusionRun"; // marca que mantiene en marcha a la rutina asociada a esta instancia de la propiedad. Para evitar conflictos se decidió que si hay mas de una instancia de esta propiedad entre los ítems equipados por un sujeto, solo una de las instancias tenga la runtina en marcha. Por ende, siempre habrá solo una de tales instancias con esta marca en TRUE. Nota: dado que no es posible poner marcas en propiedades, la marca se guarda en el ítem. Esto no molesta porque se convino que no puede haber dos instancias de la misma propiedad en el mismo ítem.
const string IPS_ItemProperty_ConfusionCurse_isRunning_VN = "ipsConfusionIsRunning"; // marca que indica si la rutina asociada a esta instancia de la propiedad esta en marcha (ver 'IPS_ItemProperty_XXX_run_VN').

string IPS_ItemProperty_ConfusionCurse_buildDescriptor();
string IPS_ItemProperty_ConfusionCurse_buildDescriptor() {
    return IPS_ItemProperty_build( IPS_ItemProperty_Index_CONFUSION, IPS_ItemProperty_Attribute_BE_AWARE, "" );
}
void IPS_ItemProperty_ConfusionCurse_routine( object item, int previousDamage, int wasUnderEffect ) {
    object subject = OBJECT_SELF;
//    SendMessageToPC( GetFirstPC(), "routine begin - item="+GetName(item) );
    // si la maldicion esta latente o activa
    if( GetLocalInt( item, IPS_ItemProperty_ConfusionCurse_run_VN ) ) {
        SetLocalInt( item, IPS_ItemProperty_ConfusionCurse_isRunning_VN, TRUE );

        float nextBeatTime;
        int currentDamage = GetMaxHitPoints(subject)-GetCurrentHitPoints(subject);
//        SendMessageToPC( GetFirstPC(), "routine - wasUnderEffect="+IntToString(wasUnderEffect)+", previousDamage="+IntToString(previousDamage)+", currentDamage="+IntToString(currentDamage) );

        // si estaba bajo efecto en el muestreo anterior...
        if( wasUnderEffect ) {
            // y ahora ya no lo esta mas
            if( Confuse_isCurrentSuperposeable( subject ) ) {
                wasUnderEffect = FALSE;
                nextBeatTime = 6.0;
            }
            // y ahora lo sigue estando
            else {
                nextBeatTime = ( 2 + Confuse_getRemainingRounds( subject ) ) * 6.0;
            }
        }
        // si no estaba bajo el efecto en el muestreo anterior
        else {
            // si el PJ victima del curse recibe daño desde el ultimo beat y se aplicó el confusion con éxito
            if( currentDamage > previousDamage && Confuse_isCurrentSuperposeable( subject ) ) {
                // aplicar el efecto
                Confuse_applyAttackNearestCreatureAndAbsorbDamage( subject, 8, previousDamage );
                // marcar que la maldición fue despertada, cosa que a partir de ahora no se pueda desequipar el ítem.
                SetItemCursedFlag( item, TRUE );
                // programar el próximo beat para 6 seg después de que termine el efecto aplicado con 'Confuse_apply(..)'
                wasUnderEffect = TRUE;
                nextBeatTime = 54.0;  // == 6*8 + 6
            }
            // si el PJ victima del curse NO recibe daño desde el ultimo beat o se falló al aplicar la confusion (porque esta bajo el efecto de otra confusion que no tolera superposicion)
            else {
                nextBeatTime = 18.0;
            }
        }
        DelayCommand( nextBeatTime, IPS_ItemProperty_ConfusionCurse_routine( item, currentDamage, wasUnderEffect ) );
    }
    // si la maldicion fue removida
    else {
        SetLocalInt( item, IPS_ItemProperty_ConfusionCurse_isRunning_VN, FALSE );
//        SendMessageToPC( GetFirstPC(), "routine stopped" );
    }
//    SendMessageToPC( GetFirstPC(), "routine end - wasUnderEffect="+IntToString(wasUnderEffect) );
}
void IPS_ItemProperty_ConfusionCurse_startRuotine( object item, object subject ) {
//    SendMessageToPC( GetFirstPC(), "startRoutine begin" );
    // poner la marca que mantiene la rutina en marcha, y de estar la rutina detenida, ponerla en marcha
    SetLocalInt( item, IPS_ItemProperty_ConfusionCurse_run_VN, TRUE ); // mantener la rutina en marcha
    if( !GetLocalInt( item, IPS_ItemProperty_ConfusionCurse_isRunning_VN ) ) {
//        SendMessageToPC( GetFirstPC(), "startRoutine started" );
        AssignCommand( subject, IPS_ItemProperty_ConfusionCurse_routine(
            item,
            GetMaxHitPoints(subject)-GetCurrentHitPoints(subject),
            FALSE
        ) );
    }
    // recordar cual de los ítems equipados es el que tiene la rutina en marcha
    SetLocalObject( subject, IPS_ItemProperty_ConfusionCurse_theOnlyItemWithRoutineRuning_VN, item );
//    SendMessageToPC( GetFirstPC(), "startRoutine end" );
}
void IPS_ItemProperty_ConfusionCurse_apply( object item, object subject )
    // Recordar que, dado que esta es una propiedad AWARE, el IPS llama a esta rutina cuando:
    //  si 'subject==portador', el item es equipado o el PJ es cargado del vault con el item equipado. Independientemente de si el item estaba identificado o no.
    //  si 'subject==OBJECT_INVALID', el ítem esta desequipado y es estudiado, o  el ítem esta conocido y es desequipado
{
//    SendMessageToPC( GetFirstPC(), "apply begin - item="+GetName(item) );
    // si el item es equipado o el PJ es cargado del vault con el item equipado (independientemente de si el item estaba identificado o no).
    if( subject != OBJECT_INVALID ) {
//        SendMessageToPC( GetFirstPC(), "apply equiped 1- runningRoutine="+GetName(GetLocalObject( subject, IPS_ItemProperty_ConfusionCurse_theOnlyItemWithRoutineRuning_VN ) ) );
        // si el item es equipado
        if( Mod_isPcInitialized(subject) ) {
//            SendMessageToPC( GetFirstPC(), "apply equiped 1-1" );
            // si el ítem fue reequipado automaticamente por el IPS porque el PJ intentó quitarselo, dañar al PJ
            if( GetLocalInt( item, IPS_Item_hasBeenTriedToRemove_VN) ) {
                if( GetIsObjectValid( GetArea( subject ) ) ) // este if evita hacer daño durante las transiciones de área porque oí por ahi que culega el servidor.
                    ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectDamage( GetCurrentHitPoints(subject)/2 ), subject );
            }
            // sino, borrar la marca de que su rutina esta en marcha, que pudo haber quedado de una caida del servidor.
            else
                DeleteLocalInt( item, IPS_ItemProperty_ConfusionCurse_isRunning_VN );

            // si no hay otro ítem equipado con una instancia de esta propiedad que tenga su rutina en marcha
            if( !GetIsObjectValid( GetLocalObject( subject, IPS_ItemProperty_ConfusionCurse_theOnlyItemWithRoutineRuning_VN ) ) )
                // poner la rutina asociada a esta instancia de Confusion en marcha, si es que no lo esta actualmente.
                IPS_ItemProperty_ConfusionCurse_startRuotine( item, subject );
        }
        // si el PJ es cargado del vault con el item equipado
        else {
//            SendMessageToPC( GetFirstPC(), "apply equiped 1-2" );
            // Borrar la marca de que la rutina esta en marcha (ya que no lo esta) para permitir que sea puesta en marcha luego.
            DeleteLocalInt( item, IPS_ItemProperty_ConfusionCurse_isRunning_VN );
            DeleteLocalObject( subject, IPS_ItemProperty_ConfusionCurse_theOnlyItemWithRoutineRuning_VN );
        }
//        SendMessageToPC( GetFirstPC(), "apply equiped 2- runningRoutine="+GetName(GetLocalObject( subject, IPS_ItemProperty_ConfusionCurse_theOnlyItemWithRoutineRuning_VN ) ) );
    }
    // si el item esta conocido y es desequipado
//    else
//        SendMessageToPC( GetFirstPC(), "apply not equiped" );
    // Notar que no se hace nada cuando el ítem esta desequipado y es estudiado, ni cuando el ítem esta conocido y es desequipado.
    // Notar tambien que la rutina no se detiene al desequipar el ítem
//    SendMessageToPC( GetFirstPC(), "apply end - item="+GetName(item) );
}
void IPS_ItemProperty_ConfusionCurse_remove( object item, object subject )
    // Recordar que para una propiedad AWARE como lo es ésta, esta operación es llamada por el IPS cuando:
    // - el ítem esta desconocido y es desequipado, o esta desequipado y es desestudiado
    // - el ítem esta conocido y es desequipado. Luego esta propiedad es vuelta a activar con el parametro 'subject' inválido.
{
    // dado que esta operación es llamada incluso aunque el ítem tenga alguna propiedad cursed despierta, cosa que obliga al IPS a reequiparlo automáticamente, es mejor realizar el quite del efecto (detener la rutina) en 'IPS_ItemProperty_XXX_removeCurse(..)', ya que esa operación solo es llamada cuando el ítem es desequipado exitosamente.
}
void IPS_ItemProperty_ConfusionCurse_removeCurse( object item, object subject )
    // Esta opearcion es llamada por el IPS cuando 'item' tiene el flag 'IPS_ITEM_FLAG_IS_CURSED' y es desequipado exitosamente, cosa que sucede cuando ninguna de las instancias de propiedades malignas esta despierta o 'subject' tenia la marca 'IPS_Subject_isRemoveCurseInEffect_VN' en TRUE cuando desequipó el ítem.
{
    // si el ítem que pudo ser desequipado gracias a un remove curse es el que tiene la rutina en marcha
    if( item == GetLocalObject( subject, IPS_ItemProperty_ConfusionCurse_theOnlyItemWithRoutineRuning_VN ) ) {
        // detener su rutina
        DeleteLocalInt( item, IPS_ItemProperty_ConfusionCurse_run_VN );
        // averiguar si hay otra intancia de esta propiedad en algún otro ítem de los equipado por 'subject', y de haberla, poner en marcha la rutina de tal instancia cosa que mientras haya una instancia de esta propiead en algún ítem equipado, siempre haya una y solo una rutina en marcha.
        int slotIterator = NUM_INVENTORY_SLOTS;
        while( --slotIterator >= 0 ) {
            object itemIterator = GetItemInSlot( slotIterator, subject );
            if( GetIsObjectValid(itemIterator) && itemIterator != item && IPS_ItemProperty_getDescriptorAt( IPS_ItemProperty_Index_CONFUSION, itemIterator ) != "" ) {
                // poner la rutina asociada a esta instancia de Confusion en marcha, si es que no lo esta actualmente.
                IPS_ItemProperty_ConfusionCurse_startRuotine( itemIterator, subject );
                return;
            }
        }
        // si además de esta instancia no hay ningúna otra instancia de esta propiedad en alguno de los ítems equipados por 'subject', borrar la referencia al ítem con rutina en marcha.
        DeleteLocalObject( subject, IPS_ItemProperty_ConfusionCurse_theOnlyItemWithRoutineRuning_VN );
    }
}

//- - - - - - - - - - - - - - HostilityCurse - - - - - - - - - - - - - - - - - - //
const string IPS_ItemProperty_HostilityCurse_theOnlyItemWithRoutineRuning_VN = "ipsHostilityTOIWRR"; // Usada para evitar que se aplique el efecto de esta propiedad (poner en marcha su rutina asociada) cuando ya fue aplicado por otra instancia de esta propiedad en algún otro item equipado por el 'subjet'. Hace referencia al ítem que tiene la instancia de esta propiedad con su rutina asociada en marcha. Si tal ítem es desequipado exitosamente, la referencia se cambia a otra instancia de esta propiedad que haya en un ítem equipado, y si no hay se cambia a OBJECT_INVALID..
const string IPS_ItemProperty_HostilityCurse_run_VN = "ipsHostilityRun"; // marca que mantiene en marcha a la rutina asociada a esta instancia de la propiedad. Para evitar conflictos se decidió que si hay mas de una instancia de esta propiedad entre los ítems equipados por un sujeto, solo una de las instancias tenga la runtina en marcha. Por ende, siempre habrá solo una de tales instancias con esta marca en TRUE. Nota: dado que no es posible poner marcas en propiedades, la marca se guarda en el ítem. Esto no molesta porque se convino que no puede haber dos instancias de la misma propiedad en el mismo ítem.
const string IPS_ItemProperty_HostilityCurse_isRunning_VN = "ipsHostilityIsRunning"; // marca que indica si la rutina asociada a esta instancia de la propiedad esta en marcha (ver 'IPS_ItemProperty_XXX_run_VN').
const string IPS_ItemProperty_HostilityCurse_previousXpSample_VN = "ipsHostilityPXS"; // recuerda cuanta XP transitoria tenia el PJ portador del ítem en el muestreo anterior.

string IPS_ItemProperty_HostilityCurse_buildDescriptor();
string IPS_ItemProperty_HostilityCurse_buildDescriptor() {
//    SendMessageToPC( GetFirstPC(), "con hostility" );
    return IPS_ItemProperty_build( IPS_ItemProperty_Index_HOSTILITY, IPS_ItemProperty_Attribute_BE_AWARE, "" );
}
void IPS_ItemProperty_HostilityCurse_perform(object item, int willDc) {
    object subject = OBJECT_SELF;
    if( GetIsInCombat( subject ) )
        DelayCommand( 20.0, IPS_ItemProperty_HostilityCurse_perform( item, willDc ) );
    else {
        SpeakString( "*Patalea muy sacado y se dirige intimidante y agresivo a su equipo* ¿Nadie sabe hacer nada bien? ¿Porque tengo que hacer todo el trabajo yo solo? ¡¡SON UNOS MALDITOS INEPTOS!! Debería acavar con ustedes y buscar a alguien que colabore." );
        object partyMemberIterator = GetFirstFactionMember( subject, FALSE );
        while( partyMemberIterator != OBJECT_INVALID ) {
            int associateType = GetAssociateType( partyMemberIterator );
            if(
                partyMemberIterator != subject
                && ( associateType == ASSOCIATE_TYPE_HENCHMAN  || associateType == ASSOCIATE_TYPE_NONE )
                && GetArea(subject) == GetArea(partyMemberIterator)
                && GetDistanceToObject(partyMemberIterator) < 50.0  // se eligio 50 porque es la distancia a la que ven los PJs.
                && Confuse_isCurrentSuperposeable( partyMemberIterator )
                && WillSave( partyMemberIterator, willDc, SAVING_THROW_TYPE_MIND_SPELLS, item )
            ) {
                AssignCommand( partyMemberIterator, ActionSpeakString( "¡Maldito gusano! ¡Voy a enterrar tu mugrosa bocota! *fuera de si*" ) );
                Confuse_applyAttackSpecifiedCreature( partyMemberIterator, 8, subject );
                ApplyEffectToObject( DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DOMINATED), partyMemberIterator, 8.0*6.0 );
            }
            partyMemberIterator = GetNextFactionMember( subject, FALSE );
        }
    }
}
void IPS_ItemProperty_HostilityCurse_routine( object item, int willDc ) {
    object subject = OBJECT_SELF;
//    SendMessageToPC( GetFirstPC(), "hostility routine begin - "+GetName(item)  );
    // si la maldicion esta latente o activa
    if( GetLocalInt( item, IPS_ItemProperty_HostilityCurse_run_VN ) ) {
        SetLocalInt( item, IPS_ItemProperty_HostilityCurse_isRunning_VN, TRUE );

        // contar cuantos compañeros cercanos hay
        int numberOfPartners = -1; // el menos uno es para descontar al PJ mismo en la cuenta de miembros del party.
        object partyMemberIterator = GetFirstFactionMember( subject, FALSE );
        while( partyMemberIterator != OBJECT_INVALID ) {
            int associateType = GetAssociateType( partyMemberIterator );
            if(
                ( associateType == ASSOCIATE_TYPE_HENCHMAN  || associateType == ASSOCIATE_TYPE_NONE )
                && GetArea(subject) == GetArea(partyMemberIterator)
                && GetDistanceToObject(partyMemberIterator) < 50.0  // se eligio 50 porque es la distancia a la que ven los PJs.
            ) {
                numberOfPartners += 1;
            }
            partyMemberIterator = GetNextFactionMember( subject, FALSE );
        }

        // Si el portador del ítem anda solo (no tiene compañeros PJ ni henchmens), dañarlo con la escusa de soledad.
        if( numberOfPartners == 0 && ( GetItemCursedFlag( item ) || Random(4) == 0 )) {
            SendMessageToPC( subject, "*La soledad te esta deprimiendo al punto de quitarte fuerza vital. Y el compararte con quienes suelen andar en grupo, te provoca mucha envidia.*" );
            if( GetIsObjectValid( GetArea( subject ) ) ) // este if evita hacer daño durante las transiciones de área porque oí por ahi que culega el servidor.
                ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectDamage( 1+GetCurrentHitPoints(subject)/6 ), subject );
            SetItemCursedFlag( item, TRUE );
        }
        else if( numberOfPartners == 1 && ( GetItemCursedFlag( item ) || Random(4) == 0 ) ) {
            SendMessageToPC( subject, "*Un compañero es mejor que estar solo, pero no es suficiente. Tu necesidad de mas compañia te tortura." );
            if( GetIsObjectValid( GetArea( subject ) ) )// este if evita hacer daño durante las transiciones de área porque oí por ahi que culega el servidor.
                ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectDamage( GetCurrentHitPoints(subject)/12 ), subject );
            SetItemCursedFlag( item, TRUE );
        }
        else if( numberOfPartners > 1 ) {
            int previousXpSample = GetLocalInt( subject, IPS_ItemProperty_HostilityCurse_previousXpSample_VN );
            int currentXpSample = GetLocalInt( subject, SPC_xpTransitoriaPorMil_VN );
            if( previousXpSample > currentXpSample )
                SetLocalInt( subject, IPS_ItemProperty_HostilityCurse_previousXpSample_VN, currentXpSample );
            else if( currentXpSample > previousXpSample + 100 + Random(800) ) {
                SetLocalInt( subject, IPS_ItemProperty_HostilityCurse_previousXpSample_VN, currentXpSample );
                SetItemCursedFlag( item, TRUE );
                IPS_ItemProperty_HostilityCurse_perform( item, willDc);
            }
        }

        DelayCommand( 360.0, IPS_ItemProperty_HostilityCurse_routine( item, willDc ) );
    }
    // si la maldicion fue removida
    else {
        SetLocalInt( item, IPS_ItemProperty_HostilityCurse_isRunning_VN, FALSE );
//        SendMessageToPC( GetFirstPC(), "routine curse removed" );
    }
//    SendMessageToPC( GetFirstPC(), "hostility routine end" );
}
void IPS_ItemProperty_HostilityCurse_startRuotine( object item, object subject ) {
//    SendMessageToPC( GetFirstPC(), "startRoutine begin" );
    // poner la marca que mantiene la rutina en marcha, y de estar la rutina detenida, ponerla en marcha
    SetLocalInt( item, IPS_ItemProperty_HostilityCurse_run_VN, TRUE ); // mantener la rutina en marcha
    if( !GetLocalInt( item, IPS_ItemProperty_HostilityCurse_isRunning_VN ) ) {
//        SendMessageToPC( GetFirstPC(), "startRoutine started" );
        int willDc = 10+FloatToInt(IPS_Item_getCr(item));
        DelayCommand( IntToFloat(Random(60)), AssignCommand( subject, IPS_ItemProperty_HostilityCurse_routine( item, willDc ) ) );
    }
    // recordar cual de los ítems equipados es el que tiene la rutina en marcha
    SetLocalObject( subject, IPS_ItemProperty_HostilityCurse_theOnlyItemWithRoutineRuning_VN, item );
//    SendMessageToPC( GetFirstPC(), "startRoutine end" );
}

void IPS_ItemProperty_HostilityCurse_apply( object item, object subject )
    // Recordar que, dado que esta es una propiedad AWARE, el IPS llama a esta rutina cuando:
    //  si 'subject==portador', el item es equipado o el PJ es cargado del vault con el item equipado. Independientemente de si el item estaba identificado o no.
    //  si 'subject==OBJECT_INVALID', el ítem esta desequipado y es estudiado, o  el ítem esta conocido y es desequipado
{
//    SendMessageToPC( GetFirstPC(), "apply begin - item="+GetName(item) );
    // si el item es equipado o el PJ es cargado del vault con el item equipado (independientemente de si el item estaba identificado o no).
    if( subject != OBJECT_INVALID ) {
//        SendMessageToPC( GetFirstPC(), "apply equiped 1- runningRoutine="+GetName(GetLocalObject( subject, IPS_ItemProperty_HostilityCurse_theOnlyItemWithRoutineRuning_VN ) ) );
        // si el item es equipado
        if( Mod_isPcInitialized(subject) ) {
//            SendMessageToPC( GetFirstPC(), "apply equiped 1-1" );
            // si el ítem fue reequipado automaticamente por el IPS porque el PJ intentó quitarselo, dañar al PJ
            if( GetLocalInt( item, IPS_Item_hasBeenTriedToRemove_VN) ) {
                if( GetIsObjectValid( GetArea( subject ) ) ) // este if evita hacer daño durante las transiciones de área porque oí por ahi que culega el servidor.
                    AssignCommand( item, ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectDamage( GetCurrentHitPoints(subject)/2 ), subject ) );
            }
            // sino, borrar la marca de que su rutina esta en marcha, que pudo haber quedado de una caida del servidor.
            else
                DeleteLocalInt( item, IPS_ItemProperty_HostilityCurse_isRunning_VN );

            // si no hay otro ítem equipado con una instancia de esta propiedad que tenga su rutina en marcha
            if( !GetIsObjectValid( GetLocalObject( subject, IPS_ItemProperty_HostilityCurse_theOnlyItemWithRoutineRuning_VN ) ) )
                // poner la rutina asociada a esta instancia de Hostility en marcha, si es que no lo esta actualmente.
                IPS_ItemProperty_HostilityCurse_startRuotine( item, subject );
        }
        // si el PJ es cargado del vault con el item equipado
        else {
//            SendMessageToPC( GetFirstPC(), "apply equiped 1-2" );
            // Borrar la marca de que la rutina esta en marcha (ya que no lo esta) para permitir que sea puesta en marcha luego.
            DeleteLocalInt( item, IPS_ItemProperty_HostilityCurse_isRunning_VN );
            DeleteLocalObject( subject, IPS_ItemProperty_HostilityCurse_theOnlyItemWithRoutineRuning_VN );
        }
//        SendMessageToPC( GetFirstPC(), "apply equiped 2- runningRoutine="+GetName(GetLocalObject( subject, IPS_ItemProperty_HostilityCurse_theOnlyItemWithRoutineRuning_VN ) ) );
    }
    // si el item esta conocido y es desequipado
    else {
//        SendMessageToPC( GetFirstPC(), "apply not equiped" );
    }
    // Notar que no se hace nada cuando el ítem esta desequipado y es estudiado, ni cuando el ítem esta conocido y es desequipado.
    // Notar tambien que la rutina no se detiene al desequipar el ítem
//    SendMessageToPC( GetFirstPC(), "apply end - item="+GetName(item) );
}
void IPS_ItemProperty_HostilityCurse_remove( object item, object subject )
    // Recordar que para una propiedad AWARE como lo es ésta, esta operación es llamada por el IPS cuando:
    // - el ítem esta desconocido y es desequipado, o esta desequipado y es desestudiado
    // - el ítem esta conocido y es desequipado. Luego esta propiedad es vuelta a activar con el parametro 'subject' inválido.
{
    // dado que esta operación es llamada incluso aunque el ítem tenga alguna propiedad cursed despierta, cosa que obliga al IPS a reequiparlo automáticamente, es mejor realizar el quite del efecto (detener la rutina) en 'IPS_ItemProperty_XXX_removeCurse(..)', ya que esa operación solo es llamada cuando el ítem es desequipado exitosamente.
}
void IPS_ItemProperty_HostilityCurse_removeCurse( object item, object subject )
    // Esta opearcion es llamada por el IPS cuando 'item' tiene el flag 'IPS_ITEM_FLAG_IS_CURSED' y es desequipado exitosamente, cosa que sucede cuando ninguna de las instancias de propiedades malignas esta despierta o 'subject' tenia la marca 'IPS_Subject_isRemoveCurseInEffect_VN' en TRUE cuando desequipó el ítem.
{
    // si el ítem que pudo ser desequipado gracias a un remove curse es el que tiene la rutina en marcha
    if( item == GetLocalObject( subject, IPS_ItemProperty_HostilityCurse_theOnlyItemWithRoutineRuning_VN ) ) {
        // detener su rutina
        DeleteLocalInt( item, IPS_ItemProperty_HostilityCurse_run_VN );
        // averiguar si hay otra intancia de esta propiedad en algún otro ítem de los equipado por 'subject', y de haberla, poner en marcha la rutina de tal instancia cosa que mientras haya una instancia de esta propiead en algún ítem equipado, siempre haya una y solo una rutina en marcha.
        int slotIterator = NUM_INVENTORY_SLOTS;
        while( --slotIterator >= 0 ) {
            object itemIterator = GetItemInSlot( slotIterator, subject );
            if( GetIsObjectValid(itemIterator) && itemIterator != item && IPS_ItemProperty_getDescriptorAt( IPS_ItemProperty_Index_HOSTILITY, itemIterator ) != "" ) {
                // poner la rutina asociada a esta instancia de Hostility en marcha, si es que no lo esta actualmente.
                IPS_ItemProperty_HostilityCurse_startRuotine( itemIterator, subject );
                return;
            }
        }
        // si además de esta instancia no hay ningúna otra instancia de esta propiedad en alguno de los ítems equipados por 'subject', borrar la referencia al ítem con rutina en marcha.
        DeleteLocalObject( subject, IPS_ItemProperty_HostilityCurse_theOnlyItemWithRoutineRuning_VN );
    }
}


//////////////////////////////// ItemProperty Dispatchers //////////////////////////////

int IPS_ItemProperty_getAttributes( string propertyDescriptor );
int IPS_ItemProperty_getAttributes( string propertyDescriptor ) {
    return StringToInt( GetSubString( propertyDescriptor, IPS_ItemProperty_ATTRIBUTES_OFFSET, IPS_ItemProperty_ATTRIBUTES_WIDTH ) );
}

void IPS_ItemProperty_apply( string itemProperty, object item, object subject ) {

    int propertyIndex = B62_toInt( GetSubString( itemProperty, IPS_ItemProperty_INDEX_OFFSET, IPS_ItemProperty_INDEX_WIDTH ) );
    string parameters = GetSubString( itemProperty, IPS_ItemProperty_PARAMETERS_OFFSET, IPS_ItemProperty_PARAMETERS_WIDTH );

    switch( propertyIndex ) {
        case IPS_ItemProperty_Index_ATTACK_BONUS:
                 IPS_ItemProperty_AttackBonus_apply( item, subject, parameters );
            break;
        case IPS_ItemProperty_Index_DAMAGE_BONUS:
                 IPS_ItemProperty_DamageBonus_apply( item, subject, parameters );
            break;
        case IPS_ItemProperty_Index_BONUS_FEAT:
                 IPS_ItemProperty_BonusFeat_apply( item, subject, parameters );
            break;
        case IPS_ItemProperty_Index_MAX_RANGE_STRENGHT_MOD:
                 IPS_ItemProperty_MaxRangeStrengthMod_apply( item, subject, parameters );
            break;
        case IPS_ItemProperty_Index_KEEN:
                 IPS_ItemProperty_Keen_apply( item, subject, parameters );
            break;
        case IPS_ItemProperty_Index_CAST_SPELL:
                 IPS_ItemProperty_CastSpell_apply( item, subject, parameters );
            break;
        case IPS_ItemProperty_Index_ON_HIT_CAST_SPELL:
                 IPS_ItemProperty_OnHitCastSpell_apply( item, subject, parameters );
            break;
        case IPS_ItemProperty_Index_ON_HIT_PROPS:
                 IPS_ItemProperty_OnHitProps_apply( item, subject, parameters );
            break;
        case IPS_ItemProperty_Index_ABILITY_BONUS:
                 IPS_ItemProperty_AbilityBonus_apply( item, subject, parameters );
            break;
        case IPS_ItemProperty_Index_BONUS_SAVING_THROW:
                 IPS_ItemProperty_BonusSavingThrow_apply( item, subject, parameters );
            break;
        case IPS_ItemProperty_Index_AC_BONUS:
                 IPS_ItemProperty_ACBonus_apply( item, subject, parameters );
            break;
        case IPS_ItemProperty_Index_ENHANCEMENT_BONUS:
                 IPS_ItemProperty_EnhancementBonus_apply( item, subject, parameters );
            break;
        case IPS_ItemProperty_Index_VAMPIRIC_REGENERATION:
                 IPS_ItemProperty_VampiricRegeneration_apply( item, subject, parameters );
            break;
        case IPS_ItemProperty_Index_UNLIMITED_AMMO:
                 IPS_ItemProperty_UnlimitedAmmo_apply( item, subject, parameters );
            break;
        case IPS_ItemProperty_Index_SKILL_BONUS:
                 IPS_ItemProperty_SkillBonus_apply( item, subject, parameters );
            break;
        case IPS_ItemProperty_Index_WEIGHT_REDUCTION:
                 IPS_ItemProperty_WeightReduction_apply( item, subject, parameters );
            break;
        case IPS_ItemProperty_Index_DAMAGE_IMMUNITY_FISICAL:
                 IPS_ItemProperty_DamageImmunityFisical_apply( item, subject, parameters );
            break;
        case IPS_ItemProperty_Index_DAMAGE_IMMUNITY_ELEMENTAL:
                 IPS_ItemProperty_DamageImmunityElemental_apply( item, subject, parameters );
            break;
        case IPS_ItemProperty_Index_FORTIFICATION:
                 IPS_ItemProperty_Fortification_apply( item, subject, parameters );
            break;
        case IPS_ItemProperty_Index_CONFUSION:
                 IPS_ItemProperty_ConfusionCurse_apply( item, subject );
            break;
        case IPS_ItemProperty_Index_HOSTILITY:
                 IPS_ItemProperty_HostilityCurse_apply( item, subject );
            break;

        default:
            WriteTimestampedLogEntry( "IPS_ItemProperty_apply: error, invalid ItemProperty index:"+IntToString( propertyIndex ) );
            break;

    }
}


void IPS_ItemProperty_remove( string itemProperty, object item, object subject );
void IPS_ItemProperty_remove( string itemProperty, object item, object subject ) {

    int propertyIndex = B62_toInt( GetSubString( itemProperty, IPS_ItemProperty_INDEX_OFFSET, IPS_ItemProperty_INDEX_WIDTH ) );
    string parameters = GetSubString( itemProperty, IPS_ItemProperty_PARAMETERS_OFFSET, IPS_ItemProperty_PARAMETERS_WIDTH );

    switch( propertyIndex ) {
        case IPS_ItemProperty_Index_ATTACK_BONUS:
                 IPS_ItemProperty_AttackBonus_remove( item, subject, parameters );
            break;
        case IPS_ItemProperty_Index_DAMAGE_BONUS:
                 IPS_ItemProperty_DamageBonus_remove( item, subject, parameters );
            break;
        case IPS_ItemProperty_Index_BONUS_FEAT:
                 IPS_ItemProperty_BonusFeat_remove( item, subject, parameters );
            break;
        case IPS_ItemProperty_Index_MAX_RANGE_STRENGHT_MOD:
                 IPS_ItemProperty_MaxRangeStrengthMod_remove ( item, subject, parameters );
            break;
        case IPS_ItemProperty_Index_KEEN:
                 IPS_ItemProperty_Keen_remove( item, subject, parameters );
            break;
        case IPS_ItemProperty_Index_CAST_SPELL: // Nota: solo soporta el caso de usos ilimitados
                 IPS_ItemProperty_CastSpell_remove( item, subject, parameters );
            break;
        case IPS_ItemProperty_Index_ON_HIT_CAST_SPELL:
                 IPS_ItemProperty_OnHitCastSpell_remove( item, subject, parameters );
            break;
        case IPS_ItemProperty_Index_ON_HIT_PROPS:
                 IPS_ItemProperty_OnHitProps_remove( item, subject, parameters );
            break;
        case IPS_ItemProperty_Index_ABILITY_BONUS:
                 IPS_ItemProperty_AbilityBonus_remove( item, subject, parameters );
            break;
        case IPS_ItemProperty_Index_BONUS_SAVING_THROW:
                 IPS_ItemProperty_BonusSavingThrow_remove ( item, subject, parameters );
            break;
        case IPS_ItemProperty_Index_AC_BONUS:
                 IPS_ItemProperty_ACBonus_remove( item, subject, parameters );
            break;
        case IPS_ItemProperty_Index_ENHANCEMENT_BONUS:
                 IPS_ItemProperty_EnhancementBonus_remove( item, subject, parameters );
            break;
        case IPS_ItemProperty_Index_VAMPIRIC_REGENERATION:
                 IPS_ItemProperty_VampiricRegeneration_remove( item, subject, parameters );
            break;
        case IPS_ItemProperty_Index_UNLIMITED_AMMO:
                 IPS_ItemProperty_UnlimitedAmmo_remove( item, subject, parameters );
            break;
        case IPS_ItemProperty_Index_SKILL_BONUS:
                 IPS_ItemProperty_SkillBonus_remove( item, subject, parameters );
            break;
        case IPS_ItemProperty_Index_WEIGHT_REDUCTION:
                 IPS_ItemProperty_WeightReduction_remove( item, subject, parameters );
            break;
        case IPS_ItemProperty_Index_DAMAGE_IMMUNITY_FISICAL:
                 IPS_ItemProperty_DamageImmunityFisical_remove( item, subject, parameters );
            break;
        case IPS_ItemProperty_Index_DAMAGE_IMMUNITY_ELEMENTAL:
                 IPS_ItemProperty_DamageImmunityElemental_remove( item, subject, parameters );
            break;
        case IPS_ItemProperty_Index_FORTIFICATION:
                 IPS_ItemProperty_Fortification_remove( item, subject, parameters );
            break;
        case IPS_ItemProperty_Index_CONFUSION:
                 IPS_ItemProperty_ConfusionCurse_remove( item, subject );
            break;
        case IPS_ItemProperty_Index_HOSTILITY:
                 IPS_ItemProperty_HostilityCurse_remove( item, subject );
            break;
        default:
            WriteTimestampedLogEntry( "IPS_ItemProperty_remove: error, invalid ItemProperty index:"+IntToString( propertyIndex ) );
            break;
    }
}

string IPS_ItemProperty_inspect( string itemProperty, object item, int levelModifier, int inspectSkill );
string IPS_ItemProperty_inspect( string itemProperty, object item, int levelModifier, int inspectSkill ) {
    float itemCR = IPS_Item_getCr( item );
    int identifyGenuineDC = FloatToInt(itemCR);
    int identifyModifiedDC = FloatToInt(itemCR*levelModifier/100.0);

    int propertyIndex = B62_toInt( GetSubString( itemProperty, IPS_ItemProperty_INDEX_OFFSET, IPS_ItemProperty_INDEX_WIDTH ) );
    string parameters = GetSubString( itemProperty, IPS_ItemProperty_PARAMETERS_OFFSET, IPS_ItemProperty_PARAMETERS_WIDTH );

    switch( propertyIndex ) {
        case IPS_ItemProperty_Index_ATTACK_BONUS:
            return inspectSkill > identifyModifiedDC -1 ? "- propiedad benigna detectada: mejora de la certeza del ataque" : "";

        case IPS_ItemProperty_Index_DAMAGE_BONUS:
            return inspectSkill > identifyModifiedDC -2 ? "- propiedad benigna detectada: aumento del daño" : "";

        case IPS_ItemProperty_Index_BONUS_FEAT:
            return inspectSkill > identifyModifiedDC +1 ? "- propiedad benigna detectada: dote extra" : "";

        case IPS_ItemProperty_Index_MAX_RANGE_STRENGHT_MOD:
            return inspectSkill > identifyModifiedDC -2 ? "propiedad benigna detectada: aprovechamiento de la fuerza" : "";

        case IPS_ItemProperty_Index_KEEN:
            return inspectSkill > identifyModifiedDC -3 ? "propiedad benigna detectada: afilada" : "";

        case IPS_ItemProperty_Index_CAST_SPELL:
            return inspectSkill > identifyModifiedDC +3 ? "- propiedad benigna detectada: secuenciador" : "";

        case IPS_ItemProperty_Index_ON_HIT_CAST_SPELL:
            return inspectSkill > identifyModifiedDC +3 ? "- propiedad benigna detectada: lanza hechizo cuando acierta un ataque" : "";

        case IPS_ItemProperty_Index_ON_HIT_PROPS:
            return inspectSkill > identifyModifiedDC +3 ? "- propiedad benigna detectada: efecto especial cuando acierta un ataque" : "";

        case IPS_ItemProperty_Index_ABILITY_BONUS:
            return inspectSkill > identifyModifiedDC +2 ? "- propiedad benigna detectada: mejora de habilidad" : "";

        case IPS_ItemProperty_Index_BONUS_SAVING_THROW:
            return inspectSkill > identifyModifiedDC +2 ? "- propiedad benigna detectada: aumento de salvacion" : "";

        case IPS_ItemProperty_Index_AC_BONUS:
            return inspectSkill > identifyModifiedDC -1 ? "- propiedad benigna detectada: mejora de la defensa" : "";

        case IPS_ItemProperty_Index_ENHANCEMENT_BONUS:
            return inspectSkill > identifyModifiedDC +2 ? "- propiedad benigna detectada: encantamiento del arma" : "";

        case IPS_ItemProperty_Index_VAMPIRIC_REGENERATION:
            return inspectSkill > identifyModifiedDC -1 ? "- propiedad benigna detectada: regeneración vampírica" : "";

        case IPS_ItemProperty_Index_UNLIMITED_AMMO:
            return inspectSkill > identifyModifiedDC +2 ? "- propiedad benigna detectada: munición inagotable" : "";

        case IPS_ItemProperty_Index_SKILL_BONUS:
            return inspectSkill > identifyModifiedDC +1 ? "- propiedad benigna detectada: mejora en alguna destreza (skill)" : "";

        case IPS_ItemProperty_Index_WEIGHT_REDUCTION:
            return inspectSkill > identifyModifiedDC -8 ? "- propiedad benigna detectada: reducción de peso" : "";

        case IPS_ItemProperty_Index_DAMAGE_IMMUNITY_FISICAL:
            return inspectSkill > identifyModifiedDC +2 ? "- propiedad benigna detectada: inmunidad a daño físico" : "";

        case IPS_ItemProperty_Index_DAMAGE_IMMUNITY_ELEMENTAL:
            return inspectSkill > identifyModifiedDC +3 ? "- propiedad benigna detectada: inmunidad a daño elemental" : "";

        case IPS_ItemProperty_Index_FORTIFICATION:
            return IPS_ItemProperty_Fortification_inspect( item, parameters, identifyModifiedDC, inspectSkill );

        case IPS_ItemProperty_Index_CONFUSION:
            return inspectSkill > identifyGenuineDC +4 ? "- propiedad MALIGNA detectada: el portador regenera 3/4 del daño fisico que sufre, pero pierde el control de sí mismo cuando sucede" : "";

        case IPS_ItemProperty_Index_HOSTILITY:
            return inspectSkill > identifyGenuineDC +7 ? "- propiedad MALIGNA detectada: al portador le deprime la soledad y es odiosamente exigente con sus compañeros de equipo" : "";

        default:
            return inspectSkill > identifyModifiedDC +0 ? "- propiedad benigna detectada" : "";
    }
    return ""; // nunca llega a esta linea. Esta solo para que el compilaador no lance error.
}


void IPS_ItemProperty_removeCurse( string itemProperty, object item, object subject );
void IPS_ItemProperty_removeCurse( string itemProperty, object item, object subject ) {
    int propertyIndex = B62_toInt( GetSubString( itemProperty, IPS_ItemProperty_INDEX_OFFSET, IPS_ItemProperty_INDEX_WIDTH ) );
    string parameters = GetSubString( itemProperty, IPS_ItemProperty_PARAMETERS_OFFSET, IPS_ItemProperty_PARAMETERS_WIDTH );

    switch( propertyIndex ) {
        case IPS_ItemProperty_Index_CONFUSION:
                 IPS_ItemProperty_ConfusionCurse_removeCurse( item, subject );
            break;
        case IPS_ItemProperty_Index_HOSTILITY:
                 IPS_ItemProperty_HostilityCurse_removeCurse( item, subject );
            break;
    }
}

