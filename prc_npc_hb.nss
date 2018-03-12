//::///////////////////////////////////////////////
//:: OnHeartbeat NPC eventscript
//:: prc_npc_hb
//:://////////////////////////////////////////////
#include "prc_alterations"
#include "inc_epicspellai"
#include "inc_utility"
#include "prc_inc_death"

void main()
{
    
    //NPC substiture for OnEquip
    DoEquipTest();


    if(DoEpicSpells())
    {
        ActionDoCommand(SetCommandable(TRUE));
        SetCommandable(FALSE);
    }
    
    if(DoDeadHealingAI())
    {
        ActionDoCommand(SetCommandable(TRUE));
        SetCommandable(FALSE);
    }

    //run the individual HB event script
    ExecuteScript("prc_onhb_indiv", OBJECT_SELF);
}