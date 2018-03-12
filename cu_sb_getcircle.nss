#include "cu_spells"
int StartingConditional()
{
    int nCircle = GetLocalInt(OBJECT_SELF, "Spellbook_Circle");
    int nCasterLevel = CU_GetCasterLevel(OBJECT_SELF);
    // casterlevel is never more then 20, since spell progression stops then
    if (nCasterLevel > 20) nCasterLevel = 20;
    SetCustomToken(101, IntToString(nCircle));
    int nClass = GetLocalInt(OBJECT_SELF, "SpellClass");
    int nMaxCircle = (nCasterLevel + 1) / 2;
    if (nClass == CLASS_TYPE_RANGER || nClass == CLASS_TYPE_PALADIN)
    {
        nMaxCircle = (nCasterLevel - 4) /3;
        if (nCasterLevel == 3) nMaxCircle = 0;
        if (nMaxCircle > 4) nMaxCircle = 4;
    }
    int nMod = CU_GetCasterMod();
    int nAbility = CU_GetCasterAbility();
    int nScore = GetAbilityScore(OBJECT_SELF, nAbility);
    if ((nMaxCircle + 10) > nScore) nMaxCircle = nScore - 10;
    if (nCircle > nMaxCircle)
        return FALSE;
    int nMinimumLevel = (nCircle * 2) - 1;
    int nSpells;
    if (nCircle <= nMaxCircle)
    {
        if (nClass == CLASS_TYPE_WIZARD)
        {
            int nMinimumLevel = (nCircle * 2) - 1;
            if (nCircle != 9)
            {
                switch (nCasterLevel - nMinimumLevel)
                {
                    case 0:
                        nSpells = 1;
                        break;
                    case 1:
                    case 2:
                        nSpells = 2;
                        break;
                    case 3:
                    case 4:
                    case 5:
                        nSpells = 3;
                        break;
                    default:
                        nSpells = 4;
                        break;
                }
            } else {
                nSpells = nCasterLevel - nMinimumLevel + 1;
                if (nSpells > 4) nSpells = 4;
            }
            if (nCasterLevel == 20 && nCircle == 8) nSpells++;
            int nBonusSpells = ((nMod + 4 - nCircle) /4);
            if (nBonusSpells > 0)
            {
                nSpells += nBonusSpells;
                if (nSpells > 9) nSpells = 9;
            }
            if (nCircle == 0 && nCasterLevel > 1) nSpells = 4;
            if (nCircle == 0 && nCasterLevel == 1) nSpells = 3;
        } // The Cleric Spell progression
        else if (nClass == CLASS_TYPE_CLERIC)
        {
            int nMinimumLevel = (nCircle * 2) - 1;
            if (nMinimumLevel < 1) nMinimumLevel = 1;
            if (nCircle != 9)
            {
                switch (nCasterLevel - nMinimumLevel)
                {
                    case 0:
                        nSpells = 2;
                        break;
                    case 1:
                    case 2:
                        nSpells = 3;
                        break;
                    case 3:
                    case 4:
                    case 5:
                        nSpells = 4;
                        break;
                    case 6:
                    case 7:
                    case 8:
                    case 9:
                        nSpells = 5;
                        break;
                    default:
                        nSpells = 6;
                        break;
                }
            if (nCircle == 0 && nSpells < 6) nSpells++;
            }else {
                nSpells = nCasterLevel - nMinimumLevel + 2;
                if (nSpells > 5) nSpells = 5;
            }
            int nBonusSpells = ((nMod + 4 - nCircle) /4);
            if (nBonusSpells > 0 && nCircle != 0)
            {
               nSpells += nBonusSpells;
               if (nSpells > 9) nSpells = 9;
            }
            if (nCasterLevel == 20 && nCircle == 8) nSpells++;
        }
        else if (nClass == CLASS_TYPE_DRUID)
        {
            int nMinimumLevel = (nCircle * 2) - 1;
            if (nMinimumLevel < 1) nMinimumLevel = 1;
            if (nCircle != 9)
            {
                switch (nCasterLevel - nMinimumLevel)
                {
                    case 0:
                        nSpells = 1;
                        break;
                    case 1:
                    case 2:
                        nSpells = 2;
                        break;
                    case 3:
                    case 4:
                    case 5:
                        nSpells = 3;
                        break;
                    case 6:
                    case 7:
                    case 8:
                    case 9:
                        nSpells = 4;
                        break;
                    default:
                        nSpells = 5;
                        break;
                }
            if (nCircle == 0 && nSpells < 6) nSpells++;
            if (nCircle == 0 && nSpells < 6) nSpells++;
            }else {
                nSpells = nCasterLevel - nMinimumLevel + 2;
                if (nSpells > 5) nSpells = 5;
            }
            int nBonusSpells = ((nMod + 4 - nCircle) /4);
            if (nBonusSpells > 0 && nCircle != 0)
            {
               nSpells += nBonusSpells;
               if (nSpells > 9) nSpells = 9;
            }
            if (nCasterLevel == 20 && nCircle == 8) nSpells++;
        }  else // rangers and paladins
        {
            int nMinimumLevel = (nCircle * 3) + 4;
            int nDif = nCasterLevel - nMinimumLevel;
            if (nCircle < 3) nDif--;
            if (nCircle = 1 && nDif > 1) nDif--;
            if (nDif < 1)
            {
                nSpells = 0;
            } else if (nDif < (9 - nCircle))
            {
                nSpells = 1;
            } else if (nDif < (14 - 2 * nCircle))
            {
                nSpells = 2;
            } else {
                nSpells = 3;
            }
            int nBonusSpells = ((nMod + 4 - nCircle) /4);
            if (nBonusSpells > 0 && nCircle != 0)
            {
               nSpells += nBonusSpells;
               if (nSpells > 9) nSpells = 9;
            }
            if (nCircle == 0) nSpells = 0;
        }
    } else nSpells = 0;
    SetLocalInt(OBJECT_SELF, "Current_Slot", 0);
    SetLocalInt(OBJECT_SELF, "Num_Spells", nSpells);
    return TRUE;
}
