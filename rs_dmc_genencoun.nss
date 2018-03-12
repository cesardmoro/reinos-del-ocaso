/************** RandomSpawn DM Control Wand - generate manual encounter *******/
#include "RS_itf"

void main() {
    object activator = GetPCSpeaker();
    object area = GetArea(activator);
    if( GetIsObjectValid(area) && GetLocalInt( area, RS_crArea_PN ) > 0 ) {

        // recordar valor anterior de variables de área que serán modificadas
        int numeroEncuentroSucesivo = GetLocalInt( area, RS_numeroEncuentroSucesivo_VN );
        object enteringPj = GetLocalObject( area, RS_enteringPj_VN );

        SetLocalInt( area, RS_numeroEncuentroSucesivo_VN, -2 );
        SetLocalObject( area, RS_enteringPj_VN, activator );

        // ejecutar el SGE
        string sge = GetLocalString( area, RS_sge_PN );
        ExecuteScript( sge, area );

        // volver a poner como estaban inicialmente las variables de área que fueron modificadas
        SetLocalInt( area, RS_numeroEncuentroSucesivo_VN, numeroEncuentroSucesivo );
        SetLocalObject( area, RS_enteringPj_VN, enteringPj );
    }

}
