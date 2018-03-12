/*************** Control de intercambio de bienes - registro  ******************
Package: Control de intercambio de bienes - Registro
Autor: Inquisidor
Descripcion: funciones para el mantenimiento persistente del balance de
intercambio de bienes.
*******************************************************************************/


////////////////////////// INTERFACE //////////////////////////////////////////

struct CIB_Balance {
    string identificadorPj;
    int recibido;
    int dado;
};

int CIB_getDesbalanceMaximo( int nivelPj );

struct CIB_Balance CIB_getBalance( string nombrePj );

int CIB_examinarPosibilidadAdquirir( struct CIB_Balance balance, int montoPretendido, int nivelPj );

int CIB_registrarAdquisicion( struct CIB_Balance balance, int montoAdquirido );

int CIB_registrarPerdida( struct CIB_Balance balance, int montoPerdido );

int CIB_getBalancePorcentual( int balanceAbsoluto, int nivelPj );




//////////////////////// VARIABLES NAMES ///////////////////////////////////////

//// nombres de tablas persistentes (de campania) /////
const string CIB_balanza_CN = "CIBdb";

//// sufijos diferenciadores de los campos de un registro persistente (de campania)  ////
const string CIB_balanzaDado_FN = "_bd";   // total de items que el PJ ha dado a otros PJs, traducido a oro
const string CIB_balanzaRecibido_FN = "_br";  // total de items que el PJ ha recibido de otros PJs, traducido a oro




/////////////////////// IMPLEMENTATION /////////////////////////////////////////

int CIB_getDesbalanceMaximo( int nivelPj );
int CIB_getDesbalanceMaximo( int nivelPj ) {
    return 100*nivelPj*nivelPj; // estaba en 80
}


struct CIB_Balance CIB_getBalance( string nombrePj ) {
    struct CIB_Balance balance;
    balance.identificadorPj = GetStringLeft( nombrePj, 25 );
    balance.recibido = GetCampaignInt( CIB_balanza_CN, balance.identificadorPj + CIB_balanzaRecibido_FN);
    balance.dado = GetCampaignInt( CIB_balanza_CN, balance.identificadorPj + CIB_balanzaDado_FN);
    return balance;
}


int CIB_examinarPosibilidadAdquirir( struct CIB_Balance balance, int montoPretendido, int nivelPj ) {
    return balance.recibido + montoPretendido - balance.dado <= CIB_getDesbalanceMaximo(nivelPj);
}


int CIB_registrarAdquisicion( struct CIB_Balance balance, int montoAdquirido ) {
    int recibido = balance.recibido + montoAdquirido;
    SetCampaignInt( CIB_balanza_CN, balance.identificadorPj + CIB_balanzaRecibido_FN, recibido );
    return recibido - balance.dado;
}


int CIB_registrarPerdida( struct CIB_Balance balance, int montoPerdido ) {
    int perdido = balance.dado + montoPerdido;
    SetCampaignInt( CIB_balanza_CN, balance.identificadorPj + CIB_balanzaDado_FN, perdido );
    return balance.recibido - perdido;
}


int CIB_getBalancePorcentual( int balanceAbsoluto, int nivelPj ) {
    return (100*balanceAbsoluto)/CIB_getDesbalanceMaximo(nivelPj);
}

