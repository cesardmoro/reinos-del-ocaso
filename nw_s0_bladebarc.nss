//::///////////////////////////////////////////////
//:: Blade Barrier: Heartbeat
//:: NW_S0_BladeBarC.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creates a wall 10m long and 2m thick of whirling
    blades that hack and slice anything moving into
    them.  Anything caught in the blades takes
    2d6 per caster level.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: July 20, 2001
//:://////////////////////////////////////////////


//:: modified by mr_bumpkin Dec 4, 2003
#include "spinc_common"

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_EVOCATION);

 ActionDoCommand(SetAllAoEInts(SPELL_BLADE_BARRIER,OBJECT_SELF, GetSpellSaveDC()));

    //Declare major variables
    object oTarget;
    effect eDam;
    effect eVis = EffectVisualEffect(VFX_COM_BLOOD_LRG_RED);
    object aoeCreator = GetAreaOfEffectCreator();
    int nMetaMagic = GetMetaMagicFeat();
    int CasterLvl = PRCGetCasterLevel(aoeCreator);
    int nLevel = CasterLvl;
    //Make level check
    if (nLevel > 20)
    {
        nLevel = 20;
    }

    int nPenetr = SPGetPenetrAOE(aoeCreator,CasterLvl);


    //--------------------------------------------------------------------------
    // GZ 2003-Oct-15
    // Add damage to placeables/doors now that the command support bit fields
    //--------------------------------------------------------------------------
    oTarget = GetFirstInPersistentObject(OBJECT_SELF,OBJECT_TYPE_CREATURE | OBJECT_TYPE_PLACEABLE | OBJECT_TYPE_DOOR);

    //--------------------------------------------------------------------------
    // GZ 2003-Oct-15
    // When the caster is no longer there, all functions calling
    // GetAreaOfEffectCreator will fail. Its better to remove the barrier then
    //--------------------------------------------------------------------------
    if (!GetIsObjectValid(aoeCreator))
    {
        DestroyObject(OBJECT_SELF);
        return;
    }

    while(GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, aoeCreator))
        {
            //Fire spell cast at event
            SignalEvent(oTarget, EventSpellCastAt(aoeCreator, SPELL_BLADE_BARRIER));
            //Make SR Check
            if (!MyPRCResistSpell(aoeCreator, oTarget,CasterLvl) )
            {
                int nDC = GetChangesToSaveDC(oTarget,aoeCreator);
                //Roll Damage
                int nDamage = d6(nLevel);
                //Enter Metamagic conditions
                if(CheckMetaMagic(nMetaMagic, METAMAGIC_MAXIMIZE))
                {
                    nDamage = nLevel * 6;//Damage is at max
                }
                else if (CheckMetaMagic(nMetaMagic, METAMAGIC_EMPOWER))
                {
                    nDamage = nDamage + (nDamage/2);
                }
                if(PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, (GetSpellSaveDC()+ nDC)))
                {
                    nDamage = nDamage/2;
                }
                //Set damage effect
                eDam = EffectDamage(nDamage, DAMAGE_TYPE_SLASHING);
                //Apply damage and VFX
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            }
        }
        oTarget = GetNextInPersistentObject(OBJECT_SELF,OBJECT_TYPE_CREATURE | OBJECT_TYPE_PLACEABLE | OBJECT_TYPE_DOOR);
     }

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name

}

