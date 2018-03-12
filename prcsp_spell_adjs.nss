//#include "prc_add_spl_pen"  <-- Inherited from  #prc_add_spell_dc
#include "prc_add_spell_dc"
#include "prc_inc_spells"

//
//	Get the Spell Penetration Bonuses
//
int
SPGetPenetr(object oCaster = OBJECT_SELF)
{
    int nPenetr = 0;

	// This is a deliberate optimization attempt.
	// The first feat determines if the others even need
	// to be referenced.
	if (GetHasFeat(FEAT_SPELL_PENETRATION, oCaster)) {
		nPenetr += 2;
		if (GetHasFeat(FEAT_EPIC_SPELL_PENETRATION, oCaster))
			nPenetr += 4;
		else if (GetHasFeat(FEAT_GREATER_SPELL_PENETRATION, oCaster))
			nPenetr += 2;
	}

	// Check for additional improvements
    nPenetr += add_spl_pen(oCaster);

    return nPenetr;
}

//
//	Interface for specific AOE requirements
//	TODO: Determine who or what removes the cached local var (bug?)
//	TODO: Try and remove this function completely? It does 2 things the
//	above function doesnt: Effective Caster Level and Cache
//
int
SPGetPenetrAOE(object oCaster = OBJECT_SELF, int nCasterLvl = 0)
{
	// Check the cache
    int nPenetr = GetLocalInt(OBJECT_SELF, "nPenetre");
    
	// Compute the result
    if (!nPenetr) {
		nPenetr = (nCasterLvl) ? nCasterLvl : PRCGetCasterLevel(oCaster);

		// Factor in Penetration Bonuses
		nPenetr += SPGetPenetr(oCaster);
       
		// Who removed this?
		SetLocalInt(OBJECT_SELF,"nPenetre",nPenetr);
    }

    return nPenetr;
}
