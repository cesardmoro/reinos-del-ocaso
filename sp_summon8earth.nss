#include "spinc_common"
#include "spinc_summon"

void main()
{
	string creature = !GetHasFeat(FEAT_ANIMAL_DOMAIN_POWER) ?
		"NW_S_EARTHGREAT" : "NW_S_EARTHELDER";

	sp_summon(creature, VFX_FNF_SUMMON_MONSTER_3);
}