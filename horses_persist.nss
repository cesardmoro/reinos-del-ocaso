///////////////////////////
// Sistema de Caballos - Persistencias
//
/* Notas importantes:

    Mirando un poco van a notar que en la base de datos se guardan 2 cosas unicamente:
    el numero identificador del resRef del caballo (que coincide con el numero de cola
    que lo representa) y el nombre del mismo (nombre que el jugador le asigna).

    Por esta razon, la unicidad del caballo esta determinada por el pj y un numerito
    que determina el orden de la base de datos (prefijo+numeroIdentificador).

    Lo unico que puede hacer desaparecer un caballo es su muerte.
*/

#include "horses_props_inc"
#include "location_tools"

////////////////////// CONSTANTES /////////////////////////////////////

const int Horses_MAX_HORSES_PER_PLAYER = 5;

const string Horses_DATABASE                = "horses";
const string Horses_DB_MAX_HORSE_INDEX      = "Horses_MAX_HORSE_INDEX";
const string Horses_DB_HORSE_RESREF_PREFIX  = "Horses_HORSE_RESREF_";
const string Horses_DB_HORSE_NAME_PREFIX    = "Horses_HORSE_NAME_";
const string Horses_DB_HORSE_APP_PREFIX     = "Horses_HORSE_APP_";
const string Horses_DB_HORSE_STABLE_PREFIX  = "Horses_HORSE_STABLE_";

const string Horses_isPersistantHorse_LN    = "isPersistantHorse";

///////////////////// FUNCIONES ////////////////////////////////////////

// Devuelve si un caballo es creado por el sistema de caballos persistentes
int GetIsPersistantHorse( object oHorse );
int GetIsPersistantHorse( object oHorse )
{
    return GetLocalInt( oHorse, Horses_isPersistantHorse_LN );
}

// Guarda el tag del area establo donde esta guardado oHorse
void Horses_SetHorseStableTag( int horseId, object horseOwner, string stableTag );
void Horses_SetHorseStableTag( int horseId, object horseOwner, string stableTag )
{
    SetCampaignString(Horses_DATABASE, Horses_DB_HORSE_STABLE_PREFIX+IntToString(horseId), stableTag, horseOwner);
}

// Devuelve el tag del area establo donde esta guardado oHorse
string Horses_GetHorseStableTag( int horseId, object horseOwner );
string Horses_GetHorseStableTag( int horseId, object horseOwner )
{
    return GetCampaignString(Horses_DATABASE, Horses_DB_HORSE_STABLE_PREFIX+IntToString(horseId), horseOwner);
}

// Devuelve el numero de caballos que oOwner tiene guardados
int Horses_GetDBMaxHorseIndex( object oOwner = OBJECT_SELF );
int Horses_GetDBMaxHorseIndex( object oOwner = OBJECT_SELF )
{
    return GetCampaignInt(Horses_DATABASE, Horses_DB_MAX_HORSE_INDEX, oOwner);
}

// Devuelve el ResRef del caballo numero nIndex de oOwner
string Horses_GetPersistantHorseResRef( int nIndex, object oOwner = OBJECT_SELF );
string Horses_GetPersistantHorseResRef( int nIndex, object oOwner = OBJECT_SELF )
{
    int horseIdentifier = GetCampaignInt(Horses_DATABASE, Horses_DB_HORSE_RESREF_PREFIX+IntToString(nIndex), oOwner);

    return Horses_RESREF_PREFIX+IntToString(horseIdentifier);
}

// Devuelve el nombre del caballo sacado de la base de datos
string Horses_GetPersistantHorseName( int nIndex, object oOwner );
string Horses_GetPersistantHorseName( int nIndex, object oOwner )
{
    return GetCampaignString(Horses_DATABASE, Horses_DB_HORSE_NAME_PREFIX+IntToString(nIndex), oOwner);
}

// Devuelve la apariencia del caballo nIndex de oOwner
int Horses_GetPersistantHorseAppearance( int nIndex, object oOwner );
int Horses_GetPersistantHorseAppearance( int nIndex, object oOwner )
{
    return GetCampaignInt(Horses_DATABASE, Horses_DB_HORSE_APP_PREFIX+IntToString(nIndex), oOwner);
}

// Guarda la apariencia del caballo nIndex de oOwner
void Horses_SetPersistantHorseAppearance( int nAppearance, int nIndex, object oOwner );
void Horses_SetPersistantHorseAppearance( int nAppearance, int nIndex, object oOwner )
{
    SetCampaignInt(Horses_DATABASE, Horses_DB_HORSE_APP_PREFIX+IntToString(nIndex), nAppearance, oOwner);
}

// Le asigna un nombre al caballo oHorse y lo guarda en la base de datos
void Horses_SetPersistantHorseName( string horseName, object oHorse, object oOwner );
void Horses_SetPersistantHorseName( string horseName, object oHorse, object oOwner )
{
    if (horseName!="") {
        SetName(oHorse, horseName);
        int nIndex = Horses_GetHorseId(oHorse);
        SetCampaignString(Horses_DATABASE, Horses_DB_HORSE_NAME_PREFIX+IntToString(nIndex), horseName, oOwner);
    }
}

// Guarda en la base de datos el ResRef, la apariencia y el nombre del caballo oHorse de oOwner
void Horses_SavePersistantHorse( object oHorse, int nIndex, object oOwner = OBJECT_SELF );
void Horses_SavePersistantHorse( object oHorse, int nIndex, object oOwner = OBJECT_SELF )
{
    int maxHorseIndex = Horses_GetDBMaxHorseIndex( oOwner );
    if (nIndex > maxHorseIndex) {
        maxHorseIndex = nIndex;
        SetCampaignInt(Horses_DATABASE, Horses_DB_MAX_HORSE_INDEX, nIndex, oOwner);
    }

    string horseResRef = GetResRef(oHorse);
    //SendMessageToPC(oOwner, "savedHorseResRef: "+horseResRef);
    horseResRef = GetStringRight(horseResRef, GetStringLength(horseResRef)-GetStringLength(Horses_RESREF_PREFIX));
    //SendMessageToPC(oOwner, "savedHorseId: "+horseResRef);
    int mountType = StringToInt(horseResRef);

    SetCampaignInt(Horses_DATABASE, Horses_DB_HORSE_RESREF_PREFIX+IntToString(nIndex), mountType, oOwner);
    SetCampaignInt(Horses_DATABASE, Horses_DB_HORSE_APP_PREFIX+IntToString(nIndex), GetAppearanceType(oHorse), oOwner);
    SetCampaignString(Horses_DATABASE, Horses_DB_HORSE_NAME_PREFIX+IntToString(nIndex), GetName(oHorse), oOwner);

    SetLocalObject(oHorse, Horses_OWNER, oOwner);
    SetLocalObject(oOwner, Horses_TAG_PREFIX+IntToString(nIndex), oHorse);
    SetLocalInt( oHorse, Horses_isPersistantHorse_LN, TRUE );
}


// Esta funcion revisa el modulo en busca del caballo.
// Si lo encuentra, devuelve ese caballo y lo lleva a esa locacion.
// Si no lo encuentra, lo crea en la locacion.
object Horses_RetrievePersistantHorse( int nIndex, object oOwner, location whereToCreate );
object Horses_RetrievePersistantHorse( int nIndex, object oOwner, location whereToCreate )
{
    object oHorse = Horses_GetHorseByIdAndOwner(nIndex, oOwner);

    if (!GetIsObjectValid(oHorse)) {

        string horseResRef = Horses_GetPersistantHorseResRef(nIndex, oOwner);
        //SendMessageToPC(oOwner, "HorseResRef: "+horseResRef);
        string horseTag = Horses_GetHorseTag(nIndex, oOwner);
        //SendMessageToPC(oOwner, "HorseTag: "+horseTag);
        oHorse = CreateObject(OBJECT_TYPE_CREATURE, horseResRef, GetLocation(GetWaypointByTag(Horses_DAYCARE_WP)), FALSE, horseTag);

        string horseName = Horses_GetPersistantHorseName(nIndex, oOwner);
        SetName(oHorse, horseName);

        // ---> Arreglo al moco en las apariencia de Zero
        int appearance = Horses_GetPersistantHorseAppearance(nIndex, oOwner);
        if (appearance < 3000) {
            appearance += 2712; // diferencia entre los antiguos valores y los actuales
            Horses_SetPersistantHorseAppearance( appearance, nIndex, oOwner );
        }
        // <---
        SetCreatureAppearanceType(oHorse, appearance);

        SetLocalObject(oOwner, Horses_TAG_PREFIX+IntToString(nIndex), oHorse);
        SetLocalObject(oHorse, Horses_OWNER, oOwner);
        SetLocalInt( oHorse, Horses_isPersistantHorse_LN, TRUE );

        AssignCommand(oHorse, Location_forcedJump(whereToCreate));

    } else if (GetArea(oHorse)!=GetArea(oOwner))
        AssignCommand(oHorse, Location_forcedJump(whereToCreate));
    else
        AssignCommand(oHorse, JumpToLocation(whereToCreate));

    //if (!GetIsObjectValid(oHorse)) SendMessageToPC(oOwner, "No se pudo crear el caballo");
    return oHorse;
}

// Borra el caballo
// Esto debe llamarse desde el evento OnDeath del caballo
void Horses_DeletePersistantHorse( int nIndex, object oOwner, float fDelay = 0.0f );
void Horses_DeletePersistantHorse( int nIndex, object oOwner, float fDelay = 0.0f )
{
    object oHorse = Horses_GetHorseByIdAndOwner(nIndex, oOwner);
    DestroyObject(oHorse, fDelay);
    SetCampaignInt(Horses_DATABASE, Horses_DB_HORSE_RESREF_PREFIX+IntToString(nIndex), 0, oOwner);
    SetCampaignInt(Horses_DATABASE, Horses_DB_HORSE_APP_PREFIX+IntToString(nIndex), 0, oOwner);
    SetCampaignString(Horses_DATABASE, Horses_DB_HORSE_NAME_PREFIX+IntToString(nIndex), "", oOwner);
}

// Crea un nuevo caballo persistente
object Horses_CreateNewPersistantHorse( int nMountType, location whereToCreate, object oOwner, int bUseAppearAnimation = FALSE );
object Horses_CreateNewPersistantHorse( int nMountType, location whereToCreate, object oOwner, int bUseAppearAnimation = FALSE )
{
    // Estoy iterando sobre la base de datos... esto no se debe hacer ¬¬U (al menos no estoy escribiendo, solo leyendo)
    int nIndex = 1;
    int maxHorseIndex = Horses_GetDBMaxHorseIndex( oOwner );
    while (GetCampaignInt(Horses_DATABASE, Horses_DB_HORSE_RESREF_PREFIX+IntToString(nIndex), oOwner) > 0 && nIndex <= maxHorseIndex) {
        nIndex++;
    }

    string horseResRef = Horses_RESREF_PREFIX + IntToString(nMountType);
    //SendMessageToPC(oOwner, "createdHorseResRef: "+horseResRef);
    string horseTag = Horses_GetHorseTag(nIndex, oOwner);
    //SendMessageToPC(oOwner, "createdHorseTag: "+horseTag);

    object oHorse = CreateObject(OBJECT_TYPE_CREATURE, horseResRef, whereToCreate, bUseAppearAnimation, horseTag);
    Horses_SavePersistantHorse(oHorse, nIndex, oOwner);
    //Esto asume que todos los caballos se crean en un establo
    SetCampaignString(Horses_DATABASE, Horses_DB_HORSE_STABLE_PREFIX+IntToString(nIndex), GetTag(GetArea(oHorse)), oOwner);

    SetLocalObject(oHorse, Horses_OWNER, oOwner);

    return oHorse;
}

