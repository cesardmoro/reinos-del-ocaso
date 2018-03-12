void main()
{
string sID = GetName(OBJECT_SELF);
if(GetStringLength(sID) > 0)
{
sID = GetStringLeft(sID, 25);
}
if(GetArea(OBJECT_SELF) != OBJECT_INVALID)
{
SetCampaignInt("delogs", "muerto" + sID , 0);
ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), OBJECT_SELF);
}
if(GetArea(OBJECT_SELF) == OBJECT_INVALID)
{
DelayCommand(3.0, ExecuteScript("matarpj", OBJECT_SELF));
}
}
