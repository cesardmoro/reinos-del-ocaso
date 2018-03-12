/******************* Item Properties System ************************************
package: Item Properties System - features include
Autor: Inquisidor
Descripcion: sistema manejador de propiedades de items.
Este permite asociar a un item propiedades no visibles que se activan al equiparse.
Ademas soporta el agregado de restricciones inter items, como por ejemplo el no
apilamiento de habilidades y skills dados por items distintos.
*******************************************************************************/
#include "Random_inc"


/******************* FEATURES  TABLE *******************************/

const int IPS_FEATURE_ID_AC_BONUS                       = 0;
const int IPS_FEATURE_ID_ATTACK_BONUS                   = 1;
const int IPS_FEATURE_ID_DAMAGE_BONUS_PHYSICAL          = 2;
const int IPS_FEATURE_ID_DAMAGE_BONUS_ELEMENTAL         = 3;
const int IPS_FEATURE_ID_ENHANCEMENT_BONUS              = 4;
const int IPS_FEATURE_ID_MAX_RANGE_STRENGHT_MOD         = 5;
const int IPS_FEATURE_ID_KEEN                           = 6;
const int IPS_FEATURE_ID_WEIGHT_REDUCTION               = 7;
const int IPS_FEATURE_ID_VAMPIRIC_REGENERATION          = 8;
const int IPS_FEATURE_ID_UNLIMITED_AMMO                 = 9;
const int IPS_FEATURE_ID_ON_HIT_ARMOR_CAST_SPELL        = 10;
const int IPS_FEATURE_ID_ON_HIT_WEAPON_PROPS            = 11;

const int IPS_FEATURE_ID_ABILITY_BEGIN                  = 20; // begin
const int IPS_FEATURE_ID_ABILITY_BONUS_STR              = 20;
const int IPS_FEATURE_ID_ABILITY_BONUS_DEX              = 21;
const int IPS_FEATURE_ID_ABILITY_BONUS_CON              = 22;
const int IPS_FEATURE_ID_ABILITY_BONUS_INT              = 23;
const int IPS_FEATURE_ID_ABILITY_BONUS_WIS              = 24;
const int IPS_FEATURE_ID_ABILITY_BONUS_CHA              = 25;
const int IPS_FEATURE_ID_ABILITY_END                    = 25; // end


const int IPS_FEATURE_ID_BONUS_SAVES_BEGIN              = 26; // begin
const int IPS_FEATURE_ID_BONUS_SAVES_UNIVERSAL          = 26;
const int IPS_FEATURE_ID_BONUS_SAVES_FORTITUDE          = 27;
const int IPS_FEATURE_ID_BONUS_SAVES_WILL               = 28;
const int IPS_FEATURE_ID_BONUS_SAVES_REFLEX             = 29;
const int IPS_FEATURE_ID_BONUS_SAVES_END                = 29; // end

const int IPS_FEATURE_ID_DAMAGE_INMUNITY_BEGIN_FISICAL  = 30; // begin
const int IPS_FEATURE_ID_DAMAGE_INMUNITY_BLUDGEONING    = 30;
const int IPS_FEATURE_ID_DAMAGE_INMUNITY_PIERCING       = 31;
const int IPS_FEATURE_ID_DAMAGE_INMUNITY_SLASHING       = 32;
const int IPS_FEATURE_ID_DAMAGE_INMUNITY_SUBDUAL        = 33;
const int IPS_FEATURE_ID_DAMAGE_INMUNITY_PHYSICAL       = 34;
const int IPS_FEATURE_ID_DAMAGE_INMUNITY_END_FISICAL    = 34; // end

const int IPS_FEATURE_ID_DAMAGE_INMUNITY_BEGIN_ELEMENTAL= 35; // begin
const int IPS_FEATURE_ID_DAMAGE_INMUNITY_MAGICAL        = 35;
const int IPS_FEATURE_ID_DAMAGE_INMUNITY_ACID           = 36;
const int IPS_FEATURE_ID_DAMAGE_INMUNITY_COLD           = 37;
const int IPS_FEATURE_ID_DAMAGE_INMUNITY_DIVINE         = 38;
const int IPS_FEATURE_ID_DAMAGE_INMUNITY_ELECTRICAL     = 39;
const int IPS_FEATURE_ID_DAMAGE_INMUNITY_FIRE           = 40;
const int IPS_FEATURE_ID_DAMAGE_INMUNITY_NEGATIVE       = 41;
const int IPS_FEATURE_ID_DAMAGE_INMUNITY_POSITIVE       = 42;
const int IPS_FEATURE_ID_DAMAGE_INMUNITY_SONIC          = 43;
const int IPS_FEATURE_ID_DAMAGE_INMUNITY_END_ELEMENTAL  = 43; // end

const int IPS_FEATURE_ID_SKILL_BEGIN                    = 50; // begin
const int IPS_FEATURE_ID_SKILL_ANIMAL_EMPATHY           = 50;
const int IPS_FEATURE_ID_SKILL_CONCENTRATION            = 51;
const int IPS_FEATURE_ID_SKILL_DISABLE_TRAP             = 52;
const int IPS_FEATURE_ID_SKILL_DISCIPLINE               = 53;
const int IPS_FEATURE_ID_SKILL_HEAL                     = 54;
const int IPS_FEATURE_ID_SKILL_HIDE                     = 55;
const int IPS_FEATURE_ID_SKILL_LISTEN                   = 56;
const int IPS_FEATURE_ID_SKILL_LORE                     = 57;
const int IPS_FEATURE_ID_SKILL_MOVE_SILENTLY            = 58;
const int IPS_FEATURE_ID_SKILL_OPEN_LOCK                = 59;
const int IPS_FEATURE_ID_SKILL_PARRY                    = 60;
const int IPS_FEATURE_ID_SKILL_PERFORM                  = 61;
const int IPS_FEATURE_ID_SKILL_PERSUADE                 = 62;
const int IPS_FEATURE_ID_SKILL_PICK_POCKET              = 63;
const int IPS_FEATURE_ID_SKILL_SEARCH                   = 64;
const int IPS_FEATURE_ID_SKILL_SET_TRAP                 = 65;
const int IPS_FEATURE_ID_SKILL_SPELLCRAFT               = 66;
const int IPS_FEATURE_ID_SKILL_SPOT                     = 67;
const int IPS_FEATURE_ID_SKILL_TAUNT                    = 68;
const int IPS_FEATURE_ID_SKILL_USE_MAGIC_DEVICE         = 69;
const int IPS_FEATURE_ID_SKILL_APPRAISE                 = 70;
const int IPS_FEATURE_ID_SKILL_TUMBLE                   = 71;
const int IPS_FEATURE_ID_SKILL_CRAFT_TRAP               = 72;
const int IPS_FEATURE_ID_SKILL_BLUFF                    = 73;
const int IPS_FEATURE_ID_SKILL_INTIMIDATE               = 74;
const int IPS_FEATURE_ID_SKILL_CRAFT_ARMOR              = 75;
const int IPS_FEATURE_ID_SKILL_CRAFT_WEAPON             = 76;
const int IPS_FEATURE_ID_SKILL_END                      = 76; // end

const int IPS_FEATURE_ID_CAST_SPELL_CONTINGENCY         = 80;
const int IPS_FEATURE_ID_ARMOR_FORTIFICATION            = 81;
const int IPS_FEATURE_ID_CONFUSION_ON_DAMAGE            = 82;
const int IPS_FEATURE_ID_HOSTILITY_BY_PARTNERS          = 83;

const int IPS_FEATURE_ID_BONUS_FEAT_GREATER_CLEAVE      = 90;



// Get2DAString adapter
string Get2DAStringAdapted(string s2DA, string sColumn, int nRow);
string Get2DAStringAdapted(string s2DA, string sColumn, int nRow) {
    return Get2DAString( s2DA, sColumn, nRow);
}

////////////////////////////////////////////////////////////////////////////////
//// RELACION ENTRE CALIDAD Y LOS PARAMETROS QUALITATIVOS DE UNA PROPIEDAD /////
////////////////////////////////////////////////////////////////////////////////

// calcula el costo de un feature cuyos parametros qualitativos son 'level', 'factor' y 'exponent'.
// 'level' es el nivel de apilamiento o intensidad; 'factor' y 'exponent' son dos coeficientes.
// Esta funcion es inversa a IPS_Feature_calculateLevel() si los parametros 'factor' y 'exponent' se mantienen constantes.
float IPS_Feature_calculateCost( int level, float factor, float exponent = 2.0 );
float IPS_Feature_calculateCost( int level, float factor, float exponent = 2.0 ) {
    return factor*pow( IntToFloat(level), exponent );
}

// calcula el nivel de apilamiento (o intensidad) que se llega pagando los 'featurePoints' dados, para un feature graduable cuyos parametros de valor son 'factor' y 'exponent'.
// Esta funcion es inversa a IPS_Feature_calculateCost() si los parametros 'factor' y 'exponent' se mantienen constantes.
float IPS_Feature_calculateLevel( float featurePoints, float factor, float exponent );
float IPS_Feature_calculateLevel( float featurePoints, float factor, float exponent ) {
    return pow( featurePoints/factor, 1.0/exponent );
}


////////////////////////////////////////////////////////////////////////////////
////////////////// Generador de intensidad al azar /////////////////////////////
////////////////////////////////////////////////////////////////////////////////

struct IPS_FeatureIntensityAndCost {
    int intensity;
    float cost;
};
// Esta funcion genera al azar un nivel de intensidad 'N' en el rango de 1 a 'fcp.maxLevel' conciderando los feature points disponibles, y calcula el costo (en feature points) correspondiente.
struct IPS_FeatureIntensityAndCost IPS_generateRandomIntensity( float remainingFeaturePoints, struct IPS_FeatureCostParams fcp, float probabilityDistributionModifier=0.25 );
struct IPS_FeatureIntensityAndCost IPS_generateRandomIntensity( float remainingFeaturePoints, struct IPS_FeatureCostParams fcp, float probabilityDistributionModifier=0.25 ) {
//    SendMessageToPC( GetFirstPC(), "IPS_generateRandomIntensity: remainingFeaturePoints="+FloatToString(remainingFeaturePoints)+", factor="+FloatToString(fcp.factor)+", maxLevel="+IntToString(fcp.maxLevel) );
    struct IPS_FeatureIntensityAndCost result;
    if( remainingFeaturePoints >= fcp.factor && fcp.maxLevel > 0 ) {
        // sorteo de la cantidad tentativa de feature points que se consumirán por la propiedad. La distribucion no es uniforme, si tal que haya mas chance de valores altos.
        float randomCost = pow( IntToFloat(Random(101))/100.0, probabilityDistributionModifier ) * remainingFeaturePoints; // medido en featurePoints
        // se objtiene el nivel correspondiente al costo generado al azar. El 0.5 es para redondear.
        result.intensity = FloatToInt( 0.5 + IPS_Feature_calculateLevel( randomCost, fcp.factor, fcp.exponent ) );
        if( result.intensity > fcp.maxLevel )
            result.intensity = fcp.maxLevel;
        else if( result.intensity == 0 )
            result.intensity = 1;
        result.cost = IPS_Feature_calculateCost( result.intensity, fcp.factor, fcp.exponent );
        // si el redondeo hacia arriba del nivel hizo que el costo (en feature points) de la propiedad supere la cantidad feature points disponibles, bajar un nivel y recalcular el costo
        if( result.cost > remainingFeaturePoints ) {
            result.intensity -= 1;
            result.cost = IPS_Feature_calculateCost( result.intensity, fcp.factor, fcp.exponent );
        }
    }
    return result;
}


////////////////////////////////////////////////////////////////////////////////
//////////// funciones secundarias para determinacion del costo ////////////////
////////////////////////////////////////////////////////////////////////////////

float IPS_Feature_getDamageModifier( int baseItemType );
float IPS_Feature_getDamageModifier( int baseItemType ) {
    if( baseItemType == BASE_ITEM_GLOVES )
        return 2.15; // 0.75 / 1 / (1+3) * (10+2) / pow(10/40,0.1) * 0.83
    int numDices = StringToInt( Get2DAStringAdapted( "baseItems", "NumDice", baseItemType ) );
    if( numDices == 0 ) // Se supone que Esta funcion es usada solo para armas. Pero por las dudas se llame equivocadamente, dar un modificador muy alto.
        return 9999999.0;
    int dieToRoll = StringToInt( Get2DAStringAdapted( "baseItems", "DieToRoll", baseItemType ) );
    int critThread = StringToInt( Get2DAStringAdapted( "baseItems", "CritThreat", baseItemType ) );
    int critHitMult = StringToInt( Get2DAStringAdapted( "baseItems", "CritHitMult", baseItemType ) );
    int reqFeat0 = StringToInt( Get2DAStringAdapted( "baseItems", "ReqFeat0", baseItemType ) );
    int tenthLBS = StringToInt( Get2DAStringAdapted( "baseItems", "TenthLBS", baseItemType ) );
    string equipableSlots = Get2DAStringAdapted( "baseItems", "EquipableSlots", baseItemType );

    if( tenthLBS <=0 )
        tenthLBS = 1;
    // si es un arma lanzable, multiplicar el peso por trescientos.
    if( baseItemType == BASE_ITEM_THROWINGAXE || baseItemType == BASE_ITEM_DART )
        tenthLBS * 300;

    float modifier = 0.75; // factor calculado para que 'modifier' valga uno cuando baseItemType es un longsword.
    modifier /= numDices * (1+dieToRoll); // cuando mas daño normal hace el arma base, menos cuestan las propiedades que aumentan el daño (el costo es inversamente proporcional al daño base)
    modifier *= 10 + critThread*(critHitMult-1); // cuanto mayor es la componente de daño critico, mas cuestan las propiedades que aumentan el daño
    modifier /= pow(tenthLBS/40.0,0.1); // cuanto mas pesada el arma, menos cuestan las propiedades que aumentan el daño
    if( reqFeat0 == FEAT_WEAPON_PROFICIENCY_EXOTIC ) modifier *= 0.94; // si el arma es exotica, las propiedades que aumentan el daño cuestan un 6% menos
    if( equipableSlots == "0x1C010" ) modifier *= 0.83; // si el arma requiere uso de ambas manos, las propiedades que aumentan el daño cuestan un 17% menos
    if( baseItemType == BASE_ITEM_DOUBLEAXE || baseItemType == BASE_ITEM_DIREMACE || baseItemType == BASE_ITEM_TWOBLADEDSWORD ) modifier *= 0.75; // si el arma es doble, las propiedades que aumentan el daño cuestan un 25% menos

    return modifier;
}


////////////////////////////////////////////////////////////////////////////////
////////////////funciones determinadoras de costo///////////////////////////////
////////////////////////////////////////////////////////////////////////////////

struct IPS_FeatureCostParams {
    float factor;
    float exponent;
    int maxLevel;
};


struct IPS_FeatureCostParams IPS_Feature_AbilityBonus_getCostParams( int baseItemType );
struct IPS_FeatureCostParams IPS_Feature_AbilityBonus_getCostParams( int baseItemType ) {
    struct IPS_FeatureCostParams fcp;
    fcp.factor = 1.0;
    fcp.exponent = 2.0; // 1.5
    fcp.maxLevel = 5;
    return fcp;
}

struct IPS_FeatureCostParams IPS_Feature_BonusSavingThrow_getCostParams( int baseItemType, int saveBaseType );
struct IPS_FeatureCostParams IPS_Feature_BonusSavingThrow_getCostParams( int baseItemType, int saveBaseType ) {
    struct IPS_FeatureCostParams fcp;
    fcp.exponent = 2.0; // 1.5
    fcp.maxLevel = 5;
    if( saveBaseType == IP_CONST_SAVEVS_UNIVERSAL ) {
        fcp.factor = 1.2;
    } else {
        fcp.factor = 0.5;
    }
    return fcp;
}


struct IPS_FeatureCostParams IPS_Feature_DamageImmunityFisical_getCostParams( int baseItemType, int armor2daIndex );
struct IPS_FeatureCostParams IPS_Feature_DamageImmunityFisical_getCostParams( int baseItemType, int armor2daIndex ) {
    struct IPS_FeatureCostParams fcp;
    fcp.exponent = 2.2; // 1.66
    if( baseItemType == BASE_ITEM_ARMOR ) {
        switch( armor2daIndex ) { // factor = 2.25 /( 1.0 + armor2daIndex );
            case -1: fcp.maxLevel = 0;  break;
            case 0: fcp.factor = 2.25;      fcp.maxLevel = 3;   break;
            case 1: fcp.factor = 1.125;     fcp.maxLevel = 5;   break;
            case 2: fcp.factor = 0.75;      fcp.maxLevel = 6;   break;
            case 3: fcp.factor = 0.5625;    fcp.maxLevel = 7;   break;
            case 4:
            case 5: fcp.factor = 0.4;       fcp.maxLevel = 8;   break;
            default:fcp.factor = 0.27;      fcp.maxLevel = 9;   break;
        }
    } else switch( baseItemType ) {
        case BASE_ITEM_SMALLSHIELD: fcp.factor = 1.0;   fcp.maxLevel = 4;   break;
        case BASE_ITEM_LARGESHIELD: fcp.factor = 0.4;   fcp.maxLevel = 7;   break;
        case BASE_ITEM_TOWERSHIELD: fcp.factor = 0.27;  fcp.maxLevel = 9;   break;
    }
    return fcp;
}

struct IPS_FeatureCostParams IPS_Feature_DamageImmunityElemental_getCostParams( int baseItemType, int armor2daIndex );
struct IPS_FeatureCostParams IPS_Feature_DamageImmunityElemental_getCostParams( int baseItemType, int armor2daIndex ) {
    struct IPS_FeatureCostParams fcp;
    fcp.exponent = 2.33; // 1.75
    if( baseItemType == BASE_ITEM_ARMOR ) {
        fcp.factor = 0.75 * ( 2 + armor2daIndex /3 );
        fcp.maxLevel = 9;
    } else switch( baseItemType ) {
        case BASE_ITEM_SMALLSHIELD: fcp.factor = 2.0;   fcp.maxLevel = 3;   break;
        case BASE_ITEM_LARGESHIELD: fcp.factor = 2.5;   fcp.maxLevel = 4;   break;
        case BASE_ITEM_TOWERSHIELD: fcp.factor = 3.0;   fcp.maxLevel = 5;   break;
    }
    return fcp;
}

struct IPS_FeatureCostParams IPS_Feature_SkillBonus_getCostParams( int baseItemType );
struct IPS_FeatureCostParams IPS_Feature_SkillBonus_getCostParams( int baseItemType ) {
    struct IPS_FeatureCostParams fcp;
    fcp.factor = 0.25; // 0.25 = (1/2)^2  cosa que +2 en un skill cueste un feature point // 0.3535 = (1/2)^1.5
    fcp.exponent = 2.0; // 1.5
    fcp.maxLevel = 10;
    return fcp;
}

struct IPS_FeatureCostParams IPS_Feature_ACBonus_getCostParams( int baseItemType, int armor2daIndex );
struct IPS_FeatureCostParams IPS_Feature_ACBonus_getCostParams( int baseItemType, int armor2daIndex ) {
    struct IPS_FeatureCostParams fcp;
    fcp.exponent = 2.0; // 1.5
    fcp.maxLevel = 5;
    switch( baseItemType ) {
        case BASE_ITEM_ARMOR:
            if( armor2daIndex < 0 )
                fcp.maxLevel = 0;
            else
                fcp.factor = 8.0/( 4 + armor2daIndex );
            break;

        case BASE_ITEM_SMALLSHIELD: fcp.factor = 1.4;  break;
        case BASE_ITEM_LARGESHIELD: fcp.factor = 1.0; break;
        case BASE_ITEM_TOWERSHIELD: fcp.factor = 0.8;  break;

        case BASE_ITEM_RING:        fcp.factor = 1.7;  break;
        case BASE_ITEM_AMULET:      fcp.factor = 1.7;  break;
        case BASE_ITEM_CLOAK:       fcp.factor = 1.6;  break;
        case BASE_ITEM_BOOTS:       fcp.factor = 1.3;  break;
        case BASE_ITEM_BRACER:      fcp.factor = 1.5;  break;
        case BASE_ITEM_HELMET:      fcp.factor = 1.2;  break;
        case BASE_ITEM_BELT:        fcp.factor = 1.5;  break;

        case BASE_ITEM_TWOBLADEDSWORD:
        case BASE_ITEM_DIREMACE:
        case BASE_ITEM_DOUBLEAXE:   fcp.factor = 1.0;  break;

        default:                    fcp.maxLevel = 0;  break;
    }
    return fcp;
}

struct IPS_FeatureCostParams IPS_Feature_Fortification_getCostParams( int baseItemType, int armor2daIndex );
struct IPS_FeatureCostParams IPS_Feature_Fortification_getCostParams( int baseItemType, int armor2daIndex ) {
    struct IPS_FeatureCostParams fcp;
    // Por limitacion de la propiedad, hay que asegurar que un PJ no tenga mas de un item con fortification equipado. Para ello se eligió que solo las armaduras puedan tenerlo.
    if( baseItemType == BASE_ITEM_ARMOR && armor2daIndex >= 0 ) {
        fcp.exponent = 2.0; // 1.5
        fcp.maxLevel = 9; //1->10%, 2->20%, ..., 9->90%
        fcp.factor = 6.0/( 4.0 + armor2daIndex ); // cosa que una fortificacion de 10% cueste 0.75 feature points en una armadura con 4 de AC, y 0.5 feature points en una armadura completa.
    }
    return fcp;
}

struct IPS_FeatureCostParams IPS_Feature_WeightReduction_getCostParams( int baseItemType, int armor2daIndex );
struct IPS_FeatureCostParams IPS_Feature_WeightReduction_getCostParams( int baseItemType, int armor2daIndex ) {
    struct IPS_FeatureCostParams fcp;
    fcp.exponent = 2.0; // 1.5
    fcp.maxLevel = 5;
    int weight;

    if( baseItemType == BASE_ITEM_ARMOR ) {
        if( armor2daIndex < 0 )
            fcp.maxLevel = 0;
        else
            weight = StringToInt( Get2DAStringAdapted( "armor", "WEIGTH", armor2daIndex ) );
    } else
        weight = StringToInt( Get2DAStringAdapted( "baseItems", "TenthLBS", baseItemType ) );

    fcp.factor = weight/1000.0; // Calculada para que una reduccion del 20% a una armadura completa cueste medio feature point
    if( fcp.factor == 0.0 )
        fcp.maxLevel = 0;

    return fcp;
}

struct IPS_FeatureCostParams IPS_Feature_AttackBonus_getCostParams( int baseItemType );
struct IPS_FeatureCostParams IPS_Feature_AttackBonus_getCostParams( int baseItemType ) {
    struct IPS_FeatureCostParams fcp;
    fcp.exponent = 2.0; // 1.5
    if( baseItemType == BASE_ITEM_DOUBLEAXE || baseItemType == BASE_ITEM_DIREMACE || baseItemType == BASE_ITEM_TWOBLADEDSWORD ) {
        fcp.maxLevel = 7;
        fcp.factor = 1.0; // estas armas son tan chotas que hay que favorecerlas
    } else if( baseItemType == BASE_ITEM_GLOVES ) {
        fcp.maxLevel = 5;
        fcp.factor = 0.6;
    } else {
        int weaponSize = StringToInt( Get2DAStringAdapted( "baseItems", "WeaponSize", baseItemType ) );
        switch( weaponSize ) {
            case 0:  fcp.maxLevel = 0; break;
            case 1:  fcp.maxLevel = 7; fcp.factor = 0.6; break;
            case 2:  fcp.maxLevel = 6; fcp.factor = 0.9; break;
            case 3:  fcp.maxLevel = 5; fcp.factor = 1.2; break;
            case 4:  fcp.maxLevel = 4; fcp.factor = 1.5; break;
            default: fcp.maxLevel = 8 - weaponSize; fcp.factor = 0.3 + 0.3*weaponSize; break;
        }
    }
    return fcp;
}

struct IPS_FeatureCostParams IPS_Feature_FisicalDamageBonus_getCostParams( int baseItemType );
struct IPS_FeatureCostParams IPS_Feature_FisicalDamageBonus_getCostParams( int baseItemType ) {
    struct IPS_FeatureCostParams fcp;
    switch( baseItemType ) {
        case BASE_ITEM_BOLT:    baseItemType = BASE_ITEM_LIGHTCROSSBOW; break;
        case BASE_ITEM_ARROW:   baseItemType = BASE_ITEM_SHORTBOW;      break;
        case BASE_ITEM_BULLET:  baseItemType = BASE_ITEM_SLING;         break;
    }
    int weaponType = StringToInt( Get2DAStringAdapted( "baseItems", "WeaponType", baseItemType ) );
    if( weaponType > 0 ) {
        fcp.factor   = IPS_Feature_getDamageModifier( baseItemType );
        fcp.exponent = 2.0; // 1.5
        fcp.maxLevel = 5;
    }
    return fcp;
}

struct IPS_FeatureCostParams IPS_Feature_ElementalDamageBonus_getCostParams( int baseItemType );
struct IPS_FeatureCostParams IPS_Feature_ElementalDamageBonus_getCostParams( int baseItemType ) {
    struct IPS_FeatureCostParams fcp;
    switch( baseItemType ) {
        case BASE_ITEM_BOLT:    baseItemType = BASE_ITEM_LIGHTCROSSBOW; break;
        case BASE_ITEM_ARROW:   baseItemType = BASE_ITEM_SHORTBOW;      break;
        case BASE_ITEM_BULLET:  baseItemType = BASE_ITEM_SLING;         break;
    }
    int weaponType = StringToInt( Get2DAStringAdapted( "baseItems", "WeaponType", baseItemType ) );
    if( weaponType > 0 ) {
        fcp.factor   = 1.2*IPS_Feature_getDamageModifier( baseItemType );
        fcp.exponent = 2.0; // 1.5
        fcp.maxLevel = 5;
    }
    return fcp;
}

struct IPS_FeatureCostParams IPS_Feature_EnhancementBonus_getCostParams( int baseItemType );
struct IPS_FeatureCostParams IPS_Feature_EnhancementBonus_getCostParams( int baseItemType ) {
    struct IPS_FeatureCostParams fcp;
    int weaponType = StringToInt( Get2DAStringAdapted( "baseItems", "WeaponType", baseItemType ) );
    if( weaponType > 0 ) {
        fcp.factor   = IPS_Feature_AttackBonus_getCostParams(baseItemType).factor + IPS_Feature_getDamageModifier(baseItemType);
        fcp.exponent = 2.0; // 1.5
        fcp.maxLevel = 5;
    }
    return fcp;
}

struct IPS_FeatureCostParams IPS_Feature_MaxRangeStrengthMod_getCostParams( int baseItemType );
struct IPS_FeatureCostParams IPS_Feature_MaxRangeStrengthMod_getCostParams( int baseItemType ) {
    struct IPS_FeatureCostParams fcp;
    fcp.exponent = 2.0; // 1.5
    fcp.factor = 0.8*IPS_Feature_getDamageModifier( baseItemType );
    switch( baseItemType ) {
        case BASE_ITEM_SLING:       fcp.maxLevel = 3;  break;
        case BASE_ITEM_SHORTBOW:    fcp.maxLevel = 4;  break;
        case BASE_ITEM_LONGBOW:     fcp.maxLevel = 5;  break;
        case BASE_ITEM_THROWINGAXE: fcp.maxLevel = 8;  break;
        default:                    fcp.maxLevel = 0;  break;
    }
    return fcp;
}

struct IPS_FeatureCostParams IPS_Feature_SpellSequencer_getCostParams( int baseItemType, int armor2daIndex );
struct IPS_FeatureCostParams IPS_Feature_SpellSequencer_getCostParams( int baseItemType, int armor2daIndex ) {
    struct IPS_FeatureCostParams fcp;
    fcp.exponent = 2.0; // 1.5
    fcp.maxLevel = 3;
    switch( baseItemType ) {
        case BASE_ITEM_ARMOR:
            if( armor2daIndex >= 0 )
                fcp.factor = 0.36 * ( 2 + armor2daIndex/2 );
            else
                fcp.maxLevel = 0;
            break;
        case BASE_ITEM_SMALLSHIELD: fcp.factor = 0.9; break;
        case BASE_ITEM_LARGESHIELD: fcp.factor = 1.08; break;
        case BASE_ITEM_TOWERSHIELD: fcp.factor = 1.44; break; // asumiendo que el tower shield tiene +4 (en lugar del +3) de base AC.
        default: {
            int weaponSize = StringToInt( Get2DAStringAdapted( "baseItems", "WeaponSize", baseItemType ) );
            if( weaponSize > 0 ) {
                fcp.factor   = 0.36 * ( 2 + weaponSize );
            } else {
                fcp.maxLevel = 0;
            }
        } break;
    }
    return fcp;
}

struct IPS_FeatureCostParams IPS_Feature_VampiricRegeneration_getCostParams( int baseItemType );
struct IPS_FeatureCostParams IPS_Feature_VampiricRegeneration_getCostParams( int baseItemType ) {
    struct IPS_FeatureCostParams fcp;
    int weaponType = StringToInt( Get2DAStringAdapted( "baseItems", "WeaponType", baseItemType ) );
    if( weaponType > 0 ) {
        fcp.factor   = 1.0; // cosa que uno de regenaracion vampirica cueste lo mismo que uno de daño // 0.3535
        fcp.exponent = 2.0; // 1.5
        fcp.maxLevel = 20;
    }
    return fcp;
}

struct IPS_FeatureCostParams IPS_Feature_UnlimitedAmmo_getCostParams( int baseItemType );
struct IPS_FeatureCostParams IPS_Feature_UnlimitedAmmo_getCostParams( int baseItemType ) {
    struct IPS_FeatureCostParams fcp;
    fcp.factor   = 4.0; // cosa que con sin daño extra valga lo mismo que +2 de attack bonus // 3.0
    fcp.exponent = 2.0; // 1.5
    fcp.maxLevel = 5;
    return fcp;
}

struct IPS_SpecialPropertyParamsAndCost { // recordar que por limitaciones de los 'IPS_ItemProperty_*_buildDescriptor()' con tres parametros, el rango de valores posible para los tres campos de esta estructura es de 0 a 61
    int subtype;
    int intensity;
    int specialParam;
    float cost;
};

struct IPS_SpecialPropertyParamsAndCost IPS_Feature_OnHitArmorCastSpell_getCostParams( int baseItemType, float remainingFeaturePoints );
struct IPS_SpecialPropertyParamsAndCost IPS_Feature_OnHitArmorCastSpell_getCostParams( int baseItemType, float remainingFeaturePoints ) {
    struct IPS_SpecialPropertyParamsAndCost sppac;
                                                             //
    struct WeightedSelector propertyDie = WeightedDie_create( "|003,050|004,250" );
    struct IPS_FeatureCostParams fcp;
    do {
        struct IPS_FeatureCostParams fcp;
        int face = WeightedDie_throw( propertyDie );
        switch( face ) {
/*            case 1:
                sppac.subtype = IP_CONST_ONHIT_CASTSPELL_CREEPING_DOOM;
                fcp.factor   = 1.0;
                fcp.exponent = 1.33; // 1.0
                fcp.maxLevel = 20;
                break;
            case 2:
                sppac.subtype = IP_CONST_ONHIT_CASTSPELL_ICE_STORM;
                fcp.factor   = 5.0;
                fcp.exponent = 1.0;
                fcp.maxLevel = 1;
                break;
*/
            case 3:
                sppac.subtype = IP_CONST_ONHIT_CASTSPELL_INFESTATION_OF_MAGGOTS;
                fcp.factor   = 6.0;
                fcp.exponent = 1.0; // 0.8
                fcp.maxLevel = 20;
                break;
            case 4:
                sppac.subtype = IP_CONST_ONHIT_CASTSPELL_ONHIT_CHAOSSHIELD;
                fcp.factor   = 0.14;
                fcp.exponent = 2.0; // 1.5
                fcp.maxLevel = 40;
                break;
            default: WriteTimestampedLogEntry( "IPS_Feature_OnHitArmorCastSpell_getCostParams: error, unreachable 1" ); break;
        }
        struct IPS_FeatureIntensityAndCost fiac = IPS_generateRandomIntensity( remainingFeaturePoints, fcp );
        if( fiac.intensity > 0 ) {
            sppac.cost = fiac.cost;
            sppac.intensity = fiac.intensity;
//            SendMessageToPC( GetFirstPC(), "IPS_Feature_OnHitArmorCastSpell_getCostParams: spellId="+IntToString(sppac.subtype)+", level="+IntToString(sppac.intensity)+", cost="+FloatToString(sppac.cost) );
            return sppac;
        }
        propertyDie = WeightedDie_removeFace( propertyDie, face );
    } while( propertyDie.totalWeight > 0 );
    return sppac;
}


struct IPS_SpecialPropertyParamsAndCost IPS_Feature_OnHitWeaponProps_generateRandom( int baseItemType, float remainingFeaturePoints );
struct IPS_SpecialPropertyParamsAndCost IPS_Feature_OnHitWeaponProps_generateRandom( int baseItemType, float remainingFeaturePoints ) {
    struct IPS_SpecialPropertyParamsAndCost sppac;
                                                            //  doom    slow    deafnes blindne wounding
    struct WeightedSelector propertyDie = WeightedDie_create( "|006,150|009,100|015,200|016,080|025,200" );
    do {
        sppac.subtype = WeightedDie_throw( propertyDie );
        struct IPS_FeatureCostParams fcp;
        fcp.exponent = 1.0; //0.8
        fcp.maxLevel = 7;
        switch( sppac.subtype ) {
            case IP_CONST_ONHIT_DOOM: //Fills a single subject with a feeling of horrible dread and causes her to weaken and lose confidence. The subject is shaken, suffering a -2 morale penalty to attack rolls, checks, and saving throws.
                fcp.factor = 4.0;
                sppac.specialParam = Random(IP_CONST_ONHIT_DURATION_75_PERCENT_1_ROUND + 1);
                break;
            case IP_CONST_ONHIT_SLOW:
                fcp.factor = 6.0;
                sppac.specialParam = Random(IP_CONST_ONHIT_DURATION_75_PERCENT_1_ROUND + 1);
                break;
            case IP_CONST_ONHIT_DEAFNESS:  // Deafness causes a 20% spell failure chance for spells with Speaking components (V), and (although NwN doesn't do this) stop them from hearing what is said around them.
                fcp.factor = 2.0;
                sppac.specialParam = Random(IP_CONST_ONHIT_DURATION_75_PERCENT_1_ROUND + 1);
                break;
            case IP_CONST_ONHIT_BLINDNESS:  // Blindness makes it so you can't see anything - 50% miss chance for all attacks, and it doesn't allow spells to be targeted directly at creatures (although area-of-effect spells, like Fireball, still can be).
                fcp.factor = 12.0;
                sppac.specialParam = Random(IP_CONST_ONHIT_DURATION_75_PERCENT_1_ROUND + 1);
                break;
            case IP_CONST_ONHIT_WOUNDING:
                fcp.factor = 3.0*IPS_Feature_getDamageModifier( baseItemType );
                break;
            default: WriteTimestampedLogEntry( "IPS_Feature_OnHitWeaponProps_generateRandom: error, unreachable 1" ); break;
        }
        struct IPS_FeatureIntensityAndCost fiac = IPS_generateRandomIntensity( remainingFeaturePoints, fcp );
        if( fiac.intensity > 0 ) {
            sppac.cost = fiac.cost;
            sppac.intensity = fiac.intensity;
//            SendMessageToPC( GetFirstPC(), "IPS_Feature_OnHitWeaponProps_generateRandom: propertyId="+IntToString(sppac.subtype)+", saveDC="+IntToString(sppac.intensity)+", special="+IntToString(sppac.specialParam)+", cost="+FloatToString(sppac.cost) );
            return sppac;
        }
        propertyDie = WeightedDie_removeFace( propertyDie, sppac.subtype );
    } while( propertyDie.totalWeight > 0 );

    return sppac;
}


float IPS_Feature_Keen_getCost( int baseItemType );
float IPS_Feature_Keen_getCost( int baseItemType ) {
    int weapontType = StringToInt( Get2DAStringAdapted( "baseItems", "WeaponType", baseItemType ) );
    if( weapontType == 3 ) {
        int critThread = StringToInt( Get2DAStringAdapted( "baseItems", "CritThreat", baseItemType ) );
        int critHitMult = StringToInt( Get2DAStringAdapted( "baseItems", "CritHitMult", baseItemType ) );
        return 0.75 * critThread * (critHitMult-1); // cuesta 0.75 cuando el rango critico es uno, 1.5 cuando es dos, y 2.25 cuando es tres.
    } else {
        return 9999999.0;
    }
}

float IPS_Feature_Feat_getCost( int baseItemType, int featId );
float IPS_Feature_Feat_getCost( int baseItemType, int featId ) {
    switch(featId) {
        case 260 /*IP_CONST_FEAT_GREATER_CLEAVE*/: {
            int weapontType = StringToInt( Get2DAStringAdapted( "baseItems", "WeaponType", baseItemType ) );
            return weapontType > 0 ? 1.0 : 9999999.0;
        }
    }
    return 9999999.0;
}

const float IPS_Feature_ConfusionCurse_QUALITY_BONUS = 5.0;
const float IPS_Feature_HostilityCurse_QUALITY_BONUS = 7.0;




