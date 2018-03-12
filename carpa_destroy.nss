#include "carpas_itf"

void main()
{
    object targetWaypoint = Carpas_GetInteriorWaypointFromPlaceable( OBJECT_SELF );
    DeleteLocalInt( targetWaypoint, Carpas_carpaOwnerId_LN );

    CreateItemOnObject(Carpas_carpaItemResRef_RN, GetPCSpeaker());

    object targetArea = GetArea( targetWaypoint );
    object objetoIterado = GetFirstObjectInArea( targetArea );
    while (GetIsObjectValid( objetoIterado )) {
        if (GetObjectType(objetoIterado) == OBJECT_TYPE_ITEM)
             DestroyObject( objetoIterado );
        objetoIterado = GetNextObjectInArea( targetArea );
    }

    int ownerId = Carpas_GetOwnerIdFromPlaceable( OBJECT_SELF );
    DestroyObject( Carpas_GetExteriorWaypointFromId(ownerId), 0.1 );
    DestroyObject( OBJECT_SELF, 0.1 );
}
