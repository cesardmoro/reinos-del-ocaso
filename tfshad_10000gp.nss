int StartingConditional()
{
object oPC = GetPCSpeaker();

if (!(GetGold(oPC) >= 10000)) return FALSE;

return TRUE;
}
