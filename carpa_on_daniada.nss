#include "carpas_itf"

void destruirCarpa( object tentArea, object interiorWaypoint )
{
    int ownerId = Carpas_GetOwnerIdFromWaypoint( interiorWaypoint );
    object exteriorWaypoint = Carpas_GetExteriorWaypointFromId( ownerId );

    object objetoIterado = GetFirstObjectInArea( tentArea );
    while (GetIsObjectValid( objetoIterado )) {
       if (GetIsPC( objetoIterado )) {
           AssignCommand( objetoIterado, JumpToObject(exteriorWaypoint) ); }
       else if (GetObjectType(objetoIterado) == OBJECT_TYPE_ITEM) {
           DestroyObject( objetoIterado, 0.1 );
       }
       objetoIterado = GetNextObjectInArea( tentArea );
    }
    Carpas_SetOwnerIdIntoWaypoint( interiorWaypoint, FALSE );
    DestroyObject( exteriorWaypoint, 10.0 );
    //craft_drop_placeable();
    DestroyObject(OBJECT_SELF, 1.0);
}

void main()
{
    object interiorWaypoint = Carpas_GetInteriorWaypointFromPlaceable( OBJECT_SELF );
    object tentArea = GetArea( interiorWaypoint );

    effect eParalyze = EffectVisualEffect(VFX_FNF_SCREEN_BUMP);

    object objetoIterado = GetFirstObjectInArea( tentArea );
    while (GetIsObjectValid( objetoIterado )) {
        if (GetIsPC( objetoIterado )) {
            SendMessageToPC( objetoIterado, "La carpa esta bajo ataque!" );
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eParalyze, objetoIterado, 1.0);
        }
        objetoIterado = GetNextObjectInArea( tentArea );
    }

    if(GetCurrentHitPoints(OBJECT_SELF) < 9950)
    {
        destruirCarpa( tentArea, interiorWaypoint );
    }





}
