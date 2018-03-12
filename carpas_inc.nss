#include "location_tools"
#include "carpas_itf"

void CrearPlaceable( int targetAreaId, location targetLocation, object oPC, object itemCarpa );
void CrearPlaceable( int targetAreaId, location targetLocation, object oPC, object itemCarpa )
{
    object interiorWaypoint = Carpas_GetInteriorWaypointFromAreaId( targetAreaId );
    // obtenemos una nueva id unica para la carpa
    int carpaId = Carpas_GetNewId();

    // marcamos la carpa objetivo con nuestra nueva id
    Carpas_SetOwnerIdIntoWaypoint( interiorWaypoint, carpaId );

    // creamos el placeable de la carpa
    string placeableTag = Carpas_placeableTag_Prefix_RN + IntToString( carpaId );
    object placeableCarpa = CreateObject( OBJECT_TYPE_PLACEABLE, Carpas_placeableCarpaResRef_RN, targetLocation, FALSE, placeableTag );
    SendMessageToPC( oPC, "Terminas de armar la tienda" );

    // marcamos el placeable con el id del area de la carpa
    SetLocalInt( placeableCarpa, Carpas_targetAreaId_LN, targetAreaId );

    // destruimos el item
    if (GetIsObjectValid( placeableCarpa ))
        DestroyObject( itemCarpa, 0.1 );

    // creamos un waypoint de salida
    float targetFacing = GetFacingFromLocation( targetLocation );
    location posicionWaypointSalida = Location_createRelative( targetLocation, -5.0, 0.0, -targetFacing );
    CreateObject( OBJECT_TYPE_WAYPOINT, Carpas_waypointExteriorResRef_RN, posicionWaypointSalida, FALSE, Carpas_waypointExteriorTag_Prefix_RN+IntToString( carpaId ) );

}

void AccionArmarCarpa(int targetAreaId, location targetLocation, object oPC, object itemCarpa );
void AccionArmarCarpa(int targetAreaId, location targetLocation, object oPC, object itemCarpa )
{
    SendMessageToPC(oPC, "Te dispones a armar la tienda...");
//    SendMessageToPC( oPC, "targetAreaId: "+IntToString(targetAreaId) );
    AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0, 2.0));
    AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0, 5.0));
    AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0, 5.0));
    AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0, 5.0));
    AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0, 5.0));
    AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0, 5.0));
    AssignCommand(oPC, ActionDoCommand(CrearPlaceable(targetAreaId, targetLocation, oPC, itemCarpa)));
}

void Carpas_onActivate( object oPC, location targetLocation, object itemCarpa, object targetObject );
void Carpas_onActivate( object oPC, location targetLocation, object itemCarpa, object targetObject )
{
    object oAreaPC = GetArea(oPC);

    if ( GetDistanceBetweenLocations(GetLocation(oPC), targetLocation) > 5.0 )
    {
        SendMessageToPC(oPC, "Estas muy lejos de ese lugar");
    }
    else if ( !( (GetIsAreaInterior(oAreaPC) == FALSE) && (GetIsAreaAboveGround(oAreaPC)) && (GetIsAreaNatural(oAreaPC)) ) )
    {
        SendMessageToPC(oPC, "Solo puedes armar una tienda en areas exteriores sobre la tierra y no artificiales");
    }
    else if ( GetIsObjectValid( targetObject ) ) {
        SendMessageToPC(oPC, "Este objeto debe ser usado sobre el piso");
    }
    else if ( oAreaPC == GetArea(GetWaypointByTag("FugueMarker")) ) {
        SendMessageToPC(oPC, "No puedes armar una carpa en este lugar.");
    }
    else
    {
        int i;
        int areaDisponible;
        for (i=1; i<=Carpas_MAXIMO_CARPAS; i++)
        {
            if (Carpas_GetOwnerIdFromWaypoint( Carpas_GetInteriorWaypointFromAreaId(i) ) == FALSE) {
                areaDisponible = i;
                break;
            }
        }
        if ( areaDisponible > 0 ) {
            AccionArmarCarpa( areaDisponible, targetLocation, oPC, itemCarpa );
        } else {
            object objetoIterado;
            int nroPCs;
            int areasLlenas = 0;
            object areaCarpa;
            for (i=1; i<=Carpas_MAXIMO_CARPAS; i++) {
                areaCarpa = GetArea( Carpas_GetInteriorWaypointFromAreaId(i) );
                nroPCs = 0;
                objetoIterado = GetFirstObjectInArea( areaCarpa );
                while (GetIsObjectValid( objetoIterado )) {
                    if (GetIsPC(objetoIterado))
                        nroPCs++;
                    objetoIterado = GetNextObjectInArea( areaCarpa );
                }
                if (nroPCs == 0) {
                    AccionArmarCarpa( i, targetLocation, oPC, itemCarpa );
                    break;
                } else {
                    areasLlenas++;
                }
            }
            if (areasLlenas >= Carpas_MAXIMO_CARPAS)
                SendMessageToPC( oPC, "Todas las areas estan ocupadas. Por favor, espera a que se desocupe alguna para armar tu carpa" );
        }
    }
}
