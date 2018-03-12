#include "cu_spells"

int StartingConditional()
{
    int nCircle = GetLocalInt(OBJECT_SELF, "Spellbook_Circle");
    int nCurrentScan = GetLocalInt(OBJECT_SELF, "SpellScanCurrent");
    SetLocalInt(OBJECT_SELF, "ScanView", 0);
    int x;
    if (nCurrentScan == 801) return FALSE;
    for (x = nCurrentScan; x < 800; x++)
    {
        if (x < 0 || GetLocalInt(OBJECT_SELF, "Known_" + IntToString(x)))
        {
            int nSpellLevel;
            if (x < 0)
            {
                nSpellLevel = GetLocalInt(OBJECT_SELF, "DomainSpellCircle_" + IntToString(-1 * x));
            } else {
                nSpellLevel = CU_GetSpellLevel(x);
            }
            if (nCircle == nSpellLevel)
            {
                return TRUE;
            }
        }
    }
    SetLocalInt(OBJECT_SELF, "SpellScanCurrent", 801);
    return FALSE;
}
