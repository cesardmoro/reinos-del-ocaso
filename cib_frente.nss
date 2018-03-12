/************** Control de intercambio de bienes - frente *********************
Package: Control de intercambio de bienes - frente
Autor: Inquisidor
Descripcion: Este sistema hace dos cosas diferentes pero que trabajan en conjunto.
1) distribucion de items en un party
2) control de intercambio de items entre personajes de jugadores (PJs)
*******************************************************************************/
#include "Party_generic"
#include "CIB_oro"
#include "CIB_registro"
#include "Store_basic"
#include "Item_inc"
#include "Mod_inc"
#include "RS_itf"
#include "Ctnr_VectorObj"


/////////////////////////////// INTERFACE ////////////////////////////////////

// Da el nombre del propietario del ítem, en lo que al CIB respecta.
string CIB_getNombrePropietario( object item );

// Esta funcion debe ser llamada para cada item generado que se pretenda sea distribuido
// entre los miembros del party del que tome el item por primera vez.
// Si 'duracionReserva' es mayor a cero, la recerva es cancelada cuando pasen 'duracionReserva' segundos desde que esta operación es llamada.
void CIB_distribuir( object item, float duracionReserva=120.0 );

// Esta funcion debe ser llamada desde el onItemAcquire handler del modulo, para
// que este sistema funcione.
void CIB_onAcquire( object acquiredItem, int acquiredAmount, object acquiredFrom, object acquiredBy );

// Esta funcion debe ser llamada desde el onItemUnacquire handler del modulo, para
// que este sistema funcione.
void CIB_onUnaquire( object lostItem, object lostBy );

// Debe ser llamado desde el handler del evento onClientEnter.
// Inicializa el estado de los items como poseidos por el 'client', pisando el que pudiera venir desde el vault.
// Esto es obligatorio porque despues del onClientLeave todos los ítems poseidos por 'client' son propiedad de él.
// Solo hace efecto si 'client' es un PJ
void CIB_onClientEnter( object client );

// Debe ser llamado desde el handler del evento onClientLeave.
// Completa las transicion de items que estan en proceso, y corrige la de los items que burlan el balance, cosa que todos los ítems poseidos por 'client' sean propiedad de 'client'.
// Solo hace efecto si 'client' es un PJ
// Recordar que los cambios en las variables locales hechos surante el onClientLeave no se guardan en el vault. Esto obliga a inicializar el estado de los ítems en el onClientEnter.
void CIB_onClientLeave( object client );

// Llamado de 'Store_onOpenForEachItemOfTheClient(..)' para determinar el precio del item.
// Nuncao concede la venta, la prohive si el cliente no es propietario del item.
// No modifica el precio del item.
struct Store_PermisoVenta CIB_onItemArrivesStore( object item, object cliente );

// Transfiere el 'item' de OBJECT_SELF a 'contenedor'.
// OBJECT_SELF debe ser un PJ y poseer el 'item'.
// 'contenedor' no debe estar controlado por el CIB (no debe ser un PJ).
// El parametro 'nuevoEstado' determina en que CIB_Estado quedará el item. Los
// valores válidos son: CIB_Estado_LIBRE, CIB_estado_ESTA_RESERVADO_AUN_NO_ASIGNADO
// y CIB_estado_POSEIDO CI.
// Si el item estaba en CIB_estado_TRANSICION_PROPIETARIO, se completa la trancision cosa que el que al que le fue quitado el item sea el propietario.
// Nota: esta accion provoca que se disparen los eventos onUnequip y onUnacquire
void CIB_transferirItemAContenedor( object item, object contenedor, int nuevoEstado );


//////////////////// FORWARD DECLARATIONS OF PRIVATE FUNCTIONS /////////////////

// funcion privada
void CIB_intentarAdquirirItemAjeno( object acquiredBy, object acquiredItem, object acquiredFrom );


///////////////////////// CONSTANTS NAMES /////////////////////////////////////

const string CIB_DELIMITADOR_MIEMBROS = ";";
const float CIB_TRANSICION_PROPIETARIO_PERIODO_MUESTREO = 10.0;
const int CIB_TRANSICION_PROPIETARIO_CANTIDAD_MUESTREOS = 6;
const float CIB_CORREGIDOR_BURLA_BALANCE_PERIODO_MUESTREO_INICIAL = 5.0;
const string CIB_cheatHandler = "CIB_cheatHandler";


///////////////////////// VARIABLE NAMES //////////////////////////////////////

///// nombres de variables locales a un PJ //////
const string CIB_pjIteradoIndice_VN = "CIBpii";

///// nombres de variables locales a un item //////
const string CIB_pjAsignado_VN = "CIBa";    // variable de tipo object que señala al PJ con el beneficio de la recerva del item. Este valor es válido solo cuando el ítme esta en estado  CIB_estado_ESTA_RESERVADO_Y_ASIGNADO.
const string CIB_nombrePropietario_VN = "CIBp";   // variable de tipo string que guarda el nombre del propietario del ítem. Este valor es válido cuando el ítem esta en estdo CIB_estado_VN esta CIB_estado_POSEIDO o en estado CIB_estado_TRANSICION_PROPIETARIO.
const string CIB_refPropietario_VN = "CIBrp";   // variable de tipo object que guarda el propietario del ítem. Este valor es válido cuando el ítem esta en estdo CIB_estado_VN esta CIB_estado_POSEIDO o en estado CIB_estado_TRANSICION_PROPIETARIO.
const string CIB_Item_nombresMiemborsEquipoQueLoGano_VN = "CIBnmeqlg"; // variable de tipo string que guarda los nombres de los miembros del grupo E (ver 'CIB_Item_repartir(..)').
const string CIB_estado_VN = "CIBe";        // variable de tipo int que indica en que estado esta el ítem. Las siguientes lineas son los posibles estados.
   const int CIB_estado_LIBRE = 0;
   const int CIB_estado_ESTA_RESERVADO_AUN_NO_ASIGNADO = 1;
   const int CIB_estado_ESTA_RESERVADO_Y_ASIGNADO = 3;
   const int CIB_estado_POSEIDO = 4;
   const int CIB_estado_TRANSICION_PROPIETARIO = 12; // = CIB_estado_POSEIDO | 8
   //const int CIB_estado_ESTA_REPARTIDO_AUN_NO_ASIGNADO = 17; // = CIB_estado_ESTA_RESERVADO_AUN_NO_ASIGNADO | 16


//////////////////////////// IMPLEMENTATION ////////////////////////////////////


// funcion privada usada por CIB_adquirirItem
int CIB_esItemConsumible( object item ) {
    int itemType = GetBaseItemType( item );
    return
        GetResRef( item ) == "vendas"
        || itemType == BASE_ITEM_SPELLSCROLL
        || itemType == BASE_ITEM_POTIONS
        || itemType == BASE_ITEM_SCROLL
        || itemType == BASE_ITEM_ENCHANTED_POTION
        || itemType == BASE_ITEM_ENCHANTED_SCROLL
    ;
}


// ver declaracion
string CIB_getNombrePropietario( object item ) {
    return
        (GetLocalInt( item, CIB_estado_VN ) & CIB_estado_POSEIDO) != 0
        ? GetLocalString( item, CIB_nombrePropietario_VN )
        : ""
    ;
}


// Marca al 'item' como repartido entre los miembros del grupo E, donde el grupo E es el conjunto de PJs que estan en el mismo party y área en que esta 'sujeto' cuando esta operación es llamada.
// Un ítem marcado con esta marca solo puede ser tomado por el PJ que haya ganado el sorteo entre los miembros de E.
// El sorteo es realizado cuando el ítem es intentado tomar por primera vez por alguno de los miembros de E.
// Solo participan del sorteo los miembros de E que esten en la misma zona que el PJ miembro de E que intenta tomar el ítem por primera vez.
// La zona esta determinada por el tipo de spawn del área. O sea que dos puntos estan en la misma zona si la propiedad de area 'RS_tipoSpawn_PN' es igual para las áreas de ambos puntos.
void CIB_Item_repartir( object item, object sujeto );
void CIB_Item_repartir( object item, object sujeto ) {
    SetLocalInt( item, CIB_estado_VN, CIB_estado_ESTA_RESERVADO_AUN_NO_ASIGNADO );
    object areaDondeEstaSujeto = GetArea( sujeto );
    string nombresMiembrosEquipoQueLoGano;
    object miembroEquipoIterado = GetFirstFactionMember( sujeto, TRUE );
    while( miembroEquipoIterado != OBJECT_INVALID ) {
        if( GetArea(miembroEquipoIterado) == areaDondeEstaSujeto )
            nombresMiembrosEquipoQueLoGano += GetName(miembroEquipoIterado)+CIB_DELIMITADOR_MIEMBROS;
        miembroEquipoIterado = GetNextFactionMember( sujeto, TRUE );
    }
    SetLocalString( item, CIB_Item_nombresMiemborsEquipoQueLoGano_VN, nombresMiembrosEquipoQueLoGano );
}


// funcion privada usada por 'CIB_adquirirItem(..)'
// Elige un PJ al azar de entre los que sus nombres estan en la lista 'nombresMiemborsEquipoQueLoGano', y que además esten en la misma zona que 'sujetoIntentaTomar'.
// Si el nombre de 'sujetoIntentaTomar' no esta en la lista 'nombresMiemborsEquipoQueLoGano', devuelve OBJECT_INVALID.
object CIB_Item_sortear( object item, string nombresMiemborsEquipoQueLoGano, object sujetoIntentaTomar );
object CIB_Item_sortear( object item, string nombresMiemborsEquipoQueLoGano, object sujetoIntentaTomar ) {
    // si quien intenta tomar el ítem no es miembro del grupo E, devolver OBJECT_INVALID para que el ítem siga sin estar sorteado/asignado hasta que un miembro de E lo intente tomar.
    if( FindSubString( nombresMiemborsEquipoQueLoGano, GetName(sujetoIntentaTomar) ) < 0 )
        return OBJECT_INVALID;

    // contar la cantidad de PJs miembros de E que esten en la misma zona que quien intenta tomar el ítem.
    string zonaDondeEstaSujetoIntentaTomar = RS_getTipoSpawn( GetArea(sujetoIntentaTomar) );
    int cantidadPjsElegibles = 0;
    object pjIterado = GetFirstPC();
    while( pjIterado != OBJECT_INVALID ) {
        if(
            FindSubString( nombresMiemborsEquipoQueLoGano, GetName(pjIterado) ) >= 0
            && RS_getTipoSpawn( GetArea(pjIterado) ) == zonaDondeEstaSujetoIntentaTomar
        )
            cantidadPjsElegibles += 1;
        pjIterado = GetNextPC();
    }

    // sortear el indice del PJ elegido
    int indicePjElegido = Random( cantidadPjsElegibles );

    // obtener el PJ elegido a partir del índice
    pjIterado = GetFirstPC();
    while( pjIterado != OBJECT_INVALID ) {
        if(
            FindSubString( nombresMiemborsEquipoQueLoGano, GetName(pjIterado) ) >= 0
            && RS_getTipoSpawn( GetArea(pjIterado) ) == zonaDondeEstaSujetoIntentaTomar
        ) {
            if( --indicePjElegido < 0 )
                return pjIterado;
       }
        pjIterado = GetNextPC();
    }

    return OBJECT_INVALID; // nunca se llega a esta linea. Esta para que el compilador no chille.
}



// funcion privada usada por CIB_distribuir(..)
// Cancela la reserva hecha en el item especificado
void CIB_cancelarReserva( object itemReservado );
void CIB_cancelarReserva( object itemReservado ) {
    int estado = GetLocalInt( itemReservado, CIB_estado_VN );
    if(
        estado == CIB_estado_ESTA_RESERVADO_AUN_NO_ASIGNADO ||
        estado == CIB_estado_ESTA_RESERVADO_Y_ASIGNADO
    ) {
        DeleteLocalInt( itemReservado, CIB_estado_VN );
        DeleteLocalObject( itemReservado, CIB_pjAsignado_VN );
    }
}

// funcion publica, ver declaracion
void CIB_distribuir( object item, float duracionReserva=120.0 ) {
    SetLocalInt( item, CIB_estado_VN, CIB_estado_ESTA_RESERVADO_AUN_NO_ASIGNADO );
    if( duracionReserva > 0.0 ) {
        DelayCommand( duracionReserva, CIB_cancelarReserva( item ) );
    }
}


// funcion privada
// Da el siguiente PJ al que le toca recibir un item en un party del cual 'pjMiembroParty' es el miembro que toma el item.
object CIB_getSiguientePjIterado( object pjMiembroParty );
object CIB_getSiguientePjIterado( object pjMiembroParty ) {

    // obtiene el lider del party (donde se mantendra el estado de la rotacion).
    object pjLiderParty = GetFactionLeader( pjMiembroParty );

    // obtiene la cantidad de PJs en el party que esten en el mismo area que pjMiembroParty
    int cantPjsEnParty = Party_getCantPjsMismaArea( pjLiderParty );

    // obtiene el indice del PJ iterado por rotacion.
    int pjIteradoIndice = GetLocalInt( pjLiderParty, CIB_pjIteradoIndice_VN ) + 1;
    if( pjIteradoIndice > cantPjsEnParty )
        pjIteradoIndice = 1;
    SetLocalInt( pjLiderParty, CIB_pjIteradoIndice_VN, pjIteradoIndice );

    // obtiene el PJ iterado
    object pjMiembroIterator = GetFirstFactionMember( pjLiderParty, TRUE );
    while( pjMiembroIterator != OBJECT_INVALID ) {
        if( GetArea(pjMiembroIterator) == GetArea( pjMiembroParty ) ) {
            if( --pjIteradoIndice == 0 )
                return pjMiembroIterator;
        }
        pjMiembroIterator = GetNextFactionMember( pjLiderParty, TRUE );
    }

    WriteTimestampedLogEntry( "CIB_getSiguientePjIterado: error, unreachable reached" );
    return pjLiderParty;
}


// funcion privada usada por CIB_onUnaquire()
// corrige posible burla al balance que se haya hecho sobre el ítem OBJECT_SELF aprovechando el bug del trueque (no se ejecuta el onAcquire al regresar un ítem puesto en la ventana del trueque), o el bug del ítem contenedor (no se ejecuta el onAcquire cuando el ítem esta contenido por un item contenedor).
void CIB_corregirPosibleBurlaAlBalance( float periodoMuestreo=CIB_CORREGIDOR_BURLA_BALANCE_PERIODO_MUESTREO_INICIAL );
void CIB_corregirPosibleBurlaAlBalance( float periodoMuestreo=CIB_CORREGIDOR_BURLA_BALANCE_PERIODO_MUESTREO_INICIAL ) {
    if( GetIsObjectValid( OBJECT_SELF ) ) { // creo que OBJECT_SELF es siempre válido, pero por las dudas
        object itemPossessor = GetItemPossessor( OBJECT_SELF );
        if( !GetIsObjectValid( itemPossessor ) && !GetIsObjectValid( GetArea(OBJECT_SELF) ) && periodoMuestreo < 600.0 )
            DelayCommand( periodoMuestreo, CIB_corregirPosibleBurlaAlBalance(periodoMuestreo*2.0) );
        else if (
            GetIsObjectValid( itemPossessor )
            && GetLocalInt( OBJECT_SELF, CIB_estado_VN ) == CIB_estado_POSEIDO
            && GetLocalString( OBJECT_SELF, CIB_nombrePropietario_VN ) != GetName( itemPossessor, TRUE )
        ) {
            CIB_intentarAdquirirItemAjeno( itemPossessor, OBJECT_SELF, OBJECT_INVALID );
        }
    }
}

// corrige cualquier burla al balance que se haya hecho, con todos los ítems poseidos por 'subject' exceptuando 'exceptedItem', aprovechando el bug del trueque: no se ejecuta el onAcquire al regresar un ítem puesto en la ventana del trueque.
// lo siguiente asegura que un PJ no tenga comom máximo un solo ítem que burle la balanza: el primero que mueva a de la ventana de trueque. Esto evita que se supere el límite máximo de desbalance.
void CIB_corregirTodosLosBalancesBurlados( object subject, object exceptedItem );
void CIB_corregirTodosLosBalancesBurlados( object subject, object exceptedItem ) {
    object itemIterator = GetFirstItemInInventory( subject );
    while( itemIterator != OBJECT_INVALID ) {
        int estado = GetLocalInt( itemIterator, CIB_estado_VN );
        if( itemIterator != exceptedItem && estado == CIB_estado_POSEIDO && GetLocalString( itemIterator, CIB_nombrePropietario_VN ) != GetName( subject, TRUE ) ) {
            CIB_intentarAdquirirItemAjeno( subject, itemIterator, OBJECT_INVALID );
        }
        itemIterator = GetNextItemInInventory( subject );
    }
    int slotIdIterator = NUM_INVENTORY_SLOTS;
    while( --slotIdIterator >= 0 ) {
        itemIterator = GetItemInSlot(slotIdIterator, subject);
        int estado = GetLocalInt( itemIterator, CIB_estado_VN );
        if( estado == CIB_estado_POSEIDO && GetLocalString( itemIterator, CIB_nombrePropietario_VN ) != GetName( subject, TRUE ) ) {
            CIB_intentarAdquirirItemAjeno( subject, itemIterator, OBJECT_INVALID );
        }
    }
}


// funcion privada
// Resta el valor del item a la balanza de intercambio del antiguo propietario (la suma a la
// balanza de intercambio del nuevo propietario ya se realizo apenas lo adquirio el item),
// y pone el estado del item en poseido por el nuevo porpietario.
// Nota: se asume que item y receptor son válidos
void CIB_completarTransicionPropietario( object item, object receptor, int hayQueExportarPjs=FALSE );
void CIB_completarTransicionPropietario( object item, object receptor, int hayQueExportarPjs=FALSE ) {
    // restarle el valor del item a la balanza de intercambio del antiguo propietario. La suma a la balanza de intercambio del nuevo propietario ya se realizo apenas lo adquirio el item.
    struct CIB_Balance balance = CIB_getBalance( GetLocalString( item, CIB_nombrePropietario_VN ) );
    CIB_registrarPerdida( balance, CIB_getItemGenuineGoldValue( item ) );

    // poner el estado del item en poseido por el nuevo porpietario
    SetLocalString( item, CIB_nombrePropietario_VN, GetName( receptor, TRUE ) );
    SetLocalObject( item, CIB_refPropietario_VN, receptor );
    SetLocalInt( item, CIB_estado_VN, CIB_estado_POSEIDO );

    // guardar los personajes involucrados en el trueque
    if( hayQueExportarPjs ) {
        SetLocalInt( receptor, "isExportPending", TRUE ); // Hace que se exporte el PJ en el proximo heartbeat.
        object dador = GetLocalObject( item, CIB_refPropietario_VN );
        SetLocalInt( dador, "isExportPending", TRUE );  // Hace que se exporte el PJ en el proximo heartbeat.
    }
}


// funcion publica
// Esta funcion solo hace efecto si se cumple que:
// 1) 'sujeto' e 'item' son validos.
// 2) 'sujeto' es poseedor de 'item'.
// 3) 'sujeto' no es aún propietario de 'item'. Esto sucede cuando 'item' fue recibido de otro PJ hace menos de un minuto.
// De cumplirse, lo que hace es restar el valor del item a la balanza de intercambio del antiguo
// propietario (la suma a la balanza de intercambio de 'sujeto' ya se realizo apenas adquirio 'item' ),
// y pone el estado del item en poseido por el nuevo porpietario.
void CIB_completarPosibleTransicionPropietario( object item, object sujeto, int hayQueExportarPjs=FALSE );
void CIB_completarPosibleTransicionPropietario( object item, object sujeto, int hayQueExportarPjs=FALSE ) {
    if(
        GetIsObjectValid( item )
        && GetIsObjectValid( sujeto )
        && GetItemPossessor( item ) == sujeto
        && GetLocalInt( item, CIB_estado_VN ) == CIB_estado_TRANSICION_PROPIETARIO
    )
        CIB_completarTransicionPropietario( item, sujeto, hayQueExportarPjs );
}

// funcion privada
// Este hilo de ejecucion es iniciado por CIB_onAcquire(..) cuando un PJ adquiere
// un item cuyo propietario es otro PJ. Su objetivo es dar tiempo al PJ a abandonar
// el item antes de que se registre la adquisicion a su balanza de intercambio.
void CIB_hiloTransicionPropietario( object acquiredItem, int temporizador ) {
    // mientras el item siga en posesion del Pj que al adquirir el item inicio este hilo de transicion...
    if( GetItemPossessor( acquiredItem ) == OBJECT_SELF && GetLocalInt( acquiredItem, CIB_estado_VN ) == CIB_estado_TRANSICION_PROPIETARIO ) { // Se revisa que aún siga en estado CIB_estado_TRANSICION_PROPIETARIO, porque es posible que la trancicion sea completada llamando a 'CIB_completarTransicionPropietario(..)' antes de que el tiempo transcurra.

        // si transcurre el tiempo establecido para convertirse en nuevo propietario
        if( --temporizador == 0 ) {

            CIB_completarTransicionPropietario( acquiredItem, OBJECT_SELF, TRUE );

            // mostrar mensaje notificando al nuevo propietario que ya es propietario del item.
            FloatingTextStringOnCreature( "Ya eres el nuevo propietario de el/la "+GetName(acquiredItem), OBJECT_SELF, FALSE );
        }

        // si aun falta para convertirse en el nuevo porpietario, programar el sieguiente muestreo
        else
            DelayCommand( CIB_TRANSICION_PROPIETARIO_PERIODO_MUESTREO, CIB_hiloTransicionPropietario( acquiredItem, temporizador ) );
    }
}


// Intenta trasferir 'item' de 'OBJECT_SELF' a 'destinatario'. Si fracaza despues de algunos reintentos, los suelta (a 'item' ).
void CIB_siEsPosibleTransferirItemSinoSoltarlo( object item, object destinatario, string cheatHandler="", int reintentos=5 );
void CIB_siEsPosibleTransferirItemSinoSoltarlo( object item, object destinatario, string cheatHandler="", int reintentos=5 ) {
    if( GetIsObjectValid(item) && GetItemPossessor(item) == OBJECT_SELF ) {
        if( GetIsObjectValid(destinatario) && reintentos > 0 ) {
            ActionGiveItem( item, destinatario );
            DelayCommand( 2.0, CIB_siEsPosibleTransferirItemSinoSoltarlo( item, destinatario, cheatHandler, reintentos-1 ) );
        }
        else
            Item_tirar( item, OBJECT_SELF, cheatHandler );
    }
}

// funcion privada
// Intenta devolver el ítem a su origen. Si el origen era un contenedor, intenta regresarlo ahí.
// Y si no es un contenedor o se falló el intento de regresarlo al contenedor de origen, se lo suela al piso.
void CIB_regresarItemAOrigen( object acquiredFrom, object acquiredBy, object acquiredItem );
void CIB_regresarItemAOrigen( object acquiredFrom, object acquiredBy, object acquiredItem ) {
    // si el ítem se obtuvo de un contenedor, regresarlo al contenedor
    if( GetIsObjectValid(acquiredFrom) && acquiredFrom != acquiredBy && GetHasInventory( acquiredFrom ) ) {
        AssignCommand( acquiredBy, CIB_siEsPosibleTransferirItemSinoSoltarlo( acquiredItem, acquiredFrom, CIB_cheatHandler ) );
    }
    // si no se obtuvo de un contendor, tirarlo en el suelo
    else {
        Item_tirar( acquiredItem, acquiredBy, CIB_cheatHandler );
    }
}


// funcion privada
void CIB_ponerMarcaPropietarioYMostrarMensajeAdquisicion( object acquiredBy, object acquiredItem );
void CIB_ponerMarcaPropietarioYMostrarMensajeAdquisicion( object acquiredBy, object acquiredItem ) {
    SetLocalInt( acquiredItem, CIB_estado_VN, CIB_estado_POSEIDO );
    SetLocalString( acquiredItem, CIB_nombrePropietario_VN, GetName(acquiredBy, TRUE) );
    SetLocalObject( acquiredItem, CIB_refPropietario_VN, acquiredBy );
    FloatingTextStringOnCreature( GetName(acquiredBy)+" toma un/a "+GetName(acquiredItem), acquiredBy, TRUE );
}

// funcion privada
void CIB_intentarAdquirirItemAjeno( object acquiredBy, object acquiredItem, object acquiredFrom ) {
    int balancePorcentualReceptor;
    // si el balance del PJ despues de adquirido el item NO supera el desbalance maximo
    struct CIB_Balance balanceReceptor = CIB_getBalance( GetName( acquiredBy, TRUE ) );
    int itemValue = CIB_getItemGenuineGoldValue( acquiredItem );
    int nivelAcquiredBy = GetHitDice( acquiredBy );
    if( CIB_examinarPosibilidadAdquirir( balanceReceptor, itemValue, nivelAcquiredBy ) ) {
        // registrar la adquisicion en el balance de quien adquiere el item
        int balanceAbsoluto = CIB_registrarAdquisicion( balanceReceptor, itemValue );

        // calcular el balance porcentual actual
        balancePorcentualReceptor = CIB_getBalancePorcentual( balanceAbsoluto, nivelAcquiredBy );

        // si el ítem es consumible, quien lo recibe pasa a ser el propietario inmediatamente
        if( CIB_esItemConsumible( acquiredItem ) ) {
            // restarle el valor del item a la balanza de intercambio del antiguo propietario. La suma a la balanza de intercambio del nuevo propietario ya se realizo apenas lo adquirio el item.
            struct CIB_Balance balanceDador = CIB_getBalance( GetLocalString( acquiredItem, CIB_nombrePropietario_VN ) );
            CIB_registrarPerdida( balanceDador, itemValue );

            // dejar que lo tome libremente
            CIB_ponerMarcaPropietarioYMostrarMensajeAdquisicion( acquiredBy, acquiredItem );

            // guardar los personajes involucrados en el trueque
            SetLocalInt( acquiredBy, "isExportPending", TRUE ); // Hace que se exporte el PJ receptor en el proximo heartbeat.
            object dador = GetLocalObject( acquiredItem, CIB_refPropietario_VN );
            SetLocalInt( dador, "isExportPending", TRUE );  // Hace que se exporte el PJ dador en el proximo heartbeat.
        }
        // si el ítem no es consumible, quien lo recibe tiene un minuto para soltarlo antes de adquirirlo
        else {
            // cambiar el estado a adquirido no definitivo, cosa que le deja tomar el item permitiendole cancelar el aumento de su balance si abandona el item antes de transcurrido un lapzo de tiempo.
            SetLocalInt( acquiredItem, CIB_estado_VN, CIB_estado_TRANSICION_PROPIETARIO );

            // Evita que pueda ser vendido. Ademas de esta es necesario que las tiendas no quiten esta marca cuando el item esta en estado CIB_estado_TRANSICION_PROPIETARIO. Ver 'CIB_onItemArrivesStore()'
            SetStolenFlag( acquiredItem, TRUE );

            // mostrar mensaje
            FloatingTextStringOnCreature( "Este/a "+GetName(acquiredItem)+" no te pertenecía.\nSi lo conservas por un minuto, serás su nuevo propietario.\nTu balanza de intercambio aumentó al "+IntToString(balancePorcentualReceptor)+"%", acquiredBy, FALSE );

            // programar para que pasado un lapzo la adquisicion se haga definitiva y se registre la perdida en el balance del antiguo propietario
            AssignCommand( acquiredBy, DelayCommand( CIB_TRANSICION_PROPIETARIO_PERIODO_MUESTREO, CIB_hiloTransicionPropietario( acquiredItem, CIB_TRANSICION_PROPIETARIO_CANTIDAD_MUESTREOS ) ) );
        }
    }
    // si el balance del PJ despues de adquirido el item supera el desbalance maximo
    else {
        // poner el estado del item a poseido por el antiguo propietario
        SetLocalInt( acquiredItem, CIB_estado_VN, CIB_estado_POSEIDO );

        // regresar el ítem al sitio de donde provino
        CIB_regresarItemAOrigen( acquiredFrom, acquiredBy, acquiredItem );

        // mostrar mensaje
        balancePorcentualReceptor = CIB_getBalancePorcentual( balanceReceptor.recibido - balanceReceptor.dado, nivelAcquiredBy );
        FloatingTextStringOnCreature( "Tu balanza intercambio esta muy elevada para recibir este ítem.\nValor actual: "+IntToString(balancePorcentualReceptor)+"%", acquiredBy, FALSE );
    }
    return;
}


// funcion privada de CIB_onAcquire(...), llamada cuando un PC o DM adquiere un item
void CIB_adquirirItem( object acquiredItem, object acquiredFrom, object acquiredBy ) {
    int estadoViejo = GetLocalInt( acquiredItem, CIB_estado_VN );

    // si el item se obtiene de una tienda, resetear las variables que quedan en el item cuando tuvo un propietario PJ. Esto se hace aqui porque las tiendas no disparan evento cuando compran un item.
    if( GetObjectType( acquiredFrom ) == OBJECT_TYPE_STORE ) {
        DeleteLocalString( acquiredItem, CIB_nombrePropietario_VN );
        DeleteLocalObject( acquiredItem, CIB_refPropietario_VN );
        estadoViejo = CIB_estado_LIBRE;
    }

    // si quien toma el item es un DM
    if( GetIsDM( acquiredBy ) || GetIsDMPossessed( acquiredBy ) ) {
        // si el item tiene propietario, decirle al DM
        if( estadoViejo == CIB_estado_POSEIDO )
            FloatingTextStringOnCreature( "Este/a "+GetName(acquiredItem)+" le pertenece a " + GetLocalString( acquiredItem, CIB_nombrePropietario_VN ), acquiredBy, FALSE );

        // si el item es tomado de la mochila de un PJ (asumiendo que el onUnAcquire del PJ no es llamado cuando un DM le quita un ítem) que no es aun el propietario del item (no paso un minuto desde que lo tomo y era de otro PJ anteriormente), y el propietario es un PJ
        if( estadoViejo == CIB_estado_TRANSICION_PROPIETARIO && GetIsPC(acquiredFrom) && !( GetIsDM(acquiredFrom) || GetIsDMPossessed(acquiredFrom) ) ) {
            // completar la transicion para que baje la balanza del antiguo propietario y el PJ de quien se quito el item sea el nuevo propietario (aunque el item ahora lo tiene el DM).
            CIB_completarTransicionPropietario( acquiredItem, acquiredBy );
        }
    }

    // en cambio, si quien adquiere el item es un PJ
    else {
        object pjAsignado;
//        int balanzaIntercambioPorcentual;
//        int estadoNuevo = estadoViejo;

        // si el ítem no esta recervado ni tiene propietario, hacer a 'acquiredBy' su propietario de forma inmediata.
        if( estadoViejo == CIB_estado_LIBRE ) {
            CIB_ponerMarcaPropietarioYMostrarMensajeAdquisicion( acquiredBy, acquiredItem );
        }
        // si el item esta reservado pero aun no fue asignado el beneficiario (es la primera vez que es un PJ intenta adquirirlo)
        else if( estadoViejo == CIB_estado_ESTA_RESERVADO_AUN_NO_ASIGNADO ) {

            // averiguar a cual PJ miembro del party le toca el item
            string nombresMiemborsEquipoQueLoGano = GetLocalString( acquiredItem, CIB_Item_nombresMiemborsEquipoQueLoGano_VN );
            if( nombresMiemborsEquipoQueLoGano == "" ) {
                pjAsignado = CIB_getSiguientePjIterado( acquiredBy );
            }
            else {
                pjAsignado = CIB_Item_sortear( acquiredItem, nombresMiemborsEquipoQueLoGano, acquiredBy );
            }

            // si el PJ al que le toca el item adquirido es el mismo PJ que lo esta adquiriendo, cambiar el estado del ítem a poseido por 'acquiredBy' y mostrar mensaje de acquisición
            if( pjAsignado == acquiredBy ) {
                CIB_ponerMarcaPropietarioYMostrarMensajeAdquisicion( acquiredBy, acquiredItem );
            }
            // si el PJ al que le toca el item adquirido NO es el mismo PJ que lo esta adquiriendo,
            // o si el ítem esta reservado y fue tomado por un PJ que no es miembro del equipo que lo ganó
            else {
                // si ya se determinó al beneficiado, cambiar el estado del ítem a CIB_estado_ESTA_RESERVADO_Y_ASIGNADO y etiquetarlo con una referencia al beneficiado.
                if( pjAsignado != OBJECT_INVALID ) {
                    SetLocalInt( acquiredItem, CIB_estado_VN, CIB_estado_ESTA_RESERVADO_Y_ASIGNADO );
                    SetLocalObject( acquiredItem, CIB_pjAsignado_VN, pjAsignado );
                    FloatingTextStringOnCreature( "Este/a "+GetName(acquiredItem)+" le corresponde a "+GetName(pjAsignado), acquiredBy, TRUE );
                }
                // si no se determinó al beneficiado es porque el ítem esta reservado y fue tomado por un PJ que no es miembro del equipo que lo ganó
                else {
                    FloatingTextStringOnCreature( "Este/a "+GetName(acquiredItem)+" esta recervado/a para el equipo que lo consiguió.", acquiredBy, FALSE );
                    // el estado del ítem permanece como estaba (en estado CIB_estado_ESTA_RESERVADO_AUN_NO_ASIGNADO)
                }
                // regresar el ítem a su origen
                CIB_regresarItemAOrigen( acquiredFrom, acquiredBy, acquiredItem );
            }
        }
        // si el item esta reservado y su beneficiario ya fue asignado
        else if( estadoViejo == CIB_estado_ESTA_RESERVADO_Y_ASIGNADO ) {

            // obtener el pj al que le fue asignado el beneficio de la reserva
            pjAsignado = GetLocalObject( acquiredItem, CIB_pjAsignado_VN );

            // si el PJ que intenta adquirir el item SI es el PJ al que le fue asignada la reserva, quitarle el estado de reservado y dejar que el PJ adquiera el item.
            if( pjAsignado == acquiredBy ) {
                DeleteLocalObject( acquiredItem, CIB_pjAsignado_VN );
                CIB_ponerMarcaPropietarioYMostrarMensajeAdquisicion( acquiredBy, acquiredItem );
            }
            // sino, regresar el ítem a su origen
            else {
                FloatingTextStringOnCreature( "Este/a "+GetName(acquiredItem)+" le corresponde a "+GetName(pjAsignado), acquiredBy, TRUE );
                CIB_regresarItemAOrigen( acquiredFrom, acquiredBy, acquiredItem );
                // el estado del ítem permanece como estaba (en estado CIB_estado_ESTA_RESERVADO_Y_ASIGNADO)
            }

        }
        // si el item pertenecia a un PJ
        else if( estadoViejo == CIB_estado_POSEIDO || estadoViejo == CIB_estado_TRANSICION_PROPIETARIO ) {

            // si el PJ que toma el item es el mismo PJ al que le pertenecia
            if( GetName( acquiredBy, TRUE ) == GetLocalString( acquiredItem, CIB_nombrePropietario_VN ) ) {
                // dejar que lo tome libremente
                CIB_ponerMarcaPropietarioYMostrarMensajeAdquisicion( acquiredBy, acquiredItem );
            }
            // si el PJ que toma el item NO es el mismo PJ al que le pertenecia
            else {
                // corregir todos los balances burlados por el receptor aprovechando el bug del trueque:
                CIB_corregirTodosLosBalancesBurlados( acquiredBy, acquiredItem );
                CIB_intentarAdquirirItemAjeno( acquiredBy, acquiredItem, acquiredFrom );
            }
        }
        else
            WriteTimestampedLogEntry( "CIB_onAcquire: assertion error 1, estadoViejo="+IntToString(estadoViejo)+", item="+GetName(acquiredItem)+", PJ="+GetName(acquiredBy, TRUE) );

/*
        // PASO 2: trata el estado de posesion del item
        // si el item adquirido estaba o paso a estar libre, dejar que el PJ lo adquiera
        if( estadoNuevo == CIB_estado_LIBRE ) {
            SetLocalString( acquiredItem, CIB_nombrePropietario_VN, GetName(acquiredBy, TRUE) );
            SetLocalObject( acquiredItem, CIB_refPropietario_VN, acquiredBy );
            estadoNuevo = CIB_estado_POSEIDO;
            if( estadoViejo != CIB_estado_LIBRE )
                FloatingTextStringOnCreature( GetName(acquiredBy)+" toma un/a "+GetName(acquiredItem), acquiredBy, TRUE );
        }
        else if( estadoNuevo == CIB_estado_TRANSICION_PROPIETARIO )
            FloatingTextStringOnCreature( "Este/a "+GetName(acquiredItem)+" no te pertenecía.\nSi lo conservas por un minuto, serás su nuevo propietario.\nTu balanza de intercambio aumentó al "+IntToString(balanzaIntercambioPorcentual)+"%", acquiredBy, FALSE );

        // si el item esta recervado, regresarlo al sitio de donde fue adquirido
        else if( estadoNuevo == CIB_estado_ESTA_RESERVADO_Y_ASIGNADO ) {
            FloatingTextStringOnCreature( "Este/a "+GetName(acquiredItem)+" le corresponde a "+GetName(pjAsignado), acquiredBy, TRUE );
            if( GetHasInventory( acquiredFrom ) )
                AssignCommand( acquiredBy, ActionGiveItem( acquiredItem, acquiredFrom ) );
            else
                Item_tirar( acquiredItem, acquiredBy, CIB_cheatHandler );
        }
        // si el ítem recibido seguirá siendo propiedad del antiguo propietario (sucede solo cuando la balanza del receptor superaría el límite), devolverlo
        else if( estadoNuevo == CIB_estado_POSEIDO ) {
            string debug;
            // si el ítem se obtuvo de un contenedor o de la ventana de trueque, regresarlo al contenedor o PJ con el que se hacia el trueque. Recordar que al regresar al inventario un ítem puesto en la ventana del trueque, no se ejecuta el onAcquire (si, un bug de bioware).
            if( GetIsObjectValid(acquiredFrom) && acquiredFrom != acquiredBy && GetHasInventory( acquiredFrom ) ) {
                AssignCommand( acquiredBy, CIB_siEsPosibleTransferirItemSinoSoltarlo( acquiredItem, acquiredFrom, CIB_cheatHandler ) );
                debug = "1";
            }
            // si no se obtuvo de un contendor...
            else {
                Item_tirar( acquiredItem, acquiredBy, CIB_cheatHandler );
                debug = "3 - rp="+GetName(GetLocalObject( acquiredItem, CIB_refPropietario_VN ));
            }

            FloatingTextStringOnCreature( "Tu balanza intercambio esta muy elevada para recibir este ítem.\nValor actual: "+IntToString(balanzaIntercambioPorcentual)+"%", acquiredBy, FALSE );
            SendMessageToPC( acquiredBy, "//##debug="+debug+", af="+GetName(acquiredFrom) );
        }
        // si el ítem esta reservado y fue tomado por un PJ que no es miembro del equipo que lo ganó, volverlo donde estaba
        else if( estadoNuevo == CIB_estado_ESTA_RESERVADO_AUN_NO_ASIGNADO ) {
            // si el ítem se obtuvo de un contenedor, regresarlo al contenedor
            if( GetIsObjectValid(acquiredFrom) && acquiredFrom != acquiredBy && GetHasInventory( acquiredFrom ) ) {
                AssignCommand( acquiredBy, CIB_siEsPosibleTransferirItemSinoSoltarlo( acquiredItem, acquiredFrom, CIB_cheatHandler ) );
            }
            // si no se obtuvo de un contendor, tirarlo en el suelo
            else {
                Item_tirar( acquiredItem, acquiredBy, CIB_cheatHandler );
            }
            FloatingTextStringOnCreature( "Este/a "+GetName(acquiredItem)+" esta recervado/a para el equipo que lo consiguió.", acquiredBy, FALSE );
        }
        else
            WriteTimestampedLogEntry( "CIB_onAcquire: assertion error 2, estadoNuevo="+IntToString(estadoNuevo)+", item="+GetName(acquiredItem)+", PJ="+GetName(acquiredBy, TRUE) );

        // actualizar el estado del item
        SetLocalInt( acquiredItem, CIB_estado_VN, estadoNuevo );

        // Si quien adquiere el item no es el propietario, evitar que lo pueda vender si el poseedor esta en una tienda. Si el poseedor no esta en una tienda, el estado de StolenFlag es indistinto porque es modificado cuanso se entra a una tienda adepta a Store. Ver 'CIB_onItemEnterStore(..)'
        if( estadoNuevo == CIB_estado_TRANSICION_PROPIETARIO )
            SetStolenFlag( acquiredItem, TRUE );
*/
    }
}


// funcion publica, ver declaracion
void CIB_onAcquire( object acquiredItem, int acquiredAmount, object acquiredFrom, object acquiredBy ) {

    // si quien adquiere es un PJ, o DM
    if( GetIsPC( acquiredBy ) ) {

        // si lo adquirido es un item
        if( GetIsObjectValid( acquiredItem ) ) {

            // si lo adquirido es una bolsa de oro
            if( GetResRef(acquiredItem) == CIB_Oro_item_RR )
                CIB_Oro_adquirir( acquiredItem, acquiredBy );
            // si lo adquirido no es una bolsa de oro y ya se ejecutó el onClientEnter
            else if( Mod_isPcInitialized( acquiredBy ) )
                CIB_adquirirItem( acquiredItem, acquiredFrom, acquiredBy );

        }
        // si no es un item, es oro nativo del motor. Asi que descartarlo.
        else {
            FloatingTextStringOnCreature( "Advertencia: El oro nativo del juego no es válido. Use la herramienta para racionar el oro.", acquiredBy, FALSE );
            AssignCommand( acquiredBy, TakeGoldFromCreature( acquiredAmount, acquiredBy, TRUE ) );
        }

    } // end of else if( GetIsPC( acquiredBy ) )
}


//funcion publica, ver declaracion
void CIB_onUnaquire( object lostItem, object lostBy ) {
    if( GetIsPC(lostBy) && !GetIsDM(lostBy) && !GetIsDMPossessed(lostBy) && GetIsObjectValid(lostItem) ) {

        int estado = GetLocalInt( lostItem, CIB_estado_VN );
//        SendMessageToPC( GetFirstPC(), "CIB_onUnaquire: estado="+IntToString( estado ) );
        if( estado == CIB_estado_TRANSICION_PROPIETARIO ) {
            // volver el estado del item al que tenia antes de haber sido tomado
            SetLocalInt( lostItem, CIB_estado_VN, CIB_estado_POSEIDO );

            // y regresar la balanza de intercambio a su estado anterior (antes de adquirir el item)
            struct CIB_Balance balance = CIB_getBalance( GetName( lostBy, TRUE ) );
            int balanceAbsoluto = CIB_registrarAdquisicion( balance, -CIB_getItemGenuineGoldValue( lostItem ) );

            // mostrar mensaje informando el estado de la balanza de intercambio actual al PJ que cancelo la adquisicion
            int balanzaIntercambioPorcentual = CIB_getBalancePorcentual( balanceAbsoluto, GetHitDice( lostBy ) );
            AssignCommand( lostBy, FloatingTextStringOnCreature( "Has abandonado el ítem antes de transcurrido el lapso para convertirte en su propietario.\nTu balanza de intercambio regresa al valor anterior a tomar el ítem.\nValor actual: "+IntToString(balanzaIntercambioPorcentual), OBJECT_SELF, FALSE ) );

            // si el ítem se deposito en la ventana de trade, o esta dentro de un contenedor, programar correccion a posible burla del balance
            if( !GetIsObjectValid( GetItemPossessor( lostItem ) ) && !GetIsObjectValid( GetArea(lostItem) ) ) {
                AssignCommand( lostItem, DelayCommand(
                    CIB_CORREGIDOR_BURLA_BALANCE_PERIODO_MUESTREO_INICIAL
                    , CIB_corregirPosibleBurlaAlBalance()
                ) );
            }
        }
        else if( estado = CIB_estado_LIBRE ) {
            WriteTimestampedLogEntry( "CIB_onUnaquire: assertion error, item="+GetName(lostItem)+", PJ="+GetName(lostBy, TRUE) );
            SetLocalInt( lostItem, CIB_estado_VN, CIB_estado_POSEIDO );
            SetLocalString( lostItem, CIB_nombrePropietario_VN, GetName( lostBy, TRUE ) );
            SetLocalObject( lostItem, CIB_refPropietario_VN, lostBy );
        }
    }
}


// funcion public, ver declaracion
void CIB_onClientEnter( object client ) {
    if( GetIsDM( client ) )
        return;
    object itemIterator = GetFirstItemInInventory( client );
    while( itemIterator != OBJECT_INVALID ) {
        SetLocalInt( itemIterator, CIB_estado_VN, CIB_estado_POSEIDO );
        SetLocalString( itemIterator, CIB_nombrePropietario_VN, GetName( client, TRUE ) );
        SetLocalObject( itemIterator, CIB_refPropietario_VN, client );
        itemIterator = GetNextItemInInventory( client );
    }

    int slotIdIterator = NUM_INVENTORY_SLOTS;
    while( --slotIdIterator >= 0 ) {
        itemIterator = GetItemInSlot(slotIdIterator, client );
        SetLocalInt( itemIterator, CIB_estado_VN, CIB_estado_POSEIDO );
        SetLocalString( itemIterator, CIB_nombrePropietario_VN, GetName( client, TRUE ) );
        SetLocalObject( itemIterator, CIB_refPropietario_VN, client );
    }
}


// funcion privada
// Ajusta los balances del receptor y dador de un item que este poseido por un PJ distinto del que la marca del ítem indique. Esto puede suceder gracias a un bug de bioware: al poner un item en la ventana de trade se ejecuta el onUnaquire, pero no se ejecuta el onAcquire cuando se lo regresa al inventario. Esto hace posible que un PJ tenga en su inventario items que le pertenecen a otros PJs.
// Usada en los workarround del bug de bioware mencionado
// Se asume que (1) es ejecutado durante el onClientLeave de 'receptor' (2) 'receptor' es válido, (3) receptor posee a 'item', (4) 'item' esta en estado CIB_estado_POSEIDO, y (5) 'receptor' no es propietario de 'item' ( GetName(receptor)!= GetLocalString( item, CIB_nombrePropietario_VN ) )
void CIB_corregirBalanceBurlado( object receptor, object item );
void CIB_corregirBalanceBurlado( object receptor, object item ) {
    int itemValue = CIB_getItemGenuineGoldValue( item );

    // registrar la adquisicion en el balance de quien adquiere el item
    struct CIB_Balance balanceReceptor = CIB_getBalance( GetName( receptor, TRUE ) );
    CIB_registrarAdquisicion( balanceReceptor, itemValue );

    // registrar la perdida en el balance de quien pierdió el ítem.
    struct CIB_Balance balanceDador = CIB_getBalance( GetLocalString( item, CIB_nombrePropietario_VN ) );
    CIB_registrarPerdida( balanceDador, itemValue );

    // guardar en el vault al personaje dador
    object dador = GetLocalObject( item, CIB_refPropietario_VN );
    SetLocalInt( dador, "isExportPending", TRUE );  // Hace que se exporte el PJ dador en el proximo heartbeat.

    // no vale la pena actualizar las marcas en el ítem porque no se guardan las modificaciones hechas en el onClientLeave
}


//funcion publica, ver declaracoin
void CIB_onClientLeave( object client ) {
    if( GetIsDM( client ) )
        return;

    object itemIterator = GetFirstItemInInventory( client );
    while( itemIterator != OBJECT_INVALID ) {
        int estado = GetLocalInt( itemIterator, CIB_estado_VN );
        if( estado == CIB_estado_TRANSICION_PROPIETARIO )
            CIB_completarTransicionPropietario( itemIterator, client );
        // este "else if" es necesarios gracias a un bug de bioware: al poner un item en la ventana de trade se ejecuta el onUnaquire, pero no se ejecuta el onAcquire cuando se lo regresa al inventario. Esto hace posible que un PJ tenga en su inventario items que le pertenecen a otros PJs.
        else if( estado == CIB_estado_POSEIDO && GetLocalString( itemIterator, CIB_nombrePropietario_VN ) != GetName( client, TRUE ) )
            CIB_corregirBalanceBurlado( client, itemIterator );
        itemIterator = GetNextItemInInventory( client );
    }

    int slotIdIterator = NUM_INVENTORY_SLOTS;
    while( --slotIdIterator >= 0 ) {
        itemIterator = GetItemInSlot(slotIdIterator, client );
        int estado = GetLocalInt( itemIterator, CIB_estado_VN );
        if( estado == CIB_estado_TRANSICION_PROPIETARIO )
            CIB_completarTransicionPropietario( GetItemInSlot(slotIdIterator), client );
        // este "else if" es necesarios gracias a un bug de bioware: al poner un item en la ventana de trade se ejecuta el onUnaquire, pero no se ejecuta el onAcquire cuando se lo regresa al inventario. Esto hace posible que un PJ tenga en su inventario items que le pertenecen a otros PJs.
        else if( estado == CIB_estado_POSEIDO && GetLocalString( itemIterator, CIB_nombrePropietario_VN ) != GetName( client, TRUE ) )
            CIB_corregirBalanceBurlado( client, itemIterator );
    }
}


//funcion publica, ver declaracion
struct Store_PermisoVenta CIB_onItemArrivesStore( object item, object cliente ) {
    struct Store_PermisoVenta permiso;
    permiso.prohibido = GetLocalInt( item, CIB_estado_VN ) == CIB_estado_TRANSICION_PROPIETARIO;
    return permiso;
}


// funcion publica, ver declaracion
void CIB_transferirItemAContenedor( object item, object contenedor, int nuevoEstado ) {
    if(
        !GetIsObjectValid( contenedor ) // toda rutina insistidora de una accion debe renunciar si se hace imposible la accion a realizar
        || GetIsPC( contenedor ) // el contenedor no debe estar controlado por el CIB
    )
        return;

    object itemPossessor = GetItemPossessor( item );
    if( itemPossessor == OBJECT_SELF ) {
        // si OBJECT_SELF no es aún el propietario del item a transferir, hacer que lo sea.
        if( GetLocalInt( item, CIB_estado_VN ) == CIB_estado_TRANSICION_PROPIETARIO )
            CIB_completarTransicionPropietario( item, OBJECT_SELF );
        // realizar la transferencia, y asegurar que se realice.
        ActionGiveItem( item, contenedor );
        DelayCommand( 1.0, CIB_transferirItemAContenedor( item, contenedor, nuevoEstado ) );
    } else {
        // notar que para que para cuando se ejecute lo siguiente, ya se ejecutaron el onUnequip y onUnacquire en OBJECT_SELF sobre 'item'
        if( nuevoEstado != CIB_estado_POSEIDO ) {
            DeleteLocalString( item, CIB_nombrePropietario_VN );
            DeleteLocalObject( item, CIB_refPropietario_VN );
        }
        SetLocalInt( item, CIB_estado_VN, nuevoEstado );
    }
}


// Hace que 'nuevoPropietario' se al nuevo propietario de un 'item' no cargado por un PJ.
// Si 'item' ya tenia un antiguo propietario, las balanzas del nuevo y del viejo
// propietarios se ajustan.
// ADVERTENCIA: 'nuevoPropietario' debe ser un PJ, e 'item' no debe estar en
// posesion de ningún PJ ( GetIsPC(GetItemPosseessor(item)) tiene que ser falso ).
void CIB_asignarPropietario( object item, object nuevoPropietario );
void CIB_asignarPropietario( object item, object nuevoPropietario ) {
    if( !GetIsPC( nuevoPropietario ) ) return;

    string nuevoPropietarioNombre = GetName(nuevoPropietario, TRUE);
    // si el item tiene un propietario y no es 'nuevoPropietario', ajustar las balanzas.
    if( GetLocalInt( item, CIB_estado_VN ) == CIB_estado_POSEIDO ) {
        string antiguoPropietarioNombre = GetLocalString( item, CIB_nombrePropietario_VN );
        if( nuevoPropietarioNombre != antiguoPropietarioNombre ) {
            int itemValor = CIB_getItemGenuineGoldValue( item );

            struct CIB_Balance nuevoPropietarioBalance = CIB_getBalance( nuevoPropietarioNombre );
            CIB_registrarAdquisicion( nuevoPropietarioBalance, itemValor );

            struct CIB_Balance antiguoPropietarioBalance = CIB_getBalance( antiguoPropietarioNombre );
            CIB_registrarPerdida( antiguoPropietarioBalance, itemValor );
        }
    }
    SetLocalInt( item, CIB_estado_VN, CIB_estado_POSEIDO );
    SetLocalString( item, CIB_nombrePropietario_VN, nuevoPropietarioNombre );
    SetLocalObject( item, CIB_refPropietario_VN, nuevoPropietario );
}



