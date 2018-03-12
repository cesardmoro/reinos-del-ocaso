//::///////////////////////////////////////////////
//:: Truestrike
//:: x0_s0_truestrike.nss
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
+20 attack bonus for 9 seconds.
CHANGE: Miss chance still applies, unlike rules.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent Knowles
//:: Created On: July 15, 2002
//:://////////////////////////////////////////////
//:: VFX Pass By:

void main()
{
    effect eAttack = EffectAttackIncrease(20);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAttack, OBJECT_SELF, 9.0);

}

