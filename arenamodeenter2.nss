#include "Time_inc"
#include "Location_tools"

void main()
{
    object oMod = GetModule(); // usamos el mod para setear
    object oPC = GetLastUsedBy();  // Pj que entra al trigger se le asignara variable arena

    int iHowLong = Time_getSecondsSinceLastRest( oPC );
    if (iHowLong < Time_SECONDS_BETWEEN_RESTS)
    {
        object oPuertaConfirma = GetNearestObjectByTag("ConfirmaArena2", oPC, 1); //Puerta a cerrar cuando esten en la arena
        if((GetLocalInt(oMod, "Confirmaciones1") == GetLocalInt(oMod, "Team1")) && (GetLocalInt(oMod, "Confirmaciones2") == GetLocalInt(oMod, "Team2"))&& (GetLocalInt(oMod, "Team2") >0  ) && (GetLocalInt(oMod, "Team1") > 0 ))
        {
            return;
        }
        if(GetLocalInt(oPC, "ArenaMode") == 1)
        {
            return;
        }
        SetLocalInt(oPC, "Confirmo", 0);
        SetLocalInt(oPC, "Team", 2);

        //si llegamos aca es q no tiene la variable
        SetLocalInt(oPC, "ArenaMode", 1);
        SendMessageToPC(oPC, "Modo Arena Activo");
        SetLocalInt(oMod, "Team2", GetLocalInt(oMod, "Team2")+1); // agregamos jugadores al equipo 2
        SetLocked(oPuertaConfirma, TRUE); //cerramos la puerta que confirma entrar a la arena para poder disparar el evento confirmador al intentar abrila luego
        AssignCommand(oPC, ClearAllActions());
        AssignCommand(oPC, ActionDoCommand(JumpToLocation( GetLocation( GetNearestObjectByTag("ArenaTeam2") ) )));
    }
    else
    {
        SendMessageToPC(oPC, "No puedes hacer un duelo sin estar listo para dormir");
    }
}
