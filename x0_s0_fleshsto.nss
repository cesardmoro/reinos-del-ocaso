 //::///////////////////////////////////////////////
//:: Flesh to Stone
//:: x0_s0_fleshsto
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
//:: The target freezes in place, standing helpless.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent Knowles
//:: Created On: October 16, 2002
//:://////////////////////////////////////////////

//:: altered by mr_bumpkin Dec 4, 2003 for prc stuff
#include "prc_alterations"

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_TRANSMUTATION);
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
    object oTarget = GetSpellTargetObject();
    int nCasterLvl = PRCGetCasterLevel(OBJECT_SELF);

    if (MyPRCResistSpell(OBJECT_SELF,oTarget,nCasterLvl+SPGetPenetr()) <1)
    {
       DoPetrification(nCasterLvl, OBJECT_SELF, oTarget, GetSpellId(), (GetSpellSaveDC() + GetChangesToSaveDC(oTarget,OBJECT_SELF)));
     }

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Erasing the variable used to store the spell's spell school

}


