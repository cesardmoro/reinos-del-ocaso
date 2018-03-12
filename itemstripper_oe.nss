//***************************************************************************//
//                         ITEM STRIPPER                                     //
//                                                                           //
//                  created by Darkleaf/Philip                               //
//                  philip_schouten@hotmail.com                              //
//***************************************************************************//
//                                                                           //
//              Comment in and out what you need.                            //
//      Don't change anything unless you know what you're doing.             //
//                                                                           //
//***************************************************************************//

void main()
{
object oPC = GetEnteringObject();
int nStripped = GetLocalInt(oPC, "stripped");

if ((GetIsPC(oPC))&&(GetXP(oPC) == 0))
    {
    // Set the integer for stripping once
    SetLocalInt(oPC, "stripped", 1);

    /*Remove Gold   -   Default at destroy all*/

    TakeGoldFromCreature(GetGold(oPC), oPC, TRUE);
    GiveGoldToCreature(oPC, 25000);

    /*Remove XP or give XP  -Default at 0
    To give XP: levels are the following:
    LVL 1:  0           LVL 11: 55000       LVL 21: 210000
    LVL 2:  1000        LVL 12: 66000       LVL 22: 231000
    LVL 3:  3000        LVL 13: 78000       LVL 23: 253000
    LVL 4:  6000        LVL 14: 91000       LVL 24: 276000
    LVL 5:  10000       LVL 15: 105000      LVL 25: 300000
    LVL 6:  15000       LVL 16: 120000      LVL 26: 325000
    LVL 7:  21000       LVL 17: 136000      LVL 27: 351000
    LVL 8:  28000       LVL 18: 153000      LVL 28: 378000
    LVL 9:  36000       LVL 19: 171000      LVL 29: 406000
    LVL 10: 45000       LVL 20: 190000      LVL 30: 435000*/
    //Change the 0 in anything

    SetXP(oPC, 105000);

    /*Destroy all items on the PC   -   Default destroys everything*/

    //Chest item
    DestroyObject(GetItemInSlot(INVENTORY_SLOT_CHEST, oPC), 0.0);
    //Creature armor item. Might not be necesarry but is possibly equiped.
    DestroyObject(GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPC), 0.0);
    //Arms item
    DestroyObject(GetItemInSlot(INVENTORY_SLOT_ARMS, oPC), 0.0);
    //Left hand item
    DestroyObject(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC), 0.0);
    //Lef hand ring item
    DestroyObject(GetItemInSlot(INVENTORY_SLOT_LEFTRING, oPC), 0.0);
    //Right hand item
    DestroyObject(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC), 0.0);
    //Right hand ring item
    DestroyObject(GetItemInSlot(INVENTORY_SLOT_RIGHTRING, oPC), 0.0);
    //Neck item
    DestroyObject(GetItemInSlot(INVENTORY_SLOT_NECK, oPC), 0.0);
    //Head item
    DestroyObject(GetItemInSlot(INVENTORY_SLOT_HEAD, oPC), 0.0);
    //Creaure weapon item bite. Might not be necesarry but is possibly equiped.
    DestroyObject(GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oPC), 0.0);
    //Creaure weapon item left hand. Might not be necesarry but is possibly equiped.
    DestroyObject(GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oPC), 0.0);
    //Creaure weapon item right hand. Might not be necesarry but is possibly equiped.
    DestroyObject(GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oPC), 0.0);
    //Cloak item
    DestroyObject(GetItemInSlot(INVENTORY_SLOT_CLOAK, oPC), 0.0);
    //Belt item
    DestroyObject(GetItemInSlot(INVENTORY_SLOT_BELT, oPC), 0.0);
    //Arrows item
    DestroyObject(GetItemInSlot(INVENTORY_SLOT_ARROWS, oPC), 0.0);
    //Bolts item
    DestroyObject(GetItemInSlot(INVENTORY_SLOT_BOLTS, oPC), 0.0);
    //Bullets item
    DestroyObject(GetItemInSlot(INVENTORY_SLOT_BULLETS, oPC), 0.0);
    //Boots item
    DestroyObject(GetItemInSlot(INVENTORY_SLOT_BOOTS, oPC), 0.0);

    /*Create items on the PC. Put the resref in the commands.*/

    //Chest item
    object oChest = CreateItemOnObject("resref", oPC, 1);
    //Arms item
    object oArms = CreateItemOnObject("resref", oPC, 1);
    //Right hand item
    object oRightHand = CreateItemOnObject("resref", oPC, 1);
    //Right hand ring item
    object oRightRing = CreateItemOnObject("resref", oPC, 1);
    //Left hand item
    object oLeftHand = CreateItemOnObject("resref", oPC, 1);
    //Left hand ring item
    object oLeftRing = CreateItemOnObject("resref", oPC, 1);
    //Cloak item
    object oCloak = CreateItemOnObject("resref", oPC, 1);
    //Neck item
    object oNeck = CreateItemOnObject("resref", oPC, 1);
    //Head item
    object oHead = CreateItemOnObject("resref", oPC, 1);
    //Boots item
    object oBoots = CreateItemOnObject("resref", oPC, 1);
    //Arrows item
    object oArrows = CreateItemOnObject("resref", oPC, 99);
    //Bolts item
    object oBolts = CreateItemOnObject("resref", oPC, 99);
    //Bullets item
    object oBullets = CreateItemOnObject("resref", oPC, 99);
    //Creature bite item
    object oCBite = CreateItemOnObject("resref", oPC, 1);
    //Creature left hand item
    object oCLeft = CreateItemOnObject("resref", oPC, 1);
    //Creature right hand item
    object oCRight = CreateItemOnObject("resref", oPC, 1);
    //Creatue armour
    object oCArmour = CreateItemOnObject("resref", oPC, 1);
    //Belt item
    object oBelt = CreateItemOnObject("resref", oPC, 1);

    /* Equip items on the PC */

    //Equip chest item
    AssignCommand(oPC, ActionEquipItem(oChest, INVENTORY_SLOT_CHEST));
    //Equip arms item
    AssignCommand(oPC, ActionEquipItem(oArms, INVENTORY_SLOT_ARMS));
    //Equip right hand item
    AssignCommand(oPC, ActionEquipItem(oRightHand, INVENTORY_SLOT_RIGHTHAND));
    //Equip right hand ring item
    AssignCommand(oPC, ActionEquipItem(oRightRing, INVENTORY_SLOT_RIGHTRING));
    //Equip left hand item
    AssignCommand(oPC, ActionEquipItem(oLeftHand, INVENTORY_SLOT_LEFTHAND));
    //Equip left hand ring item
    AssignCommand(oPC, ActionEquipItem(oLeftRing, INVENTORY_SLOT_LEFTRING));
    //Equip cloak item
    AssignCommand(oPC, ActionEquipItem(oCloak, INVENTORY_SLOT_CLOAK));
    //Equip neck item
    AssignCommand(oPC, ActionEquipItem(oNeck, INVENTORY_SLOT_NECK));
    //Equip head item
    AssignCommand(oPC, ActionEquipItem(oHead, INVENTORY_SLOT_HEAD));
    //Equip boots item
    AssignCommand(oPC, ActionEquipItem(oBoots, INVENTORY_SLOT_BOOTS));
    //Equip arrows
    AssignCommand(oPC, ActionEquipItem(oArrows, INVENTORY_SLOT_ARROWS));
    //Equip bolts
    AssignCommand(oPC, ActionEquipItem(oBolts, INVENTORY_SLOT_BOLTS));
    //Equip bullets
    AssignCommand(oPC, ActionEquipItem(oBullets, INVENTORY_SLOT_BULLETS));
    //Equip creature bite item
    AssignCommand(oPC, ActionEquipItem(oCBite, INVENTORY_SLOT_CWEAPON_B));
    //Equip creature left hand item
    AssignCommand(oPC, ActionEquipItem(oCLeft,INVENTORY_SLOT_CWEAPON_L));
    //Equip creature right hand item
    AssignCommand(oPC, ActionEquipItem(oCRight, INVENTORY_SLOT_CWEAPON_R));
    //Equip creature armour item
    AssignCommand(oPC, ActionEquipItem(oCArmour, INVENTORY_SLOT_CARMOUR));
    //Equip belt item
    AssignCommand(oPC, ActionEquipItem(oBelt, INVENTORY_SLOT_BELT));

    /* Destroy all inventory items */

    object oDestroy = GetFirstItemInInventory(oPC);

    while (oDestroy != OBJECT_INVALID)
        {
        DestroyObject(oDestroy, 0.0);

        oDestroy = GetNextItemInInventory(oPC);
        }

    /* Give new items to the PC. Put the resref between quotation marks.
       Uncomment and copy new lines if needed.                           */
    //object oItem = CreateItemOnObject("resref", oPC, 1);
    }
}
