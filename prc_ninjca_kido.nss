//::///////////////////////////////////////////////
//:: Ki Dodge
//:: ninjca_gkido
//::
//:://////////////////////////////////////////////
/*
	Begins Ki Dodge Mode
*/


#include "prc_inc_clsfunc"

void main()
{
     //Declare major variables
     object oPC = OBJECT_SELF;
     object oTarget = GetSpellTargetObject();
     
	if (!Ninja_AbilitiesEnabled(OBJECT_SELF))
	{
		IncrementRemainingFeatUses(OBJECT_SELF, FEAT_KI_DODGE);
		SendMessageToPC(OBJECT_SELF, "Your ki powers will not function while encumbered or wearing armor");
		return;
	}
	else
		Ninja_DecrementKi(oPC, FEAT_KI_DODGE);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectConcealment(20), OBJECT_SELF, RoundsToSeconds(1));
}
