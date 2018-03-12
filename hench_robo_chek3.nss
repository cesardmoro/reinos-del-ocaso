int StartingConditional()
{
    int precio = GetLocalInt(OBJECT_SELF, "Precio") * 2;
    if (precio>GetGold(GetPCSpeaker()))
        return FALSE;

    return TRUE;
}
