//::///////////////////////////////////////////////
//:: Name
//:: FileName t_chk100gp
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
// This can be used to only say a line in a conversation if the
// speaker has 100gp or more.
int StartingConditional()
{
   int iResult;

   iResult = (GetGold(GetPCSpeaker()) >= 100);
   return iResult;
}

