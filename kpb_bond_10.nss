////////////////////////////////////////////
//  Kittrell's Persistent Banking System  //
//  Designed by: Brian J. Kittrell        //
//                                        //
//  This script does the following:       //
//                                        //
//  kpb_bond_10 - This script allows      //
//  players to receive a bullion bank     //
//  bond for 10,000 gold coins.           //
////////////////////////////////////////////

void main()
{
    object oPC = GetPCSpeaker();
    string sItem = "bullionbond10";
    int nCost = 10000;
    int nGold = GetGold(oPC);

    if (nGold < nCost)
    {
    SpeakString("Debes tener el dinero necesario.");
    return;
    }
    if (nGold >= nCost)
    {
        CreateItemOnObject(sItem, oPC);
        TakeGoldFromCreature(10000, oPC, TRUE);
        SpeakString("Muy bien aqui tiene el bono.");
    }
}
