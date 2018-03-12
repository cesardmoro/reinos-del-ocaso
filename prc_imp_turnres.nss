//::///////////////////////////////////////////////
//:: Name   Improved Turn Resistance
//:: FileName  prc_imp_turnres.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*  Improved Turn Resistance feat for undead chracters

*/
//:://////////////////////////////////////////////
//:: Created By:  Tenjac
//:: Created On:  12/17/04
//:://////////////////////////////////////////////

#include "inc_utility"
void main()
{
object oPC = (OBJECT_SELF);
object oSkin = GetPCSkin(oPC);

SetCompositeBonus(oSkin, "ImpTurnRes", 4, ITEM_PROPERTY_TURN_RESISTANCE);
}

