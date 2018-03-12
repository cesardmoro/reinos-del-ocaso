#include "cu_spells"
int StartingConditional()
{
    int nView = GetLocalInt(OBJECT_SELF, "ChosenSpellView");
    int nId = GetLocalInt(OBJECT_SELF, "CastId_" + IntToString(nView));
    int nSub = GetLocalInt(OBJECT_SELF, "SubNum");
    string sSub  = CU_Get2DAString("spells", "SubRadSpell" + IntToString(nSub), nId);
    SetLocalInt(OBJECT_SELF, "SubNum", ++nSub);
    if (sSub == "") return FALSE;
    string sSubName = CU_GetSpellName(StringToInt(sSub));
    SetCustomToken(598 + nSub, sSubName);
    return TRUE;
}
