//::///////////////////////////////////////////////
//:: Ice Storm
//:: NW_S0_IceStorm
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Everyone in the area takes 3d6 Bludgeoning
    and 2d6 Cold damage.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Sept 12, 2001
//:://////////////////////////////////////////////

//:: modified by mr_bumpkin Dec 4, 2003 for PRC stuff
#include "spinc_common"

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_EVOCATION);
/*
  Spellcast Hook Code
  Added 2003-06-20 by Georg
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Declare major variables
    object oCaster = OBJECT_SELF;
    int CasterLvl = PRCGetCasterLevel(OBJECT_SELF);


    int EleDmg = SPGetElementalDamageType(DAMAGE_TYPE_COLD);

    int nCasterLvl = CasterLvl;
    int nMetaMagic = GetMetaMagicFeat();
    int nDamage, nDamage2, nDamage3;
    int nVariable = nCasterLvl/3;
    float fDelay;
    effect eExplode = EffectVisualEffect(VFX_FNF_ICESTORM); //USE THE ICESTORM FNF
    effect eVis = EffectVisualEffect(VFX_IMP_FROST_S);
    effect eDam,eDam2, eDam3;
    //Get the spell target location as opposed to the spell target.
    location lTarget = GetSpellTargetLocation();
    CasterLvl +=SPGetPenetr();

    //Apply the ice storm VFX at the location captured above.
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);
    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
        {
            fDelay = GetRandomDelay(0.75, 2.25);
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_ICE_STORM));
            if (!MyPRCResistSpell(OBJECT_SELF, oTarget,CasterLvl, fDelay))
            {
                //Roll damage for each target
                nDamage = d6(3);
                nDamage2 = d6(2);
                nDamage3 = d6(nVariable);
                //Resolve metamagic
                if (CheckMetaMagic(nMetaMagic, METAMAGIC_MAXIMIZE))
                {
                    nDamage = 18;
                    nDamage2 = 12;
                    nDamage3 = 6 * nVariable;
                }
                else if (CheckMetaMagic(nMetaMagic, METAMAGIC_EMPOWER))
                {
                   nDamage = nDamage + (nDamage / 2);
                   nDamage2 = nDamage2 + (nDamage2 / 2);
                   nDamage3 = nDamage3 + (nDamage3 / 2);
                }
                nDamage2 = nDamage2;
                //Set the damage effect
                eDam = EffectDamage(nDamage, DAMAGE_TYPE_BLUDGEONING);
                eDam2 = EffectDamage(nDamage2, EleDmg);
                // Apply effects to the currently selected target.
                DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam2, oTarget));
                //This visual effect is applied to the target object not the location as above.  This visual effect
                //represents the impact that erupts on the target not on the ground.
                DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
             }
        }
       //Select the next target within the spell shape.
       oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }



DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name
}

