void main()
{
    object oPC = GetPCSpeaker();
    location lPC = GetLocation(oPC);
    object oAltar = CreateObject(OBJECT_TYPE_PLACEABLE,"codi_sam_altar",lPC);
    SetLocalObject(oAltar,"CODI_SAMURAI",oPC);
    SetLocalInt(oPC,"CODI_HAS_ALTAR",TRUE);
    DelayCommand(60.0, DestroyObject(oAltar));
    DelayCommand(60.0, DeleteLocalInt(oPC,"CODI_HAS_ALTAR"));
}

