void main()
{
    object oPC = GetPCSpeaker();
    object oWeapon = GetItemPossessedBy(oPC, "codi_sam_mw");
    object oNewWeapon = CopyObject(oWeapon, GetLocation(oPC), oPC, "codi_sam_XX");
    DestroyObject(oWeapon);
}

