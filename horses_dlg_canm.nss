#include "horses_props_inc"

int StartingConditional()
{
    object oHorse = OBJECT_SELF;
    object oPC = GetPCSpeaker();

    if (FindSubString(GetResRef(oHorse), Horses_PALMOUNT_RESREF_PREFIX) > -1) {
        return (GetMaster(oHorse) == oPC);
    } else {
        return TRUE;
    }
}
