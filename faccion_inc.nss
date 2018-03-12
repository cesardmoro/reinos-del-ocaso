/************************ Faccion Include *************************************/

const string TAG_WP_AREA_FACCION = "Merc4";

// Cambia la faccion de la criatura
void CambiarFaccion( object oCriatura, int nFaccionBusq );
void CambiarFaccion( object oCriatura, int nFaccionBusq )
{
    SetLocalInt(oCriatura, "FaccionBuscada", nFaccionBusq);
    SetLocalLocation(oCriatura, "DeDondeVino", GetLocation(oCriatura));
    AssignCommand(oCriatura, ClearAllActions());
    AssignCommand(oCriatura, ActionJumpToLocation(GetLocation(GetWaypointByTag(TAG_WP_AREA_FACCION))));
}

// Cambia la faccion de la criatura y la envia al punto indicado
void CambiarFaccionConDestino( object oCriatura, int nFaccionBusq, location lDestino );
void CambiarFaccionConDestino( object oCriatura, int nFaccionBusq, location lDestino )
{
    SetLocalInt(oCriatura, "FaccionBuscada", nFaccionBusq);
    SetLocalLocation(oCriatura, "DeDondeVino", lDestino);
    AssignCommand(oCriatura, ClearAllActions());
    AssignCommand(oCriatura, ActionJumpToLocation(GetLocation(GetWaypointByTag(TAG_WP_AREA_FACCION))));
}
