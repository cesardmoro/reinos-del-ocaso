#include "cu_spells"

int CheckSpontCast(int nSlot)
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
    int nScanSlot, nScanCircle;
    SetLocalInt(OBJECT_SELF, "SeekSpellView" , 1);
    if (nCircle == 10) return FALSE;
    if (nCircle == 11)
    {
        if (CheckSpontCast(nSlot))
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
            int bMemorised = GetLocalInt(OBJECT_SELF, "Memorised_" + IntToString(nScanCircle) + "_" + IntToString(nScanSlot));
            int bDisplayed = GetLocalInt(OBJECT_SELF, "Displayed_" + IntToString(nId));
            if ((nId >= 0) && bMemorised && !bDisplayed)
            {
                return TRUE;
            }
        }
        nSlot = 1;
    }
    if (CheckSpontCast(0))
    {
        SetLocalInt(OBJECT_SELF, "SeekSpellCircle", 11);
        return TRUE;
    }
    SetLocalInt(OBJECT_SELF, "SeekSpellCircle", 10);
    return FALSE;
}
