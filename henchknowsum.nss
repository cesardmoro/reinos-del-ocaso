#include "cu_spells"
int StartingConditional()
{
    talent tSum = CU_GetCreatureTalentBest(TALENT_CATEGORY_BENEFICIAL_OBTAIN_ALLIES, 20);
    return GetIsTalentValid(tSum);
}
