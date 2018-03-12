/************* Script Generador de Encuentros - Grupal combinado ***************
template author: Inquisidor
script name: granjaspawn
script author: Inquisidor
names of the areas this script is asociated with: camino del sur de benzor
********************************************************************************/
#include "RS_sgeTools"
#include "RS_ADE"

void main() {
    struct RS_DatosSGE datosSGE = RS_getDatosSGE();

    // si el encuentro esta en la mitad oriental salen trasgos, si esta en la mitad occidental salen kobolds
    float frontera = IntToFloat( 5 * GetAreaSize( AREA_WIDTH, OBJECT_SELF ) );
    if( GetPositionFromLocation( datosSGE.ubicacionEncuentro ).x > frontera ) {

        float faeCasters = RS_generarGrupo( datosSGE, ADE_Humanoid_Trasgo_getCaster(), 0.25, 0.15, 0, 0.30, 2, 0.10 );   // de 10% a 40% del poder del encuentro estaria comprendido por casters. No poner ningun casters cuya FAE supere al 30%. No poner casters cuya FAE sea menor a 10% excepto si para los ultimos 3 DMDs.

        float faeFighters = RS_generarGrupo( datosSGE, ADE_Humanoid_Trasgo_getMelee(), 1.0 - faeCasters, 0.1, 2, 0.45, 2, 0.25 );  // el resto del poder del encuentro estaria comprendido por fighters. No poner fighters cuya FAE supere al 45% excepto si es alguno de los 2 primeros DMDs. No poner fighter cuya FAE este por debajo del 25% excepto para los ultimos dos DMDs.

    } else {

        float faeCasters = RS_generarGrupo( datosSGE, ADE_Humanoid_Kobold_getCaster(), 0.25, 0.15, 0, 0.30, 2, 0.10 );   // de 10% a 40% del poder del encuentro estaria comprendido por casters. No poner ningun casters cuya FAE supere al 30%. No poner casters cuya FAE sea menor a 10% excepto si para los ultimos 2 DMDs.

        float faeFighters = RS_generarGrupo( datosSGE, ADE_Humanoid_Kobold_getMelee(), 1.0 - faeCasters, 0.1, 2, 0.45, 2, 0.25 );  // el resto del poder del encuentro estaria comprendido por fighters. No poner fighters cuya FAE supere al 45% excepto si es alguno de los 2 primeros DMDs. No poner fighter cuya FAE este por debajo del 25% excepto para los ultimos dos DMDs.

    }
}


