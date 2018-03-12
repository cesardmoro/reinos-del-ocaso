/******************* Registro de Ganancias *************************************
Autor: Inquisidor
Descripcion: lleva la contabilidad de todo lo adquirido por los
personajes de jugadores desde el ultimo reset.
*******************************************************************************/
#include "RS_itf"


const string RegGan_DBN = "RegGan";
const string RegGan_oro_RN = "oro";

// registra una ganancia en oro del 'pc'
// Debe ser llamada cada vez que un personaje de jugador gana oro
void RegGan_registrarOro( object pc, int monto );
void RegGan_registrarOro( object pc, int monto ) {
    if( GetLocalInt( GetArea(pc), RS_crArea_PN ) != 0 ) {
        int oroGanado = monto + GetCampaignInt( RegGan_DBN, RegGan_oro_RN, pc );
        SetCampaignInt( RegGan_DBN, RegGan_oro_RN, oroGanado, pc );
    }
}

// Da el oro que el 'pc' ha ganado desde el ultimo reset
int RegGan_getOroGanado( object pc );
int RegGan_getOroGanado( object pc ) {
    return GetCampaignInt( RegGan_DBN, RegGan_oro_RN, pc );
}


void RegGan_reset( object pc );
void RegGan_reset( object pc ) {
    SetCampaignInt( RegGan_DBN, RegGan_oro_RN, 0, pc );
}


void RegGan_onPcEntersArea( object pc, object areaActual );
void RegGan_onPcEntersArea( object pc, object areaActual ) {
    object areaAnterior = GetLocalObject( pc, RS_areaAnterior_VN  );
    int crAreaActual = GetLocalInt( areaActual, RS_crArea_PN );
    // si se entra a un area de CR = 0, o se pasa de un area de CR = 0 a otra de CR != 0,  resetear el registro
    if(
        crAreaActual == 0
        || crAreaActual != 0 && GetLocalInt( areaAnterior, RS_crArea_PN ) == 0
    ) {
        RegGan_reset( pc );
    }
}
