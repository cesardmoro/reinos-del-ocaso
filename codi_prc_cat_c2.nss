void main()
{
    object oPC = GetPCSpeaker();
    if(GetGold(oPC) >= 25)
    {
        object oWeapon = CreateItemOnObject("codi_mw_short",oPC);
        TakeGoldFromCreature(25, oPC, TRUE);
    }
    else
    {
        FloatingTextStringOnCreature("You do not have enough gold to do that.", oPC, FALSE);
    }
}

