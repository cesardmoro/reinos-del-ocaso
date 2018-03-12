/****************** Script Generador de Encuentros -
COMPUESTO****************
template author: Inquisidor
script name: sgemtescristalow
script author: Inquisidor
names of the areas this script is asociated with:
Montes Cristal (noreste junto a Colinas del Sur de Brosna)
********************************************************************************/
#include "RS_fge_inc"

void main() {
    struct RS_DatosSGE datosSGE = RS_getDatosSGE();

    // dicernir en que seccion del area cae el encuentro
    int seccionEncuentro = Location_dicernirSeccion( GetPositionFromLocation(datosSGE.ubicacionEncuentro), 6, 6 );

    // si el encuentro cae hacia el sur-oeste del area
    if( seccionEncuentro == Location_SECCION_SUR_OESTE ) {
        FGE_Giant_Hill( datosSGE );
    }
    // si el encuentro cae hacia el sur-este del area
    else {

        // y si es de dia
        if( GetIsDay() ) {
            RS_generarMezclado( datosSGE,
                FGE_Animal_BosqueDiurno_getVariado()
            );
        }
        // y si es de noche
        else {
            RS_generarMezclado( datosSGE,
                FGE_Animal_BosqueNocturno_getVariado()
            );
        }
    }
}


/*
BosqueNoche
BosqueDia
HGiant
Stinger
Ogres
*/

/*     NUEVO!!!

Bosque Dia incluye Osos Legend

HGiant (Grupo)
gnthill001           Hill Giant D&D CR7
gnthill002barb3      Hill Giant D&D CR9 (barbarian 3)
gnthill002bar6       Hill Giant D&D CR11 (barbarian 6)

MontVariado (Solitario Variado)
ettin003        Ettin CR6
zep_cyclops     Ciclope CR10
zep_gntmntc_001 Muntain Giant CR14

Stinger
Warrior cr8     stinger2
Cleric cr8      stinger1
Sorcerer cr10   stinger3
Lider cr11      stinger4

*/
