/************* Script Generador de Encuentros - Grupal combinado ***************
template author: Inquisidor
script name: sgeTrasgoCaberna
script author: Inquisidor
names of the areas this script is asociated with: cabernas en bosque sombrio
********************************************************************************/
#include "RS_FGE_inc"


void main()  {

    struct RS_DatosSGE datosSGE = RS_getDatosSGE();
    FGE_Humanoid_Trasgo( datosSGE );
//    FGE_Humanoid_TrasgoCaverna( datosSGE ); - modificado temporalmente para probar el arreglo completo de trasgos.
}
