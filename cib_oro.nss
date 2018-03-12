/************** Control de intercambio de bienes - oro *********************
Package: Control de intercambio de bienes - Oro
Autor: Inquisidor
Descripcion: seccion del sistema de control de intercambio de bienes que se
encarga del intercambio de oro.
*******************************************************************************/
#include "CIB_ValueAdapter"
#include "CIB_Registro"
#include "Party_generic"
#include "RegGan_inc"


const string CIB_Oro_bolsaDentroContenedor_VN = "OroB"; // cuando la bolsa de oro se genera dentro de un contenedor, esta variable se guarda en el PJ haciendo referencia a la ultima bolsa generada para posterior uso durante el dialogo.
const string CIB_Oro_monto_VN = "OroM";         // monto que representa la bolsa de oro
const string CIB_Oro_nombrePropietario_VN = "OroNP";   // nombre del PJ que genero la bolsa de oro usando el racionador. Solo valido si el CIB_Oro_estado_VN == CIB_Oro_Estado_POSEIDO.
const string CIB_Oro_refPropietario_VN = "OroRP";   // referencia al PJ que genero la bolsa de oro usando el racionador. Solo valido si el CIB_Oro_estado_VN == CIB_Oro_Estado_POSEIDO.
const string CIB_Oro_estado_VN = "OroE";        // estado de la bolsa de oro
   const int CIB_Oro_Estado_LIBRE = 1;          // el oro se lo queda todo quien lo toma, sin alterar su balance
   const int CIB_Oro_Estado_PARA_REPARTIR = 2;  // el oro se reparte entre los PJs integrantes del party, sin alterar sus balances
   const int CIB_Oro_Estado_POSEIDO = 4;        // el oro se lo queda todo quien lo toma, aumentando el balance del receptor y bajando el balance del dador


const string CIB_Oro_item_RR = "cib_oro_item";              // ResRef de la bolsa que representa el monto de oro cuando esta dentro de un contenedor
const string CIB_Oro_placeable_RR = "cib_oro_placeabl";     // ResRef de la bolsa que bolsa que representa el monto de oro cuando esta en el suelo. La razon de porque hay dos objetos distinto para representar el monto de oro, es que se necesita sea un item cuando esta dentro de un contenedor; y que sea un placeable cuando se raciona oro al suelo dado que los items no soportan dialogos.
const string CIB_Oro_conversation_RR = "cib_oro_conversa";  // ResRef del dialogo entre el PJ y la bolsa de oro creada por el racionador
const string CIB_Oro_racionador_RR = "cib_oro_racionad";    // ResRef de la herramienta racionadora de oro


// Genera una bolsa con 'monto' monedas de oro en 'sitio'.
// Si 'estado' es CIB_Oro_Estado_POSEIDO, el oro tendra el propietario cuyo nombres sea 'nombrePropietario'.
// 'refPropietario' no es neceario. Solo se usa para guardar el personaje.
object CIB_Oro_generarEnSuelo( location sitio, int monto, int estado=CIB_Oro_Estado_LIBRE, string nombrePropietario="", object refPropietario=OBJECT_INVALID );
object CIB_Oro_generarEnSuelo( location sitio, int monto, int estado=CIB_Oro_Estado_LIBRE, string nombrePropietario="", object refPropietario=OBJECT_INVALID ) {
    object oro = CreateObject( OBJECT_TYPE_PLACEABLE, CIB_Oro_placeable_RR, sitio );
    if( GetIsObjectValid( oro ) ) {
        if( monto == 1 )
            SetName( oro, "bolsa con una moneda" );
        else
            SetName( oro, "bolsa con "+IntToString( monto )+" monedas" );

        SetLocalInt( oro, CIB_Oro_monto_VN, monto );
        SetLocalInt( oro, CIB_Oro_estado_VN, estado );
        if( estado == CIB_Oro_Estado_POSEIDO ) {
            SetLocalString( oro, CIB_Oro_nombrePropietario_VN, nombrePropietario );
            SetLocalObject( oro, CIB_Oro_refPropietario_VN, refPropietario );
        }
    }
    return oro;
}

// si 'esRepartido' es TRUE, 'nombrePropietario' es ignorado.
// si 'esRepartido' es FALSE y 'nombrePropietario' es distinto de "", el oro quedará con el propietario indicado.
// si 'esRepartido' es FALSE y 'nombrePropietario' es "", el oro quedará sin propietario.
// refPropietario solo se usa para gaurdar el PJ
object CIB_Oro_generarEnContenedor( object contenedor, int monto, int esRepartido=TRUE, string nombrePropietario="", object refPropietario=OBJECT_INVALID );
object CIB_Oro_generarEnContenedor( object contenedor, int monto, int esRepartido=TRUE, string nombrePropietario="", object refPropietario=OBJECT_INVALID ) {
    object oro = CreateItemOnObject( CIB_Oro_item_RR, contenedor );
    if( GetIsObjectValid( oro ) ) {
        if( monto == 1 )
            SetName( oro, "bolsa con una moneda" );
        else
            SetName( oro, "bolsa con "+IntToString( monto )+" monedas" );

        SetLocalInt( oro, CIB_Oro_monto_VN, monto );
        if( esRepartido )
            SetLocalInt( oro, CIB_Oro_estado_VN, CIB_Oro_Estado_PARA_REPARTIR );
        else if( nombrePropietario == "" )
            SetLocalInt( oro, CIB_Oro_estado_VN, CIB_Oro_Estado_LIBRE );
        else {
            SetLocalInt( oro, CIB_Oro_estado_VN, CIB_Oro_Estado_POSEIDO );
            SetLocalString( oro, CIB_Oro_nombrePropietario_VN, nombrePropietario );
            SetLocalObject( oro, CIB_Oro_refPropietario_VN, refPropietario );
        }

    }
    return oro;
}


void CIB_Oro_onActivate();
void CIB_Oro_onActivate() {

    object item = GetItemActivated();
    object pjFuente = GetItemActivator();
    object targetObj = GetItemActivatedTarget();
    location targetLoc = GetItemActivatedTargetLocation();
    object oro;

    if( GetObjectType( targetObj )==OBJECT_TYPE_PLACEABLE && GetHasInventory( targetObj ) && !GetLocked( targetObj ) ) {
        oro = CreateItemOnObject( CIB_Oro_item_RR, targetObj );
    }
    else if( !GetIsObjectValid( targetObj ) && GetAreaFromLocation(targetLoc)!=OBJECT_INVALID ) {
        oro = CreateObject( OBJECT_TYPE_PLACEABLE, CIB_Oro_placeable_RR, targetLoc );
        targetObj = oro;
    }
    else if( targetObj == pjFuente ) {
        struct CIB_Balance balance = CIB_getBalance( GetName(pjFuente, TRUE) );
        SendMessageToPC( pjFuente, "Tu balanza de intercambio esta en " + IntToString( CIB_getBalancePorcentual( balance.recibido - balance.dado, GetHitDice(pjFuente) ) ) + "%" );
        oro = OBJECT_INVALID;
    }
    else if( GetObjectType(targetObj)==OBJECT_TYPE_ITEM && pjFuente == GetItemPossessor(targetObj) ) {
        int valorAparente = CIB_getItemApparentGoldValue( targetObj, pjFuente );
        SendMessageToPC( pjFuente, "El ítem (" + GetName(targetObj) + ") aparenta valer " + IntToString( valorAparente ) + " monedas de oro." );
        oro = OBJECT_INVALID;
    }
    else
        return;

    if( GetIsObjectValid( oro ) ) {
        SetLocalObject( pjFuente, CIB_Oro_bolsaDentroContenedor_VN, oro );
        SetName( oro, "bolsa vacia" );
        SetLocalInt( oro, CIB_Oro_estado_VN, CIB_Oro_Estado_POSEIDO );
        SetLocalString( oro, CIB_Oro_nombrePropietario_VN, GetName(pjFuente, TRUE) );
        SetLocalObject( oro, CIB_Oro_refPropietario_VN, pjFuente );
        AssignCommand( pjFuente, ActionStartConversation( targetObj, CIB_Oro_conversation_RR, TRUE ) );
    }
}


int CIB_Oro_getMonto( object pjFuente );
int CIB_Oro_getMonto( object pjFuente ) {
    object oro = GetLocalObject( pjFuente, CIB_Oro_bolsaDentroContenedor_VN );
    return GetLocalInt( oro, CIB_Oro_monto_VN );
}


int CIB_Oro_incrementarMonto( object pjFuente, int cantidad );
int CIB_Oro_incrementarMonto( object pjFuente, int cantidad ) {
    int monto = 0;
    if( GetGold(pjFuente) >= cantidad ) {

        object oro = GetLocalObject( pjFuente, CIB_Oro_bolsaDentroContenedor_VN );

        if( GetIsObjectValid( oro ) ) {
            TakeGoldFromCreature( cantidad, pjFuente, TRUE );
            monto = GetLocalInt( oro, CIB_Oro_monto_VN ) + cantidad;
            SetLocalInt( oro, CIB_Oro_monto_VN, monto );
            if( monto == 1 )
                SetName( oro, "bolsa con una moneda" );
            else
                SetName( oro, "bolsa con "+IntToString( monto )+" monedas" );
        }
    }
    return monto;
}


void CIB_Oro_cancelarMonto( object pjFuente );
void CIB_Oro_cancelarMonto( object pjFuente ) {
    object oro = GetLocalObject( pjFuente, CIB_Oro_bolsaDentroContenedor_VN );
    GiveGoldToCreature( pjFuente, GetLocalInt( oro, CIB_Oro_monto_VN ) );
    DestroyObject( oro );
}



void CIB_Oro_adquirir( object oro, object receptor );
void CIB_Oro_adquirir( object oro, object receptor ) {
    int monto = GetLocalInt( oro, CIB_Oro_monto_VN );
    if( monto != 0 ) {
        int estado = GetLocalInt( oro, CIB_Oro_estado_VN );

        // si quien toma la bolsa de oro es un DM
        if( GetIsDM( receptor ) || GetIsDMPossessed( receptor ) ) {
            if( estado == CIB_Oro_Estado_POSEIDO )
                FloatingTextStringOnCreature( "Has tomado " + IntToString(monto) + " monedas de oro que eran de " + GetLocalString( oro, CIB_Oro_nombrePropietario_VN ) + ".\nNota: El balance de intercambio del duenio no baja cuando su oro es tomado por un DM.", receptor, FALSE );
            GiveGoldToCreature( receptor, monto ); // para ayudar a la memoria del DM
        }

        // en cambio, si quien toma la bolsa es un PJ
        // si es oro para repartir entre los miembros del party
        else if( estado == CIB_Oro_Estado_PARA_REPARTIR ) {

            // calcular la porcion para cada PJ miembro del party
            int cantPjEnParty = Party_getCantPjsMismaArea( receptor );
            int porcion = monto /cantPjEnParty;
            int resto = monto - porcion * cantPjEnParty;

            // dar una porcion a cada uno de los otros miembros
            object pjMiembroIterator = GetFirstFactionMember( receptor, TRUE );
            while( pjMiembroIterator != OBJECT_INVALID ) {
                if( GetArea(pjMiembroIterator) == GetArea(receptor) ) {
                    int porcionMasResto = porcion + (resto>0?1:0);
                    GiveGoldToCreature( pjMiembroIterator, porcionMasResto );
                    RegGan_registrarOro( pjMiembroIterator, porcionMasResto );
                    resto -= 1;
                }
                pjMiembroIterator = GetNextFactionMember( receptor, TRUE );
            }
        }

        // si es oro que pertenece a un PJ
        else if( estado == CIB_Oro_Estado_POSEIDO ) {

            object dador = GetLocalObject( oro, CIB_Oro_refPropietario_VN ); // esta referencia puede ser invalida. Solo se usa para guardar el PJ
            string nombreDador = GetLocalString( oro, CIB_Oro_nombrePropietario_VN );
            if( GetName( receptor, TRUE ) == nombreDador ) {
                GiveGoldToCreature( receptor, monto );
                SetLocalInt( receptor, "isExportPending", TRUE ); // Hace que se exporte el PJ en el proximo heartbeat.
            }
            else {
                struct CIB_Balance balanceDador = CIB_getBalance( nombreDador );

                struct CIB_Balance balanceReceptor = CIB_getBalance( GetName(receptor, TRUE) );
                int balanceAbsolutoReceptor = monto + balanceReceptor.recibido - balanceReceptor.dado;
                int desbalanceMaximo = CIB_getDesbalanceMaximo( GetHitDice(receptor) );

                int sobra = balanceAbsolutoReceptor - desbalanceMaximo;
                if( sobra > 0) {
                    if( sobra <= monto ) {
                        balanceAbsolutoReceptor = desbalanceMaximo;
                        monto -= sobra;
                    } else if( sobra > monto ) {// esto puede suceder si se cambia el desbalance máximo a un valor mas bajo
                        balanceAbsolutoReceptor =  balanceReceptor.recibido - balanceReceptor.dado;
                        sobra = monto;
                        monto = 0;
                    }
                    CIB_Oro_generarEnSuelo( GetLocation( receptor ), sobra, CIB_Oro_Estado_POSEIDO, nombreDador, dador );
                }

                if( monto == 0 )
                    FloatingTextStringOnCreature( "No puedes tomar el oro debido a que tu balance de intercambio esta en el maximo admisible.", receptor, FALSE );
                else {
                    GiveGoldToCreature( receptor, monto );
                    RegGan_registrarOro( receptor, monto );
                    CIB_registrarAdquisicion( balanceReceptor, monto );
                    CIB_registrarPerdida( balanceDador, monto );
                    FloatingTextStringOnCreature( "Has tomado " + IntToString(monto) + " monedas de oro ajeno. Tu balance de intercambio sube a " + IntToString( CIB_getBalancePorcentual( balanceAbsolutoReceptor, GetHitDice(receptor) ) ) + "%", receptor, FALSE );

                    SetLocalInt( receptor, "isExportPending", TRUE ); // Hace que se exporte el PJ en el proximo heartbeat.
                    if( GetIsObjectValid( dador ) )
                        SetLocalInt( dador, "isExportPending", TRUE ); // Hace que se exporte el PJ en el proximo heartbeat.
                }
            }
        }

        // si es oro de nadie para quien lo tome
        else if( estado == CIB_Oro_Estado_LIBRE ) {
            GiveGoldToCreature( receptor, monto );
            RegGan_registrarOro( receptor, monto );
        }
        else
            WriteTimestampedLogEntry( "CIB_Oro_adquirir: error, unreachable reached. receptor="+GetName(receptor, TRUE)+", dador="+GetLocalString( oro, CIB_Oro_nombrePropietario_VN )+", monto="+IntToString(monto)+", area="+GetTag(GetArea(receptor)) );
    }
    SetName( oro, "bolsa vacia" );
    DestroyObject( oro );
}
