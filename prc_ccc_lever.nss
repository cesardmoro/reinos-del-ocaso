#include "inc_letoscript"
#include "prc_ccc_inc"
#include "inc_encrypt"
#include "inc_utility"

void main()
{
    object oPC = GetLastUsedBy();

    if(GetIsDM(oPC))
        return;//dont mess with DMs


    if(!GetPRCSwitch(PRC_CONVOCC_ENABLE))
        return;

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
        sScript = LetoGet("FirstName")+"print ' '; "+LetoGet("LastName");
    StackedLetoScript(sScript);
    RunStackedLetoScriptOnObject(oPC, "LETOTEST", "SCRIPT", "", FALSE);
    string sResult = GetLocalString(GetModule(), "LetoResult");
    string sName = GetName(oPC);
    if(sResult != sName
        && sResult != sName+" "
        && sResult != " "+sName)
    {
        SendMessageToPC(oPC, "Letoscript is not setup correctly. Please check that you have set the directory to the correct one.");
        WriteTimestampedLogEntry("Letoscript is not setup correctly. Please check that you have set the directory to the correct one.");
        bBoot = TRUE;
    }

    if(bBoot)
    {
        return;
    }

    string sEncrypt = Encrypt(oPC);

    //if using XP for new characters, set returning characters tags to encrypted
    //then you can turn off using XP after all characters have logged on.
    if(GetPRCSwitch(PRC_CONVOCC_USE_XP_FOR_NEW_CHAR)
        && GetTag(oPC) != sEncrypt
        && GetXP(oPC) > 0)
    {
        string sScript = LetoSet("Tag", sEncrypt, "string");
        SetLocalString(oPC, "LetoScript", GetLocalString(oPC, "LetoScript")+sScript);
    }
    
    if((GetPRCSwitch(PRC_CONVOCC_USE_XP_FOR_NEW_CHAR) && GetXP(oPC) == 0)
        || (!GetPRCSwitch(PRC_CONVOCC_USE_XP_FOR_NEW_CHAR) && GetTag(oPC) != sEncrypt))
    {
        SetXP(oPC, 0);
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
        //Take their Gold
        int nAmount = GetGold(oPC);
        if(nAmount > 0)
        {
            AssignCommand(oPC,TakeGoldFromCreature(nAmount,oPC,TRUE));
        }
        //preserve the PCs dignity by giving them clothes
        //object oClothes = CreateItemOnObject("nw_cloth022", oPC);
        //AssignCommand(oPC, ActionEquipItem(oClothes, INVENTORY_SLOT_CHEST));
        //start the ConvoCC conversation
        SetLocalString(oPC, DYNCONV_SCRIPT, "prc_ccc");
        DelayCommand(2.5, AssignCommand(oPC, ActionStartConversation(oPC, "dyncov_base", TRUE, FALSE)));
        //DISABLE FOR DEBUGGING
        DelayCommand(2.0, AssignCommand(oPC, ActionDoCommand(SetCutsceneMode(oPC, TRUE))));
        SetCameraMode(oPC, CAMERA_MODE_TOP_DOWN);
    }
    else
    {
        //its a returning character, dont do anything
        FloatingTextStringOnCreature("You are too developed to re-level your character.", oPC, FALSE);
    }
}
