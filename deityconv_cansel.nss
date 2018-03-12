// Can select this deity.
#include "deity_include"

int StartingConditional()
{
    object oPC = GetPCSpeaker();

    // TRUE if the PC is not a cleric of an approved deity...
    return ( GetDeityIndex(oPC) < 0  ||  GetLevelByClass(CLASS_TYPE_CLERIC, oPC) == 0 )
            // ...and is not already a follower of this deity.
            &&  GetDeityIndex(oPC) != GetLocalInt(OBJECT_SELF, "DeityToTalkAbout");
}
