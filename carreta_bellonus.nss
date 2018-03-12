/******************** Station bell on used handler *****************************
Package: Sistema de tranporte por carreta - carreta - station bell on used handler
Autor: Inquisidor
Version: 0.1
*******************************************************************************/
#include "Cochero"

void main()  {
    object carreta = GetLocalObject( OBJECT_SELF, Campana_carreta_FIELD );
    object cochero = Carreta_getCochero( carreta );
//    SendMessageToPC( GetFirstPC(), "Campana_onUsed: carreta="+GetName(carreta)+", cochero="+GetName(cochero) );
    if( GetLocalInt( cochero, Cochero_estado_FIELD ) == Cochero_Estado_INACTIVO ) {
        SetLocalInt( cochero, Cochero_estado_FIELD, Cochero_Estado_DESPERTANDO ); // esta linea esta para evitar que se llame dos veces a 'Cochero_arrivarAEstacion(..)', cuando el uso de la campana se pone mas de una vez en la cola de acciones antes de que se ejecute alguno.
        object estacionWaypoint = GetLocalObject( OBJECT_SELF, Campana_estacionWaypoint_FIELD );
//        SendMessageToPC( GetFirstPC(), "Campana_onUsed: waypoint="+GetName(estacionWaypoint) );
        AssignCommand( cochero, DelayCommand( 3.0, Cochero_arrivarAEstacion( estacionWaypoint ) ) );
    } else if( GetArea(cochero) == GetArea(OBJECT_SELF) || GetLocalInt( cochero, Cochero_estado_FIELD ) == Cochero_Estado_DESPERTANDO ) {
        FloatingTextStringOnCreature( "*tus timpanos se quejan*", GetLastUsedBy(), FALSE );
        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, EffectDazed(), GetLastUsedBy(), 120.0 );
        ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectDamage( d6(2), DAMAGE_TYPE_SONIC ), GetLastUsedBy(), 120.0 );
    } else
        FloatingTextStringOnCreature( "*aparentemente nadie atiende*", GetLastUsedBy(), FALSE );

    PlaySound("as_cv_bellship2");
    DelayCommand( 0.1, PlayAnimation(ANIMATION_PLACEABLE_ACTIVATE) );
}
