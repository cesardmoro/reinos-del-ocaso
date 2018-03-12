#include "cu_spells"

int CheckSpontCast(int nSlot, int nView)
{
    // nSlot keeps track of the SpellId in this case
    if (GetLocalInt(OBJECT_SELF, "SpellClass") == CLASS_TYPE_CLERIC)
    {
        int z, x;
        for (z = nSlot; z < 10; z++)
        {
            switch (z)
            {
                case 0:
                    x = SPELL_CURE_MINOR_WOUNDS;
                    break;
                case 1:
                    x = SPELL_CURE_LIGHT_WOUNDS;
                    break;
                case 2:
                    x = SPELL_CURE_MODERATE_WOUNDS;
                    break;
                case 3:
                    x = SPELL_CURE_SERIOUS_WOUNDS;
                    break;
                case 4:
                    x = SPELL_CURE_CRITICAL_WOUNDS;
                    break;
                case 5:
                    x = SPELL_INFLICT_MINOR_WOUNDS;
                    break;
                case 6:
                    x = SPELL_INFLICT_LIGHT_WOUNDS;
                    break;
                case 7:
                    x = SPELL_INFLICT_MODERATE_WOUNDS;
                    break;
                case 8:
                    x = SPELL_INFLICT_SERIOUS_WOUNDS;
                    break;
                case 9:
                    x = SPELL_INFLICT_CRITICAL_WOUNDS;
                    break;
            }
            int nSpellCircle = CU_GetSpellLevel(x);
            int y;
            for (y = 1; y < 10; y++)
            {
                int bMem = GetLocalInt(OBJECT_SELF, "Memorised_" + IntToString(nSpellCircle) + "_" + IntToString(y));
                if (bMem)
                {
                    int nId = GetLocalInt(OBJECT_SELF, "Memorise_" + IntToString(nSpellCircle) + "_" + IntToString(y)) -1;
                    int bKnown = GetLocalInt(OBJECT_SELF, "Known_" + IntToString(nId));
                    int bDisplayed = GetLocalInt(OBJECT_SELF, "Displayed_" + IntToString(x)+ "_" + IntToString(METAMAGIC_NONE));
                    // not a domain spell
                    if (!bDisplayed && bKnown)
                    {
                        string sName =  "Spontaneous " + CU_GetSpellName(x);
                        SetCustomToken(499 + nView, sName);
                        SetLocalInt(OBJECT_SELF, "CastId_" + IntToString(nView), x);
                        SetLocalInt(OBJECT_SELF, "CastMeta_" + IntToString(nView), METAMAGIC_NONE);
                        SetLocalInt(OBJECT_SELF, "Displayed_" + IntToString(x) + "_" + IntToString(METAMAGIC_NONE), TRUE);
                        SetLocalInt(OBJECT_SELF, "SeekSpellSlot",z + 1);
                        SetLocalInt(OBJECT_SELF, "SeekSpellView", nView + 1);
                        return TRUE;
                    }
                }
            }
        }
    }
    return FALSE;
}

int StartingConditional()
{
    int nCircle = GetLocalInt(OBJECT_SELF, "SeekSpellCircle");
    int nSlot = GetLocalInt(OBJECT_SELF, "SeekSpellSlot");
    int nView = GetLocalInt(OBJECT_SELF, "SeekSpellView");
    int nScanSlot, nScanCircle;
    if (nCircle == 10) return FALSE;
    if (nCircle == 11)
    {
        if (CheckSpontCast(nSlot, nView))
        {
            return TRUE;
        }
        SetLocalInt(OBJECT_SELF, "SeekSpellCircle", 10);
        return FALSE;
    }
    for (nScanCircle = nCircle; nScanCircle < 10; nScanCircle++)
    {
        for (nScanSlot = nSlot; nScanSlot < 10; nScanSlot++)
        {
            int nId = GetLocalInt(OBJECT_SELF, "Memorise_" + IntToString(nScanCircle) + "_" + IntToString(nScanSlot)) -1;
            int nMeta = GetLocalInt(OBJECT_SELF, "MetaMagic_" + IntToString(nScanCircle) + "_" + IntToString(nScanSlot));
            int bMemorised = GetLocalInt(OBJECT_SELF, "Memorised_" + IntToString(nScanCircle) + "_" + IntToString(nScanSlot));
            int bDisplayed = GetLocalInt(OBJECT_SELF, "Displayed_" + IntToString(nId)+ "_" + IntToString(nMeta));
            if ((nId >= 0) && bMemorised && !bDisplayed)
            {
                string sName = CU_GetSpellName(nId);
                switch (nMeta)
                {
                    case METAMAGIC_EMPOWER:
                    sName = "Empowered " + sName;
                    break;
                    case METAMAGIC_EXTEND:
                    sName = "Extended " + sName;
                    break;
                    case METAMAGIC_MAXIMIZE:
                    sName = "Maximized " + sName;
                    break;
                    case METAMAGIC_SILENT:
                    sName = "Silent " + sName;
                    break;
                    case METAMAGIC_STILL:
                    sName = "Still " + sName;
                    break;
                    case METAMAGIC_QUICKEN:
                    sName = "Quickened " + sName;
                    break;
                }
                SetCustomToken(499 + nView, sName);
                SetLocalInt(OBJECT_SELF, "CastId_" + IntToString(nView), nId);
                SetLocalInt(OBJECT_SELF, "CastMeta_" + IntToString(nView), nMeta);
                SetLocalInt(OBJECT_SELF, "Displayed_" + IntToString(nId) + "_" + IntToString(nMeta), TRUE);
                nScanSlot++;
                if (nScanSlot == 10)
                {
                    nScanSlot = 1;
                    nScanCircle++;
                }
                SetLocalInt(OBJECT_SELF, "SeekSpellCircle", nScanCircle);
                SetLocalInt(OBJECT_SELF, "SeekSpellSlot", nScanSlot);
                SetLocalInt(OBJECT_SELF, "SeekSpellView", nView + 1);
                return TRUE;
            }
        }
        nSlot = 1;
    }
    if (CheckSpontCast(0, nView))
    {
        SetLocalInt(OBJECT_SELF, "SeekSpellCircle", 11);
        return TRUE;
    }
    SetLocalInt(OBJECT_SELF, "SeekSpellCircle", 10);
    return FALSE;
}
