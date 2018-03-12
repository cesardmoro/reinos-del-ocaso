//::///////////////////////////////////////////////
//:: Call Lightning
//:: NW_S0_CallLghtn.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This spells smites an area around the caster
    with bolts of lightning which strike all enemies.
    Bolts do 1d10 per level up 10d10
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 22, 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001


//:: modified by mr_bumpkin Dec 4, 2003
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

    if (GetIsAreaInterior(GetArea(oCaster)))
    {
        FloatingTextStringOnCreature("No puedes usar este conjuro en un area que no este al aire libre.", oCaster);
    }
    else
    {
        int CasterLvl = PRCGetCasterLevel(OBJECT_SELF);

        int nCasterLvl = CasterLvl;
        int nMetaMagic = GetMetaMagicFeat();
        int nDamage;
        float fDelay;
        effect eVis = EffectVisualEffect(VFX_IMP_LIGHTNING_M);
        effect eDam;
        //Get the spell target location as opposed to the spell target.
        location lTarget = GetSpellTargetLocation();
        //Limit Caster level for the purposes of damage
        if (nCasterLvl > 10)
        {
            nCasterLvl = 10;
        }

        CasterLvl +=SPGetPenetr();
        int EleDmg = SPGetElementalDamageType(DAMAGE_TYPE_ELECTRICAL);

        //Declare the spell shape, size and the location.  Capture the first target object in the shape.
        object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
        //Cycle through the targets within the spell shape until an invalid object is captured.
        while (GetIsObjectValid(oTarget))
        {
            if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF))
            {
               //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_CALL_LIGHTNING));
                //Get the distance between the explosion and the target to calculate delay
                fDelay = GetRandomDelay(0.4, 1.75);
                if (!MyPRCResistSpell(OBJECT_SELF, oTarget,CasterLvl, fDelay))
                {
                    //Roll damage for each target
                    nDamage = d6(nCasterLvl);
                    //Resolve metamagic
                    if (CheckMetaMagic(nMetaMagic, METAMAGIC_MAXIMIZE))
                    {
                        nDamage = 6 * nCasterLvl;
                    }
                    else if (CheckMetaMagic(nMetaMagic, METAMAGIC_EMPOWER))
                    {
                       nDamage = nDamage + nDamage / 2;
                    }
                    //Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
                    nDamage = PRCGetReflexAdjustedDamage(nDamage, oTarget, (GetSpellSaveDC()+ GetChangesToSaveDC(oTarget,OBJECT_SELF)), SAVING_THROW_TYPE_ELECTRICITY);
                    //Set the damage effect
                    eDam = EffectDamage(nDamage, EleDmg);
                    if(nDamage > 0)
                    {
                        // Apply effects to the currently selected target.
                        DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                        //This visual effect is applied to the target object not the location as above.  This visual effect
                        //represents the flame that erupts on the target not on the ground.
                        DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                    }
                 }
            }
           //Select the next target within the spell shape.
           oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
        }
    }

    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    // Getting rid of the local integer storing the spellschool name

}
