//:://////////////////////////////////////////////
//:: FileName: "inc_utilityfuncs"
/*   Purpose: This is a #include file for various unrelated functions.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On: March 13, 2004
//:://////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////
//  CONSTANTS
//////////////////////////////////////////////////////////////////////////////
const string ID_ITEM_START = "You have identified the ";
const string ID_ITEM_END = " in your inventory.";

///////////////////////////////////////////////////////////////////////////////
//  FUNCTION DECLARATIONS
///////////////////////////////////////////////////////////////////////////////

// Try to identify all unidentified objects within oPC's inventory.
void TryToIDItems(object oPC = OBJECT_SELF);

///////////////////////////////////////////////////////////////////////////////
//  FUNCTION IMPLEMENTATION
///////////////////////////////////////////////////////////////////////////////
void TryToIDItems(object oPC = OBJECT_SELF)
{
    int nLore = GetSkillRank(SKILL_LORE, oPC);
    int nGP;
    string sMax = Get2DAString("SkillVsItemCost",
        "DeviceCostMax", nLore);
    int nMax = StringToInt(sMax);
    if (sMax == "") nMax = 120000000;
    object oItem = GetFirstItemInInventory(oPC);
    while(oItem != OBJECT_INVALID)
    {
        if(!GetIdentified(oItem))
        {
            // Check for the value of the item first.
            SetIdentified(oItem, TRUE);
            nGP = GetGoldPieceValue(oItem);
            SetIdentified(oItem, FALSE);
            // If oPC has enough Lore skill to ID the item, then do so.
            if(nMax >= nGP)
            {
                SetIdentified(oItem, TRUE);
                SendMessageToPC(oPC,
                    ID_ITEM_START + GetName(oItem) + ID_ITEM_END);
            }
        }
        oItem = GetNextItemInInventory(oPC);
    }

}
