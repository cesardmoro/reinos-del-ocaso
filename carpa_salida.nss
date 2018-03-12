#include "Carpas_itf"

void main()
{
  object oClicker = GetClickingObject();

  object interiorWaypoint = Carpas_GetInteriorWaypointFromArea( GetArea(oClicker) );
  object exteriorWaypoint = Carpas_GetExteriorWaypointFromId( Carpas_GetOwnerIdFromWaypoint(interiorWaypoint) );
  AssignCommand( oClicker, JumpToObject(exteriorWaypoint) );
}
