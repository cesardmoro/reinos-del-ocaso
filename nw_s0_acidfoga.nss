//::///////////////////////////////////////////////
//:: Acid Fog: On Enter
//:: NW_S0_AcidFogA.nss
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
//:://///////////////////////////////////////////


//:: modified by mr_bumpkin Dec 4, 2003
#include "spinc_common"

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_CONJURATION);

 ActionDoCommand(SetAllAoEInts(SPELL_ACID_FOG,OBJECT_SELF, GetSpellSaveDC()));

    //Declare major variables
    int nMetaMagic = GetMetaMagicFeat();
    int nDamage;
    effect eDam;
    effect eVis = EffectVisualEffect(VFX_IMP_ACID_S);
    effect eSlow = EffectMovementSpeedDecrease(50);
    object oTarget = GetEnteringObject();
    float fDelay = GetRandomDelay(1.0, 2.2);
    int nPenetr = SPGetPenetrAOE(GetAreaOfEffectCreator());

    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
    {
        //Fire cast spell at event for the target
        SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(), SPELL_ACID_FOG));
        //Spell resistance check
        if(!MyPRCResistSpell(GetAreaOfEffectCreator(), oTarget,nPenetr, fDelay))
        {
            //Roll Damage
            //Enter Metamagic conditions
            nDamage = d6(4);
            if (CheckMetaMagic(nMetaMagic, METAMAGIC_MAXIMIZE))
            {
                nDamage = 12;//Damage is at max
            }
            else if (CheckMetaMagic(nMetaMagic, METAMAGIC_EMPOWER))
            {
                nDamage = nDamage + (nDamage/2); //Damage/Healing is +50%
            }
            //Make a Fortitude Save to avoid the effects of the movement hit.
            if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, (GetSpellSaveDC()+ GetChangesToSaveDC(oTarget,GetAreaOfEffectCreator())), SAVING_THROW_TYPE_ACID, GetAreaOfEffectCreator(), fDelay))
            {
                //slowing effect
                SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eSlow, oTarget,0.0f,FALSE);
                // * BK: Removed this because it reduced damage, didn't make sense nDamage = d6();
            }

            //Set Damage Effect with the modified damage
            eDam = EffectDamage(nDamage, SPGetElementalDamageType(DAMAGE_TYPE_ACID, GetAreaOfEffectCreator()));
            //Apply damage and visuals
            DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
            DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
        }
    }

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name
}
