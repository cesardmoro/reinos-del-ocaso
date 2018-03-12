//
// Stub function for possible later use.
//

void main()
{
    // Item creation code
   // ExecuteScript("hd_o0_heartbeat",OBJECT_SELF);
     object oMod=GetModule();
    int iCurrentHour = GetTimeHour();
    int nCurrentMinute = GetTimeMinute();
    int nCurrentSecond = GetTimeSecond();
    int nCurrentMilli = GetTimeMillisecond();
    SetTime(iCurrentHour, nCurrentMinute, nCurrentSecond, nCurrentMilli);

    if (GetLocalInt(oMod, "CheckHour") != GetTimeHour())
    {
        SetLocalInt(oMod, "CheckHour", GetTimeHour());
        ExecuteScript("kpb_tset", oMod);
    }


}
