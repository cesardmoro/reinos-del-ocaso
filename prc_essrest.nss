#include "inc_item_props"
#include "nw_i0_plot"
#include "prc_inc_function"
#include "inc_epicspells"

void RestMeUp(object oPC)
{
    FloatingTextStringOnCreature("*You feel refreshed*", oPC, FALSE);
    ForceRest(oPC);
    if (GetIsEpicCleric(oPC) || GetIsEpicDruid(oPC) ||
        GetIsEpicSorcerer(oPC) || GetIsEpicWizard(oPC))
    {
        ReplenishSlots(oPC);
    }
}


 
void main()
{
    object oPC=OBJECT_SELF;

    if (!GetLocalInt(oPC,"ForceRest"))
    {

      AssignCommand(oPC, ClearAllActions(FALSE));
      // Start the special conversation with oPC.
      AssignCommand(oPC, ActionStartConversation(OBJECT_SELF, "_rest_button", TRUE, FALSE));
    }
    DeleteLocalInt(oPC,"ForceRest");
}