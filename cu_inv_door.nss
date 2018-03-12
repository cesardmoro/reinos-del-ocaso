#include "cu_spells"
void main()
{
    int nView = GetLocalInt(OBJECT_SELF, "ChosenSpellView");
    int nId = GetLocalInt(OBJECT_SELF, "CastId_" + IntToString(nView));
    int nMeta = GetLocalInt(OBJECT_SELF, "CastMeta_" + IntToString(nView));
    object oTarget = GetNearestObject(OBJECT_TYPE_DOOR);
    if (!GetIsObjectValid(oTarget) || GetDistanceToObject(oTarget) > 20.0)
        return;
    ClearAllActions();
    CU_ActionCastSpellAtObject(nId, oTarget, nMeta);
}
