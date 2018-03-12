//::///////////////////////////////////////////////
//:: Desecrate
//:: prc_tn_des_b
//:://////////////////////////////////////////////
/*
    You create an aura that boosts the undead
    around you.
*/

#include "prc_spell_const"
#include "nw_i0_spells"
#include "prc_inc_clsfunc"
#include "prc_spell_const"

void main()
{
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_EVOCATION);

    ActionDoCommand(SetAllAoEInts(SPELL_ANTIPAL_DESECRATE ,OBJECT_SELF, GetSpellSaveDC(),0,GetLevelByClass(CLASS_TYPE_ANTI_PALADIN,GetAreaOfEffectCreator())/2));

        
    effect eDam = EffectDamageIncrease(DAMAGE_BONUS_1, DAMAGE_TYPE_NEGATIVE);
    effect eAttack = EffectAttackIncrease(1);
    effect eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, 1);
    
    effect eVis2 = EffectVisualEffect(VFX_IMP_HOLY_AID);
    effect eLink = EffectLinkEffects(eDam, eAttack);
    eLink = EffectLinkEffects(eLink, eSave);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
   
   
   object oTarget = GetFirstInPersistentObject(OBJECT_SELF,OBJECT_TYPE_CREATURE);
    //Declare the spell shape, size and the location.
    while(GetIsObjectValid(oTarget))
    {
    	//SendMessageToPC(GetFirstPC(), "Target: " + GetName(oTarget));
       if(!GetHasSpellEffect(SPELL_ANTIPAL_DESECRATE, oTarget))
       {
         int racialType = MyPRCGetRacialType(oTarget);
    
         if(MyPRCGetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
         {
            int nHP = GetHitDice(oTarget);
            effect eHP = EffectTemporaryHitpoints(nHP);           
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(eHP), oTarget);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
           
         }
         else
           ApplyEffectToObject(DURATION_TYPE_PERMANENT,  eDur, oTarget);
         
      }
          //Select the next target within the spell shape.
        oTarget = GetNextInPersistentObject(OBJECT_SELF,OBJECT_TYPE_CREATURE);
    }

    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");

}