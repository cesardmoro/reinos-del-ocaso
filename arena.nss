#include "muerte_inc"
void accionesarena(object oPC)
{
object oMod = GetModule();
object oEstado1 = GetNearestObjectByTag("ItemdeEstado", OBJECT_SELF, 1); // buscamos el cristal que brilla si el duelo esta activo
object oEstado2 = GetNearestObjectByTag("ItemdeEstado", OBJECT_SELF, 1); // buscamos el cristal que brilla si el duelo esta activo
object oSalida1 = GetNearestObjectByTag("Salida1");
object oSalida2 = GetNearestObjectByTag("Salida2");
object oPuertaduel = GetNearestObjectByTag("PuertaArena1");
object oPuertaduel2 = GetNearestObjectByTag("PuertaArena2");
Raise(oPC);
ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCutsceneImmobilize(), oPC, 1.0);
AssignCommand(oPC, JumpToLocation( GetLocation( GetNearestObjectByTag("ArenaRespawn") ) ));
SetLocalInt(oPC, "ArenaMode", 0);
if(GetLocalInt(oPC, "Team") == 2)
{
SetLocalInt(oMod, "Team2", GetLocalInt(oMod, "Team2")-1);
}
if(GetLocalInt(oPC, "Team") == 1)
{
SetLocalInt(oMod, "Team1", GetLocalInt(oMod, "Team1")-1);
}

if(GetLocalInt(oMod, "Team1") == 0 || GetLocalInt(oMod, "Team2") == 0)
{
AssignCommand(oEstado1, DelayCommand(3.0, PlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE)));
AssignCommand(oEstado2, DelayCommand(3.0, PlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE)));
SetLocked(oSalida1, FALSE);
SetLocked(oSalida2, FALSE);
SetLocked(oPuertaduel, FALSE);
SetLocked(oPuertaduel2, FALSE);
}




}
