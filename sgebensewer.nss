/************** Script Generador de Encuentros - Grupales simples *******************
template author: Inquisidor
script name: sgebensewer
script author: Inquisidor
names of the areas this script is asociated with: alcantarillas de benzor
********************************************************************************/
#include "RS_FGE_inc"

void main() {
    struct RS_DatosSGE datosSGE = RS_getDatosSGE();
    datosSGE.faccionId = STANDARD_FACTION_HOSTILE;

    float fae;
    do {
        int selector = Random(20);
        if( selector <= 10 ) {
            fae = RS_generarMezclado(
                datosSGE,
                ADE_Insect_Spider_getVariado()
                + ADE_Animales_Alimanias_getVariado()
                + ADE_Insects_Beetle_getVariado()
                + ADE_Cienos_getVariado()
                , 0.60
            );
        } else if( selector <= 14 ) {
            fae = RS_generarGrupo( datosSGE, ADE_NPC_Bandits_get() );
        } else if( selector <= 17 ) {
            fae = RS_generarGrupo( datosSGE, ADE_Insects_Ants_get() );
        } else if( selector <= 19 ) {
            fae = RS_generarGrupo( datosSGE, FGE_NPC_mercenary_get() );
        } else {
            fae = RS_generarGrupo( datosSGE, ADE_Humanoid_Lizardmen_getMelee() );
        }
    } while( fae < 0.5 );
}

