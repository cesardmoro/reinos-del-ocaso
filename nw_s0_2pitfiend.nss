 //::///////////////////////////////////////////////
//:: Pit Fiend Payload
//:: NW_S0_2PitFiend
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    DEATH --- DEATH --- BO HA HA HA
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: April 11, 2002
//:://////////////////////////////////////////////

#include "spinc_common"

void main()
{
    object oTarget = OBJECT_SELF;
    int CasterLvl = PRCGetCasterLevel(OBJECT_SELF);
    effect eDrain = EffectDeath();
    effect eVis = EffectVisualEffect(VFX_IMP_DEATH);

    SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eDrain, oTarget,0.0f,TRUE,-1,CasterLvl);
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
}
