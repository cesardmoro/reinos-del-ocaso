/****************** Script Generador de Encuentros - COMPUESTO****************
template author: Inquisidor
script name: sgedeswampdf
script author: Lobofiel
names of the areas this script is asociated with:
Desolation Swamp, Damned Fort (1)
********************************************************************************/
#include "RS_FGE_inc"

void main() {
    struct RS_DatosSGE datosSGE = RS_getDatosSGE();

    if( d3()==0 )
        FGE_Humanoid_Lizardmen( datosSGE );
    else
        FGE_Planar_Demon( datosSGE );

// QUITADO cuando se bajo el CR de los lizard
//    if (GetIsDay()) {
//        Lizard( datosSGE );

/*  QUITADO por Inquisidor: excepto por los Lizards, el resto de los arreglos son de CR muy bajo para el CR de las areas donde se usa este SGE
        switch( Random(6) ) {
            case 0: Serpent();
                break;
            case 1: Bestias();
                break;
            case 2: Troll( datosSGE );
                break;
            case 3: Scorpion( datosSGE );
                break;
            case 4: Beetle( datosSGE );
                break;
            case 5: Lizard( datosSGE );
                break;
        }
*/

// QUITADO cuando se bajo el CR de los lizard
//    }
//    if (GetIsNight()) {
//
//        float frontera = IntToFloat( 5 * GetAreaSize( AREA_WIDTH, OBJECT_SELF ) );
//        if( GetPositionFromLocation( datosSGE.ubicacionEncuentro ).x > frontera )
//            FGE_Humanoid_Lizardmen( datosSGE );
//        else
//            Damned( datosSGE );

/*  QUITADO por Inquisidor: excepto por los Lizards y Damned, el resto de los arreglos son de CR muy bajo para el CR de las areas donde se usa este SGE
        switch( Random(7) ) {
            case 0: Lizard( datosSGE );
                break;
            case 1: Damned( datosSGE );
                break;
            case 2: Serpent();
                break;
            case 3: Bestias();
                break;
            case 4: Troll( datosSGE );
                break;
            case 5: Scorpion( datosSGE );
                break;
            case 6: Beetle( datosSGE );
                break;
        }
*/
//    }
}

