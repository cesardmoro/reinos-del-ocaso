void main()
{
    SetLocalInt(OBJECT_SELF, "SeekSpellCircle", 0);
    SetLocalInt(OBJECT_SELF, "SeekSpellSlot", 1);
    SetLocalInt(OBJECT_SELF, "SeekSpellView", 1);
    int x, y;
    for (x = 0; x< 10; x++)
    {
        for (y = 0; y < 10; y++)
        {
            int nId = GetLocalInt(OBJECT_SELF, "Memorise_" + IntToString(x) + "_" + IntToString(y)) -1;
            int nMeta = GetLocalInt(OBJECT_SELF, "MetaMagic_" + IntToString(x) + "_" + IntToString(y));
            int bMemorised = GetLocalInt(OBJECT_SELF, "Memorised_" + IntToString(x) + "_" + IntToString(y));
            DeleteLocalInt(OBJECT_SELF, "Displayed_" + IntToString(nId)+ "_" + IntToString(nMeta));
        }
    }
    DeleteLocalInt(OBJECT_SELF, "Displayed_31_0");
    DeleteLocalInt(OBJECT_SELF, "Displayed_32_0");
    DeleteLocalInt(OBJECT_SELF, "Displayed_33_0");
    DeleteLocalInt(OBJECT_SELF, "Displayed_34_0");
    DeleteLocalInt(OBJECT_SELF, "Displayed_35_0");
    DeleteLocalInt(OBJECT_SELF, "Displayed_431_0");
    DeleteLocalInt(OBJECT_SELF, "Displayed_432_0");
    DeleteLocalInt(OBJECT_SELF, "Displayed_433_0");
    DeleteLocalInt(OBJECT_SELF, "Displayed_434_0");
    DeleteLocalInt(OBJECT_SELF, "Displayed_435_0");
}
