/**********************************************************
Sistema de Carpas - Rearmado 18/11/2007 by dragoncin


**********************************************************/

/**********************************************************
 Constantes
**********************************************************/

const int Carpas_MAXIMO_CARPAS = 9;

const string Carpas_placeableCarpaResRef_RN         = "carpa_blueprnt";
const string Carpas_waypointExteriorResRef_RN       = "out_wpoint0";

const string Carpas_areaTag_Prefix_RN               = "AreaCarpa";
const string Carpas_waypointInteriorTag_Prefix_RN   = "CARPA_WPOINT0";
const string Carpas_waypointExteriorTag_Prefix_RN   = "OUT_WPOINT";
const string Carpas_placeableTag_Prefix_RN          = "CARPAPLC_";

const string Carpas_carpaOwnerId_LN                 = "wpOwner";
const string Carpas_targetAreaId_LN                 = "targetAreaId";
const string Carpas_globalIdControl_LN              = "carpasGlobalId";

const string Carpas_carpaItemResRef_RN              = "tienda";

/**********************************************************
 Funciones
**********************************************************/

// Devuelve una nueva Id unica para una carpa
int Carpas_GetNewId();
int Carpas_GetNewId()
{
    object module = GetModule();
    int id = GetLocalInt( module, Carpas_globalIdControl_LN );
    id++;
    SetLocalInt( module, Carpas_globalIdControl_LN, id );
    return id;
}

// Devuelve la id unica que identifica al placeable/waypoint duenio de la carpa
int Carpas_GetOwnerIdFromWaypoint( object waypointCarpa );
int Carpas_GetOwnerIdFromWaypoint( object waypointCarpa )
{
    return GetLocalInt( waypointCarpa, Carpas_carpaOwnerId_LN );
}

// Setea la id unica que identifica al placeable/waypoint duenio de la carpa
void Carpas_SetOwnerIdIntoWaypoint( object waypointCarpa, int ownerId );
void Carpas_SetOwnerIdIntoWaypoint( object waypointCarpa, int ownerId )
{
    SetLocalInt( waypointCarpa, Carpas_carpaOwnerId_LN, ownerId );
}


// Devuelve el waypoint exterior (salida) de la carpa cuyo id es ownerId
object Carpas_GetExteriorWaypointFromId( int ownerId );
object Carpas_GetExteriorWaypointFromId( int ownerId )
{
    return GetWaypointByTag( Carpas_waypointExteriorTag_Prefix_RN + IntToString(ownerId) );
}

// Devuelve el waypoint interno del area de id areaId
object Carpas_GetInteriorWaypointFromAreaId( int areaId );
object Carpas_GetInteriorWaypointFromAreaId( int areaId )
{
    return GetWaypointByTag( Carpas_waypointInteriorTag_Prefix_RN + IntToString(areaId) );
}

object Carpas_GetTentAreaFromAreaId( int areaId );
object Carpas_GetTentAreaFromAreaId( int areaId )
{
    object innerWaypoint = Carpas_GetInteriorWaypointFromAreaId( areaId );
    return GetArea( innerWaypoint );
}

// Devuelve el waypoint interno del area
object Carpas_GetInteriorWaypointFromArea( object area );
object Carpas_GetInteriorWaypointFromArea( object area )
{
    string areaTag = GetTag( area );
    string idArea = GetStringRight( areaTag, GetStringLength(areaTag)-GetStringLength(Carpas_areaTag_Prefix_RN) );

    return GetWaypointByTag( Carpas_waypointInteriorTag_Prefix_RN + idArea );
}


// Devuelve el identificador de la carpa a partir del placeable
int Carpas_GetOwnerIdFromPlaceable( object placeableCarpa );
int Carpas_GetOwnerIdFromPlaceable( object placeableCarpa )
{
    string placeableTag = GetTag( placeableCarpa );
    string sId = GetStringRight( placeableTag, GetStringLength(placeableTag)-GetStringLength(Carpas_placeableTag_Prefix_RN) );

    return StringToInt( sId );
}

// Devuelve el id del area cuyo duenio es el placeable
int Carpas_GetAreaIdFromPlaceable( object placeableCarpa );
int Carpas_GetAreaIdFromPlaceable( object placeableCarpa )
{
    return GetLocalInt( placeableCarpa, Carpas_targetAreaId_LN );
}

object Carpas_GetInteriorWaypointFromPlaceable( object placeableCarpa );
object Carpas_GetInteriorWaypointFromPlaceable( object placeableCarpa )
{
    int waypointId = Carpas_GetAreaIdFromPlaceable( placeableCarpa );
    return GetWaypointByTag( Carpas_waypointInteriorTag_Prefix_RN + IntToString(waypointId) );
}
