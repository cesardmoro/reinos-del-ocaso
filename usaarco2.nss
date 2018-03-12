#include "j_inc_spawnin"

void main()
{
SetAIInteger(AI_RANGED_WEAPON_RANGE, 3);
SetSpawnInCondition(AI_FLAG_COMBAT_ARCHER_ALWAYS_MOVE_BACK, AI_COMBAT_MASTER);
object oPC = OBJECT_SELF;

    if (GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_ARROWS ,oPC)) == TRUE)
    {


    DestroyObject(GetItemInSlot(INVENTORY_SLOT_ARROWS ,oPC), 0.1);

        //      SetLocalInt(oPC, "nArrow", GetLocalInt(oPC, "nArrow") + GetItemStackSize(GetItemInSlot(INVENTORY_SLOT_ARROWS ,oPC)));
    }
    object oPri = GetFirstItemInInventory(oPC);
    while(oPri != OBJECT_INVALID)
    {
        if (GetBaseItemType(oPri) == BASE_ITEM_ARROW)
        {
            DestroyObject(oPri, 0.1);
            //SetLocalInt(oPC, "nArrow", GetLocalInt(oPC, "nArrow") + GetItemStackSize(oPri));
        }

        oPri = GetNextItemInInventory(oPC);
    }
 //   SendMessageToPC(oPC, "Llevas "+IntToString(GetLocalInt(oPC, "nArrow"))+" de "+IntToString(nArrow)+" Flechas");
if (GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_BOLTS ,oPC)) == TRUE)
    {


    DestroyObject(GetItemInSlot(INVENTORY_SLOT_BOLTS ,oPC), 0.1);

        //      SetLocalInt(oPC, "nArrow", GetLocalInt(oPC, "nArrow") + GetItemStackSize(GetItemInSlot(INVENTORY_SLOT_ARROWS ,oPC)));
    }
     oPri = GetFirstItemInInventory(oPC);
    while(oPri != OBJECT_INVALID)
    {
        if (GetBaseItemType(oPri) == BASE_ITEM_BOLT)
        {
            DestroyObject(oPri, 0.1);
            //SetLocalInt(oPC, "nArrow", GetLocalInt(oPC, "nArrow") + GetItemStackSize(oPri));
        }

        oPri = GetNextItemInInventory(oPC);
    }
if (GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_BULLETS ,oPC)) == TRUE)
    {


    DestroyObject(GetItemInSlot(INVENTORY_SLOT_BULLETS ,oPC), 0.1);

        //      SetLocalInt(oPC, "nArrow", GetLocalInt(oPC, "nArrow") + GetItemStackSize(GetItemInSlot(INVENTORY_SLOT_ARROWS ,oPC)));
    }
     oPri = GetFirstItemInInventory(oPC);
    while(oPri != OBJECT_INVALID)
    {
        if (GetBaseItemType(oPri) == BASE_ITEM_BULLET)
        {
            DestroyObject(oPri, 0.1);
            //SetLocalInt(oPC, "nArrow", GetLocalInt(oPC, "nArrow") + GetItemStackSize(oPri));
        }

        oPri = GetNextItemInInventory(oPC);
    }
CreateItemOnObject("nw_wamar001", OBJECT_SELF, 99);
CreateItemOnObject("nw_wambo001", OBJECT_SELF, 99);
CreateItemOnObject("nw_wambu001", OBJECT_SELF, 99);
}
