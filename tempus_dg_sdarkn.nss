#include "prc_feat_const"

void main()
{
    object oPC = GetPCSpeaker();

   if (GetLocalInt(oPC,"WeapEchant1")==TEMPUS_ABILITY_DARKNESS||
        GetLocalInt(oPC,"WeapEchant2")==TEMPUS_ABILITY_DARKNESS||
        GetLocalInt(oPC,"WeapEchant3")==TEMPUS_ABILITY_DARKNESS)
        return;

    if(!GetLocalInt(oPC,"WeapEchant1"))
      SetLocalInt(oPC,"WeapEchant1",TEMPUS_ABILITY_DARKNESS);
    else if(!GetLocalInt(oPC,"WeapEchant2"))
      SetLocalInt(oPC,"WeapEchant2",TEMPUS_ABILITY_DARKNESS);
    else if(!GetLocalInt(oPC,"WeapEchant3"))
      SetLocalInt(oPC,"WeapEchant3",TEMPUS_ABILITY_DARKNESS);


     SetLocalInt(oPC,"TempusPower",GetLocalInt(oPC,"TempusPower")-1);

}
