/************* Script Generador de Encuentros - Grupal combinado ***************
template author: Inquisidor
script name: sgebenshillsog
script author: Lobofiel
names of the areas this script is asociated with:
Benzor South Hills - Ogre Lair
********************************************************************************/
#include "RS_sgeTools"
#include "RS_ADE"


void main()  {
    struct RS_DatosSGE datosSGE = RS_getDatosSGE();
    float faeCasters = RS_generarGrupo( datosSGE, ADE_Giant_Ogro_getCaster(), 0.30, 0.10, 0, 0.35, 2 );   // de 20% a 40% del poder del encuentro estaria comprendido por casters. No poner casters cuya FAE sea superior al 40%. Ignorar el filtro de FAE minima para los dos últimos DMDs.
    RS_generarGrupo( datosSGE, ADE_Giant_Ogro_getMelee(), 1.0 - faeCasters, 0.1, 2, 0.5 ); // el resto del poder del encuentro estara comprendido por luchadores. No poner luchadores cuya FAE sea superior al 40% del encuentro excepto para los primeros dos DMD. Ignorar el filtro de FAE minima para el ultimo DMD.
}


