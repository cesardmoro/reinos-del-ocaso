#include "deity_include"

int StartingConditional()
{
    object oPC = GetPCSpeaker();

    // TRUE if the PC is not a cleric of an approved deity.
    return GetDeityIndex(oPC) < 0  ||  GetLevelByClass(CLASS_TYPE_CLERIC, oPC) == 0;
}
