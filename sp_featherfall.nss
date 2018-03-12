/*********************************
Feather Fall
***********************************/

#include "Jump_inc"
#include "x2_inc_spellhook"

void stopFeatherFall( object oCreature )
{
    if (GetIsObjectValid(oCreature))
    {
        DeleteLocalInt(oCreature, Jump_HAS_FEATHER_FALL);
    }
}

void main()
{
    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    object oTarget = GetSpellTargetObject();
    int nCasterLevel = GetCasterLevel(OBJECT_SELF);

    if (GetIsObjectValid(oTarget))
    {
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE), oTarget);
        SetLocalInt(oTarget, Jump_HAS_FEATHER_FALL, TRUE);
        DelayCommand(RoundsToSeconds(nCasterLevel), stopFeatherFall(oTarget));
    }
}
