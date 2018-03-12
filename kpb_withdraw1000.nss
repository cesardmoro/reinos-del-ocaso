////////////////////////////////////////////
//  Kittrell's Persistent Banking System  //
//  Designed by: Brian J. Kittrell        //
//                                        //
//  This script does the following:       //
//                                        //
//  kpb_withdraw1000 - This script allows //
//  players to withdraw 1000 of their     //
//  gold that is in the vault.            //
////////////////////////////////////////////

void main()
{
object oPC = GetPCSpeaker();
int nWithdraw = 1000;
int nBalance = GetCampaignInt("kpb_bank", "KPB_BANK_BALANCE", oPC);
int nAmount = (nBalance - nWithdraw);
int nGold = GetGold(oPC);
if (nBalance >= 1000)
    {
    GiveGoldToCreature(oPC, nWithdraw);
    SetCampaignInt("kpb_bank", "KPB_BANK_BALANCE", nAmount, oPC);
    }
else
    {
    SpeakString("No tienes suficiente en tu cuenta para retirar eso", TALKVOLUME_TALK);
    }
}
