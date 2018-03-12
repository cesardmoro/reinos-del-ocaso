#include "mk_inc_body"

void main()
{
    object oDM = GetPCSpeaker();
    object oPC = GetLocalObject(oDM, "oTargetCreature");
    MK_RestoreHead(oPC);
}
