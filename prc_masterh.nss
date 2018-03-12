//::///////////////////////////////////////////////
//:: [Master Harper Feat]
//:: [prc_masterh.nss]
//:://////////////////////////////////////////////
//:: Check to see which Master Harper feats a creature
//:: has and apply the appropriate bonuses.
//:://////////////////////////////////////////////
//:: Created By: Age
//:: Created On: Feb 6, 2004
//:://////////////////////////////////////////////

#include "prc_class_const"
#include "prc_feat_const"
#include "inc_item_props"

void MasterHarperBonusFeat(object oPC, object oSkin, string sFlag, int iItemProp, int iSubProp, int iValue)
{
    //SpawnScriptDebugger();
    if(GetLocalInt(oSkin,sFlag) == TRUE) return;

    SetCompositeBonus(oSkin, sFlag, iValue,
                        iItemProp,iSubProp);
}


void main()
{
    //SpawnScriptDebugger();
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    int iLycanbane = GetHasFeat(FEAT_LYCANBANE,oPC);
    int iMililEar = GetHasFeat(FEAT_MILILS_EAR,oPC);
    int iDeneirsOrel = GetHasFeat(FEAT_DENEIRS_OREL,oPC);
    int iHarperLevel = GetLevelByClass(CLASS_TYPE_MASTER_HARPER,oPC);

    if (iLycanbane > 0) MasterHarperBonusFeat(oPC, oSkin, "MHLycanbane",
                                                ITEM_PROPERTY_AC_BONUS_VS_RACIAL_GROUP,
                                                IP_CONST_RACIALTYPE_SHAPECHANGER, 5);
    if (iMililEar > 0) MasterHarperBonusFeat(oPC, oSkin, "MHMililEar",
                                                ITEM_PROPERTY_SKILL_BONUS,
                                                SKILL_LISTEN, 4);
    if (iDeneirsOrel > 0) MasterHarperBonusFeat(oPC, oSkin, "MHDeneirsOrel",
                                                ITEM_PROPERTY_SKILL_BONUS,
                                                SKILL_SPELLCRAFT, 4);
    // New skill to give the Master Harper a bonus to Lore from "Harper Knowledge" feat gained on level 1.
    MasterHarperBonusFeat(oPC, oSkin, "MHHarperKnowledge", ITEM_PROPERTY_SKILL_BONUS, SKILL_LORE, iHarperLevel);
}
