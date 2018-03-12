const string CityDoors_OPEN_DOOR_MESSAGE        = "ABRAN LA PUERTA";
const string CityDoors_isNearDoor_VN            = "isnearcitydoor";
const string CityDoors_CITY_DOOR_RESREF_PREFIX  = "puertaciudad_";

int CityDoors_getIsNearDoor( object oPC );
int CityDoors_getIsNearDoor( object oPC )
{
    return GetLocalInt( oPC, CityDoors_isNearDoor_VN );
}

object CityDoors_getNearestDoor( object oPC );
object CityDoors_getNearestDoor( object oPC )
{
    object objetoIterado = GetFirstObjectInShape( SHAPE_CUBE, 40.0, GetLocation(oPC), FALSE, OBJECT_TYPE_DOOR );
    while ( GetIsObjectValid(objetoIterado) )
    {
        if ( GetStringLeft(GetResRef(objetoIterado), GetStringLength(CityDoors_CITY_DOOR_RESREF_PREFIX)) == CityDoors_CITY_DOOR_RESREF_PREFIX )
        {
            return objetoIterado;
        }
        objetoIterado = GetNextObjectInShape( SHAPE_CUBE, 40.0, GetLocation(oPC), FALSE, OBJECT_TYPE_DOOR );
    }
    return OBJECT_INVALID;
}

void CityDoors_open( object oDoor );
void CityDoors_open( object oDoor )
{
    SetLocked(oDoor, FALSE);
    AssignCommand(oDoor, ActionOpenDoor(oDoor));
}

void CityDoors_onPlayerChat( string message, object oPC );
void CityDoors_onPlayerChat( string message, object oPC )
{
    if ( CityDoors_getIsNearDoor(oPC) &&
        GetStringUpperCase(GetStringLeft(message, GetStringLength(CityDoors_OPEN_DOOR_MESSAGE))) == CityDoors_OPEN_DOOR_MESSAGE )
    {
        CityDoors_open( CityDoors_getNearestDoor(oPC) );
    }
}

void CityDoors_onPlayerEnterTrigger( object oPC );
void CityDoors_onPlayerEnterTrigger( object oPC )
{
    SetLocalInt( oPC, CityDoors_isNearDoor_VN, TRUE );
}

void CityDoors_onPlayerExitTrigger( object oPC );
void CityDoors_onPlayerExitTrigger( object oPC )
{
    SetLocalInt( oPC, CityDoors_isNearDoor_VN, FALSE );
}
