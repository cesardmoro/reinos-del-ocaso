//::///////////////////////////////////////////////
//:: Greater Planar Binding
//:: NW_S0_GrPlanar.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Summons an outsider dependant on alignment, or
    holds an outsider if the creature fails a save.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 12, 2001
//:://////////////////////////////////////////////

//:: modified by mr_bumpkin Dec 4, 2003 for PRC stuff

//---------------------------------------------------------------------------------------
// Modificaciones por Marduk & Dragoncin.
// 1. Hacer que realmente se fije en el alineamiento para invocar la bestia;
// 2. Desligar el script de todo el prc, para evitar problemas (sacando includes,
// multisummonpresummon y racialtype);
// 3. Saque la posibilidad de extender la duracion por metamagia extended, el caster lvl
// y corregi la duracion a 1 hs fija.
//---------------------------------------------------------------------------------------

//#include "prc_alterations"
//#include "prc_inc_spells"

void main()
{
    //Declare major variables
    string template;
    //int nMetaMagic = PRCGetMetaMagicFeat();
    //int nCasterLevel = GetLevelByClass(CLASS_TYPE_ACOLYTE, OBJECT_SELF);
    int nDuration = ( 1 );
    int alineamiento = GetAlignmentLawChaos(OBJECT_SELF);
    effect eSummon;
    effect eGate;
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eDur2 = EffectVisualEffect(VFX_DUR_PARALYZED);
    effect eDur3 = EffectVisualEffect(VFX_DUR_PARALYZE_HOLD);

    effect eLink = EffectLinkEffects(eDur, EffectParalyze());
    eLink = EffectLinkEffects(eLink, eDur2);
    eLink = EffectLinkEffects(eLink, eDur3);

    object oTarget = GetSpellTargetObject();
    //int nRacial = MyPRCGetRacialType(oTarget);

    //Check for metamagic extend
    //if (nMetaMagic & METAMAGIC_EXTEND)
    //{
    //    nDuration = nDuration *2;   //Duration is +100%
    //}
    //Practiced spellcaster
    //int PractisedSpellcasting (object oCaster, int iCastingClass, int iCastingLevels);

    if (alineamiento==ALIGNMENT_CHAOTIC)
        template = "zep_glabrezu001";
    else if (alineamiento==ALIGNMENT_LAWFUL)
        template = "zep_gelugon001";
    else
        switch(d2()) {
            case 1:     template = "zep_gelugon001"; break;
            case 2:     template = "zep_glabrezu001"; break;
        }
    eSummon = EffectSummonCreature(template, VFX_FNF_SUMMON_GATE, 3.0);

//if(GetPRCSwitch(MARKER_PRC_COMPANION))

    //Apply the VFX impact and summon effect
    //MultisummonPreSummon(OBJECT_SELF);
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), HoursToSeconds(nDuration));

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name
}

