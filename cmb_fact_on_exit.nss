/************************************************************
24/11/06 - Script By Dragoncin
Evita que luchen los integrantes del area al dejar la misma, por si coinciden mas de un
objeto de diferentes facciones.
Area donde se aplica: Area de Servicio - Cambio de faccion
************************************************************/

void main()
{
    object oCreature = GetExitingObject();
    DeleteLocalInt(oCreature, "FaccionBuscada");
    DeleteLocalLocation(oCreature, "DeDondeVino");
    AssignCommand(oCreature, ClearAllActions());
}
