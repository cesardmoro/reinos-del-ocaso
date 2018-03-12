//::///////////////////////////////////////////////
//:: Desecrate
//:: PRC_TN_desecrate
//:://////////////////////////////////////////////
/*
    You create an aura that boosts the undead
    around you.
*/

#include "prc_feat_const"
#include "prc_spell_const"
#include "nw_i0_spells"

void main()
{

     object oPC = OBJECT_SELF;
     string nMes = "";

     if(!GetHasSpellEffect(SPELL_DES_100) )
     {    
   	effect eAOE = EffectAreaOfEffect(AOE_MOB_DES_100); //"prc_tn_des_a", "prc_tn_des_a", "prc_tn_des_b");
	effect eVis = EffectVisualEffect(VFX_TN_DES_100);
    	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAOE, OBJECT_SELF, HoursToSeconds(99));
    	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, OBJECT_SELF, HoursToSeconds(99));
     	nMes = "*Lesser Desecrate Activated*";
     }
     else     
     {
	// Removes effects
	RemoveSpellEffects(SPELL_DES_100, oPC, oPC);
	nMes = "*Lesser Desecrate Deactivated*";
     }

     FloatingTextStringOnCreature(nMes, oPC, FALSE);
}

