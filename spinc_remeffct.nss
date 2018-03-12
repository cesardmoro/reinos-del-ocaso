///////////////////////////////////////////////////////////////////////////
//@file
//Include for spell removal checks
//
//
//void SpellRemovalCheck
//
//This function is used for the removal of effects and ending of spells that
//cannot be ended in a normal fashion.
//
///////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////
/*             Function prototypes              */
//////////////////////////////////////////////////

void SpellRemovalCheck(object oCaster, object oTarget);


//////////////////////////////////////////////////
/*                  Includes                    */
//////////////////////////////////////////////////

#include "prc_alterations"


//////////////////////////////////////////////////
/*             Function definitions             */
//////////////////////////////////////////////////

void SpellRemovalCheck(object oCaster, object oTarget)
{
	//Get Spell being cast
	int nSpellID = PRCGetSpellId();

	//Set up spell removals for individual spells
	//Remove Curse
	if(nSpellID == SPELL_REMOVE_CURSE)
	{
		//Ghoul Gauntlet
		if(GetHasSpellEffect(SPELL_GHOUL_GAUNTLET, oTarget))
		{
			RemoveSpellEffects(SPELL_GHOUL_GAUNTLET, oCaster, oTarget);
		}
	}

	//Remove Disease
	if(nSpellID == SPELL_REMOVE_DISEASE)
	{
		//Ghoul Gauntlet
		if(GetHasSpellEffect(SPELL_GHOUL_GAUNTLET, oTarget))
		{
			RemoveSpellEffects(SPELL_GHOUL_GAUNTLET, oCaster, oTarget);
		}
	}

	//Heal
	if(nSpellID == SPELL_HEAL)
	{
		//Ghoul Gauntlet
		if(GetHasSpellEffect(SPELL_GHOUL_GAUNTLET, oTarget))
		{
			RemoveSpellEffects(SPELL_GHOUL_GAUNTLET, oCaster, oTarget);
		}

		//Energy Ebb
		if(GetHasSpellEffect(SPELL_ENERGY_EBB, oTarget))
		{
			RemoveSpellEffects(SPELL_ENERGY_EBB, oCaster, oTarget);
		}

	}

	//Restoration
	if(nSpellID == SPELL_RESTORATION)
	{
		//Ghoul Gauntlet
		if(GetHasSpellEffect(SPELL_GHOUL_GAUNTLET, oTarget))
		{
			RemoveSpellEffects(SPELL_GHOUL_GAUNTLET, oCaster, oTarget);
		}

		//Energy Ebb
		if(GetHasSpellEffect(SPELL_ENERGY_EBB, oTarget))
		{
			RemoveSpellEffects(SPELL_ENERGY_EBB, oCaster, oTarget);
		}

	}

	//Greater Restoration
	if(nSpellID == SPELL_GREATER_RESTORATION)
	{
		//Ghoul Gauntlet
		if(GetHasSpellEffect(SPELL_GHOUL_GAUNTLET, oTarget))
		{
			RemoveSpellEffects(SPELL_GHOUL_GAUNTLET, oCaster, oTarget);
		}

		//Energy Ebb
		if(GetHasSpellEffect(SPELL_ENERGY_EBB, oTarget))
		{
			RemoveSpellEffects(SPELL_ENERGY_EBB, oCaster, oTarget);
		}

	}

	//Dispel Magic
	if(nSpellID == SPELL_DISPEL_MAGIC)
	{
		//Ghoul Gauntlet
		if(GetHasSpellEffect(SPELL_GHOUL_GAUNTLET, oTarget))
		{
			RemoveSpellEffects(SPELL_GHOUL_GAUNTLET, oCaster, oTarget);
		}

	}

	//Greater Dispelling
	if(nSpellID == SPELL_GREATER_DISPELLING)
	{
		//Ghoul Gauntlet
		if(GetHasSpellEffect(SPELL_GHOUL_GAUNTLET, oTarget))
		{
			RemoveSpellEffects(SPELL_GHOUL_GAUNTLET, oCaster, oTarget);
		}

	}

	//Mordenkainen's Disjunction
	if(nSpellID == SPELL_MORDENKAINENS_DISJUNCTION)
	{
		//Ghoul Gauntlet
		if(GetHasSpellEffect(SPELL_GHOUL_GAUNTLET, oTarget))
		{
			RemoveSpellEffects(SPELL_GHOUL_GAUNTLET, oCaster, oTarget);
		}

	}

	//Limited Wish
	//Wish
	//Miracle
}

// Test main
//void main(){}
