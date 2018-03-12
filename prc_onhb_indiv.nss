/*

    prc_onhb_indiv.nss
    
    Invidual Heartbeat event
    
    This script is run every heartbeat for every PC via the prc_onheartbeat event
    This script is run every heartbeat for every NPC via the prc_npc_hb event
    
    Its main purposes is to provide a unified individual hb script interface
    Slighly less efficient because things like switches are checked for each individual.

*/

#include "prc_alterations"
#include "prc_inc_natweap"

void main()
{
    object oPC = OBJECT_SELF;
    
    // Eventhook
    ExecuteAllScriptsHookedToEvent(oPC, EVENT_ONHEARTBEAT);
    // ECL
    if(GetIsPC(oPC) 
        || (!GetIsPC(oPC) 
            && GetPRCSwitch(PRC_XP_GIVE_XP_TO_NPCS)))
        ApplyECLToXP(oPC);
    
    int bCraftingBaseItems  = GetPRCSwitch(PRC_CRAFTING_BASE_ITEMS);
    
    // Check if the character has lost a level since last HB
    if(GetHitDice(oPC) != GetLocalInt(oPC, "PRC_HitDiceTracking"))
    {
        if(GetHitDice(oPC) < GetLocalInt(oPC, "PRC_HitDiceTracking"))
        {
            SetLocalInt(oPC, "PRC_OnLevelDown_OldLevel", GetLocalInt(oPC, "PRC_HitDiceTracking"));
            DelayCommand(0.0f, ExecuteScript("prc_onleveldown", oPC));
        }

        SetLocalInt(oPC, "PRC_HitDiceTracking", GetHitDice(oPC));
    }


    //crafting base items
    if(bCraftingBaseItems)
    {
        int bHasPotion,
            bHasScroll,
            bHasWand;
        int bHasPotionFeat,
            bHasScrollFeat,
            bHasWandFeat;
        if(GetHasFeat(FEAT_BREW_POTION, oPC))
            bHasPotionFeat = TRUE;
        if(GetHasFeat(FEAT_SCRIBE_SCROLL, oPC))
            bHasScrollFeat = TRUE;
        if(GetHasFeat(FEAT_CRAFT_WAND, oPC))
            bHasWandFeat = TRUE;
        if(bHasPotionFeat || bHasScrollFeat || bHasWandFeat)
        {
            object oTest = GetFirstItemInInventory(oPC);
            while(GetIsObjectValid(oTest)
                //&& (!bHasPotion || !bHasScroll || !bHasWand)
                )
            {
                string sResRef = GetResRef(oTest);
                if(sResRef == "x2_it_cfm_pbottl")
                    bHasPotion = TRUE;
                if(sResRef == "x2_it_cfm_bscrl")
                    bHasScroll = TRUE;
                if(sResRef == "x2_it_cfm_wand")
                    bHasWand = TRUE;
                oTest = GetNextItemInInventory(oPC);
            }
            if(bHasPotionFeat && !bHasPotion)
            {
                oTest = CreateItemOnObject("x2_it_cfm_pbottl", oPC);
                if(GetItemPossessor(oTest) != oPC)
                    DestroyObject(oTest); //not enough room in inventory
                else
                    SetItemCursedFlag(oTest, TRUE); //curse it so it cant be sold etc
            }
            if(bHasScrollFeat && !bHasScroll)
            {
                oTest = CreateItemOnObject("x2_it_cfm_bscrl", oPC);
                if(GetItemPossessor(oTest) != oPC)
                    DestroyObject(oTest); //not enough room in inventory
                else
                    SetItemCursedFlag(oTest, TRUE); //curse it so it cant be sold etc
            }
            if(bHasWandFeat && !bHasWand)
            {
                oTest = CreateItemOnObject("x2_it_cfm_wand", oPC);
                if(GetItemPossessor(oTest) != oPC)
                    DestroyObject(oTest); //not enough room in inventory
                else
                    SetItemCursedFlag(oTest, TRUE); //curse it so it cant be sold etc
            }
        }
    }
    // Race Pack Code
    ExecuteScript("race_hb", oPC);
    //natural weapons
    DoNaturalWeaponHB(oPC);
}        