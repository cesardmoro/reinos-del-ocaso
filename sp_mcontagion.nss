#include "spinc_common"


void main()
{
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	if (!X2PreSpellCastCode()) return;
    
	SPSetSchool(SPELL_SCHOOL_NECROMANCY);
	
	// Get the spell target location as opposed to the spell target.
	location lTarget = GetSpellTargetLocation();

	// Get the effective caster level.
	int nCasterLvl = PRCGetCasterLevel();
	int nPenetr = nCasterLvl + SPGetPenetr();

	
	float fDelay;

        int nRand = Random(7)+1;
        int nDisease;
    	//Use a random seed to determine the disease that will be delivered.
    	switch (nRand)
    	{
           case 1:
             nDisease = DISEASE_BLINDING_SICKNESS;
             break;
           case 2:
             nDisease = DISEASE_CACKLE_FEVER;
             break;
           case 3:
             nDisease = DISEASE_FILTH_FEVER;
             break;
           case 4:
             nDisease = DISEASE_MINDFIRE;
             break;
           case 5:
             nDisease = DISEASE_RED_ACHE;
             break;
           case 6:
             nDisease = DISEASE_SHAKES;
             break;
           case 7:
             nDisease = DISEASE_SLIMY_DOOM;
             break;
    	}

        effect eDisease = EffectDisease(nDisease);
    	
	// Declare the spell shape, size and the location.  Capture the first target object in the shape.
	// Cycle through the targets within the spell shape until an invalid object is captured.
	
	object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	while (GetIsObjectValid(oTarget))
	{
		fDelay = GetSpellEffectDelay(lTarget, oTarget);
		
		// Run the Bioware drown code.
		object oCaster = OBJECT_SELF;

		
		if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
                {
                  SPRaiseSpellCastAt(oTarget);
                  
		  if (!SPResistSpell(OBJECT_SELF, oTarget,nPenetr))
		  {

	             // Apply damage and VFX.
		     SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eDisease, oTarget,0.0f,TRUE,-1,nCasterLvl);
		  }
		}
		oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
	}
	
	SPSetSchool();
}
