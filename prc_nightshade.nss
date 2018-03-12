
#include "prc_feat_const"
#include "prc_class_const"
#include "prc_spell_const"
#include "inc_item_props"
#include "prc_ipfeat_const"

void ImmunityMisc(object oSkin,int bImmu,string sImmu)
{
  if (GetLocalInt(oSkin, sImmu)== 1 || bImmu == 0 ) return;

  if ( sImmu == "ImmuNSPoison" )
    AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_POISON),oSkin);
  else
  {
    AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_WEB),oSkin);
    AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_BELETITH_WEB),oSkin);
    AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_BOLT_WEB),oSkin);
    AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_NS_WEB),oSkin);
    AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_SHADOW_WEB),oSkin);

  }
  SetLocalInt(oSkin, sImmu,1);
}

void main()
{

     //Declare main variables.
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);

    int bImmuWeb    = GetHasFeat(FEAT_NS_WEBWALKER, oPC)        ? 1 : 0;
    int bImmuPois  = GetHasFeat(FEAT_NS_POISON_IMMUNE, oPC)     ? 1 : 0;

    ImmunityMisc(oSkin,bImmuWeb,"ImmuNSWeb");
    ImmunityMisc(oSkin,bImmuPois,"ImmuNSPoison");

}
