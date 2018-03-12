const int TARGET_TYPE_SELF = 0x01;
const int TARGET_TYPE_OTHERS = 0x02;
const int TARGET_TYPE_GROUND = 0x04;
const int TARGET_TYPE_ITEMS = 0x08;
const int TARGET_TYPE_DOORS = 0x10;
const int TARGET_TYPE_PLACEABLES = 0x20;

// MyResistSpell, but works for the henchman
int CU_MyResistSpell(object oCaster, object oTarget, float fDelay = 0.0);
// GetCasterLevel, but works for the henchman
int CU_GetCasterLevel(object oCreature);
// gets the dc for spells, working for the henchman
int CU_GetSpellSaveDC();
// gets the level of the spell, if not castable, innate is returned
int CU_GetSpellLevel(int nSpell, object oCaster = OBJECT_SELF);
// gets the spell id of a scroll. returns -1 on error.
int GetScrollSpellId(object oScroll);
// get2dastring but uses caching
string CU_Get2DAString(string s2D, string sColumn, int nRow);
// returns the name of nSpell
string CU_GetSpellName(int nSpell);
// same as ActionCastSpellAtLocation(), but works with the spellbook system
void CU_ActionCastSpellAtLocation(int nSpell, location lTargetLocation, int nMetaMagic=METAMAGIC_ANY, int bCheat=FALSE, int nProjectilePathType=PROJECTILE_PATH_TYPE_DEFAULT, int bInstantSpell=FALSE);
// same as ActionCastSpellAtObject(), but works with the spellbook system
void CU_ActionCastSpellAtObject(int nSpell, object oTarget, int nMetaMagic=METAMAGIC_ANY, int bCheat=FALSE, int nDomainLevel=0, int nProjectilePathType=PROJECTILE_PATH_TYPE_DEFAULT, int bInstantSpell=FALSE);
// same as GetHasSpell(), but works with the spellbook system
int CU_GetHasSpell(int nSpell, object oCreature = OBJECT_SELF);
// uses the format "0x####" etc.
int CU_HexToInt(string sHex);
int CU_GetMetaMagicAllowed(int nSpell, int nMetaMagic);
// same as GetMetaMagicFeat(), but works with the spellbook system
int CU_GetMetaMagicFeat();
// call in the cleric's onspawn script
void CU_LearnClericSpells();
// called from the spellhook
void AOECheck();
void CU_RestoreSpells();
void CU_DoMetaMagic(int nMetaMagic);
// Determine whether oCreature has tTalent.
int CU_GetCreatureHasTalent(talent tTalent, object oCreature=OBJECT_SELF);
// sets whether the henchman known nSpell
// nSpell = SPELL_*
void CU_SetSpellKnown(int nSpell, int bKnown = TRUE);
int CU_GetCasterMod(object oCreature = OBJECT_SELF);
int CU_GetCasterAbility(object oCreature = OBJECT_SELF);
int CU_IsSpellSpontaneous(int nSpell);
void CU_LearnDruidSpells();
void CU_LearnRangerSpells();
void CU_LearnPaladinSpells();
// Sets up a spellslot with the given spell and metamagic.
// If the spell cannot be learned, or if the spell is in the wrong circle, casting it will fail.
void CU_SetSpellSlot(int nCircle, int nSlot, int nSpell, int nMetaMagic);
// Get the best talent (i.e. closest to nCRMax without going over) of oCreature,
// within nCategory.
// - nCategory: TALENT_CATEGORY_*
// - nCRMax: Challenge Rating of the talent
// - oCreature
talent CU_GetCreatureTalentBest(int nCategory, int nCRMax, object oCreature=OBJECT_SELF);
void CU_ActionUseTalentOnObject(talent tChosenTalent, object oTarget);
void CU_ActionUseTalentAtLocation(talent tChosenTalent, location lTargetLocation);
talent CU_GetCreatureTalentRandom(int nCategory, object oCreature=OBJECT_SELF);
void CheckBonusSpellsSlots();

void CheckBonusSpellsSlots()
{
    int nOldScore = GetLocalInt(OBJECT_SELF, "CastScore");
    int nAbility = CU_GetCasterAbility();
    int nScore = GetAbilityScore(OBJECT_SELF, nAbility);
    if (nScore >= nOldScore) return;
    int nCircle, nSlot;
    int nCasterLevel = CU_GetCasterLevel(OBJECT_SELF);
    // Spell progression stops at level 20
    if (nCasterLevel > 20) nCasterLevel = 20;
    int nClass = GetLocalInt(OBJECT_SELF, "SpellClass");
    int nMaxCircle = (nCasterLevel + 1) / 2;
    if (nClass == CLASS_TYPE_RANGER || nClass == CLASS_TYPE_PALADIN)
    {
        nMaxCircle = (nCasterLevel - 4) /3;
        if (nCasterLevel == 3) nMaxCircle = 0;
        if (nMaxCircle < 0) return;
        if (nMaxCircle > 4) nMaxCircle = 4;
    }
    int nMod = CU_GetCasterMod();
    if ((nMaxCircle + 10) > nScore) nMaxCircle = nScore - 10;
    int nSpells;
    SetLocalInt(OBJECT_SELF, "CastScore", nScore);
    for (nCircle = 0; nCircle < 10; nCircle++)
    {
        if (nCircle <= nMaxCircle)
        {
            // The wizard spell progression
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
             } else if (nClass == CLASS_TYPE_DRUID)
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
            } else             // rangers and paladins
            {
                int nMinimumLevel = (nCircle * 3) + 4;
                int nDif = nCasterLevel - nMinimumLevel;
                if (nCircle < 3) nDif--;
                if (nCircle == 1 && nDif > 1) nDif--;
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
        for (nSlot = 1; nSlot < 10; nSlot++)
        {
            int nSpellId = GetLocalInt(OBJECT_SELF, "Memorise_" + IntToString(nCircle) + "_" + IntToString(nSlot)) -1;
            int nMem = GetLocalInt(OBJECT_SELF, "Memorised_" + IntToString(nCircle) + "_" + IntToString(nSlot));
            int nMemNum = GetLocalInt(OBJECT_SELF, "MemNum_" + IntToString(nSpellId));
            if (nSlot > nSpells && nMem)
            {
                SetLocalInt(OBJECT_SELF, "Memorised_" + IntToString(nCircle) + "_" + IntToString(nSlot), FALSE);
                SetLocalInt(OBJECT_SELF, "MemNum_" + IntToString(nSpellId), nMemNum -1);
                int nSub = 1;
                string sSubRad = CU_Get2DAString("spells", "SubRadSpell" +IntToString(nSub), nSpellId);
                while (sSubRad != "" && nSub < 6)
                {
                    int nSubId = StringToInt(sSubRad);
                    SetLocalInt(OBJECT_SELF, "MemNum_" + IntToString(nSubId), nMemNum - 1);
                    nSub++;
                }
            }
        }
    }
}

void CU_DoMetaMagic(int nMetaMagic)
{
    SetLocalInt(OBJECT_SELF, "MetaMagic", nMetaMagic);
    if (!GetLocalInt(OBJECT_SELF, "UseSpellBook")) return;
    int nFeatNum;
    switch (nMetaMagic)
    {
        case METAMAGIC_QUICKEN:
        nFeatNum = 40;
        break;
        case METAMAGIC_SILENT:
        nFeatNum = 41;
        break;
        case METAMAGIC_STILL:
        nFeatNum = 42;
        break;
        default:
        return;
    }
    object oHide = GetItemInSlot(INVENTORY_SLOT_CARMOUR);
    if (!GetIsObjectValid(oHide))
    {
        SendMessageToPC(GetFirstPC(), "Metamagic Error: Henchman has no hide");
        return;
    }
    itemproperty ipMeta = ItemPropertyBonusFeat(nFeatNum);
    AddItemProperty(DURATION_TYPE_TEMPORARY, ipMeta, oHide, 3.0);
}

void CU_ActionUseTalentAtLocation(talent tChosenTalent, location lTargetLocation)
{
    if (GetTypeFromTalent(tChosenTalent) != TALENT_TYPE_SPELL
    || !GetLocalInt(OBJECT_SELF, "UseSpellBook")
    || !CU_GetHasSpell(GetIdFromTalent(tChosenTalent)))
    {
        if (GetLocalInt(OBJECT_SELF, "UseSpellBook"))
            ActionDoCommand(SetLocalInt(OBJECT_SELF, "NormalSpellLevel", TRUE));
        ActionUseTalentAtLocation(tChosenTalent, lTargetLocation);
        return;
    }
    CU_ActionCastSpellAtLocation(GetIdFromTalent(tChosenTalent), lTargetLocation);
}

void CU_ActionUseTalentOnObject(talent tChosenTalent, object oTarget)
{
    if (GetTypeFromTalent(tChosenTalent) != TALENT_TYPE_SPELL
    || !GetLocalInt(OBJECT_SELF, "UseSpellBook")
    || !CU_GetHasSpell(GetIdFromTalent(tChosenTalent)))
    {
        if (GetLocalInt(OBJECT_SELF, "UseSpellBook"))
            ActionDoCommand(SetLocalInt(OBJECT_SELF, "NormalSpellLevel", TRUE));
        ActionUseTalentOnObject(tChosenTalent, oTarget);
        return;
    }
    CU_ActionCastSpellAtObject(GetIdFromTalent(tChosenTalent), oTarget);
}

talent CU_GetCreatureTalentRandom(int nCategory, object oCreature=OBJECT_SELF)
{
    talent tStandard = CU_GetCreatureTalentRandom(nCategory, oCreature);
    if (!GetLocalInt(oCreature, "UseSpellBook")) return tStandard;
    // See wether we have a custom spell talent
    int nCasterLevel = CU_GetCasterLevel(oCreature);
    int nMaxCircle = (nCasterLevel + 1) / 2;
    int nAbility = CU_GetCasterAbility(oCreature);
    int nScore = GetAbilityScore(oCreature, nAbility);
    if ((nMaxCircle + 10) > nScore) nMaxCircle = nScore - 10;
    int nCircle = Random(nMaxCircle + 1);
    int nSlotStart = Random(9) + 1;
    int nSlot;
    talent tCustom;
    // find a spell in that circle matching the talent type. Go down until found
    for (; nCircle >= 0; nCircle--)
    {
        for (nSlot = nSlotStart; nSlot > 0; nSlot--)
        {
            int nId = GetLocalInt(OBJECT_SELF, "Memorise_" + IntToString(nCircle) + "_" + IntToString(nSlot)) - 1;
            int bMemorised = GetLocalInt(OBJECT_SELF, "Memorised_" + IntToString(nCircle) + "_" + IntToString(nSlot));
            if (bMemorised)
            {
                // check the type
                string sCat = CU_Get2DAString("spells", "Category", nId);
                if (sCat != "")
                {
                    if (StringToInt(sCat) == nCategory)
                    {
                        tCustom = TalentSpell(nId);
                        break;
                    }
                }
            }
        }
        nSlotStart = 9;
    }
    if (!GetIsTalentValid(tCustom) || (Random(2) && GetIsTalentValid(tStandard)))
        return tStandard;
    return tCustom;
}

talent CU_GetCreatureTalentBest(int nCategory, int nCRMax, object oCreature=OBJECT_SELF)
{
    talent tStandard = GetCreatureTalentBest(nCategory, nCRMax, oCreature);
    if (!GetLocalInt(oCreature, "UseSpellBook")) return tStandard;
    // See wether we have a custom spell talent
    int nCR = 0;
    if (GetTypeFromTalent(tStandard) == TALENT_TYPE_SPELL)
    {
        nCR = StringToInt(CU_Get2DAString("spells", "Innate", GetIdFromTalent(tStandard)));
    }
    // we need to get the best spell
    int nCircle = ((nCRMax + 1) / 2);
    int nSlot = 1;
    talent tCustom;
    // find a spell in that circle matching the talent type. Go down until found
    for (; nCircle >= 0; nCircle--)
    {
        for (nSlot = 1; nSlot < 9; nSlot++)
        {
            int nId = GetLocalInt(OBJECT_SELF, "Memorise_" + IntToString(nCircle) + "_" + IntToString(nSlot)) - 1;
            int bMemorised = GetLocalInt(OBJECT_SELF, "Memorised_" + IntToString(nCircle) + "_" + IntToString(nSlot));
            if (bMemorised)
            {
                // check the type
                string sCat = CU_Get2DAString("spells", "Category", nId);
                if (sCat != "")
                {
                    if (StringToInt(sCat) == nCategory)
                    {
                        tCustom = TalentSpell(nId);
                        break;
                    }
                }
            }
        }
    }
    if (!GetIsTalentValid(tCustom) || nCR > (nCircle * 2 -1))
        return tStandard;
    return tCustom;
}

int CU_GetCreatureHasTalent(talent tTalent, object oCreature=OBJECT_SELF)
{
    int nType = GetTypeFromTalent(tTalent);
    if (nType != TALENT_TYPE_SPELL || !GetLocalInt(oCreature, "UseSpellBook"))
        return GetCreatureHasTalent(tTalent, oCreature);
    int nSpell = GetIdFromTalent(tTalent);
    return (CU_GetHasSpell(nSpell, oCreature) || GetCreatureHasTalent(tTalent, oCreature));
}

void CU_SetSpellSlot(int nCircle, int nSlot, int nSpell, int nMetaMagic)
{
    int nOldSpell = GetLocalInt(OBJECT_SELF, "Memorise_" + IntToString(nCircle) + "_" + IntToString(nSlot)) -1;
    int nOldSpellMemorised = GetLocalInt(OBJECT_SELF, "Memorised_" + IntToString(nCircle) + "_" + IntToString(nSlot));
    if (nOldSpellMemorised && (nOldSpell != -1))
    {
        int nMemNum = GetLocalInt(OBJECT_SELF, "MemNum_" + IntToString(nOldSpell));
        SetLocalInt(OBJECT_SELF, "MemNum_" + IntToString(nOldSpell), --nMemNum);
    }
    SetLocalInt(OBJECT_SELF, "Memorise_" + IntToString(nCircle) + "_" + IntToString(nSlot), nSpell + 1);
    SetLocalInt(OBJECT_SELF, "Memorised_" + IntToString(nCircle) + "_" + IntToString(nSlot), FALSE);
    SetLocalInt(OBJECT_SELF, "MetaMagic_" + IntToString(nCircle) + "_" + IntToString(nSlot), nMetaMagic);
}

int CU_IsSpellSpontaneous(int nSpell)
{
    if (nSpell == SPELL_CURE_MINOR_WOUNDS
    || nSpell == SPELL_CURE_LIGHT_WOUNDS
    || nSpell == SPELL_CURE_MODERATE_WOUNDS
    || nSpell == SPELL_CURE_SERIOUS_WOUNDS
    || nSpell == SPELL_CURE_CRITICAL_WOUNDS
    || nSpell == SPELL_INFLICT_MINOR_WOUNDS
    || nSpell == SPELL_INFLICT_LIGHT_WOUNDS
    || nSpell == SPELL_INFLICT_MODERATE_WOUNDS
    || nSpell == SPELL_INFLICT_SERIOUS_WOUNDS
    || nSpell == SPELL_INFLICT_CRITICAL_WOUNDS)
        return TRUE;
    return FALSE;
}

void CU_LearnDruidSpells()
{
    int x;
    string sDruid;
    for (x = 0; x < 800; x++)
    {
        sDruid = CU_Get2DAString("spells", "Druid", x);
        if (sDruid != "")
        {
            SetLocalInt(OBJECT_SELF, "Known_" + IntToString(x), TRUE);
        }
    }
}

void CU_LearnRangerSpells()
{
    int x;
    string sRanger;
    for (x = 0; x < 800; x++)
    {
        sRanger = CU_Get2DAString("spells", "Ranger", x);
        if (sRanger != "")
        {
            SetLocalInt(OBJECT_SELF, "Known_" + IntToString(x), TRUE);
        }
    }
}

void CU_LearnPaladinSpells()
{
    int x;
    string sPaladin;
    for (x = 0; x < 800; x++)
    {
        sPaladin= CU_Get2DAString("spells", "Paladin", x);
        if (sPaladin != "")
        {
            SetLocalInt(OBJECT_SELF, "Known_" + IntToString(x), TRUE);
        }
    }
}

void CU_LearnClericSpells()
{
    int x;
    string sCleric;
    for (x = 0; x < 800; x++)
    {
        sCleric = CU_Get2DAString("spells", "Cleric", x);
        if (sCleric != "")
        {
            SetLocalInt(OBJECT_SELF, "Known_" + IntToString(x), TRUE);
        }
    }
    // domain spells
    string sFeat, sSpell;
    int y, nSpell, nDomainSpells, z;
    for (x = 0; x < 22; x++)
    {
        sFeat = CU_Get2DAString("domains", "GrantedFeat", x);
        if (GetHasFeat(StringToInt(sFeat)))
        {
            for (y = 1; y < 10; y++)
            {
                sSpell = CU_Get2DAString("domains", "Level_" + IntToString(y), x);
                if (sSpell != "")
                {
                    nSpell = StringToInt(sSpell);
                    int nReturn = 0;
                    // Set up domain information...
                    // see if the domainspell is granted like this by another domain...
                    if (nDomainSpells > 0)
                    {
                        for (z = 1; z <= nDomainSpells; z++)
                        {
                            if (GetLocalInt(OBJECT_SELF, "DomainSpellId_" + IntToString(z)) == nSpell
                            && GetLocalInt(OBJECT_SELF, "DomainSpellCircle_" + IntToString(z)) == y)
                            {
                                nReturn = 1;
                                break;
                            }
                        }
                    }
                    if (!nReturn)
                    {
                        // spell wasn't known in this circle...
                        nDomainSpells++;
                        SetLocalInt(OBJECT_SELF, "DomainSpellCircle_" + IntToString(nDomainSpells), y);
                        SetLocalInt(OBJECT_SELF, "DomainSpellId_" + IntToString(nDomainSpells), nSpell);
                    }
                }
            }
        }
    }
    SetLocalInt(OBJECT_SELF, "DomainSpells", nDomainSpells);
}

int CU_GetCasterAbility(object oCreature = OBJECT_SELF)
{
    int nAbility;
    int nClass = GetLocalInt(oCreature, "SpellClass");
    if (nClass == CLASS_TYPE_WIZARD)
    {
        nAbility = ABILITY_INTELLIGENCE;
    } else if (nClass == CLASS_TYPE_CLERIC || nClass == CLASS_TYPE_DRUID
        || nClass == CLASS_TYPE_PALADIN || nClass == CLASS_TYPE_RANGER)
    {
        nAbility = ABILITY_WISDOM;
    }
    return nAbility;
}

int CU_GetCasterMod(object oCreature = OBJECT_SELF)
{
    int nAbility;
    int nClass = GetLocalInt(oCreature, "SpellClass");
    if (nClass == CLASS_TYPE_WIZARD)
    {
        nAbility = ABILITY_INTELLIGENCE;
    } else if (nClass == CLASS_TYPE_CLERIC || nClass == CLASS_TYPE_DRUID
    || nClass == CLASS_TYPE_PALADIN || nClass == CLASS_TYPE_RANGER)
    {
        nAbility = ABILITY_WISDOM;
    }
    return GetAbilityModifier(nAbility, oCreature);
}

void CU_SetSpellKnown(int nSpell, int bKnown = TRUE)
{
    SetLocalInt(OBJECT_SELF, "Known_" + IntToString(nSpell), bKnown);
}


int CU_GetMetaMagicAllowed(int nSpell, int nMetaMagic)
{
    string sMetaMagic = CU_Get2DAString("spells", "MetaMagic", nSpell);
    int nMeta = CU_HexToInt(sMetaMagic);
    if (nMeta & nMetaMagic)
        return TRUE;
    return FALSE;
}

void ScanForAOE(location lScan, int nDC, int nMeta)
{
    // incase it isn't found because it is too near
    vector vNew = GetPositionFromLocation(lScan);
    vNew.z += 0.5;
    location lNew = Location(GetAreaFromLocation(lScan), vNew, GetFacingFromLocation(lScan));
    int nScan = 1;
    object oAOE = GetNearestObjectToLocation(OBJECT_TYPE_AREA_OF_EFFECT, lScan, nScan);
    while (GetIsObjectValid(oAOE))
    {
        if (!GetLocalInt(oAOE, "SAVE_DC"))
        {
            SetLocalInt(oAOE, "SAVE_DC", nDC);
            SetLocalInt(oAOE, "METAMAGIC", nMeta);
            return;
        }
        oAOE = GetNearestObjectToLocation(OBJECT_TYPE_AREA_OF_EFFECT, lScan, ++nScan);
    }
}

void AOECheck()
{
    if (GetLocalInt(OBJECT_SELF, "UseSpellBook") && !GetLocalInt(OBJECT_SELF, "NormalSpellLevel"))
    {
        DelayCommand(0.1, ScanForAOE(GetSpellTargetLocation(), CU_GetSpellSaveDC(), CU_GetMetaMagicFeat()));
    }
    //SendMessageToPC(GetFirstPC(), IntToString(CU_GetMetaMagicFeat()));
}

int CU_GetHasSpell(int nSpell, object oCreature = OBJECT_SELF)
{
    if (!GetLocalInt(oCreature, "UseSpellBook"))
        return GetHasSpell(nSpell, oCreature);
    int nMemNum = GetLocalInt(oCreature, "MemNum_" + IntToString(nSpell));
    // spells known in the normal way count too.
    nMemNum += GetHasSpell(nSpell, oCreature);
    // clerics may be able to cast spontaneously
    if (nMemNum == 0 && GetLocalInt(oCreature, "SpellClass") == CLASS_TYPE_CLERIC)
    {
        if (CU_IsSpellSpontaneous(nSpell))
        {
            int nCircle = CU_GetSpellLevel(nSpell, oCreature);
            int x;
            for (x = 1; x < 10; x++)
            {
                int nMem = GetLocalInt(oCreature, "Memorised_" + IntToString(nCircle) + "_" + IntToString(x));
                if (nMem)
                {
                    int nId = GetLocalInt(oCreature, "Memorise_" + IntToString(nCircle) + "_" + IntToString(x)) -1;
                    int bKnown = GetLocalInt(oCreature, "Known_" + IntToString(nId));
                    if (bKnown)
                    {
                        return 1;
                    }
                }
            }
        }
    }
    return nMemNum;
}

int CU_GetMetaMagicFeat()
{
    if (GetObjectType(OBJECT_SELF) == OBJECT_TYPE_AREA_OF_EFFECT)
    {
        object oCaster = GetAreaOfEffectCreator();
        if (!GetLocalInt(oCaster, "UseSpellBook"))
            return GetMetaMagicFeat();
        if (!GetLocalInt(OBJECT_SELF, "SAVE_DC"))
            return (GetLocalInt(oCaster,"MetaMagic"));
        return GetLocalInt(OBJECT_SELF, "METAMAGIC");
    }
    if (!GetLocalInt(OBJECT_SELF, "UseSpellBook"))
    {
        return GetMetaMagicFeat();
    }
    return (GetLocalInt(OBJECT_SELF,"MetaMagic"));
}

void CU_ActionCastSpellAtObject(int nSpell, object oTarget, int nMetaMagic=METAMAGIC_ANY, int bCheat=FALSE, int nDomainLevel=0, int nProjectilePathType=PROJECTILE_PATH_TYPE_DEFAULT, int bInstantSpell=FALSE)
{
    if (!GetLocalInt(OBJECT_SELF, "UseSpellBook") || bCheat)
    {
        if (GetLocalInt(OBJECT_SELF, "UseSpellBook"))
        {
            ActionDoCommand(SetLocalInt(OBJECT_SELF, "NormalSpellLevel", TRUE));
            ActionDoCommand(SetLocalInt(OBJECT_SELF, "MetaMagic", nMetaMagic));
        }
        ActionCastSpellAtObject(nSpell, oTarget, nMetaMagic, bCheat, nDomainLevel, nProjectilePathType, bInstantSpell);
        return;
    }
    if (GetHasSpell(nSpell, OBJECT_SELF) > 0)
    {
        // if it is known normally, cast it as normal
        ActionCastSpellAtObject(nSpell, oTarget, nMetaMagic, FALSE, nDomainLevel, nProjectilePathType, bInstantSpell);
        return;
    }
    string sMaster = CU_Get2DAString("spells", "Master", nSpell);
    int nToFind = nSpell;
    if (sMaster != "") nToFind = StringToInt(sMaster);
    int nDone;
    int nMetaM = nMetaMagic;
    int nIsCircle = CU_GetSpellLevel(nToFind);
    int nDomain;
    int nDomainId = -1;
    int nDomainDone = 0;
    while (!nDomainDone)
    {
        if (GetLocalInt(OBJECT_SELF, "SpellClass") == CLASS_TYPE_CLERIC)
        {
            int nDomainSpells = GetLocalInt(OBJECT_SELF, "DomainSpells");
            while ((nDomainId != nToFind) && (nDomainSpells > nDomain))
            {
                nDomainId = GetLocalInt(OBJECT_SELF, "DomainSpellId_" + IntToString(++nDomain));
            }
            if (nToFind == nDomainId)
            {
                nIsCircle = GetLocalInt(OBJECT_SELF, "DomainSpellCircle_" + IntToString(nDomain));
            } else {
                nDomainDone = 1;
                nIsCircle = CU_GetSpellLevel(nToFind);
            }
        } else {
            nDomainDone = 1;
        }
        nDone = 0;
        nMetaM = nMetaMagic;
        while (!nDone)
        {
            int nCircle = nIsCircle;
            if (nMetaMagic == METAMAGIC_ANY)
            {
                if (nMetaM == METAMAGIC_ANY)
                {
                    nMetaM = METAMAGIC_MAXIMIZE;
                } else if (nMetaM == METAMAGIC_MAXIMIZE)
                {
                    nMetaM = METAMAGIC_EMPOWER;
                } else if (nMetaM == METAMAGIC_EMPOWER)
                {
                    nMetaM = METAMAGIC_EXTEND;
                } else if (nMetaM == METAMAGIC_EXTEND)
                {
                    nMetaM = METAMAGIC_SILENT;
                } else if (nMetaM == METAMAGIC_SILENT)
                {
                    nMetaM = METAMAGIC_STILL;
                } else if (nMetaM == METAMAGIC_STILL)
                {
                    nMetaM = METAMAGIC_QUICKEN;
                } else if (nMetaM == METAMAGIC_QUICKEN)
                {
                    nMetaM = METAMAGIC_NONE;
                    nDone = 1;
                } else {return;}
            } else {
                nDone = 1;
            }
            switch (nMetaM)
            {
                case METAMAGIC_EMPOWER:
                nCircle += 2;
                break;
                case METAMAGIC_EXTEND:
                case METAMAGIC_STILL:
                case METAMAGIC_SILENT:
                nCircle += 1;
                break;
                case METAMAGIC_MAXIMIZE:
                nCircle += 3;
                break;
                case METAMAGIC_QUICKEN:
                nCircle += 4;
                break;
            }
            int x;
            for (x = 1; x < 9; x++)
            {
                int nId = GetLocalInt(OBJECT_SELF, "Memorise_" + IntToString(nCircle) + "_" + IntToString(x)) - 1;
                int bMemorised = GetLocalInt(OBJECT_SELF, "Memorised_" + IntToString(nCircle) + "_" + IntToString(x));
                int nMeta = GetLocalInt(OBJECT_SELF, "MetaMagic_" + IntToString(nCircle) + "_" + IntToString(x));
                if (nId == nToFind && bMemorised && nMeta == nMetaM)
                {
                    int nMemNum = GetLocalInt(OBJECT_SELF, "MemNum_" + IntToString(nToFind));
                    SetLocalInt(OBJECT_SELF, "Memorised_" + IntToString(nCircle) + "_" + IntToString(x), FALSE);
                    SetLocalInt(OBJECT_SELF, "MemNum_" + IntToString(nToFind), nMemNum -1);
                    if (nToFind != nSpell)
                    {
                        int nSub = 1;
                        string sSubRad = CU_Get2DAString("spells", "SubRadSpell" +IntToString(nSub), nToFind);
                        while (sSubRad != "" && nSub < 6)
                        {
                            int nSubId = StringToInt(sSubRad);
                            SetLocalInt(OBJECT_SELF, "MemNum_" + IntToString(nSubId), nMemNum - 1);
                            nSub++;
                        }
                    }
                    ActionDoCommand(SetLocalInt(OBJECT_SELF, "NormalSpellLevel", FALSE));
                    ActionDoCommand(CU_DoMetaMagic(nMetaM));
                    ActionCastSpellAtObject(nSpell, oTarget, nMetaM, TRUE, nDomainLevel, nProjectilePathType, bInstantSpell);
                    return;
                }
            }
        }
    }
    // trying to cast spontaneously now
    if (GetLocalInt(OBJECT_SELF, "SpellClass") == CLASS_TYPE_CLERIC && (nMetaMagic == METAMAGIC_ANY || nMetaMagic == METAMAGIC_NONE))
    {
        string sSpont = CU_Get2DAString("spells", "SpontaneouslyCast", nSpell);
        if (sSpont == "1")
        {
            int nCircle = CU_GetSpellLevel(nSpell, OBJECT_SELF);
            int x;
            for (x = 1; x < 10; x++)
            {
                int nMem = GetLocalInt(OBJECT_SELF, "Memorised_" + IntToString(nCircle) + "_" + IntToString(x));
                if (nMem)
                {
                    int nId = GetLocalInt(OBJECT_SELF, "Memorise_" + IntToString(nCircle) + "_" + IntToString(x)) -1;
                    int bKnown = GetLocalInt(OBJECT_SELF, "Known_" + IntToString(nId));
                    // not a domain spell
                    if (bKnown)
                    {
                        // a spell to sacrifice is found
                        int nMemNum = GetLocalInt(OBJECT_SELF, "MemNum_" + IntToString(nId));
                        SetLocalInt(OBJECT_SELF, "Memorised_" + IntToString(nCircle) + "_" + IntToString(x), FALSE);
                        SetLocalInt(OBJECT_SELF, "MemNum_" + IntToString(nId), nMemNum -1);
                        ActionDoCommand(SetLocalInt(OBJECT_SELF, "NormalSpellLevel", FALSE));
                        ActionDoCommand(SetLocalInt(OBJECT_SELF, "MetaMagic", METAMAGIC_NONE));
                        ActionCastSpellAtObject(nSpell, oTarget, METAMAGIC_NONE, TRUE, nDomainLevel, nProjectilePathType, bInstantSpell);
                        return;
                    }
                }
            }
        }
    }
    SendMessageToPC(GetFirstPC(), GetName(OBJECT_SELF) + ": Attempted to cast but failed: " + CU_GetSpellName(nSpell));
    SendMessageToPC(GetFirstPC(), GetName(OBJECT_SELF) + ": Mem = " + IntToString(CU_GetHasSpell(nSpell)));
}

void CU_ActionCastSpellAtLocation(int nSpell, location lTargetLocation, int nMetaMagic=METAMAGIC_ANY, int bCheat=FALSE, int nProjectilePathType=PROJECTILE_PATH_TYPE_DEFAULT, int bInstantSpell=FALSE)
{
    if (!GetLocalInt(OBJECT_SELF, "UseSpellBook") || bCheat)
    {
        if (GetLocalInt(OBJECT_SELF, "UseSpellBook"))
        {
            ActionDoCommand(SetLocalInt(OBJECT_SELF, "NormalSpellLevel", TRUE));
            ActionDoCommand(SetLocalInt(OBJECT_SELF, "MetaMagic", nMetaMagic));
        }
        ActionCastSpellAtLocation(nSpell, lTargetLocation, nMetaMagic, bCheat, nProjectilePathType, bInstantSpell);
        return;
    }
    if (GetHasSpell(nSpell, OBJECT_SELF) > 0)
    {
        // if it is known normally, cast it as normal
        ActionCastSpellAtLocation(nSpell, lTargetLocation, nMetaMagic, FALSE, nProjectilePathType, bInstantSpell);
        return;
    }
    string sMaster = CU_Get2DAString("spells", "Master", nSpell);
    int nToFind = nSpell;
    if (sMaster != "") nToFind = StringToInt(sMaster);
    int nDone;
    int nIsCircle = CU_GetSpellLevel(nToFind);
    int nMetaM = nMetaMagic;
        int nDomain, nDomainId = -1;
    int nDomainDone = 0;
    while (!nDomainDone)
    {
        if (GetLocalInt(OBJECT_SELF, "SpellClass") == CLASS_TYPE_CLERIC)
        {
            int nDomainSpells = GetLocalInt(OBJECT_SELF, "DomainSpells");
            while ((nDomainId != nToFind) && (nDomainSpells > nDomain))
            {
                nDomainId = GetLocalInt(OBJECT_SELF, "DomainSpellId_" + IntToString(++nDomain));
            }
            if (nToFind == nDomainId)
            {
                nIsCircle = GetLocalInt(OBJECT_SELF, "DomainSpellCircle_" + IntToString(nDomain));
            } else {
                nDomainDone = 1;
                nIsCircle = CU_GetSpellLevel(nToFind);
            }
        } else {
            nDomainDone = 1;
        }
        nDone = 0;
        nMetaM = nMetaMagic;
        while (!nDone)
        {
            int nCircle = nIsCircle;
            if (nMetaMagic == METAMAGIC_ANY)
            {
                if (nMetaM == METAMAGIC_ANY)
                {
                    nMetaM = METAMAGIC_MAXIMIZE;
                } else if (nMetaM == METAMAGIC_MAXIMIZE)
                {
                    nMetaM = METAMAGIC_EMPOWER;
                } else if (nMetaM == METAMAGIC_EMPOWER)
                {
                    nMetaM = METAMAGIC_EXTEND;
                } else if (nMetaM == METAMAGIC_EXTEND)
                {
                    nMetaM = METAMAGIC_SILENT;
                } else if (nMetaM == METAMAGIC_SILENT)
                {
                    nMetaM = METAMAGIC_STILL;
                } else if (nMetaM == METAMAGIC_STILL)
                {
                    nMetaM = METAMAGIC_QUICKEN;
                } else if (nMetaM == METAMAGIC_QUICKEN)
                {
                    nMetaM = METAMAGIC_NONE;
                    nDone = 1;
                } else
                { return;}
            } else
            {
                nDone = 1;
            }
            switch (nMetaM)
            {
                case METAMAGIC_EMPOWER:
                nCircle += 2;
                break;
                case METAMAGIC_EXTEND:
                case METAMAGIC_STILL:
                case METAMAGIC_SILENT:
                nCircle += 1;
                break;
                case METAMAGIC_MAXIMIZE:
                nCircle += 3;
                break;
                case METAMAGIC_QUICKEN:
                nCircle += 4;
                break;
            }
            int x;
            for (x = 1; x < 9; x++)
            {
                int nId = GetLocalInt(OBJECT_SELF, "Memorise_" + IntToString(nCircle) + "_" + IntToString(x)) - 1;
                int bMemorised = GetLocalInt(OBJECT_SELF, "Memorised_" + IntToString(nCircle) + "_" + IntToString(x));
                int nMeta = GetLocalInt(OBJECT_SELF, "MetaMagic_" + IntToString(nCircle) + "_" + IntToString(x));
                if (nId == nToFind && bMemorised && nMeta == nMetaM)
                {
                    int nMemNum = GetLocalInt(OBJECT_SELF, "MemNum_" + IntToString(nToFind));
                    SetLocalInt(OBJECT_SELF, "Memorised_" + IntToString(nCircle) + "_" + IntToString(x), FALSE);
                    SetLocalInt(OBJECT_SELF, "MemNum_" + IntToString(nToFind), nMemNum -1);
                    if (nToFind != nSpell)
                    {
                        int nSub = 1;
                        string sSubRad = CU_Get2DAString("spells", "SubRadSpell" +IntToString(nSub), nToFind);
                        while (sSubRad != "" && nSub < 6)
                        {
                            int nSubId = StringToInt(sSubRad);
                            SetLocalInt(OBJECT_SELF, "MemNum_" + IntToString(nSubId), nMemNum - 1);
                            nSub++;
                        }
                    }
                    ActionDoCommand(SetLocalInt(OBJECT_SELF, "NormalSpellLevel", FALSE));
                    ActionDoCommand(CU_DoMetaMagic(nMetaM));
                    ActionCastSpellAtLocation(nSpell, lTargetLocation, nMetaM, TRUE, nProjectilePathType, bInstantSpell);
                    return;
                }
            }
        }
    }
    // trying to cast spontaneously now
    if (GetLocalInt(OBJECT_SELF, "SpellClass") == CLASS_TYPE_CLERIC && (nMetaMagic == METAMAGIC_ANY || nMetaMagic == METAMAGIC_NONE))
    {
        string sSpont = CU_Get2DAString("spells", "SpontaneouslyCast", nSpell);
        if (sSpont == "1")
        {
            int nCircle = CU_GetSpellLevel(nSpell, OBJECT_SELF);
            int x;
            for (x = 1; x < 10; x++)
            {
                int nMem = GetLocalInt(OBJECT_SELF, "Memorised_" + IntToString(nCircle) + "_" + IntToString(x));
                if (nMem)
                {
                    int nId = GetLocalInt(OBJECT_SELF, "Memorise_" + IntToString(nCircle) + "_" + IntToString(x)) -1;
                    int bKnown = GetLocalInt(OBJECT_SELF, "Known_" + IntToString(nId));
                    // not a domain spell
                    if (bKnown)
                    {
                        // a spell to sacrifice is found
                        int nMemNum = GetLocalInt(OBJECT_SELF, "MemNum_" + IntToString(nId));
                        SetLocalInt(OBJECT_SELF, "Memorised_" + IntToString(nCircle) + "_" + IntToString(x), FALSE);
                        SetLocalInt(OBJECT_SELF, "MemNum_" + IntToString(nId), nMemNum -1);
                        ActionDoCommand(SetLocalInt(OBJECT_SELF, "NormalSpellLevel", FALSE));
                        ActionDoCommand(SetLocalInt(OBJECT_SELF, "MetaMagic", METAMAGIC_NONE));
                        ActionCastSpellAtLocation(nSpell, lTargetLocation, METAMAGIC_NONE, TRUE, nProjectilePathType, bInstantSpell);
                        return;
                    }
                }
            }
        }
    }
    SendMessageToPC(GetFirstPC(), GetName(OBJECT_SELF) + ": Attempted to cast but failed: " + CU_GetSpellName(nSpell));
    SendMessageToPC(GetFirstPC(), GetName(OBJECT_SELF) + ": Mem = " + IntToString(CU_GetHasSpell(nSpell)));
}

int CU_HexToInt(string sHex)
{
    int nLen = GetStringLength(sHex) - 2;
    string sHex2 = GetStringLowerCase(GetStringRight(sHex, nLen));
    string sHexRefer = "0123456789abcdef";
    int x;
    int nValue = 0;
    string sH;
    for (x = 0; x < nLen; x++)
    {
        sH = GetSubString(sHex2, nLen - x -1, 1);
        nValue += FloatToInt(pow(16.0, IntToFloat(x))) * FindSubString(sHexRefer, sH);
    }
    return nValue;
}

int GetScrollSpellId(object oScroll)
{
    itemproperty ipSpell = GetFirstItemProperty(oScroll);
    while (GetIsItemPropertyValid(ipSpell))
    {
        if (GetItemPropertyType(ipSpell) == ITEM_PROPERTY_CAST_SPELL)
        {
             int nPropId = GetItemPropertySubType(ipSpell);
             int nID = StringToInt(CU_Get2DAString("iprp_spells", "SpellIndex", nPropId));
             return nID;
        }
        ipSpell = GetNextItemProperty(oScroll);
    }
    return -1;
}

string CU_GetSpellName(int nSpell)
{
    int nStrRef = StringToInt(CU_Get2DAString("spells", "Name", nSpell));
    return GetStringByStrRef(nStrRef);
}

int CU_GetSpellLevel(int nSpell, object oCaster = OBJECT_SELF)
{
    int nClass = GetLocalInt(oCaster, "SpellClass");
    string sColumn;
    if (nClass == CLASS_TYPE_WIZARD)
    {
        sColumn = "Wiz_Sorc";
    } else if (nClass == CLASS_TYPE_CLERIC)
    {
        sColumn = "Cleric";
    } else if (nClass == CLASS_TYPE_DRUID)
    {
        sColumn = "Druid";
    }  else if (nClass == CLASS_TYPE_RANGER)
    {
        sColumn = "Ranger";
    } else if (nClass == CLASS_TYPE_PALADIN)
    {
        sColumn = "Paladin";
    }
    string sSpellLevel = CU_Get2DAString("spells", sColumn, nSpell);
    if (sSpellLevel == "")
    {
        sSpellLevel = CU_Get2DAString("spells", "Innate", nSpell);
    }
    return StringToInt(sSpellLevel);
}

int CU_GetSpellSaveDC()
{
    object oCaster = OBJECT_SELF;
    if (GetObjectType(oCaster) == OBJECT_TYPE_AREA_OF_EFFECT)
    {
        if (GetLocalInt(GetAreaOfEffectCreator(), "UseSpellBook"))
        {
            int nDc = GetLocalInt(oCaster, "SAVE_DC");
            if (nDc) return nDc;
        }
        return GetSpellSaveDC();
    }
    if (!GetLocalInt(oCaster, "UseSpellBook") || GetLocalInt(oCaster, "NormalSpellLevel"))
            return GetSpellSaveDC();
    int nId = GetSpellId();
    int nSpellLevel = CU_GetSpellLevel(nId);
    int nMod = CU_GetCasterMod(oCaster);
    int nDC = 10 + nMod + nSpellLevel;
    string sSchool = CU_Get2DAString("spells", "School", nId);
    int nFeatEpic, nFeatGreater, nFeatFocus;
    if (sSchool == "V")
    {
        nFeatEpic = FEAT_EPIC_SPELL_FOCUS_EVOCATION;
        nFeatGreater = FEAT_GREATER_SPELL_FOCUS_EVOCATION;
        nFeatFocus = FEAT_SPELL_FOCUS_EVOCATION;
    } else
    if (sSchool == "E")
    {
        nFeatEpic = FEAT_EPIC_SPELL_FOCUS_ENCHANTMENT;
        nFeatGreater = FEAT_GREATER_SPELL_FOCUS_ENCHANTMENT;
        nFeatFocus = FEAT_SPELL_FOCUS_ENCHANTMENT;
    } else
    if (sSchool == "A")
    {
        nFeatEpic = FEAT_EPIC_SPELL_FOCUS_ABJURATION;
        nFeatGreater = FEAT_GREATER_SPELL_FOCUS_ABJURATION;
        nFeatFocus = FEAT_SPELL_FOCUS_ABJURATION;
    } else
    if (sSchool == "C")
    {
        nFeatEpic = FEAT_EPIC_SPELL_FOCUS_CONJURATION;
        nFeatGreater = FEAT_GREATER_SPELL_FOCUS_CONJURATION;
        nFeatFocus = FEAT_SPELL_FOCUS_CONJURATION;
    } else
    if (sSchool == "D")
    {
        nFeatEpic = FEAT_EPIC_SPELL_FOCUS_DIVINATION;
        nFeatGreater = FEAT_GREATER_SPELL_FOCUS_DIVINATION;
        nFeatFocus = FEAT_SPELL_FOCUS_DIVINATION;
    } else
    if (sSchool == "I")
    {
        nFeatEpic = FEAT_EPIC_SPELL_FOCUS_ILLUSION;
        nFeatGreater = FEAT_GREATER_SPELL_FOCUS_ILLUSION;
        nFeatFocus = FEAT_SPELL_FOCUS_ILLUSION;
    } else
    if (sSchool == "N")
    {
        nFeatEpic = FEAT_EPIC_SPELL_FOCUS_NECROMANCY;
        nFeatGreater = FEAT_GREATER_SPELL_FOCUS_NECROMANCY;
        nFeatFocus = FEAT_SPELL_FOCUS_NECROMANCY;
    } else
    if (sSchool == "T")
    {
        nFeatEpic = FEAT_EPIC_SPELL_FOCUS_TRANSMUTATION;
        nFeatGreater = FEAT_GREATER_SPELL_FOCUS_TRANSMUTATION;
        nFeatFocus = FEAT_SPELL_FOCUS_TRANSMUTATION;
    }
    if (GetHasFeat(nFeatEpic))
    {
        nDC +=6;
    } else if (GetHasFeat(nFeatGreater))
    {
        nDC +=4;
    } else if (GetHasFeat(nFeatFocus))
    {
        nDC +=2;
    }
    return nDC;
}

string CU_Get2DAString(string s2DA, string sColumn, int nRow)
{
    object oCache = GetObjectByTag("CU_CACHE");
    string sReturn = GetLocalString(oCache, "2DA_" + s2DA + "_" + sColumn + "_" + IntToString(nRow));
    if (sReturn == "")
    {
        sReturn = Get2DAString(s2DA, sColumn, nRow);
        if (sReturn == "")
            sReturn = "~NULL~";
        SetLocalString(oCache, "2DA_" + s2DA + "_" + sColumn + "_" + IntToString(nRow), sReturn);
    }
    if (sReturn == "~NULL~")
    {
        sReturn = "";
    }
    return sReturn;
}

int CU_GetCasterLevel(object oCreature)
{
    if (GetObjectType(oCreature) == OBJECT_TYPE_AREA_OF_EFFECT)
    {
        oCreature = GetAreaOfEffectCreator(oCreature);
    }
    if (!GetLocalInt(oCreature, "UseSpellBook")
    || GetIsObjectValid(GetSpellCastItem())
    || GetLocalInt(oCreature, "NormalSpellLevel"))
        return GetCasterLevel(oCreature);
    int nClass = GetLocalInt(oCreature, "SpellClass");
    int nLevel = GetLevelByClass(nClass, oCreature);
    return nLevel;
}

int CU_MyResistSpell(object oCaster, object oTarget, float fDelay = 0.0)
{
    if (fDelay > 0.5)
    {
        fDelay = fDelay - 0.1;
    }
    int nResist = ResistSpell(oCaster, oTarget);
    effect eSR = EffectVisualEffect(VFX_IMP_MAGIC_RESISTANCE_USE);
    effect eGlobe = EffectVisualEffect(VFX_IMP_GLOBE_USE);
    effect eMantle = EffectVisualEffect(VFX_IMP_SPELL_MANTLE_USE);
    if (nResist < 2 && (GetLocalInt(oCaster, "UseSpellBook") && !GetLocalInt(oCaster, "NormalSpellLevel")))
    {
        int nResistSpell = GetSpellResistance(oTarget);
        int nLevel = CU_GetCasterLevel(oCaster);
        if (GetHasFeat(FEAT_EPIC_SPELL_PENETRATION, oCaster))
        {
            nLevel += 6;
        } else if (GetHasFeat(FEAT_GREATER_SPELL_PENETRATION, oCaster))
        {
            nLevel += 4;
        } else if (GetHasFeat(FEAT_SPELL_PENETRATION, oCaster))
        {
            nLevel += 2;
        }
        int nThrow = d20();
        if (nLevel + nThrow >= nResistSpell)
        {
            nResist = 0;
        } else {
            nResist = 1;
        }
        if (nResistSpell > 0)
        {
            string sResistFeedback = GetName(oCaster) + ": piercing Spell Resistance: " + IntToString(nThrow) + " + " + IntToString(nLevel) + " vs DC " + IntToString(nResistSpell) + ": ";
            object oPC = GetMaster(oCaster);
            if (nResist == 1)
            {
                sResistFeedback += "Failed";
            } else {
                sResistFeedback += "Success";
            }
            SendMessageToPC(oPC, sResistFeedback);
            SendMessageToPC(oTarget, sResistFeedback);
        }
    }
    if(nResist == 1) //Spell Resistance
    {
        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eSR, oTarget));
    }
    else if(nResist == 2) //Globe
    {
        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eGlobe, oTarget));
    }
    else if(nResist == 3) //Spell Mantle
    {
        if (fDelay > 0.5)
        {
            fDelay = fDelay - 0.1;
        }
        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eMantle, oTarget));
    }
    return nResist;
}

void CU_RestoreSpells()
{
    int nCircle, nSlot;
    int nCasterLevel = CU_GetCasterLevel(OBJECT_SELF);
    // Spell progression stops at level 20
    if (nCasterLevel > 20) nCasterLevel = 20;
    int nClass = GetLocalInt(OBJECT_SELF, "SpellClass");
    int nMaxCircle = (nCasterLevel + 1) / 2;
    if (nClass == CLASS_TYPE_RANGER || nClass == CLASS_TYPE_PALADIN)
    {
        nMaxCircle = (nCasterLevel - 4) /3;
        if (nCasterLevel == 3) nMaxCircle = 0;
        if (nMaxCircle < 0) return;
        if (nMaxCircle > 4) nMaxCircle = 4;
    }
    int nMod = CU_GetCasterMod();
    int nAbility = CU_GetCasterAbility();
    int nScore = GetAbilityScore(OBJECT_SELF, nAbility);
    if ((nMaxCircle + 10) > nScore) nMaxCircle = nScore - 10;
    int nSpells;
    SetLocalInt(OBJECT_SELF, "CastScore", nScore);
    // max circle is different for rangers/paladins
    for (nCircle = 0; nCircle < 10; nCircle++)
    {
        if (nCircle <= nMaxCircle)
        {
            // The wizard spell progression
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
            } else { // rangers and paladins
                int nMinimumLevel = (nCircle * 3) + 4;
                int nDif = nCasterLevel - nMinimumLevel;
                if (nCircle < 3) nDif--;
                if (nCircle == 1 && nDif > 1) nDif--;
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
        for (nSlot = 1; nSlot < 10; nSlot++)
        {
            int nSpellId = GetLocalInt(OBJECT_SELF, "Memorise_" + IntToString(nCircle) + "_" + IntToString(nSlot)) -1;
            int nMem = GetLocalInt(OBJECT_SELF, "Memorised_" + IntToString(nCircle) + "_" + IntToString(nSlot));
            int nMemNum = GetLocalInt(OBJECT_SELF, "MemNum_" + IntToString(nSpellId));
            if (nSlot > nSpells && nMem)
            {
                SetLocalInt(OBJECT_SELF, "Memorised_" + IntToString(nCircle) + "_" + IntToString(nSlot), FALSE);
                SetLocalInt(OBJECT_SELF, "MemNum_" + IntToString(nSpellId), nMemNum -1);
                int nSub = 1;
                string sSubRad = CU_Get2DAString("spells", "SubRadSpell" +IntToString(nSub), nSpellId);
                while (sSubRad != "" && nSub < 6)
                {
                    int nSubId = StringToInt(sSubRad);
                    SetLocalInt(OBJECT_SELF, "MemNum_" + IntToString(nSubId), nMemNum - 1);
                    nSub++;
                }
            } else if (!nMem)
            {
                SetLocalInt(OBJECT_SELF, "MemNum_" + IntToString(nSpellId), nMemNum +1);
                SetLocalInt(OBJECT_SELF, "Memorised_" + IntToString(nCircle) + "_" + IntToString(nSlot), TRUE);
                int nSub = 1;
                string sSubRad = CU_Get2DAString("spells", "SubRadSpell" +IntToString(nSub), nSpellId);
                while (sSubRad != "" && nSub < 6)
                {
                    int nSubId = StringToInt(sSubRad);
                    SetLocalInt(OBJECT_SELF, "MemNum_" + IntToString(nSubId), nMemNum + 1);
                    nSub++;
                }
            }
        }
    }
    return;
}
