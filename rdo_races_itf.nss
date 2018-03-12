/******************************************************************************
Sistema de Subrazas - Script By dragoncin

Para agregar una subraza hay que:
    . Agregar un ID a la lista de identificadores de la subraza
    . Aumentar en 1 la constante Races_NUMBER_OF_SUBRACES
    . Agregar una rama en el switch de la funcion RDO_getSubRaceInfo() con los datos de la subraza

La unica limitacion esta en el numero de feats raciales que no puede superar 5 sin cambiar más código
******************************************************************************/

#include "RDO_Const_Feat"
#include "RDO_Clases_Itf"

////////////////////////// CONSTANTES ////////////////////////////////

// Identificadores de subrazas
const int SUBRACE_ID_NONE                   = 0;
const int SUBRACE_ID_ELF_MOON               = 1;
const int SUBRACE_ID_ELF_SUN                = 2;
const int SUBRACE_ID_ELF_WILD               = 3;
const int SUBRACE_ID_ELF_WOOD               = 4;
const int SUBRACE_ID_DWARF_SHIELD           = 5;
const int SUBRACE_ID_DWARF_GOLD             = 6;
const int SUBRACE_ID_DWARF_ARTIC            = 7;
const int SUBRACE_ID_GNOME_ROCK             = 8;
const int SUBRACE_ID_HALFLING_LIGHTFOOT     = 9;
const int SUBRACE_ID_HALFLING_STRONGHEART   = 10;
const int SUBRACE_ID_HALFLING_GHOSTWISE     = 11;
const int SUBRACE_ID_GNOME_FOREST           = 12;

const int Races_NUMBER_OF_SUBRACES          = 12;

const string RDO_modificadorNivelSubraza_PN = "MNS"
    // modificador del nivel de un PJ debido a su subraza
;

//////////// BASE DE DATOS //////////////////
const string SubRaces_DATABASE = "races";
const string SubRaces_DB_SUBRACE_WAS_SET = "SubRaces_DB_SUBRACE_WAS_SET";

// juro que ya no sabia que mas ponerle. sorry ¬¬U (by drago)
const string STOP_ON_ENTER_STUFF = "STOP_ON_ENTER_STUFF";


struct RDO_SubraceInfo
{
    string Name;
    int Race;
    int Str, Dex, Con, Int, Wis, Cha;
    int FavouredClass;
    int LevelAdjustmentFixed; // este el el ajuste conocido de los libros de D&D
    int LevelAdjustmentProgressive; /* este es un ajuste inventado por Inquisidor para balancear
									   las subrazas que mejoran con el nivel (ejemplo: 
									   las que su SR aumenta con el nivel). 
									   Este parámetro debe valer la relación de poder entre PjE y PjN,
									   donde PjE y PjN son dos PJs iguales en todo excepto que:
									   (1) PjE tiene subraza especial y PjN es normal, y 
									   (2) el nivel(PjN) = nivel(PjE) + LevelAdjustmentFixed. */
    int Feat1, Feat2, Feat3, Feat4, Feat5; // Dotes ganadas por la subraza
    int remFeat1, remFeat2, remFeat3, remFeat4, remFeat5; // Dotes perdidas
};

////////////////////////// FUNCIONES ////////////////////////////////////////

struct RDO_SubraceInfo RDO_getSubRaceInfo( int subRaceId );
struct RDO_SubraceInfo RDO_getSubRaceInfo( int subRaceId )
{
    struct RDO_SubraceInfo sri;
    sri.FavouredClass = -1;
    sri.Feat1 = -1;
    sri.Feat2 = -1;
    sri.Feat3 = -1;
    sri.Feat4 = -1;
    sri.Feat5 = -1;
    sri.remFeat1 = -1;
    sri.remFeat2 = -1;
    sri.remFeat3 = -1;
    sri.remFeat4 = -1;
    sri.remFeat5 = -1;
    switch ( subRaceId ) {
        case SUBRACE_ID_ELF_MOON:       sri.Name = "Elfo Lunar";
                                        sri.Race = RACIAL_TYPE_ELF;
                                        break;
        case SUBRACE_ID_ELF_SUN:        sri.Name = "Elfo Solar";
                                        sri.Race = RACIAL_TYPE_ELF;
                                        sri.Dex = -2; sri.Int = 2;
                                        break;
        case SUBRACE_ID_ELF_WILD:       sri.Name = "Elfo Salvaje";
                                        sri.Race = RACIAL_TYPE_ELF;
                                        sri.Con = 2; sri.Int = -2;
                                        sri.FavouredClass = CLASS_TYPE_SORCERER;
                                        break;
        case SUBRACE_ID_ELF_WOOD:       sri.Name = "Elfo del Bosque";
                                        sri.Race = RACIAL_TYPE_ELF;
                                        sri.Str = 2;
                                        sri.Cha = -2;
                                        sri.FavouredClass = CLASS_TYPE_RANGER;
                                        break;
        case SUBRACE_ID_DWARF_SHIELD:   sri.Name = "Enano Escudo";
                                        sri.Race = RACIAL_TYPE_DWARF;
                                        break;
        case SUBRACE_ID_DWARF_GOLD:     sri.Name = "Enano Dorado";
                                        sri.Race = RACIAL_TYPE_DWARF;
                                        sri.Dex = -2; sri.Cha = 2;
                                        break;
        case SUBRACE_ID_DWARF_ARTIC:    sri.Name = "Enano Artico";
                                        sri.Race = RACIAL_TYPE_DWARF; sri.FavouredClass = CLASS_TYPE_RANGER;
                                        sri.Str = 4; sri.Dex = -2;
                                        sri.LevelAdjustmentFixed = 2;
                                        sri.Feat1 = 375; // Small stature
                                        sri.Feat2 = FEAT_IMMUNITY_COLD;
                                        break;
        case SUBRACE_ID_GNOME_ROCK:     sri.Name = "Gnomo de las Rocas";
                                        sri.Race = RACIAL_TYPE_GNOME;
                                        break;
        case SUBRACE_ID_GNOME_FOREST:   sri.Name = "Gnomo del Bosque";
                                        sri.Race = RACIAL_TYPE_GNOME;
                                        sri.LevelAdjustmentFixed = 1;
                                        sri.Feat1 = FEAT_FOREST_GNOME_HIDE;
                                        sri.Feat2 = FEAT_SPEAK_WITH_ANIMALS;
                                        break;
        case SUBRACE_ID_HALFLING_LIGHTFOOT:     sri.Name = "Mediano Piesligeros";
                                                sri.Race = RACIAL_TYPE_HALFLING;
                                                break;
        case SUBRACE_ID_HALFLING_STRONGHEART:   sri.Name = "Mediano Fortecor";
                                                sri.Race = RACIAL_TYPE_HALFLING;
                                                sri.remFeat1 = FEAT_LUCKY;
                                                break;
        case SUBRACE_ID_HALFLING_GHOSTWISE:     sri.Name = "Mediano Fantasagaz";
                                                sri.Race = RACIAL_TYPE_HALFLING;
                                                sri.FavouredClass = CLASS_TYPE_BARBARIAN;
                                                break;
    }
    return sri;
}

// Devuelve el Id de subraza de oPC en base a la subraza que tenga seteada en su Bic y a su raza
// Si alguno de los dos no coincide, devuelve SUBRACE_ID_NONE
int GetSubRaceId( object oPC );
int GetSubRaceId( object oPC )
{
    struct RDO_SubraceInfo sri;
    int subRaceIterator;
    int subRaceId = SUBRACE_ID_NONE;
    int racialType = GetRacialType(oPC);
    for (subRaceIterator=1; subRaceIterator<=Races_NUMBER_OF_SUBRACES; subRaceIterator++) {
        sri = RDO_getSubRaceInfo( subRaceIterator );
        if (GetStringUpperCase(GetSubRace(oPC))==GetStringUpperCase(sri.Name) && racialType==sri.Race)
            subRaceId = subRaceIterator;
    }
    if (subRaceId == SUBRACE_ID_NONE) {
        switch (racialType) {
            case RACIAL_TYPE_ELF:       subRaceId = SUBRACE_ID_ELF_MOON; break;
            case RACIAL_TYPE_DWARF:     subRaceId = SUBRACE_ID_DWARF_SHIELD; break;
            case RACIAL_TYPE_GNOME:     subRaceId = SUBRACE_ID_GNOME_ROCK; break;
            case RACIAL_TYPE_HALFLING:  subRaceId = SUBRACE_ID_HALFLING_LIGHTFOOT; break;
        }
    }
    return subRaceId;
}


// Devuelve la clase preferida de la raza (de bioware)
int Races_GetRaceFavouredClass( int racialType );
int Races_GetRaceFavouredClass( int racialType )
{
    switch (racialType) {
        case RACIAL_TYPE_ELF:       return CLASS_TYPE_WIZARD;
        case RACIAL_TYPE_DWARF:     return CLASS_TYPE_FIGHTER;
        case RACIAL_TYPE_HALFLING:  return CLASS_TYPE_ROGUE;
        case RACIAL_TYPE_GNOME:     return CLASS_TYPE_WIZARD;
        case RACIAL_TYPE_HALFORC:   return CLASS_TYPE_BARBARIAN;
    }
    return CLASS_TYPE_INVALID;
}


struct slot {
    int clase;
    int nivel;
};

// Por Inquisidor
float calcularPena( int claseFavorita, object pj=OBJECT_SELF ) {
    float pena = 0.0;
    struct slot slot1;
    struct slot slot2;
    struct slot slot3;
    slot1.clase = GetClassByPosition( 1, pj );
    slot1.nivel = GetLevelByPosition( 1, pj );
    slot2.clase = GetClassByPosition( 2, pj );
    slot2.nivel = GetLevelByPosition( 2, pj );
    slot3.clase = GetClassByPosition( 3, pj );
    slot3.nivel = GetLevelByPosition( 3, pj );

    // eliminacion de clase favorita
    if( slot1.clase == claseFavorita ) {
        slot1.nivel = 0;
    }
    if( slot2.clase == claseFavorita || !RDO_getIsBaseClass( slot2.clase ) ) {
        slot2.nivel = 0;
    }
    if( slot3.clase == claseFavorita || !RDO_getIsBaseClass( slot2.clase ) ) {
        slot3.nivel = 0;
    }

    // pone en slot1 la clase de mayor nivel
    if( slot2.nivel > slot1.nivel ) {
        struct slot temp = slot2;
        slot2 = slot1;
        slot1 = temp;
    }
    if( slot3.nivel > slot1.nivel ) {
        struct slot temp = slot3;
        slot3 = slot1;
        slot1 = temp;
    }

    // suma de penas
    if( slot2.nivel != 0 && abs( slot1.nivel - slot2.nivel ) > 1 )
        pena = 20.0;
    if( slot3.nivel != 0 && abs( slot1.nivel - slot3.nivel ) > 1 )
        pena += 20.0;

    return pena;
}

// Ajusta la experiencia en base a la clase preferida de oPC
// No soporta subrazas de la raza humano
// Asume que la subraza esta estandarizada
// Soporta valores negativos de 'xpAmount'
int Races_GetFavouredClassAdjustedXP( int xpAmount, object oPC );
int Races_GetFavouredClassAdjustedXP( int xpAmount, object oPC )
{
    int subRaceId = GetSubRaceId(oPC);
    if (subRaceId != SUBRACE_ID_NONE)
    {
        struct RDO_SubraceInfo sri = RDO_getSubRaceInfo( subRaceId );
        float porcentajeBioware  = 100.0 - calcularPena(Races_GetRaceFavouredClass(GetRacialType(oPC)), oPC);
        //SendMessageToPC(oPC, "porcentajeBioware: "+FloatToString(porcentajeBioware));
        float porcentajeSubRazas = 100.0 - calcularPena(sri.FavouredClass, oPC);
        //SendMessageToPC(oPC, "porcentajeSubRazas: "+FloatToString(porcentajeSubRazas));

        //SendMessageToPC(oPC, "variacion: "+FloatToString(porcentajeSubRazas / porcentajeBioware));
        float nuevaXp = IntToFloat(xpAmount) * ( porcentajeSubRazas / porcentajeBioware );

        return FloatToInt(nuevaXp);
    }
    else
        return xpAmount;
}


