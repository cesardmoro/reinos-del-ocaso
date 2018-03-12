#include "prc_inc_clsfunc"
#include "prc_class_const"
#include "prc_feat_const"

void main()
{

if(GetLocalInt(OBJECT_SELF, "DRUNKEN_MASTER_IS_IN_DRUNKEN_RAGE") == 1)
    {
    // PC is in Drunken Rage
    // Check for alcohol:
    if(UseAlcohol(OBJECT_SELF) == FALSE)
        {
        // PC has no drinks left, remove Drunken Rage effects for Breath of Flame:
        RemoveDrunkenRageEffects(OBJECT_SELF);
        }
    }
else
    {
    //PC is NOT in a Drunken Rage, Check for alcohol:
    if(UseAlcohol(OBJECT_SELF) == FALSE)
        {
        // PC has no alcohol in inventory or in system, exit:
        FloatingTextStringOnCreature("For Medicinal Purposes not possible", OBJECT_SELF);
        SendMessageToPC(OBJECT_SELF, "For Medicinal Purposes not possible: You don't have any alcohol in your system or in your inventory.");
        return;
        }
    }


effect eVis = EffectVisualEffect(VFX_IMP_HEALING_L);
int nHeal = d12(4) + GetLevelByClass(CLASS_TYPE_DRUNKEN_MASTER, OBJECT_SELF);
effect eHeal = EffectHeal(nHeal);
ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, OBJECT_SELF);
ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);


}
