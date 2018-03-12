#include "cu_spells"

int StartingConditional()
{
    int nView = GetLocalInt(OBJECT_SELF, "ChosenSpellView");
    int nId = GetLocalInt(OBJECT_SELF, "CastId_" + IntToString(nView));
    string sTarget = CU_Get2DAString("spells", "TargetType", nId);
    int nTarget = CU_HexToInt(sTarget);
    SetLocalInt(OBJECT_SELF, "SpellTargets", nTarget);
    SetCustomToken(550, CU_GetSpellName(nId));
    SetLocalInt(OBJECT_SELF, "SubNum", 1);
    if (CU_Get2DAString("spells", "SubRadSpell1", nId) != "")
        return FALSE;
    return TRUE;
}
