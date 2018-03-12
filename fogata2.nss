void main()
{
if(GetCurrentHitPoints(OBJECT_SELF) == 1)
{
 DelayCommand(90.0, DestroyObject(OBJECT_SELF));
}
}
