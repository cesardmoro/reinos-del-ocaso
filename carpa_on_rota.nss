#include "Carpas_itf"

void main()
{
     int areaId = Carpas_GetAreaIdFromPlaceable( OBJECT_SELF );
     object tentArea = Carpas_GetTentAreaFromAreaId( areaId );
     object interiorWaypoint = Carpas_GetInteriorWaypointFromAreaId( areaId );
     object exteriorWaypoint = Carpas_GetExteriorWaypointFromId( Carpas_GetOwnerIdFromWaypoint(interiorWaypoint) );

     object objetoIterado = GetFirstObjectInArea( tentArea );
     while (GetIsObjectValid( objetoIterado )) {
        if (GetIsPC(objetoIterado)) {
            AssignCommand( objetoIterado, JumpToObject(exteriorWaypoint) ); }
        else if (GetObjectType(objetoIterado) == OBJECT_TYPE_ITEM) {
            DestroyObject(objetoIterado);
        }
        objetoIterado = GetNextObjectInArea( tentArea );
     }
     Carpas_SetOwnerIdIntoWaypoint( interiorWaypoint, FALSE );
     DestroyObject( exteriorWaypoint, 10.0 );
}
