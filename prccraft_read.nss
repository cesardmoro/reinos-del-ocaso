//:://////////////////////////////////////////////
//:: Examine Recipe or Item (was: Read Magic)
//:: prccraft_read
//:: Copyright (c) 2003 Gerald Leung.
//::
//:: Created By: Gerald Leung
//:: Created On: November 12, 2003
//:: Edited  By: Guido Imperiale (CRVSADER//KY)
//:: Edited  On: March 1, 2005
//::
//:: Attempt to read an item.  Part of Hierarchical
//:: Design's Item Creation Feats System
//:: The target can be a recipe or an item
//:: Combined with craft item into one feat
//::
//:://////////////////////////////////////////////

#include "prc_inc_craft"

void CreateRecipeAndTakeGold(string sRecipeTag)
{
    object oRecipe = CreateObject(OBJECT_TYPE_ITEM, "itemrecipe", GetLocation(OBJECT_SELF), FALSE, sRecipeTag);
    ActionDoCommand(ActionPickUpItem(oRecipe));
    TakeGoldFromCreature(1, OBJECT_SELF, TRUE);
}

void SafeGetRecipeTagFromItem(string sResRef, int nRow = 0)
{
    if (GetPRCSwitch(PRC_USE_DATABASE)) 
    {
        //NWNX2/SQL
        string q = PRC_SQLGetTick();
        string sQuery = "SELECT "+q+"recipe_tag"+q+" FROM "+q+"prc_cached2da_item_to_ireq"+q+" WHERE "+q+"L_RESREF"+q+"='"+sResRef+"'";
        PRC_SQLExecDirect(sQuery);
        if (PRC_SQLFetch() == PRC_SQL_ERROR)
            return;
        else
            CreateRecipeAndTakeGold(PRC_SQLGetData(1));
    }
    else 
    {
        //Plain slow 2DA
        if(nRow > GetPRCSwitch(FILE_END_ITEM_TO_IREQ))
            return;
        int row;            
        for (row = nRow; row <= nRow+100; row++) 
        {
            string sResRefRead = Get2DACache("item_to_ireq", "L_RESREF"  , row);
            if (sResRefRead ==  sResRef) 
            {
                CreateRecipeAndTakeGold(Get2DACache("item_to_ireq", "RECIPE_TAG"  , row));
                return;
            }
        }
        DelayCommand(0.01, SafeGetRecipeTagFromItem(sResRef, nRow+100));
    }

    return;
}

// Create the Item from the resref and set it IDed.
void FinishItem(string sResRef, int nStackSize, int nResultType, string sResultArgs)
{
    object oResult;

    if (nResultType == RESULT_TYPE_ITEM)
    {
        oResult = CreateItemOnObject(sResRef, OBJECT_SELF, nStackSize);
    }
    else if (nResultType == RESULT_TYPE_SCRIPT)
    {
        PRCCraft_SetArguments(sResultArgs);
        PRCCraft_SetConsume(TRUE);  
        ExecuteScript(sResRef, OBJECT_SELF);
    }
    else 
    {
        //get a location in front of the caster
        vector vPC = GetPosition(OBJECT_SELF);
        float fAngle = GetFacing(OBJECT_SELF);
    
        const float fDistance = 2.0;

        vector vSpawn;
        vSpawn.z = vPC.z;
        vSpawn.x = vPC.x + (fDistance * cos(fAngle));
        if (vSpawn.x < 0.0)
            vSpawn.x = 0.0;
        vSpawn.y = vPC.y + (fDistance * sin(fAngle));
        if (vSpawn.y < 0.0)
            vSpawn.y = 0.0;

        fAngle += 180.0;
        if (fAngle >= 360.0)
            fAngle -= 360.0;

        location lSpawn = Location(GetArea(OBJECT_SELF), vSpawn, fAngle);   

        oResult = CreateObject(nResultType == RESULT_TYPE_PLACEABLE ? OBJECT_TYPE_PLACEABLE : OBJECT_TYPE_CREATURE, sResRef, lSpawn);
    }

    if (GetIsObjectValid(oResult))
        SetIdentified(oResult, TRUE);
    else
        prccache_error("prccraft_craft.nss: FinishItem(): Trying to create an invalid object: " + sResRef);
}


void main()
{
    if (GetPRCSwitch(PRC_DISABLE_CRAFT)) {
        SendMessageToPCByStrRef(OBJECT_SELF, STRREF_CRAFTDISABLED);
        return;
    }
    //check if crafting disabled
    if (GetLocalInt(GetArea(OBJECT_SELF), PRC_AREA_DISABLE_CRAFTING))
    {
        FloatingTextStrRefOnCreature(16832014, OBJECT_SELF); // * Item creation feats are not enabled in this area *
        return;
    }
    
    object oItem = PRCGetSpellTargetObject();
    //been read recently, craft it
    if(GetLocalInt(oItem, "BeenRead"))
    {
        object oTarget = PRCGetSpellTargetObject();
        int nTargetType = GetObjectType(oTarget);
        struct ireqreport iReport;
        
        // Current valid targets are: items, placeables, doors, and creatures.
        // If would-be wondrous item creator is trying to use Craft Wondrous Item on some invalid target..
        if (!(
              (nTargetType == OBJECT_TYPE_ITEM) ||
              (nTargetType == OBJECT_TYPE_PLACEABLE) ||
              (nTargetType == OBJECT_TYPE_DOOR) ||
              (nTargetType == OBJECT_TYPE_CREATURE)
             ))
        {
                SendMessageToPCByStrRef(OBJECT_SELF, STRREF_CANTUSETHIS);
        }
        // If valid target..
        else
        {
            // and if IReqs check out,
            iReport = CheckIReqs(oTarget, TRUE, FALSE);
            if (iReport.result != "") {
                //valid recipe and all requisites are met;
                iReport = CheckIReqs(oTarget, FALSE, TRUE);
    
                // get the item template from the IReqTable
                if (iReport.result != "") {
                    FinishItem(iReport.result, iReport.stacksize, iReport.result_type, iReport.result_args);
    
                    //disable crafting for some time (default: disabled)
                    object oModule = GetModule();
                    int nDelay = FloatToInt((IntToFloat(GetPRCSwitch(PRC_CRAFT_TIMER_MULTIPLIER))/100) * IntToFloat(iReport.marketprice));
                    nDelay = min(nDelay, GetPRCSwitch(PRC_CRAFT_TIMER_MIN));
                    nDelay = max(nDelay, GetPRCSwitch(PRC_CRAFT_TIMER_MAX));
                    
                    // Maester class cuts crafting time in half.
                    if (GetLevelByClass(CLASS_TYPE_MAESTER, OBJECT_SELF)) nDelay /= 2;
    
                    SetCraftTimer(nDelay);
                    
                    //alternatively, use the inc_time based system
                    //1 day per 1000GP base cost, min 1
                    int nDays = iReport.marketprice/1000;
                    // Maester class cuts crafting time in half.
                    if (GetLevelByClass(CLASS_TYPE_MAESTER, OBJECT_SELF)) nDays /= 2;
                    if(!nDays) nDays = 1;
                    AdvanceTimeForPlayer(OBJECT_SELF, HoursToSeconds(nDays*24));
                }
            } else if (iReport.validrecipe == FALSE) {
                //not a valid recipe
                SendMessageToPCByStrRef(OBJECT_SELF, STRREF_INVALIDRECIPE);
            }
        }    
    }
    else //not been read, read it
    {   
        //If targeting a valid recipe, display its content
        struct ireqreport iReport = CheckIReqs(oItem, TRUE, FALSE);

        if (iReport.result == "" && iReport.validrecipe == FALSE)
        {
            //Try to write a recipe
            SendMessageToPCByStrRef(OBJECT_SELF, STRREF_TRYTOWRITERECIPE);

            //Need 1 GP
            if (GetGold(OBJECT_SELF) < 1)
                SendMessageToPCByStrRef(OBJECT_SELF, STRREF_NEED1GOLD);

            //Try to make a recipe for the item (must be identified)
            else if (!GetIdentified(oItem))
                SendMessageToPCByStrRef(OBJECT_SELF, STRREF_CANTUNDERSTAND);

            //Recipe successfully written; take 1 GP
            else
                SafeGetRecipeTagFromItem(GetResRef(oItem));
        }
        SetLocalInt(oItem, "BeenRead", TRUE);
        DelayCommand(6.0, DeleteLocalInt(oItem, "BeenRead"));
    }
}
