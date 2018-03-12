//::///////////////////////////////////////////////
//:: Confusion Heartbeat Support Script
//:: NW_G0_Confuse
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This heartbeat script runs on any creature
    that has been hit with the confusion effect.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Sept 27, 2001
//:: Modified By: Inquisidor
//:://////////////////////////////////////////////
#include "x0_inc_henai"
#include "Confuse_itf"

void main() {
    SetCommandable(TRUE);
    ClearAllActions(TRUE);

    switch( GetLocalInt( OBJECT_SELF, Confuse_option_VN ) ) {

        // Esta opcion es la confusion estandard. Para evitar modificar el hechizo confusion, todas las otras opciones deben poner el valor de 'Confuse_option_VN' devuelta a 'Confuse_Option_standard_CN' una vez que culmina el efecto.
        case Confuse_Option_standard_CN: { // usar el handler original de bioware
            SendForHelp();

            //Make sure the creature is commandable for the round
            SetCommandable(TRUE);
            //Clear all previous actions.
            ClearAllActions(TRUE);
            int nRandom = d10();
            //Roll a random int to determine this rounds effects
            if(nRandom  == 1)
            {
                ActionRandomWalk();
            }
            else if (nRandom >= 2 && nRandom  <= 6)
            {
                ClearAllActions(TRUE);
            }
            else if(nRandom >= 7 && nRandom <= 10)
            {
                ActionAttack(GetNearestObject(OBJECT_TYPE_CREATURE));
            }
        } break;


        // En esta opcion el que pone el efecto es responsable de quitarlo y poner el valor de 'Confuse_option_VN' devuelta a 'Confuse_Option_standard_CN'.
        case Confuse_Option_attackNearestCreatureAndAbsorbDamage_CN: {
//            SendMessageToPC( GetFirstPC(), "confuse begin" );
            int remainingRounds = GetLocalInt( OBJECT_SELF, Confuse_remainingRounds_VN );
//            SendMessageToPC( GetFirstPC(), "remainingRounds="+IntToString(remainingRounds) );
            if( --remainingRounds >= 0 ) {

                // absorbcion de daño y regreso a 8 rondas faltantes si se recibe daño
                int previousDamage = GetLocalInt( OBJECT_SELF, Confuse_previousDamage_VN );
                int currentDamage = GetMaxHitPoints(OBJECT_SELF)-GetCurrentHitPoints(OBJECT_SELF);
                if( currentDamage > previousDamage ) {
                    int absorbtion = ((currentDamage-previousDamage)*3)/4;
                    if( absorbtion > 0 ) {
                        ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectHeal( absorbtion ), OBJECT_SELF );
                        currentDamage -= absorbtion;
                    }
                    if( remainingRounds <= 2 )
                        remainingRounds += 2;
                }
                SetLocalInt( OBJECT_SELF, Confuse_previousDamage_VN, currentDamage );

                // oscurecimiento intermitente de la pantalla
                if( (remainingRounds&1)==0 ) {
                    FadeFromBlack( OBJECT_SELF );
//                    SendMessageToPC( GetFirstPC(), "fade from black" );
                }
                else {
                    FadeToBlack( OBJECT_SELF );
//                    SendMessageToPC( GetFirstPC(), "fade to black" );
                }

                // atacar a la criatura mas cercana
                object nearestCreature = GetNearestObject(OBJECT_TYPE_CREATURE, OBJECT_SELF);
                if( GetIsPC(nearestCreature) )
                    SetPCDislike( OBJECT_SELF, nearestCreature );
                ActionAttack(nearestCreature);
            }
            else {
                RemoveEffect( OBJECT_SELF, Confuse_getEffect() );
                SetLocalInt( OBJECT_SELF, Confuse_option_VN, Confuse_Option_standard_CN );
            }

            SetLocalInt( OBJECT_SELF, Confuse_remainingRounds_VN, remainingRounds );
//            SendMessageToPC( GetFirstPC(), "confuse end" );
        } break;


        // En esta opcion, es este handler el responsable de quitar el efecto y poner el valor de 'Confuse_option_VN' devuelta a 'Confuse_Option_standard_CN'.
        case Confuse_Option_attackSpecifiedCreature_CN: {
            int remainingRounds = GetLocalInt( OBJECT_SELF, Confuse_remainingRounds_VN );
            if( --remainingRounds >= 0 ) {
                object creature = GetLocalObject( OBJECT_SELF, Confuse_specifiedCreature_VN );
                if( GetIsPC(creature) )
                    SetPCDislike( OBJECT_SELF, creature );
                ActionAttack(creature);
            }
            else {
                RemoveEffect( OBJECT_SELF, Confuse_getEffect() );
                SetLocalInt( OBJECT_SELF, Confuse_option_VN, Confuse_Option_standard_CN );
            }
            SetLocalInt( OBJECT_SELF, Confuse_remainingRounds_VN, remainingRounds );
        } break;


        case Confuse_Option_doNothing_CN:
            break;
    }

    SetCommandable(FALSE);
}
