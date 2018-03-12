void main()
{
    object oPC = GetPCSpeaker();
    if(GetGold(oPC) >= 50)
    {
        object oWeapon = CreateItemOnObject("codi_mw_katana",oPC);
        TakeGoldFromCreature(50, oPC, TRUE);
    }
    else
    {
        FloatingTextStringOnCreature("You do not have enough gold to do that.", oPC, FALSE);
    }
}

