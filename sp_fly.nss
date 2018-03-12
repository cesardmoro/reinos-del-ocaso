/**********************************
Conjuro Volar
***********************************/
#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"
#include "Fly_inc"

void main()
{
    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

/*    if (GetPCPublicCDKey(OBJECT_SELF)!= "MLQCEL4J")
        SendMessageToPC(OBJECT_SELF, "Conjuro desactivado.");
    else
    {*/
        object oTarget = GetSpellTargetObject();
        int nCasterLevel = GetCasterLevel(OBJECT_SELF);
        int nMetaMagic = GetMetaMagicFeat();
        int nDuration = nCasterLevel;

        if (nMetaMagic == METAMAGIC_EXTEND)
            nDuration *= 2;

        if (GetIsObjectValid(oTarget))
        {
            effect eVis = EffectVisualEffect( VFX_DUR_CESSATE_POSITIVE );
            effect eSpeed = EffectMovementSpeedIncrease( 33 );
            effect eLink = EffectLinkEffects( eVis, eSpeed );
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));

            Fly_StartHovering( oTarget );
            DelayCommand(RoundsToSeconds(nDuration), Fly_StopHovering( oTarget ));
        }
/*    }*/
}
