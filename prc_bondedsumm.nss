
#include "prc_inc_clsfunc"
#include "prc_feat_const"
#include "prc_class_const"
#include "prc_spell_const"
#include "prc_ipfeat_const"
#include "inc_item_props"

void ResEle(object oPC ,object oSkin ,int iLevel,int iType)
{
  if(GetLocalInt(oSkin, "BondResEle") == iLevel) return;

  RemoveSpecificProperty(oSkin,ITEM_PROPERTY_DAMAGE_RESISTANCE,iType,GetLocalInt(oSkin, "BondResEle"));

  DelayCommand(0.1, AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageResistance(iType,iLevel),oSkin));
  SetLocalInt(oSkin, "BondResEle",iLevel);
}

void ImmunityMisc(object oSkin,int bImmu,string sImmu)
{
  if (GetLocalInt(oSkin, sImmu)== 1 || bImmu==-1) return;
  AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyImmunityMisc(bImmu),oSkin);
  SetLocalInt(oSkin, sImmu,1);
}

void Subtype(object oSkin,int iType,object oPC)
{
  if (iType==IP_CONST_DAMAGETYPE_ELECTRICAL)
  {
      ActionCastSpellOnSelf(SPELL_SACREDSPEED);
      return;
  }

  if (GetLocalInt(oSkin, "BondSubType")) return;

  if (iType==IP_CONST_DAMAGETYPE_FIRE)
    AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageVulnerability(IP_CONST_DAMAGETYPE_COLD,IP_CONST_DAMAGEVULNERABILITY_50_PERCENT),oSkin);
  else if (iType==IP_CONST_DAMAGETYPE_COLD)
    AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageVulnerability(IP_CONST_DAMAGETYPE_FIRE,IP_CONST_DAMAGEVULNERABILITY_50_PERCENT),oSkin);

    SetLocalInt(oSkin, "BondSubType",iType);
}

void main()
{

     //Declare main variables.
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);

    int iType = GetHasFeat(FEAT_BONDED_AIR, oPC)   ? IP_CONST_DAMAGETYPE_ELECTRICAL  : 0 ;
        iType = GetHasFeat(FEAT_BONDED_EARTH, oPC) ? IP_CONST_DAMAGETYPE_ACID  : iType ;
        iType = GetHasFeat(FEAT_BONDED_FIRE, oPC)  ? IP_CONST_DAMAGETYPE_FIRE  : iType ;
        iType = GetHasFeat(FEAT_BONDED_WATER, oPC) ? IP_CONST_DAMAGETYPE_COLD  : iType ;


    int bResisEle = GetHasFeat(FEAT_RESISTANCE_ELE5, oPC)  ? IP_CONST_DAMAGERESIST_5 : 0;
        bResisEle = GetHasFeat(FEAT_RESISTANCE_ELE10, oPC) ? IP_CONST_DAMAGERESIST_10 : bResisEle;
        bResisEle = GetHasFeat(FEAT_RESISTANCE_ELE15, oPC) ? IP_CONST_DAMAGERESIST_15 : bResisEle;
        bResisEle = GetHasFeat(FEAT_RESISTANCE_ELE20, oPC) ? IP_CONST_DAMAGERESIST_20 : bResisEle;
        bResisEle = GetHasFeat(FEAT_IMMUNITY_ELEMENT, oPC) ? IP_CONST_DAMAGERESIST_500 : bResisEle;

    int bImmuSneak  = GetHasFeat(FEAT_IMMUNITY_SNEAKATK, oPC) ? IP_CONST_IMMUNITYMISC_BACKSTAB : -1;
    int bImmuCriti  = GetHasFeat(FEAT_IMMUNITY_CRITIK, oPC)   ? IP_CONST_IMMUNITYMISC_CRITICAL_HITS : -1;

    int bType =  GetHasFeat(FEAT_TYPE_ELEMENTAL, oPC)     ? 1: 0;

    if (bResisEle>0) ResEle(oPC,oSkin,bResisEle,iType);
    ImmunityMisc(oSkin,bImmuSneak,"ImmuSneak");
    ImmunityMisc(oSkin,bImmuCriti,"ImmuCritik");

    if (bType>0) Subtype(oSkin,iType,oPC);
}
