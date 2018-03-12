void pregunta(object oMuerto, object oArea)
{
    if(GetCurrentHitPoints( oMuerto) < -10 )
    {
        //if(GetIsInSubArea(oMuerto, oArea))
        //{
        SetCustomToken(2000+GetLocalInt(GetModule(), "iNum"), GetName(oMuerto));
        SetLocalObject(GetModule(), IntToString(2000+GetLocalInt(GetModule(), "iNum")), oMuerto);
        SetLocalInt(GetModule(), "iNum", GetLocalInt(GetModule(), "iNum")+1);
        //}
    }
}
