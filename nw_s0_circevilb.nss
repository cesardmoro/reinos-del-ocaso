//::///////////////////////////////////////////////
//:: Magic Cirle Against Evil
//:: NW_S0_CircEvilB
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Add basic protection from evil effects to
    entering allies.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 20, 2001
//:://////////////////////////////////////////////
#include "NW_I0_SPELLS"
#include "spinc_common"

#include "x2_inc_spellhook"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_ABJURATION);

 ActionDoCommand(SetAllAoEInts(SPELL_MAGIC_CIRCLE_AGAINST_EVIL,OBJECT_SELF, GetSpellSaveDC()));

    //Declare major variables
    //Get the object that is exiting the AOE
    object oTarget = GetExitingObject();
    int bValid = FALSE;
    effect eAOE;
    if(GetHasSpellEffect(SPELL_MAGIC_CIRCLE_AGAINST_EVIL, oTarget))
    {
        //Search through the valid effects on the target.
        eAOE = GetFirstEffect(oTarget);
         while (GetIsEffectValid(eAOE))
        {
            if (GetEffectCreator(eAOE) == GetAreaOfEffectCreator()
                && GetEffectSpellId(eAOE) == SPELL_MAGIC_CIRCLE_AGAINST_EVIL
                && GetEffectType(eAOE) != EFFECT_TYPE_AREA_OF_EFFECT
                && GetEffectCreator(eAOE) != OBJECT_SELF)
            {
                RemoveEffect(oTarget, eAOE);
            }
            //Get next effect on the target
            eAOE = GetNextEffect(oTarget);
        }
    }

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
 // delete the variable showing the spell's school
}
