/******************************************************************************
Package: RandomSpawn - Area_onExit handler
Author: Inquisidor
Version: 0.1
Descripcon: Aqui esta el handler que debe ser llamado desde el onExit handler de
todas las areas (al menos todas las que generan RandoSpawn y las aledanias).
*******************************************************************************/
#include "RS_inc"
#include "Location_tools"

// Debe ser llamada desde el handler del evento 'onAreaExit' para que el RandomSpawn funcione bien.
void RS_onExit( object exitingObject );
void RS_onExit( object exitingObject ) {
    if( GetIsPC( exitingObject ) ) {
        SetLocalObject( exitingObject, RS_areaAnterior_VN, OBJECT_SELF );

        // clears the encounters forced location just in case the subsystem which set it didn't.
        DeleteLocalObject( exitingObject, Location_PJ_punteroUbicacionForzada_VN );
    }
}
