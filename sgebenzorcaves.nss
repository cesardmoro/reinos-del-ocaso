/************* Script Generador de Encuentros - Variado ***************
template author: Inquisidor
script name: sgeBenzorCaves
script author: Lobofiel
Guaridas de Animales (pequenas)
Invierte Spawn Diurno - Nocturno
********************************************************************************/
#include "RS_FGE_inc"

void main() {
    struct RS_DatosSGE datosSGE = RS_getDatosSGE();
    int selector = Random(7);
    if( selector==0 )
        RS_generarGrupo( datosSGE, FGE_NPC_mercenary_get() );
    else if( selector<=2 )
        RS_generarGrupo( datosSGE, ADE_NPC_Bandits_get() );
    else if( GetIsDay() )
        RS_generarMezclado( datosSGE, FGE_Animal_BosqueDiurno_getVariado() + ADE_Insects_Beetle_getVariado() );
    else
        RS_generarMezclado( datosSGE, FGE_Animal_BosqueNocturno_getVariado() );

}
