#include "x2_inc_craft"
#include "mk_inc_craft"

int StartingConditional()
{
    object oDM = GetPCSpeaker();
    object oPC = GetLocalObject(oDM, "oTargetCreature");
    int nWings = GetCreatureWingType(oPC);

    string sWings = Get2DAString("WingModel", "LABEL", nWings);
    if (sWings=="") sWings = "Unknown";

    SetCustomToken(MK_TOKEN_PARTSTRING, sWings);
    SetCustomToken(MK_TOKEN_PARTNUMBER, IntToString(nWings));

    return TRUE;
}
