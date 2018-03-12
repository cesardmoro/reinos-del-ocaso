int StartingConditional()
{
int iResult;
object oPC = GetPCSpeaker();
if(GetGold(oPC) >= 10)
{
TakeGoldFromCreature(10, oPC, TRUE);
return TRUE;

}
return FALSE;
}

