void avisar(object oPC)
{

//  if(GetSkillRank(SKILL_LISTEN, oPC)+d20(1) > 10+GetLocalInt(GetArea(oPC), "Cr"))
//     {
//     SendMessageToPC(oPC, "Escuchas algo en las cercanias");
 //    }
 // if(LineOfSightObject(oPC, oWay) == TRUE)
// {
//  if(GetSkillRank(SKILL_SPOT, oPC)+d20(1) > 10+GetLocalInt(GetArea(oPC), "Cr"))
//  {
////  SendMessageToPC(oPC, "Logras ver a tu enemigo y te dispones a intentar atacar antes que el");
//  int masini;
//  if(GetHasFeat(FEAT_EPIC_SUPERIOR_INITIATIVE, oPC) == TRUE)
//    {
 //   masini = masini + 4;
//    }
 //   if(GetHasFeat(FEAT_IMPROVED_INITIATIVE, oPC) == TRUE)
 ///   {
 //   masini = masini +4;
 //   }
//  SetLocalInt(GetArea(oPC), "ini", d20(1)+GetAbilityModifier(ABILITY_DEXTERITY, oPC)+masini);
 // }
//  }
     oPC = GetFirstFactionMember(oPC, TRUE);
while(oPC != OBJECT_INVALID)
{
     if(GetSkillRank(SKILL_LISTEN, oPC)+d20(1) > 10+GetLocalInt(GetArea(oPC), "Cr"))
     {
     SendMessageToPC(oPC, "Escuchas algo en las cercanias");
     }
//      if(LineOfSightObject(oPC, oWay) == TRUE)
//  {
//  if(GetSkillRank(SKILL_SPOT, oPC)+d20(1) > 10+GetLocalInt(GetArea(oPC), "Cr"))
//  {
//  SendMessageToPC(oPC, "Logras ver a tu enemigo y te dispones a intentar atacar antes que el");
  int masini;
  if(GetHasFeat(FEAT_EPIC_SUPERIOR_INITIATIVE, oPC) == TRUE)
    {
    masini = masini + 4;
    }
    if(GetHasFeat(FEAT_IMPROVED_INITIATIVE, oPC) == TRUE)
    {
    masini = masini +4;
    }
    if(GetLocalInt(GetArea(oPC), "ini") > 0)
    {
    SetLocalInt(GetArea(oPC), "ini", (d20(1)+GetAbilityModifier(ABILITY_DEXTERITY, oPC)+masini+GetLocalInt(GetArea(oPC), "ini"))/2);
    }
  if(GetLocalInt(GetArea(oPC), "ini") == 0)
    {
  SetLocalInt(GetArea(oPC), "ini", d20(1)+GetAbilityModifier(ABILITY_DEXTERITY, oPC)+masini);
 // }
 // }
  }
     oPC = GetNextFactionMember(oPC, TRUE);
}
DelayCommand(1.0, SetLocalInt(GetArea(oPC), "ini", 0));
}
