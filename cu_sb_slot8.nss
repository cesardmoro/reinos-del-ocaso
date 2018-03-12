void main()
{
    SetLocalInt(OBJECT_SELF, "ChosenSpellSlot", 8);
    SetLocalInt(OBJECT_SELF, "SpellScanCurrent", 0);
    SetLocalInt(OBJECT_SELF, "ScanView", 0);
    if (GetLocalInt(OBJECT_SELF, "SpellClass") == CLASS_TYPE_CLERIC)
    {
        // clerics have domain spells
        int nDomainSpells = GetLocalInt(OBJECT_SELF, "DomainSpells");
        SetLocalInt(OBJECT_SELF, "SpellScanCurrent", -1 * nDomainSpells);
    }
}
