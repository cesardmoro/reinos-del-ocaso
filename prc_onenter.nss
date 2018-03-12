#include "inc_item_props"
#include "prc_inc_function"
#include "prc_inc_clsfunc"


void main()
{
    //The composite properties system gets confused when an exported
    //character re-enters.  Local Variables are lost and most properties
    //get re-added, sometimes resulting in larger than normal bonuses.
    //The only real solution is to wipe the skin on entry.  This will
    //mess up the lich, but only until I hook it into the EvalPRC event -
    //hopefully in the next update
    //  -Aaon Graywolf
    object oPC = OBJECT_SELF;
        object oSkin = GetPCSkin(oPC);
    ScrubPCSkin(oPC, oSkin);
        DeletePRCLocalInts(oSkin);

    SetLocalInt(oPC,"ONENTER",1);
    // Make sure we reapply any bonuses before the player notices they are gone.
    DelayCommand(0.1, EvalPRCFeats(oPC));
    // Check to see which special prc requirements (i.e. those that can't be done)
    // through the .2da's, the entering player already meets.
    ExecuteScript("prc_prereq", oPC);
    //ExecuteScript("prc_psi_ppoints", oPC);
    if (GetHasFeat(FEAT_PRESTIGE_IMBUE_ARROW))
    {
        //Destroy imbued arrows.
        AADestroyAllImbuedArrows(oPC);
    }
    DeleteLocalInt(oPC,"ONENTER");
}
