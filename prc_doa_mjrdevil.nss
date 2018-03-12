//::///////////////////////////////////////////////
//:: Disciple of Asmodeus Summon Major Devil
//:: prc_doa_mjrdevil.nss
//::///////////////////////////////////////////////
/*
    Summons a Hellcat. At level 9, summons 1d4 Hellcats.
    Duration as per summon monster
*/
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: 27.2.2006
//:://////////////////////////////////////////////

#include "prc_alterations"

void main()
{
    //Declare major variables
    object oPC = OBJECT_SELF;
    
    effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_GATE);
    float fDuration = HoursToSeconds(24);
    string sSummon;
    int nDuration = PRCGetCasterLevel(oPC);
    if(GetPRCSwitch(PRC_SUMMON_ROUND_PER_LEVEL))
        fDuration = RoundsToSeconds(nDuration*GetPRCSwitch(PRC_SUMMON_ROUND_PER_LEVEL));    
        
    if (PRCGetSpellId() == SPELL_DISCIPLE_ASMODEUS_DEVIL_CORN) sSummon = "prc_sum_cornugon";
    else if (PRCGetSpellId() == SPELL_DISCIPLE_ASMODEUS_DEVIL_GEL) sSummon = "prc_sum_gelugon";
    else if (PRCGetSpellId() == SPELL_DISCIPLE_ASMODEUS_DEVIL_GLAB) sSummon = "prc_sum_glabrezu";
    else if (PRCGetSpellId() == SPELL_DISCIPLE_ASMODEUS_DEVIL_HAM) sSummon = "prc_sum_hamatula";
    else if (PRCGetSpellId() == SPELL_DISCIPLE_ASMODEUS_DEVIL_OSY) sSummon = "prc_sum_osyluth";
        
    effect eSummon = EffectSummonCreature(sSummon);        

    // 1 summon only
    MultisummonPreSummon(oPC);
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis, GetSpellTargetLocation());
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), fDuration);
}
