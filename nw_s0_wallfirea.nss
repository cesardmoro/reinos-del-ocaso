//::///////////////////////////////////////////////
//:: Wall of Fire: On Enter
//:: NW_S0_WallFireA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Person within the AoE take 4d6 fire damage
    per round.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 17, 2001
//:://////////////////////////////////////////////

//:: modified by mr_bumpkin  Dec 4, 2003
#include "spinc_common"

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_EVOCATION);

 ActionDoCommand(SetAllAoEInts(SPELL_WALL_OF_FIRE,OBJECT_SELF, GetSpellSaveDC()));

    //Declare major variables
    int nMetaMagic = GetMetaMagicFeat();
    int nDamage;
    effect eDam;
    object oTarget;
    //Declare and assign personal impact visual effect.
    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_M);
    int nPenetr = SPGetPenetrAOE(GetAreaOfEffectCreator());

    //Capture the first target object in the shape.
    oTarget = GetEnteringObject();
    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_WALL_OF_FIRE));
        //Make SR check, and appropriate saving throw(s).
        if(!MyPRCResistSpell(GetAreaOfEffectCreator(), oTarget,nPenetr))
        {
            //Roll damage.
            nDamage = d6(4);
            //Enter Metamagic conditions
                if (CheckMetaMagic(nMetaMagic, METAMAGIC_MAXIMIZE))
                {
                   nDamage = 24;//Damage is at max
                }
                if (CheckMetaMagic(nMetaMagic, METAMAGIC_EMPOWER))
                {
                     nDamage = nDamage + (nDamage/2); //Damage/Healing is +50%
                }
            nDamage = PRCGetReflexAdjustedDamage(nDamage, oTarget, (GetSpellSaveDC() + GetChangesToSaveDC(oTarget,GetAreaOfEffectCreator())), SAVING_THROW_TYPE_FIRE);
            if(nDamage > 0)
            {
                // Apply effects to the currently selected target.
                eDam = EffectDamage(nDamage, SPGetElementalDamageType(DAMAGE_TYPE_FIRE, GetAreaOfEffectCreator()));
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            }
        }
    }

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the integer used to hold the spells spell school
}
