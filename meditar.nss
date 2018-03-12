#include "SPC_inc"

void RestMeUp( int vidaAnterior, int temporizador )
{
    int vidaActual = GetCurrentHitPoints( OBJECT_SELF );
    int vidaPerdidaRonda = vidaAnterior - vidaActual;
    if( vidaPerdidaRonda > 0 ) {
        if( GetIsSkillSuccessful( OBJECT_SELF, SKILL_CONCENTRATION, 10 + vidaPerdidaRonda ) )
            SendMessageToPC( OBJECT_SELF, "Concentracion: Exito" );
        else {
            SendMessageToPC( OBJECT_SELF, "Concentracion: Fallo");
            temporizador += 18;
        }
    }

    temporizador -= 6;
    if( temporizador > 0 ) {

        ActionDoCommand( ActionPlayAnimation( ANIMATION_LOOPING_MEDITATE, 1.0, 6.0) );
        ActionDoCommand( RestMeUp( vidaActual, temporizador ) );

    } else {

        ForceRest( OBJECT_SELF );
        ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectDamage( GetCurrentHitPoints(OBJECT_SELF) - vidaActual ), OBJECT_SELF );
        ExecuteScript("prc_rest", OBJECT_SELF);

        // si se medita o duerme en un area segura que no esta en un poblado amigable, se pierde el 9% de la experiencia acumulada
        if( GetLocalInt( GetArea(OBJECT_SELF), SPC_seAplicaPenaDescanso_PN) ) {
            SisPremioCombate_quitarPorcentajeXpTransitoria( OBJECT_SELF, 9 );
            SendMessageToPC( OBJECT_SELF, "Meditar dentro de una carpa o taberna aislada resta un 9% a la experiencia transitoria acumulada desde el último descanzo en poblacion no hostil." );

        // si se medita en una mansion de Mordenkainen, se pierde el 6% de la experiencia transitoria acumulada
        } else if( GetTag( GetArea( OBJECT_SELF ) ) == "MordenkainensMagnificentMansion" ) {
            SisPremioCombate_quitarPorcentajeXpTransitoria( OBJECT_SELF, 6 );
            SendMessageToPC( OBJECT_SELF, "Meditar dentro de una mansion de Mordenkainen resta un 6% a la experiencia transitoria acumulada desde el último descanso en poblacion no hostil." );
        }

    }
}

void main() {
    int vidaInicial = GetCurrentHitPoints(OBJECT_SELF);
    ActionDoCommand( ActionPlayAnimation( ANIMATION_LOOPING_MEDITATE, 1.0, 6.0) );
    ActionDoCommand( RestMeUp( vidaInicial, 180 ) );
}
