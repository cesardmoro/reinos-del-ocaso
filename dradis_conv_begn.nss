void main()
{
    object oPC = GetPCSpeaker();
    int i;
    for (i=1; i<=3; i++)
    {
        int clase = GetClassByPosition(i, oPC);
        int strRefNombreClase = StringToInt(Get2DAString("classes", "Name", clase));
        SetCustomToken(14001+i, GetStringByStrRef(strRefNombreClase));
    }
}
