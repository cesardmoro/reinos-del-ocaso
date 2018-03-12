#include "spinc_common"
#include "spinc_summon"

void main()
{
	string creature = !GetHasFeat(FEAT_ANIMAL_DOMAIN_POWER) ?
		"NW_S_AIRGREAT" : "NW_S_AIRELDER";

	sp_summon(creature, VFX_FNF_SUMMON_MONSTER_3);
}