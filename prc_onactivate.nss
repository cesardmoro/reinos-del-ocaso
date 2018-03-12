//::///////////////////////////////////////////////
//:: OnActivateItem eventscript
//:: prc_onactivate
//:://////////////////////////////////////////////
#include "prc_alterations"
#include "inc_utility"

void main()
{
    object oItem = GetItemActivated();
    object oPC = GetItemActivator();

    // One of the Epic Seed books.
    if (GetStringLeft(GetTag(oItem), 8) == "EPIC_SD_")
        ExecuteScript("activate_seeds", oPC);

    // One of the Epic Spell books.
    if (GetStringLeft(GetResRef(oItem), 8) == "epic_sp_")
        ExecuteScript("activate_epspell", oPC);

    // "A Gem Caged Creature" item received from the epic spell Gem Cage.
    if (GetTag(oItem) == "IT_GEMCAGE_GEM")
        ExecuteScript("run_gemcage_gem", oPC);

    // "Whip of Shar" item received from the epic spell Whip of Shar.
    if (GetTag(oItem) == "WhipofShar")
        ExecuteScript("run_whipofshar", oPC);

    // "Epic Spellcasting" item used to prepare epic spells
    if (GetTag(oItem) == "epicspellcast")
        ExecuteScript("_rest_button", oPC);
    
        //rest kits
    if(GetPRCSwitch(PRC_SUPPLY_BASED_REST))
        ExecuteScript("sbr_onactivate", OBJECT_SELF);
        
    // Execute scripts hooked to this event for the player and item triggering it
    ExecuteAllScriptsHookedToEvent(oPC, EVENT_ONACTIVATEITEM);
    ExecuteAllScriptsHookedToEvent(oItem, EVENT_ITEM_ONACTIVATEITEM);
}