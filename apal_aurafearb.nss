//::///////////////////////////////////////////////
//:: Aura of Fear: On Exit
//:: NW_S1_AuraFear.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    All allies within 15ft are rendered invisible.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "prc_inc_function"
#include "spinc_common"
#include "x2_inc_spellhook"

#include "prc_spell_const"

void main()
{


    //Declare major variables
    //Get the object that is exiting the AOE
    object oTarget = GetExitingObject();

    effect eAOE;
    if(GetHasSpellEffect(SPELL_ANTIPAL_AURAFEAR, oTarget))
    {
        //Search through the valid effects on the target.
        eAOE = GetFirstEffect(oTarget);
        while (GetIsEffectValid(eAOE))
        {
            if (GetEffectCreator(eAOE) == GetAreaOfEffectCreator())
            {

                    //If the effect was created by the Invisibility Sphere then remove it
                    if(GetEffectSpellId(eAOE) == SPELL_ANTIPAL_AURAFEAR)
                    {
                        RemoveEffect(oTarget, eAOE);

                    }

            }
            //Get next effect on the target
            eAOE = GetNextEffect(oTarget);
        }
    }

}
