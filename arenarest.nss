#include "Time_inc"
#include "Location_tools"

void main()
{
    object oPC = GetExitingObject();
    int iHowLong = Time_getSecondsSinceLastRest( oPC );
    if (iHowLong < Time_SECONDS_BETWEEN_RESTS)
        ForceRest(oPC);
    else {
        AssignCommand(oPC, Location_forcedJump( GetLocation( GetNearestObjectByTag("ArenaRespawn") ) ));
        SendMessageToPC( oPC, "Deben transcurrir cuatro horas desde el ultimo descanso o duelo para volver a participar" );
    }
}

