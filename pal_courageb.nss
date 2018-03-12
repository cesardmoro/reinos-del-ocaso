/********************************************************************
Aura de Corage del Paladin

+4 a Salvaciones contra miedo
********************************************************************/

#include "RDO_SpInc"

void main()
{
    object oTarget = GetExitingObject();
    effect eAOE = GetFirstEffect(oTarget);
    while (GetIsEffectValid(eAOE))
    {
        if (GetEffectCreator(eAOE) == RDO_GetCreatorByTag("EffectCreator_AuraPaladin"))
            RemoveEffect(oTarget, eAOE);
        eAOE = GetNextEffect(oTarget);
    }
}
