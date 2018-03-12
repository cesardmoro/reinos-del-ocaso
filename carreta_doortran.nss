/******************** Carreta exit door transition handler *********************
Package: Sistema de tranporte por carreta - carreta - exit door transition handler
Autor: Inquisidor
Version: 0.1
*******************************************************************************/
#include "Cochero"

void main() {
    object carreta = GetArea( OBJECT_SELF );
    object cochero = Carreta_getCochero( carreta );
    object pasajero = GetClickingObject();

    if( DateTime_getActual() < Cochero_getFechaHoraProximaPartida( cochero ) + 5  ) {
        location ultimaEstacionLoc = Cochero_getUltimaEstacion( cochero );
        AssignCommand( pasajero, JumpToLocation( Carreta_getEscaleraLoc( ultimaEstacionLoc ) ) );
    } else {
        object caidaWaypoint = Carreta_getCaidaWaypoint( carreta );
        if( caidaWaypoint == OBJECT_INVALID )
            return;
        location caidaLoc = GetLocation( caidaWaypoint );

        // aplicar los efectos de la caida de la carreta
        effect knockdown = EffectKnockdown();
        effect dazed = EffectDazed();
        location randomLocation = Location_createRandom( GetLocation( caidaWaypoint ), 5.0, 20.0, TRUE );
        object polvo = CreateObject( OBJECT_TYPE_PLACEABLE, "plc_dustplume", randomLocation );
        DestroyObject( polvo, 60.0 );
        AssignCommand( pasajero, JumpToLocation( randomLocation ) );
        SendMessageToPC( pasajero, "saltas de la carreta en movimiento" );
        DelayCommand( 5.0, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, knockdown, pasajero, 5.0 ) );
        effect damage = EffectDamage( d4( GetHitDice(pasajero) ), DAMAGE_TYPE_BLUDGEONING, DAMAGE_POWER_PLUS_TWENTY );
        DelayCommand( 10.0, ApplyEffectToObject( DURATION_TYPE_INSTANT, damage, pasajero ) );
        DelayCommand( 12.0, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, dazed, pasajero, 60.0 ) );
    }
}
