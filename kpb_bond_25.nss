////////////////////////////////////////////
//  Kittrell's Persistent Banking System  //
//  Designed by: Brian J. Kittrell        //
//                                        //
//  This script does the following:       //
//                                        //
//  kpb_bond_25 - This script allows      //
//  players to receive a bullion bank     //
//  bond for 25,000 gold coins.           //
////////////////////////////////////////////

void main()
{
    object oPC = GetPCSpeaker();
    string sItem = "bullionbond25";
    int nCost = 25000;
    int nGold = GetGold(oPC);

    if (nGold < nCost)
    {
    SpeakString("Debes tener el dinero necesario.");
    return;
    }
    if (nGold >= nCost)
    {
        CreateItemOnObject(sItem, oPC);
        TakeGoldFromCreature(25000, oPC, TRUE);
        SpeakString("Aqui Tiene.");
    }
}
