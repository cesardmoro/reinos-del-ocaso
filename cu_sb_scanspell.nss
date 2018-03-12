#include "cu_spells"

// edit for new metamagic feats: quicken, still and silent
int StartingConditional()
{
    int nCircle = GetLocalInt(OBJECT_SELF, "Spellbook_Circle");
    int nCurrentScan = GetLocalInt(OBJECT_SELF, "SpellScanCurrent");
    int nView = GetLocalInt(OBJECT_SELF, "ScanView") + 1;
    int nMetaStart = GetLocalInt(OBJECT_SELF, "MetaStart");
    DeleteLocalInt(OBJECT_SELF, "MetaStart");
    SetLocalInt(OBJECT_SELF, "ScanView", nView);
    int x;
    if (nCurrentScan == 801) return FALSE;
    for (x = nCurrentScan; x < 800; x++)
    {
        int nSpell = x;
        if (x < 0 || GetLocalInt(OBJECT_SELF, "Known_" + IntToString(nSpell)))
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
                nMeta = METAMAGIC_MAXIMIZE;
                nSpellLevel +=3;
            } else if ((nSpellLevel + 2) == nCircle && GetHasFeat(FEAT_EMPOWER_SPELL) && CU_GetMetaMagicAllowed(nSpell, METAMAGIC_EMPOWER))
            {
                nMeta = METAMAGIC_EMPOWER;
                nSpellLevel +=2;
            } else if (nMetaStart < 1 && (nSpellLevel + 1) == nCircle && GetHasFeat(FEAT_EXTEND_SPELL) && CU_GetMetaMagicAllowed(nSpell, METAMAGIC_EXTEND))
            {
                nMeta = METAMAGIC_EXTEND;
                nSpellLevel ++;
                SetLocalInt(OBJECT_SELF, "MetaStart", 1);
            } else if (nMetaStart < 2 && (nSpellLevel + 1) == nCircle && GetHasFeat(FEAT_STILL_SPELL) && CU_GetMetaMagicAllowed(nSpell, METAMAGIC_STILL))
            {
                SetLocalInt(OBJECT_SELF, "MetaStart", 2);
                nMeta = METAMAGIC_STILL;
                nSpellLevel ++;
            }  else if ((nSpellLevel + 1) == nCircle && GetHasFeat(FEAT_SILENCE_SPELL) && CU_GetMetaMagicAllowed(nSpell, METAMAGIC_SILENT))
            {
                nMeta = METAMAGIC_SILENT;
                nSpellLevel ++;
            } else if ((nSpellLevel + 4) == nCircle && GetHasFeat(FEAT_QUICKEN_SPELL) && CU_GetMetaMagicAllowed(nSpell, METAMAGIC_QUICKEN))
            {
                nMeta = METAMAGIC_QUICKEN;
                nSpellLevel ++;
            }
            if (nCircle == nSpellLevel)
            {
                string sName = CU_GetSpellName(nSpell);
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
                    case METAMAGIC_QUICKEN:
                    sName = "Quickened " + sName;
                    break;
                    case METAMAGIC_SILENT:
                    sName = "Silent " + sName;
                    break;
                    case METAMAGIC_STILL:
                    sName = "Still " + sName;
                    break;
                }
                SetCustomToken(299 + nView, sName);
                SetLocalInt(OBJECT_SELF, "View_Spell_Id_" + IntToString(nView), nSpell);
                SetLocalInt(OBJECT_SELF, "View_Spell_Meta_" + IntToString(nView), nMeta);
                if (GetLocalInt(OBJECT_SELF, "MetaStart"))
                {
                    SetLocalInt(OBJECT_SELF, "SpellScanCurrent", x);
                } else {
                    SetLocalInt(OBJECT_SELF, "SpellScanCurrent", x + 1);
                }
                return TRUE;
            }
        }
    }
    SetLocalInt(OBJECT_SELF, "SpellScanCurrent", 801);
    return FALSE;
}
