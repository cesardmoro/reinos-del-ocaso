/***************** Cochero on heartbeat event handler **************************
Package: Sistema de tranporte por carreta - cochero - heartbeat event handler
Autor: Inquisidor
Version: 0.1
*******************************************************************************/
#include "Cochero"

void AnuncioTiempoFaltante_handler( int id, string mensaje ) {
    if( GetLocalInt( OBJECT_SELF, "ATFid" ) != id ) {
        SetLocalInt( OBJECT_SELF, "ATFid", id );
        SpeakString( mensaje, TALKVOLUME_TALK );
    }
}


void main() {
    ExecuteScript("nw_c2_default1", OBJECT_SELF);
  //  SendMessageToPC( GetFirstPC(), "Heartbeat: begin" );

    if( !GetIsInCombat(OBJECT_SELF) && !IsInConversation(OBJECT_SELF) && !GetIsDMPossessed(OBJECT_SELF) ) {

        switch( Cochero_getEstado( OBJECT_SELF ) ) {

        case Cochero_Estado_DESCANSANDO: {
            SetLocalInt( OBJECT_SELF, "estabaDescansando", TRUE );
            int tiempoFaltanteParaPartir = Cochero_getFechaHoraProximaPartida( OBJECT_SELF ) - DateTime_getActual();
//            SendMessageToPC( GetFirstPC(), "Heartbeat: tiempoFaltanteParaPartir="+IntToString( tiempoFaltanteParaPartir ) );
            if( tiempoFaltanteParaPartir < 15 )
                AnuncioTiempoFaltante_handler(  10,"Ultimo aviso. Coche con destino a "+Cochero_getDestinoViaje( OBJECT_SELF )+" pronto a partir." );
            else if( tiempoFaltanteParaPartir < 30 )
                AnuncioTiempoFaltante_handler(  30, "Coche con destino a "+Cochero_getDestinoViaje( OBJECT_SELF )+" partira en 10 minutos." );
            else if ( tiempoFaltanteParaPartir < 60 )
                AnuncioTiempoFaltante_handler(  60, "Coche con destino a "+Cochero_getDestinoViaje( OBJECT_SELF )+" partira en 20 minutos." );
            else if( tiempoFaltanteParaPartir < 90 )
                AnuncioTiempoFaltante_handler(  90, "Coche con destino a "+Cochero_getDestinoViaje( OBJECT_SELF )+" partira en 30 minutos." );
            else if( tiempoFaltanteParaPartir < 120 )
                AnuncioTiempoFaltante_handler( 120, "Coche con destino a "+Cochero_getDestinoViaje( OBJECT_SELF )+" partira en 40 minutos." );

            } break;

        case Cochero_Estado_VIAJANDO: {
            int tiempoFaltatneParaArrivar = Cochero_getFechaHoraArrivoDestino( OBJECT_SELF ) - DateTime_getActual();
  //          SendMessageToPC( GetFirstPC(), "Heartbeat: tiempoFaltatneParaArrivar="+IntToString( tiempoFaltatneParaArrivar ) );
            if( tiempoFaltatneParaArrivar < 10 )
                AnuncioTiempoFaltante_handler( -10, "Pasajeros, apenas faltan 5 minutos para llegar a " + Cochero_getDestinoViaje( OBJECT_SELF ) );
            else if( tiempoFaltatneParaArrivar < 30 )
                AnuncioTiempoFaltante_handler( -30, "Pasajeros, solo faltan 10 minutos para llegar a " + Cochero_getDestinoViaje( OBJECT_SELF ) );
            else if( tiempoFaltatneParaArrivar < 60 )
                AnuncioTiempoFaltante_handler( -60, "Pasajeros, faltan 20 minutos para llegar a " + Cochero_getDestinoViaje( OBJECT_SELF ) );
            else if( tiempoFaltatneParaArrivar < 120 )
                AnuncioTiempoFaltante_handler( -120, "Pasajeros, faltan 40 minutos para llegar a " + Cochero_getDestinoViaje( OBJECT_SELF ) );

            effect temblor = EffectVisualEffect( VFX_FNF_SCREEN_SHAKE );
            location effectTarget = GetLocation( OBJECT_SELF );
            if( tiempoFaltatneParaArrivar > 1 && !GetLocalInt( OBJECT_SELF, "estabaDescansando" ) )
                ApplyEffectAtLocation( DURATION_TYPE_TEMPORARY, temblor, effectTarget );
            if( tiempoFaltatneParaArrivar > 4 )
                DelayCommand( 3.0f, ApplyEffectAtLocation( DURATION_TYPE_TEMPORARY, temblor, effectTarget ) );

            DeleteLocalInt( OBJECT_SELF, "estabaDescansando" );

            } break;
        }
    }
}

