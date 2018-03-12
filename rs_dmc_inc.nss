/*******************************************************************************
Package: Random Spawn - DM control - conversation include
Autor: Inquisidor
*******************************************************************************/
#include "RS_itf"
#include "DM_inc"

const string RS_bku_crArea_VN = "RScr_bku";
const string RS_bku_superficieEncuentro_VN = "RSspe_bku";
const string RS_bku_distanciaMinima_VN = "RSdMin_bku";
const string RS_bku_modificadorPeriodoSpawn_VN = "RSmps_bku";
const string RS_bku_sge_VN = "RSsge_bku";
const string RS_bku_porcentajeModificadorCantidadRefuerzos_VN = "RSpmcr_bku";
const string RS_bku_procentajeModificadorPorcentajeAumentoPoderUltimoRefuerzo_VN = "RSpmpapur_bku";
const string RS_dmControlTimer_VN = "RSdmct";


void RS_DMC_onActivate();
void RS_DMC_onActivate() {
//    if( GetIsDM( GetItemActivator() ) )
    if( GetIsAllowedDM( GetItemActivator() ) || GetPCPublicCDKey(GetItemActivator()) == "" )
        AssignCommand( GetItemActivator(), ActionStartConversation( GetItemActivator(), "rs_dmc_conversat", TRUE, FALSE ) );
}

void RS_DMC_backup( object area ) {
    SetLocalInt( area, RS_bku_crArea_VN, GetLocalInt( area, RS_crArea_PN ) );
    SetLocalInt( area, RS_bku_superficieEncuentro_VN, GetLocalInt( area, RS_superficieEncuentro_PN ) );
    SetLocalInt( area, RS_bku_distanciaMinima_VN, GetLocalInt( area, RS_distanciaMinima_PN ) );
    SetLocalFloat( area, RS_bku_modificadorPeriodoSpawn_VN, GetLocalFloat( area, RS_modificadorPeriodoSpawn_PN ) );
    SetLocalString( area, RS_bku_sge_VN, GetLocalString( area, RS_sge_PN ) );
    SetLocalInt( area, RS_bku_porcentajeModificadorCantidadRefuerzos_VN, GetLocalInt( area, RS_porcentajeModificadorCantidadRefuerzos_PN ) );
    SetLocalInt( area, RS_bku_procentajeModificadorPorcentajeAumentoPoderUltimoRefuerzo_VN, GetLocalInt( area, RS_procentajeModificadorPorcentajeAumentoPoderUltimoRefuerzo_PN ) );
}

void RS_DMC_restore( object area ) {
    SetLocalInt( area, RS_crArea_PN, GetLocalInt( area, RS_bku_crArea_VN ) );
    SetLocalInt( area, RS_superficieEncuentro_PN, GetLocalInt( area, RS_bku_superficieEncuentro_VN ) );
    SetLocalInt( area, RS_distanciaMinima_PN, GetLocalInt( area, RS_bku_distanciaMinima_VN ) );
    SetLocalFloat( area, RS_modificadorPeriodoSpawn_PN, GetLocalFloat( area, RS_bku_modificadorPeriodoSpawn_VN ) );
    SetLocalString( area, RS_sge_PN, GetLocalString( area, RS_bku_sge_VN ) );
    SetLocalInt( area, RS_porcentajeModificadorCantidadRefuerzos_PN, GetLocalInt( area, RS_bku_porcentajeModificadorCantidadRefuerzos_VN ) );
    SetLocalInt( area, RS_procentajeModificadorPorcentajeAumentoPoderUltimoRefuerzo_PN, GetLocalInt( area, RS_bku_procentajeModificadorPorcentajeAumentoPoderUltimoRefuerzo_VN ) );
    SetLocalInt( area, RS_dmControlTimer_VN, 0 );
}

void RS_DMC_rutina( object area ) {
    int timer = GetLocalInt( area, RS_dmControlTimer_VN );
    if( timer > 1 ) {
        DelayCommand( 60.0, RS_DMC_rutina( area ) );
        SetLocalInt( area, RS_dmControlTimer_VN, timer - 1 );
    } else if( timer == 1 ) {
        RS_DMC_restore( area );
    }
}


object RS_DMC_activate() {
    object dm = GetPCSpeaker();
    object area = GetArea( dm );
    if( GetLocalInt( area, RS_dmControlTimer_VN ) == 0 ) {
        RS_DMC_backup( area );
        DelayCommand( 60.0, RS_DMC_rutina( area ) );
    }
    SetLocalInt( area, RS_dmControlTimer_VN, 120 );
    return area;
}


// desactiva el control del DM. Todos los valores originales son recuperados.
object RS_DMC_deactivate();
object RS_DMC_deactivate() {
    object dm = GetPCSpeaker();
    object area = GetArea( dm );
    if( GetLocalInt( area, RS_dmControlTimer_VN ) != 0 ) {
        RS_DMC_restore( area );
    }
    return area;
}


// obtiene el estado actual
int RS_DMC_getEstado();
int RS_DMC_getEstado() {
    object dm = GetPCSpeaker();
    object area = GetArea( dm );
    return GetLocalInt( area, RS_estado_VN );
}


// obtiene el numero de encuentro sucesivo actual
int RS_DMC_getNES();
int RS_DMC_getNES() {
    object dm = GetPCSpeaker();
    object area = GetArea( dm );
    return GetLocalInt( area, RS_numeroEncuentroSucesivo_VN );
}

// cambia el CR actual
int RS_DMC_setCr( int cr );
int RS_DMC_setCr( int cr ) {
    object area = RS_DMC_activate();
    if( cr < 0 )
        cr = 0;
    SetLocalInt( area, RS_crArea_PN, cr );
    return cr;
}


// obtiene el CR actual
int RS_DMC_getCr();
int RS_DMC_getCr() {
    object dm = GetPCSpeaker();
    object area = GetArea( dm );
    return GetLocalInt( area, RS_crArea_PN );
}


// cambia el spe actual
int RS_DMC_setSPE( int spe );
int RS_DMC_setSPE( int spe ) {
    object area = RS_DMC_activate();
    if( spe < 16 )
        spe = 16;
    SetLocalInt( area, RS_superficieEncuentro_PN, spe );
    return spe;
}


// obtiene el spe actual
int RS_DMC_getSPE();
int RS_DMC_getSPE() {
    object dm = GetPCSpeaker();
    object area = GetArea( dm );
    return RS_getSuperficiePorEncuentro( area );
}


// cambia el dMin actual
int RS_DMC_setDMin( int dMin );
int RS_DMC_setDMin( int dMin ) {
    object area = RS_DMC_activate();
    if( dMin < 2 )
        dMin = 2;
    SetLocalFloat( area, RS_distanciaMinima_PN, IntToFloat(dMin) );
    return dMin;
}


// obtiene el dMin actual
int RS_DMC_getDMin();
int RS_DMC_getDMin() {
    object dm = GetPCSpeaker();
    object area = GetArea( dm );
    return FloatToInt( RS_getDistanciaMinimaEntrePjYEncuentro(area) );
}


// cambia el mps actual
int RS_DMC_setMPS( int mps );
int RS_DMC_setMPS( int mps ) {
    object area = RS_DMC_activate();
    if( mps < -90 )
        mps = -90;
    if( mps > 1000 )
        mps = 1000;
    SetLocalFloat( area, RS_modificadorPeriodoSpawn_PN, IntToFloat(mps)/100.0  );
    return mps;
}


// obtiene el mps actual
int RS_DMC_getMPS();
int RS_DMC_getMPS() {
    object dm = GetPCSpeaker();
    object area = GetArea( dm );
    int mps = FloatToInt( GetLocalFloat( area, RS_modificadorPeriodoSpawn_PN )*100.0 );
    return mps;
}


// cambia el SGE actual
string RS_DMC_setSGE( string sge );
string RS_DMC_setSGE( string sge ) {
    object area = RS_DMC_activate();
    SetLocalString( area, RS_sge_PN, sge );
    return sge;
}


// obtiene el SGE actual
string RS_DMC_getSGE();
string RS_DMC_getSGE() {
    object dm = GetPCSpeaker();
    object area = GetArea( dm );
    return GetLocalString( area, RS_sge_PN );
}


// cambia el mcesr actual
int RS_DMC_setMCESR( int mcesr );
int RS_DMC_setMCESR( int mcesr ) {
    object area = RS_DMC_activate();
    if( mcesr < -95 )
        mcesr = -95;
    SetLocalInt( area, RS_porcentajeModificadorCantidadRefuerzos_PN, mcesr );
    return mcesr;
}


// obtiene el mcesr actual
int RS_DMC_getMCESR();
int RS_DMC_getMCESR() {
    object dm = GetPCSpeaker();
    object area = GetArea( dm );
    int mcesr = GetLocalInt( area, RS_porcentajeModificadorCantidadRefuerzos_PN );
    return mcesr;
}


// cambia el apur actual
int RS_DMC_setAPUR( int apur );
int RS_DMC_setAPUR( int apur ) {
    object area = RS_DMC_activate();
    if( apur < -95 )
        apur = -95;
    SetLocalInt( area, RS_procentajeModificadorPorcentajeAumentoPoderUltimoRefuerzo_PN, apur );
    return apur;
}


// obtiene el apur actual
int RS_DMC_getAPUR();
int RS_DMC_getAPUR() {
    object dm = GetPCSpeaker();
    object area = GetArea( dm );
    int apur = GetLocalInt( area, RS_procentajeModificadorPorcentajeAumentoPoderUltimoRefuerzo_PN );
    return apur;
}


