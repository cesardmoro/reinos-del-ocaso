#include "spinc_common"
#include "spinc_engimm"

void main()
{
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	if (!X2PreSpellCastCode()) return;
    
	DoEnergyImmunity (DAMAGE_TYPE_ELECTRICAL, VFX_IMP_LIGHTNING_M);
}
