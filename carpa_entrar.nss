#include "carpas_itf"

void main()
{
    int tentAreaId = Carpas_GetAreaIdFromPlaceable( OBJECT_SELF );
    object targetWaypoint = Carpas_GetInteriorWaypointFromAreaId( tentAreaId );
    AssignCommand(GetPCSpeaker(), JumpToObject( targetWaypoint ));
}
