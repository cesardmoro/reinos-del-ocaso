//:://////////////////////////////////////////////
//:: Power Leech Conversation
//:: power_leech.nss
//:://////////////////////////////////////////////
/** @file
    This allows you to choose which stat to drain
    from the spell target


    @author Tenjac
    @date   Created  - 10.3.2006
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "inc_dynconv"
#include "prc_alterations"


//////////////////////////////////////////////////
/* Constant defintions                          */
//////////////////////////////////////////////////

const int STAGE_STAT_CHOICE = 0;
const int STAGE_CONFIRMATION  = 1;

//////////////////////////////////////////////////
/* Aid functions                                */
//////////////////////////////////////////////////

// Just takes the stat and returns the name
string StatToName(int nStat)
{
    if      (nStat == ABILITY_STRENGTH)     return GetStringByStrRef(135);
    else if (nStat == ABILITY_DEXTERITY)    return GetStringByStrRef(133);
    else if (nStat == ABILITY_CONSTITUTION) return GetStringByStrRef(132);
    else if (nStat == ABILITY_WISDOM)       return GetStringByStrRef(136);
    else if (nStat == ABILITY_INTELLIGENCE) return GetStringByStrRef(134);
    else if (nStat == ABILITY_CHARISMA)     return GetStringByStrRef(131);

    // if its not a stat
    return "";
}


//////////////////////////////////////////////////
/* Main function                                */
//////////////////////////////////////////////////

void main()
{
    object oPC = GetPCSpeaker();
    /* Get the value of the local variable set by the conversation script calling
     * this script. Values:
     * DYNCONV_ABORTED     Conversation aborted
     * DYNCONV_EXITED      Conversation exited via the exit node
     * DYNCONV_SETUP_STAGE System's reply turn
     * 0                   Error - something else called the script
     * Other               The user made a choice
     */
    int nValue = GetLocalInt(oPC, DYNCONV_VARIABLE);
    // The stage is used to determine the active conversation node.
    // 0 is the entry node.
    int nStage = GetStage(oPC);

    // Check which of the conversation scripts called the scripts
    if(nValue == 0) // All of them set the DynConv_Var to non-zero value, so something is wrong -> abort
        return;

    if(nValue == DYNCONV_SETUP_STAGE)
    {
        // Check if this stage is marked as already set up
        // This stops list duplication when scrolling
        if(!GetIsStageSetUp(nStage, oPC))
        {
            // variable named nStage determines the current conversation node
            // Function SetHeader to set the text displayed to the PC
            // Function AddChoice to add a response option for the PC. The responses are show in order added
            if(nStage == STAGE_STAT_CHOICE)
            {
                // Set the header
                SetHeader("Select the Ability Score you would like to boost.");

                // Add responses for the PC
                AddChoice(StatToName(ABILITY_STRENGTH),     ABILITY_STRENGTH,     oPC);
                AddChoice(StatToName(ABILITY_DEXTERITY),    ABILITY_DEXTERITY,    oPC);
                AddChoice(StatToName(ABILITY_CONSTITUTION), ABILITY_CONSTITUTION, oPC);
                AddChoice(StatToName(ABILITY_WISDOM),       ABILITY_WISDOM,       oPC);
                AddChoice(StatToName(ABILITY_INTELLIGENCE), ABILITY_INTELLIGENCE, oPC);
                AddChoice(StatToName(ABILITY_CHARISMA),     ABILITY_CHARISMA,     oPC);

                MarkStageSetUp(STAGE_STAT_CHOICE, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }
            else if(nStage == STAGE_CONFIRMATION)//confirmation
            {
                int nChoice = GetLocalInt(oPC, "PRC_Power_Leech_Stat");
                AddChoice(GetStringByStrRef(4752), TRUE); // "Yes"
                AddChoice(GetStringByStrRef(4753), FALSE); // "No"

                string sName = StatToName(nChoice);
                string sText = "You have selected " + sName + ".\n";
                
                sText += "Is this correct?";

                SetHeader(sText);
                MarkStageSetUp(STAGE_CONFIRMATION, oPC);
            }
        }

        // Do token setup
        SetupTokens();
    }
    // End of conversation cleanup
    else if(nValue == DYNCONV_EXITED)
    {
        // End of conversation cleanup
        DeleteLocalInt(oPC, "PRC_Power_Leech_Stat");
    }
    
    // Abort conversation cleanup.
    // NOTE: This section is only run when the conversation is aborted
    // while aborting is allowed. When it isn't, the dynconvo infrastructure
    // handles restoring the conversation in a transparent manner
    else if(nValue == DYNCONV_ABORTED)
    {
        // End of conversation cleanup
        DeleteLocalInt(oPC, "PRC_Power_Leech_Stat");
    }
    // Handle PC responses
    else
    {
        // variable named nChoice is the value of the player's choice as stored when building the choice list
        // variable named nStage determines the current conversation node
        int nChoice = GetChoice(oPC);
        if(nStage == STAGE_STAT_CHOICE)
        {
            // If there are more stats to do

            nStage = STAGE_CONFIRMATION;
            SetLocalInt(oPC, "PRC_Power_Leech_Stat", nChoice);
        }
        else if(nStage == STAGE_CONFIRMATION)//confirmation
        {
            if(nChoice == TRUE)
            {
		    // We're all done
		    AllowExit(DYNCONV_EXIT_FORCE_EXIT);

            }
            else
            {
                nStage = STAGE_STAT_CHOICE;
                // Reset the counter
                //DeleteLocalInt(oPC, "AACounter");
                MarkStageNotSetUp(STAGE_STAT_CHOICE, oPC);
                MarkStageNotSetUp(STAGE_CONFIRMATION, oPC);
            }

            DeleteLocalInt(oPC, "PRC_Power_Leech_Stat");
        }

        // Store the stage value. If it has been changed, this clears out the choices
        SetStage(nStage, oPC);
    }
}
