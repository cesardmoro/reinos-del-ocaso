#include "X0_I0_SPELLS"
#include "prc_feat_const"
#include "x2_inc_spellhook"
#include "spinc_common"

const int SPELL_UR_BLACKLIGHT = 2091;

void main()
{

    SPSetSchool(SPELL_SCHOOL_EVOCATION);
    ActionDoCommand(SetAllAoEInts(SPELL_BLACKLIGHT ,OBJECT_SELF, GetSpellSaveDC()));

    object oTarget = GetExitingObject();
    object oCreator = GetAreaOfEffectCreator();

    //Search through the valid effects on the target.
    effect eAOE = GetFirstEffect(oTarget);
    while (GetIsEffectValid(eAOE))
    {
        int nID = GetEffectSpellId(eAOE);

        if( nID== SPELL_UR_BLACKLIGHT)
        {
           if (GetEffectCreator(eAOE) == oCreator)
              RemoveEffect(oTarget, eAOE);

        }

        //Get next effect on the target
        eAOE = GetNextEffect(oTarget);
    }
    
    SPSetSchool();

}
