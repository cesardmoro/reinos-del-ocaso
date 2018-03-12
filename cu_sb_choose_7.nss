void main()
{
    int nCurrentSlot = GetLocalInt(OBJECT_SELF, "ChosenSpellSlot");
    int nCircle = GetLocalInt(OBJECT_SELF, "Spellbook_Circle");
    int nSpellId = GetLocalInt(OBJECT_SELF, "View_Spell_Id_7");
    int nMeta = GetLocalInt(OBJECT_SELF, "View_Spell_Meta_7");
    int nOldSpell = GetLocalInt(OBJECT_SELF, "Memorise_" + IntToString(nCircle) + "_" + IntToString(nCurrentSlot)) -1;
    int nOldSpellMemorised = GetLocalInt(OBJECT_SELF, "Memorised_" + IntToString(nCircle) + "_" + IntToString(nCurrentSlot));
    if (nOldSpellMemorised && nOldSpell)
    {
        int nMemNum = GetLocalInt(OBJECT_SELF, "MemNum_" + IntToString(nOldSpell));
        SetLocalInt(OBJECT_SELF, "MemNum_" + IntToString(nOldSpell), --nMemNum);
    }
    SetLocalInt(OBJECT_SELF, "Memorise_" + IntToString(nCircle) + "_" + IntToString(nCurrentSlot), nSpellId + 1);
    SetLocalInt(OBJECT_SELF, "Memorised_" + IntToString(nCircle) + "_" + IntToString(nCurrentSlot), FALSE);
    SetLocalInt(OBJECT_SELF, "MetaMagic_" + IntToString(nCircle) + "_" + IntToString(nCurrentSlot), nMeta);
}
