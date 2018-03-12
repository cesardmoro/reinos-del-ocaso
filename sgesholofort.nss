/****************** Script Generador de Encuentros -
COMPUESTO****************
template author: Inquisidor
script name: sgesholofort
script author: Lobofiel
names of the areas this script is asociated with:
Planicie de Sholo - Fuerte Perdido exterior
********************************************************************************/
#include "RS_fge_inc"

void main() {
    struct RS_DatosSGE datosSGE = RS_getDatosSGE();

    // dicernir en que seccion del area cae el encuentro
    int seccionEncuentro = Location_dicernirSeccion( GetPositionFromLocation(datosSGE.ubicacionEncuentro), 2, 3 );

    // si el encuentro cae hacia el nor-oeste del area
    if( seccionEncuentro == Location_SECCION_NOR_OESTE ) {
        FGE_Giant_Hill( datosSGE );
    }
    // si el encuentro cae hacia el sur-este del area
    else if( seccionEncuentro == Location_SECCION_SUR_ESTE ) {
        FGE_Giant_Ogro( datosSGE );
    }
    // si el encuentro cae hacia el sur_oeste o nor-este del area
    else {

        // si es de dia
        if( GetIsDay() ) {
            RS_generarMezclado( datosSGE,
                FGE_Animal_BosqueDiurno_getVariado()
            );
        }
        // si es de noche
        else {
            // si el encuentro cae hacia el nor-este del area
            if( seccionEncuentro == Location_SECCION_NOR_ESTE ) {
                FGE_Undead_Fantasma( datosSGE );
            }
            // si el encuentro cae hacia el nor-oeste del area
            else {
                RS_generarMezclado( datosSGE,
                    FGE_Animal_BosqueNocturno_getVariado()
                );
            }
        }
    }
}


/*
BosqueNoche
BosqueDia
HGiant
Ogres
UndeadSkel
UndeadFan
*/

/*     NUEVO!!!

Bosque Dia incluye Osos Legend

HGiant
gnthill001           Hill Giant D&D CR7
gnthill002barb3      Hill Giant D&D CR9 (barbarian 3)
gnthill002bar6       Hill Giant D&D CR11 (barbarian 6)
*/
