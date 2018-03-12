#include "x2_inc_craft"
#include "mk_inc_craft"

int StartingConditional()
{
    object oDM = GetPCSpeaker();
    object oPC = GetLocalObject(oDM, "oTargetCreature");
    int nTail = GetCreatureTailType(oPC);

    string sTail = Get2DAString("TailModel", "LABEL", nTail);
    if (sTail=="") sTail = "Unknown";

    SetCustomToken(MK_TOKEN_PARTSTRING, sTail);
    SetCustomToken(MK_TOKEN_PARTNUMBER, IntToString(nTail));

    return TRUE;
}
