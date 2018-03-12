int StartingConditional()
{
if(GetLocalInt(GetArea(GetPCSpeaker()), "puede") == 1)
{
return TRUE;
}
return FALSE;
}
