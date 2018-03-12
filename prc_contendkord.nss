//::///////////////////////////////////////////////
//:: Mighty Contender of Kord
//:: prc_contendkord.nss
//:://////////////////////////////////////////////
//:: Applies the Contender Strength boost
//:://////////////////////////////////////////////

#include "prc_alterations"

// * Applies the Kord's stat bonuses as CompositeBonuses on object's skin.
void KordBonus(object oPC, object oSkin, int iLevel)
{
    string sFlag = "MightyContenderStrength";

    if(GetLocalInt(oSkin, sFlag) == iLevel) return;

    if(iLevel > 0)
    {
        SetCompositeBonus(oSkin, sFlag, iLevel, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_CHA);
    }
}

void main()
{
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    int nKord = GetLevelByClass(CLASS_TYPE_MIGHTY_CONTENDER_KORD, oPC);
    int nBonus = 0;

    if (nKord >= 9) nBonus = 2;
    else if (nKord >= 5) nBonus = 1;

    // Get the first boost at level 5
    if (nKord >= 5) KordBonus(oPC, oSkin, nBonus);
}
