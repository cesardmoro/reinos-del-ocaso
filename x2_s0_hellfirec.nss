//::///////////////////////////////////////////////
//:: Aura of Hellfire on Heartbeat
//:: NW_S1_AuraElecC.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Prolonged exposure to the aura of the creature
    causes fire damage to all within the aura.
*/

//:: altered by mr_bumpkin Dec 4, 2003 for prc stuff
#include "spinc_common"

#include "NW_I0_SPELLS"

void main()
{

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_EVOCATION);
ActionDoCommand(SetAllAoEInts(761,OBJECT_SELF, GetSpellSaveDC()));

    int nDamage;
    int nDamSave;
    effect eDam;
    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_M);
    int EleDmg = SPGetElementalDamageType(DAMAGE_TYPE_FIRE, GetAreaOfEffectCreator());

    //Get first target in spell area
    object oTarget = GetFirstInPersistentObject();
    while(GetIsObjectValid(oTarget))
    {
        if(GetIsEnemy(oTarget, GetAreaOfEffectCreator()))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(), 761));
            //Roll damage
            nDamage = d6(6);
            //Make a saving throw check
            if(PRCMySavingThrow(SAVING_THROW_FORT, oTarget, (GetSpellSaveDC() + GetChangesToSaveDC(oTarget,GetAreaOfEffectCreator())), SAVING_THROW_TYPE_FIRE))
            {
                nDamage = nDamage / 2;
            }
            //Set the damage effect
            eDam = EffectDamage(nDamage, EleDmg);
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget,0.0f,FALSE);
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget,0.0f,FALSE);
        }
        //Get next target in spell area
        oTarget = GetNextInPersistentObject();
    }


DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Erasing the variable used to store the spell's spell school
}
