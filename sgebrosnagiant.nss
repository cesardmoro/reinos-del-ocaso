/****************** Script Generador de Encuentros -
COMPUESTO****************
template author: Inquisidor
script name: sgebrosnagiant
script author: Inquisidor
names of the areas this script is asociated with:
Planicie de Sholo (general)
********************************************************************************/
#include "RS_fge_inc"

void main() {
    struct RS_DatosSGE datosSGE = RS_getDatosSGE();

    // dicernir en que seccion del area cae el encuentro
    int seccionEncuentro = Location_dicernirSeccion( GetPositionFromLocation(datosSGE.ubicacionEncuentro), 5, 5 );

    // si el encuentro cae hacia el sur-oeste del area
    if( seccionEncuentro == Location_SECCION_SUR_OESTE ) {
        FGE_Giant_Ogro( datosSGE );
    }
    // si el encuentro cae hacia el nor-este del area
    else if( seccionEncuentro == Location_SECCION_NOR_ESTE ) {
        FGE_Giant_Hill( datosSGE );
    }
    // si el encuentro cae hacia el sur-este o nor-oeste del area
    else {
        if( GetLocalInt( OBJECT_SELF, RS_dadoCicloEstado_VN ) < 100 )
            FGE_Humanoid_HOrcOutLaw( datosSGE );
        else
            RS_generarMezclado( datosSGE, FGE_BosqueTemplado_getVariado() );
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
