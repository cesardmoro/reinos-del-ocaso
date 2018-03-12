#include "cu_spells"
int StartingConditional()
{
    int nTarget = GetLocalInt(OBJECT_SELF, "SpellTargets");
    object oMaster = GetMaster();
    if (nTarget & TARGET_TYPE_OTHERS)
    {
        object oHench = GetHenchman(oMaster, 1);
        if (oHench != OBJECT_SELF && GetIsObjectValid(oHench))
        {
            SetCustomToken(330, GetName(oHench));
            return TRUE;
        }
    }
    return FALSE;
}
