#include "carpas_itf"

int StartingConditional()
{
    int targetAreaId = GetLocalInt( OBJECT_SELF, Carpas_targetAreaId_LN );
    object interiorWaypoint = Carpas_GetInteriorWaypointFromAreaId( targetAreaId );

    return ( Carpas_GetOwnerIdFromPlaceable(OBJECT_SELF) == Carpas_GetOwnerIdFromWaypoint(interiorWaypoint) );
}
