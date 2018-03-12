//::///////////////////////////////////////////////
//:: Earthquake
//:: X0_S0_Earthquake
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
// Ground shakes. 1d6 damage, max 10d6
// LOCKINDAL: Changed to alternate: DC 15 or knock down, 25% creatures must make DC 20 or die.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: July 22 2002
//:://////////////////////////////////////////////
//:: Last Updated By: Andrew Nobbs May 01, 2003
//:: Altered By: Lockindal

//:: altered by mr_bumpkin Dec 4, 2003 for prc stuff
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
    int nMetaMagic = GetMetaMagicFeat();
    int nRandom = 0;
    int nSpectacularDeath = TRUE;
    int nDisplayFeedback = TRUE;
    float fDelay;
    float nSize =  RADIUS_SIZE_COLOSSAL;
    effect eExplode = EffectVisualEffect(VFX_COM_CHUNK_STONE_MEDIUM);
    effect eExplode2 = EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_NATURE);
    effect eExplode3 = EffectVisualEffect(VFX_IMP_DUST_EXPLOSION);
    effect eVis = EffectVisualEffect(VFX_IMP_HEAD_NATURE);
    effect eShake = EffectVisualEffect(356);
    effect eKnockdown = EffectKnockdown();
    effect eDeath = EffectDeath(nSpectacularDeath, nDisplayFeedback);

    float fDuration = 18.0;
    //Get the spell target location as opposed to the spell target.
    location lTarget = GetSpellTargetLocation();
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShake, OBJECT_SELF, RoundsToSeconds(6),TRUE,-1,CasterLvl);

    //Apply epicenter explosion on caster
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, GetLocation(OBJECT_SELF));
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode2, GetLocation(OBJECT_SELF));
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode3, GetLocation(OBJECT_SELF));


    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, nSize, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget))
    {
        nRandom = d4();   // if they roll a 3 on this, they must make DC 20 or die.

        //knockdown effect applies to ALL creatures; DC 15 or knockdown.
        if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
        {
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_EARTHQUAKE));
           if(oTarget != oCaster)
           {
                if(ReflexSave(oTarget, 15, SAVING_THROW_REFLEX, OBJECT_SELF) == 0)
                {
                 SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnockdown, oTarget, fDuration,TRUE,-1,CasterLvl);
                }
           }
        }

        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) && nRandom == 3)
        {
            //Fire cast spell at event for the specified target
            //Get the distance between the explosion and the target to calculate delay
                fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
                //Reflex DC 20 or die.
                if (oTarget != oCaster)
                {
                  if(ReflexSave(oTarget, 20, SAVING_THROW_REFLEX, OBJECT_SELF) == 0)
                  {
                     SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDeath, oTarget, fDuration,TRUE,-1,CasterLvl);
                  }
                }
        }
       //Select the next target within the spell shape.
       oTarget = MyNextObjectInShape(SHAPE_SPHERE, nSize, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Erasing the variable used to store the spell's spell school
}
