//::///////////////////////////////////////////////
//:: Name: Pony del Sur Benzor
//:: FileName: PoSurBen4
//:: Quest Pony Sur Benzor, PJ trae carta desde Ornal
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

int StartingConditional()
{
object oPC = GetPCSpeaker();

if (GetItemPossessedBy(oPC, "PoSurOrBen") == OBJECT_INVALID) return FALSE;

return TRUE;
}

