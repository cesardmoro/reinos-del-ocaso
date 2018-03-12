void main()
{

    object oPC2 = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, GetObjectByTag("granjaspawn"));
 //  object oPC3 = GetFirstPC();
   SendMessageToPC(oPC2, "HearBeat");
  // SendMessageToPC(oPC3, "HearBeat");
   // if(GetLocalInt(GetObjectByTag("granjaspawn"), "numero") >= 1)
   // {

    object oPC = GetObjectByTag("granjaspawn");
    object oMod=GetModule();
    string sPCName=GetName(oPC);
    string sCDK="";
    int iLastHourSpawn = GetLocalInt(oMod, ("LastHourSpawn"+sPCName+sCDK));
    int iLastMinuteSpawn = GetLocalInt(oMod, ("LastMinuteSpawn"+sPCName+sCDK));
    //int iLastYearRest = GetLocalInt(oMod,("LastYearRest"+sPCName+sCDK));
    //int iLastMonthRest = GetLocalInt(oMod,("LastMonthRest"+sPCName+sCDK));
    int iMinute = GetTimeMinute();
    int iHour = GetTimeHour();
     // int iDay  = GetCalendarDay();
    int iHowLong = 0;
    if(iLastHourSpawn != iHour)
    {
    iMinute = iMinute + 60;
    }
    if(iMinute > iLastMinuteSpawn)
    {
    iHowLong = iMinute -iLastMinuteSpawn;
    }
  //  if(iHowLong > 20)
  //  {
    ExecuteScript("granjaspawn", oPC2);
   // }
    }

//}
