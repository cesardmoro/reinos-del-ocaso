#include "cu_spells"
int StartingConditional()
{
    SetLocalInt(OBJECT_SELF, "ITEM_SLOT", 0);
    SetLocalInt(OBJECT_SELF, "ITEM_SEEK", 0);
    int nTarget = GetLocalInt(OBJECT_SELF, "SpellTargets");
    if (nTarget & TARGET_TYPE_ITEMS)
    {
        return TRUE;
    }
    return FALSE;
}
