//::///////////////////////////////////////////////
//:: [Mage Killer Feats]
//:: [prc_magekill.nss]
//:://////////////////////////////////////////////
//:: Check to see which Mage Killer feats a creature
//:: has and apply the appropriate bonuses.
//:://////////////////////////////////////////////
//:: Created By: Stratovarius.  Modified by Aaon Graywolf
//:: Created On: Dec 29, 2003
//:://////////////////////////////////////////////

#include "inc_item_props"
#include "prc_feat_const"

// * Applies the Mage Killer's saving throw bonuses as CompositeBonuses on the object's skin.
// * Currently only valid for Fortitude and Reflex saves.
// * iLevel = integer save bonus
// * iType = IP_CONST_SAVEBASETYPE_*
// * sFlag = Flag to check whether the property has already been added
void MageKillerSaveBonus(object oPC, object oSkin, int iLevel, int iType, string sFlag)
{
    if(GetLocalInt(oSkin, sFlag) == iLevel) return;

    SetCompositeBonus(oSkin, sFlag, iLevel, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC, iType);
    SetLocalInt(oPC, sFlag, TRUE);
}

void main()
{
    object oPC = OBJECT_SELF;

    int bRefx = GetHasFeat(FEAT_MK_REF_1, oPC) ? 1 : 0;
        bRefx = GetHasFeat(FEAT_MK_REF_2, oPC) ? 2 : bRefx;
        bRefx = GetHasFeat(FEAT_MK_REF_3, oPC) ? 3 : bRefx;
        bRefx = GetHasFeat(FEAT_MK_REF_4, oPC) ? 4 : bRefx;
        bRefx = GetHasFeat(FEAT_MK_REF_5, oPC) ? 5 : bRefx;
        bRefx = GetHasFeat(FEAT_MK_REF_6, oPC) ? 6 : bRefx;
        bRefx = GetHasFeat(FEAT_MK_REF_7, oPC) ? 7 : bRefx;
        bRefx = GetHasFeat(FEAT_MK_REF_8, oPC) ? 8 : bRefx;
        bRefx = GetHasFeat(FEAT_MK_REF_9, oPC) ? 9 : bRefx;
        bRefx = GetHasFeat(FEAT_MK_REF_10, oPC) ? 10 : bRefx;
        bRefx = GetHasFeat(FEAT_MK_REF_11, oPC) ? 11 : bRefx;
        bRefx = GetHasFeat(FEAT_MK_REF_12, oPC) ? 12 : bRefx;
        bRefx = GetHasFeat(FEAT_MK_REF_13, oPC) ? 13 : bRefx;
        bRefx = GetHasFeat(FEAT_MK_REF_14, oPC) ? 14 : bRefx;
        bRefx = GetHasFeat(FEAT_MK_REF_15, oPC) ? 15 : bRefx;

    int bFort = GetHasFeat(FEAT_MK_FORT_1, oPC) ? 1 : 0;
        bFort = GetHasFeat(FEAT_MK_FORT_2, oPC) ? 2 : bFort;
        bFort = GetHasFeat(FEAT_MK_FORT_3, oPC) ? 3 : bFort;
        bFort = GetHasFeat(FEAT_MK_FORT_4, oPC) ? 4 : bFort;
        bFort = GetHasFeat(FEAT_MK_FORT_5, oPC) ? 5 : bFort;
        bFort = GetHasFeat(FEAT_MK_FORT_6, oPC) ? 6 : bFort;
        bFort = GetHasFeat(FEAT_MK_FORT_7, oPC) ? 7 : bFort;
        bFort = GetHasFeat(FEAT_MK_FORT_8, oPC) ? 8 : bFort;
        bFort = GetHasFeat(FEAT_MK_FORT_9, oPC) ? 9 : bFort;
        bFort = GetHasFeat(FEAT_MK_FORT_10, oPC) ? 10 : bFort;
        bFort = GetHasFeat(FEAT_MK_FORT_11, oPC) ? 11 : bFort;
        bFort = GetHasFeat(FEAT_MK_FORT_12, oPC) ? 12 : bFort;
        bFort = GetHasFeat(FEAT_MK_FORT_13, oPC) ? 13 : bFort;
        bFort = GetHasFeat(FEAT_MK_FORT_14, oPC) ? 14 : bFort;
        bFort = GetHasFeat(FEAT_MK_FORT_15, oPC) ? 15 : bFort;

    object oSkin = GetPCSkin(oPC);

    if(bRefx > 0) MageKillerSaveBonus(oPC, oSkin, bRefx, IP_CONST_SAVEBASETYPE_REFLEX, "MKFortBonus");
    if(bFort > 0) MageKillerSaveBonus(oPC, oSkin, bFort, IP_CONST_SAVEBASETYPE_FORTITUDE, "MKRefBonus");
}
