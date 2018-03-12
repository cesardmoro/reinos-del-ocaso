//::///////////////////////////////////////////////
//:: Suel Archanamach Feats
//:: prc_suelarchana.nss
//:://////////////////////////////////////////////
//:: Check to see which Suel Archanamach feats a creature
//:: has and apply the appropriate bonuses.
//:://////////////////////////////////////////////
//:: Created By: Stratovarius.  
//:: Created On: Apr 7, 2006
//:://////////////////////////////////////////////

#include "prc_alterations"


// * Applies the Spellsword's Spell Failure reduction on object's skin.
// * iLevel = IP_CONST_ARCANE_SPELL_FAILURE_*
// * sFlag = Flag to check whether the property has already been added
void SuelIgnoreSpellFailure(object oPC, object oSkin, int iLevel, string sFlag)
{
    if(GetLocalInt(oSkin, sFlag) == iLevel) return;

    RemoveSpecificProperty(oSkin, ITEM_PROPERTY_ARCANE_SPELL_FAILURE, -1, GetLocalInt(oSkin, sFlag), 1, sFlag);
    AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyArcaneSpellFailure(iLevel), oSkin);
    SetLocalInt(oSkin, sFlag, iLevel);
}

void main()
{
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    int nClass = GetLevelByClass(CLASS_TYPE_SUEL_ARCHANAMACH, oPC);
    int nSF;
    
    if (nClass >= 10)       nSF = IP_CONST_ARCANE_SPELL_FAILURE_MINUS_20_PERCENT;
    else if (nClass >= 7)   nSF = IP_CONST_ARCANE_SPELL_FAILURE_MINUS_15_PERCENT;
    else if (nClass >= 4)   nSF = IP_CONST_ARCANE_SPELL_FAILURE_MINUS_10_PERCENT;
    else if (nClass >= 1)   nSF = IP_CONST_ARCANE_SPELL_FAILURE_MINUS_5_PERCENT;

    SuelIgnoreSpellFailure(oPC, oSkin, nSF, "SuelArchanamachSpellFailure");
}

