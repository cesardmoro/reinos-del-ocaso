//::///////////////////////////////////////////////
//:: Creeping Doom: On Enter
//:: NW_S0_AcidFogA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creature caught in the swarm take an initial
    damage of 1d20, but there after they take
    1d4 per swarm counter on the AOE.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 17, 2001
//:://////////////////////////////////////////////


//:: modified by mr_bumpkin Dec 4, 2003
#include "spinc_common"

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_CONJURATION);

 ActionDoCommand(SetAllAoEInts(SPELL_CREEPING_DOOM ,OBJECT_SELF, GetSpellSaveDC()));

    //Declare major variables
    int nDamage;
    effect eDam;
    effect eVis = EffectVisualEffect(VFX_COM_BLOOD_REG_RED);
    object oTarget = GetEnteringObject();
    effect eSpeed = EffectMovementSpeedDecrease(50);
    effect eVis2 = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eLink = EffectLinkEffects(eSpeed, eVis2);
    float fDelay;
    
   object aoeCreator = GetAreaOfEffectCreator();
   int CasterLvl = PRCGetCasterLevel(aoeCreator);

    int nPenetr = SPGetPenetrAOE(aoeCreator,CasterLvl);
 
    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, aoeCreator))
    {
        //Fire cast spell at event for the target
        SignalEvent(oTarget, EventSpellCastAt(aoeCreator, SPELL_CREEPING_DOOM));
        fDelay = GetRandomDelay(1.0, 1.8);
        //Spell resistance check
        if(!MyPRCResistSpell(aoeCreator, oTarget,nPenetr, fDelay))
        {
            //Roll Damage
            nDamage = d20();
            //Set Damage Effect with the modified damage
            eDam = EffectDamage(nDamage, DAMAGE_TYPE_PIERCING);
            //Apply damage and visuals
            SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eSpeed, oTarget,0.0f,FALSE);
            DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
            DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
        }
    }


DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name
}
