////MalcolmLila3 - Lila recibe la carta

/*   Script generated by
Lilac Soul's NWN Script Generator, v. 2.3

For download info, please visit:
http://nwvault.ign.com/View.php?view=Other.Detail&id=4683&id=625    */

int StartingConditional()
{
object oPC = GetPCSpeaker();

if (GetItemPossessedBy(oPC, "CartaMalcolmLila") == OBJECT_INVALID) return FALSE;

return TRUE;
}

