//::///////////////////////////////////////////////
//:: Acid Fog: Heartbeat
//:: NW_S0_AcidFogC.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    All creatures within the AoE take 2d6 acid damage
    per round and upon entering if they fail a Fort Save
    their movement is halved.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 17, 2001
//:://////////////////////////////////////////////


//:: modified by mr_bumpkin Dec 4, 2003
#include "spinc_common"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_CONJURATION);

 ActionDoCommand(SetAllAoEInts(SPELL_ACID_FOG,OBJECT_SELF, GetSpellSaveDC()));

    //Declare major variables
    int nMetaMagic = GetMetaMagicFeat();
    int nDamage = d6(2);
    effect eDam;
    effect eVis = EffectVisualEffect(VFX_IMP_ACID_S);
    object oTarget;
    float fDelay;

        //Enter Metamagic conditions
        if (CheckMetaMagic(nMetaMagic, METAMAGIC_MAXIMIZE))
        {
            nDamage = 12;//Damage is at max
        }
        if (CheckMetaMagic(nMetaMagic, METAMAGIC_EMPOWER))
        {
            nDamage = nDamage + (nDamage/2); //Damage/Healing is +50%
        }

   //--------------------------------------------------------------------------
    // GZ 2003-Oct-15
    // When the caster is no longer there, all functions calling
    // GetAreaOfEffectCreator will fail. Its better to remove the barrier then
    //--------------------------------------------------------------------------
    if (!GetIsObjectValid(GetAreaOfEffectCreator()))
    {
        DestroyObject(OBJECT_SELF);
        return;
    }

    int nPenetr = SPGetPenetrAOE(GetAreaOfEffectCreator());




     //Set the damage effect
    eDam = EffectDamage(nDamage, SPGetElementalDamageType(DAMAGE_TYPE_ACID, GetAreaOfEffectCreator()));
    //Start cycling through the AOE Object for viable targets including doors and placable objects.
    oTarget = GetFirstInPersistentObject(OBJECT_SELF);
    while(GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
        {
            int nDC = GetChangesToSaveDC(oTarget,GetAreaOfEffectCreator());
            if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, (GetSpellSaveDC() + nDC), SAVING_THROW_TYPE_ACID, GetAreaOfEffectCreator(), fDelay))
            {
                 nDamage = d6();
            }
            fDelay = GetRandomDelay(0.4, 1.2);
            //Fire cast spell at event for the affected target
            SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(), SPELL_ACID_FOG));
            //Spell resistance check
            if(!MyPRCResistSpell(GetAreaOfEffectCreator(), oTarget,nPenetr, fDelay))
            {
               //Apply damage and visuals
                DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
            }
        }
        //Get next target.
        oTarget = GetNextInPersistentObject(OBJECT_SELF);
    }


DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name
}
