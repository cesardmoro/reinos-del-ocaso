void main()
{
    object oPC = GetPCSpeaker();
    object oMerc = OBJECT_SELF;
    location oLoc = GetLocation(OBJECT_SELF);
//    DelayCommand(1.0,ChangeToStandardFaction(oMerc, STANDARD_FACTION_COMMONER));
    SetLocalInt(oMerc, "FaccionBuscada", STANDARD_FACTION_COMMONER);
    SetLocalLocation(oMerc, "DeDondeVino", oLoc);
    RemoveHenchman(oPC);
    AssignCommand(oMerc, ActionJumpToLocation(GetLocation(GetWaypointByTag("Merc4"))));
//    DelayCommand(2.0, AssignCommand(oMerc, ActionJumpToLocation(oLoc)));
    SetLocalInt(OBJECT_SELF, "merc", 0);
    //SetLocalInt(oPC, "cantidadMercenarios", GetLocalInt(oPC, "cantidadMercenarios")-1);

}
