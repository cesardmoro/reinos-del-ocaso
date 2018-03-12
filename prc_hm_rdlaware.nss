/****************************************************
* Feat: Riddle of Awareness
* Discription: Once per day: +4 to Listen, Search &
* Spot checks for 10 hours.
*
* by Jeremiah Teague
* spl_rdlawr
****************************************************/
//#include "prc_hnshnmystc"
#include "prc_class_const"
#include "prc_feat_const"

void main()
{
object oTarget = GetSpellTargetObject();
effect eListen = EffectSkillIncrease(SKILL_LISTEN, 4);
effect eSearch = EffectSkillIncrease(SKILL_SEARCH, 4);
effect eSpot   = EffectSkillIncrease(SKILL_SPOT, 4);
effect eVFX = EffectVisualEffect(VFX_DUR_PROT_PREMONITION);

ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVFX, OBJECT_SELF, HoursToSeconds(10));
ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eListen, OBJECT_SELF, HoursToSeconds(10));
ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSearch, OBJECT_SELF, HoursToSeconds(10));
ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSpot, OBJECT_SELF, HoursToSeconds(10));
}
