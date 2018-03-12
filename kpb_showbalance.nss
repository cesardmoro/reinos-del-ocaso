////////////////////////////////////////////
//  Kittrell's Persistent Banking System  //
//  Designed by: Brian J. Kittrell        //
//                                        //
//  This script does the following:       //
//                                        //
//  kpb_showbalance - This script will    //
//  show the current amount of gold held  //
//  for the player by the bank.           //
////////////////////////////////////////////

void main()
{
object oPC = GetPCSpeaker();
int nBalance = GetCampaignInt("kpb_bank", "KPB_BANK_BALANCE", oPC);
SpeakString("Usted tiene" + IntToString(nBalance) + " monedas en su cuenta", TALKVOLUME_TALK);
}
