int StartingConditional()
{
int iResult;
object oPC = GetPCSpeaker();
if(GetGold(oPC) > 10)
{
//TakeGoldFromCreature(100, oPC, TRUE);
return FALSE;

}
return TRUE;
}

