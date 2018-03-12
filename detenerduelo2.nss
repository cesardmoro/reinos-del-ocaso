void main()
{
object oMod = GetModule();
    int iLastHourRest = GetLocalInt(oMod, ("LastHourDuel"+GetTag(GetArea(OBJECT_SELF))));
    int iLastDayRest = GetLocalInt(oMod, ("LastDayDuel"+GetTag(GetArea(OBJECT_SELF))));
    int iLastYearRest = GetLocalInt(oMod, ("LastMonthDuel"+GetTag(GetArea(OBJECT_SELF))));
    int iLastMonthRest = GetLocalInt(oMod, ("LastYearDuel"+GetTag(GetArea(OBJECT_SELF))));
    int iHour = GetTimeHour();
        int iDay  = GetCalendarDay();
        int iYear = GetCalendarYear();
        int iMonth = GetCalendarMonth();
        int iHowLong = 0;
        if (iLastYearRest != iYear)
        {
            iMonth = iMonth + 12;
        }
        if (iLastMonthRest != iMonth)
        {
            iDay = iDay + 28;
        }
        if (iDay != iLastDayRest)
        {
            iHour = iHour + 24 * (iDay - iLastDayRest);
        }
        //figure out how long it has been since last rested
        iHowLong = iHour - iLastHourRest;

        if ((iHowLong > 4))
        {

object oEstado1 = GetNearestObjectByTag("ItemdeEstado", OBJECT_SELF, 1); // buscamos el cristal que brilla si el duelo esta activo
object oEstado2 = GetNearestObjectByTag("ItemdeEstado2", OBJECT_SELF, 1); // buscamos el cristal que brilla si el duelo esta activo
object oSalida1 = GetNearestObjectByTag("Salida1");
object oSalida2 = GetNearestObjectByTag("Salida2");
object oPuertaduel = GetNearestObjectByTag("PuertaArena1");
object oPuertaduel2 = GetNearestObjectByTag("PuertaArena2");
SetLocalInt(oMod, "Team2", 0);
SetLocalInt(oMod, "Team1", 0);
AssignCommand(oEstado1, DelayCommand(3.0, PlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE)));
AssignCommand(OBJECT_SELF, DelayCommand(3.0, PlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE)));
SetLocked(oSalida1, FALSE);
SetLocked(oSalida2, FALSE);
SetLocked(oPuertaduel, FALSE);
SetLocked(oPuertaduel2, FALSE);
SetLocalInt(oMod, "Confirmaciones1", 0);
SetLocalInt(oMod, "Confirmaciones2", 0);
SendMessageToPC(GetLastUsedBy(), "Duelo detenido");
}
else
{
SendMessageToPC(GetLastUsedBy(), "Deben pasar 4 horas desde comenzado el duelo para poder detenerlo");
}
}
