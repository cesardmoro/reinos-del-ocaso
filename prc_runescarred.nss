#include "inc_item_props"
#include "prc_feat_const"
#include "prc_class_const"
#include "prc_ipfeat_const"

// Runescarred Berserker
/*
const int FEAT_RIT_SCAR             = 2369;
const int FEAT_SPAWNFROST           = 2371;
const int FEAT_RIT_DR               = 2370;
*/
////Resistance Cold////
void ResCold(object oPC ,object oSkin ,int iLevel)
{
  //if(GetLocalInt(oSkin, "RuneCold") == iLevel) return;
  RemoveSpecificProperty(oSkin,ITEM_PROPERTY_DAMAGE_RESISTANCE,IP_CONST_DAMAGETYPE_COLD,GetLocalInt(oSkin, "RuneCold"));
  AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageResistance(IP_CONST_DAMAGETYPE_COLD,iLevel),oSkin);
  SetLocalInt(oSkin, "RuneCold",iLevel);
}

///Ritual Scarring /////////
void RitScar(object oPC ,object oSkin, int iLevel)
{
   if(GetLocalInt(oSkin, "RitScarAC") == iLevel) return;

    SetCompositeBonus(oSkin, "RitScarAC", iLevel,ITEM_PROPERTY_AC_BONUS);

}

void RitDR(object oPC, object oSkin, int iLevel)
{
   //if(GetLocalInt(oSkin, "RitScarDR") == iLevel) return;
    RemoveSpecificProperty(oSkin, ITEM_PROPERTY_DAMAGE_REDUCTION, GetLocalInt(oSkin, "RitScarDR"), iLevel, 1, "RitScarDR");
    AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_20, iLevel), oSkin);
    SetLocalInt(oSkin, "RitScarDR", iLevel);
}

void main()
{

    //Declare main variables.
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);

    int bRitDR = GetHasFeat(FEAT_RIT_DR, oPC) ? IP_CONST_DAMAGESOAK_1_HP : 0;

    if(GetLevelByClass(CLASS_TYPE_RUNESCARRED, oPC) >= 7)
     {
     bRitDR = IP_CONST_DAMAGESOAK_2_HP;
     }
    if(GetLevelByClass(CLASS_TYPE_RUNESCARRED, oPC) >= 10)
     {
     bRitDR = IP_CONST_DAMAGESOAK_3_HP;
     }

     int bRitScar=GetHasFeat(FEAT_RIT_SCAR, oPC) ? 1 : 0;
         bRitScar=GetHasFeat(FEAT_RIT_SCAR_2, oPC) ? 2 : bRitScar;
         bRitScar=GetHasFeat(FEAT_RIT_SCAR_3, oPC) ? 3 : bRitScar;
     /*if(GetLevelByClass(CLASS_TYPE_RUNESCARRED, oPC) >= 6)
     {
     bRitScar = 2;
     }

     if(GetLevelByClass(CLASS_TYPE_RUNESCARRED, oPC) >= 9)
     {
     bRitScar = 3;
     }
     */
    int bResCold=GetHasFeat(FEAT_SPAWNFROST, oPC) ? IP_CONST_DAMAGERESIST_5 : 0;

    if (bResCold>0) ResCold(oPC,oSkin,bResCold);
    if (bRitScar>0) RitScar(oPC, oSkin,bRitScar);
    if (bRitDR>0) RitDR(oPC, oSkin,bRitDR);


}