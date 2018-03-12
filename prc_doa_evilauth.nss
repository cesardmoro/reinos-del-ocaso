//::///////////////////////////////////////////////
//:: Disciple of Asmodeus Evil Authority
//:: prc_doa_evilauth.nss
//::///////////////////////////////////////////////
/*
    All evil aligned creatures of hit dice less than the DoA
    must make a will save vs 10 + class level + charisma
    or be dominated for 24 hours
*/
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: 28.2.2006
//:://////////////////////////////////////////////

#include "spinc_common"

void main()
{
    //Declare major variables
    object oPC = OBJECT_SELF;
    effect eMindVFX  = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
    effect eDominate = EffectDominated();
    effect eLink;
    float fRadius = FeetToMeters(50.0);
    location lTarget = GetLocation(oPC);
    float fDuration = HoursToSeconds(24);
    int nDC = 10 + GetLevelByClass(CLASS_TYPE_DISCIPLE_OF_ASMODEUS, oPC) + GetAbilityModifier(ABILITY_CHARISMA, oPC);
    
	object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	while(GetIsObjectValid(oTarget))
	{
	    if(GetAlignmentGoodEvil(oTarget) == ALIGNMENT_EVIL && GetHitDice(oPC) > GetHitDice(oTarget))
    	    {
        	// Let the AI know
        	SPRaiseSpellCastAt(oTarget, TRUE, PRCGetSpellId(), oPC);
        	//Make a saving throw check
        	if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
        	{
        	        // Determine effect and apply it
        	        eLink = EffectLinkEffects(eMindVFX, GetScaledEffect(eDominate, oTarget));
        	        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration, TRUE, PRCGetSpellId(), PRCGetCasterLevel(oPC));
        	}// end if - Save
    	    }	

            //Select the next target within the spell shape.
    	    oTarget = MyNextObjectInShape(SHAPE_SPHERE, fRadius, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	}// end while - Target loop
}
