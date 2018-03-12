
#include "prc_feat_const"
#include "prc_racial_const"
#include "inc_encrypt"
#include "inc_utility"
#include "inc_letoscript"
#include "prc_ccc_inc"
#include "x2_inc_switches"

void CheckAndBoot(object oPC)
{
    if(GetIsObjectValid(GetAreaFromLocation(GetLocation(oPC))))
        BootPC(oPC);
}

void main()
{

    object oPC = GetEnteringObject();
    if(GetIsDM(oPC))
        return;//dont mess with DMs
    if(!GetIsPC(oPC))
        return;//dont run for NPCs


    
    if(!GetPRCSwitch(PRC_CONVOCC_ENABLE))
        return;

    SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);
    
    int bBoot;
    //check that its a multiplayer game
    if(GetPCPublicCDKey(oPC) == "")
    {
        SendMessageToPC(oPC, "This module must be hosted as a multiplayer game with NWNX and Letoscript");
        WriteTimestampedLogEntry("This module must be hosted as a multiplayer game with NWNX and Letoscript");
        bBoot = TRUE;
    }

    //check that letoscript is setup correctly
    string sScript;
    if(GetPRCSwitch(PRC_LETOSCRIPT_PHEONIX_SYNTAX))
        sScript = LetoGet("FirstName")+" "+LetoGet("LastName");
    else
        sScript = LetoGet("FirstName")+"print ' ';"+LetoGet("LastName");
        
    StackedLetoScript(sScript);
    RunStackedLetoScriptOnObject(oPC, "LETOTEST", "SCRIPT", "", FALSE);
    string sResult = GetLocalString(GetModule(), "LetoResult");
    string sName = GetName(oPC);
    if((    sResult != sName
         && sResult != sName+" "
         && sResult != " "+sName)
         )
    {
        SendMessageToPC(oPC, "Letoscript is not setup correctly. Please check that you have set the directory to the correct one.");
        WriteTimestampedLogEntry("Letoscript is not setup correctly. Please check that you have set the directory to the correct one.");
        bBoot = TRUE;
    }

    if(bBoot)
    {
        effect eParal = EffectCutsceneParalyze();
        eParal = SupernaturalEffect(eParal);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eParal, oPC);
        AssignCommand(oPC, DelayCommand(10.0, CheckAndBoot(oPC)));
        return;
    }

    string sEncrypt;
    sEncrypt= Encrypt(oPC);

    //if using XP for new characters, set returning characters tags to encrypted
    //then you can turn off using XP after all characters have logged on.
    if(GetPRCSwitch(PRC_CONVOCC_USE_XP_FOR_NEW_CHAR)
        && GetTag(oPC) != sEncrypt
        && GetXP(oPC) > 0)
    {
        string sScript = LetoSet("Tag", sEncrypt, "string");
        SetLocalString(oPC, "LetoScript", GetLocalString(oPC, "LetoScript")+sScript);
    }
    
    if(GetPRCSwitch(PRC_CONVOCC_ENFORCE_FEATS))
    {
        SetPRCSwitch(PRC_CONVOCC_ENFORCE_BLOOD_OF_THE_WARLORD, TRUE);
        SetPRCSwitch(PRC_CONVOCC_ENFORCE_FEAT_NIMBUSLIGHT, TRUE);
        SetPRCSwitch(PRC_CONVOCC_ENFORCE_FEAT_HOLYRADIANCE, TRUE);
        SetPRCSwitch(PRC_CONVOCC_ENFORCE_FEAT_SERVHEAVEN, TRUE);
        SetPRCSwitch(PRC_CONVOCC_ENFORCE_FEAT_SAC_VOW, TRUE);
        SetPRCSwitch(PRC_CONVOCC_ENFORCE_FEAT_VOW_OBED, TRUE);
        SetPRCSwitch(PRC_CONVOCC_ENFORCE_FEAT_THRALL_TO_DEMON, TRUE);
        SetPRCSwitch(PRC_CONVOCC_ENFORCE_FEAT_DISCIPLE_OF_DARKNESS, TRUE);
        SetPRCSwitch(PRC_CONVOCC_ENFORCE_FEAT_LICHLOVED, TRUE);
        SetPRCSwitch(PRC_CONVOCC_ENFORCE_FEAT_EVIL_BRANDS, TRUE);
        SetPRCSwitch(PRC_CONVOCC_ENFORCE_FEAT_VILE_WILL_DEFORM, TRUE);
        SetPRCSwitch(PRC_CONVOCC_ENFORCE_FEAT_VILE_DEFORM_OBESE, TRUE);
        SetPRCSwitch(PRC_CONVOCC_ENFORCE_FEAT_VILE_DEFORM_GAUNT, TRUE);
        SetPRCSwitch(PRC_CONVOCC_ENFORCE_FEAT_LOLTHS_MEAT, TRUE);
    }
    if(GetPRCSwitch(PRC_CONVOCC_ENFORCE_PNP_RACIAL))
    {
        SetPRCSwitch(PRC_CONVOCC_DRIDER_FEMALE_APPEARANCE, TRUE);
        SetPRCSwitch(PRC_CONVOCC_RAKSHASHA_FEMALE_APPEARANCE, TRUE);
        SetPRCSwitch(PRC_CONVOCC_GENASI_ENFORCE_DOMAINS, TRUE);
        SetPRCSwitch(PRC_CONVOCC_DROW_ENFORCE_GENDER, TRUE);
        SetPRCSwitch(PRC_CONVOCC_FEYRI_TAIL, TRUE);
        SetPRCSwitch(PRC_CONVOCC_FEYRI_WINGS, TRUE);
        SetPRCSwitch(PRC_CONVOCC_AVARIEL_WINGS, TRUE);
    }

    if((GetPRCSwitch(PRC_CONVOCC_USE_XP_FOR_NEW_CHAR) && GetXP(oPC) == 0)
        || (!GetPRCSwitch(PRC_CONVOCC_USE_XP_FOR_NEW_CHAR) && GetTag(oPC) != sEncrypt))
    {
        //first entry
        // Check Equip Items and get rid of them
        int i;
        for(i=0; i<NUM_INVENTORY_SLOTS; i++)
        {
            object oEquip = GetItemInSlot(i,oPC);
            if(GetIsObjectValid(oEquip))
            {
                SetPlotFlag(oEquip,FALSE);
                DestroyObject(oEquip);
            }
        }
        // Check general Inventory and clear it out.
        object oItem = GetFirstItemInInventory(oPC);
        while(GetIsObjectValid(oItem))
        {
            SetPlotFlag(oItem,FALSE);
            if(GetHasInventory(oItem))
            {
                object oItem2 = GetFirstItemInInventory(oItem);
                while(GetIsObjectValid(oItem2))
                {
                    object oItem3 = GetFirstItemInInventory(oItem2);
                    while(GetIsObjectValid(oItem3))
                    {
                        SetPlotFlag(oItem3,FALSE);
                        DestroyObject(oItem3);
                        oItem3 = GetNextItemInInventory(oItem2);
                    }
                    SetPlotFlag(oItem2,FALSE);
                    DestroyObject(oItem2);
                    oItem2 = GetNextItemInInventory(oItem);
                }
            }
            DestroyObject(oItem);
            oItem = GetNextItemInInventory(oPC);
        }
        //rest them so that they loose cutscene invisible
        //from previous logons
        ForceRest(oPC);
        //Take their Gold
        AssignCommand(oPC,TakeGoldFromCreature(GetGold(oPC),oPC,TRUE));
        //preserve the PCs dignity by giving them clothes
        //no cos they we cant see any tattoos
        //start the ConvoCC conversation
        DelayCommand(10.0, StartDynamicConversation("prc_ccc", oPC, FALSE, FALSE, TRUE));
        //DISABLE FOR DEBUGGING
        SetCutsceneMode(oPC, TRUE);
        SetCameraMode(oPC, CAMERA_MODE_TOP_DOWN);
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_END);
    }
    else
    {
        //its a returning character, dont do anything
        SetExecutedScriptReturnValue(X2_EXECUTE_SCRIPT_CONTINUE);
    }
}
