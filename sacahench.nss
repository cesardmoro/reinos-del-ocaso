/******************************************************
24/11/06 - Script By Zero modificado por Dragoncin
Quita los mercenarios del grupo de un personaje.
Luego, los envia a un area donde se le cambia la faccion y se lo devuelve
******************************************************/

void matahench(object oPC)
{
//object oPC = OBJECT_SELF;
//int nSummon = 1;
//object oSummon;
//hile(GetIsObjectValid(GetAssociate(ASSOCIATE_TYPE_DOMINATED, OBJECT_SELF, nSummon)) == TRUE)
//{
//oSummon = GetAssociate(ASSOCIATE_TYPE_DOMINATED, OBJECT_SELF, nSummon);
if(GetAssociateType(oPC) == ASSOCIATE_TYPE_HENCHMAN)
{
object oMerc = oPC;
location oLoc = GetLocation(oPC);
    AssignCommand(oPC, ClearAllActions());
//    DelayCommand(0.5, ChangeToStandardFaction(oMerc, STANDARD_FACTION_COMMONER));
    DelayCommand(0.1, AssignCommand(oMerc, ActionJumpToLocation(GetLocation(GetObjectByTag("Merc4")))));
//    DelayCommand(3.0, AssignCommand(oMerc, ActionJumpToLocation(oLoc)));
    RemoveHenchman(GetMaster(oPC));

    SetLocalInt(oPC, "merc", 0);
}
//n/Summon = nSummon +1;
//}

}
