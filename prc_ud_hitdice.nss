//::///////////////////////////////////////////////
//:: Name   Undead Hit Dice
//:: FileName   prc_bn_hitdice
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*   Gives +12 to CON on oSkin to simulate the d12
     change of undead creatures

*/
//:://////////////////////////////////////////////
//:: Created By:  Tenjac
//:: Created On:  11/26/04
//:://////////////////////////////////////////////

#include "inc_utility"


void main()
{
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    int nBonus = 12;

    if(DEBUG) DoDebug("prc_ud_hitdice: Applying +12 Con bonus\n"
                    + "oPC = " + DebugObject2Str(oPC) + "\n"
                    + "oSkin = " + DebugObject2Str(oSkin) + "\n"
                      );

    SetCompositeBonus(oSkin, "PRCUndeadHD", nBonus, ITEM_PROPERTY_ABILITY_BONUS, IP_CONST_ABILITY_CON);
}

