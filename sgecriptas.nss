/****************** Script Generador de Encuentros *****************************
template author: Inquisidor
script name: sgecriptas
script author: Inquisidor
names of the areas this script is asociated with:
Criptas
********************************************************************************/
#include "RS_FGE_inc"
#include "Random_inc"

void main() {
    struct RS_DatosSGE datosSGE = RS_getDatosSGE();
    float totalFae;
    struct WeightedSelector dado = WeightedDie_create( "001,020|002,010|003,010|004,010|006,020|009,030|011,020|012,010|" );
    do {
        int selector = WeightedDie_throw( dado );
        switch( selector ) {
            case 1: totalFae = RS_generarGrupo( datosSGE, FGE_NPC_mercenary_get() ); break;
            case 2: totalFae = RS_generarGrupo( datosSGE, ADE_NPC_Bandits_get() ); break;
            case 3: totalFae = RS_generarGrupo( datosSGE, ADE_NPC_Gypsy_get() ); break;
            case 4: totalFae = FGE_Undead_Fantasma( datosSGE ); break;
            case 6: totalFae = FGE_Undead_Esqueleto( datosSGE ); break;
            case 9: {
                string arreglo = RS_ArregloDMDs_sumar(
                    RS_ArregloDMDs_sumar(
                        ADE_Undead_Zombi_getMelee(),
                        ADE_Undead_Tumulo_getMelee()
                    ),
                    ADE_Undead_Momias_get()
                );
                if( Random(4)==1 )
                    arreglo = RS_ArregloDMDs_sumar( arreglo, ADE_Undead_Bodak_getVariado() );

                totalFae = RS_generarGrupo( datosSGE, arreglo );
                break; }
            case 11: totalFae = RS_generarMezclado( datosSGE, FGE_DungeonCity_getVariado() ); break;
            case 12: totalFae = RS_generarGrupo( datosSGE, ADE_Demon_Abisai_get() ); break;
        }
        dado = WeightedDie_removeFace( dado, selector );		
    } while( totalFae == 0.0 && dado.totalWeight > 0 );
}
/*
    struct RS_DatosSGE datosSGE = RS_getDatosSGE();
    //5% posibilidades de encuentro Bodak
    if (Random (20) == 0){
        RS_generarMezclado( datosSGE,ADE_Undead_Bodak_getVariado());
    }
    //10% posibilidades de Ambiente Dungeon City
    else if (Random (10) == 0){
        RS_generarMezclado( datosSGE, FGE_DungeonCity_getVariado());
    }
    else {
        RS_generarGrupo( datosSGE, FGE_Undead_get());
    }
*/

