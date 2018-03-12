#include "cu_spells"

int StartingConditional()
{
    int nCircle = GetLocalInt(OBJECT_SELF, "Spellbook_Circle");
    int nCurrentScan = GetLocalInt(OBJECT_SELF, "SpellScanCurrent");
    int nView = GetLocalInt(OBJECT_SELF, "ScanView") + 1;
    SetLocalInt(OBJECT_SELF, "ScanView", nView);
    int x, nSpell;
    if (nCurrentScan == 801) return FALSE;
    for (x = nCurrentScan; x < 800; x++)
    {
        nSpell = x;
        if (x < 0 || GetLocalInt(OBJECT_SELF, "Known_" + IntToString(x)))
        {
            int nSpellLevel;
            if (x < 0)
            {
                nSpellLevel = GetLocalInt(OBJECT_SELF, "DomainSpellCircle_" + IntToString(-1 * x));
                nSpell = GetLocalInt(OBJECT_SELF, "DomainSpellId_" + IntToString(-1 * x));
            } else {
                nSpellLevel = CU_GetSpellLevel(nSpell);
            }
            if (nCircle == nSpellLevel)
            {
                string sName = CU_GetSpellName(nSpell);
                SetCustomToken(299 + nView, sName);
                SetLocalInt(OBJECT_SELF, "View_Spell_Id_" + IntToString(nView), nSpell);
                SetLocalInt(OBJECT_SELF, "SpellScanCurrent", x + 1);
                return TRUE;
            }
        }
    }
    SetLocalInt(OBJECT_SELF, "SpellScanCurrent", 801);
    return FALSE;
}
