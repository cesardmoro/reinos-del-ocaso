//::///////////////////////////////////////////////
//:: Name: Pony del Sur Benzor
//:: FileName: PoSurBen6
//:: Quest Pony Sur Benzor, PJ trae carta desde Ornal, le pagan 5gp
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Created By: Lobofiel
//:: Created On:
//:://////////////////////////////////////////////
/*   Script generated by
Lilac Soul's NWN Script Generator, v. 2.3

For download info, please visit:
http://nwvault.ign.com/View.php?view=Other.Detail&id=4683&id=625    */

//Put this on action taken in the conversation editor
#include "nw_i0_tool"
void main()
{

object oPC = GetPCSpeaker();

object oItem;
oItem = GetFirstItemInInventory(oPC);

while (GetIsObjectValid(oItem))
   {
   if (GetTag(oItem)=="PoSurOrBen") DestroyObject(oItem);

   oItem = GetNextItemInInventory(oPC);
   }

RewardPartyGP(5, oPC, FALSE);

}

