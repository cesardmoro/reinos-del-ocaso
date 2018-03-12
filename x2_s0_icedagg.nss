//::///////////////////////////////////////////////
//:: Ice Dagger
//:: X2_S0_IceDagg
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
// You create a dagger shapped piece of ice that
// flies toward the target and deals 1d4 points of
// cold damage per level (maximum od 5d4)
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Nov 25 , 2002
//:://////////////////////////////////////////////
//:: Last Updated By: Andrew Nobbs, 02/06/2003

//:: altered by mr_bumpkin Dec 4, 2003 for prc stuff
#include "spinc_common"

#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_CONJURATION);
/*
  Spellcast Hook Code
  Added 2003-07-07 by Georg Zoeller
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
    object oTarget = GetSpellTargetObject();
    int CasterLvl = PRCGetCasterLevel(OBJECT_SELF);

    int nCasterLvl = CasterLvl;
    int nMetaMagic = GetMetaMagicFeat();
    int nDamage;
    float fDelay;
    effect eVis = EffectVisualEffect(VFX_IMP_FROST_S);
    effect eDam;
    //Get the spell target location as opposed to the spell target.
    location lTarget = GetSpellTargetLocation();
    //Limit Caster level for the purposes of damage
    if (nCasterLvl > 5)
    {
        nCasterLvl = 5;
    }

    CasterLvl +=SPGetPenetr();

    if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
        //Get the distance between the explosion and the target to calculate delay
        fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
        if (!MyPRCResistSpell(OBJECT_SELF, oTarget,CasterLvl, fDelay))
        {
            //Roll damage for each target
            nDamage = d4(nCasterLvl);
            //Resolve metamagic
            if (CheckMetaMagic(nMetaMagic, METAMAGIC_MAXIMIZE))
            {
                nDamage = 4 * nCasterLvl;
            }
            else if (CheckMetaMagic(nMetaMagic, METAMAGIC_EMPOWER))
            {
                nDamage = nDamage + nDamage / 2;
            }
            //Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
            nDamage = PRCGetReflexAdjustedDamage(nDamage, oTarget, (GetSpellSaveDC()  + GetChangesToSaveDC(oTarget,OBJECT_SELF)), SAVING_THROW_TYPE_COLD);
            //Set the damage effect
            eDam = EffectDamage(nDamage, SPGetElementalDamageType(DAMAGE_TYPE_COLD));
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


DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Erasing the variable used to store the spell's spell school
}

