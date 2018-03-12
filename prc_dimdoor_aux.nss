//::///////////////////////////////////////////////
//:: Dimension Door - auxiliary script
//:: prc_dimdoor_aux
//::///////////////////////////////////////////////
/** @ file
    This script is fired from a listener that hears
    a numeric value said by a PC that cast
    Dimension Door within the last 10 seconds.

    This script will ExecuteScript itself on the
    PC for the actual call to finish the
    dimension door, since it seems DelayCommands
    are object-specific, meaning the listener
    mustn't be OBJECT_SELF as it gets nuked
    right after this script ends.

    @author Ornedan
    @date   Created  - 2005.07.04
    @date   Modified - 2005.10.12
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "spinc_dimdoor"

void main()
{
    if(DEBUG) DoDebug("Running prc_dimdoor_aux");

    // Is it called for the listener or for the PC?
    if(!GetLocalInt(OBJECT_SELF, DD_FIRSTSTAGE_DONE))
    {
        string sNum = GetMatchedSubstring(0);
        object oPC = GetLastSpeaker();
        // I'm not sure how well the string parsing works, so try both direct conversion to float and conversion via integer
        float fVal = StringToFloat(sNum);
        if(fVal == 0.0f)
            fVal = IntToFloat(StringToInt(sNum));

        SetLocalFloat(oPC, DD_DISTANCE, fVal);
        SetLocalInt(oPC, DD_FIRSTSTAGE_DONE, TRUE);

        ExecuteScript("prc_dimdoor_aux", oPC);

        // Destroy the listener
        DestroyListener(OBJECT_SELF);
    }
    // Called for the PC
    else
    {
        object oPC = OBJECT_SELF;
        DimensionDoorAux(oPC);
    }
}