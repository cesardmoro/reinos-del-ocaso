void main()
{
object oPC = GetLastUsedBy();
object oMod = GetModule();
if(GetLocalInt(oPC, "ArenaMode") == 1)
{
 SetLocalInt(oPC, "Team", 0);
 SetLocalInt(oPC, "ArenaMode", 0);
 SendMessageToPC(oPC, "Modo Arena Desactivado, Todas las confirmaciones deben volver a hacerce");
 SetLocalInt(oMod, "Team1", GetLocalInt(oMod, "Team1")-1); // descontamos jugadores del equipo 1
 SetLocalInt(oMod, "Confirmaciones1", 0);
 }
 AssignCommand(oPC, ActionDoCommand(JumpToLocation( GetLocation( GetNearestObjectByTag("ArenaRespawn") ) )));

}
