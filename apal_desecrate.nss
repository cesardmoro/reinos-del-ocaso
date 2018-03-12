//::///////////////////////////////////////////////
//:: Lesser Desecrate
//:: PRC_TN_DES_20
//:://////////////////////////////////////////////
/*
    You create an aura that boosts the undead
    around you.
*/

#include "prc_feat_const"
#include "prc_spell_const"
#include "prc_class_const"
#include "nw_i0_spells"

void main()
{

     object oPC = OBJECT_SELF;
     int APal = GetLevelByClass(CLASS_TYPE_ANTI_PALADIN,oPC);
     string nMes = "";

     if(!GetHasSpellEffect(SPELL_DES_20) )
     {    
   	effect eAOE = EffectAreaOfEffect(AOE_MOB_DES_20); //"prc_tn_des_a", "prc_tn_des_a", "prc_tn_des_b");
	effect eVis = EffectVisualEffect(VFX_TN_DES_20);
    	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, OBJECT_SELF, HoursToSeconds(APal));
    	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, OBJECT_SELF, HoursToSeconds(APal));
     }
}