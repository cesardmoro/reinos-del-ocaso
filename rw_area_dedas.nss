/******** RandomWay - Area - dungeon end - default on activate script ************
Autor: Inquisidor
Description: The RandomSpawn system has an area property called 'RS_scriptPreparacionArea_PN' (="RSspa") which,
when the name of a script S is set, S is called by the RandomSpawn system every time the area state changes
from RS_Estado_PASIVO to another state (which happens when a PC enters the area A, and A is in the RS_Estado_PASIVO state).
This script was made to be put in the mentioned property, in order to generate the boss for the final area
of a RandomWay dungeon.
If the area where this script is executed is a RandomWay dungeon final area, a boss is placed in the male transition.
See RW_facade_inc and RS_onEnter for details.
*******************************************************************************/
#include "RW_facade_inc"
#include "RS_itf"

const string RW_Area_bossSge_PN = "RWAbsge";              // [string] Encounter generator script (SGE) that is used to generate the boss.

void main() {
    object areaBody = OBJECT_SELF;

    // Generate the boss
    string bossSge = GetLocalString( areaBody, RW_Area_bossSge_PN );
    if( GetLocalInt( areaBody, RW_Area_isDungeonEnd_VN ) && GetStringLength(bossSge) != 0 ) {

        // recordar valor anterior de variables de área que serán modificadas
        int numeroEncuentroSucesivo = GetLocalInt( areaBody, RS_numeroEncuentroSucesivo_VN );
        object enteringPj = GetLocalObject( areaBody, RS_enteringPj_VN );

        SetLocalInt( areaBody, RS_numeroEncuentroSucesivo_VN, -1 );
        SetLocalObject( areaBody, RS_enteringPj_VN, GetLocalObject( areaBody, RW_Area_maleTransition_VN ) );

        // ejecutar el SGE
        ExecuteScript( bossSge, areaBody );

        // volver a poner como estaban inicialmente las variables de área que fueron modificadas
        SetLocalInt( areaBody, RS_numeroEncuentroSucesivo_VN, numeroEncuentroSucesivo );
        SetLocalObject( areaBody, RS_enteringPj_VN, enteringPj );

    }

}
