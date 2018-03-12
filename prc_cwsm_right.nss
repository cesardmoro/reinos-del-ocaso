#include "inc_utility"

void main()
{
   object oTarget;
   object oPC = OBJECT_SELF;
   object oWeap = GetFirstItemInInventory(oPC);

   object oItem = GetItemInSlot(INVENTORY_SLOT_LEFTHAND);
   if (DEBUG) FloatingTextStringOnCreature("Right Exec",OBJECT_SELF);
   //Searches Inventory for Katana and Shortsword and Equips them
   while(!GetIsObjectValid(oItem))
   {
        if(GetBaseItemType(oWeap) == BASE_ITEM_SHORTSWORD)
	{
		oItem = oWeap;
		ForceEquip(oPC, oWeap, INVENTORY_SLOT_LEFTHAND);
		if (DEBUG) FloatingTextStringOnCreature("inside left hand loop",OBJECT_SELF);
		break;
	}
	oWeap = GetNextItemInInventory(oPC);
   }
}