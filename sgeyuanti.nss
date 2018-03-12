#include "RS_FGE_inc"
void main() {
//    SendMessageToPC( GetFirstPC(), "sge started" );
    struct RS_DatosSGE datosSGE = RS_getDatosSGE();
//    datosSGE.poderRelativoEncuentro = 2.0;
    float aporteCasters = RS_generarGrupo( datosSGE, ADE_Humanoid_YuanTis_getCaster(),  0.3, 0.2, 0 );
    RS_generarGrupo( datosSGE, ADE_Humanoid_YuanTis_getMelee(), 1.0-aporteCasters );
}

