//::///////////////////////////////////////////////
//:: Eyeblast On Hit
//:: poison_eyeblast
//:://////////////////////////////////////////////
/*
    Permanent blindness
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 10.01.2005
//:://////////////////////////////////////////////

#include "spinc_common"

void main()
{
    object oTarget = OBJECT_SELF;
    
    effect eBlindness = EffectBlindness();
    SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eBlindness, oTarget, 0.0f, FALSE);
}