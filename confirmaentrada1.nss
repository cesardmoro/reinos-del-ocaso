void main()
{
object oPuertaInicio = GetNearestObjectByTag("ConfirmaArena1");
object oPuertaInicio2 = GetNearestObjectByTag("ConfirmaArena2");
object oPuertaduel = GetNearestObjectByTag("PuertaArena1");
object oPuertaduel2 = GetNearestObjectByTag("PuertaArena2");
object oSalida1 = GetNearestObjectByTag("Salida1");
object oSalida2 = GetNearestObjectByTag("Salida2");
object oPC = GetLastUsedBy();
object oMod = GetModule(); // usamos el mod para setear
object oEstado1 = GetNearestObjectByTag("ItemdeEstado", OBJECT_SELF, 1); // buscamos el cristal que brilla si el duelo esta activo
object oEstado2 = GetNearestObjectByTag("ItemdeEstado2", OBJECT_SELF, 1); // buscamos el cristal que brilla si el duelo esta activo
object oVerde1 = GetNearestObjectByTag("Verde1", OBJECT_SELF);
object oAmarillo1 = GetNearestObjectByTag("Amarillo1", OBJECT_SELF);
object oRojo1 = GetNearestObjectByTag("Rojo1", OBJECT_SELF);
object oVerde2 = GetNearestObjectByTag("Verde2", OBJECT_SELF);
object oAmarillo2 = GetNearestObjectByTag("Amarillo2", OBJECT_SELF);
object oRojo2 = GetNearestObjectByTag("Rojo2", OBJECT_SELF);
if(GetLocalInt(oPC, "Confirmo") == 1)
{
return;
}
if(GetLocalInt(oMod, "Team2") < 1)
{
SendMessageToPC(oPC, "El otro equipo esta vacio");
return;
}
SetLocalInt(oPC, "Confirmo", 1);
SetLocalInt(oMod, "Confirmaciones1", GetLocalInt(oMod, "Confirmaciones1")+1);
SendMessageToPC(oPC, IntToString(GetLocalInt(oMod, "Confirmaciones1"))+" Confirmaciones de "+IntToString(GetLocalInt(oMod, "Team1"))+ " Hechas");
if((GetLocalInt(oMod, "Confirmaciones1") == GetLocalInt(oMod, "Team1")) && (GetLocalInt(oMod, "Confirmaciones2") == GetLocalInt(oMod, "Team2")))
{
SetLocked(oPuertaduel, TRUE);
SetLocked(oPuertaduel2, TRUE);
SetLocked(oSalida1, TRUE);
SetLocked(oSalida2, TRUE);
AssignCommand(oPuertaInicio, DelayCommand(6.0, SetLocked(oPuertaInicio, FALSE)));
AssignCommand(oPuertaInicio, DelayCommand(6.5, ActionOpenDoor(oPuertaInicio)));
AssignCommand(oPuertaInicio2, DelayCommand(6.0, SetLocked(oPuertaInicio2, FALSE)));
AssignCommand(oPuertaInicio2, DelayCommand(6.5, ActionOpenDoor(oPuertaInicio2)));
AssignCommand(oRojo1, DelayCommand(2.0, PlayAnimation(ANIMATION_PLACEABLE_ACTIVATE)));
AssignCommand(oRojo2, DelayCommand(2.0, PlayAnimation(ANIMATION_PLACEABLE_ACTIVATE)));
AssignCommand(oRojo1, DelayCommand(4.0, PlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE)));
AssignCommand(oRojo2, DelayCommand(4.0, PlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE)));
AssignCommand(oAmarillo1, DelayCommand(4.0, PlayAnimation(ANIMATION_PLACEABLE_ACTIVATE)));
AssignCommand(oAmarillo2, DelayCommand(4.0, PlayAnimation(ANIMATION_PLACEABLE_ACTIVATE)));
AssignCommand(oAmarillo1, DelayCommand(6.0, PlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE)));
AssignCommand(oAmarillo2, DelayCommand(6.0, PlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE)));
AssignCommand(oVerde1, DelayCommand(6.0, PlayAnimation(ANIMATION_PLACEABLE_ACTIVATE)));
AssignCommand(oVerde2, DelayCommand(6.0, PlayAnimation(ANIMATION_PLACEABLE_ACTIVATE)));
AssignCommand(oEstado1, DelayCommand(6.0, PlayAnimation(ANIMATION_PLACEABLE_ACTIVATE)));
AssignCommand(oEstado2, DelayCommand(6.0, PlayAnimation(ANIMATION_PLACEABLE_ACTIVATE)));
AssignCommand(oRojo1, DelayCommand(12.0, PlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE)));
AssignCommand(oRojo2, DelayCommand(12.0, PlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE)));
AssignCommand(oAmarillo1, DelayCommand(12.0, PlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE)));
AssignCommand(oAmarillo2, DelayCommand(12.0, PlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE)));
AssignCommand(oVerde1, DelayCommand(12.0, PlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE)));
AssignCommand(oVerde2, DelayCommand(12.0, PlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE)));

    SetLocalInt(oMod, ("LastHourDuel"+GetTag(GetArea(OBJECT_SELF))), GetTimeHour());
    SetLocalInt(oMod, ("LastDayDuel"+GetTag(GetArea(OBJECT_SELF))), GetCalendarDay());
    SetLocalInt(oMod, ("LastMonthDuel"+GetTag(GetArea(OBJECT_SELF))), GetCalendarMonth());
    SetLocalInt(oMod, ("LastYearDuel"+GetTag(GetArea(OBJECT_SELF))), GetCalendarYear());
}
}
