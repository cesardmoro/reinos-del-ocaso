void main()
{
    int nivel_hench = GetLevelByPosition(1) + GetLevelByPosition(2) + GetLevelByPosition(3);
    SetCustomToken(105, IntToString(nivel_hench*10));
    SetCustomToken(106, IntToString(nivel_hench*20));
    SetCustomToken(107, IntToString(GetLocalInt(OBJECT_SELF, "Precio")*2));
}
