#include "cu_spells"
void main()
{
    int nView = GetLocalInt(OBJECT_SELF, "ChosenSpellView");
    int nId = GetLocalInt(OBJECT_SELF, "CastId_" + IntToString(nView));
    int nMeta = GetLocalInt(OBJECT_SELF, "CastMeta_" + IntToString(nView));
    object oItem = GetLocalObject(OBJECT_SELF, "CAST_TARGET_ITEM");
    ClearAllActions();
    CU_ActionCastSpellAtObject(nId, oItem, nMeta);
}
