//::///////////////////////////////////////////////
//:: Disciple of Asmodeus Summon Hellcat
//:: prc_doa_hellcat.nss
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
    effect eSummon = EffectSummonCreature("prc_doa_hellcat");
    effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_GATE);
    float fDuration = HoursToSeconds(24);
    int nDuration = PRCGetCasterLevel(oPC);
    if(GetPRCSwitch(PRC_SUMMON_ROUND_PER_LEVEL))
        fDuration = RoundsToSeconds(nDuration*GetPRCSwitch(PRC_SUMMON_ROUND_PER_LEVEL));    

    if (GetLevelByClass(CLASS_TYPE_DISCIPLE_OF_ASMODEUS, oPC) >= 9)
    {
	// Override so they get 1d4 summons
    	MultisummonPreSummon(oPC, TRUE);
    	ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis, GetSpellTargetLocation());
    	
    	int i;
    	int nNumSummons = d4();
    	for(i = 1; i <= nNumSummons; i++)
        {
    		ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), fDuration);
    	}
    }
    else
    {
    	// 1 summon only
    	MultisummonPreSummon(oPC);
    	ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis, GetSpellTargetLocation());
    	ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), fDuration);
    }
}
