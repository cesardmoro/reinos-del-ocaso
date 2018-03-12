//::///////////////////////////////////////////////
//:: Magic Cirle Against Good
//:: NW_S0_CircGoodB
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Add basic protection from good effects to
    entering allies.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 20, 2001
//:://////////////////////////////////////////////
#include "NW_I0_SPELLS"
#include "spinc_common"
#include "prc_inc_clsfunc"
#include "x2_inc_spellhook"

void main()
{

 DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_ABJURATION);

    ActionDoCommand(SetAllAoEInts(SPELL_MAGIC_CIRCLE_AGAINST_GOOD ,OBJECT_SELF, GetSpellSaveDC(),0,GetLevelByClass(CLASS_TYPE_ANTI_PALADIN,GetAreaOfEffectCreator())/2));

    //Declare major variables
    //Get the object that is exiting the AOE
    object oTarget = GetExitingObject();
    int bValid = FALSE;
    effect eAOE;
    if(GetHasSpellEffect(SPELL_ANTIPAL_MAGIC_CIRCLE_AGAINST_GOOD, oTarget))
    {
        //Search through the valid effects on the target.
        eAOE = GetFirstEffect(oTarget);
        while (GetIsEffectValid(eAOE))
        {
            if (GetEffectCreator(eAOE) == GetAreaOfEffectCreator())
            {
                //If the effect was created by the AOE then remove it
                if(GetEffectSpellId(eAOE) == SPELL_ANTIPAL_MAGIC_CIRCLE_AGAINST_GOOD)
                {
                    RemoveEffect(oTarget, eAOE);
                }
            }
            //Get next effect on the target
            eAOE = GetNextEffect(oTarget);
        }
    }
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// delete variable showing spell's school.

}
