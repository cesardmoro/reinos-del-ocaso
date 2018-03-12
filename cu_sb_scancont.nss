#include "cu_spells"

int StartingConditional()
{
    int nCircle = GetLocalInt(OBJECT_SELF, "Spellbook_Circle");
    int nCurrentScan = GetLocalInt(OBJECT_SELF, "SpellScanCurrent");
    SetLocalInt(OBJECT_SELF, "ScanView", 0);
    int x, nSpell;
    if (nCurrentScan == 801) return FALSE;
    for (x = nCurrentScan; x < 800; x++)
    {
        nSpell = x;
        if (x < 0 || GetLocalInt(OBJECT_SELF, "Known_" + IntToString(x)))
        {
            int nSpellLevel;
            // domain spells if x < 0
            if (x < 0)
            {
                nSpellLevel = GetLocalInt(OBJECT_SELF, "DomainSpellCircle_" + IntToString(-1 * x));
                nSpell = GetLocalInt(OBJECT_SELF, "DomainSpellId_" + IntToString(-1 * x));
            } else {
                nSpellLevel = CU_GetSpellLevel(nSpell);
            }
            int nMeta;
            if ((nSpellLevel + 3) == nCircle && GetHasFeat(FEAT_MAXIMIZE_SPELL) && CU_GetMetaMagicAllowed(nSpell, METAMAGIC_MAXIMIZE))
            {
                nSpellLevel +=3;
            } else if ((nSpellLevel + 2) == nCircle && GetHasFeat(FEAT_EMPOWER_SPELL) && CU_GetMetaMagicAllowed(nSpell, METAMAGIC_EMPOWER))
            {
                nSpellLevel +=2;
            } else if ((nSpellLevel + 1) == nCircle && GetHasFeat(FEAT_EXTEND_SPELL) && CU_GetMetaMagicAllowed(nSpell, METAMAGIC_EXTEND))
            {
                nSpellLevel ++;
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
