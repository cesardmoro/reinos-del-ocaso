/************** Item Distribution and Interchange Control *********************
Package: Item distribucion and interchange control - todo en este include
Autor: Inquisidor
Descripcion: Este sistema hace dos cosas diferentes pero que trabajan en conjunto.
1) de distribucion de items en un party
2) control de intercambio de items
*******************************************************************************/

#include "RS_inc"


/////////////////////////////// INTERFACE ////////////////////////////////////

// Esta funcion debe ser llamada para cada item generado que se pretenda sea distribuido
// entre los miembros del party del que tome el item por primera vez.
void IDIC_distribuir( object item, float duracionReserva );

// Esta funcion debe ser llamada desde el onItemAcquire handler del modulo, para
// que este sistema funcione.
void IDIC_onAcquire( object acquiredItem, int acquiredAmount, object acquiredFrom, object acquiredBy );

// Esta funcion debe ser llamada desde el onItemUnacquire handler del modulo, para
// que este sistema funcione.
void IDIC_onUnaquire( object lostItem, object lostBy );

///////////////////////// VARIABLE NAMES //////////////////////////////////////

///// nombres de variables locales a un PJ //////
const string IDIC_pjIteradoIndice_VN = "IDICpii";

///// nombres de variables locales a un item //////
const string IDIC_pjAsignado_VN = "IDICa";
const string IDIC_propietario_VN = "IDICp";
const string IDIC_estado_VN = "IDICe";
   const int IDIC_estado_LIBRE = 0;
   const int IDIC_estado_ESTA_RESERVADO_AUN_NO_ASIGNADO = 1;
   const int IDIC_estado_ESTA_RESERVADO_Y_ASIGNADO = 3;
   const int IDIC_estado_POSEIDO = 4;
   const int IDIC_estado_TRANSICION_PROPIETARIO = 12;

//// nombres de tablas persistentes (de campania) /////
const string IDIC_balanza_CN = "IDICbc";

//// sufijos diferenciadores de los campos de un registro persistente (de campania)  ////
const string IDIC_balanzaDado_FN = "_bd";   // total de items que el PJ ha dado a otros PJs, traducido a oro
const string IDIC_balanzaRecibido_FN = "_br";  // total de items que el PJ ha recibido de otros PJs, traducido a oro



//////////////////////////// IMPLEMENTATION ////////////////////////////////////


// Cancela la reserva hecha en el item especificado
void IDIC_cancelarReserva( object itemReservado );
void IDIC_cancelarReserva( object itemReservado ) {
    int estado = GetLocalInt( itemReservado, IDIC_estado_VN );
    if(
        estado == IDIC_estado_ESTA_RESERVADO_AUN_NO_ASIGNADO ||
        estado == IDIC_estado_ESTA_RESERVADO_Y_ASIGNADO
    ) {
        DeleteLocalInt( itemReservado, IDIC_estado_VN );
        DeleteLocalObject( itemReservado, IDIC_pjAsignado_VN );
    }
}


// Esta funcion debe ser llamada para cada item generado que se pretenda sea distribuido
// entre los miembros del party del que tome el item por primera vez.
void IDIC_distribuir( object item, float duracionReserva ) {
    if( duracionReserva > 0.0 ) {
        SetLocalInt( item, IDIC_estado_VN, IDIC_estado_ESTA_RESERVADO_AUN_NO_ASIGNADO );
        DelayCommand( duracionReserva, IDIC_cancelarReserva( item ) );
    }
}


// Da la cantidad de PJs en el party del que el PJ 'pjMiembroParty' es miembro,
// y que esten en el mismo area.
// Nota: pjMiembroParty debe ser un PJ.
int IDIC_getCantPjsEnParty( object pjMiembroParty );
int IDIC_getCantPjsEnParty( object pjMiembroParty ) {
    int cantPjsEnParty = 0;
    object pjMiembroIterator = GetFirstFactionMember( pjMiembroParty, TRUE );
    while( pjMiembroIterator != OBJECT_INVALID ) {
        if( GetArea(pjMiembroIterator) == GetArea( pjMiembroParty ) )
            cantPjsEnParty += 1;
        pjMiembroIterator = GetNextFactionMember( pjMiembroParty, TRUE );
    }
    return cantPjsEnParty;
}


// Da el siguiente PJ al que le toca recibir un item en un party del cual 'pjMiembroParty' es el miembro que toma el item.
object IDIC_getSiguientePjIterado( object pjMiembroParty );
object IDIC_getSiguientePjIterado( object pjMiembroParty ) {

    // obtiene el lider del party (donde se mantendra el estado de la rotacion).
    object pjLiderParty = GetFactionLeader( pjMiembroParty );

    // obtiene la cantidad de PJs en el party
    int cantPjsEnParty = IDIC_getCantPjsEnParty( pjLiderParty );

    // obtiene el indice del PJ iterado por rotacion.
    int pjIteradoIndice = GetLocalInt( pjLiderParty, IDIC_pjIteradoIndice_VN ) + 1;
    if( pjIteradoIndice > cantPjsEnParty )
        pjIteradoIndice = 1;
    SetLocalInt( pjLiderParty, IDIC_pjIteradoIndice_VN, pjIteradoIndice );

    // obtiene el PJ iterado
    object pjMiembroIterator = GetFirstFactionMember( pjLiderParty, TRUE );
    while( pjMiembroIterator != OBJECT_INVALID ) {
        if( GetArea(pjMiembroIterator) == GetArea( pjMiembroParty ) ) {
            if( --pjIteradoIndice == 0 )
                return pjMiembroIterator;
        }
        pjMiembroIterator = GetNextFactionMember( pjLiderParty, TRUE );
    }

    WriteTimestampedLogEntry( "IDIC_getSiguientePjIterado: error, unreachable reached" );
    return pjLiderParty;
}


int getBalanceIntercambioTope( object pj ) {
    int level = GetHitDice( pj );
    return 150*level*level;
}


string getIdentificadorPj( string nombrePj ) {
    return GetStringLeft( nombrePj, 25 );
}


// Este hilo de ejecucion es iniciado por IDIC_onAcquire(..) cuando un PJ adquiere
// un item cuyo propietario es otro PJ. Su objetivo es dar tiempo al PJ a abandonar
/// el item antes de que se registre la adquisicion a su balanza de intercambio.
void IDIC_hiloTransicionPropietario( object acquiredItem, int temporizador ) {
    // mientras el item siga en posesion del Pj que inicio este hilo de transicion...
    if( GetItemPossessor( acquiredItem ) == OBJECT_SELF ) {

        // si transcurre el tiempo establecido para convertirse en nuevo propietario
        if( --temporizador == 0 ) {

            // restarle el valor del item a la balanza de intercambio del antiguo propietario. La suma a la balanza de intercambio del nuevo propietario ya se realizo apenas lo adquirio el item.
            string identificadorAntiguoPropietario = getIdentificadorPj( GetLocalString( acquiredItem, IDIC_propietario_VN ) );
            string balanzaDadoAntiguoPopietarioRef = identificadorAntiguoPropietario + IDIC_balanzaDado_FN;
            int balanzaDadoAntiguoPopietario = GetCampaignInt( IDIC_balanza_CN, balanzaDadoAntiguoPopietarioRef ) + GetGoldPieceValue( acquiredItem );
            SetCampaignInt( IDIC_balanza_CN, balanzaDadoAntiguoPopietarioRef, balanzaDadoAntiguoPopietario );

            // mostrar mensaje notificando al nuevo propietario que el antiguo mejoro su balance
            FloatingTextStringOnCreature( "Ya eres el nuevo propietario de el/la "+GetName(acquiredItem), OBJECT_SELF );

            // poner el estado del item en poseido por el nuevo porpietario
            SetLocalString( acquiredItem, IDIC_propietario_VN, GetName( OBJECT_SELF ) );
            SetLocalInt( acquiredItem, IDIC_estado_VN, IDIC_estado_POSEIDO );
        }

        // si aun falta para convertirse en el nuevo porpietario, programar el sieguiente muestreo
        else
            DelayCommand( 10.0, IDIC_hiloTransicionPropietario( acquiredItem, temporizador ) );
    }
}



void IDIC_onAcquire( object acquiredItem, int acquiredAmount, object acquiredFrom, object acquiredBy ) {

    // si quien adquiere es un DM
    if( GetIsDM( acquiredBy ) ) {
        ; // no hacer nada por ahora
    }

    // si quien adquiere es un PJ
    else if( GetIsPC( acquiredBy ) ) {

//        SendMessageToPC( GetFirstPC(), "Tesor_onAcquire: 1" );
        // si 'acquiredFrom' es invalido, se trata los items del PJ que son adquiridos al entrar al modulo.
        //if( !GetIsObjectValid( acquiredFrom ) ) {
        //    SendMessageToPC( GetFirstPC(), "Tesor_onAcquire: 2" );
        //    SetLocalString( acquiredItem, IDIC_propietario_VN, GetName(acquiredBy) );
        //}

        // si lo adquirido es un item
        if( GetIsObjectValid( acquiredItem ) ) {
            object pjAsignado;
            int balanzaIntercambioPorcentual;
            int estadoViejo = GetLocalInt( acquiredItem, IDIC_estado_VN );
            int estadoNuevo = estadoViejo;
//            SendMessageToPC( GetFirstPC(), "Tesor_onAcquire: 3 - estadoViejo="+IntToString(estadoViejo) );
            // PASO 1: trata el estado de reserva del item
            // si el item debe ser reservado pero aun no fue asignado el beneficiario (es la primera vez que es un PJ intenta adquirirlo)
            if( estadoViejo == IDIC_estado_ESTA_RESERVADO_AUN_NO_ASIGNADO ) {

//                SendMessageToPC( GetFirstPC(), "Tesor_onAcquire: 4" );
                // averiguar a cual PJ miembro del party le toca el item
                pjAsignado = IDIC_getSiguientePjIterado( acquiredBy );

                // si el PJ al que le toca el item adquirido SI es el mismo PJ que lo esta adquiriendo, quitarle el estado de reservado y simplemente dejar que el PJ adquiera el item.
                if( pjAsignado == acquiredBy ) {
                    estadoNuevo = IDIC_estado_LIBRE;
                }
                // si el PJ al que le toca el item adquirido NO es el mismo PJ que lo esta adquiriendo, reservar el item para el PJ elegido y regresarlo al contenedor de donde lo obtuvo.
                else {
                    estadoNuevo = IDIC_estado_ESTA_RESERVADO_Y_ASIGNADO;
                    SetLocalObject( acquiredItem, IDIC_pjAsignado_VN, pjAsignado );
                }
            }
            // si el item esta reservado y su beneficiario ya fue asignado
            else if( estadoViejo == IDIC_estado_ESTA_RESERVADO_Y_ASIGNADO ) {

//                SendMessageToPC( GetFirstPC(), "Tesor_onAcquire: 5" );
                // obtener el pj al que le fue asignado el beneficio de la reserva
                pjAsignado = GetLocalObject( acquiredItem, IDIC_pjAsignado_VN );

                // si el PJ que intenta adquirir el item SI es el PJ al que le fue asignada la reserva, quitarle el estado de reservado y dejar que el PJ adquiera el item.
                if( pjAsignado == acquiredBy ) {
                    estadoNuevo = IDIC_estado_LIBRE;
                    DeleteLocalObject( acquiredItem, IDIC_pjAsignado_VN );
                }
            }
            // si el item pertenecia a un PJ
            else if( estadoViejo == IDIC_estado_POSEIDO || estadoViejo == IDIC_estado_TRANSICION_PROPIETARIO ) {
//                SendMessageToPC( GetFirstPC(), "Tesor_onAcquire: 6" );

                if( GetName( acquiredBy ) == GetLocalString( acquiredItem, IDIC_propietario_VN ) ) {
//                    SendMessageToPC( GetFirstPC(), "Tesor_onAcquire: 7" );
                    estadoNuevo = IDIC_estado_LIBRE;
                }
                else {
//                    SendMessageToPC( GetFirstPC(), "Tesor_onAcquire: 8" );
                    string idAcquiredBy = getIdentificadorPj( GetName(acquiredBy) );
                    int itemValue = GetGoldPieceValue( acquiredItem );
                    int recibido = GetCampaignInt( IDIC_balanza_CN, idAcquiredBy + IDIC_balanzaRecibido_FN);
                    int dado = GetCampaignInt( IDIC_balanza_CN, idAcquiredBy + IDIC_balanzaDado_FN);
                    int balanceIntercambioTope = getBalanceIntercambioTope( acquiredBy );
//                    SendMessageToPC( GetFirstPC(), "Tesor_onAcquire: id=["+idAcquiredBy+"], recibido="+IntToString(recibido)+", dado="+IntToString(dado)+", itemValue="+IntToString(itemValue) );
                    if( recibido + itemValue - dado <= balanceIntercambioTope ) {
//                        SendMessageToPC( GetFirstPC(), "Tesor_onAcquire: 9" );
                        balanzaIntercambioPorcentual = (100*(recibido + itemValue - dado))/balanceIntercambioTope;
//                        SendMessageToPC( GetFirstPC(), "Tesor_onAcquire: bc="+IntToString(balanzaIntercambioPorcentual) );
                        SetCampaignInt( IDIC_balanza_CN, idAcquiredBy + IDIC_balanzaRecibido_FN, itemValue + recibido );
                        estadoNuevo = IDIC_estado_TRANSICION_PROPIETARIO;
                        AssignCommand( acquiredBy, DelayCommand( 10.0, IDIC_hiloTransicionPropietario( acquiredItem, 6 ) ) );
                    }
                    else {
//                        SendMessageToPC( GetFirstPC(), "Tesor_onAcquire: 10" );
                        balanzaIntercambioPorcentual = (100*(recibido - dado))/balanceIntercambioTope;
//                        SendMessageToPC( GetFirstPC(), "Tesor_onAcquire: bc=["+IntToString(balanzaIntercambioPorcentual) );
                        estadoNuevo = IDIC_estado_POSEIDO;
                    }
                }
            }
            else if( estadoViejo != IDIC_estado_LIBRE )
                WriteTimestampedLogEntry( "IDIC_onAcquire: assertion error 1" );


            // PASO 2: trata el estado de posesion del item
            // si el item adquirido estaba o paso a estar libre, dejar que el PJ lo adquiera
            if( estadoNuevo == IDIC_estado_LIBRE ) {
                FloatingTextStringOnCreature( GetName(acquiredBy)+" toma un/a "+GetName(acquiredItem), acquiredBy );
                SetLocalString( acquiredItem, IDIC_propietario_VN, GetName(acquiredBy) );
                estadoNuevo = IDIC_estado_POSEIDO;
            }
            else if( estadoNuevo == IDIC_estado_TRANSICION_PROPIETARIO )
                FloatingTextStringOnCreature( "Este/a "+GetName(acquiredItem)+" no te pertenecia.\nSi lo conservas por un minuto, seras su nuevo propietario.\nTu balanza de intercambio aumento al %"+IntToString(balanzaIntercambioPorcentual), acquiredBy );

            // si el item adquirido NO esta libre, regresarlo al sitio de donde fue adquirido
            else if( estadoNuevo == IDIC_estado_ESTA_RESERVADO_Y_ASIGNADO || estadoNuevo == IDIC_estado_POSEIDO ) {
//                if( GetHasInventory( acquiredFrom ) )
//                    AssignCommand( acquiredBy, ActionGiveItem( acquiredItem, acquiredFrom ) );
//                else
                    AssignCommand( acquiredBy, ActionPutDownItem( acquiredItem ) );

                if( estadoNuevo == IDIC_estado_ESTA_RESERVADO_Y_ASIGNADO )
                    FloatingTextStringOnCreature( "Este/a "+GetName(acquiredItem)+" le corresponde a "+GetName(pjAsignado), acquiredBy );
                else if( estadoNuevo == IDIC_estado_POSEIDO )
                    FloatingTextStringOnCreature( "Tu balanza intercambio esta muy elevada para recibir este item.\nValor actual: "+IntToString(balanzaIntercambioPorcentual), acquiredBy );
                else
                    FloatingTextStringOnCreature( "Algun impedimento evita que tu PJ adquiera este item.\nConsulte con un DM.", acquiredBy );
            }
            else
                WriteTimestampedLogEntry( "IDIC_onAcquire: assertion error 2" );


            // actualizar el estado del item
            SetLocalInt( acquiredItem, IDIC_estado_VN, estadoNuevo );

        }

        // si lo adquirido es oro
        else if( acquiredAmount > 0 ) {

//            SendMessageToPC( GetFirstPC(), "Tesor_onAcquire: 20" );
            // calcular la porcion para cada PJ miembro del party
            int porcion = acquiredAmount / IDIC_getCantPjsEnParty( acquiredBy );

            // dar una porcion a cada uno de los otros miembros
            object pjMiembroIterator = GetFirstFactionMember( acquiredBy, TRUE );
            while( pjMiembroIterator != OBJECT_INVALID ) {
                if( pjMiembroIterator != acquiredBy )
                    AssignCommand( pjMiembroIterator, TakeGoldFromCreature( porcion, acquiredBy, FALSE ) );
                pjMiembroIterator = GetNextFactionMember( acquiredBy, TRUE );
            }
        }
    } // end of else if( GetIsPC( acquiredBy ) )
}



// Esta funcion debe ser llamada desde el onItemUnacquire handler del modulo, para
// que este sistema funcione.
void IDIC_onUnaquire( object lostItem, object lostBy ) {
    if( GetIsPC(lostBy) && !GetIsDM(lostBy) && GetIsObjectValid(lostItem) ) {

        int estado = GetLocalInt( lostItem, IDIC_estado_VN );
//        SendMessageToPC( GetFirstPC(), "IDIC_onUnaquire: estado="+IntToString( estado ) );
        if( estado == IDIC_estado_TRANSICION_PROPIETARIO ) {

            // volver el estado del item a poseido por el antiguo propetario.
            SetLocalInt( lostItem, IDIC_estado_VN, IDIC_estado_POSEIDO );

            // y regresar la balanza de intercambio a su estado anterior (antes de adquirir el item)
            string identificadorLostBy = getIdentificadorPj( GetName( lostBy ) );
            string balanzaRecibidoLostByRef = identificadorLostBy + IDIC_balanzaRecibido_FN;
            int balanzaRecibidoLostBy = GetCampaignInt( IDIC_balanza_CN, balanzaRecibidoLostByRef ) - GetGoldPieceValue( lostItem );
            SetCampaignInt( IDIC_balanza_CN, balanzaRecibidoLostByRef, balanzaRecibidoLostBy );

            // mostrar mensaje informando el estado de la balanza de intercambio actual al PJ que cancelo la adquisicion
            int balanceDadoLostBy = GetCampaignInt( IDIC_balanza_CN, identificadorLostBy + IDIC_balanzaDado_FN );
            int balanceIntercambioTope = 50*GetHitDice( lostBy )*GetHitDice( lostBy );
            int balanzaIntercambioPorcentual = (100*(balanzaRecibidoLostBy - balanceDadoLostBy))/balanceIntercambioTope;
            AssignCommand( lostBy, FloatingTextStringOnCreature( "Has abandonado el item antes de transcurrido el lapso para convertirte en su propietario.\nTu balanza de intercambio regresa al valor anterior a tomar el item.\nValor actual: "+IntToString(balanzaIntercambioPorcentual), OBJECT_SELF ) );
        }
        else if( estado != IDIC_estado_POSEIDO )
            WriteTimestampedLogEntry( "IDIC_onUnaquire: assertion error" );
    }
}

