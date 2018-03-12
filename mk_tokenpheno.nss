#include "x2_inc_craft"
#include "mk_inc_craft"

int StartingConditional()
{
    object oDM = GetPCSpeaker();
    object oPC = GetLocalObject(oDM, "oTargetCreature");
    int nPhenoType = GetPhenoType(oPC);

    string sPhenoType = Get2DAString("PhenoType", "Label", nPhenoType);
    if (sPhenoType=="") sPhenoType = "Unknown";

    SetCustomToken(MK_TOKEN_PARTSTRING, sPhenoType);
    SetCustomToken(MK_TOKEN_PARTNUMBER, IntToString(nPhenoType));

    return TRUE;
}
