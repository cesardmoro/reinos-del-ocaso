/*:://////////////////////////////////////////////
//:: Name Componants include file (gems, specific items of tags etc)
//:: FileName phs_inc_compnent
//:://////////////////////////////////////////////
    This include file is meant for spells needing
    an item to cast it. It will check the inventory
    for any item of the right value (using pre-set items).

    It checks, and removes the items. Use this line to check:

    if(PHS_SpellItemCheck(iID, sNAME, iVALUE))

    To check the spells ID.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//:: Created On: July+
//::////////////////////////////////////////////*/
/*
    NW_IT_GEM001 - 7 - Greenstone
    NW_IT_GEM007 - 8 - Malachite
    NW_IT_GEM002 - 10 - Fire Agate
    NW_IT_GEM004 - 20 - Phenalope
    NW_IT_GEM014 - 20 -   Aventurine
    NW_IT_GEM003 - 40 - Amethyst
    NW_IT_GEM015 - 50 - Fluorspar
    NW_IT_GEM011 - 120 - Garnet
    NW_IT_GEM013 - 145 - Alexandrite
    NW_IT_GEM010 - 250 - Topaz
    NW_IT_GEM008 - 1000 - Sapphire
    NW_IT_GEM009 - 1500 - Fire Opal
    NW_IT_GEM005 - 2000 - Diamond
    NW_IT_GEM006 - 3000 - Ruby
    NW_IT_GEM012 - 4000 - Emerald
*/

// This will return TRUE if the caster has an item (gem) of that value.
// It will be destroyed in the process. The lowest is chosen.
// It also notified the gems destruction.
// * sName is the spells name, iValue is the lowest gem value.
int PHS_SpellItemCheck(int iSpellID, string sName, int iItemValue);
// Returns a gem of the lowest value.
// * Checks inventory of the caster.
object PHS_LowestGemOfValue(int iItemValue);
// This creates a stack of sblueprint items on the caster.
void PHS_ActionCreateObject(string sBlueprint, int iStack);
// Returns TRUE if they possess an item of sTag.
// * If FALSE - debugs using sItemName and sSpellName.
// * TRUE if it finds the item.
int PHS_SpellExactItem(string sTag, string sItemName, string sSpellName);
// Gets the item of string sTag, if valid, it removes it for the spell to work.
// * If FALSE - debugs using sItemName and sSpellName.
// * TRUE if it removes the item.
int PHS_SpellExactItemRemove(string sTag, string sItemName, string sSpellName);
// Removes the item of sTag. 1 of them anyway.
void PHS_ItemRemove(string sTag);

// Checks if they have an amount of XP that will not lose them a level
int PHS_XPCheck(int nXP, object oTarget);
// Removes nXP from oTarget. Make sure this can happen without level loss with
// PHS_XPCheck.
void PHS_XPRemove(int nXP, object oTarget);

// This will return TRUE if the caster has an item (gem) of that value.
// It will be destroyed in the process. The lowest is chosen.
// It also notified the gems destruction.
// * sName is the spells name, iValue is the lowest gem value.
int PHS_SpellItemCheck(int iSpellID, string sName, int iItemValue)
{
    if(!GetIsPC(OBJECT_SELF))
    {
        SendMessageToPC(OBJECT_SELF, "NPC Detected, does not use material componants");
        return TRUE;
    }
    // Get the lowest value gem, >= iItemValue.
    object oLowest = PHS_LowestGemOfValue(iItemValue);

    // If it is valid, we tell the PC about it, and destroy it, and return TRUE
    if(GetIsObjectValid(oLowest))
    {
        // Delay the creation of the gems again.
        DelayCommand(0.5, PHS_ActionCreateObject(GetResRef(oLowest), GetNumStackedItems(oLowest) - 1));
        // Destroy the lowest gem.
        DestroyObject(oLowest);
        // Display message, and return that they have done it.
        SendMessageToPC(OBJECT_SELF, "You have lost a material componant (" + GetName(oLowest) + ") required for casting " + sName + ".");
        return TRUE;
    }
    // Else no item of the right value. Message it.
    SendMessageToPC(OBJECT_SELF, "You have not got a gem, valued at " + IntToString(iItemValue) + " required for your spell. It has dispissiated.");
    return FALSE;
}

// Returns a gem of the lowest value.
// * Checks inventory of the caster.
object PHS_LowestGemOfValue(int iItemValue)
{
    object oReturn = OBJECT_INVALID;
    object oLowest = GetFirstItemInInventory();
    int iValue, iStack, iLowestValue = 1000000;
    while(GetIsObjectValid(oLowest))
    {
        if(GetBaseItemType(oLowest) == BASE_ITEM_GEM &&
          !GetPlotFlag(oLowest))
        {
            // Get the right value for seperate gems.
            iStack = GetNumStackedItems(oLowest);
            iValue = GetGoldPieceValue(oLowest)/iStack;
            if(iValue >= iItemValue && iValue < iLowestValue)
            {
                iLowestValue = iValue;
                oReturn = oLowest;
            }
        }
        oLowest = GetNextItemInInventory();
    }
    return oReturn;
}
// This creates a stack of sblueprint items on the caster.
void PHS_ActionCreateObject(string sBlueprint, int iStack)
{
    CreateItemOnObject(sBlueprint, OBJECT_SELF, iStack);
}

// Returns TRUE if they possess an item of sTag.
// * If FALSE - debugs using sItemName and sSpellName.
int PHS_SpellExactItem(string sTag, string sItemName, string sSpellName)
{
    // Check item
    if(!GetIsObjectValid(GetItemPossessedBy(OBJECT_SELF, sTag)))
    {
        // Not got it! Debug message
        SendMessageToPC(OBJECT_SELF, "You cannot cast " + sSpellName + ", without " + sItemName + ".");
        return FALSE;
    }
    return TRUE;
}

// Gets the item of string sTag, if valid, it removes it for the spell to work.
// * If FALSE - debugs using sItemName and sSpellName.
int PHS_SpellExactItemRemove(string sTag, string sItemName, string sSpellName)
{
    object oItem = GetItemPossessedBy(OBJECT_SELF, sTag);
    int iStack = GetItemStackSize(oItem);
    // Check item
    if(!GetIsObjectValid(oItem))
    {
        // Not got it! Debug message
        SendMessageToPC(OBJECT_SELF, "You cannot cast " + sSpellName + ", without " + sItemName + ".");
        return FALSE;
    }
    // Remove item
    if(iStack > 1)
    {
        // Take one only off the stack
        iStack--;
        SetItemStackSize(oItem, iStack);
    }
    else
    {
        // Delete item otherwise
        DestroyObject(oItem);
    }
    return TRUE;
}
// Removes the item of sTag. 1 of them anyway.
void PHS_ItemRemove(string sTag)
{
    object oItem = GetItemPossessedBy(OBJECT_SELF, sTag);
    int iStack = GetItemStackSize(oItem);
    // Check item
    if(GetIsObjectValid(oItem))
    {
        // Remove item
        if(iStack > 1)
        {
            // Take one only off the stack
            iStack--;
            SetItemStackSize(oItem, iStack);
        }
        else
        {
            // Delete item otherwise
            DestroyObject(oItem);
        }
    }
}

// Checks if they have an amount of XP that will not lose them a level
int PHS_XPCheck(int nXP, object oTarget)
{
    int nTargetXP = GetXP(oTarget);

    // Make sure it won't go below 0 anyway
    if(nTargetXP - nXP < FALSE)
    {
        return FALSE;
    }

    int nHD = GetHitDice(oTarget);
    // * You can not lose a level (Bioware thing here...)
    int nMin = ((nHD * (nHD - 1)) / 2) * 1000;

    // Make sure that nTargetXP - nXP is not under nMin.
    if(nTargetXP - nXP >= nMin)
    {
        return TRUE;
    }
    return FALSE;
}
// Removes nXP from oTarget. Make sure this can happen without level loss with
// PHS_XPCheck.
void PHS_XPRemove(int nXP, object oTarget)
{
    // Get what they already have.
    int nCurrent = GetXP(oTarget);
    // Minus
    int nNew = nCurrent - nXP;

    // Set it
    SetXP(oTarget, nNew);
}
