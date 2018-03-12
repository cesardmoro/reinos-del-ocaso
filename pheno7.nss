void main()
{
    object oPC = GetPCSpeaker();
    if(GetRacialType(oPC) == RACIAL_TYPE_HUMAN ||
       GetRacialType(oPC) == RACIAL_TYPE_HALFORC ||
       GetRacialType(oPC) == RACIAL_TYPE_HALFELF ||
       GetRacialType(oPC) == RACIAL_TYPE_ELF)
    {
        SetPhenoType(4, oPC);
    }
    else
    {
        FloatingTextStringOnCreature("You are too small to ride this animal!", oPC);
    }
}
