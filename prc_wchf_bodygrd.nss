//::///////////////////////////////////////////////
//:: Foe Hunter
//:://////////////////////////////////////////////
/*
    Foe Hunter DR
*/
//:://////////////////////////////////////////////
//:: Created By: Oni5115
//:: Created On: Mar 17, 2004
//:://////////////////////////////////////////////

#include "prc_feat_const"
#include "prc_class_const"
#include "prc_spell_const"
#include "prc_alterations"

void main()
{
     object oPC = OBJECT_SELF;
     object oFoe = GetLastDamager();
     
     int iDamageTaken = GetTotalDamageDealt();
     int nCheck = FALSE;
     
	object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, GetLocation(oPC), TRUE, OBJECT_TYPE_CREATURE);
	while (GetIsObjectValid(oTarget) && !nCheck)
	{
		if (spellsIsTarget(oTarget, SPELL_TARGET_ALLALLIES, OBJECT_SELF) && oTarget != OBJECT_SELF)
		{
			// This is the damage being shifted from the Warchief to an ally
			effect eDam = EffectDamage(iDamageTaken);
			ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
			nCheck = TRUE;
		}
		
		oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, GetLocation(oPC), TRUE, OBJECT_TYPE_CREATURE);
	}     
         
     effect eHeal = EffectHeal(iDamageTaken);
     ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oPC);
}