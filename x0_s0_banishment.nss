//::///////////////////////////////////////////////
//:: Banishment
//:: x0_s0_banishment.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    All summoned creatures within 30ft of caster
    make a save and SR check or be banished
    + As well any Outsiders being must make a
    save and SR check or be banished (up to
    2 HD creatures / level can be banished)
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 22, 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001

//:: altered by mr_bumpkin Dec 4, 2003 for prc stuff
#include "prc_alterations"

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


    //Declare major variables
    object oMaster;
    effect eVis = EffectVisualEffect(VFX_IMP_UNSUMMON);
    effect eImpact = EffectVisualEffect(VFX_FNF_LOS_EVIL_30);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, GetSpellTargetLocation());
    int nSpellDC;
    //Get the first object in the are of effect
    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));

    // * the pool is the number of hit dice of creatures that can be banished
    int CasterLvl = PRCGetCasterLevel(OBJECT_SELF);

    int nPool = 2 * CasterLvl;
    CasterLvl +=SPGetPenetr();

                   
    while(GetIsObjectValid(oTarget))
    {
        //does the creature have a master.
        oMaster = GetMaster(oTarget);
        if (oMaster == OBJECT_INVALID)
        {
            oMaster = OBJECT_SELF;  // TO prevent problems with invalid objects
                                    // passed into GetAssociate
        }

        // * BK: Removed the master check, only applys to Dismissal not banishment
        //Is that master valid and is he an enemy
       // if(GetIsObjectValid(oMaster) && GetIsEnemy(oMaster))
        {
            // * Is the creature a summoned associate
            // * or is the creature an outsider
            // * and is there enough points in the pool
            if(
               (GetAssociate(ASSOCIATE_TYPE_SUMMONED, oMaster) == oTarget ||
               GetAssociate(ASSOCIATE_TYPE_FAMILIAR, oMaster) == oTarget ||
               GetTag(OBJECT_SELF)=="BONDFAMILIAR" ||
               GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION, oMaster) == oTarget ) ||
               (MyPRCGetRacialType((oTarget)) == RACIAL_TYPE_OUTSIDER)  &&
               (nPool > 0)
               )
            {
                // * March 2003. Added a check so that 'friendlies' will not be
                // * unsummoned.
                if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
                {
                    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 430));
                    //Determine correct save

                    // * Must be enough points in the pool to destroy target
                    if (nPool >= GetHitDice(oTarget))
                    {
                          nSpellDC = (GetSpellSaveDC() + GetChangesToSaveDC(oTarget,OBJECT_SELF)) ;// + 6;

                     // * Make SR and will save checks
                     if (!MyPRCResistSpell(OBJECT_SELF, oTarget,CasterLvl) && !PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nSpellDC))
                     {
                         //Apply the VFX and delay the destruction of the summoned monster so
                         //that the script and VFX can play.

                         nPool = nPool - GetHitDice(oTarget);
                         ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetLocation(oTarget));
                         if (CanCreatureBeDestroyed(oTarget) == TRUE)
                         {
                             //bugfix: Simply destroying the object won't fire it's OnDeath script.
                             //Which is bad when you have plot-specific things being done in that
                             //OnDeath script... so lets kill it.
                             effect eKill = EffectDamage(GetCurrentHitPoints(oTarget));
                             //just to be extra-sure... :)
                             effect eDeath = EffectDeath(FALSE, FALSE);
                             DelayCommand(0.25, ApplyEffectToObject(DURATION_TYPE_INSTANT, eKill, oTarget));
                             DelayCommand(0.25, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget));
                         }
                     }
                    }
                } // rep check
            }
        }
        //Get next creature in the shape.
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
    }

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Erasing the variable used to store the spell's spell school

}
