//:://////////////////////////////////////////////
//:: PRC New Spellbooks use conversation
//:: prc_s_spellb
//:://////////////////////////////////////////////
/** @file
    @todo Primo: Could you write a blurb on what
                 this does and TLKify it?


    @author Primogenitor
    @date   Created  - yyyy.mm.dd
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "inc_newspellbook"
#include "inc_dynconv"


//////////////////////////////////////////////////
/* Constant defintions                          */
//////////////////////////////////////////////////

const int STAGE_SELECT_CLASS       = 0;
const int STAGE_SELECT_SPELL_LEVEL = 1;
const int STAGE_SELECT_SPELL_SLOT  = 2;
const int STAGE_SELECT_SPELL       = 3;


//////////////////////////////////////////////////
/* Aid functions                                */
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
            if(nStage == STAGE_SELECT_CLASS)
            {
                //select spell class
                SetHeader("Select a spell book:");
                int i;
                for(i = 12; i <= 255; i++)
                {
                    if(GetLevelByClass(i, oPC)
                        && GetSpellbookTypeForClass(i) == SPELLBOOK_TYPE_PREPARED
                        && GetSlotCount(GetLevelByClass(i, oPC), 1, GetAbilityForClass(i, oPC), i))
                    {
                        AddChoice(GetStringByStrRef(StringToInt(Get2DACache("classes", "Name", i))), i, oPC);
                    }
                }
                MarkStageSetUp(STAGE_SELECT_CLASS, oPC);

                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }
            else if(nStage == STAGE_SELECT_SPELL_LEVEL)
            {
                // Build a list of spells remaining in this class's slots
                int nSpellClass = GetLocalInt(oPC, "SpellClass");
                string sFile = GetFileForClass(nSpellClass);
                int nClassLevel = GetSpellslotLevel(nSpellClass, oPC);
                int nAbilityScore = GetAbilityForClass(nSpellClass, oPC);
                string sMessage;
                int i;
                sMessage += "You have remaining:\n";
                if(!persistant_array_exists(oPC, "NewSpellbookMem_"+IntToString(nSpellClass)))
                {
            DoDebug("Error: NewSpellbookMem_"+IntToString(nSpellClass)+" array does not exist");
                    persistant_array_create(oPC,  "NewSpellbookMem_"+IntToString(nSpellClass));
                }
                int nArraySize = persistant_array_get_size(oPC, "NewSpellbookMem_" + IntToString(nSpellClass));
                for(i = 0; i < nArraySize; i++)
                {
                    int nUses = persistant_array_get_int(oPC, "NewSpellbookMem_" + IntToString(nSpellClass), i);
                    if(nUses > 0)
                    {
                        int nSpellID = StringToInt(Get2DACache(sFile, "SpellID", i));
                        string sSpellName = GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSpellID)));
                        sMessage += "  "+IntToString(nUses)+" "+sSpellName+"\n";
                    }
                }
                sMessage += "\nSelect a spell level:";
                SetHeader(sMessage);

                // List all spell levels available to the caster for this class
                for(i = 0; i <= 9; i++)
                {
                    if(GetSlotCount(nClassLevel, i, nAbilityScore, nSpellClass))
                    {
                        AddChoice("Spell level "+IntToString(i), i, oPC);
                    }
                }

                MarkStageSetUp(STAGE_SELECT_SPELL_LEVEL, oPC);
            }

            else if(nStage == STAGE_SELECT_SPELL_SLOT)
            {
                SetHeader("Select a spell slot:");

                int nSpellClass = GetLocalInt(oPC, "SpellClass");
                int nSpellLevel = GetLocalInt(oPC, "SpellLevel");
                int nClassLevel = GetSpellslotLevel(nSpellClass, oPC);
                int nAbilityScore = GetAbilityForClass(nSpellClass, oPC);
                int nSlots = GetSlotCount(nClassLevel, nSpellLevel, nAbilityScore, nSpellClass, oPC);
                int nSlot, nFeatID, nSpellbookID;
                string sChoice, sFile;
                for(nSlot = 0; nSlot < nSlots; nSlot++)
                {
                    nSpellbookID = persistant_array_get_int(oPC, "Spellbook"+IntToString(nSpellLevel)+"_"+IntToString(nSpellClass), nSlot);
                    if(nSpellbookID == 0)
                        sChoice = "Empty";
                    else
                    {
                        sFile = GetFileForClass(nSpellClass);
                        nFeatID = StringToInt(Get2DACache(sFile, "IPFeatID", nSpellbookID));
                        sChoice = GetStringByStrRef(StringToInt(Get2DACache("iprp_feats", "Name", nFeatID)));
                    }

                    AddChoice(sChoice, nSlot, oPC);
                }
                MarkStageSetUp(STAGE_SELECT_SPELL_SLOT, oPC);
            }
            else if(nStage == STAGE_SELECT_SPELL)
            {
                // Select spell
                SetHeader("Select a spell:");
                int nSpellLevel = GetLocalInt(oPC, "SpellLevel");
                int nSpellClass = GetLocalInt(oPC, "SpellClass");
                string sFile = GetFileForClass(nSpellClass);
                int i;
                string sTag = "SpellLvl_"+IntToString(nSpellClass)+"_Level_"+IntToString(nSpellLevel);
                object oWP = GetObjectByTag(sTag);
                if(!GetIsObjectValid(oWP))
                    DoDebug("ERROR: "+sTag+" is not valid");
                for(i=0; i<array_get_size(oWP, sTag); i++)
                {
                    int nRow = array_get_int(oWP, sTag, i);
                    if(Get2DACache(sFile, "ReqFeat", nRow)==""                                // Has no prerequisites
                        || GetHasFeat(StringToInt(Get2DACache(sFile, "ReqFeat", nRow)), oPC)) // Or has prerequisites which the PC posseses
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
                for(i = 0; i < SetPRCSwitch(FILE_END_CLASS_SPELLBOOK); i++)
                {
                    if(StringToInt(Get2DACache(sFile, "Level", i)) == nSpellLevel               // Correct spell level
                        && Get2DACache(sFile, "Level", i) != ""                                 // And not undefined spell level in case of SL 0
                        && (Get2DACache(sFile, "ReqFeat", i)==""                                // Has no prerequisites
                            || GetHasFeat(StringToInt(Get2DACache(sFile, "ReqFeat", i)), oPC))) // Or has prerequisites which the PC posseses
                    {                  
                        int nFeatID = StringToInt(Get2DACache(sFile, "IPFeatID", i));
                        AddChoice(GetStringByStrRef(StringToInt(Get2DACache("iprp_feats", "Name", nFeatID))), i, oPC);
DoDebug("PRC_S_spellb i="+IntToString(i));                    
DoDebug("PRC_S_spellb sFile="+sFile);
DoDebug("PRC_S_spellb nFeatID="+IntToString(nFeatID));  
DoDebug("PRC_S_spellb resref="+IntToString(StringToInt(Get2DACache("iprp_feats", "Name", nFeatID))));  
                    }
                }
                */
                MarkStageSetUp(STAGE_SELECT_SPELL, oPC);
            }
        }

        // Do token setup
        SetupTokens();
    }
    else if(nValue == DYNCONV_EXITED)
    {
        //end of conversation cleanup
        DeleteLocalInt(oPC, "SpellClass");
        DeleteLocalInt(oPC, "SpellLevel");
        DeleteLocalInt(oPC, "SpellSlot");
    }
    else if(nValue == DYNCONV_ABORTED)
    {
        //abort conversation cleanup
        DeleteLocalInt(oPC, "SpellClass");
        DeleteLocalInt(oPC, "SpellLevel");
        DeleteLocalInt(oPC, "SpellSlot");

    }
    else
    {
        int nChoice = GetChoice(oPC);
        if(nStage == STAGE_SELECT_CLASS)
        {
           //select class
            SetLocalInt(oPC, "SpellClass", nChoice);
            MarkStageNotSetUp(STAGE_SELECT_CLASS, oPC);
            nStage = STAGE_SELECT_SPELL_LEVEL;
        }
        else if(nStage == STAGE_SELECT_SPELL_LEVEL)
        {
            //select level
            SetLocalInt(oPC, "SpellLevel", nChoice);
            MarkStageNotSetUp(STAGE_SELECT_SPELL_LEVEL, oPC);
            nStage = STAGE_SELECT_SPELL_SLOT;
        }
        else if(nStage == STAGE_SELECT_SPELL_SLOT)
        {
            //select slot
            SetLocalInt(oPC, "SpellSlot", nChoice);
            MarkStageNotSetUp(STAGE_SELECT_SPELL_SLOT, oPC);
            nStage = STAGE_SELECT_SPELL;
        }
        else if(nStage == STAGE_SELECT_SPELL)
        {
            //select spell
            int nSpellSlot = GetLocalInt(oPC, "SpellSlot");
            int nSpellLevel = GetLocalInt(oPC, "SpellLevel");
            int nSpellClass = GetLocalInt(oPC, "SpellClass");
            persistant_array_create(oPC, "Spellbook"+IntToString(nSpellLevel)+"_"+IntToString(nSpellClass));
            persistant_array_set_int(oPC, "Spellbook"+IntToString(nSpellLevel)+"_"+IntToString(nSpellClass), nSpellSlot, nChoice);
            MarkStageNotSetUp(STAGE_SELECT_SPELL, oPC);
            nStage = STAGE_SELECT_SPELL_LEVEL;
        }

        // Store the stage value. If it has been changed, this clears out the choices
        SetStage(nStage, oPC);
    }
}
