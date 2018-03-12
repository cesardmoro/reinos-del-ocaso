int StartingConditional()
{
    object oPC = GetPCSpeaker();
    return (GetClassByPosition(2, oPC) > 0);
}

