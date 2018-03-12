#include "cu_spells"
int StartingConditional()
{
    int nTarget = GetLocalInt(OBJECT_SELF, "SpellTargets");
    object oMaster = GetMaster();
    if (nTarget & TARGET_TYPE_OTHERS)
    {
        object oCorpse = GetNearestCreature(CREATURE_TYPE_IS_ALIVE,FALSE, OBJECT_SELF, 1);
        int n = 1;
        while (GetIsObjectValid(oCorpse))
        {   // the dead creature had my master as master
            if (GetLocalObject(oCorpse, "X0_LAST_MASTER_TAG") == oMaster)
            {
                SetCustomToken(333, GetName(oCorpse));
                // remember who it was
                SetLocalObject(OBJECT_SELF, "TARGET_CORPSE", oCorpse);
                return TRUE;
            }
            oCorpse = GetNearestCreature(CREATURE_TYPE_IS_ALIVE,FALSE, OBJECT_SELF, ++n);
        }
    }
    return FALSE;
}
