/*****************************************************
* Feat: Walk Through the Mountains
* Description: For 2 rounds per level
* (spell: etheralness). Used once a day.
*
* by Jeremiah Teague
*****************************************************/
//#include "prc_hnshnmystc"
#include "prc_class_const"
#include "prc_feat_const"

void main()
{
effect eVFX = EffectVisualEffect(VFX_FNF_DISPEL_GREATER);
int nTotalLevels = 0;
int i = 0;
for(i=0; i < 37; i++)
    {//count all class levels:
    nTotalLevels += GetLevelByClass(i+1, OBJECT_SELF);
    }

float fDuration = RoundsToSeconds(nTotalLevels * 2);

ApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX, OBJECT_SELF);
ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectEthereal(), OBJECT_SELF, fDuration);

///*DEBUG*/ SendMessageToPC(OBJECT_SELF, "nTotalLevels = " + IntToString(nTotalLevels));
}
