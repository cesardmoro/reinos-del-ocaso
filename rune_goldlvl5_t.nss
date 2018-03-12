#include "prc_class_const"

int StartingConditional()
{
    int iGoldCost = (25*GetLevelByClass(CLASS_TYPE_RUNESCARRED,OBJECT_SELF));
    int iGoldAvai = GetGold(OBJECT_SELF);

    if(iGoldCost > iGoldAvai)
    return FALSE;

    return TRUE;
}
