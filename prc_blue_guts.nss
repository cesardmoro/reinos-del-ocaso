
//Blueguts      DC14     Incubation 1d3 days       1d4 Str dam

#include "spinc_common"

void main()
{
	int nDC = 14;
	effect eDisease = GetFirstEffect(OBJECT_SELF);
	
	while(GetIsEffectValid(eDisease))
	{
		if(GetEffectType(eDisease) == EFFECT_TYPE_DISEASE)
		break;
		
		eDisease = GetNextEffect(OBJECT_SELF);
		
	}// end while - loop through all effects
		
	// Do the save
	if(PRCMySavingThrow(SAVING_THROW_FORT, OBJECT_SELF, nDC, SAVING_THROW_TYPE_DISEASE))
	{
		// Get the value of the previous save
		if(GetLocalInt(OBJECT_SELF, "SPELL_BLUE_GUTS_SAVED"))
		{
			// 2 saves in row, OBJECT_SELF recovers from the disease
			// Remove the disease and relevant locals.
			RemoveEffect(OBJECT_SELF, eDisease);
			DeleteLocalInt(OBJECT_SELF, "SPELL_BLUE_GUTS_SAVED");									
		}
		
		else
		{
			// Note down the successful save
			SetLocalInt(OBJECT_SELF, "SPELL_BLUE_GUTS_SAVED", TRUE);
		}		
	}
	else
	{
		// Note down the failed save
		SetLocalInt(OBJECT_SELF, "SPELL_BLUE_GUTS_SAVED", FALSE);
		
		//Cause damage
		int nDam = d4();
		
		ApplyAbilityDamage(OBJECT_SELF, ABILITY_STRENGTH, nDam, DURATION_TYPE_TEMPORARY, TRUE, -1.0f);
	}	
}