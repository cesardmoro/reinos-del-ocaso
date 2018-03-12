// requires
// #include "x2_inc_craft"
#include "ips_inc"

const int MK_IP_CLOAKTYPE_NEXT = 0;
const int MK_IP_CLOAKTYPE_PREV = 1;

/* Defined in x2_inc_craft
const int X2_CI_MODMODE_INVALID = 0;
const int X2_CI_MODMODE_ARMOR = 1;
const int X2_CI_MODMODE_WEAPON = 2;
*/
const int MK_CI_MODMODE_CLOAK = 3;
const int MK_CI_MODMODE_HELMET = 4;

const int MK_ENABLE_MODIFY_DC = 0;
const int MK_ENABLE_MODIFY_GOLD = 0;

const int MK_TOKEN_PARTSTRING = 14422;
const int MK_TOKEN_PARTNUMBER = 14423;

string ClothColor(int iColor);
string ClothColorEx(int iColor, int bDisplayNumber = TRUE);
string MetalColor(int iColor);
string MetalColorEx(int iColor, int bDisplayNumber = TRUE);
void DyeItem(object oPC, int iMaterialToDye, int iColor, object oChest);
void DisplayColors(object oPC, object oItem);

int MK_GetArmorAppearanceType(object oArmor, int nPart, int nMode);

object MK_GetModifiedArmor(object oArmor, int nPart, int nMode, int bDestroyOldOnSuccess);

int MK_GetCurrentInventorySlot(object oPC);

int MK_GetCurrentInventorySlot(object oPC)
{
    int nInventorySlot=0;

//    switch (GetLocalInt(oPC,"X2_L_CRAFT_MODIFY_MODE"))
    switch (CIGetCurrentModMode(oPC))
    {
    case X2_CI_MODMODE_ARMOR:
        nInventorySlot = INVENTORY_SLOT_CHEST;
        break;
    case X2_CI_MODMODE_WEAPON:
        nInventorySlot = INVENTORY_SLOT_RIGHTHAND;
        break;
    case MK_CI_MODMODE_CLOAK:
        nInventorySlot = INVENTORY_SLOT_CLOAK;
        break;
    case MK_CI_MODMODE_HELMET:
        nInventorySlot = INVENTORY_SLOT_HEAD;
        break;
    default:
        nInventorySlot = -1;
    }
    return nInventorySlot;
}

// copied from 'string ZEP_ListReverse(string s)'
string MK_ListReverse(string s) {
    string sCache;
    int n;
    int l = GetStringLength(s);
    s = GetSubString(s, 1, l);
    while (s!="") {
        // take string upto next seperator and put this in front of cache
        n = FindSubString(s, ":")+1;
        sCache = GetStringLeft(s, n) + sCache;
        s = GetSubString(s, n, l);
    }
    return ":"+sCache;
}


//copied from 'string ZEP_PreReadArmorACList(string sAC)'
string MK_PreReadArmorACList(string sAC)
{
    // pick the right 2da to read the parts from
    string s2DA = "parts_chest";
    string sCache= ":";
    string sLine;

    int nMax = 255;
    int n=1;
    sAC = GetStringLeft(sAC, 1);
    while (n<=nMax) {
        // Verify validity of the ID and add to the list
        sLine = Get2DAString(s2DA, "ACBONUS", n);
        if (GetStringLeft(sLine, 1)==sAC)
        {
            sCache+= IntToString(n)+":";
        }
        n++;
    }
    // Store the list in a modulestring, once normal, once reversed, both with ID 0 added as first index for cycling
    SetLocalString(GetModule(), "MK_IDPreReadAC_"+GetStringLeft(sAC,1), sCache);
    SetLocalString(GetModule(), "MK_IDPreReadACR_"+GetStringLeft(sAC,1), MK_ListReverse(sCache));

    return sCache;
}

// copied from 'string ZEP_PreReadArmorPartList(int nPart)' and modified
string MK_GetParts2DAfile(int nPart)
{
    string s2DA = "parts_";
    switch (nPart) {
        case ITEM_APPR_ARMOR_MODEL_LBICEP:
        case ITEM_APPR_ARMOR_MODEL_RBICEP: s2DA+= "bicep"; break;
        case ITEM_APPR_ARMOR_MODEL_LFOOT:
        case ITEM_APPR_ARMOR_MODEL_RFOOT: s2DA+= "foot"; break;
        case ITEM_APPR_ARMOR_MODEL_LFOREARM:
        case ITEM_APPR_ARMOR_MODEL_RFOREARM: s2DA+= "forearm"; break;
        case ITEM_APPR_ARMOR_MODEL_LHAND:
        case ITEM_APPR_ARMOR_MODEL_RHAND: s2DA+= "hand"; break;
        case ITEM_APPR_ARMOR_MODEL_LSHIN:
        case ITEM_APPR_ARMOR_MODEL_RSHIN: s2DA+= "shin"; break;
        case ITEM_APPR_ARMOR_MODEL_LSHOULDER:
        case ITEM_APPR_ARMOR_MODEL_RSHOULDER: s2DA+= "shoulder"; break;
        case ITEM_APPR_ARMOR_MODEL_LTHIGH:
        case ITEM_APPR_ARMOR_MODEL_RTHIGH: s2DA+= "legs"; break;
        case ITEM_APPR_ARMOR_MODEL_NECK: s2DA+= "neck"; break;
        case ITEM_APPR_ARMOR_MODEL_BELT: s2DA+= "belt"; break;
        case ITEM_APPR_ARMOR_MODEL_PELVIS: s2DA+= "pelvis"; break;
        case ITEM_APPR_ARMOR_MODEL_ROBE: s2DA+= "robe"; break;
    }
    return s2DA;
}

// - private -
// Prereads the 2da-file for nPart and puts all used ID's in a : seperated stringlist
string MK_PreReadArmorPartList(int nPart) {
    // pick the right 2da to read the parts from
    string s2DA = MK_GetParts2DAfile(nPart);

    string sCache= ":";
    string sLine;
    int nMax = 255;
    int n=1;
    while (n<=nMax) {
        // Verify validity of the ID and add to the list
        sLine = Get2DAString(s2DA, "ACBONUS", n);
        if (sLine!="")
        {
            sCache+= IntToString(n)+":";
        }
        n++;
    }
    // Store the list in a modulestring, once normal, once reversed, both with ID 0 added as first index for cycling
    SetLocalString(GetModule(), "MK_IDPreRead_"+IntToString(nPart), ":0"+sCache);
    SetLocalString(GetModule(), "MK_IDPreReadR_"+IntToString(nPart), ":0"+MK_ListReverse(sCache));
    return sCache;
}

// copied from 'void ZEP_RemakeItem(object oPC, int nMode)' and modified
int MK_GetArmorAppearanceType(object oArmor, int nPart, int nMode)
{
    int nCurrApp  = GetItemAppearance(oArmor,ITEM_APPR_TYPE_ARMOR_MODEL,nPart);

    string sPreRead;

    if (nPart == ITEM_APPR_ARMOR_MODEL_TORSO)
    {
        string sAC = Get2DAString("parts_chest", "ACBONUS", nCurrApp);
        // Fetch the stringlist that holds the ID's for this part
        sPreRead = GetLocalString(GetModule(), "MK_IDPreReadAC_"+GetStringLeft(sAC,1));
        if (sPreRead=="") // list didn't exist yet, so generate it
           sPreRead = MK_PreReadArmorACList(sAC);
        if (nMode==X2_IP_ARMORTYPE_PREV)
           sPreRead = GetLocalString(GetModule(), "MK_IDPreReadACR_"+GetStringLeft(sAC,1));
    }
    else
    {
        // Fetch the stringlist that holds the ID's for this part
        sPreRead = GetLocalString(GetModule(), "MK_IDPreRead_"+IntToString(nPart));
        if (sPreRead=="") // list didn't exist yet, so generate it
          sPreRead = MK_PreReadArmorPartList(nPart);
        if (nMode==X2_IP_ARMORTYPE_PREV)
          sPreRead = GetLocalString(GetModule(), "MK_IDPreReadR_"+IntToString(nPart));
    }

    // Find the current ID in the stringlist and pick the one coming after that
    string sID;
    string sCurrApp = IntToString(nCurrApp);
    int n = FindSubString(sPreRead, ":"+sCurrApp+":");
    sID = GetSubString(sPreRead, n+GetStringLength(sCurrApp)+2, 5);
    n = FindSubString(sID, ":");
    sID = GetStringLeft(sID, n);
    if (sID=="" && nPart == ITEM_APPR_ARMOR_MODEL_TORSO)
    {
       sID = GetSubString(sPreRead, 1, 5);
       n = FindSubString(sID, ":");
       sID = GetStringLeft(sID, n);
    }
    nCurrApp = StringToInt(sID);

    return nCurrApp;
}


// ----------------------------------------------------------------------------
// Returns a new armor based of oArmor with nPartModified
// nPart - ITEM_APPR_ARMOR_MODEL_* constant of the part to be changed
// nMode -
//          X2_IP_ARMORTYPE_NEXT    - next valid appearance
//          X2_IP_ARMORTYPE_PREV    - previous valid apperance;
//          X2_IP_ARMORTYPE_RANDOM  - random valid appearance (torso is never changed);
// bDestroyOldOnSuccess - Destroy oArmor in process?
// Uses Get2DAstring, so do not use in loops
// ----------------------------------------------------------------------------
object MK_GetModifiedArmor(object oArmor, int nPart, int nMode, int bDestroyOldOnSuccess)
{
    int nNewApp = MK_GetArmorAppearanceType(oArmor, nPart,  nMode );
    //SpeakString("old: " + IntToString(GetItemAppearance(oArmor,ITEM_APPR_TYPE_ARMOR_MODEL,nPart)));
    //SpeakString("new: " + IntToString(nNewApp));

    object oNew = CopyItemAndModify(oArmor,ITEM_APPR_TYPE_ARMOR_MODEL, nPart, nNewApp,TRUE);

    if (oNew != OBJECT_INVALID)
    {
        SetCustomToken(MK_TOKEN_PARTNUMBER, IntToString(nNewApp));
        if( bDestroyOldOnSuccess )
        {
            DestroyObject(oArmor);
        }
        return oNew;
    }

    // Safety fallback, return old armor on failures
    return oArmor;
}


// - private -
// Prereads the 2da-file for nPart and puts all used ID's in a : seperated stringlist
string MK_PreReadCloakModelList()
{
    // pick the right 2da to read the parts from
    string s2DA = "CloakModel";

    string sCache= ":";
    string sLine;
    int nMax = 255;
    int n=1;
    while (n<=nMax) {
        // Verify validity of the ID and add to the list
        sLine = Get2DAString(s2DA, "LABEL", n);
        if (sLine!="")
        {
            sCache+= IntToString(n)+":";
        }
        n++;
    }
    // Store the list in a modulestring, once normal, once reversed, both with ID 0 added as first index for cycling
    SetLocalString(GetModule(), "MK_IDPreRead_Cloak", ":0"+sCache);
    SetLocalString(GetModule(), "MK_IDPreReadR_Cloak", ":0"+MK_ListReverse(sCache));

//    SpeakString(GetLocalString(GetModule(),"MK_IDPreRead_Cloak"));
//    SpeakString(GetLocalString(GetModule(),"MK_IDPreReadR_Cloak"));

    return sCache;
}


// copied from 'void ZEP_RemakeItem(object oPC, int nMode)' and modified
int MK_GetCloakAppearanceType(object oCloak, int nPart, int nMode)
{
    int nCurrApp  = GetItemAppearance(oCloak, 0, nPart);

    string sPreRead;

    // Fetch the stringlist that holds the ID's for this part
    sPreRead = GetLocalString(GetModule(), "MK_IDPreRead_Cloak");
    if (sPreRead=="") // list didn't exist yet, so generate it
        sPreRead = MK_PreReadCloakModelList();
    if (nMode==MK_IP_CLOAKTYPE_PREV)
        sPreRead = GetLocalString(GetModule(), "MK_IDPreReadR_Cloak");

    // Find the current ID in the stringlist and pick the one coming after that
    string sID;
    string sCurrApp = IntToString(nCurrApp);
    int n = FindSubString(sPreRead, ":"+sCurrApp+":");
    sID = GetSubString(sPreRead, n+GetStringLength(sCurrApp)+2, 5);
    n = FindSubString(sID, ":");
    sID = GetStringLeft(sID, n);
    nCurrApp = StringToInt(sID);

    return nCurrApp;
}

// ----------------------------------------------------------------------------
// Returns a new armor based of oArmor with nPartModified
// nPart - ITEM_APPR_ARMOR_MODEL_* constant of the part to be changed
// nMode -
//          MK_IP_CLOAKTYPE_NEXT    - next valid appearance
//          MK_IP_CLOAKTYPE_PREV    - previous valid apperance;
// bDestroyOldOnSuccess - Destroy oArmor in process?
// Uses Get2DAstring, so do not use in loops
// ----------------------------------------------------------------------------
object MK_GetModifiedCloak(object oCloak, int nPart, int nMode, int bDestroyOldOnSuccess)
{
    int nNewApp = MK_GetCloakAppearanceType(oCloak, nPart,  nMode );

//    SpeakString("old: " + IntToString(GetItemAppearance(oCloak,0,nPart)));
//    SpeakString("new: " + IntToString(nNewApp));

    object oNew = CopyItemAndModify(oCloak, 0, nPart, nNewApp,TRUE);

    if (oNew != OBJECT_INVALID)
    {
        SetCustomToken(MK_TOKEN_PARTNUMBER, IntToString(nNewApp));
        if( bDestroyOldOnSuccess )
        {
            DestroyObject(oCloak);
        }
        return oNew;
    }
//        SpeakString("failed");

    // Safety fallback, return old armor on failures
    return oCloak;
}

void DyeItem(object oPC, int iMaterialToDye, int iColor, object oChest)
{
    if (!GetIsObjectValid(oPC))
    {
        return;
    }

    if (!GetIsObjectValid(oChest))
    {
        return;
    }

//    object oItem = GetItemInSlot(iItemToDye, oPC);
    object oItem = CIGetCurrentModItem(oPC);
    AssignCommand(oPC, ClearAllActions());
    AssignCommand(oPC, ActionUnequipItem(oItem));
//    object oItem = GetLocalObject(oPC,"X2_O_CRAFT_MODIFY_ITEM");
    if (!GetIsObjectValid(oItem))
    {
        return;
    }

    // Set armor to being edited
    SetLocalInt(oItem, "mil_EditingItem", TRUE);

    // Copy item to the chest
    object oInChest = CopyItem(oItem, oChest, TRUE);
    DestroyObject(oItem);

    // Dye the item
    object oDyedItem = CopyItemAndModify(oInChest, ITEM_APPR_TYPE_ARMOR_COLOR, iMaterialToDye, iColor, TRUE);
    DestroyObject(oInChest);

    // Agregado para evitar problemas con la identificacion del item por el IPS
    if (IPS_Item_getIsAdept(oDyedItem))
        IPS_Item_disableProperties(oDyedItem, oPC);

    // Copy the armor back to the PC
    object oOnPC = CopyItem(oDyedItem, oPC, TRUE);
    DestroyObject(oDyedItem);

    int nInventorySlot = MK_GetCurrentInventorySlot(oPC);

    // Equip the armor
//    DelayCommand(0.5f, AssignCommand(oPC, ActionEquipItem(oOnPC, iItemToDye)));
    DelayCommand(0.5f, AssignCommand(oPC, ActionEquipItem(oOnPC, nInventorySlot)));
//    DelayCommand(0.55f, DisplayColors(oPC,oOnPC));

    CISetCurrentModItem(oPC,oOnPC);

    // Set armor editable again
    DelayCommand(3.0f, DeleteLocalInt(oOnPC, "mil_EditingItem"));
}

void DisplayColors(object oPC, object oItem)
{
    if (GetIsObjectValid(oItem)) {
        int iLeather1 = GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_LEATHER1);
        int iLeather2 = GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_LEATHER2);
        int iCloth1 = GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_CLOTH1);
        int iCloth2 = GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_CLOTH2);
        int iMetal1 = GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_METAL1);
        int iMetal2 = GetItemAppearance(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_METAL2);

        string sOutput = "\n" + "Leather 1: " + ClothColorEx(iLeather1);
        sOutput += "\n" + "Leather 2: " + ClothColorEx(iLeather2);
        sOutput += "\n" + "Cloth 1: " + ClothColorEx(iCloth1);
        sOutput += "\n" + "Cloth 2: " + ClothColorEx(iCloth2);
        sOutput += "\n" + "Metal 1: " + MetalColorEx(iMetal1);
        sOutput += "\n" + "Metal 2: " + MetalColorEx(iMetal2);

        SendMessageToPC(oPC, sOutput);
    }
}

string ClothColorEx(int iColor, int bDisplayNumber)
{
    string sColor = ClothColor(iColor);
    if (bDisplayNumber)
    {
        sColor = sColor + (sColor=="" ? " " : "") + "(" + IntToString(iColor) + ")";
    }
    return sColor;
}

string MetalColorEx(int iColor, int bDisplayNumber)
{
    string sColor = MetalColor(iColor);
    if (bDisplayNumber)
    {
        sColor = sColor + (sColor=="" ? " " : "") + "(" + IntToString(iColor) + ")";
    }
    return sColor;
}

string ClothColor(int iColor) {
    switch (iColor) {
        case 00: return "Lightest Tan/Brown";
        case 01: return "Light Tan/Brown";
        case 02: return "Dark Tan/Brown";
        case 03: return "Darkest Tan/Brown";

        case 04: return "Lightest Tan/Red";
        case 05: return "Light Tan/Red";
        case 06: return "Dark Tan/Red";
        case 07: return "Darkest Tan/Red";

        case 08: return "Lightest Tan/Yellow";
        case 09: return "Light Tan/Yellow";
        case 10: return "Dark Tan/Yellow";
        case 11: return "Darkest Tan/Yellow";

        case 12: return "Lightest Tan/Grey";
        case 13: return "Light Tan/Grey";
        case 14: return "Dark Tan/Grey";
        case 15: return "Darkest Tan/Grey";

        case 16: return "Lightest Olive";
        case 17: return "Light Olive";
        case 18: return "Dark Olive";
        case 19: return "Darkest Olive";

        case 20: return "White";
        case 21: return "Light Grey";
        case 22: return "Dark Grey";
        case 23: return "Charcoal";

        case 24: return "Light Blue";
        case 25: return "Dark Blue";

        case 26: return "Light Aqua";
        case 27: return "Dark Aqua";

        case 28: return "Light Teal";
        case 29: return "Dark Teal";

        case 30: return "Light Green";
        case 31: return "Dark Green";

        case 32: return "Light Yellow";
        case 33: return "Dark Yellow";

        case 34: return "Light Orange";
        case 35: return "Dark Orange";

        case 36: return "Light Red";
        case 37: return "Dark Red";

        case 38: return "Light Pink";
        case 39: return "Dark Pink";

        case 40: return "Light Purple";
        case 41: return "Dark Purple";

        case 42: return "Light Violet";
        case 43: return "Dark Violet";

        case 44: return "Shiny White";
        case 45: return "Shiny Black";

        case 46: return "Shiny Blue";
        case 47: return "Shiny Aqua";

        case 48: return "Shiny Teal";
        case 49: return "Shiny Green";

        case 50: return "Shiny Yellow";
        case 51: return "Shiny Orange";

        case 52: return "Shiny Red";
        case 53: return "Shiny Pink";

        case 54: return "Shiny Purple";
        case 55: return "Shiny Violet";

        case 56: return "Hidden: Silver";
        case 57: return "Hidden: Obsidian";
        case 58: return "Hidden: Gold";
        case 59: return "Hidden: Copper";
        case 60: return "Hidden: Grey";
        case 61: return "Hidden: Mirror";
        case 62: return "Hidden: Pure White";
        case 63: return "Hidden: Pure Black";
     }

    return "";
}

string MetalColor(int iColor) {
    switch (iColor) {
        case 00: return "Lightest Shiny Silver";
        case 01: return "Light Shiny Silver";
        case 02: return "Dark Shiny Obsidian";
        case 03: return "Darkest Shiny Obsidian";

        case 04: return "Lightest Dull Silver";
        case 05: return "Light Dull Silver";
        case 06: return "Dark Dull Obsidian";
        case 07: return "Darkest Dull Obsidian";

        case 08: return "Lightest Gold";
        case 09: return "Light Gold";
        case 10: return "Dark Gold";
        case 11: return "Darkest Gold";

        case 12: return "Lightest Celestial Gold";
        case 13: return "Light Celestial Gold";
        case 14: return "Dark Celestial Gold";
        case 15: return "Darkest Celestial Gold";

        case 16: return "Lightest Copper";
        case 17: return "Light Copper";
        case 18: return "Dark Copper";
        case 19: return "Darkest Copper";

        case 20: return "Lightest Brass";
        case 21: return "Light Brass";
        case 22: return "Dark Brass";
        case 23: return "Darkest Brass";

        case 24: return "Light Red";
        case 25: return "Dark Red";
        case 26: return "Light Dull Red";
        case 27: return "Dark Dull Red";

        case 28: return "Light Purple";
        case 29: return "Dark Purple";
        case 30: return "Light Dull Purple";
        case 31: return "Dark Dull Purple";

        case 32: return "Light Blue";
        case 33: return "Dark Blue";
        case 34: return "Light Dull Blue";
        case 35: return "Dark Dull Blue";

        case 36: return "Light Teal";
        case 37: return "Dark Teal";
        case 38: return "Light Dull Teal";
        case 39: return "Dark Dull Teal";

        case 40: return "Light Green";
        case 41: return "Dark Green";
        case 42: return "Light Dull Green";
        case 43: return "Dark Dull Green";

        case 44: return "Light Olive";
        case 45: return "Dark Olive";
        case 46: return "Light Dull Olive";
        case 47: return "Dark Dull Olive";

        case 48: return "Light Prismatic";
        case 49: return "Dark Prismatic";

        case 50: return "Lightest Rust";
        case 51: return "Light Rust";
        case 52: return "Dark Rust";
        case 53: return "Darkest Rust";

        case 54: return "Light Aged Metal";
        case 55: return "Dark Aged Metal";

        case 56: return "Hidden: Silver";
        case 57: return "Hidden: Obsidian";
        case 58: return "Hidden: Gold";
        case 59: return "Hidden: Copper";
        case 60: return "Hidden: Grey";
        case 61: return "Hidden: Mirror";
        case 62: return "Hidden: Pure White";
        case 63: return "Hidden: Pure Black";
   }

    return "";
}

/*
void main()
{

}
/**/
