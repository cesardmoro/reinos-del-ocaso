void main()
{
object oPC = GetLastUsedBy();
object oMod = GetModule();
if(GetLocalInt(oPC, "ArenaMode") == 1)
{
 SetLocalInt(oPC, "Team", 0);
 SetLocalInt(oPC, "ArenaMode", 0);
 SendMessageToPC(oPC, "Modo Arena Desactivado, Todas las confirmaciones deben volver a hacerce");
 SetLocalInt(oMod, "Team2", GetLocalInt(oMod, "Team2")-1); // descontamos jugadores del equipo 2
 SetLocalInt(oMod, "Confirmaciones2", 0);
 }
 AssignCommand(oPC, ActionDoCommand(JumpToLocation( GetLocation( GetNearestObjectByTag("ArenaRespawn") ) )));

}
