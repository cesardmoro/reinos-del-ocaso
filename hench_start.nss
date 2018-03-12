int StartingConditional()
{
    SetCustomToken(100, GetName(OBJECT_SELF));
    int nivel = GetLevelByPosition(1, OBJECT_SELF);
    int precio = nivel * 3;
    SetLocalInt(OBJECT_SELF, "Precio", precio);
    SetCustomToken(101, IntToString(precio));
    if (GetMaster()!=OBJECT_INVALID)
        return FALSE;

    return TRUE;
}
