/******************* Item Properties System - Random Treasure Generator ********
package: Item Properties System - Random Treasure Generator - include
Autor: Inquisidor
Descripcion: funciones que generan items con propiedades al azar.
*******************************************************************************/
#include "IPS_RPG_inc"

const int IPS_AMMO_PACK_SIZE = 50;

object IPS_Item_build( object container, string baseItemTemplate, int baseItemType, float baseItemGoldValue, int packSize, float desiredLevel, struct WeightedSelector featureDie, int isForAStore, int randomizeApparience, int armor2daIndex=-1 );
object IPS_Item_build( object container, string baseItemTemplate, int baseItemType, float baseItemGoldValue, int packSize, float desiredLevel, struct WeightedSelector featureDie, int isForAStore, int randomizeApparience, int armor2daIndex=-1 ) {
    float baseItemQuality = IPS_levelToQuality( baseItemGoldValue/IPS_ITEM_VALUE_PER_LEVEL );
    float propertiesQuality = IPS_levelToQuality(desiredLevel) - baseItemQuality;
    if( propertiesQuality < 0.0 )
        propertiesQuality = 0.0;
    struct Properties properties = IPS_Item_generateRandomProperties( propertiesQuality, featureDie, baseItemType, armor2daIndex );
    object temporaryContainer = randomizeApparience ? GetLocalObject( GetModule(), IPS_temporaryContainer_PN ) : container ;
    object item = IPS_Item_create( temporaryContainer, baseItemTemplate, baseItemQuality, properties, isForAStore, packSize );

    if( !GetIsObjectValid(item) )
        WriteTimestampedLogEntry( "IPS_Item_build: error, template="+baseItemTemplate );
//    SetName( item, GetName(item)+", v="+IntToString(IPS_Item_getGenuineGoldValue(item))+", oed="+IntToString(GetStringLength(properties.onEquipDescriptors)/IPS_ItemProperty_TOTAL_WIDTH)+", ocd="+IntToString(GetStringLength(properties.onCreationDescriptors)/IPS_ItemProperty_TOTAL_WIDTH) );

    if( randomizeApparience ) {
        item = Item_applyRandomAppearance( item );
        DestroyObject( item ); // recordar que el ítem referenciado por 'item' es destruido recien cuando termina de ejecutarse el script
        item = CopyItem( item, container );
    }
    if( isForAStore )
        IPS_Item_adjustGoldValue( item );

    return item;
}

string IPS_RTG_takeTemplate( string descriptor, int offset=1, int width=16 );
string IPS_RTG_takeTemplate( string descriptor, int offset=1, int width=16 ) {
    int length = FindSubString( descriptor, " " ) - offset;
    if( length > width || length < 0 )
        length = width;
    return GetSubString( descriptor, offset, length );
}

////////////////////////////////////////////////////////////////////////////////


// Notas: En las armas de dos tipos de danio, el enchant weapon agrega danio que se muestra como fisico pero en realidad es del tipo que aparece segundo en la hoja del arma.
//                                                       Bastard Sword                Battleaxe                    Club                         Dagger                       Dire Mace                    Double Axe                   Dwarven Waraxe               Greataxe                     Greatsword                   Gloves
//                                                     "|@@@@@@@@@@@@@@@@,###,###,###|@@@@@@@@@@@@@@@@,###,###,###|@@@@@@@@@@@@@@@@,###,###,###|@@@@@@@@@@@@@@@@,###,###,###|@@@@@@@@@@@@@@@@,###,###,###|@@@@@@@@@@@@@@@@,###,###,###|@@@@@@@@@@@@@@@@,###,###,###|@@@@@@@@@@@@@@@@,###,###,###|@@@@@@@@@@@@@@@@,###,###,###|@@@@@@@@@@@@@@@@,###,###,###|@@@@@@@@@@@@@@@@,###,###,###
  const string ALL_MELEE_WEAPONS_DESCRIPTORS_ARRAY_1 = "|nw_wswbs001     ,070,003,050|nw_waxbt001     ,020,002,080|nw_wblcl001     ,002,028,100|nw_wswdg001     ,004,022,100|nw_wdbma001     ,080,032,050|nw_wdbax001     ,060,033,080|x2_wdwraxe001   ,030,108,080|nw_waxgr001     ,040,018,080|nw_wswgs001     ,100,013,080|ips_rtg_mglove1 ,002,036,120";

//                                                       Halberd                      Handaxe                      Heavy Flail                  Katana                       Kukri                        Light Flail                  Light Hammer                 Longsword                    Light Mace                   Morningstar
//                                                     "|@@@@@@@@@@@@@@@@,###,###,###|@@@@@@@@@@@@@@@@,###,###,###|@@@@@@@@@@@@@@@@,###,###,###|@@@@@@@@@@@@@@@@,###,###,###|@@@@@@@@@@@@@@@@,###,###,###|@@@@@@@@@@@@@@@@,###,###,###|@@@@@@@@@@@@@@@@,###,###,###|@@@@@@@@@@@@@@@@,###,###,###|@@@@@@@@@@@@@@@@,###,###,###|@@@@@@@@@@@@@@@@,###,###,###|@@@@@@@@@@@@@@@@,###,###,###
  const string ALL_MELEE_WEAPONS_DESCRIPTORS_ARRAY_2 = "|nw_wplhb001     ,020,010,080|nw_waxhn001     ,012,038,080|nw_wblfh001     ,030,035,080|nw_wswka001     ,080,041,050|nw_wspku001     ,008,042,005|nw_wblfl001     ,016,004,080|nw_wblhl001     ,002,037,080|nw_wswls001     ,030,001,080|nw_wblml001     ,010,009,100|nw_wblms001     ,016,047,100";

//                                                       Quarterstaff                 Rapier                       Scimitar                     Scythe                       Short Sword                  Sickle                       Short Spear                  Two-Bladed Sword             War Hammer                   Whip
//                                                     "|@@@@@@@@@@@@@@@@,###,###,###|@@@@@@@@@@@@@@@@,###,###,###|@@@@@@@@@@@@@@@@,###,###,###|@@@@@@@@@@@@@@@@,###,###,###|@@@@@@@@@@@@@@@@,###,###,###|@@@@@@@@@@@@@@@@,###,###,###|@@@@@@@@@@@@@@@@,###,###,###|@@@@@@@@@@@@@@@@,###,###,###|@@@@@@@@@@@@@@@@,###,###,###|@@@@@@@@@@@@@@@@,###,###,###|@@@@@@@@@@@@@@@@,###,###,###
  const string ALL_MELEE_WEAPONS_DESCRIPTORS_ARRAY_3 = "|nw_wdbqs001     ,002,050,100|nw_wswrp001     ,040,051,080|nw_wswsc001     ,036,053,080|nw_wplsc001     ,036,055,050|nw_wswss001     ,020,000,080|nw_wspsc001     ,012,060,100|nw_wplss001     ,002,058,100|nw_wdbsw001     ,200,012,050|nw_wblhw001     ,024,005,080|x2_it_wpwhip    ,001,111,080";


const int    MeleeWeaponDescriptor_TEMPLATE_OFFSET = 1;
const int    MeleeWeaponDescriptor_TEMPLATE_WIDTH = 16;
const int    MeleeWeaponDescriptor_GOLD_VALUE_OFFSET = 18;
const int    MeleeWeaponDescriptor_GOLD_VALUE_WIDTH = 3;
const int    MeleeWeaponDescriptor_BASE_ITEM_TYPE_OFFSET = 22;
const int    MeleeWeaponDescriptor_BASE_ITEM_TYPE_WIDTH = 3;
const int    MeleeWeaponDescriptor_TOTAL_WIDTH = 29;

object IPS_Item_generateMeleeWeapon( object container, float desiredLevel, string baseItemsDescriptorsArray, int isForAStore=FALSE );
object IPS_Item_generateMeleeWeapon( object container, float desiredLevel, string baseItemsDescriptorsArray, int isForAStore=FALSE ) {
    struct WeightedSelector weightingSelector = WeightedSelector_create( baseItemsDescriptorsArray, MeleeWeaponDescriptor_TOTAL_WIDTH );
    string baseItemDescriptor = WeightedSelector_choose( weightingSelector );
    string baseItemTemplate = IPS_RTG_takeTemplate( baseItemDescriptor );
    float baseItemGoldValue = StringToFloat( GetSubString( baseItemDescriptor, MeleeWeaponDescriptor_GOLD_VALUE_OFFSET, MeleeWeaponDescriptor_GOLD_VALUE_WIDTH ) );
    int baseItemType = StringToInt( GetSubString( baseItemDescriptor, MeleeWeaponDescriptor_BASE_ITEM_TYPE_OFFSET, MeleeWeaponDescriptor_BASE_ITEM_TYPE_WIDTH ) );
                                                            //  attackB damFisi damElem enhaBon weightR conting gCleave ACBonus
    struct WeightedSelector propertyDie = WeightedDie_create( "|001,500|002,350|003,150|004,500|007,050|080,010|090,200|000,300" );
                                                            //  attackB damFisi damElem enhaBon weightR conting gCleave ACBonus
    if( Random(4) == 0 )//keen
        propertyDie = WeightedDie_addFace( propertyDie, IPS_FEATURE_ID_KEEN, 200 ); // agrega Keen como propiedad eligible
    int weaponSize = StringToInt( Get2DAStringAdapted( "baseItems", "WeaponSize", baseItemType ) );
    if( weaponSize <= 2 ) {
        propertyDie = WeightedDie_addFace( propertyDie, IPS_FEATURE_ID_SKILL_PARRY, 200 ); // agrega parry como skill elegible
    }
    if( !isForAStore ) {
        propertyDie = WeightedDie_addFace( propertyDie, IPS_FEATURE_ID_VAMPIRIC_REGENERATION, 100 ); // agrega regeneracion vampírica
        propertyDie = WeightedDie_addFace( propertyDie, IPS_FEATURE_ID_ON_HIT_WEAPON_PROPS, 100 ); // agrega on hit special property
        int curseWeight = propertyDie.totalWeight/40;
        propertyDie = WeightedDie_addFace( propertyDie, IPS_FEATURE_ID_CONFUSION_ON_DAMAGE, curseWeight ); // agrega la maldición confusion al recibir daño con 1/30 de chance
        propertyDie = WeightedDie_addFace( propertyDie, IPS_FEATURE_ID_HOSTILITY_BY_PARTNERS, curseWeight ); // agrega la maldición hostilidad desenfrenada de los compañeros de equipo con 1/30 de chance
    }
    return IPS_Item_build( container, baseItemTemplate, baseItemType, baseItemGoldValue, 1, desiredLevel, propertyDie, isForAStore, TRUE );
}


//                                                      Long bow                     Short bow                    Heavy Crossbow               Light croswbow               Sling
//                                                    "|@@@@@@@@@@@@@@@@,###,###,###|@@@@@@@@@@@@@@@@,###,###,###|@@@@@@@@@@@@@@@@,###,###,###|@@@@@@@@@@@@@@@@,###,###,###|@@@@@@@@@@@@@@@@,###,###,###|@@@@@@@@@@@@@@@@,###,###,###
  const string ALL_RANGED_WEAPONS_DESCRIPTORS_ARRAY = "|nw_wbwln001     ,075,008,100|nw_wbwsh001     ,060,011,100|nw_wbwxh001     ,050,006,100|nw_wbwxl001     ,035,007,100|nw_wbwsl001     ,002,061,100";


const int RangedWeaponDescriptor_TEMPLATE_OFFSET = 1;
const int RangedWeaponDescriptor_TEMPLATE_WIDTH = 16;
const int RangedWeaponDescriptor_GOLD_VALUE_OFFSET = 18;
const int RangedWeaponDescriptor_GOLD_VALUE_WIDTH = 3;
const int RangedWeaponDescriptor_BASE_ITEM_TYPE_OFFSET = 22;
const int RangedWeaponDescriptor_BASE_ITEM_TYPE_WIDTH = 3;
const int RangedWeaponDescriptor_TOTAL_WIDTH = 29;

object IPS_Item_generateRangedWeapon( object container, float desiredLevel, string baseItemsDescriptorsArray, int isForAStore=FALSE );
object IPS_Item_generateRangedWeapon( object container, float desiredLevel, string baseItemsDescriptorsArray, int isForAStore=FALSE ) {
    struct WeightedSelector weightingSelector = WeightedSelector_create( baseItemsDescriptorsArray, RangedWeaponDescriptor_TOTAL_WIDTH );
    string baseItemDescriptor = WeightedSelector_choose( weightingSelector );
    string baseItemTemplate = IPS_RTG_takeTemplate( baseItemDescriptor );
    float baseItemGoldValue = StringToFloat( GetSubString( baseItemDescriptor, RangedWeaponDescriptor_GOLD_VALUE_OFFSET, RangedWeaponDescriptor_GOLD_VALUE_WIDTH ) );
    int baseItemType = StringToInt( GetSubString( baseItemDescriptor, RangedWeaponDescriptor_BASE_ITEM_TYPE_OFFSET, RangedWeaponDescriptor_BASE_ITEM_TYPE_WIDTH ) );
                                                            //  attackB conting mighty
    struct WeightedSelector propertyDie = WeightedDie_create( "|001,500|080,010|005,500" );

    if( !isForAStore ) {
        propertyDie = WeightedDie_addFace( propertyDie, IPS_FEATURE_ID_UNLIMITED_AMMO, 50 ); // agrega unlimited ammo
        int curseWeight = propertyDie.totalWeight/40;
        propertyDie = WeightedDie_addFace( propertyDie, IPS_FEATURE_ID_CONFUSION_ON_DAMAGE, curseWeight ); // agrega la maldición confusion al recibir daño con un cuarto de chance
        propertyDie = WeightedDie_addFace( propertyDie, IPS_FEATURE_ID_HOSTILITY_BY_PARTNERS, curseWeight ); // agrega la maldición hostilidad desenfrenada de los compañeros de equipo
    }

    return IPS_Item_build( container, baseItemTemplate, baseItemType, baseItemGoldValue, 1, desiredLevel, propertyDie, isForAStore, TRUE );
}


//                                                        Dart                         Throwing Axe                 Shuriken
//                                                      "|@@@@@@@@@@@@@@@@,###,###,###|@@@@@@@@@@@@@@@@,###,###,###|@@@@@@@@@@@@@@@@,###,###,###|@@@@@@@@@@@@@@@@,###,###,###
  const string ALL_THROWING_WEAPONS_DESCRIPTORS_ARRAY = "|nw_wthdt001     ,0.1,031,050|nw_wthax001     ,001,063,150|nw_wthsh001     ,001,059,010";


const int    ThrowingWeaponDescriptor_TEMPLATE_OFFSET = 1;
const int    ThrowingWeaponDescriptor_TEMPLATE_WIDTH = 16;
const int    ThrowingWeaponDescriptor_GOLD_VALUE_OFFSET = 18;
const int    ThrowingWeaponDescriptor_GOLD_VALUE_WIDTH = 3;
const int    ThrowingWeaponDescriptor_BASE_ITEM_TYPE_OFFSET = 22;
const int    ThrowingWeaponDescriptor_BASE_ITEM_TYPE_WIDTH = 3;
const int    ThrowingWeaponDescriptor_TOTAL_WIDTH = 29;

object IPS_Item_generateThrowingWeapon( object container, float desiredLevel, string baseItemsDescriptorsArray, int isForAStore=FALSE );
object IPS_Item_generateThrowingWeapon( object container, float desiredLevel, string baseItemsDescriptorsArray, int isForAStore=FALSE ) {
    struct WeightedSelector weightingSelector = WeightedSelector_create( baseItemsDescriptorsArray, ThrowingWeaponDescriptor_TOTAL_WIDTH );
    string baseItemDescriptor = WeightedSelector_choose( weightingSelector );
    string baseItemTemplate = IPS_RTG_takeTemplate( baseItemDescriptor );
    float baseItemGoldValue = StringToFloat( GetSubString( baseItemDescriptor, ThrowingWeaponDescriptor_GOLD_VALUE_OFFSET, ThrowingWeaponDescriptor_GOLD_VALUE_WIDTH ) );
    int baseItemType = StringToInt( GetSubString( baseItemDescriptor, ThrowingWeaponDescriptor_BASE_ITEM_TYPE_OFFSET, ThrowingWeaponDescriptor_BASE_ITEM_TYPE_WIDTH ) );
                                                             // attackB damFisi damElem enhancB mighty  weightR
    struct WeightedSelector propertyDie = WeightedDie_create( "|001,500|002,350|003,150|004,500|005,200|007,050" );

    if( !isForAStore )
        propertyDie = WeightedDie_addFace( propertyDie, IPS_FEATURE_ID_ON_HIT_WEAPON_PROPS, 50 ); // agrega on hit special property

    return IPS_Item_build( container, baseItemTemplate, baseItemType, baseItemGoldValue, IPS_AMMO_PACK_SIZE, desiredLevel, propertyDie, isForAStore, TRUE );
}


object IPS_Item_generateArrowsPack( object container, float desiredLevel, int isForAStore=FALSE );
object IPS_Item_generateArrowsPack( object container, float desiredLevel, int isForAStore=FALSE ) {
    struct WeightedSelector propertyDie = WeightedDie_create( "|002,050|003,050" );

    return IPS_Item_build( container, "nw_wamar001", BASE_ITEM_SHORTBOW, 3.0, IPS_AMMO_PACK_SIZE, desiredLevel, propertyDie, isForAStore, TRUE );
}

object IPS_Item_generateBoltsPack( object container, float desiredLevel, int isForAStore=FALSE );
object IPS_Item_generateBoltsPack( object container, float desiredLevel, int isForAStore=FALSE ) {
    struct WeightedSelector propertyDie = WeightedDie_create( "|002,050|003,050" );

    return IPS_Item_build( container, "nw_wambo001", BASE_ITEM_LIGHTCROSSBOW, 4.0, IPS_AMMO_PACK_SIZE, desiredLevel, propertyDie, isForAStore, TRUE );
}

object IPS_Item_generateBulletsPack( object container, float desiredLevel, int isForAStore=FALSE );
object IPS_Item_generateBulletsPack( object container, float desiredLevel, int isForAStore=FALSE ) {
    struct WeightedSelector propertyDie = WeightedDie_create( "|002,050|003,050" );

    return IPS_Item_build( container, "nw_wambu001", BASE_ITEM_SLING, 1.0, IPS_AMMO_PACK_SIZE, desiredLevel, propertyDie, isForAStore, TRUE );
}


//                                               Cleric tunic                 Wizard Tunic
//                                              "|@@@@@@@@@@@@@@@@,####,#,###|@@@@@@@@@@@@@@@@,####,#,###|@@@@@@@@@@@@@@@@,####,#,###|@@@@@@@@@@@@@@@@,####,#,###|@@@@@@@@@@@@@@@@,####,#,###
  const string ROBE_ARMOR_DESCRIPTORS_ARRAY   = "|ips_rtg_cloth1  ,0010,0,100|ips_rtg_cloth2  ,0010,0,100|ips_rtg_cloth3  ,0010,0,100|ips_rtg_cloth4  ,0010,0,100";

//                                               Armadura de cuero            Armadura acolchada           Armadura de cuero tachonado  Armadura de pieles
//                                              "|@@@@@@@@@@@@@@@@,####,#,###|@@@@@@@@@@@@@@@@,####,#,###|@@@@@@@@@@@@@@@@,####,#,###|@@@@@@@@@@@@@@@@,####,#,###|@@@@@@@@@@@@@@@@,####,#,###
  const string LIGHT_ARMOR_DESCRIPTORS_ARRAY  = "|ips_rtg_aarcl001,0100,2,200|ips_rtg_aarcl009,0040,1,200|nw_aarcl002     ,0180,3,100|ips_rtg_aarcl008,0180,3,100";

//                                               Camisote de mallas           Coraza                       Cota de mallas               Cota de escamas
//                                              "|@@@@@@@@@@@@@@@@,####,#,###|@@@@@@@@@@@@@@@@,####,#,###|@@@@@@@@@@@@@@@@,####,#,###|@@@@@@@@@@@@@@@@,####,#,###|@@@@@@@@@@@@@@@@,####,#,###
  const string MEDIUM_ARMOR_DESCRIPTORS_ARRAY = "|ips_rtg_aarcl012,0290,4,100|ips_rtg_aarcl010,0430,5,100|ips_rtg_aarcl004,0430,5,100|ips_rtg_aarcl003,0290,4,100";

//                                               Cota de bandas               Armadura completa            Armadura de placas y mallas  Armadura laminada
//                                              "|@@@@@@@@@@@@@@@@,####,#,###|@@@@@@@@@@@@@@@@,####,#,###|@@@@@@@@@@@@@@@@,####,#,###|@@@@@@@@@@@@@@@@,####,#,###|@@@@@@@@@@@@@@@@,####,#,###
  const string HEAVY_ARMOR_DESCRIPTORS_ARRAY  = "|ips_rtg_aarcl011,0600,6,100|ips_rtg_aarcl007,1000,8,100|ips_rtg_aarcl006,0700,7,150|ips_rtg_aarcl005,0600,6,100";


const int    ArmorDescriptor_TEMPLATE_OFFSET = 1;
const int    ArmorDescriptor_TEMPLATE_WIDTH = 16;
const int    ArmorDescriptor_GOLD_VALUE_OFFSET = 18;
const int    ArmorDescriptor_GOLD_VALUE_WIDTH = 4;
const int    ArmorDescriptor_DEFENSE_OFFSET = 23;
const int    ArmorDescriptor_DEFENSE_WIDTH = 1;
const int    ArmorDescriptor_TOTAL_WIDTH = 28;

object IPS_Item_generateArmor( object container, float desiredLevel, string baseItemsDescriptorsArray, int isForAStore=FALSE );
object IPS_Item_generateArmor( object container, float desiredLevel, string baseItemsDescriptorsArray, int isForAStore=FALSE ) {
    struct WeightedSelector weightingSelector = WeightedSelector_create( baseItemsDescriptorsArray, ArmorDescriptor_TOTAL_WIDTH );
    string baseItemDescriptor = WeightedSelector_choose( weightingSelector );
    string baseItemTemplate = IPS_RTG_takeTemplate( baseItemDescriptor );
    float baseItemGoldValue = StringToFloat( GetSubString( baseItemDescriptor, ArmorDescriptor_GOLD_VALUE_OFFSET, ArmorDescriptor_GOLD_VALUE_WIDTH ) );
    int baseItemDefense = StringToInt( GetSubString( baseItemDescriptor, ArmorDescriptor_DEFENSE_OFFSET, ArmorDescriptor_DEFENSE_WIDTH ) );

                                                            //  AC      bludImm pierImm slasImm acidImm coldImm elecImm fireImm soniImm conting fortifi
    struct WeightedSelector propertyDie = WeightedDie_create( "|000,900|030,070|031,070|032,070|036,040|037,040|039,040|040,040|043,040|080,020|081,050" );

    if( Random( 3 + baseItemDefense*baseItemDefense ) == 0 )             // hide    moveSil tumble
        propertyDie = WeightedDie_merge( propertyDie, WeightedDie_create( "|055,900|058,900|071,900" ) );
    if( baseItemDefense > 1 )
        propertyDie = WeightedDie_addFace( propertyDie, IPS_FEATURE_ID_WEIGHT_REDUCTION, 100 ); // le agrega reduccion de peso
    if( !isForAStore ) {
        propertyDie = WeightedDie_addFace( propertyDie, IPS_FEATURE_ID_ON_HIT_ARMOR_CAST_SPELL, 80 ); // le agrega oh hit cast spell
        int curseWeight = propertyDie.totalWeight/40;
        propertyDie = WeightedDie_addFace( propertyDie, IPS_FEATURE_ID_CONFUSION_ON_DAMAGE, curseWeight ); // agrega la maldición confusion al recibir daño con un cuarto de chance
        propertyDie = WeightedDie_addFace( propertyDie, IPS_FEATURE_ID_HOSTILITY_BY_PARTNERS, curseWeight ); // agrega la maldición hostilidad desenfrenada de los compañeros de equipo
    }

    object item = IPS_Item_build( container, baseItemTemplate, BASE_ITEM_ARMOR, baseItemGoldValue, 1, desiredLevel, propertyDie, isForAStore, FALSE, baseItemDefense );
    return item;
}


object IPS_Item_generateSmallShield( object container, float desiredLevel, int isForAStore=FALSE );
object IPS_Item_generateSmallShield( object container, float desiredLevel, int isForAStore=FALSE ) {
                                                             //  AC     bludImm pierImm slasImm acidImm coldImm elecImm fireImm soniImm conting
    struct WeightedSelector propertyDie = WeightedDie_create( "|000,900|030,070|031,070|032,070|036,007|037,007|039,007|040,007|043,007|080,010" );
    if( !isForAStore ) {
        int curseWeight = propertyDie.totalWeight/40;
        propertyDie = WeightedDie_addFace( propertyDie, IPS_FEATURE_ID_CONFUSION_ON_DAMAGE, curseWeight ); // agrega la maldición confusion al recibir daño con un cuarto de chance
        propertyDie = WeightedDie_addFace( propertyDie, IPS_FEATURE_ID_HOSTILITY_BY_PARTNERS, curseWeight ); // agrega la maldición hostilidad desenfrenada de los compañeros de equipo
    }

    return IPS_Item_build( container, "nw_ashsw001", 14, 9.0, 1, desiredLevel, propertyDie, isForAStore, TRUE );
}

object IPS_Item_generateLargeShield( object container, float desiredLevel, int isForAStore=FALSE );
object IPS_Item_generateLargeShield( object container, float desiredLevel, int isForAStore=FALSE ) {
                                                             //  AC     weightR bludImm pierImm slasImm acidImm coldImm elecImm fireImm soniImm conting
    struct WeightedSelector propertyDie = WeightedDie_create( "|000,900|007,100|030,070|031,070|032,070|036,007|037,007|039,007|040,007|043,007|080,010" );
    if( !isForAStore ) {
        int curseWeight = propertyDie.totalWeight/40;
        propertyDie = WeightedDie_addFace( propertyDie, IPS_FEATURE_ID_CONFUSION_ON_DAMAGE, curseWeight ); // agrega la maldición confusion al recibir daño con un cuarto de chance
        propertyDie = WeightedDie_addFace( propertyDie, IPS_FEATURE_ID_HOSTILITY_BY_PARTNERS, curseWeight ); // agrega la maldición hostilidad desenfrenada de los compañeros de equipo
    }

    return IPS_Item_build( container, "nw_ashlw001", 56, 50.0, 1, desiredLevel, propertyDie, isForAStore, TRUE );
}

object IPS_Item_generateTowerShield( object container, float desiredLevel, int isForAStore=FALSE );
object IPS_Item_generateTowerShield( object container, float desiredLevel, int isForAStore=FALSE ) {
                                                             //  AC     weightR bludImm pierImm slasImm acidImm coldImm elecImm fireImm soniImm conting
    struct WeightedSelector propertyDie = WeightedDie_create( "|000,900|007,100|030,070|031,070|032,070|036,007|037,007|039,007|040,007|043,007|080,007" );
    if( !isForAStore ) {
        int curseWeight = propertyDie.totalWeight/40;
        propertyDie = WeightedDie_addFace( propertyDie, IPS_FEATURE_ID_CONFUSION_ON_DAMAGE, curseWeight ); // agrega la maldición confusion al recibir daño con un cuarto de chance
        propertyDie = WeightedDie_addFace( propertyDie, IPS_FEATURE_ID_HOSTILITY_BY_PARTNERS, curseWeight ); // agrega la maldición hostilidad desenfrenada de los compañeros de equipo
    }

    return IPS_Item_build( container, "nw_ashto001", 57, 100.0, 1, desiredLevel, propertyDie, isForAStore, TRUE );
}

object IPS_Item_generateShield( object container, float desiredLevel, int isForAStore=FALSE );
object IPS_Item_generateShield( object container, float desiredLevel, int isForAStore=FALSE ) {
    object shield;
    switch( Random(3) ) {
        case 0: shield = IPS_Item_generateSmallShield( container, desiredLevel, isForAStore );
        case 1: shield = IPS_Item_generateLargeShield( container, desiredLevel, isForAStore );
        case 2: shield= IPS_Item_generateTowerShield( container, desiredLevel, isForAStore );
    }
    return shield;
}

object IPS_Item_generateNecklace( object container, float desiredLevel, int isForAStore=FALSE );
object IPS_Item_generateNecklace( object container, float desiredLevel, int isForAStore=FALSE ) {
                                                             // AC      constit wisdom  charism univSav fortitu will    reflex
    struct WeightedSelector propertyDie = WeightedDie_create( "|000,550|022,100|024,100|025,100|026,036|027,038|028,038|029,038" );
    if( !isForAStore ) {
        int curseWeight = propertyDie.totalWeight/40;
        propertyDie = WeightedDie_addFace( propertyDie, IPS_FEATURE_ID_CONFUSION_ON_DAMAGE, curseWeight ); // agrega la maldición confusion al recibir daño con un cuarto de chance
        propertyDie = WeightedDie_addFace( propertyDie, IPS_FEATURE_ID_HOSTILITY_BY_PARTNERS, curseWeight ); // agrega la maldición hostilidad desenfrenada de los compañeros de equipo
    }

    return IPS_Item_build( container, "ips_rtg_mneck1", BASE_ITEM_AMULET, 200.0, 1, desiredLevel, propertyDie, isForAStore, TRUE );
}


object IPS_Item_generateRing( object container, float desiredLevel, int isForAStore=FALSE );
object IPS_Item_generateRing( object container, float desiredLevel, int isForAStore=FALSE ) {
    float baseItemGoldValue = 100.0;
    float baseItemQuality = IPS_levelToQuality( baseItemGoldValue/IPS_ITEM_VALUE_PER_LEVEL );
                                                             // AC      intelig wisdom  charism univSav fortitu will    reflex
    struct WeightedSelector propertyDie = WeightedDie_create( "|000,550|023,100|024,100|025,100|026,036|027,038|028,038|029,038" );
    if( !isForAStore ) {
        int curseWeight = propertyDie.totalWeight/40;
        propertyDie = WeightedDie_addFace( propertyDie, IPS_FEATURE_ID_CONFUSION_ON_DAMAGE, curseWeight ); // agrega la maldición confusion al recibir daño con un cuarto de chance
        propertyDie = WeightedDie_addFace( propertyDie, IPS_FEATURE_ID_HOSTILITY_BY_PARTNERS, curseWeight ); // agrega la maldición hostilidad desenfrenada de los compañeros de equipo
    }

    return IPS_Item_build( container, "ips_rtg_mring1", BASE_ITEM_RING, 100.0, 1, desiredLevel, propertyDie, isForAStore, TRUE );
}


object IPS_Item_generateHelmet( object container, float desiredLevel, int isForAStore=FALSE );
object IPS_Item_generateHelmet( object container, float desiredLevel, int isForAStore=FALSE ) {
    string baseItemTemplate;
    switch( Random(4) ) {
        case 0: baseItemTemplate = "ips_rtg_arhe1"; break;
        case 1: baseItemTemplate = "ips_rtg_arhe2"; break;
        case 2: baseItemTemplate = "ips_rtg_arhe3"; break;
        case 3: baseItemTemplate = "ips_rtg_arhe4"; break;
    }
    float baseItemGoldValue = 100.0;
    float baseItemQuality = IPS_levelToQuality( baseItemGoldValue/IPS_ITEM_VALUE_PER_LEVEL );
                                                             // AC      intelig will    concent listen, spot
    struct WeightedSelector propertyDie = WeightedDie_create( "|000,550|023,150|028,050|051,080|056,080|067,080" );

    if( !isForAStore ) {
        int curseWeight = propertyDie.totalWeight/40;
        propertyDie = WeightedDie_addFace( propertyDie, IPS_FEATURE_ID_CONFUSION_ON_DAMAGE, curseWeight ); // agrega la maldición confusion al recibir daño con un cuarto de chance
        propertyDie = WeightedDie_addFace( propertyDie, IPS_FEATURE_ID_HOSTILITY_BY_PARTNERS, curseWeight ); // agrega la maldición hostilidad desenfrenada de los compañeros de equipo
    }

    return IPS_Item_build( container, baseItemTemplate, BASE_ITEM_HELMET, 100.0, 1, desiredLevel, propertyDie, isForAStore, FALSE );
}


object IPS_Item_generateBracer( object container, float desiredLevel, int isForAStore=FALSE );
object IPS_Item_generateBracer( object container, float desiredLevel, int isForAStore=FALSE ) {
    struct WeightedSelector propertyDie;
    if( Random(10) == 0 )                //  AC     dexteri disTrap openLoc setTrap
        propertyDie = WeightedDie_create( "|000,030|021,070|052,300|059,300|065,300" );
    else                                 //  AC     strengh dexteri fortitu will    reflex  parry   perform spellcr
        propertyDie = WeightedDie_create( "|000,550|020,100|021,100|027,050|028,050|029,050|060,050|061,020|066,010" );
    if( !isForAStore ) {
        int curseWeight = propertyDie.totalWeight/40;
        propertyDie = WeightedDie_addFace( propertyDie, IPS_FEATURE_ID_CONFUSION_ON_DAMAGE, curseWeight ); // agrega la maldición confusion al recibir daño con un cuarto de chance
        propertyDie = WeightedDie_addFace( propertyDie, IPS_FEATURE_ID_HOSTILITY_BY_PARTNERS, curseWeight ); // agrega la maldición hostilidad desenfrenada de los compañeros de equipo
    }

    return IPS_Item_build( container, "ips_rtg_mbracer1", BASE_ITEM_BRACER, 100.0, 1, desiredLevel, propertyDie, isForAStore, TRUE );
}


object IPS_Item_generateCloack( object container, float desiredLevel, int isForAStore=FALSE );
object IPS_Item_generateCloack( object container, float desiredLevel, int isForAStore=FALSE ) {
    string baseItemTemplate;
    switch( Random(4) ) {
        case 0: baseItemTemplate = "ips_rtg_mcloak1"; break;
        case 1: baseItemTemplate = "ips_rtg_mcloak2"; break;
        case 2: baseItemTemplate = "ips_rtg_mcloak3"; break;
        case 3: baseItemTemplate = "ips_rtg_mcloak4"; break;
    }
    float baseItemGoldValue = 100.0;
    float baseItemQuality = IPS_levelToQuality( baseItemGoldValue/IPS_ITEM_VALUE_PER_LEVEL );
    //                                                          AC      constit charism fortitu will    reflex  hide
    struct WeightedSelector propertyDie = WeightedDie_create( "|000,550|022,100|025,100|027,050|028,050|029,050|055,100" );
    if( !isForAStore ) {
        int curseWeight = propertyDie.totalWeight/40;
        propertyDie = WeightedDie_addFace( propertyDie, IPS_FEATURE_ID_CONFUSION_ON_DAMAGE, curseWeight ); // agrega la maldición confusion al recibir daño con un cuarto de chance
        propertyDie = WeightedDie_addFace( propertyDie, IPS_FEATURE_ID_HOSTILITY_BY_PARTNERS, curseWeight ); // agrega la maldición hostilidad desenfrenada de los compañeros de equipo
    }

    return IPS_Item_build( container, baseItemTemplate, BASE_ITEM_CLOAK, 100.0, 1, desiredLevel, propertyDie, isForAStore, FALSE );
}

object IPS_Item_generateBelt( object container, float desiredLevel, int isForAStore=FALSE );
object IPS_Item_generateBelt( object container, float desiredLevel, int isForAStore=FALSE ) {
    float baseItemGoldValue = 100.0;
    float baseItemQuality = IPS_levelToQuality( baseItemGoldValue/IPS_ITEM_VALUE_PER_LEVEL );
    //                                                          AC      strengh dexteri constit fortitu will    reflex
    struct WeightedSelector propertyDie = WeightedDie_create( "|000,550|020,100|021,100|022,100|027,050|028,050|029,050" );
    if( !isForAStore ) {
        int curseWeight = propertyDie.totalWeight/40;
        propertyDie = WeightedDie_addFace( propertyDie, IPS_FEATURE_ID_CONFUSION_ON_DAMAGE, curseWeight ); // agrega la maldición confusion al recibir daño con un cuarto de chance
        propertyDie = WeightedDie_addFace( propertyDie, IPS_FEATURE_ID_HOSTILITY_BY_PARTNERS, curseWeight ); // agrega la maldición hostilidad desenfrenada de los compañeros de equipo
    }

    return IPS_Item_build( container, "ips_rtg_mbelt1", BASE_ITEM_BELT, 100.0, 1, desiredLevel, propertyDie, isForAStore, TRUE );
}

object IPS_Item_generateBoots( object container, float desiredLevel, int isForAStore=FALSE );
object IPS_Item_generateBoots( object container, float desiredLevel, int isForAStore=FALSE ) {
    float baseItemGoldValue = 100.0;
    float baseItemQuality = IPS_levelToQuality( baseItemGoldValue/IPS_ITEM_VALUE_PER_LEVEL );
    //                                                          AC      dexteri constit fortitu will    reflex  moveSil
    struct WeightedSelector propertyDie = WeightedDie_create( "|000,550|021,100|022,100|027,050|028,050|029,050|058,100" );
    if( !isForAStore ) {
        int curseWeight = propertyDie.totalWeight/40;
        propertyDie = WeightedDie_addFace( propertyDie, IPS_FEATURE_ID_CONFUSION_ON_DAMAGE, curseWeight ); // agrega la maldición confusion al recibir daño con un cuarto de chance
        propertyDie = WeightedDie_addFace( propertyDie, IPS_FEATURE_ID_HOSTILITY_BY_PARTNERS, curseWeight ); // agrega la maldición hostilidad desenfrenada de los compañeros de equipo
    }

    return IPS_Item_build( container, "ips_rtg_mboots1", BASE_ITEM_BOOTS, 100.0, 1, desiredLevel, propertyDie, isForAStore, TRUE );
}


// Notas: En las armas de dos tipos de danio, el enchant weapon agrega danio que se muestra como fisico pero en realidad es del tipo que aparece segundo en la hoja del arma.
//                                       Array standard: "|template,precioBase,extraDamageCost,damageType,flags|"
//                                                         Laud                         Flauta de Pan                Arco de Violin               Tamborin                     Harpa
//                                                       "|@@@@@@@@@@@@@@@@,###,###,###|@@@@@@@@@@@@@@@@,###,###,###|@@@@@@@@@@@@@@@@,###,###,###|@@@@@@@@@@@@@@@@,###,###,###|@@@@@@@@@@@@@@@@,###,###,###,D,S,@@@@@@@@@@@@@@@@
const string ALL_MUSIC_INSTRUMENTS_DESCRIPTORS_ARRAY_1 = "|ips_lute        ,180,???,100|ips_pipes       ,050,???,100|ips_violinbow   ,200,???,100|ips_tambourine  ,050,???,100|ips_harp        ,100,???,100";

const int    MusicInstrumentDescriptor_TEMPLATE_OFFSET = 1;
const int    MusicInstrumentDescriptor_TEMPLATE_WIDTH = 16;
const int    MusicInstrumentDescriptor_GOLD_VALUE_OFFSET = 18;
const int    MusicInstrumentDescriptor_GOLD_VALUE_WIDTH = 3;
const int    MusicInstrumentDescriptor_BASE_ITEM_TYPE_OFFSET = 22;
const int    MusicInstrumentDescriptor_BASE_ITEM_TYPE_WIDTH = 3;
const int    MusicInstrumentDescriptor_TOTAL_WIDTH = 29;

object IPS_Item_generateMusicInstrument( object container, float desiredLevel, string baseItemsDescriptorsArray, int isForAStore=FALSE );
object IPS_Item_generateMusicInstrument( object container, float desiredLevel, string baseItemsDescriptorsArray, int isForAStore=FALSE ) {
    struct WeightedSelector weightingSelector = WeightedSelector_create( baseItemsDescriptorsArray, MusicInstrumentDescriptor_TOTAL_WIDTH );
    string baseItemDescriptor = WeightedSelector_choose( weightingSelector );
    string baseItemTemplate = IPS_RTG_takeTemplate( baseItemDescriptor );
    float baseItemGoldValue = StringToFloat( GetSubString( baseItemDescriptor, MusicInstrumentDescriptor_GOLD_VALUE_OFFSET, MusicInstrumentDescriptor_GOLD_VALUE_WIDTH ) );
    int baseItemType = StringToInt( GetSubString( baseItemDescriptor, MusicInstrumentDescriptor_BASE_ITEM_TYPE_OFFSET, MusicInstrumentDescriptor_BASE_ITEM_TYPE_WIDTH ) );
                                                             // univers fortitu will    reflex  perform conting
    struct WeightedSelector propertyDie = WeightedDie_create( "|026,010|027,016|028,016|029,016|061,100|080,010" );

    if( !isForAStore ) {
        int curseWeight = propertyDie.totalWeight/40;
        propertyDie = WeightedDie_addFace( propertyDie, IPS_FEATURE_ID_CONFUSION_ON_DAMAGE, curseWeight ); // agrega la maldición confusion al recibir daño con 1/30 de chance
        propertyDie = WeightedDie_addFace( propertyDie, IPS_FEATURE_ID_HOSTILITY_BY_PARTNERS, curseWeight ); // agrega la maldición hostilidad desenfrenada de los compañeros de equipo
    }

    return IPS_Item_build( container, baseItemTemplate, baseItemType, baseItemGoldValue, 1, desiredLevel, propertyDie, isForAStore, FALSE );
}


