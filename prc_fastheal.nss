//::///////////////////////////////////////////////
//:: [Fast Healing Feats]
//:: [prc_bld_arch.nss]
//:://////////////////////////////////////////////
//:: Grants a creature with the fast Healing feats 
//:: the appropriate regeneration.
//:://////////////////////////////////////////////
//:: Created By: Silver
//:: Created On: June 8, 2005
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "prc_feat_const"

void main()
{
    //Declare main variables.
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
 
    int epHeal;
    if(GetHasFeat(FAST_HEALING_3,oPC))
        epHeal = 9;
    else if(GetHasFeat(FAST_HEALING_2,oPC))
        epHeal = 6;
    else if(GetHasFeat(FAST_HEALING_1,oPC))
        epHeal = 3;
    if(epHeal)
        SetCompositeBonus(oSkin, "FastHealing", epHeal, ITEM_PROPERTY_REGENERATION);
}