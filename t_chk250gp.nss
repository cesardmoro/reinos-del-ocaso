//::///////////////////////////////////////////////
//:: Name
//:: FileName t_chk250gp
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
// This can be used to only say a line in a conversation if the
// speaker has 250gp or more.
int StartingConditional()
{
   int iResult;

   iResult = (GetGold(GetPCSpeaker()) >= 250);
   return iResult;
}

