//::///////////////////////////////////////////////
//:: Invisibility Sphere: On Exit
//:: NW_S0_InvSphA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    All allies within 15ft are rendered invisible.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////

#include "spinc_common"
#include "x2_inc_spellhook"
#include "prc_spell_const"

void main()
{

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

ActionDoCommand(SetAllAoEInts(SPELL_SOL_CONCECRATE,OBJECT_SELF, GetSpellSaveDC(),0,GetLevelByClass(CLASS_TYPE_SOLDIER_OF_LIGHT,GetAreaOfEffectCreator())));

    //Declare major variables
    //Get the object that is exiting the AOE
    object oTarget = GetExitingObject();

    effect eAOE;
    if(GetHasSpellEffect(SPELL_SOL_CONCECRATE, oTarget))
    {
        //Search through the valid effects on the target.
        eAOE = GetFirstEffect(oTarget);
        while (GetIsEffectValid(eAOE))
        {
            if (GetEffectCreator(eAOE) == GetAreaOfEffectCreator())
            {

                    //If the effect was created by the Invisibility Sphere then remove it
                    if(GetEffectSpellId(eAOE) == SPELL_CONCECRATE)
                    {
                        RemoveEffect(oTarget, eAOE);

                    }

            }
            //Get next effect on the target
            eAOE = GetNextEffect(oTarget);
        }
    }
    else if (MyPRCGetRacialType(oTarget)==RACIAL_TYPE_UNDEAD)
    {
        effect eVis = EffectVisualEffect(VFX_FNF_STRIKE_HOLY );
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        DestroyObject(oTarget);   	
    }


}
