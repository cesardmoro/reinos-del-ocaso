//::///////////////////////////////////////////////
//:: Vine Mine, Entangle
//:: X2_S0_VineMEnt
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
  Area of effect spell that places the entangled
  effect on enemies if they fail a saving throw
  each round.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Nov 25, 2002
//:://////////////////////////////////////////////

//:: altered by mr_bumpkin Dec 4, 2003 for prc stuff
#include "prc_alterations"

#include "nw_i0_spells"
#include "x0_i0_spells"
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


    //Declare major variables including Area of Effect Object
    effect eAOE = EffectAreaOfEffect(AOE_PER_ENTANGLE, "", "X2_S0_VineMEntC", "X2_S0_VineMEntB");
    location lTarget = GetSpellTargetLocation();
    //--------------------------------------------------------------------------
    // 1 turn per caster is not fun, so we do 1 round per casterlevel
    //--------------------------------------------------------------------------
    int nDuration = PRCGetCasterLevel(OBJECT_SELF);
    //Make sure duration does no equal 0
    if (nDuration < 1)
    {
        nDuration = 1;
    }
    //Create an instance of the AOE Object using the Apply Effect function
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));


DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Erasing the variable used to store the spell's spell school

}

