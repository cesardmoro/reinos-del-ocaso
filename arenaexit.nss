void main()
{
object oPC = GetExitingObject();
SetLocalInt(oPC, "ArenaMode", 0);
SendMessageToPC(oPC, "Modo Arena Desactivado");
}
