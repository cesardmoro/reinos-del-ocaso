/**************************** class Carreta - implementacion *******************
Carreta - include
Author: Inquisidor
Version: 0.1
Descripcion: define una carreta. Sus responsabilidades son: conocer las
estaciones que recorre, presio y duracion de los viajes y descansos.
*******************************************************************************/
#include "Carreta_itf"
#include "RdO_races_itf"

// Traslada el pasajero especificado de donde este, al area interior de esta carreta.
void Carreta_cargarPasajero( object this, object pasajero );
void Carreta_cargarPasajero( object this, object pasajero ) {
    object pasajeroWaypoint = GetWaypointByTag( GetLocalString( this, Carreta_pasajeroWaypointTag_LN ) );
    if( pasajeroWaypoint != OBJECT_INVALID ) {
        AssignCommand( pasajero, ActionJumpToObject( pasajeroWaypoint ) );
    } else {
        PrintString( "Carreta_cargarPasajero: error 1 - "+GetName(this) );
    }
}



// Da TRUE si el objeto dado es una carreta (que coicide con el area interior de una carreta).
int Carreta_esValida( object this );
int Carreta_esValida( object this ) {
    if( GetLocalString( this, Carreta_PrimerEstacionRef_LN ) != "" ) {
        if( GetLocalString( this, Carreta_vehiculoResRef_LN ) != "" )
            return TRUE;
        else
            PrintString( "Carreta_esValida: error 2 - "+GetName(this) );
    } else
        PrintString( "Carreta_esValida: error 1 - "+GetName(this) ); // este error tambien aparece si un DM crea un cochero en un mapa que no es interior de carreta.
    return FALSE;
}


// Proceso del choque de la carreta OBJECT_SELF.
// Nota: Iniciado por Cochero_onDeath.
void Carreta_choque();
void Carreta_choque() {
    object this = OBJECT_SELF;
//    SendMessageToPC( GetFirstPC(), "Carreta_choque: begin" );

    // se tira un dado de 6 caras...
    if( d6() == 1 )
    // si sale un '1', los pasajeros salen expulsados de la carreta
    {
        object caidaWaypoint = Carreta_getCaidaWaypoint( this );
        if( caidaWaypoint == OBJECT_INVALID ) return;
//        SendMessageToPC( GetFirstPC(), "Carreta_choque: caidaWaypointTag="+GetTag(caidaWaypoint) );

        // poner restos de carreta
        object oCarreta = CreateObject( OBJECT_TYPE_PLACEABLE, "plc_burnwagon", GetLocation( caidaWaypoint ) );
        DestroyObject(oCarreta, 180.0);
        // aplicar los efectos de la expulsion de la carreta a cada pasajero
        effect knockdown = EffectKnockdown();
        effect dazed = EffectDazed();
        effect blind = EffectBlindness();
        object pasajeroIterator = Carreta_getFirstPasajero( this );
        while( pasajeroIterator != OBJECT_INVALID ) {
            location randomLocation = Location_createRandom( GetLocation( caidaWaypoint ), 3.0, 10.0, TRUE );
            object polvo = CreateObject( OBJECT_TYPE_PLACEABLE, "plc_dustplume", randomLocation );
            DestroyObject( polvo, 60.0 );
            AssignCommand( pasajeroIterator, JumpToLocation( randomLocation ) );
            SendMessageToPC( pasajeroIterator, "sales despedido de la carreta" );
            DelayCommand( 1.0, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, knockdown, pasajeroIterator, 15.0 ) );
            DelayCommand( 3.0, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, blind, pasajeroIterator, 20.0 ) );
            DelayCommand( 4.0, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, dazed, pasajeroIterator, 60.0 ) );
            effect damage = EffectDamage( d2( GetHitDice(pasajeroIterator) ), DAMAGE_TYPE_BLUDGEONING, DAMAGE_POWER_PLUS_TWENTY );
            DelayCommand( 5.0, ApplyEffectToObject( DURATION_TYPE_INSTANT, damage, pasajeroIterator ) );

            pasajeroIterator = Carreta_getNextPasajero( this );
        }

        // El choque termino. Programar la apropiacion de esta instancia de carreta por otro cochero en 5minutos.
        DelayCommand( 300.0, Carreta_apropiar( this ) );

    } else
    // si sale distinto de '1', los pasajeros sufren un golpe y se vuelve a tirar el dado
    {
        // Realizar efectos visules de area
        object effectTargetWaypoint = GetWaypointByTag( GetLocalString( this, Carreta_pasajeroWaypointTag_LN ) );
        if( effectTargetWaypoint == OBJECT_INVALID ) {
            PrintString( "Carreta_choque: Error 2" );
            return;
        }
        location effectTarget = Location_createRandom( GetLocation( effectTargetWaypoint ), 3.0, 10.0, TRUE );
        effect temblor = EffectVisualEffect( 356 ); // VFX_FNF_SCREEN_SHAKE
        ApplyEffectAtLocation( DURATION_TYPE_TEMPORARY, temblor, effectTarget );
        effect astillas = EffectVisualEffect( VFX_DUR_CALTROPS );
        ApplyEffectAtLocation( DURATION_TYPE_TEMPORARY, astillas, effectTarget );

        // Aplicar efectos de un golpe del revuelco de la carreta a cada pasajaro
        effect knockdown = EffectKnockdown();
        object pasajeroIterator = Carreta_getFirstPasajero( this );
        while( pasajeroIterator != OBJECT_INVALID ) {
            SendMessageToPC(  pasajeroIterator, "la carreta da un vuelco" );
            PlaySound( "cb_bu_woodlrg" );
            int nivel = GetHitDice(pasajeroIterator) + GetLocalInt( pasajeroIterator, RDO_modificadorNivelSubraza_PN );
            effect damage = EffectDamage( 1+Random( nivel ), DAMAGE_TYPE_BLUDGEONING, DAMAGE_POWER_PLUS_TWENTY );
            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, knockdown, pasajeroIterator, IntToFloat(d4()) );
            ApplyEffectToObject( DURATION_TYPE_INSTANT, damage, pasajeroIterator );
            pasajeroIterator = Carreta_getNextPasajero( this );
        }

        // repetir hasta que salga un '1'  en el dado.
        DelayCommand( 5.0, Carreta_choque() );
    }
}


// Inicializa la carreta. Solo es necesario inicializar una vez a cada carreta.
// La inicializacon consiste en poner los carteles y campanas en cada estacion.
void Carreta_inicializar( object this );
void Carreta_inicializar( object this ) {
    if( GetLocalInt( this, Carreta_estaInicializada_FIELD ) )
        return;
    SetLocalInt( this, Carreta_estaInicializada_FIELD, TRUE );

    string primerEstacionRef = GetLocalString( this, Carreta_PrimerEstacionRef_LN );
    string estacionIteradaRef = primerEstacionRef;
    do {
        object estacionIteradaWayPoint = GetWaypointByTag( GetLocalString( this, estacionIteradaRef + Station_waypointTag_FIELD ) );
        if( estacionIteradaWayPoint == OBJECT_INVALID )
            break;

        object cartel = CreateObject(
            OBJECT_TYPE_PLACEABLE,
            "plc_billboard5",
            Location_createRelative( GetLocation(estacionIteradaWayPoint), -2.0, 4.0, 180.0 )
        );
//        SetUseableFlag( cartel, TRUE );
        SetPlotFlag( cartel, TRUE );

        object campana = CreateObject(
            OBJECT_TYPE_PLACEABLE,
            "carreta_campana",
            Location_createRelative( GetLocation(estacionIteradaWayPoint), -2.31, 4.0, 0.0 )
        );
        SetName( campana, "Parada de carruajes\nUse la campana para advertir su presencia" );
        SetLocalObject( campana, Campana_carreta_FIELD, this );
        SetLocalObject( campana, Campana_estacionWaypoint_FIELD, estacionIteradaWayPoint );

        estacionIteradaRef = GetLocalString( this, estacionIteradaRef + Station_nextTripDestinationRef_FIELD );
    } while( estacionIteradaRef != primerEstacionRef );
    if( estacionIteradaRef != primerEstacionRef )
        PrintString( "Carreta_constructor: error 1; carretaTag="+GetTag(this)+", estacionRef="+estacionIteradaRef );
}


