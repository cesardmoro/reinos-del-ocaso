const string SUB = "3";

#include "cu_spells"
void main()
{
    int nView = GetLocalInt(OBJECT_SELF, "ChosenSpellView");
    int nId = GetLocalInt(OBJECT_SELF, "CastId_" + IntToString(nView));
    int nSub = StringToInt(CU_Get2DAString("spells", "SubRadSpell" + SUB, nId));
    string sSubName = CU_GetSpellName(nSub);
    SetCustomToken(550, sSubName);
    SetLocalInt(OBJECT_SELF, "CastId_" + IntToString(nView), nSub);
}
