
#include "prc_feat_const"
#include "prc_racial_const"
#include "prc_ccc_inc"

#include "inc_utility"


void CheckAndBoot(object oPC)
{
    if(GetIsObjectValid(GetAreaFromLocation(GetLocation(oPC))))
        BootPC(oPC);
}

void main()
{
    object oPC = OBJECT_SELF;
    int nValue = GetLocalInt(oPC, DYNCONV_VARIABLE);
    if(DEBUG) DoDebug("prc_ccc running.\n"
                    + "oPC = " + DebugObject2Str(oPC) + "\n"
                    + "nValue = " + IntToString(nValue)
                      );
    if(nValue == 0)
        return;


    if(nValue == DYNCONV_SETUP_STAGE)
    {
        int nStage = GetStage(oPC);
        if(DEBUG) DoDebug("prc_ccc: Setting up stage " + IntToString(nStage));
        // Check if this stage is marked as already set up
        // This stops list duplication when scrolling
        if(!GetIsStageSetUp(nStage, oPC))
        {
            if(DEBUG) DoDebug("prc_ccc: Stage was not already set up");
            SetupStage();
            SetupHeader();
        }

        // Do token setup
        SetupTokens();
        ExecuteScript("prc_ccc_debug", oPC);
    }
    else if(nValue == DYNCONV_EXITED)
    {
        if(DEBUG) DoDebug("prc_ccc: Conversation exited");
        //end of conversation cleanup
        SetCutsceneMode(oPC, FALSE);
        AssignCommand(oPC, DelayCommand(1.0, CheckAndBoot(oPC)));
        DoCleanup();
    }
    else if(nValue == DYNCONV_ABORTED)
    {
        if(DEBUG) DoDebug("prc_ccc: Conversation aborted");
        //abort conversation cleanup
        DoCleanup();
        SetCutsceneMode(oPC, FALSE);
        AssignCommand(oPC, DelayCommand(1.0, CheckAndBoot(oPC)));
        ForceRest(oPC);
    }
    else
    {
        if(DEBUG) DoDebug("prc_ccc: User made a choice");
        //selection made
        ChoiceSelected(nValue);
        SetupTokens();
    }
}
