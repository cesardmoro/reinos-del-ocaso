int StartingConditional()
{
    int precio = GetLocalInt(OBJECT_SELF, "Precio") + GetLevelByPosition(1) + GetLevelByPosition(2) + GetLevelByPosition(3);
    if (precio>GetGold(GetPCSpeaker()))
        return FALSE;

    return TRUE;
}
