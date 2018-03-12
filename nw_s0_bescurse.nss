//::///////////////////////////////////////////////
//:: Bestow Curse
//:: NW_S0_BesCurse.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Afflicted creature must save or suffer a -2 penalty
    to all ability scores. This is a supernatural effect.
*/
//:://////////////////////////////////////////////
//:: Created By: Bob McCabe
//:: Created On: March 6, 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk
//:: VFX Pass By: Preston W, On: June 20, 2001
//:: Update Pass By: Preston W, On: July 20, 2001


//:: modified by mr_bumpkin Dec 4, 2003
#include "spinc_common"

#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_TRANSMUTATION);
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
    object oTarget = GetSpellTargetObject();
    effect eVis = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
    effect eCurse = EffectCurse(2, 2, 2, 2, 2, 2);
    int CasterLvl = PRCGetCasterLevel(OBJECT_SELF);
    int nPenetr =   CasterLvl + SPGetPenetr();
        
    //Make sure that curse is of type supernatural not magical
    eCurse = SupernaturalEffect(eCurse);
    if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Signal spell cast at event
        SignalEvent(oTarget, EventSpellCastAt(oTarget, SPELL_BESTOW_CURSE));
         //Make SR Check
         if (!MyPRCResistSpell(OBJECT_SELF, oTarget,nPenetr))
         {
            //Make Will Save
            if (!/*Will Save*/ PRCMySavingThrow(SAVING_THROW_WILL, oTarget, (GetSpellSaveDC()+ GetChangesToSaveDC(oTarget,OBJECT_SELF))))
            {
                //Apply Effect and VFX
                SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eCurse, oTarget,0.0f,TRUE,-1,CasterLvl);
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            }
        }
    }
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name

}
