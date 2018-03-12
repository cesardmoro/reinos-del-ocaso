#include "cu_spells"

int StartingConditional()
{
    int nCircle = GetLocalInt(OBJECT_SELF, "Spellbook_Circle");
    int nSpells = GetLocalInt(OBJECT_SELF, "Num_Spells");
    int nCurrentSlot = GetLocalInt(OBJECT_SELF, "Current_Slot") + 1;
    if (nCurrentSlot > nSpells)
        return FALSE;
    SetLocalInt(OBJECT_SELF, "Current_Slot", nCurrentSlot);
    int nSpellInSlot = GetLocalInt(OBJECT_SELF, "Memorise_" + IntToString(nCircle) + "_" + IntToString(nCurrentSlot));
    string sSpellInSlot;
    if (nSpellInSlot)
    {
        sSpellInSlot = CU_GetSpellName(nSpellInSlot - 1) + ": ";
        if (GetLocalInt(OBJECT_SELF, "Memorised_" + IntToString(nCircle) + "_" + IntToString(nCurrentSlot)))
        {
            sSpellInSlot += "Memorised";
        } else
        {
            sSpellInSlot += "UnMemorised";
        }
        int nMeta = GetLocalInt(OBJECT_SELF, "MetaMagic_" + IntToString(nCircle) + "_" + IntToString(nCurrentSlot));
        switch (nMeta)
        {
            case METAMAGIC_EMPOWER:
            sSpellInSlot = "Empowered " + sSpellInSlot;
            break;
            case METAMAGIC_EXTEND:
            sSpellInSlot = "Extended " + sSpellInSlot;
            break;
            case METAMAGIC_MAXIMIZE:
            sSpellInSlot = "Maximized " + sSpellInSlot;
            break;
            case METAMAGIC_QUICKEN:
            sSpellInSlot = "Quickened " + sSpellInSlot;
            break;
            case METAMAGIC_SILENT:
            sSpellInSlot = "Silent " + sSpellInSlot;
            break;
            case METAMAGIC_STILL:
            sSpellInSlot = "Still " + sSpellInSlot;
            break;
        }
    } else {
        sSpellInSlot = "Empty";
    }
    SetCustomToken(199 + nCurrentSlot, "Slot " + IntToString(nCurrentSlot) + ": " + sSpellInSlot);
    return TRUE;
}
