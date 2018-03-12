/************* Script Generador de Encuentros - Grupal combinado ***************
template author: Inquisidor
script name: sgeOzgo1
script author: Inquisidor
names of the areas this script is asociated with: caberna al norte de la ciudad de benzor
********************************************************************************/
#include "RS_sgeTools"
#include "RS_ADE"


void main()  {

    struct RS_DatosSGE datosSGE = RS_getDatosSGE();

    float faeCasters = RS_generarGrupo( datosSGE, ADE_Humanoid_Trasgo_getCaster(), 0.25, 0.10, 0, 0.3 );   // de 15% a 35% del poder del encuentro estaria comprendido por casters. No poner casters cuya FAE sea superior al 30%. Ignorar el filtro de FAE minima para el último DMD.

    RS_generarGrupo( datosSGE, ADE_Humanoid_Trasgo_getMelee(), 1.0 - faeCasters, 0.1, 2, 0.40 ); // el resto del poder del encuentro estara comprendido por luchadores. No poner luchadores cuya FAE sea superior al 40% del encuentro excepto para los primeros dos DMD. Ignorar el filtro de FAE minima para el ultimo DMD.

}
