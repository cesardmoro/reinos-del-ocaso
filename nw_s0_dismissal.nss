//::///////////////////////////////////////////////
//:: Dismissal
//:: NW_S0_Dismissal.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    All summoned creatures within 30ft of caster
    make a save and SR check or be banished
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 22, 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001


//:: modified by mr_bumpkin Dec 4, 2003
#include "spinc_common"

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_ABJURATION);

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

    int CasterLvl = PRCGetCasterLevel(OBJECT_SELF);
    CasterLvl +=SPGetPenetr();

    //Declare major variables
    object oMaster;
    effect eVis = EffectVisualEffect(VFX_IMP_UNSUMMON);
    effect eImpact = EffectVisualEffect(VFX_FNF_LOS_EVIL_30);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, GetSpellTargetLocation());

    //Get the first object in the are of effect
    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
    while(GetIsObjectValid(oTarget))
    {
        //does the creature have a master.
        oMaster = GetMaster(oTarget);
        //Is that master valid and is he an enemy
        if(GetIsObjectValid(oMaster) && spellsIsTarget(oMaster,SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF ))
        {
            //Is the creature a summoned associate
            if(GetAssociate(ASSOCIATE_TYPE_SUMMONED, oMaster) == oTarget ||
               GetAssociate(ASSOCIATE_TYPE_FAMILIAR, oMaster) == oTarget ||
               GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION, oMaster) == oTarget ||
               GetTag(oTarget)=="BONDFAMILIAR")
             {
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_DISMISSAL));
                 //Make SR and will save checks
                if (!MyPRCResistSpell(OBJECT_SELF, oTarget,CasterLvl) && !PRCMySavingThrow(SAVING_THROW_WILL, oTarget, (GetSpellSaveDC()+ GetChangesToSaveDC(oTarget,OBJECT_SELF)) + 6))
                {
                     //Apply the VFX and delay the destruction of the summoned monster so
                     //that the script and VFX can play.
                     SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                     AssignCommand(oTarget, SetIsDestroyable(TRUE));
                     DestroyObject(oTarget, 0.5);
                }


            }
            if(GetRacialType(oTarget) == RACIAL_TYPE_ELEMENTAL || GetRacialType(oTarget) == RACIAL_TYPE_OUTSIDER)
             {
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_DISMISSAL));
                 //Make SR and will save checks
                if (!MyPRCResistSpell(OBJECT_SELF, oTarget,CasterLvl) && !PRCMySavingThrow(SAVING_THROW_WILL, oTarget, (GetSpellSaveDC()+ GetChangesToSaveDC(oTarget,OBJECT_SELF)) + 6))
                {
                     //Apply the VFX and delay the destruction of the summoned monster so
                     //that the script and VFX can play.
                     SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                     effect eVis = EffectVisualEffect(VFX_IMP_UNSUMMON);
                     ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis, GetLocation(oTarget));
                     AssignCommand(oTarget, SetIsDestroyable(TRUE, FALSE, FALSE));
                     DestroyObject(oTarget, 0.1);

                }


            }

        }
        //Get next creature in the shape.
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
    }


DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name
}
