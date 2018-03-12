///::///////////////////////////////////////////////
//:: Ultravision
//:://////////////////////////////////////////////
/*
   The character gains Ultravision permanently.
*/
#include "prc_alterations"

void main()
{
	object oPC = OBJECT_SELF;
	effect eUltra =  EffectUltravision();
        
        if(!GetHasEffect(EFFECT_TYPE_ULTRAVISION, oPC))
        {
		SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eUltra, oPC);
	}
}
