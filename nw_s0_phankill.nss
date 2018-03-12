//::///////////////////////////////////////////////
//:: Phantasmal Killer
//:: NW_S0_PhantKill
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Target of the spell must make 2 saves or die.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Dec 14 , 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 22, 2001
//:: Update Pass By: Preston W, On: Aug 3, 2001

//:: modified by mr_bumpkin Dec 4, 2003 for PRC stuff
#include "spinc_common"

#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_ILLUSION);
/*
  Spellcast Hook Code
  Added 2003-06-23 by GeorgZ
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
    int nDamage = d6(3);
    int nMetaMagic = GetMetaMagicFeat();
    object oTarget = GetSpellTargetObject();
    effect eDam;
    effect eVis = EffectVisualEffect(VFX_IMP_DEATH);
    effect eVis2 = EffectVisualEffect(VFX_IMP_SONIC);
    effect eStun = EffectStunned();
    int nTimer = d4(1);
    if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_PHANTASMAL_KILLER));
        //Make an SR check
        if(!MyPRCResistSpell(OBJECT_SELF, oTarget) && !GetIsImmune(oTarget, IMMUNITY_TYPE_FEAR))
        {
            //Make a Will save
            if (!PRCMySavingThrow(SAVING_THROW_WILL,  oTarget, (GetSpellSaveDC()+ GetChangesToSaveDC(oTarget,OBJECT_SELF)), SAVING_THROW_TYPE_MIND_SPELLS))
            {
                //Make a Fort save
                if (PRCMySavingThrow(SAVING_THROW_FORT, oTarget, (GetSpellSaveDC()+ GetChangesToSaveDC(oTarget,OBJECT_SELF)),SAVING_THROW_TYPE_DEATH))
                {
                     //Check for metamagic
                     if (CheckMetaMagic(nMetaMagic, METAMAGIC_MAXIMIZE))
                     {
                        nDamage = 18;
                        nTimer = 4;
                     }
                     if (CheckMetaMagic(nMetaMagic, METAMAGIC_EMPOWER))
                     {
                        nDamage = FloatToInt( IntToFloat(nDamage) * 1.5 );
                     }
                     //Set the damage property
                     eDam = EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL);
                     //Apply the damage effect and VFX impact
                     SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
                     SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
                     SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStun, oTarget, RoundsToSeconds(nTimer));
                }
                else
                {
                     DeathlessFrenzyCheck(oTarget);
                     nDamage = GetCurrentHitPoints(oTarget)+11;
                     eDam = EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL);
                     //Apply the death effect and VFX impact
                     SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
                     //SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                }
            }
        }
    }

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the integer used to hold the spells spell school
}
