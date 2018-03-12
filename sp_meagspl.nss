#include "spinc_common"
#include "spinc_massbuff"

void main()
{
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	if (!X2PreSpellCastCode()) return;
    
    // The typo on the spell ID is Bioware's.
	DoMassBuff (MASSBUFF_STAT, ABILITY_CHARISMA, SPELL_EAGLE_SPLEDOR);
}
