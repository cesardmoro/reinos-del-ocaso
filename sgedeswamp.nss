/****************** Script Generador de Encuentros - COMPUESTO****************
template author: Inquisidor
script name: sgedeswamp
script author: Lobofiel
names of the areas this script is asociated with:
Desolation Swamp (10)
********************************************************************************/
#include "RS_FGE_inc"


/*****MAIN*/
void main() {
    struct RS_DatosSGE datosSGE = RS_getDatosSGE();

    if( GetIsDay() && d3()==1 ) {
        RS_generarMezclado( datosSGE,
            FGE_Animal_BosqueDiurno_getVariado()
        );
    }
    else
        FGE_Humanoid_Lizardmen( datosSGE );

/*  QUITADO por Inquisidor: excepto por los Lizards, el resto de los arreglos son de CR muy bajo para el CR de las areas donde se usa este SGE
    switch( Random(7) ){
        case 0: Scorpion( datosSGE );
            break;
        case 1: Beetle( datosSGE );
            break;
        case 3: Harpy( );
            break;
        case 4: Bestias(  );
            break;
        case 5: Serpent(  );
            break;
        case 6: Troll( datosSGE );
            break;}
        case 7: Lizard( datosSGE );
            break;
    }
*/
}
