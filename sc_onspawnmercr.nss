//:://////////////////////////////////////////////
/*
    Default On Spawn script


    2003-07-28: Georg Zoeller:

    If you set a ninteger on the creature named
    "X2_USERDEFINED_ONSPAWN_EVENTS"
    The creature will fire a pre and a post-spawn
    event on itself, depending on the value of that
    variable
    1 - Fire Userdefined Event 1510 (pre spawn)
    2 - Fire Userdefined Event 1511 (post spawn)
    3 - Fire both events

*/
//:://////////////////////////////////////////////
//:: Created By: Keith Warner, Georg Zoeller
//:: Created On: June 11/03
//:://////////////////////////////////////////////

const int EVENT_USER_DEFINED_PRESPAWN = 1510;
const int EVENT_USER_DEFINED_POSTSPAWN = 1511;
void todosin(object oPC)
{
DelayCommand(90.0, ExecuteScript("borrarcriatura", OBJECT_SELF));
object oPri = GetFirstItemInInventory(oPC);
while(oPri != OBJECT_INVALID)
{
if(!(GetStringLeft(GetTag(oPri), 6) == "Cuerpo"))
{
SetDroppableFlag(oPri, FALSE);
SetPlotFlag(oPri, FALSE);
SetIdentified(oPri, TRUE);
}
oPri = GetNextItemInInventory(oPC);
}
SetIdentified(GetItemInSlot(INVENTORY_SLOT_ARMS, oPC), TRUE);
SetIdentified(GetItemInSlot(INVENTORY_SLOT_ARROWS, oPC), TRUE);
SetIdentified(GetItemInSlot(INVENTORY_SLOT_BELT, oPC), TRUE);
SetIdentified(GetItemInSlot(INVENTORY_SLOT_BOLTS, oPC), TRUE);
SetIdentified(GetItemInSlot(INVENTORY_SLOT_BOOTS, oPC), TRUE);
SetIdentified(GetItemInSlot(INVENTORY_SLOT_BULLETS, oPC), TRUE);
SetIdentified(GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPC), TRUE);
SetIdentified(GetItemInSlot(INVENTORY_SLOT_CHEST, oPC), TRUE);
SetIdentified(GetItemInSlot(INVENTORY_SLOT_CLOAK, oPC), TRUE);
SetIdentified(GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oPC), TRUE);
SetIdentified(GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oPC), TRUE);
SetIdentified(GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oPC), TRUE);
SetIdentified(GetItemInSlot(INVENTORY_SLOT_HEAD, oPC), TRUE);
SetIdentified(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC), TRUE);
SetIdentified(GetItemInSlot(INVENTORY_SLOT_LEFTRING, oPC), TRUE);
SetIdentified(GetItemInSlot(INVENTORY_SLOT_NECK, oPC), TRUE);
SetIdentified(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC), TRUE);
SetIdentified(GetItemInSlot(INVENTORY_SLOT_RIGHTRING, oPC), TRUE);

SetDroppableFlag(GetItemInSlot(INVENTORY_SLOT_ARMS, oPC), FALSE);
SetDroppableFlag(GetItemInSlot(INVENTORY_SLOT_ARROWS, oPC), FALSE);
SetDroppableFlag(GetItemInSlot(INVENTORY_SLOT_BELT, oPC), FALSE);
SetDroppableFlag(GetItemInSlot(INVENTORY_SLOT_BOLTS, oPC), FALSE);
SetDroppableFlag(GetItemInSlot(INVENTORY_SLOT_BOOTS, oPC), FALSE);
SetDroppableFlag(GetItemInSlot(INVENTORY_SLOT_BULLETS, oPC), FALSE);
SetDroppableFlag(GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPC), FALSE);
SetDroppableFlag(GetItemInSlot(INVENTORY_SLOT_CHEST, oPC), FALSE);
SetDroppableFlag(GetItemInSlot(INVENTORY_SLOT_CLOAK, oPC), FALSE);
SetDroppableFlag(GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oPC), FALSE);
SetDroppableFlag(GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oPC), FALSE);
SetDroppableFlag(GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oPC), FALSE);
SetDroppableFlag(GetItemInSlot(INVENTORY_SLOT_HEAD, oPC), FALSE);
SetDroppableFlag(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC), FALSE);
SetDroppableFlag(GetItemInSlot(INVENTORY_SLOT_LEFTRING, oPC), FALSE);
SetDroppableFlag(GetItemInSlot(INVENTORY_SLOT_NECK, oPC), FALSE);
SetDroppableFlag(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC), FALSE);
SetDroppableFlag(GetItemInSlot(INVENTORY_SLOT_RIGHTRING, oPC), FALSE);



//}


}

#include "x2_inc_switches"
void main()
{
todosin(OBJECT_SELF);
    //Permite que algunos NPC tengan nombre propio
    if (GetLocalInt(OBJECT_SELF, "TieneNombrePropio")==0) {
        if(GetGender(OBJECT_SELF) == GENDER_MALE) {
            SetName(OBJECT_SELF, RandomName(NAME_FIRST_GENERIC_MALE)+" "+RandomName(NAME_LAST_HUMAN));
        }
        else if(GetGender(OBJECT_SELF) == GENDER_FEMALE) {
            SetName(OBJECT_SELF, RandomName(NAME_FIRST_HUMAN_FEMALE)+" "+RandomName(NAME_LAST_HUMAN));
        }
    }
    // User defined OnSpawn event requested?
    int nSpecEvent = GetLocalInt(OBJECT_SELF,"X2_USERDEFINED_ONSPAWN_EVENTS");

    // Pre Spawn Event requested
    if (nSpecEvent == 1  || nSpecEvent == 3  )
    {
    SignalEvent(OBJECT_SELF,EventUserDefined(EVENT_USER_DEFINED_PRESPAWN ));
    }

    /*  Fix for the new golems to reduce their number of attacks */

    int nNumber = GetLocalInt(OBJECT_SELF,CREATURE_VAR_NUMBER_OF_ATTACKS);
    if (nNumber >0 )
    {
        SetBaseAttackBonus(nNumber);
    }

    // Execute default OnSpawn script.
    ExecuteScript("nw_c2_default9", OBJECT_SELF);


    //Post Spawn event requeste
    if (nSpecEvent == 2 || nSpecEvent == 3)
    {
    SignalEvent(OBJECT_SELF,EventUserDefined(EVENT_USER_DEFINED_POSTSPAWN));
    }

}
