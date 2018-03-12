//:://////////////////////////////////////////////
//:: Craft Item (Item Creation Feat)
//:: prccraft_craft
//:: Copyright (c) 2003 Gerald Leung.
//::
//:: Created By: Gerald Leung
//:: Created On: December 11, 2003
//:: Edited  By: Guido Imperiale (CRVSADER//KY)
//:: Edited  On: December 29, 2004
//::
//:: Attempt to craft an item using the Craft Item feat.
//::
//:://////////////////////////////////////////////

#include "prc_inc_craft"

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
                if (GetLevelByClass(CLASS_TYPE_MAESTER, OBJECT_SELF) > 0) nDelay /= 2;

                SetCraftTimer(nDelay);
            }
        } else if (iReport.validrecipe == FALSE) {
            //not a valid recipe
            SendMessageToPCByStrRef(OBJECT_SELF, STRREF_INVALIDRECIPE);
        }
    }
}
