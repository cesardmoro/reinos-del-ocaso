void main()
{
object oPC = GetLastSpeaker();
if(GetLocalInt(oPC, "conjuro") == 0)
{
SetLocalInt(oPC, "conjuro", 9);
}
}
