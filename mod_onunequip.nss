//::///////////////////////////////////////////////
//:: Example XP2 OnItemEquipped
//:: x2_mod_def_unequ
//:: (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Put into: OnUnEquip Event
*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-07-16
//:://////////////////////////////////////////////
#include "x2_inc_switches"
//#include "Tesoro_inc"
#include "inventario_inc"
#include "IPS_inc"
#include "Speed_inc"
#include "Horses_inc"
#include "Competencias_inc"
#include "RdO_Clases_inc"
#include "ReglasDeLaCasa"

void main()
{
    object oItem = GetPCItemLastUnequipped();
    object oPC = GetPCItemLastUnequippedBy();

    if( GetIsPC(oPC) && !GetIsDM(oPC) )
         IPS_Subject_onUnequip( oPC, oItem );

    Competencias_onUnequip( oPC, oItem );
    RdO_Classes_onUnequip( oPC, oItem );
    RdlC_ajustarFalloArcano( oPC );

    ExecuteScript("prc_unequip", oPC);

    Speed_applyModifiedSpeed(oPC);
    Horses_onUnequip(oPC);

    // -------------------------------------------------------------------------
    //  Intelligent Weapon System
    // -------------------------------------------------------------------------
//    if (IPGetIsIntelligentWeapon(oItem))
//    {
//            IWSetIntelligentWeaponEquipped(oPC,OBJECT_INVALID);
//            IWPlayRandomUnequipComment(oPC,oItem);
//    }

    // No esta para nada claro qu� hace esto
    SetLocalString(oPC, "LastWeap", "");
    if(Item_GetIsMeleeWeapon(oItem) == TRUE)
        SetLocalString(oPC, "LastWeap", "Melee");
    if(Item_GetIsRangedWeapon(oItem) == TRUE)
        SetLocalString(oPC, "LastWeap", "Ranged");

     // -------------------------------------------------------------------------
     // Generic Item Script Execution Code
     // If MODULE_SWITCH_EXECUTE_TAGBASED_SCRIPTS is set to TRUE on the module,
     // it will execute a script that has the same name as the item's tag
     // inside this script you can manage scripts for all events by checking against
     // GetUserDefinedItemEventNumber(). See x2_it_example.nss
     // -------------------------------------------------------------------------
     if (GetModuleSwitchValue(MODULE_SWITCH_ENABLE_TAGBASED_SCRIPTS) == TRUE)
     {
        SetUserDefinedItemEventNumber(X2_ITEM_EVENT_UNEQUIP);
        int nRet =   ExecuteScriptAndReturnInt(GetUserDefinedItemEventScriptName(oItem),OBJECT_SELF);
        if (nRet == X2_EXECUTE_SCRIPT_END)
        {
           return;
        }

     }
}
