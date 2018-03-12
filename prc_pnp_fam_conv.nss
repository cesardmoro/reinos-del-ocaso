//:://////////////////////////////////////////////
//:: Short description
//:: prc_pnp_fam_conv
//:://////////////////////////////////////////////
/** @file
    @todo Primo: Could you fill in the file comments
                 and TLKify?


    @author Primogenitor
    @date   Created  - yyyy.mm.dd
    @date   Modified - 2005.09.24 - Adapted to new
            DynConvo system - Ornedan
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "inc_dynconv"


//////////////////////////////////////////////////
/* Constant defintions                          */
//////////////////////////////////////////////////

const int STAGE_ENTRY  = 0;
const int STAGE_SUMMON = 1;


//////////////////////////////////////////////////
/* Aid functions                                */
//////////////////////////////////////////////////



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
            if(nStage == STAGE_ENTRY)
            {
                SetHeader("Please select a familiar.\nAll familiars will cost 100GP to summon.");

                AddChoice("Bat",    1, oPC);
//                AddChoice("Cat",    2, oPC);
                AddChoice("Hawk",   3, oPC);
//                AddChoice("Lizard", 4, oPC);
//                AddChoice("Owl",    5, oPC);
//                AddChoice("Rat",    6, oPC);
//                AddChoice("Raven",  7, oPC);
//                AddChoice("Snake",  8, oPC);
//                AddChoice("Toad",   9, oPC);
//                AddChoice("Weasel", 10, oPC);

                MarkStageSetUp(nStage, oPC);
            }
            else if(nStage == STAGE_SUMMON)
            {
                SetHeader("Familiar selected, summoning...");
            }
        }

        // Do token setup
        SetupTokens();
        SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
    }
    else if(nValue == DYNCONV_EXITED)
    {
        // End of conversation cleanup
    }
    else if(nValue == DYNCONV_ABORTED)
    {
        // Abort conversation cleanup
    }
    else
    {
        int nChoice = GetChoice(oPC);
        if(nStage == STAGE_ENTRY)
        {
            nStage = STAGE_SUMMON;
            SetPersistantLocalInt(oPC, "PnPFamiliarType", nValue);
            ActionUseFeat(FEAT_SUMMON_FAMILIAR, OBJECT_SELF);
            // Take 100 gold - the cost of obtaining a familiar as per PnP
            TakeGoldFromCreature(100, oPC, TRUE);
        }

        // Store the stage value. If it has been changed, this clears out the choices
        SetStage(nStage, oPC);
    }
}