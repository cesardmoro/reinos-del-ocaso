void main()
{
object oMod = GetModule();
object oEstado1 = GetNearestObjectByTag("ItemdeEstado", OBJECT_SELF, 1); // buscamos el cristal que brilla si el duelo esta activo
object oEstado2 = GetNearestObjectByTag("ItemdeEstado2", OBJECT_SELF, 1); // buscamos el cristal que brilla si el duelo esta activo
object oSalida1 = GetNearestObjectByTag("Salida1");
object oSalida2 = GetNearestObjectByTag("Salida2");
object oPuertaduel = GetNearestObjectByTag("PuertaArena1");
object oPuertaduel2 = GetNearestObjectByTag("PuertaArena2");
SetLocalInt(oMod, "Team2", 0);
SetLocalInt(oMod, "Team1", 0);
AssignCommand(OBJECT_SELF, DelayCommand(3.0, PlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE)));
AssignCommand(oEstado2, DelayCommand(3.0, PlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE)));
SetLocked(oSalida1, FALSE);
SetLocked(oSalida2, FALSE);
SetLocked(oPuertaduel, FALSE);
SetLocked(oPuertaduel2, FALSE);
SetLocalInt(oMod, "Confirmaciones1", 0);
SetLocalInt(oMod, "Confirmaciones2", 0);
SendMessageToPC(GetLastUsedBy(), "Duelo detenido");
AssignCommand(GetLastUsedBy(), ClearAllActions());
AssignCommand(GetLastUsedBy(), ActionDoCommand(JumpToLocation( GetLocation( GetNearestObjectByTag("ArenaRespawn") ) )));
SetLocalInt(GetLastUsedBy(), "ArenaMode", 0);
SendMessageToPC(GetLastUsedBy(), "Modo Arena Desactivado");
}
