#include "prc_feat_const"

void main()
{
    object oPC = GetPCSpeaker();
    if ( (GetLocalInt(oPC,"WeapEchant1")==TEMPUS_ABILITY_VICIOUS && GetLocalInt(oPC,"WeapEchantRace1")==IP_CONST_RACIALTYPE_ELEMENTAL  )||
         (GetLocalInt(oPC,"WeapEchant1")==TEMPUS_ABILITY_VICIOUS && GetLocalInt(oPC,"WeapEchantRace2")==IP_CONST_RACIALTYPE_ELEMENTAL  )||
         (GetLocalInt(oPC,"WeapEchant1")==TEMPUS_ABILITY_VICIOUS && GetLocalInt(oPC,"WeapEchantRace3")==IP_CONST_RACIALTYPE_ELEMENTAL  ))
          return;

    if(!GetLocalInt(oPC,"WeapEchant1"))
    {
      SetLocalInt(oPC,"WeapEchant1",TEMPUS_ABILITY_VICIOUS);
      SetLocalInt(oPC,"WeapEchantRace1",IP_CONST_RACIALTYPE_ELEMENTAL);
    }
    else if(!GetLocalInt(oPC,"WeapEchant2"))
    {
      SetLocalInt(oPC,"WeapEchant2",TEMPUS_ABILITY_VICIOUS);
      SetLocalInt(oPC,"WeapEchantRace2",IP_CONST_RACIALTYPE_ELEMENTAL);
    }
    else if(!GetLocalInt(oPC,"WeapEchant3"))
    {
      SetLocalInt(oPC,"WeapEchant3",TEMPUS_ABILITY_VICIOUS);
      SetLocalInt(oPC,"WeapEchantRace3",IP_CONST_RACIALTYPE_ELEMENTAL);
    }

     SetLocalInt(oPC,"TempusPower",GetLocalInt(oPC,"TempusPower")-1);

}
