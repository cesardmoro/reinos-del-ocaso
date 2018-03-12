/****************** Script Generador de Encuentros -
COMPUESTO****************
template author: Inquisidor
script name: sgebrosnaruin
script author: Inquisidor
names of the areas this script is asociated with:
Planicie de Sholo - Fuerte Perdido exterior
********************************************************************************/
#include "RS_fge_inc"

void main() {
    struct RS_DatosSGE datosSGE = RS_getDatosSGE();

    // y si es de dia
    if( GetIsDay() ) {
        RS_generarMezclado( datosSGE,
            FGE_Animal_BosqueDiurno_getVariado()
        );
    }
    // y si es de noche
    else {
        // dicernir en que seccion del area cae el encuentro
        int seccionEncuentro = Location_dicernirSeccion( GetPositionFromLocation(datosSGE.ubicacionEncuentro), 5, 3 );

        // si el encuentro cae hacia el este del area
        if( (seccionEncuentro & Location_SECCION_NOR_ESTE) != 0 ) {
            FGE_Undead_Fantasma( datosSGE );
        }
        // si el encuentro no cae hacia el oeste del area
        else {
            if( GetLocalInt( OBJECT_SELF, RS_dadoCicloEstado_VN ) < 100 )
                FGE_Humanoid_HOrcOutLaw( datosSGE );
            else
                RS_generarMezclado( datosSGE, FGE_BosqueTemplado_getVariado() );
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
