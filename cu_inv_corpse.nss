#include "cu_spells"
void main()
{
    int nView = GetLocalInt(OBJECT_SELF, "ChosenSpellView");
    int nId = GetLocalInt(OBJECT_SELF, "CastId_" + IntToString(nView));
    int nMeta = GetLocalInt(OBJECT_SELF, "CastMeta_" + IntToString(nView));
    object oCorpse = GetLocalObject(OBJECT_SELF, "TARGET_CORPSE");
    ClearAllActions();
    CU_ActionCastSpellAtObject(nId, oCorpse, nMeta);
}
