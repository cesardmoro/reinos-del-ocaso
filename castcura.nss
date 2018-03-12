void main()
{
        object oPC = GetPCSpeaker();
        object oMod = GetModule();
        int iMinRest = 96;
        string sPCName=GetName(oPC);
        string sCDK=GetPCPublicCDKey(oPC);
        int iHour = GetTimeHour();
        int iDay  = GetCalendarDay();
        int iYear = GetCalendarYear();
        int iMonth = GetCalendarMonth();

        SetLocalInt(oMod, ("LastHourCura"+sPCName+sCDK), iHour);
        SetLocalInt(oMod, ("LastDayCura"+sPCName+sCDK), iDay);
        SetLocalInt(oMod,("LastYearCura"+sPCName+sCDK), iYear);
        SetLocalInt(oMod,("LastMonthCura"+sPCName+sCDK), iMonth);
}
