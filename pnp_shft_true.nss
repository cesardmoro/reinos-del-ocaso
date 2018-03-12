//true form shifter class feat script
#include "pnp_shft_main"

void main()
{
	if (CanShift(OBJECT_SELF))
	{
		SetShiftTrueForm(OBJECT_SELF);
		ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectVisualEffect(VFX_IMP_POLYMORPH),OBJECT_SELF);
		//re-equid creature items to get correct ip feats
		//(some were staying on even when they had been removed from the hide)
//		object oHidePC = GetItemInSlot(INVENTORY_SLOT_CARMOUR,OBJECT_SELF);
//		object oWeapCRPC = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R,OBJECT_SELF);
//		object oWeapCLPC = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L,OBJECT_SELF);
//		object oWeapCBPC = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B,OBJECT_SELF);
		//mast re-equiping the items when they are already equiped to
		//fix up item propertys
//		DelayCommand(0.5,ActionEquipItem(oHidePC,INVENTORY_SLOT_CARMOUR));
//		DelayCommand(0.5,ActionEquipItem(oWeapCRPC,INVENTORY_SLOT_CWEAPON_R));
//		DelayCommand(0.5,ActionEquipItem(oWeapCLPC,INVENTORY_SLOT_CWEAPON_L));
//		DelayCommand(0.5,ActionEquipItem(oWeapCBPC,INVENTORY_SLOT_CWEAPON_B));

		//this was added to stop the shifter from looking naked when they reenter/reload
		//a server/mod and then unshifting.
		object oArmour = GetItemInSlot(INVENTORY_SLOT_CHEST);
		object oHelm = GetItemInSlot(INVENTORY_SLOT_HEAD);
		if (GetIsObjectValid(oArmour))
		{
//			DelayCommand(0.0,ActionUnequipItem(oArmour));
//			DelayCommand(0.1,ActionEquipItem(oArmour,INVENTORY_SLOT_CHEST));
		}
		if (GetIsObjectValid(oHelm))
		{
//			DelayCommand(0.2,ActionUnequipItem(oHelm));
//			DelayCommand(0.3,ActionEquipItem(oHelm,INVENTORY_SLOT_HEAD));
		}

		// Reset any PRC feats that might have been lost from the shift
		DelayCommand(1.0, EvalPRCFeats(OBJECT_SELF));
		DeleteLocalInt(OBJECT_SELF, "shifting");
		DelayCommand(1.0, ClearShifterItems(OBJECT_SELF));
	}

}


//
//    	//re-equid creature items to get correct ip feats
//	    //(some were staying on even when they had been removed from the hide)
//    	oHide = GetItemInSlot(INVENTORY_SLOT_CARMOUR,oPC);
//	    oWeapCR = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R,oPC);
//    	oWeapCL = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L,oPC);
//	    oWeapCB = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B,oPC);
//    	//mast not unequid the items, this would crash the game
//	    //but re-equiping the items when they are already equiped will
//    	//recheck what is on the hide
//	    DelayCommand(0.0,AssignCommand(oPC,ActionEquipItem(oHide,INVENTORY_SLOT_CARMOUR)));
//	    DelayCommand(0.0,AssignCommand(oPC,ActionEquipItem(oWeapCR,INVENTORY_SLOT_CWEAPON_R)));
//	    DelayCommand(0.0,AssignCommand(oPC,ActionEquipItem(oWeapCL,INVENTORY_SLOT_CWEAPON_L)));
//	    DelayCommand(0.0,AssignCommand(oPC,ActionEquipItem(oWeapCB,INVENTORY_SLOT_CWEAPON_B)));
//------------->
