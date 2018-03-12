//:://////////////////////////////////////////////
//:: PRC Switch manipulation conversation
//:: prc_switchesc
//:://////////////////////////////////////////////
/** @file
    This conversation is used for changing values
    of the PRC switches ingame.

    @todo Primo: TLKify this

    @author Primogenitor
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "inc_dynconv"
#include "prc_alterations"
#include "inc_epicspells"
#include "prc_inc_leadersh"
#include "prc_inc_natweap"

//////////////////////////////////////////////////
/* Constant defintions                          */
//////////////////////////////////////////////////

const int STAGE_ENTRY                           =  0;
const int STAGE_SWITCHES                        =  1;
const int STAGE_SWITCHES_VALUE                  =  2;
const int STAGE_EPIC_SPELLS                     =  3;
const int STAGE_EPIC_SPELLS_ADD                 =  4;
const int STAGE_EPIC_SPELLS_REMOVE              =  5;
const int STAGE_EPIC_SPELLS_CONTING             =  6;
const int STAGE_SHOPS                           =  8;
const int STAGE_TEFLAMMAR_SHADOWLORD            =  9;
const int STAGE_LEADERSHIP                      = 10;
const int STAGE_LEADERSHIP_ADD_STANDARD         = 11;
const int STAGE_LEADERSHIP_ADD_STANDARD_CONFIRM = 12;
const int STAGE_LEADERSHIP_ADD_CUSTOM_RACE      = 13;
const int STAGE_LEADERSHIP_ADD_CUSTOM_GENDER    = 14;
const int STAGE_LEADERSHIP_ADD_CUSTOM_CLASS     = 15;
const int STAGE_LEADERSHIP_ADD_CUSTOM_ALIGN     = 16;
const int STAGE_LEADERSHIP_ADD_CUSTOM_CONFIRM   = 17;
const int STAGE_LEADERSHIP_REMOVE               = 18;
const int STAGE_LEADERSHIP_DELETE               = 19;
const int STAGE_LEADERSHIP_DELETE_CONFIRM       = 20;
const int STAGE_NATURAL_WEAPON                  = 30;

const int CHOICE_RETURN_TO_PREVIOUS             = 0xEFFFFFFF;
const int CHOICE_SWITCHES_USE_2DA               = 0xEFFFFFFE;


//////////////////////////////////////////////////
/* Aid functions                                */
//////////////////////////////////////////////////

void AddCohortRaces(int nMin, int nMax, object oPC)
{
    int i;
    int nMaxHD = GetCohortMaxLevel(GetLeadershipScore(oPC), oPC);
    for(i=nMin;i<nMax;i++)
    {
        if(Get2DACache("racialtypes", "PlayerRace", i) == "1")
        {
            string sName = GetStringByStrRef(StringToInt(Get2DACache("racialtypes", "Name", i)));
            //if using racial HD, dont add them untill they can afford the minimum racial hd
            if(GetPRCSwitch(PRC_XP_USE_SIMPLE_RACIAL_HD))
            {
                //get the real race
                int nRacialHD = StringToInt(Get2DACache("ECL", "RaceHD", i));
                if(nMaxHD > nRacialHD)
                    AddChoice(sName, i);
            }
            else
                AddChoice(sName, i);
        }
    }
}


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
                SetHeader("What do you want to do?");

                if(GetPRCSwitch(PRC_DISABLE_SWITCH_CHANGING_CONVO) == 0
                    || (GetPRCSwitch(PRC_DISABLE_SWITCH_CHANGING_CONVO) == 1
                    && GetIsDM(oPC)))
                    AddChoice("Alter code switches.", 1);
                if (GetIsEpicCleric(oPC)
                        || GetIsEpicDruid(oPC)
                        || GetIsEpicSorcerer(oPC)
                        || GetIsEpicWizard(oPC))
                    AddChoice("Manage Epic Spells.", 2);
                AddChoice("Purchase general items, such as scrolls or crafting materials.", 3);
                AddChoice("Attempt to identify everything in my inventory.", 4);
                if(GetAlignmentGoodEvil(oPC) != ALIGNMENT_GOOD)
                    AddChoice("Join the Shadowlords as a prerequisited for the Teflammar Shadowlord class.", 5);
                if(GetCanRegister(oPC)
                    && !GetPRCSwitch(PRC_DISABLE_REGISTER_COHORTS))
                    AddChoice("Register this character as a cohort.", 6);
                if(GetMaximumCohortCount(oPC))
                    AddChoice("Manage cohorts.", 7);
                if(GetPrimaryNaturalWeaponCount(oPC))
                    AddChoice("Select primary natural weapon.", 8);


                MarkStageSetUp(nStage, oPC);
                SetDefaultTokens(); // Set the next, previous, exit and wait tokens to default values
            }
            else if(nStage == STAGE_SWITCHES)
            {
                SetHeader("Select a variable to modify.\n"
                        + "See prc_inc_switches for descriptions.\n"
                        + "In most cases zero is off and any other value is on."
                         );

                // First choice is Back, so people don't have to scroll ten pages to find it
                AddChoice("Back", CHOICE_RETURN_TO_PREVIOUS);

                // Add a special choices
                AddChoice("Read personal_switch.2da and set switches based on it's contents", CHOICE_SWITCHES_USE_2DA);


                // Get the switches container waypoint, and call the builder function if it doesn't exist yet (it should)
                object oWP = GetWaypointByTag("PRC_Switch_Name_WP");
                if(!GetIsObjectValid(oWP))
                {
                    if(DEBUG) DoDebug("prc_switchesc: PRC_Switch_Name_WP did not exist, attempting creation");
                    CreateSwitchNameArray();
                    oWP = GetWaypointByTag("PRC_Switch_Name_WP");
                    if(DEBUG) DoDebug("prc_switchesc: PRC_Switch_Name_WP " + (GetIsObjectValid(oWP) ? "created":"not created"));
                }
                int i;
                for(i = 0; i < array_get_size(oWP, "Switch_Name"); i++)
                {
                    AddChoice(array_get_string(oWP, "Switch_Name", i), i, oPC);
                }

                MarkStageSetUp(nStage, oPC);
            }
            else if(nStage == STAGE_SWITCHES_VALUE)
            {
                string sVarName = GetLocalString(oPC, "VariableName");
                int nVal = GetPRCSwitch(sVarName);

                SetHeader("CurrentValue is: " + IntToString(nVal) + "\n"
                        + "CurrentVariable is: " + sVarName + "\n"
                        + "Select an ammount to modify the variable by:"
                          );

                AddChoice("Back", CHOICE_RETURN_TO_PREVIOUS);
                AddChoice("-10", -10);
                AddChoice("-5", -5);
                AddChoice("-4", -4);
                AddChoice("-3", -3);
                AddChoice("-2", -2);
                AddChoice("-1", -1);
                AddChoice("+1", 1);
                AddChoice("+2", 2);
                AddChoice("+3", 3);
                AddChoice("+4", 4);
                AddChoice("+5", 5);
                AddChoice("+10", 10);
            }
            else if(nStage == STAGE_EPIC_SPELLS)
            {
                SetHeader("Make a selection.");
                AddChoice("Back", CHOICE_RETURN_TO_PREVIOUS);
                if(GetCastableFeatCount(oPC)>0)
                    AddChoice("Remove an Epic Spell from the radial menu.", 1);
                if(GetCastableFeatCount(oPC)<7)
                    AddChoice("Add an Epic Spell to the radial menu.", 2);
                AddChoice("Manage any active contingencies.", 3);
                if(!GetPRCSwitch(PRC_EPIC_CONVO_LEARNING_DISABLE))
                    AddChoice("Research an Epic Spell.", 4);

                MarkStageSetUp(nStage, oPC);
            }
            else if(nStage == STAGE_EPIC_SPELLS_ADD)
            {
                SetHeader("Choose the spell to add.");
                int i;
                for(i = 0; i < 71; i++)
                {
                    int nResearchedFeat = StringToInt(Get2DACache("epicspells", "ResFeatID", i));
                    int nSpellFeat = StringToInt(Get2DACache("epicspells", "SpellFeatID", i));
                    if(GetHasFeat(nResearchedFeat, oPC) && !GetHasFeat(nSpellFeat, oPC))
                    {
                        string sName = GetStringByStrRef(
                            StringToInt(Get2DACache("feat", "FEAT", nSpellFeat)));
                        AddChoice(sName, i, oPC);
                    }
                }
                AddChoice("Back", CHOICE_RETURN_TO_PREVIOUS);

                MarkStageSetUp(nStage, oPC);
            }
            else if(nStage == STAGE_EPIC_SPELLS_REMOVE)
            {
                SetHeader("Choose the spell to remove.");
                int i;
                for(i = 0; i < 71; i++)
                {
                    int nFeat = StringToInt(Get2DACache("epicspells", "SpellFeatID", i));
                    if(GetHasFeat(nFeat, oPC))
                    {
                        string sName = GetStringByStrRef(
                            StringToInt(Get2DACache("feat", "FEAT", StringToInt(
                                Get2DACache("epicspells", "SpellFeatID", i)))));
                        AddChoice(sName, i, oPC);
                    }
                }
                AddChoice("Back", CHOICE_RETURN_TO_PREVIOUS);

                MarkStageSetUp(nStage, oPC);
            }
            else if(nStage == STAGE_EPIC_SPELLS_CONTING)
            {
                SetHeader("Choose an active contingency to dispel. Dispelling will pre-emptively end the contingency and restore the reserved epic spell slot for your use.");
                if(GetLocalInt(oPC, "nContingentRez"))
                    AddChoice("Dispel any contingent resurrections.", 1);
                AddChoice("Back", CHOICE_RETURN_TO_PREVIOUS);

                MarkStageSetUp(nStage, oPC);
            }
            else if(nStage == STAGE_SHOPS)
            {
                SetHeader("Select what type of item you wish to purchase.");
                if(GetHasFeat(FEAT_CRAFT_ITEM, oPC)
                    && !GetPRCSwitch(PRC_SPELLSLAB_NORECIPES))
                    AddChoice("Crafting recipes", 1);
                if(GetHasFeat(FEAT_BREW_POTION, oPC)
                    || GetHasFeat(FEAT_SCRIBE_SCROLL, oPC)
                    || GetHasFeat(FEAT_CRAFT_WAND, oPC))
                    AddChoice("Magic item raw materials", 2);
                if(!GetPRCSwitch(PRC_SPELLSLAB_NOSCROLLS))
                    AddChoice("Spell scrolls", 3);
                if ((GetIsEpicCleric(oPC)
                        || GetIsEpicDruid(oPC)
                        || GetIsEpicSorcerer(oPC)
                        || GetIsEpicWizard(oPC))
                    && GetPRCSwitch(PRC_SPELLSLAB) != 3
                    )
                    AddChoice("Epic spell books", 4);
                AddChoice("Back", CHOICE_RETURN_TO_PREVIOUS);

                MarkStageSetUp(nStage, oPC);
            }
            else if(nStage == STAGE_TEFLAMMAR_SHADOWLORD)
            {
                SetHeader("This will cost you 10,000 GP, are you prepared to pay this?");
                if(GetGold(oPC) >= 10000)
                    AddChoice("Yes", 1);
                AddChoice("Back", CHOICE_RETURN_TO_PREVIOUS);

                MarkStageSetUp(nStage, oPC);
            }
            else if(nStage == STAGE_LEADERSHIP)
            {
                SetHeader("What do you want to change?");
                if(GetCurrentCohortCount(oPC) < GetMaximumCohortCount(oPC)
                    && !GetLocalInt(oPC, "CohortRecruited")
                    && !GetPRCSwitch(PRC_DISABLE_CUSTOM_COHORTS))
                    AddChoice("Recruit a custom cohort", 1);
                if(GetCurrentCohortCount(oPC) < GetMaximumCohortCount(oPC)
                    && !GetLocalInt(oPC, "CohortRecruited")
                    && !GetPRCSwitch(PRC_DISABLE_STANDARD_COHORTS))
                    AddChoice("Recruit a standard cohort", 4);
                //not implemented, remove via radial or conversation
                //if(GetCurrentCohortCount(oPC))
                //    AddChoice("Dismiss an existing cohort", 2);
                if(GetCampaignInt(COHORT_DATABASE, "CohortCount")>0)
                    AddChoice("Delete a stored custom cohort", 3);
                AddChoice("Back", CHOICE_RETURN_TO_PREVIOUS);

                MarkStageSetUp(nStage, oPC);
            }
            else if(nStage == STAGE_LEADERSHIP_ADD_STANDARD)
            {
                SetHeader("Select a cohort:");

                int nCohortCount = GetCampaignInt(COHORT_DATABASE, "CohortCount");
                int i;
                for(i=1;i<=nCohortCount;i++)
                {
                    if(GetIsCohortChoiceValidByID(i, oPC))
                    {
                        string sName = GetCampaignString(COHORT_DATABASE, "Cohort_"+IntToString(i)+"_name");
                        AddChoice(sName, i);
                    }
                }

                AddChoice("Back", CHOICE_RETURN_TO_PREVIOUS);

                MarkStageSetUp(nStage, oPC);
            }
            else if(nStage == STAGE_LEADERSHIP_ADD_STANDARD_CONFIRM)
            {
                string sHeader = "Are you sure you want this cohort?";

                int nCohortID = GetLocalInt(oPC, "CohortID");
                string sName = GetCampaignString(  COHORT_DATABASE, "Cohort_"+IntToString(nCohortID)+"_name");
                int    nRace = GetCampaignInt(     COHORT_DATABASE, "Cohort_"+IntToString(nCohortID)+"_race");
                int    nClass1=GetCampaignInt(     COHORT_DATABASE, "Cohort_"+IntToString(nCohortID)+"_class1");
                int    nClass2=GetCampaignInt(     COHORT_DATABASE, "Cohort_"+IntToString(nCohortID)+"_class2");
                int    nClass3=GetCampaignInt(     COHORT_DATABASE, "Cohort_"+IntToString(nCohortID)+"_class3");
                int    nOrder= GetCampaignInt(     COHORT_DATABASE, "Cohort_"+IntToString(nCohortID)+"_order");
                int    nMoral= GetCampaignInt(     COHORT_DATABASE, "Cohort_"+IntToString(nCohortID)+"_moral");
                sHeader +="\n"+sName;
                sHeader +="\n"+GetStringByStrRef(StringToInt(Get2DACache("racialtypes", "Name", nRace)));
                sHeader +="\n"+GetStringByStrRef(StringToInt(Get2DACache("classes", "Name", nClass1)));
                if(nClass2 != CLASS_TYPE_INVALID)
                    sHeader +=" / "+GetStringByStrRef(StringToInt(Get2DACache("classes", "Name", nClass2)));
                if(nClass3 != CLASS_TYPE_INVALID)
                    sHeader +=" / "+GetStringByStrRef(StringToInt(Get2DACache("classes", "Name", nClass3)));
                SetHeader(sHeader);
                AddChoice("Yes", 1);
                AddChoice("Back", CHOICE_RETURN_TO_PREVIOUS);

                MarkStageSetUp(nStage, oPC);
            }
            else if(nStage == STAGE_LEADERSHIP_ADD_CUSTOM_RACE)
            {
                SetHeader("Select a race for the cohort:");
                AddCohortRaces(  0, 100, oPC);
                DelayCommand(0.01, AddCohortRaces(101, 200, oPC));
                DelayCommand(0.02, AddCohortRaces(201, 255, oPC));

                MarkStageSetUp(nStage, oPC);
            }
            else if(nStage == STAGE_LEADERSHIP_ADD_CUSTOM_GENDER)
            {
                SetHeader("Select a gender for the cohort:");
                AddChoice("Male", GENDER_MALE);
                AddChoice("Female", GENDER_FEMALE);

                MarkStageSetUp(nStage, oPC);
            }
            else if(nStage == STAGE_LEADERSHIP_ADD_CUSTOM_CLASS)
            {
                SetHeader("Select a class for the cohort:");
                int i;
                //only do bioware base classes for now otherwise the AI will fubar
                for(i=0;i<=10;i++)
                {
                    string sName = GetStringByStrRef(StringToInt(Get2DACache("classes", "Name", i)));
                    AddChoice(sName, i);
                }
                MarkStageSetUp(nStage, oPC);
            }
            else if(nStage == STAGE_LEADERSHIP_ADD_CUSTOM_ALIGN)
            {
                SetHeader("Select an alignment for the cohort:");

                int nClass = GetLocalInt(oPC, "CustomCohortClass");
                if(GetIsValidAlignment(ALIGNMENT_LAWFUL, ALIGNMENT_GOOD,
                    HexToInt(Get2DACache("classes", "AlignRestrict",nClass)),
                    HexToInt(Get2DACache("classes", "AlignRstrctType",nClass)),
                    HexToInt(Get2DACache("classes", "InvertRestrict",nClass))))
                {
                    AddChoice(GetStringByStrRef(112), 0);
                }
                if(GetIsValidAlignment(ALIGNMENT_NEUTRAL, ALIGNMENT_GOOD,
                    HexToInt(Get2DACache("classes", "AlignRestrict",nClass)),
                    HexToInt(Get2DACache("classes", "AlignRstrctType",nClass)),
                    HexToInt(Get2DACache("classes", "InvertRestrict",nClass))))
                {
                    AddChoice(GetStringByStrRef(115), 1);
                }
                if(GetIsValidAlignment(ALIGNMENT_CHAOTIC, ALIGNMENT_GOOD,
                    HexToInt(Get2DACache("classes", "AlignRestrict",nClass)),
                    HexToInt(Get2DACache("classes", "AlignRstrctType",nClass)),
                    HexToInt(Get2DACache("classes", "InvertRestrict",nClass))))
                {
                    AddChoice(GetStringByStrRef(118), 2);
                }
                if(GetIsValidAlignment(ALIGNMENT_LAWFUL, ALIGNMENT_NEUTRAL,
                    HexToInt(Get2DACache("classes", "AlignRestrict",nClass)),
                    HexToInt(Get2DACache("classes", "AlignRstrctType",nClass)),
                    HexToInt(Get2DACache("classes", "InvertRestrict",nClass))))
                {
                    AddChoice(GetStringByStrRef(113), 3);
                }
                if(GetIsValidAlignment(ALIGNMENT_NEUTRAL, ALIGNMENT_NEUTRAL,
                    HexToInt(Get2DACache("classes", "AlignRestrict",nClass)),
                    HexToInt(Get2DACache("classes", "AlignRstrctType",nClass)),
                    HexToInt(Get2DACache("classes", "InvertRestrict",nClass))))
                {
                    AddChoice(GetStringByStrRef(116), 4);
                }
                if(GetIsValidAlignment(ALIGNMENT_CHAOTIC, ALIGNMENT_NEUTRAL,
                    HexToInt(Get2DACache("classes", "AlignRestrict",nClass)),
                    HexToInt(Get2DACache("classes", "AlignRstrctType",nClass)),
                    HexToInt(Get2DACache("classes", "InvertRestrict",nClass))))
                {
                    AddChoice(GetStringByStrRef(119), 5);
                }
                if(GetIsValidAlignment(ALIGNMENT_LAWFUL, ALIGNMENT_EVIL,
                    HexToInt(Get2DACache("classes", "AlignRestrict",nClass)),
                    HexToInt(Get2DACache("classes", "AlignRstrctType",nClass)),
                    HexToInt(Get2DACache("classes", "InvertRestrict",nClass))))
                {
                    AddChoice(GetStringByStrRef(114), 6);
                }
                if(GetIsValidAlignment(ALIGNMENT_NEUTRAL, ALIGNMENT_EVIL,
                    HexToInt(Get2DACache("classes", "AlignRestrict",nClass)),
                    HexToInt(Get2DACache("classes", "AlignRstrctType",nClass)),
                    HexToInt(Get2DACache("classes", "InvertRestrict",nClass))))
                {
                    AddChoice(GetStringByStrRef(117), 7);
                }
                if(GetIsValidAlignment(ALIGNMENT_CHAOTIC, ALIGNMENT_EVIL,
                    HexToInt(Get2DACache("classes", "AlignRestrict",nClass)),
                    HexToInt(Get2DACache("classes", "AlignRstrctType",nClass)),
                    HexToInt(Get2DACache("classes", "InvertRestrict",nClass))))
                {
                    AddChoice(GetStringByStrRef(120), 8);
                }
                MarkStageSetUp(nStage, oPC);
            }
            else if(nStage == STAGE_LEADERSHIP_ADD_CUSTOM_CONFIRM)
            {
                string sHeader = "Are you sure you want this cohort?";
                int    nRace = GetLocalInt(oPC, "CustomCohortRace");
                int    nClass= GetLocalInt(oPC, "CustomCohortClass");
                int    nOrder= GetLocalInt(oPC, "CustomCohortOrder");
                int    nMoral= GetLocalInt(oPC, "CustomCohortMoral");
                int    nGender=GetLocalInt(oPC, "CustomCohortGender");
                string sKey=   GetPCPublicCDKey(oPC);
                sHeader +="\n"+GetStringByStrRef(StringToInt(Get2DACache("racialtypes", "Name", nRace)));
                sHeader +="\n"+GetStringByStrRef(StringToInt(Get2DACache("classes", "Name", nClass)));
                SetHeader(sHeader);
                // GetIsCohortChoiceValid(sName, nRace, nClass1, nClass2,            nClass3,            nOrder, nMoral, nEthran, sKey, nDeleted, oPC);
                if(GetIsCohortChoiceValid("",    nRace, nClass,  CLASS_TYPE_INVALID, CLASS_TYPE_INVALID, nOrder, nMoral, FALSE,   sKey, FALSE,    oPC))
                {
                    AddChoice("Yes", 1);
                    AddChoice("Back", CHOICE_RETURN_TO_PREVIOUS);
                }
                else
                    AddChoice("This cohort is invalid", CHOICE_RETURN_TO_PREVIOUS);

                MarkStageSetUp(nStage, oPC);
            }
            else if(nStage == STAGE_LEADERSHIP_DELETE)
            {
                SetHeader("Select a cohort to delete:");

                int nCohortCount = GetCampaignInt(COHORT_DATABASE, "CohortCount");
                int i;
                for(i=1;i<=nCohortCount;i++)
                {
                    if(GetIsCohortChoiceValidByID(i, oPC))
                    {
                        string sName = GetCampaignString(COHORT_DATABASE, "Cohort_"+IntToString(i)+"_name");
                        AddChoice(sName, i);
                    }
                }

                AddChoice("Back", CHOICE_RETURN_TO_PREVIOUS);

                MarkStageSetUp(nStage, oPC);
            }
            else if(nStage == STAGE_LEADERSHIP_DELETE_CONFIRM)
            {
                string sHeader = "Are you sure you want to delete this cohort?";

                int nCohortID = GetLocalInt(oPC, "CohortID");
                string sName = GetCampaignString(  COHORT_DATABASE, "Cohort_"+IntToString(nCohortID)+"_name");
                int    nRace = GetCampaignInt(     COHORT_DATABASE, "Cohort_"+IntToString(nCohortID)+"_race");
                int    nClass1=GetCampaignInt(     COHORT_DATABASE, "Cohort_"+IntToString(nCohortID)+"_class1");
                int    nClass2=GetCampaignInt(     COHORT_DATABASE, "Cohort_"+IntToString(nCohortID)+"_class2");
                int    nClass3=GetCampaignInt(     COHORT_DATABASE, "Cohort_"+IntToString(nCohortID)+"_class3");
                int    nOrder= GetCampaignInt(     COHORT_DATABASE, "Cohort_"+IntToString(nCohortID)+"_order");
                int    nMoral= GetCampaignInt(     COHORT_DATABASE, "Cohort_"+IntToString(nCohortID)+"_moral");
                sHeader +="\n"+sName;
                sHeader +="\n"+GetStringByStrRef(StringToInt(Get2DACache("racialtypes", "Name", nRace)));
                sHeader +="\n"+GetStringByStrRef(StringToInt(Get2DACache("classes", "Name", nClass1)));
                if(nClass2 != CLASS_TYPE_INVALID)
                    sHeader +=" / "+GetStringByStrRef(StringToInt(Get2DACache("classes", "Name", nClass2)));
                if(nClass3 != CLASS_TYPE_INVALID)
                    sHeader +=" / "+GetStringByStrRef(StringToInt(Get2DACache("classes", "Name", nClass3)));
                SetHeader(sHeader);
                AddChoice("Yes", 1);
                AddChoice("Back", CHOICE_RETURN_TO_PREVIOUS);

                MarkStageSetUp(nStage, oPC);
            }
            else if (nStage == STAGE_NATURAL_WEAPON)
            {
                string sHeader = "Select a natural weapon to use.";
                SetHeader(sHeader);
                AddChoice("Unarmed", -512);
                int i;
                for(i=0;i<GetPrimaryNaturalWeaponCount(oPC);i++)
                {
                    string sName;
                    //use resref for now
                    sName = array_get_string(oPC, ARRAY_NAT_PRI_WEAP_RESREF, i);
                    AddChoice(sName, i);
                }
                AddChoice("Back", CHOICE_RETURN_TO_PREVIOUS);

                MarkStageSetUp(nStage, oPC);
            
            }
        }

        // Do token setup
        SetupTokens();
    }
    else if(nValue == DYNCONV_EXITED)
    {
        //end of conversation cleanup
        array_delete(oPC, "StagesSetup");
        DeleteLocalString(oPC, "VariableName");
        DeleteLocalInt(oPC, "CohortID");
        DeleteLocalInt(oPC, "CustomCohortRace");
        DeleteLocalInt(oPC, "CustomCohortClass");
        DeleteLocalInt(oPC, "CustomCohortMoral");
        DeleteLocalInt(oPC, "CustomCohortOrder");
        DeleteLocalInt(oPC, "CustomCohortGender");
    }
    else if(nValue == DYNCONV_ABORTED)
    {
        //abort conversation cleanup
        array_delete(oPC, "StagesSetup");
        DeleteLocalString(oPC, "VariableName");
        DeleteLocalInt(oPC, "CohortID");
        DeleteLocalInt(oPC, "CustomCohortRace");
        DeleteLocalInt(oPC, "CustomCohortClass");
        DeleteLocalInt(oPC, "CustomCohortMoral");
        DeleteLocalInt(oPC, "CustomCohortOrder");
        DeleteLocalInt(oPC, "CustomCohortGender");
    }
    else
    {
        // PC response handling
        int nChoice = GetChoice(oPC);
        if(nStage == STAGE_ENTRY)
        {
            if(nChoice == CHOICE_RETURN_TO_PREVIOUS)
                nStage = STAGE_ENTRY;
            else if(nChoice == 1)
                nStage = STAGE_SWITCHES;
            else if(nChoice == 2)
                nStage = STAGE_EPIC_SPELLS;
            else if(nChoice == 3)
                nStage = STAGE_SHOPS;
            else if(nChoice == 4)
            {
                AssignCommand(oPC, TryToIDItems(oPC));
                AllowExit(DYNCONV_EXIT_FORCE_EXIT);
            }
            else if(nChoice == 5)
                nStage = STAGE_TEFLAMMAR_SHADOWLORD;
            else if(nChoice == 6)
            {
                RegisterAsCohort(oPC);
                AllowExit(DYNCONV_EXIT_FORCE_EXIT);
            }
            else if(nChoice == 7)
                nStage = STAGE_LEADERSHIP;
            else if(nChoice == 8)
                nStage = STAGE_NATURAL_WEAPON;

            // Mark the target stage to need building if it was changed (ie, selection was other than ID all)
            if(nStage != STAGE_ENTRY)
                MarkStageNotSetUp(nStage, oPC);
        }
        else if(nStage == STAGE_SWITCHES)
        {
            if(nChoice == CHOICE_RETURN_TO_PREVIOUS)
                nStage = STAGE_ENTRY;
            else if(nChoice == CHOICE_SWITCHES_USE_2DA)
            {
                object oModule = GetModule();
                int i = 0;
                string sSwitchName, sSwitchType, sSwitchValue;
                // Use Get2DAString() instead of Get2DACache() to avoid caching.
                // People might want to set different switch values when playing in different modules.
                // Or just change the switch values midplay.
                while((sSwitchName = Get2DAString("personal_switch", "SwitchName", i)) != "")
                {
                    // Read rest of the line
                    sSwitchType  = Get2DAString("personal_switch", "SwitchType",  i);
                    sSwitchValue = Get2DAString("personal_switch", "SwitchValue", i);

                    // Determine switch type and set the var
                    if(sSwitchType == "float")
                        SetLocalFloat(oModule, sSwitchName, StringToFloat(sSwitchValue));
                    else if(sSwitchType == "int")
                        SetPRCSwitch(sSwitchName, StringToInt(sSwitchValue));
                    else if(sSwitchType == "string")
                        SetLocalString(oModule, sSwitchName, sSwitchValue);

                    // Increment loop counter
                    i += 1;
                }
            }
            else
            {
                //move to another stage based on response
                SetLocalString(oPC, "VariableName", GetChoiceText(oPC));
                nStage = STAGE_SWITCHES_VALUE;
            }
            MarkStageNotSetUp(nStage, oPC);
        }
        else if(nStage == STAGE_SWITCHES_VALUE)
        {
            if(nChoice == CHOICE_RETURN_TO_PREVIOUS)
            {
                nStage = STAGE_SWITCHES;
            }
            else
            {
                string sVarName = GetLocalString(oPC, "VariableName");
                SetPRCSwitch(sVarName, GetPRCSwitch(sVarName) + nChoice);
            }
            MarkStageNotSetUp(nStage, oPC);
        }
        else if(nStage == STAGE_EPIC_SPELLS)
        {
            if(nChoice == CHOICE_RETURN_TO_PREVIOUS)
                nStage = STAGE_ENTRY;
            else if (nChoice == 1)
                nStage = STAGE_EPIC_SPELLS_REMOVE;
            else if (nChoice == 2)
                nStage = STAGE_EPIC_SPELLS_ADD;
            else if (nChoice == 3)
                nStage = STAGE_EPIC_SPELLS_CONTING;
            else if (nChoice == 4)
            {
                //research an epic spell
                object oPlaceable = CreateObject(OBJECT_TYPE_PLACEABLE, "prc_ess_research", GetLocation(oPC));
                if(!GetIsObjectValid(oPlaceable))
                    DoDebug("Research placeable not valid.");
                AssignCommand(oPC, ClearAllActions());
                AssignCommand(oPC, DoPlaceableObjectAction(oPlaceable, PLACEABLE_ACTION_USE));
                SPApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY), oPlaceable);
                DestroyObject(oPlaceable, 60.0);
                //end the conversation
                AllowExit(DYNCONV_EXIT_FORCE_EXIT);
            }

            MarkStageNotSetUp(nStage, oPC);
        }
        else if(nStage == STAGE_EPIC_SPELLS_ADD)
        {
            if(nChoice == CHOICE_RETURN_TO_PREVIOUS)
                nStage = STAGE_EPIC_SPELLS;
            else
            {
                GiveFeat(oPC, StringToInt(Get2DACache("epicspells", "SpellFeatIPID", nChoice)));
                ClearCurrentStage();
            }
            MarkStageNotSetUp(nStage, oPC);
        }
        else if(nStage == STAGE_EPIC_SPELLS_REMOVE)
        {
            if(nChoice == CHOICE_RETURN_TO_PREVIOUS)
                nStage = STAGE_EPIC_SPELLS;
            else
            {
                TakeFeat(oPC, StringToInt(Get2DACache("epicspells", "SpellFeatIPID", nChoice)));
                ClearCurrentStage();
            }
            MarkStageNotSetUp(nStage, oPC);
        }
        else if(nStage == STAGE_EPIC_SPELLS_CONTING)
        {
            //contingencies
            if(nChoice == CHOICE_RETURN_TO_PREVIOUS)
                nStage = STAGE_EPIC_SPELLS;
            else if(nChoice == 1) //contingent resurrection
                SetLocalInt(oPC, "nContingentRez", 0);

            MarkStageNotSetUp(nStage, oPC);
        }
        else if(nStage == STAGE_SHOPS)
        {
            if(nChoice == CHOICE_RETURN_TO_PREVIOUS)
                nStage = STAGE_ENTRY;
            else if (nChoice == 1)
            {
                //Crafting recipes
                object oStore = GetObjectByTag("prc_recipe");
                if(!GetIsObjectValid(oStore))
                {
                    location lLimbo = GetLocation(GetObjectByTag("HEARTOFCHAOS"));
                    oStore = CreateObject(OBJECT_TYPE_STORE, "prc_recipe", lLimbo);
                }
                DelayCommand(1.0, OpenStore(oStore, oPC));
                AllowExit(DYNCONV_EXIT_FORCE_EXIT);
            }
            else if (nChoice == 2)
            {
                //Magic item raw materials
                object oStore = GetObjectByTag("prc_magiccraft");
                if(!GetIsObjectValid(oStore))
                {
                    location lLimbo = GetLocation(GetObjectByTag("HEARTOFCHAOS"));
                    oStore = CreateObject(OBJECT_TYPE_STORE, "prc_magiccraft", lLimbo);
                }
                DelayCommand(1.0, OpenStore(oStore, oPC));
                AllowExit(DYNCONV_EXIT_FORCE_EXIT);
            }
            else if (nChoice == 3)
            {
                //Spell scrolls
                object oStore = GetObjectByTag("prc_scrolls");
                if(!GetIsObjectValid(oStore))
                {
                    location lLimbo = GetLocation(GetObjectByTag("HEARTOFCHAOS"));
                    oStore = CreateObject(OBJECT_TYPE_STORE, "prc_scrolls", lLimbo);
                }
                DelayCommand(1.0, OpenStore(oStore, oPC));
                AllowExit(DYNCONV_EXIT_FORCE_EXIT);
            }
            else if (nChoice == 4)
            {
                //Epic spell books
                object oStore = GetObjectByTag("prc_epicspells");
                if(!GetIsObjectValid(oStore))
                {
                    location lLimbo = GetLocation(GetObjectByTag("HEARTOFCHAOS"));
                    oStore = CreateObject(OBJECT_TYPE_STORE, "prc_epicspells", lLimbo);
                }
                DelayCommand(1.0, OpenStore(oStore, oPC));
                AllowExit(DYNCONV_EXIT_FORCE_EXIT);
            }

            //MarkStageNotSetUp(nStage, oPC);
        }
        else if(nStage == STAGE_TEFLAMMAR_SHADOWLORD)
        {
            nStage = STAGE_ENTRY;
            if(nChoice == 1)
            {
                AssignCommand(oPC, ClearAllActions());
                AssignCommand(oPC, TakeGoldFromCreature(10000, oPC, TRUE));
                //use a persistant local instead of an item
                //CreateItemOnObject("shadowwalkerstok", oPC);
                SetPersistantLocalInt(oPC, "shadowwalkerstok", TRUE);
                SetLocalInt(oPC, "PRC_PrereqTelflam", 0);
            }
            MarkStageNotSetUp(nStage, oPC);
        }
        else if(nStage == STAGE_LEADERSHIP)
        {
            if(nChoice == 1)
                nStage = STAGE_LEADERSHIP_ADD_STANDARD;
            else if(nChoice == 2)
                nStage = STAGE_LEADERSHIP_REMOVE;
            else if(nChoice == 3)
                nStage = STAGE_LEADERSHIP_DELETE;
            else if(nChoice == 4)
                nStage = STAGE_LEADERSHIP_ADD_CUSTOM_RACE;
            else if(nChoice == CHOICE_RETURN_TO_PREVIOUS)
                nStage = STAGE_ENTRY;
            MarkStageNotSetUp(nStage, oPC);
        }
        else if(nStage == STAGE_LEADERSHIP_REMOVE)
        {
            if(nChoice == CHOICE_RETURN_TO_PREVIOUS)
            {

            }
            else
            {
                int nCohortID = GetLocalInt(oPC, "CohortID");
                RemoveCohortFromPlayer(GetCohort(nCohortID, oPC), oPC);
            }
            nStage = STAGE_LEADERSHIP;
            MarkStageNotSetUp(nStage, oPC);
        }
        else if(nStage == STAGE_LEADERSHIP_ADD_STANDARD)
        {
            if(nChoice == CHOICE_RETURN_TO_PREVIOUS)
                nStage = STAGE_LEADERSHIP;
            else
            {
                SetLocalInt(oPC, "CohortID", nChoice);
                nStage = STAGE_LEADERSHIP_ADD_STANDARD_CONFIRM;
            }
            MarkStageNotSetUp(nStage, oPC);
        }
        else if(nStage == STAGE_LEADERSHIP_ADD_STANDARD_CONFIRM)
        {
            if(nChoice == 1)
            {
                int nCohortID = GetLocalInt(oPC, "CohortID");
                AddCohortToPlayer(nCohortID, oPC);
                //mark the player as having recruited for the day
                SetLocalInt(oPC, "CohortRecruited", TRUE);
                nStage = STAGE_LEADERSHIP;
            }
            else if(nChoice == CHOICE_RETURN_TO_PREVIOUS)
                nStage = STAGE_LEADERSHIP_ADD_STANDARD;
            MarkStageNotSetUp(nStage, oPC);
        }
        else if(nStage == STAGE_LEADERSHIP_ADD_CUSTOM_RACE)
        {
            SetLocalInt(oPC, "CustomCohortRace", nChoice);
            nStage = STAGE_LEADERSHIP_ADD_CUSTOM_GENDER;
            MarkStageNotSetUp(nStage, oPC);
        }
        else if(nStage == STAGE_LEADERSHIP_ADD_CUSTOM_GENDER)
        {
            SetLocalInt(oPC, "CustomCohortGender", nChoice);
            nStage = STAGE_LEADERSHIP_ADD_CUSTOM_CLASS;
            MarkStageNotSetUp(nStage, oPC);
        }
        else if(nStage == STAGE_LEADERSHIP_ADD_CUSTOM_CLASS)
        {
            SetLocalInt(oPC, "CustomCohortClass", nChoice);
            nStage = STAGE_LEADERSHIP_ADD_CUSTOM_ALIGN;
            MarkStageNotSetUp(nStage, oPC);
        }
        else if(nStage == STAGE_LEADERSHIP_ADD_CUSTOM_ALIGN)
        {
            switch(nChoice)
            {
                case 0: //lawful good
                    SetLocalInt(OBJECT_SELF, "CustomCohortOrder", 85);
                    SetLocalInt(OBJECT_SELF, "CustomCohortMoral", 85);
                    break;
                case 1: //neutral good
                    SetLocalInt(OBJECT_SELF, "CustomCohortOrder", 50);
                    SetLocalInt(OBJECT_SELF, "CustomCohortMoral", 85);
                    break;
                case 2: //chaotic good
                    SetLocalInt(OBJECT_SELF, "CustomCohortOrder", 15);
                    SetLocalInt(OBJECT_SELF, "CustomCohortMoral", 85);
                    break;
                case 3: //lawful neutral
                    SetLocalInt(OBJECT_SELF, "CustomCohortOrder", 85);
                    SetLocalInt(OBJECT_SELF, "CustomCohortMoral", 50);
                    break;
                case 4: //true neutral
                    SetLocalInt(OBJECT_SELF, "CustomCohortOrder", 50);
                    SetLocalInt(OBJECT_SELF, "CustomCohortMoral", 50);
                    break;
                case 5: //chaotic neutral
                    SetLocalInt(OBJECT_SELF, "CustomCohortOrder", 15);
                    SetLocalInt(OBJECT_SELF, "CustomCohortMoral", 50);
                    break;
                case 6: //lawful evil
                    SetLocalInt(OBJECT_SELF, "CustomCohortOrder", 85);
                    SetLocalInt(OBJECT_SELF, "CustomCohortMoral", 15);
                    break;
                case 7: //neutral evil
                    SetLocalInt(OBJECT_SELF, "CustomCohortOrder", 50);
                    SetLocalInt(OBJECT_SELF, "CustomCohortMoral", 15);
                    break;
                case 8: //chaotic evil
                    SetLocalInt(OBJECT_SELF, "CustomCohortOrder", 15);
                    SetLocalInt(OBJECT_SELF, "CustomCohortMoral", 15);
                    break;
            }
            nStage = STAGE_LEADERSHIP_ADD_CUSTOM_CONFIRM;
            MarkStageNotSetUp(nStage, oPC);
        }
        else if(nStage == STAGE_LEADERSHIP_ADD_CUSTOM_CONFIRM)
        {
            if(nChoice == 1)
            {
                int    nRace = GetLocalInt(oPC, "CustomCohortRace");
                int    nClass= GetLocalInt(oPC, "CustomCohortClass");
                int    nOrder= GetLocalInt(oPC, "CustomCohortOrder");
                int    nMoral= GetLocalInt(oPC, "CustomCohortMoral");
                int    nGender= GetLocalInt(oPC, "CustomCohortGender");
                string sResRef = "prc_npc_"+IntToString(nRace)+"_"+IntToString(nClass)+"_"+IntToString(nGender);
                location lSpawn = GetLocation(oPC);
                object oCohort = CreateObject(OBJECT_TYPE_CREATURE, sResRef, lSpawn, TRUE, COHORT_TAG);
                //change alignment
                int nCurrentOrder = GetAlignmentLawChaos(oCohort);
                int nCurrentMoral = GetAlignmentGoodEvil(oCohort);
                if(nCurrentMoral < nMoral)
                    AdjustAlignment(oCohort, ALIGNMENT_GOOD, nMoral-nCurrentMoral);
                else if(nCurrentMoral > nMoral)
                    AdjustAlignment(oCohort, ALIGNMENT_EVIL, nCurrentMoral-nMoral);
                if(nCurrentOrder < nOrder)
                    AdjustAlignment(oCohort, ALIGNMENT_LAWFUL, nOrder-nCurrentOrder);
                else if(nCurrentOrder > nOrder)
                    AdjustAlignment(oCohort, ALIGNMENT_CHAOTIC, nCurrentOrder-nOrder);
                //level it up
                int i;
                //if simple racial HD on, give them racial HD
                if(GetPRCSwitch(PRC_XP_USE_SIMPLE_RACIAL_HD))
                {
                    //get the real race
                    int nRace = GetRacialType(oCohort);
                    int nRacialHD = StringToInt(Get2DACache("ECL", "RaceHD", nRace));
                    int nRacialClass = StringToInt(Get2DACache("ECL", "RaceClass", nRace));
                    for(i=0;i<nRacialHD;i++)
                    {
                        LevelUpHenchman(oCohort, nRacialClass, TRUE);
                    }
                }
                //give them their levels in their class
                int nLevel = GetCohortMaxLevel(GetLeadershipScore(oPC), oPC);
                for(i=GetHitDice(oCohort);i<nLevel;i++)
                {
                    LevelUpHenchman(oCohort, CLASS_TYPE_INVALID, TRUE);
                }
                //add to player
                //also does name/portrait/bodypart changes via DoDisguise
                AddCohortToPlayerByObject(oCohort, oPC);
                //mark the player as having recruited for the day
                SetLocalInt(oPC, "CohortRecruited", TRUE);
                nStage = STAGE_LEADERSHIP;
            }
            else if(nChoice == CHOICE_RETURN_TO_PREVIOUS)
                nStage = STAGE_LEADERSHIP;
            MarkStageNotSetUp(nStage, oPC);
        }
        else if(nStage == STAGE_LEADERSHIP_DELETE)
        {
            SetLocalInt(oPC, "CohortID", nChoice);
            nStage = STAGE_LEADERSHIP_DELETE_CONFIRM;
            MarkStageNotSetUp(nStage, oPC);
        }
        else if(nStage == STAGE_LEADERSHIP_DELETE_CONFIRM)
        {
            if(nChoice == 1)
            {
                int nCohortID = GetLocalInt(oPC, "CohortID");
                DeleteCohort(nCohortID);
                nStage = STAGE_LEADERSHIP;
            }
            else if(nChoice == CHOICE_RETURN_TO_PREVIOUS)
                nStage = STAGE_LEADERSHIP_DELETE;
            MarkStageNotSetUp(nStage, oPC);
        }
        else if (nStage == STAGE_NATURAL_WEAPON)
        {
            if(nChoice = -512)
                //no primary natural weapon
                SetPrimaryNaturalWeapon(oPC, -1);           
            else
                //specific natural weapon
                SetPrimaryNaturalWeapon(oPC, nChoice);
        
            nStage = STAGE_ENTRY;
            MarkStageNotSetUp(nStage, oPC);
        }


        // Store the stage value. If it has been changed, this clears out the choices
        SetStage(nStage, oPC);
    }
}
