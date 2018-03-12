//::///////////////////////////////////////////////
//:: Spike Growth: On Heartbeat
//:: x0_s0_spikegroHB.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    All creatures within the AoE take 1d4 acid damage
    per round
*/
//:://////////////////////////////////////////////
//:: Created By: Brent Knowles
//:: Created On: September 6, 2002
//:://////////////////////////////////////////////

//:: altered by mr_bumpkin Dec 4, 2003 for prc stuff
#include "spinc_common"

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_TRANSMUTATION);
ActionDoCommand(SetAllAoEInts(SPELL_SPIKE_GROWTH,OBJECT_SELF, GetSpellSaveDC()));

    int nPenetr = SPGetPenetrAOE(GetAreaOfEffectCreator());


    object oTarget;
    //Start cycling through the AOE Object for viable targets including doors and placable objects.
    oTarget = GetFirstInPersistentObject(OBJECT_SELF);
    while(GetIsObjectValid(oTarget))
    {
     DoSpikeGrowthEffect(oTarget,nPenetr);
        //Get next target.
    oTarget = GetNextInPersistentObject(OBJECT_SELF);
    }


DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Erasing the variable used to store the spell's spell school
}
