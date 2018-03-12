#include "inc_utility"
#include "prc_class_const"


void main()
{
    //ExecuteScript("nw_ch_ac7", OBJECT_SELF);
    //dont fire the bioware one, it does odd things
    if(GetPRCSwitch(PRC_PNP_FAMILIARS))
    {
        //apply XP penalty
        object oPC = GetMaster();
        int nFamLevel = GetLevelByClass(CLASS_TYPE_WIZARD)
            +GetLevelByClass(CLASS_TYPE_SORCERER)
            +GetLevelByClass(CLASS_TYPE_BONDED_SUMMONNER);
            //add other familiar stacking classes here
        int nLostXP = 200*nFamLevel;
        //fort save for half xp loss
        if(FortitudeSave(oPC, 15))
            nLostXP /= 2;
        //check it wont loose a level
        int nSpareXP = GetXP(oPC)-(GetHitDice(oPC)*(GetHitDice(oPC)-1)*500);
        if(nSpareXP<nLostXP) 
            nLostXP = nSpareXP;
        SetXP(oPC, GetXP(oPC)-nLostXP);      
        //set locals to restore XP on ressurection/raisedead
        SetLocalInt(OBJECT_SELF, "RemovedXP", nLostXP);
        SetLocalInt(OBJECT_SELF, "Dead", TRUE);
        //delete it from the database
        DeleteCampaignVariable("prc_data", "Familiar", oPC);
        
    }
}