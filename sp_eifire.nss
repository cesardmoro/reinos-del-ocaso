#include "spinc_common"
#include "spinc_engimm"

void main()
{
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
	if (!X2PreSpellCastCode()) return;
    
	DoEnergyImmunity (DAMAGE_TYPE_FIRE, VFX_IMP_FLAME_M);
}
