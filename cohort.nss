//::///////////////////////////////////////////////
//:: Summon Cohort
//:: Cohort
//:://////////////////////////////////////////////
/*
    Summons a Rashemen Barbarian as a Hathran cohort
*/
//:://////////////////////////////////////////////
//:: Created By: Sir Attilla
//:: Created On: January 3 , 2004
//:: Modified By: Stratovarius, bugfixes.
//:://////////////////////////////////////////////

#include "prc_feat_const"
#include "prc_class_const"

void main()
{
    effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_GATE);
    string sSummon;
    object oCreature;
    object oHench = GetHenchman();

    int nClass = GetLevelByClass(CLASS_TYPE_HATHRAN, OBJECT_SELF);

    if (nClass > 27)	        sSummon = "prc_hath_rash10";
    else if (nClass > 24)	sSummon = "prc_hath_rash9";
    else if (nClass > 21)	sSummon = "prc_hath_rash8";
    else if (nClass > 18)	sSummon = "prc_hath_rash7";
    else if (nClass > 15)	sSummon = "prc_hath_rash6";
    else if (nClass > 12)	sSummon = "prc_hath_rash5";
    else if (nClass > 9)	sSummon = "prc_hath_rash4";
    else if (nClass > 6)	sSummon = "prc_hath_rash3";
    else if (nClass > 3)	sSummon = "prc_hath_rash2";
    else if (nClass > 0)	sSummon = "prc_hath_rash";

    if (GetResRef(oHench) == sSummon)
    {
    FloatingTextStringOnCreature("You may only have one Cohort.", OBJECT_SELF, FALSE);
    return;
    }

    oCreature = CreateObject(OBJECT_TYPE_CREATURE, sSummon, GetSpellTargetLocation());
    AddHenchman(OBJECT_SELF, oCreature);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetSpellTargetLocation());
}



