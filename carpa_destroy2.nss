#include "carpas_itf"

void main()
{
    CreateItemOnObject(Carpas_carpaItemResRef_RN, GetPCSpeaker());

    object exteriorWaypoint = Carpas_GetExteriorWaypointFromId( Carpas_GetOwnerIdFromPlaceable(OBJECT_SELF) );
    DestroyObject(exteriorWaypoint, 0.1);

    int areaId = Carpas_GetAreaIdFromPlaceable( OBJECT_SELF );
    object tentArea = Carpas_GetTentAreaFromAreaId( areaId );
    object objetoIterado = GetFirstObjectInArea( tentArea );
    while (GetIsObjectValid( objetoIterado )) {
        if (GetObjectType(objetoIterado) == OBJECT_TYPE_ITEM)
             DestroyObject(objetoIterado);
        objetoIterado = GetNextObjectInArea(tentArea);
    }
    DestroyObject(OBJECT_SELF, 0.1);
}
