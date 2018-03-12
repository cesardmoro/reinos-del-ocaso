//:://////////////////////////////////////////////
//:: Short description
//:: filename
//:://////////////////////////////////////////////
/** @file
    Long description


    @author Joe Random
    @date   Created  - yyyy.mm.dd
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "inc_dynconv"
#include "prc_alterations"
#include "inc_newspellbook"

//////////////////////////////////////////////////
/* Constant defintions                          */
//////////////////////////////////////////////////

const int STAGE_SELECT_LEVEL = 0;
const int STAGE_SELECT_SPELL = 1;
const int STAGE_CONFIRM      = 2;

const int STRREF_SELECTED_HEADER1   = 16824209; // "You have selected:"
const int STRREF_SELECTED_HEADER2   = 16824210; // "Is this correct?"
const int STRREF_END_CONVO_SELECT   = 16824212; // "Finish"
const int LEVEL_STRREF_START        = 16824809;
const int STRREF_YES                = 4752;     // "Yes"
const int STRREF_NO                 = 4753;     // "No"

const int ERROR_CODE_5 = 999;
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
            // variable named nStage determines the current conversation node
            // Function SetHeader to set the text displayed to the PC
            // Function AddChoice to add a response option for the PC. The responses are show in order added
            if(nStage == STAGE_SELECT_LEVEL)
            {
                int nClass = GetLocalInt(oPC, "SpellGainClass"); 
                int nSpellbookMinLevel = GetLocalInt(oPC, "SpellbookMinSpelllevel");  
                int nSpellbookMaxLevel = GetLocalInt(oPC, "SpellbookMaxSpelllevel");  
                int nLevel = GetSpellslotLevel(nClass, oPC);
                string sFile = GetFileForClass(nClass);
                int nSpellsKnownCurrent;
                int nSpellsKnownMax;
                int nSpellsKnownToSelect;
                int i;
                
                int nAddedASpellLevel = FALSE;
                for(i=nSpellbookMinLevel;i<=nSpellbookMaxLevel;i++)
                {
                    nSpellsKnownCurrent  = GetSpellKnownCurrentCount(oPC, i, nClass);
                    nSpellsKnownMax      = GetSpellKnownMaxCount(nLevel, i, nClass, oPC);
                    int nSpellsAvaliable = GetSpellUnknownCurrentCount(oPC, i, nClass);
                    if(nSpellsKnownCurrent < nSpellsKnownMax)
                    {
DoDebug("nSpellsKnownCurrent < nSpellsKnownMax is TRUE");    
                        //if(nSpellsAvaliable >= nSpellsKnownToSelect)
                        if(nSpellsAvaliable)
                        {
DoDebug("nSpellsAvaliable is TRUE");    
                            nAddedASpellLevel = TRUE;
                            AddChoice("Spell Level "+IntToString(i), i);
                        }   
                        else
                            DoDebug("Insufficient spells to fill level "+IntToString(i));
                    }
                }
                if(!nAddedASpellLevel)
                {
                    SetHeader("You can select more spells when you next gain a level.");
                    SetCustomToken(DYNCONV_TOKEN_EXIT, GetStringByStrRef(STRREF_END_CONVO_SELECT));
                    AllowExit(DYNCONV_EXIT_ALLOWED_SHOW_CHOICE, TRUE, oPC);
                    DelayCommand(0.01, AllowExit(DYNCONV_EXIT_ALLOWED_SHOW_CHOICE, TRUE, oPC));
                    DelayCommand(0.1 , AllowExit(DYNCONV_EXIT_ALLOWED_SHOW_CHOICE, TRUE, oPC));
                }
                else
                {
                    SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
                    SetHeader("Select a level to gain spells");
                }
                MarkStageSetUp(nStage, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
            }   
            else if(nStage == STAGE_SELECT_SPELL)
            {        
                int nClass = GetLocalInt(oPC, "SpellGainClass");   
                int nLevel = GetSpellslotLevel(nClass, oPC);
                int nSpellLevel = GetLocalInt(oPC, "SelectedLevel");
                string sFile = GetFileForClass(nClass);
                // Set the header
                int nSpellsKnownCurrent = GetSpellKnownCurrentCount(oPC, nSpellLevel, nClass);
                int nSpellsKnownMax = GetSpellKnownMaxCount(nLevel, nSpellLevel, nClass, oPC);
                int nSpellsKnownToSelect = nSpellsKnownMax - nSpellsKnownCurrent;
                string sHeader;
                int i;
                int nRow;
                // Add responses for the PC
                string sTag = "SpellLvl_"+IntToString(nClass)+"_Level_"+IntToString(nSpellLevel);
                object oWP = GetObjectByTag(sTag);
                for(i=0; i<array_get_size(oWP, sTag); i++)
                {
                    int nRow = array_get_int(oWP, sTag, i);
                    int nFeatID = StringToInt(Get2DACache(sFile, "FeatID", nRow));
                    if(Get2DACache(sFile, "ReqFeat", nRow)==""      // Has no prerequisites
                        && !GetHasFeat(nFeatID, oPC))               // And doesnt have it already
                    {                  
                        int nFeatID = StringToInt(Get2DACache(sFile, "IPFeatID", nRow));
                        AddChoice(GetStringByStrRef(StringToInt(Get2DACache("iprp_feats", "Name", nFeatID))), nRow, oPC);
DoDebug("PRC_S_spellb i="+IntToString(nRow));                    
DoDebug("PRC_S_spellb sFile="+sFile);
DoDebug("PRC_S_spellb nFeatID="+IntToString(nFeatID));  
DoDebug("PRC_S_spellb resref="+IntToString(StringToInt(Get2DACache("iprp_feats", "Name", nFeatID))));  
                    }
                }
                /*
                for(nRow=0;nRow<GetPRCSwitch(FILE_END_CLASS_SPELLBOOK);nRow++)
                {
                    int nFeatID = StringToInt(Get2DACache(sFile, "FeatID", nRow));
                    if(!GetHasFeat(nFeatID, oPC)
                        && Get2DACache(sFile, "ReqFeat", nRow) == ""
                        && Get2DACache(sFile, "Level", nRow) == IntToString(nSpellLevel)
                        )
                    {
                        int bHas = FALSE;
                        for(i=0;i<persistant_array_get_size(oPC, "Spellbook"+IntToString(nClass)) && !bHas;i++)
                        {
                            int nNewSpellbookID = persistant_array_get_int(oPC, "Spellbook"+IntToString(nClass), i)-1;
                            if(nNewSpellbookID == nRow)
                                bHas = TRUE;    
                        }   
                        if(!bHas)
                        {
                            string sName = GetStringByStrRef(StringToInt(Get2DACache("feat", "FEAT", nFeatID)));
                            AddChoice(sName, nRow);
                        }
                    }
                }*/
                sHeader += "You have "+IntToString(nSpellsKnownToSelect)+" level "+IntToString(nSpellLevel);
                sHeader += " spells remaining to select.";
                SetHeader(sHeader);
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
                MarkStageSetUp(nStage, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
            }
            else if(nStage == STAGE_CONFIRM)
            {
                int nRow = GetLocalInt(oPC, "SelectedSpell");
                int nClass = GetLocalInt(oPC, "SpellGainClass");    
                string sFile = GetFileForClass(nClass);
                
                string sDesc;
                sDesc += "You have selected: ";
                sDesc += GetStringByStrRef(StringToInt(Get2DACache("feat", "FEAT", 
                    StringToInt(Get2DACache(sFile, "FeatID", nRow)))));
                sDesc += "\n\n";
                sDesc += GetStringByStrRef(StringToInt(Get2DACache("feat", "DESCRIPTION", 
                    StringToInt(Get2DACache(sFile, "FeatID", nRow)))));
                sDesc += "\n\nIs this correct?";
                SetHeader(sDesc);
                AddChoice(GetStringByStrRef(STRREF_YES), TRUE);
                AddChoice(GetStringByStrRef(STRREF_NO), FALSE);
                MarkStageSetUp(nStage, oPC); // This prevents the setup being run for this stage again until MarkStageNotSetUp is called for it
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }
            //add more stages for more nodes with Else If clauses
        }

        // Do token setup
        SetupTokens();
    }
    // End of conversation cleanup
    else if(nValue == DYNCONV_EXITED)
    {
        // Add any locals set through this conversation
        DeleteLocalInt(oPC, "SelectedLevel");
        DeleteLocalInt(oPC, "SpellGainClass");
        DeleteLocalInt(oPC, "SelectedSpell");
        DeleteLocalInt(oPC, "SpellbookMinSpelllevel");
        DeleteLocalInt(oPC, "SpellbookMaxSpelllevel");
        DelayCommand(1.0, EvalPRCFeats(oPC));
    }
    // Abort conversation cleanup.
    // NOTE: This section is only run when the conversation is aborted
    // while aborting is allowed. When it isn't, the dynconvo infrastructure
    // handles restoring the conversation in a transparent manner
    else if(nValue == DYNCONV_ABORTED)
    {
        // Add any locals set through this conversation
        DeleteLocalInt(oPC, "SelectedLevel");
        DeleteLocalInt(oPC, "SelectedSpell");
        DeleteLocalInt(oPC, "SpellGainClass");
        DeleteLocalInt(oPC, "SpellbookMinSpelllevel");
        DeleteLocalInt(oPC, "SpellbookMaxSpelllevel");
        DelayCommand(1.0, EvalPRCFeats(oPC));
    }
    // Handle PC responses
    else
    {
        // variable named nChoice is the value of the player's choice as stored when building the choice list
        // variable named nStage determines the current conversation node
        int nChoice = GetChoice(oPC);
        if(nStage == STAGE_SELECT_LEVEL)
        {        
            SetLocalInt(oPC, "SelectedLevel", nChoice);
            nStage = STAGE_SELECT_SPELL;       
            MarkStageNotSetUp(nStage, oPC);  
        }
        else if(nStage == STAGE_SELECT_SPELL)
        {
            // Move to another stage based on response, for example
            //nStage = STAGE_QUUX;
            SetLocalInt(oPC, "SelectedSpell", nChoice);
            nStage = STAGE_CONFIRM;       
            MarkStageNotSetUp(nStage, oPC);      
        }
        else if(nStage == STAGE_CONFIRM)
        {
            // Move to another stage based on response, for example
            //nStage = STAGE_QUUX;
            if(nChoice == TRUE)
            {  
                int nClass = GetLocalInt(oPC, "SpellGainClass");  
                string sFile = GetFileForClass(nClass);
                int nRow = GetLocalInt(oPC, "SelectedSpell");
                object oSkin = GetPCSkin(oPC);  
                int nIPFeatID = StringToInt(Get2DACache(sFile, "IPFeatID", nRow));
                int nFeatID = StringToInt(Get2DACache(sFile, "FeatID", nRow));
                int nLevel = StringToInt(Get2DACache(sFile, "Level", nRow));
DoDebug("persistant_array_get_size(oPC, Spellbook+IntToString(nClass)) = "+IntToString(persistant_array_get_size(oPC, "Spellbook"+IntToString(nClass))));
                if(!persistant_array_exists(oPC, "Spellbook"+IntToString(nClass)))
                    persistant_array_create(oPC, "Spellbook"+IntToString(nClass));
DoDebug("persistant_array_get_size(oPC, Spellbook+IntToString(nClass)) = "+IntToString(persistant_array_get_size(oPC, "Spellbook"+IntToString(nClass))));
                persistant_array_set_int(oPC, "Spellbook"+IntToString(nClass), 
                    persistant_array_get_size(oPC, "Spellbook"+IntToString(nClass)), nRow);
DoDebug("persistant_array_get_size(oPC, Spellbook+IntToString(nClass)) = "+IntToString(persistant_array_get_size(oPC, "Spellbook"+IntToString(nClass))));
                //this will add feat and stuff
                AddSpellUse(oPC, nRow, nClass);
            
            }
            else
            {        
                DeleteLocalInt(oPC, "SelectedSpell");   
            }
            nStage = STAGE_SELECT_LEVEL; 
            MarkStageNotSetUp(nStage, oPC); 
        }

        // Store the stage value. If it has been changed, this clears out the choices
        SetStage(nStage, oPC);
    }
}
