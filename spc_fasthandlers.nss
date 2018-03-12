#include "RW_facade_inc"

// Esta funcion es llamada cuando una criatura 'OBJECT_SELF' generada por el RandomSpawn es vencida por un party que contiene
// al menos un personaje de jugador. El objetivo de esta funcion es comunicar, a quienes se subscriban insertando código,
// cuándo es que la criatura muere, y cuánto fue el total de premio nominal que fue dado a cada unos de los personajes jugadores por vencer a la criatura.
void SPC_Creature_onDeathFastHandlers( float premioTotalNominal );
void SPC_Creature_onDeathFastHandlers( float premioTotalNominal ) {

    // this code segment corresponds to the RandomWay -BEGIN
    object initiator = GetLocalObject( GetArea(OBJECT_SELF), RW_Area_initiatorTransition_VN );
    if( GetIsObjectValid(initiator) ) {
        SetLocalFloat(
            initiator,
            RW_Initiator_totalNominalReward_VN,
            premioTotalNominal + GetLocalFloat( initiator, RW_Initiator_totalNominalReward_VN )
        );
    }
    // this code segment corresponds to the RandomWay -END
}




// Esta funcion es llamada cuando un placeable 'OBJECT_SELF' con traba es abierta por un personaje jugador.
// El objetivo de esta funcion es comunicar, a quienes se subscriban insertando código,
// cuánto fue el premio nominal que fue dado por el hecho de abrir la cerradura.
void SPC_Placeable_onUnlockFastHandlers( object placeable, float premioNominal );
void SPC_Placeable_onUnlockFastHandlers( object placeable, float premioNominal ) {

    // this code segment corresponds to the RandomWay -BEGIN
    object initiator = GetLocalObject( GetArea(placeable), RW_Area_initiatorTransition_VN );
    if( GetIsObjectValid(initiator) ) {
        SetLocalFloat(
            initiator,
            RW_Initiator_totalNominalReward_VN,
            premioNominal + GetLocalFloat( initiator, RW_Initiator_totalNominalReward_VN )
        );
    }
    // this code segment corresponds to the RandomWay -END
}


void SPC_Placeable_onDisarmFastHandlers( object placeable, float premioNominal );
void SPC_Placeable_onDisarmFastHandlers( object placeable, float premioNominal ) {
    // vacio adrede
}
