#include "cu_spells"
void main()
{
    int nView = GetLocalInt(OBJECT_SELF, "ChosenSpellView");
    int nId = GetLocalInt(OBJECT_SELF, "CastId_" + IntToString(nView));
    int nMeta = GetLocalInt(OBJECT_SELF, "CastMeta_" + IntToString(nView));
    object oHench = GetHenchman(GetMaster(), 3);
    ClearAllActions();
    CU_ActionCastSpellAtObject(nId, oHench, nMeta);
}
