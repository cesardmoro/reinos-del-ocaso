#include "mk_inc_body"

void main()
{
    object oDM = GetPCSpeaker();
    object oPC = GetLocalObject(oDM, "oTargetCreature");
    int nPart = MK_GetCurrentBodyPart(oPC);

    MK_SetCreatureBodyPart(nPart, MK_CREATURE_PART_NEXT, oPC);
}
