//::///////////////////////////////////////////////
//:: Incendiary Cloud
//:: NW_S0_IncCloudC.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Objects within the AoE take 4d6 fire damage
    per round.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 17, 2001
//:://////////////////////////////////////////////
//:: Updated By: GeorgZ 2003-08-21: Now affects doors and placeables as well


//:: modified by mr_bumpkin Dec 4, 2003 for PRC stuff
#include "spinc_common"

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_EVOCATION);
 ActionDoCommand(SetAllAoEInts(SPELL_INCENDIARY_CLOUD,OBJECT_SELF, GetSpellSaveDC()));

    //Declare major variables
    int nMetaMagic = GetMetaMagicFeat();
    int nDamage;
    effect eDam;
    object oTarget;
    //Declare and assign personal impact visual effect.
    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_S);
    float fDelay;
    //Capture the first target object in the shape.

    //--------------------------------------------------------------------------
    // GZ 2003-Oct-15
    // When the caster is no longer there, all functions calling
    // GetAreaOfEffectCreator will fail. Its better to remove the barrier then
    //--------------------------------------------------------------------------
    object aoeCreator = GetAreaOfEffectCreator();
    if (!GetIsObjectValid(aoeCreator))
    {
        DestroyObject(OBJECT_SELF);
        return;
    }

    int CasterLvl = PRCGetCasterLevel(aoeCreator);

    int nPenetr = SPGetPenetrAOE(aoeCreator,CasterLvl);

    int EleDmg = SPGetElementalDamageType(DAMAGE_TYPE_FIRE, aoeCreator);


    oTarget = GetFirstInPersistentObject(OBJECT_SELF,OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    //Declare the spell shape, size and the location.
    while(GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, aoeCreator))
        {
            fDelay = GetRandomDelay(0.5, 2.0);
            //Make SR check, and appropriate saving throw(s).
            if(!MyPRCResistSpell(aoeCreator, oTarget,nPenetr, fDelay))
            {
                SignalEvent(oTarget, EventSpellCastAt(aoeCreator, SPELL_INCENDIARY_CLOUD));
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
                int nDC = GetChangesToSaveDC(oTarget,aoeCreator);
                //Adjust damage for Reflex Save, Evasion and Improved Evasion
                nDamage = PRCGetReflexAdjustedDamage(nDamage, oTarget, GetSpellSaveDC()+nDC,SAVING_THROW_TYPE_FIRE, aoeCreator);
                // Apply effects to the currently selected target.
                eDam = EffectDamage(nDamage, EleDmg);
                if(nDamage > 0)
                {
                    DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                    DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                }
            }
        }
        //Select the next target within the spell shape.
        oTarget = GetNextInPersistentObject(OBJECT_SELF,OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }


DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name
}
