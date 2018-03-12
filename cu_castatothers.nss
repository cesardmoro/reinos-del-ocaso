#include "cu_spells"
int StartingConditional()
{
    int nTarget = GetLocalInt(OBJECT_SELF, "SpellTargets");
    if (nTarget & TARGET_TYPE_OTHERS)
    {
        return TRUE;
    }
    return FALSE;
}
