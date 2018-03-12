/**************************** Perception - area **********************
Package: Perception - Area - faccade
Author: Inquisidor
Version: 0.1
Descripcon: funciones dispersas en distintos handlers que brindan informacion
al los personajes en funcion de las habilidades que posea.
*******************************************************************************/
#include "RS_itf"
#include "Dice_roll_check"


void PerceptionSys_onPjEnterArea( object pjIntruso );
void PerceptionSys_onPjEnterArea( object pjIntruso ) {

    // Percepcion de explorador
        int pjBaseSurvivalModifier = DRC_survivalModifier( pjIntruso, TRUE );
        if ( GetIsAreaNatural(OBJECT_SELF) )
            pjBaseSurvivalModifier += 1 + GetLevelByClass(CLASS_TYPE_RANGER, pjIntruso)/2;
        int crArea = GetLocalInt( OBJECT_SELF, RS_crArea_PN );
        if( 3*pjBaseSurvivalModifier > 2*crArea ) {
                                        // Esta variable se define en el SGE del area
            int cantidadDescripciones = GetLocalInt(OBJECT_SELF, "cantidadDescripciones");
            if (cantidadDescripciones <= 0)
                SendMessageToPC( pjIntruso, "percepcion de explorador: el grado de difucultad de este area es " + IntToString(crArea) );
            else
                SendMessageToPC( pjIntruso, GetLocalString(OBJECT_SELF, "descripcion_"+IntToString(Random(cantidadDescripciones))) );
        }
}
