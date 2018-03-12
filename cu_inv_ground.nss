#include "cu_spells"
#include "x0_i0_position"
void main()
{
    int nView = GetLocalInt(OBJECT_SELF, "ChosenSpellView");
    int nId = GetLocalInt(OBJECT_SELF, "CastId_" + IntToString(nView));
    int nMeta = GetLocalInt(OBJECT_SELF, "CastMeta_" + IntToString(nView));
    ClearAllActions();
    location lTarget = GetRandomLocation(GetArea(OBJECT_SELF), OBJECT_SELF, 3.0);
    CU_ActionCastSpellAtLocation(nId, lTarget, nMeta);
}
