/******************* Random Treasure Generator *********************************
package: Random Treasure Generator - include
Autor: Inquisidor
Descripcion: funcion que genera un tesoro. Puede ser un item u oro.
*******************************************************************************/
#include "SPC_Cofre_inc"
#include "IPS_RTG_inc"
#include "CIB_frente"
#include "RTG_itf"

struct RTG_RacialDistribution {
    float goldFraction;
    float ammoFraction;
    float singularItemFraction;
    string ammoTypeDistribution;
    string singularItemTypeDistribution;
};

struct RTG_RacialDistribution RTG_getRacialDistribution( object specimen );
struct RTG_RacialDistribution RTG_getRacialDistribution( object specimen ) {
    struct RTG_RacialDistribution distribution;

    distribution.goldFraction = 0.38;
    distribution.singularItemFraction = 0.60;
    distribution.ammoFraction = 0.02;

    if( GetIsPlayableRacialType( specimen ) ) {
        distribution.goldFraction = 0.15;
        distribution.singularItemFraction = 0.83;
        distribution.ammoFraction = 0.02;
            //                                           |meleeW |rangedW|robeA  |lightA |mediumA|heavyA |smallSh|largeSh|towerSh|necklac|ring   |bracer |helmet |cloack |belt   |boots  |  |
            distribution.singularItemTypeDistribution = "|000,100|010,100|030,050|031,050|034,050|036,050|041,050|042,050|043,050|050,050|060,050|070,050|080,050|090,050|100,050|110,050";
            //                                   |throwiW|arrows |bolts  |bullets|
            distribution.ammoTypeDistribution = "|020,300|120,170|121,100|122,030";
    }
    else switch( GetRacialType( specimen ) ) {
        case RACIAL_TYPE_ABERRATION:
            //                                           |robeA  |smallSh|necklac|ring   |bracer |helmet |cloack |belt   |
            distribution.singularItemTypeDistribution = "|030,100|041,050|050,050|060,050|070,050|080,050|090,050|100,050";
            //                                   |throwiW|arrows |bolts  |bullets|
            distribution.ammoTypeDistribution = "|020,300|120,170|121,100|122,030";
            break;
        case RACIAL_TYPE_ANIMAL:
            distribution.goldFraction = 0.45;
            distribution.singularItemFraction = 0.52;
            distribution.ammoFraction = 0.03;
            //                                           |meleeW |robeA  |lightA |smallSh|necklac|ring   |bracer |helmet |cloack |belt   |boots
            distribution.singularItemTypeDistribution = "|000,020|030,020|031,100|041,020|050,050|060,050|070,050|080,050|090,020|100,050|110,050";
            //                                   |throwiW|arrows |bolts  |bullets|
            distribution.ammoTypeDistribution = "|020,300|120,170|121,100|122,030";
            break;
        case RACIAL_TYPE_BEAST:
            distribution.goldFraction = 0.40;
            distribution.singularItemFraction = 0.57;
            distribution.ammoFraction = 0.03;
            //                                           |meleeW |rangedW|robeA  |lightA |smallSh|largeSh|necklac|ring   |bracer |helmet |cloack |belt   |boots  |
            distribution.singularItemTypeDistribution = "|000,100|010,040|030,050|031,030|041,030|042,015|050,050|060,050|070,050|080,050|090,050|100,050|110,050";
            //                                   |throwiW|arrows |bolts  |bullets|
            distribution.ammoTypeDistribution = "|020,120|120,170|121,100|122,030";
            break;
        case RACIAL_TYPE_CONSTRUCT:
            distribution.goldFraction = 0.85;
            distribution.singularItemFraction = 0.14;
            distribution.ammoFraction = 0.01;
            //                                           |meleeW |rangedW|heavyA |smallSh|largeSh|towerSh|necklac|ring   |bracer |helmet |cloack |belt   |boots  |
            distribution.singularItemTypeDistribution = "|000,100|010,100|036,060|041,050|042,050|043,050|050,030|060,030|070,050|080,050|090,020|100,020|110,010";
            //                                   |throwiW|arrows |bolts  |bullets|
            distribution.ammoTypeDistribution = "|020,300|120,170|121,100|122,030";
            break;
        case RACIAL_TYPE_DRAGON:
            distribution.goldFraction = 0.20;
            distribution.singularItemFraction = 0.79;
            distribution.ammoFraction = 0.01;
            //                                           |meleeW |rangedW|robeA  |lightA |mediumA|heavyA |smallSh|largeSh|towerSh|necklac|ring   |bracer |helmet |cloack |belt   |boots  |
            distribution.singularItemTypeDistribution = "|000,100|010,100|030,050|031,050|034,050|036,050|041,050|042,050|043,050|050,050|060,050|070,050|080,050|090,050|100,050|110,050";
            //                                   |throwiW|arrows |bolts  |bullets|
            distribution.ammoTypeDistribution = "|020,300|120,170|121,100|122,030";
            break;
        case RACIAL_TYPE_ELEMENTAL:
            distribution.goldFraction = 0.30;
            distribution.singularItemFraction = 0.69;
            distribution.ammoFraction = 0.01;
            //                                           |meleeW |robeA  |lightA |mediumA|smallSh|largeSh|necklac|ring   |bracer |helmet |cloack |belt
            distribution.singularItemTypeDistribution = "|000,100|030,005|031,010|034,015|041,020|042,020|050,040|060,040|070,030|080,020|090,010|100,030";
            //                                   |throwiW|arrows |bolts  |bullets|
            distribution.ammoTypeDistribution = "|020,300|120,170|121,100|122,030";
            break;
        case RACIAL_TYPE_FEY:
            //                                           |meleeW |rangedW|robeA  |lightA |mediumA|smallSh|largeSh|towerSh|necklac|ring   |bracer |helmet |cloack |belt   |boots  |
            distribution.singularItemTypeDistribution = "|000,100|010,100|030,050|031,050|034,050|041,050|042,050|043,050|050,050|060,050|070,050|080,050|090,050|100,050|110,050";
            //                                   |throwiW|arrows |bolts  |bullets|
            distribution.ammoTypeDistribution = "|020,300|120,170|121,100|122,030";
            break;
        case RACIAL_TYPE_GIANT:
            //                                           |meleeW |robeA  |lightA |mediumA|heavyA |smallSh|largeSh|towerSh|necklac|ring   |bracer |helmet |cloack |belt   |boots
            distribution.singularItemTypeDistribution = "|000,140|030,050|031,050|034,050|036,050|041,050|042,050|043,050|050,050|060,050|070,050|080,050|090,050|100,050|110,050";
            //                                   |throwiW|
            distribution.ammoTypeDistribution = "|020,300";
            break;
        case RACIAL_TYPE_HUMANOID_GOBLINOID:
            distribution.goldFraction = 0.30;
            distribution.singularItemFraction = 0.68;
            distribution.ammoFraction = 0.02;
            //                                           |meleeW |rangedW|robeA  |lightA |mediumA|heavyA |smallSh|largeSh|towerSh|necklac|ring   |bracer |helmet |cloack |belt   |boots  |
            distribution.singularItemTypeDistribution = "|000,100|010,100|030,050|031,050|034,050|036,050|041,050|042,050|043,050|050,050|060,050|070,050|080,050|090,050|100,050|110,050";
            //                                   |throwiW|arrows |bolts  |bullets|
            distribution.ammoTypeDistribution = "|020,300|120,170|121,100|122,030";
            break;
        case RACIAL_TYPE_HUMANOID_MONSTROUS:
            distribution.goldFraction = 0.28;
            distribution.singularItemFraction = 0.70;
            distribution.ammoFraction = 0.02;
            //                                           |meleeW |rangedW|robeA  |lightA |mediumA|heavyA |smallSh|largeSh|towerSh|necklac|ring   |bracer |helmet |cloack |belt   |boots  |
            distribution.singularItemTypeDistribution = "|000,100|010,100|030,050|031,050|034,050|036,050|041,050|042,050|043,050|050,050|060,050|070,050|080,050|090,050|100,050|110,050";
            //                                   |throwiW|arrows |bolts  |bullets|
            distribution.ammoTypeDistribution = "|020,300|120,170|121,100|122,030";
            break;
        case RACIAL_TYPE_HUMANOID_ORC:
            distribution.goldFraction = 0.25;
            distribution.singularItemFraction = 0.72;
            distribution.ammoFraction = 0.03;
            //                                           |meleeW |rangedW|robeA  |lightA |mediumA|heavyA |smallSh|largeSh|towerSh|necklac|ring   |bracer |helmet |cloack |belt   |boots  |
            distribution.singularItemTypeDistribution = "|000,100|010,100|030,050|031,050|034,050|036,050|041,050|042,050|043,050|050,050|060,050|070,050|080,050|090,050|100,050|110,050";
            //                                   |throwiW|arrows |bolts  |bullets|
            distribution.ammoTypeDistribution = "|020,600|120,170|121,100|122,030";
            break;
        case RACIAL_TYPE_HUMANOID_REPTILIAN:
            distribution.goldFraction = 0.23;
            distribution.singularItemFraction = 0.75;
            distribution.ammoFraction = 0.02;
            //                                           |meleeW |rangedW|robeA  |lightA |mediumA|heavyA |smallSh|largeSh|towerSh|necklac|ring   |bracer |helmet |cloack |belt   |boots  |
            distribution.singularItemTypeDistribution = "|000,100|010,100|030,050|031,050|034,050|036,050|041,050|042,050|043,050|050,050|060,050|070,050|080,050|090,050|100,050|110,050";
            //                                   |throwiW|arrows |bolts  |bullets|
            distribution.ammoTypeDistribution = "|020,300|120,170|121,100|122,030";
            break;
        case RACIAL_TYPE_MAGICAL_BEAST:
            //                                           |meleeW |robeA  |lightA |mediumA|smallSh|largeSh|necklac|ring   |bracer |helmet |cloack |belt   |boots  |
            distribution.singularItemTypeDistribution = "|000,060|010,040|031,030|034,010|041,030|042,010|050,060|060,060|070,050|080,040|090,050|100,050|110,050";
            //                                   |throwiW|arrows |bolts  |bullets|
            distribution.ammoTypeDistribution = "|020,300|120,170|121,100|122,030";
            break;
        case RACIAL_TYPE_OOZE:
            //                                           |meleeW |mediumA|heavyA |smallSh|largeSh|towerSh|necklac|ring   |bracer |helmet |boots
            distribution.singularItemTypeDistribution = "|000,080|034,040|036,040|041,040|042,040|043,050|050,030|060,010|070,040|080,050|110,020";
            //                                   |throwiW|bullets|
            distribution.ammoTypeDistribution = "|020,300|122,300";
            break;
        case RACIAL_TYPE_OUTSIDER:
            //                                           |meleeW |rangedW|robeA  |lightA |mediumA|heavyA |smallSh|largeSh|towerSh|necklac|ring   |bracer |helmet |cloack |belt   |boots  |
            distribution.singularItemTypeDistribution = "|000,100|010,100|030,050|031,050|034,050|036,050|041,050|042,050|043,050|050,050|060,050|070,050|080,050|090,050|100,050|110,050";
            //                                   |throwiW|arrows |bolts  |bullets|
            distribution.ammoTypeDistribution = "|020,300|120,170|121,100|122,030";
            break;
        case RACIAL_TYPE_SHAPECHANGER:
            //                                           |meleeW |rangedW|robeA  |lightA |mediumA|heavyA |smallSh|largeSh|towerSh|necklac|ring   |bracer |helmet |cloack |belt   |boots  |
            distribution.singularItemTypeDistribution = "|000,100|010,100|030,050|031,050|034,050|036,050|041,050|042,050|043,050|050,050|060,050|070,050|080,050|090,050|100,050|110,050";
            //                                   |throwiW|arrows |bolts  |bullets|
            distribution.ammoTypeDistribution = "|020,300|120,170|121,100|122,030";
            break;
        case RACIAL_TYPE_UNDEAD:
            distribution.goldFraction = 0.25;
            distribution.singularItemFraction = 0.74;
            distribution.ammoFraction = 0.01;
            //                                           |meleeW |rangedW|robeA  |lightA |mediumA|heavyA |smallSh|largeSh|towerSh|necklac|ring   |bracer |helmet |cloack |belt   |boots  |
            distribution.singularItemTypeDistribution = "|000,100|010,100|030,050|031,050|034,050|036,050|041,050|042,050|043,050|050,050|060,050|070,050|080,050|090,050|100,050|110,050";
            //                                   |throwiW|arrows |bolts  |bullets|
            distribution.ammoTypeDistribution = "|020,300|120,170|121,100|122,030";
            break;
        case RACIAL_TYPE_VERMIN:
            //                                           |meleeW |smallSh|necklac|ring   |bracer |helmet |belt   |boots  |
            distribution.singularItemTypeDistribution = "|000,040|041,030|050,050|060,050|070,050|080,050|100,050|110,050";
            //                                   |throwiW|arrows |bolts  |bullets|
            distribution.ammoTypeDistribution = "|020,300|120,015|121,015|122,020";
            break;

        case RACIAL_TYPE_INVALID: // anything that is not a creature: containers
            distribution.goldFraction = 0.32;
            distribution.singularItemFraction = 0.67;
            distribution.ammoFraction = 0.01;
            //                                           |meleeW |rangedW|robeA  |lightA |mediumA|heavyA |smallSh|largeSh|towerSh|necklac|ring   |bracer |helmet |cloack |belt   |boots  |
            distribution.singularItemTypeDistribution = "|000,100|010,100|030,050|031,050|034,050|036,050|041,050|042,050|043,050|050,050|060,050|070,050|080,050|090,050|100,050|110,050";
            //                                   |throwiW|arrows |bolts  |bullets|
            distribution.ammoTypeDistribution = "|020,300|120,170|121,100|122,030";
            break;

        default:
            //                                           |meleeW |rangedW|robeA  |lightA |mediumA|heavyA |smallSh|largeSh|towerSh|necklac|ring   |bracer |helmet |cloack |belt   |boots  |
            distribution.singularItemTypeDistribution = "|000,100|010,100|030,050|031,050|034,050|036,050|041,050|042,050|043,050|050,050|060,100|070,050|080,050|090,050|100,050|110,050";
            //                                   |throwiW|arrows |bolts  |bullets|
            distribution.ammoTypeDistribution = "|020,300|120,170|121,100|122,030";
            break;
    }

    return distribution;
}


object RTG_generateItem( string typeDistribution, object container, float desiredLevel );
object RTG_generateItem( string typeDistribution, object container, float desiredLevel ) {
    object item;
    struct WeightedSelector die = WeightedDie_create( typeDistribution );
    int itemType = WeightedDie_throw( die );
//    SendMessageToPC( GetFirstPC(), "RTG_generateItem: itemType="+IntToString(itemType) );
    switch( itemType ) {
    case 00: item = IPS_Item_generateMeleeWeapon( container, desiredLevel, ALL_MELEE_WEAPONS_DESCRIPTORS_ARRAY_1 + ALL_MELEE_WEAPONS_DESCRIPTORS_ARRAY_2 + ALL_MELEE_WEAPONS_DESCRIPTORS_ARRAY_3);
        break;
    case 10: item = IPS_Item_generateRangedWeapon( container, desiredLevel, ALL_RANGED_WEAPONS_DESCRIPTORS_ARRAY );
        break;
    case 20: item = IPS_Item_generateThrowingWeapon( container, desiredLevel, ALL_THROWING_WEAPONS_DESCRIPTORS_ARRAY );
        break;
    case 30: item = IPS_Item_generateArmor( container, desiredLevel, ROBE_ARMOR_DESCRIPTORS_ARRAY );
        break;
    case 31: item = IPS_Item_generateArmor( container, desiredLevel, LIGHT_ARMOR_DESCRIPTORS_ARRAY);
        break;
    case 34: item = IPS_Item_generateArmor( container, desiredLevel, MEDIUM_ARMOR_DESCRIPTORS_ARRAY );
        break;
    case 36: item = IPS_Item_generateArmor( container, desiredLevel, HEAVY_ARMOR_DESCRIPTORS_ARRAY );
        break;
    case 41: item = IPS_Item_generateSmallShield( container, desiredLevel );
        break;
    case 42: item = IPS_Item_generateLargeShield( container, desiredLevel );
        break;
    case 43: item = IPS_Item_generateTowerShield( container, desiredLevel );
        break;
    case 50: item = IPS_Item_generateNecklace( container, desiredLevel );
        break;
    case 60: item = IPS_Item_generateRing( container, desiredLevel );
        break;
    case 70: item = IPS_Item_generateBracer( container, desiredLevel );
        break;
    case 80: item = IPS_Item_generateHelmet( container, desiredLevel );
        break;
    case 90: item = IPS_Item_generateCloack( container, desiredLevel );
        break;
    case 100: item = IPS_Item_generateBelt( container, desiredLevel );
        break;
    case 110: item = IPS_Item_generateBoots( container, desiredLevel );
        break;
    case 120: item = IPS_Item_generateArrowsPack( container, desiredLevel );
        break;
    case 121: item = IPS_Item_generateBoltsPack( container, desiredLevel );
        break;
    case 122: item = IPS_Item_generateBulletsPack( container, desiredLevel );
        break;
    }
    if( !GetIsObjectValid(item) )
        WriteTimestampedLogEntry("RTG_generateItem: Error! itemType="+IntToString(itemType)+", desiredLevel="+FloatToString(desiredLevel)+", typeDistribution="+typeDistribution );
    return item;
}



int RTG_calculateNumberOfSuccesses( float esperance, float maxChance=0.5 ) {
    int successes = 0;
    // Para lograr la esperanza recibida, uso una variable aleatoria con distribucion binomial de 'numberOfTries' experimentos cada uno con probalidad 'chanceOfEachTry' de exito. Dado que es binomial, la esperanza es numberOfTries*chanceOfEachTry.
    int numberOfTries = 1 + FloatToInt( esperance/maxChance ); // eligo la cantidad minima de experimentos tal que la probabilidad de exito de cada uno no supere 'maxChance'.
    // Una vez determinada la cantidad de experimentos 'numberOfTries', la probabilidad de exito de cada uno (chanceOfEachTry) es igual a esperance/tries
    int chanceOfEachTryX10000 = FloatToInt(10000.0*esperance)/numberOfTries; // Esto es cierto porque se trata de una
//    SendMessageToPC( GetFirstPC(), "esperance="+FloatToString(esperance)+", numberOfTries="+IntToString(numberOfTries)+", chanceOfEachTryX10000="+IntToString(chanceOfEachTryX10000) );
    while( --numberOfTries >= 0 ) {
        int dice = Random(10000);
//        SendMessageToPC( GetFirstPC(), "dice="+IntToString(dice) );
        if( dice < chanceOfEachTryX10000 )
            successes += 1;
    }
    return successes;
}


// Genera un tesoro tal que: (1) la esperanza del valor genuino del tesoro sea desiredCr * RTG_TOKEN_VALUE_PER_CR,
// y (2) los items sean del nivel dado por IPS_crToLevel('desiredCr').
// 'desiredCr' CR del encuento. Determina el nivel de los items que se generan (nivel=CR^IPS_ITEM_CR_TO_LEVEL_EXPONENT), y el monto de oro.
// 'numberOfTokensEsperance' esperanza de la cantidad de tokens que se pretende generar dentro del contenedor. Un token es la unidad de tesoro y vale 'desiredCr'*RTG_TOKEN_VALUE_PER_CR.
// 'beneficiario' cuando el tesoro es un ítem singular, indica a quienes se le recervará el ítem, que son los PJ que estén en el party en que este 'beneficiario' y que esten en el mismo área que 'beneficiario' cuando esta operacion es llamada.
// Devuelve un reporte que informa en cual de los contenedores destino se pusieron bienes. Si el bit 1 esta puesto, el cadaver recibió algún bien. Y si el bit 2 esta puesto, el cofre recibio algún bien.
// La distribucion de probabilidad de los distintos tipos de elementos que componen el tesoro generado, depende de la
// raza del contenedor. Pero siempre es tal que la esperanza del valor genuino del tesoro sea desiredLevel * RTG_TOKEN_VALUE_PER_CR.
int RTG_determineLoot( object cadaver, float desiredCr, float numberOfTokensEsperance, object beneficiario, float reservationDuration=100.0 );
int RTG_determineLoot( object cadaver, float desiredCr, float numberOfTokensEsperance, object beneficiario, float reservationDuration=100.0 ) {
    object cofre;
    int seIntentoGenerarCofre = FALSE;
    int reporte;
//    SendMessageToPC( GetFirstPC(), "desiredCr="+FloatToString( desiredCr )+", numTokenEsperance="+FloatToString(numberOfTokensEsperance) );
    struct RTG_RacialDistribution racialDistribution = RTG_getRacialDistribution( cadaver );

    // valorUnToken = desiredCr * RTG_TOKEN_VALUE_PER_CR
    // esperanzaNumTokens * valorUnToken = esperanzaValorTesoro = esperanzaValorItems + esperanzaValorAmmoPacks + esperanzaOro
    // 1 = fraccionItems + fraccionAmmoPacks + fraccionOro
    // esperanzaValorItems = fraccionItems * esperanzaValorTesoro; esperanzaValorAmmoPacks = fraccionAmmoPacks * esperanzaValorTesoro; esperanzaCantOro = fraccionOro * esperanzaCantOro;
    // desiredLevel = desiredCr ^ IPS_ITEM_CR_TO_LEVEL_EXPONENT

    float desiredLevel = IPS_crToLevel( desiredCr );

    // esperanzaValorItems = fraccionItems * esperanzaNumTokens * valorUnToken
    // esperanzaValorItems = esperanzaNumItems * valorUnItem
    // esperanzaNumItems = esperanzaValorItems / valorUnItem = fraccionItems * esperanzaNumTokens * valorUnToken / valorUnItem
    // valorUnItem = desiredLevel * IPS_ITEM_VALUE_PER_LEVEL
    // esperanzaNumItems = fraccionItems * esperanzaNumTokens * desiredCr * RTG_TOKEN_VALUE_PER_CR / (desiredLevel * IPS_ITEM_VALUE_PER_LEVEL)
    float esperanceOfNumberOfSingularItems = racialDistribution.singularItemFraction * numberOfTokensEsperance * desiredCr * RTG_TOKEN_VALUE_PER_CR / (desiredLevel * IPS_ITEM_VALUE_PER_LEVEL);
    int numberOfSingularItems = RTG_calculateNumberOfSuccesses( esperanceOfNumberOfSingularItems );
    if( numberOfSingularItems > 0 && GetIsObjectValid( beneficiario ) ) {
        // determinar el cofre donde se dejarían los bienes en caso que se generaran.
        cofre = SPC_Cofre_determinarDestinoTesoro( cadaver );
        seIntentoGenerarCofre = TRUE;
//        SendMessageToPC( GetFirstPC(), "RTG_determineLoot: 1- cofre ="+GetResRef( cofre ) );
    }
//    SendMessageToPC( GetFirstPC(), "esperanceOfNumberOfSingularItems="+FloatToString(esperanceOfNumberOfSingularItems)+", numberOfSingularItems="+IntToString(numberOfSingularItems) );
    while( --numberOfSingularItems >= 0 ) {
        if( GetIsObjectValid( cofre ) ) { // notar que 'cofre' solo puede ser válido si 'beneficiario' es válido
            object item = RTG_generateItem( racialDistribution.singularItemTypeDistribution, cofre, desiredLevel );
            CIB_Item_repartir( item, beneficiario );
            reporte |= 2;
//            SendMessageToPC( GetFirstPC(), "RTG_determineLoot: 2- item="+GetName(item) );
        }
        else {
            object item = RTG_generateItem( racialDistribution.singularItemTypeDistribution, cadaver, desiredLevel );
            CIB_distribuir( item, reservationDuration );
            reporte |= 1;
//            SendMessageToPC( GetFirstPC(), "RTG_determineLoot: 3- item="+GetName(item) );
       }
    }

    // esperanzaValorAmmoPacks = fraccionAmmoPacks * esperanzaNumTokens * valorUnToken
    // esperanzaValorAmmoPacks = esperanzaNumAmmoPacks * valorUnAmmoPack
    // esperanzaNumAmmoPacks = esperanzaValorAmmoPacks / valorUnAmmoPack = fraccionAmmoPacks * esperanzaNumTokens * valorUnToken / valorUnAmmoPack
    // valorUnAmmoPack = desiredLevel * IPS_ITEM_VALUE_PER_LEVEL * IPS_AMMO_PACK_SIZE / IPS_AMMO_VALUE_DIVISOR
    // esperanzaNumAmmoPacks = fraccionAmmoPacks * esperanzaNumTokens * desiredCr * RTG_TOKEN_VALUE_PER_CR / (desiredLevel * IPS_ITEM_VALUE_PER_LEVEL * IPS_AMMO_PACK_SIZE / IPS_AMMO_VALUE_DIVISOR)
    float esperanceOfNumberOfAmmoPacks = racialDistribution.ammoFraction * numberOfTokensEsperance * desiredCr * RTG_TOKEN_VALUE_PER_CR * IPS_AMMO_VALUE_DIVISOR / ( desiredLevel * IPS_ITEM_VALUE_PER_LEVEL * IPS_AMMO_PACK_SIZE );
    int numberOfAmmoPacks = RTG_calculateNumberOfSuccesses( esperanceOfNumberOfAmmoPacks );
//    SendMessageToPC( GetFirstPC(), "esperanceOfNumberOfAmmoPacks="+FloatToString(esperanceOfNumberOfAmmoPacks)+", numberOfAmmoPacks="+IntToString(numberOfAmmoPacks) );
    while( --numberOfAmmoPacks >= 0 ) {
        object item = RTG_generateItem( racialDistribution.ammoTypeDistribution, cadaver, desiredLevel );
        reporte |= 1;
    }

    // esperanzaCantOro = fraccionOro * esperanzaNumTokens * valorUnToken
    // esperanzaCantOro = esperanzaNumBolsasOro * valorUnaBolsaOro
    // esperanzaNumBolsasOro = esperanzaCantOro / valorUnaBolsaOro = fraccionOro * esperanzaNumTokens * valorUnToken / valorUnaBolsaOro
    // valorUnaBolsaOro = valorUnToken = desiredCr * RTG_TOKEN_VALUE_PER_CR
    // esperanzaNumBolsasOro = fraccionOro * esperanzaNumTokens
    float esperanceOfNumberOfGoldBags = racialDistribution.goldFraction * numberOfTokensEsperance;
    int numberOfGoldBags = RTG_calculateNumberOfSuccesses( esperanceOfNumberOfGoldBags );

    // si hay que generar bolsas de oro en el cofre y el cofre no fue obtenido, obtenerlo
    if( numberOfGoldBags > 0 && !seIntentoGenerarCofre && GetIsObjectValid( beneficiario ) ) {
        // determinar el cofre donde se dejarían los bienes en caso que se generaran.
        cofre = SPC_Cofre_determinarDestinoTesoro( cadaver );
//        SendMessageToPC( GetFirstPC(), "RTG_determineLoot: 4 - cofre ="+GetResRef( cofre ) );
    }
//    SendMessageToPC( GetFirstPC(), "esperanceOfNumberOfGoldBags="+FloatToString(esperanceOfNumberOfGoldBags)+", numberOfGoldBags="+IntToString(numberOfGoldBags) );
    while( --numberOfGoldBags >= 0 ) {
        if( GetIsObjectValid( cofre ) ) { // notar que 'cofre' solo puede ser válido si 'beneficiario' es válido
            CIB_Oro_generarEnContenedor( cofre, FloatToInt( desiredCr*RTG_TOKEN_VALUE_PER_CR ), TRUE );
            reporte |= 2;
        }
        else {
            CIB_Oro_generarEnContenedor( cadaver ,FloatToInt( desiredCr*RTG_TOKEN_VALUE_PER_CR ), (reservationDuration > 0.0 || GetIsObjectValid(beneficiario)) );
            reporte |= 1;
        }
    }

    return reporte;
}



/* Versión vieja de RTG_determineLoot(..)'
// Genera un tesoro tal que: (1) la esperanza del valor genuino del tesoro sea desiredLevel * RTG_TOKEN_VALUE_PER_LEVEL,
// y (2) los items sean del nivel dado por 'desiredLevel'.
// 'desiredLevel' nivel de calidad del loot. Determina el nivel de los items que se generan, y el monto de oro.
// 'numberOfTokensEsperance' esperanza de la cantidad de tokens que se pretende generar dentro del contenedor. Un token es la unidad de tesoro y vale 'desiredLevel'*RTG_TOKEN_VALUE_PER_LEVEL.
// 'beneficiario' cuando el tesoro es un ítem singular, indica a quienes se le recervará el ítem, que son los PJ que estén en el party en que este 'beneficiario' y que esten en el mismo área que 'beneficiario' cuando esta operacion es llamada.
// Devuelve un reporte que informa en cual de los contenedores destino se pusieron bienes. Si el bit 1 esta puesto, el cadaver recibió algún bien. Y si el bit 2 esta puesto, el cofre recibio algún bien.
// La distribucion de probabilidad de los distintos tipos de elementos que componen el tesoro generado, depende de la
// raza del contenedor. Pero siempre es tal que la esperanza del valor genuino del tesoro sea desiredLevel * RTG_TOKEN_VALUE_PER_LEVEL.
int RTG_determineLoot( object cadaver, float desiredLevel, float numberOfTokensEsperance, object beneficiario, float reservationDuration=100.0 );
int RTG_determineLoot( object cadaver, float desiredLevel, float numberOfTokensEsperance, object beneficiario, float reservationDuration=100.0 ) {
    object cofre;
    int seIntentoGenerarCofre = FALSE;
    int reporte;
//    SendMessageToPC( GetFirstPC(), "desiredLevel="+FloatToString( desiredLevel )+", numTokenEsperance="+FloatToString(numberOfTokensEsperance) );
    struct RTG_RacialDistribution racialDistribution = RTG_getRacialDistribution( cadaver );

    float esperanceOfNumberOfSingularItems = racialDistribution.singularItemFraction * numberOfTokensEsperance * RTG_TOKEN_VALUE_PER_LEVEL / IPS_ITEM_VALUE_PER_LEVEL;
    int numberOfSingularItems = RTG_calculateNumberOfSuccesses( esperanceOfNumberOfSingularItems );
    if( numberOfSingularItems > 0 && GetIsObjectValid( beneficiario ) ) {
        // determinar el cofre donde se dejarían los bienes en caso que se generaran.
        cofre = SPC_Cofre_determinarDestinoTesoro( cadaver );
        seIntentoGenerarCofre = TRUE;
//        SendMessageToPC( GetFirstPC(), "RTG_determineLoot: 1- cofre ="+GetResRef( cofre ) );
    }
//    SendMessageToPC( GetFirstPC(), "esperanceOfNumberOfSingularItems="+FloatToString(esperanceOfNumberOfSingularItems)+", numberOfSingularItems="+IntToString(numberOfSingularItems) );
    while( --numberOfSingularItems >= 0 ) {
        if( GetIsObjectValid( cofre ) ) { // notar que 'cofre' solo puede ser válido si 'beneficiario' es válido
            object item = RTG_generateItem( racialDistribution.singularItemTypeDistribution, cofre, desiredLevel );
            CIB_Item_repartir( item, beneficiario );
            reporte |= 2;
//            SendMessageToPC( GetFirstPC(), "RTG_determineLoot: 2- item="+GetName(item) );
        }
        else {
            object item = RTG_generateItem( racialDistribution.singularItemTypeDistribution, cadaver, desiredLevel );
            CIB_distribuir( item, reservationDuration );
            reporte |= 1;
//            SendMessageToPC( GetFirstPC(), "RTG_determineLoot: 3- item="+GetName(item) );
       }
    }

    float esperanceOfNumberOfAmmoPacks = racialDistribution.ammoFraction * numberOfTokensEsperance * RTG_TOKEN_VALUE_PER_LEVEL * IPS_AMMO_VALUE_DIVISOR / ( IPS_ITEM_VALUE_PER_LEVEL * IPS_AMMO_PACK_SIZE );
    int numberOfAmmoPacks = RTG_calculateNumberOfSuccesses( esperanceOfNumberOfAmmoPacks );
//    SendMessageToPC( GetFirstPC(), "esperanceOfNumberOfAmmoPacks="+FloatToString(esperanceOfNumberOfAmmoPacks)+", numberOfAmmoPacks="+IntToString(numberOfAmmoPacks) );
    while( --numberOfAmmoPacks >= 0 ) {
        object item = RTG_generateItem( racialDistribution.ammoTypeDistribution, cadaver, desiredLevel );
        reporte |= 1;
    }


    float esperanceOfNumberOfGoldBags = racialDistribution.goldFraction * numberOfTokensEsperance;
    int numberOfGoldBags = RTG_calculateNumberOfSuccesses( esperanceOfNumberOfGoldBags );

    // si hay que generar bolsas de oro en el cofre y el cofre no fue obtenido, obtenerlo
    if( numberOfGoldBags > 0 && !seIntentoGenerarCofre && GetIsObjectValid( beneficiario ) ) {
        // determinar el cofre donde se dejarían los bienes en caso que se generaran.
        cofre = SPC_Cofre_determinarDestinoTesoro( cadaver );
//        SendMessageToPC( GetFirstPC(), "RTG_determineLoot: 4 - cofre ="+GetResRef( cofre ) );
    }
//    SendMessageToPC( GetFirstPC(), "esperanceOfNumberOfGoldBags="+FloatToString(esperanceOfNumberOfGoldBags)+", numberOfGoldBags="+IntToString(numberOfGoldBags) );
    while( --numberOfGoldBags >= 0 ) {
        if( GetIsObjectValid( cofre ) ) { // notar que 'cofre' solo puede ser válido si 'beneficiario' es válido
            CIB_Oro_generarEnContenedor( cofre, FloatToInt( desiredLevel*RTG_TOKEN_VALUE_PER_LEVEL ), TRUE );
            reporte |= 2;
        }
        else {
            CIB_Oro_generarEnContenedor( cadaver ,FloatToInt( desiredLevel*RTG_TOKEN_VALUE_PER_LEVEL ), (reservationDuration > 0.0 || GetIsObjectValid(beneficiario)) );
            reporte |= 1;
        }
    }

    return reporte;
}
*/
