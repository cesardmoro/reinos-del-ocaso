//::///////////////////////////////////////////////
//:: Removing Polymorph Effect, and Summoned Wolf on Level
//:: prc_wwunpoly
//:: Copyright (c) 2004 Shepherd Soft
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Created By: Russell S. Ahlstrom
//:: Created On: May 14, 2004
//:://////////////////////////////////////////////

#include "prc_feat_const"

void main()
{
    object oPC = OBJECT_SELF;
    effect ePoly = GetFirstEffect(oPC);
    while (GetIsEffectValid(ePoly))
    {
        if (GetEffectType(ePoly) == EFFECT_TYPE_POLYMORPH)
        {
            RemoveEffect(oPC, ePoly);
            break;
        }
        ePoly = GetNextEffect(oPC);
    }

    object oWolf = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oPC);
    int nCount = 1;
    while (GetIsObjectValid(oWolf))
    {
        if (GetName(oWolf) == "Wolf")
        {
            effect eVis = EffectVisualEffect(VFX_IMP_UNSUMMON);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oWolf);
            DelayCommand(2.3, DestroyObject(oWolf));
            IncrementRemainingFeatUses(oPC, FEAT_PRESTIGE_WOLF_EMPATHY);
            break;
        }
        nCount++;
        oWolf = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oPC, nCount);
    }
}
