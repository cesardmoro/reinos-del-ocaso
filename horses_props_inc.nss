/////////////////////////////////////
// Sistema de Caballos - Propiedades y Estados
//
/* Notas importantes:

    Se define el ResRef de un caballo como: Horses_RESREF_PREFIX + Horses_MOUNT_TYPE

    Se define el Tag de un caballo como:    Horses_TAG_PREFIX + numeroCaballo + Horses_TAG_IDVSNAME_SEPARATOR + colaAsociada + "_" + primeros##caracteresNombreDueño

*//////////////////////////////////

#include "horses_const"

/////////////////////////// CONSTANTES ////////////////////////////////////

// Prefijo del ResRef de los caballos
const string Horses_RESREF_PREFIX               = "rdohorse_";
const string Horses_PALMOUNT_RESREF_PREFIX      = "palam";

// Prefijo de los tags de los caballos
const string Horses_TAG_PREFIX                  = "Horse_";
const string Horses_TAG_IDVSNAME_SEPARATOR      = "__";

const string Horses_IDENTIFIER                  = "Horses_IDENTIFIER";
const string Horses_OWNER                       = "Horses_OWNER";

// Misc
const string Horses_MOUNT_TYPE                  = "Horses_MOUNT_TYPE";
const string Horses_ATTACK_DEC_EFFECT_CREATOR   = "Horses_ATTACK_DEC_EFFECT_CREATOR";
const string Horses_MOUNTED_HORSE_CREATURE      = "Horses_MOUNTED_HORSE_CREATURE";

const string Horses_isFollowing_LN              = "horses_follow";


/////////////////////////// FUNCIONES //////////////////////////////////

// Devuelve el caballo que oPC esta montando (y que esta en la guarderia)
object Horses_GetMountedHorse( object oPC );
object Horses_GetMountedHorse( object oPC )
{
    return GetLocalObject(oPC, Horses_MOUNTED_HORSE_CREATURE);
}

// Definicion del tag de un caballo (util para no equivocarse copipasteando)
// No devuelve el tag de un caballo sino que crea uno a partir de su definicion
string Horses_GetHorseTag( int nHorseNumber, object oPC );
string Horses_GetHorseTag( int nHorseNumber, object oPC )
{
    return Horses_TAG_PREFIX+IntToString(nHorseNumber)+Horses_TAG_IDVSNAME_SEPARATOR+GetStringLeft(GetName(oPC), 20);
}

// Devuelve el Id de un caballo
// El Id esta guardado en el Tag
// Devuelve -1 en caso de error (no ser un caballo por ej)
int Horses_GetHorseId( object oHorse );
int Horses_GetHorseId( object oHorse )
{
    string horseTag = GetTag(oHorse);
    //SendMessageToPC(GetFirstPC(), "Horse Tag: "+horseTag);
    int tagPrefixPosition = FindSubString(horseTag, Horses_TAG_PREFIX);
    //SendMessageToPC(GetFirstPC(), "Horse TagPrefixPosition: "+IntToString(tagPrefixPosition));

    if (GetIsObjectValid(oHorse) && !GetIsPC(oHorse) && tagPrefixPosition > -1) {

        int barPosition = FindSubString(horseTag, Horses_TAG_IDVSNAME_SEPARATOR);
        if (barPosition > -1)
            horseTag = GetStringLeft(horseTag, barPosition);
        //SendMessageToPC(GetFirstPC(), "Horse Tag: "+horseTag);
        horseTag = GetStringRight(horseTag, GetStringLength(horseTag)-GetStringLength(Horses_TAG_PREFIX));
        //SendMessageToPC(GetFirstPC(), "Horse Tag: "+horseTag);

        return StringToInt(horseTag);

    } else
        return -1;
}

// Devuelve el dueño del caballo en cuestion
object Horses_GetHorseOwner( object oHorse );
object Horses_GetHorseOwner( object oHorse )
{
    return GetLocalObject(oHorse, Horses_OWNER);
}

// Devuelve el tipo de montura que monta el personaje
// Los tipos de montura estan definidos en "Horses_const.nss".
// Devuelve MOUNT_TYPE_NONE en caso de no estar montado
int Horses_GetMountType( object oPC );
int Horses_GetMountType( object oPC )
{
    return GetLocalInt(oPC, Horses_MOUNT_TYPE);
}

// Devuelve el tipo de montura que representa la criatura
int Horses_GetCreatureMountType( object oCreature );
int Horses_GetCreatureMountType( object oCreature )
{
    string horseResRef = GetResRef(oCreature);
    //SendMessageToPC(GetFirstPC(), "horseResRef: "+horseResRef);
    if (FindSubString(horseResRef, Horses_RESREF_PREFIX) < 0)
        return MOUNT_TYPE_NONE;

    horseResRef = GetStringRight(horseResRef, GetStringLength(horseResRef)-FindSubString(horseResRef, "_")-1);
    //SendMessageToPC(GetFirstPC(), "horseResRef: "+horseResRef);
    return StringToInt(horseResRef);
}

// Devuelve si la criatura es un caballo montable
int GetIsRidableHorse( object oCreature );
int GetIsRidableHorse( object oCreature )
{
    return (FindSubString(GetResRef(oCreature), Horses_RESREF_PREFIX) > -1 ||
            FindSubString(GetResRef(oCreature), Horses_PALMOUNT_RESREF_PREFIX) > -1 );
}

// Devuelve TRUE si la montura que monta oPC es una montura de guerra
int Horses_GetHasWarMount( object oPC );
int Horses_GetHasWarMount( object oPC )
{
   int mountType = Horses_GetMountType(oPC);

   return ( mountType==MOUNT_TYPE_WARHORSE_LIGHT ||
            mountType==MOUNT_TYPE_WARHORSE_HEAVY
           );
}

// Devuelve la velocidad de la montura de oPC, en pies por ronda
// Si oPC no esta montado, devuelve 30.0 (por las dudas).
float Horses_GetMountSpeed( object oPC );
float Horses_GetMountSpeed( object oPC )
{
    float mountedSpeed = 30.0;
    switch (Horses_GetMountType(oPC)) {
        case MOUNT_TYPE_HORSE_CARGO:        mountedSpeed = 40.0; break;
        case MOUNT_TYPE_HORSE_LIGHT:        mountedSpeed = 60.0; break;
        case MOUNT_TYPE_HORSE_HEAVY:        mountedSpeed = 50.0; break;
        case MOUNT_TYPE_WARHORSE_LIGHT:     mountedSpeed = 60.0; break;
        case MOUNT_TYPE_WARHORSE_HEAVY:     mountedSpeed = 50.0; break;
    }
    return mountedSpeed;
}

// Devuelve TRUE si el PJ esta montado en un caballo
int GetIsMounted( object oPC = OBJECT_SELF );
int GetIsMounted( object oPC = OBJECT_SELF )
{
    return (Horses_GetMountType(oPC) > 0);
}

// Devuelve el caballo nIdentifier de oPC
// Primero lo busca por una variable local en oPC
// Si no lo encuentra, lo busca por el tag usando GetObjectByTag() por lo que
// no se debe abusar de esta funcion.
object Horses_GetHorseByIdAndOwner( int nIdentifier, object oPC );
object Horses_GetHorseByIdAndOwner( int nIdentifier, object oPC )
{
    object oHorse = GetLocalObject(oPC, Horses_TAG_PREFIX+IntToString(nIdentifier));
    string horseTag;

    if (!GetIsObjectValid(oHorse)) {
        horseTag = Horses_GetHorseTag(nIdentifier, oPC);
        oHorse = GetObjectByTag(horseTag);
        SetLocalObject(oPC, Horses_TAG_PREFIX+IntToString(nIdentifier), oHorse);
    }
    //if (!GetIsObjectValid(oHorse)) SendMessageToPC(oPC, "Horses_GetHorseByIdAndOwner: Caballo "+GetName(oHorse)+" ("+horseTag+") del PJ "+GetName(oPC)+" no encontrado!");

    return oHorse;
}

///////////////////////////// APARIENCIA /////////////////////////////////

// Devuelve TRUE si el modelo nModel le corresponde al tipo de montura
int Horses_GetModelBelongsToMountType( int nModel, int nMountType );
int Horses_GetModelBelongsToMountType( int nModel, int nMountType )
{
    /* Nota por dragoncin:
        Esta funcion es absolutamente arbitraria, por ende debe ser modificada teniendo eso en cuenta
        y por esa razon esta escrita asi de larga y fea.
        Las constantes estan en "horses_const".*/
    int nResult = FALSE;
    switch (nMountType) {
        case MOUNT_TYPE_HORSE_CARGO:        nResult = ( nModel == Horses_APP_CARGO_1 ||
                                                        nModel == Horses_APP_CARGO_2 ||
                                                        nModel == Horses_APP_CARGO_3 ||
                                                        nModel == Horses_APP_CARGO_4
                                                       ); break;
        case MOUNT_TYPE_HORSE_HEAVY:        nResult = ( nModel == Horses_APP_HEAVY_1 ||
                                                        nModel == Horses_APP_HEAVY_2 ||
                                                        nModel == Horses_APP_HEAVY_3 ||
                                                        nModel == Horses_APP_HEAVY_4 ||
                                                        nModel == Horses_APP_HEAVY_5 ||
                                                        nModel == Horses_APP_HEAVY_6 ||
                                                        nModel == Horses_APP_HEAVY_7 ||
                                                        nModel == Horses_APP_HEAVY_8
                                                       ); break;
        case MOUNT_TYPE_HORSE_LIGHT:        nResult = ( nModel == Horses_APP_LIGHT_1 ||
                                                        nModel == Horses_APP_LIGHT_2 ||
                                                        nModel == Horses_APP_LIGHT_3 ||
                                                        nModel == Horses_APP_LIGHT_4 ||
                                                        nModel == Horses_APP_LIGHT_5 ||
                                                        nModel == Horses_APP_LIGHT_6 ||
                                                        nModel == Horses_APP_LIGHT_7 ||
                                                        nModel == Horses_APP_LIGHT_8
                                                       ); break;
        case MOUNT_TYPE_WARHORSE_HEAVY:     nResult = ( nModel == Horses_APP_WAR_HEAVY_1 ||
                                                        nModel == Horses_APP_WAR_HEAVY_2 ||
                                                        nModel == Horses_APP_WAR_HEAVY_3 ||
                                                        nModel == Horses_APP_WAR_HEAVY_4 ||
                                                        nModel == Horses_APP_WAR_HEAVY_5 ||
                                                        nModel == Horses_APP_WAR_HEAVY_6 ||
                                                        nModel == Horses_APP_WAR_HEAVY_7 ||
                                                        nModel == Horses_APP_WAR_HEAVY_8 ||
                                                        nModel == Horses_APP_WAR_HEAVY_9 ||
                                                        nModel == Horses_APP_WAR_HEAVY_10 ||
                                                        nModel == Horses_APP_WAR_HEAVY_11 ||
                                                        nModel == Horses_APP_WAR_HEAVY_12 ||
                                                        nModel == Horses_APP_WAR_HEAVY_13 ||
                                                        nModel == Horses_APP_WAR_HEAVY_14 ||
                                                        nModel == Horses_APP_WAR_HEAVY_15 ||
                                                        nModel == Horses_APP_WAR_HEAVY_16 ||
                                                        nModel == Horses_APP_WAR_HEAVY_17 ||
                                                        nModel == Horses_APP_WAR_HEAVY_18 ||
                                                        nModel == Horses_APP_WAR_HEAVY_19 ||
                                                        nModel == Horses_APP_WAR_HEAVY_20 ||
                                                        nModel == Horses_APP_WAR_HEAVY_21 ||
                                                        nModel == Horses_APP_WAR_HEAVY_22 ||
                                                        nModel == Horses_APP_WAR_HEAVY_23 ||
                                                        nModel == Horses_APP_WAR_HEAVY_24
                                                       ); break;
        case MOUNT_TYPE_WARHORSE_LIGHT:     nResult = ( nModel == Horses_APP_WAR_LIGHT_1 ||
                                                        nModel == Horses_APP_WAR_LIGHT_2 ||
                                                        nModel == Horses_APP_WAR_LIGHT_3 ||
                                                        nModel == Horses_APP_WAR_LIGHT_4 ||
                                                        nModel == Horses_APP_WAR_LIGHT_5 ||
                                                        nModel == Horses_APP_WAR_LIGHT_6 ||
                                                        nModel == Horses_APP_WAR_LIGHT_7 ||
                                                        nModel == Horses_APP_WAR_LIGHT_8 ||
                                                        nModel == Horses_APP_WAR_LIGHT_9 ||
                                                        nModel == Horses_APP_WAR_LIGHT_10
                                                       ); break;
    }
    return nResult;
}

const int Horses_DIFF_BETWEEN_APP_AND_TAIL = 3195;

// Devuelve el numero de cola que representa el caballo oHorse
int Horses_GetAssignedTailModelFromCreatureHorse( object oHorse );
int Horses_GetAssignedTailModelFromCreatureHorse( object oHorse )
{
    int horseAppearance = GetAppearanceType(oHorse);
    int tailModel = (horseAppearance == 3263) ? 67 : (horseAppearance - Horses_DIFF_BETWEEN_APP_AND_TAIL);
    return tailModel;
}


// Devuelve si el caballo esta siguiendo a su amo
// El resultado de esta funcion no significa que este verdaderamente siguiendo al amo (dominado)
// sino si esta marcado para que lo haga
int Horses_GetIsHorseFollowing( object oHorse );
int Horses_GetIsHorseFollowing( object oHorse )
{
    return GetLocalInt( oHorse, Horses_isFollowing_LN );
}

