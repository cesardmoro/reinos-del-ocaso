////////////////////////////////////////////
//  Kittrell's Persistent Banking System  //
//  Designed by: Brian J. Kittrell        //
////////////////////////////////////////////

#include "kpb_inc"

void main()
{
    object oPC = GetPCSpeaker();
    int nDeposit = GetLocalInt(oPC, KPB_Bank_CANTIDAD_DEPOSITO_VAR);
    int nBalance = GetCampaignInt("kpb_bank", "KPB_BANK_BALANCE", oPC);
    int nAmount = nDeposit + nBalance - GetLocalInt(oPC, KPB_Bank_IMPUESTO_VAR);
    int nGold = GetGold(oPC);
    int iMonth = GetCalendarMonth();
    int iDay = GetCalendarDay();
    int iYear = GetCalendarYear();
    if (nGold >= nDeposit)
    {
        TakeGoldFromCreature(nDeposit, oPC, TRUE);
        SetCampaignInt("kpb_bank", "KPB_BANK_BALANCE", nAmount, oPC);
        SetCampaignInt("kpb_bank", "KPB_DEPO_YEAR", iYear, oPC);
        SetCampaignInt("kpb_bank", "KPB_DEPO_DAY", iDay, oPC);
        SetCampaignInt("kpb_bank", "KPB_DEPO_MONTH", iMonth, oPC);
        SpeakString("Usted tiene" + IntToString(nAmount) + " monedas en su cuenta", TALKVOLUME_TALK);
    }
    else
    {
        SpeakString("No tienes suficiente oro para depositar", TALKVOLUME_TALK);
    }
    DeleteLocalInt(oPC, KPB_Bank_CANTIDAD_DEPOSITO_VAR);
    DeleteLocalInt(oPC, KPB_Bank_IMPUESTO_VAR);

}
