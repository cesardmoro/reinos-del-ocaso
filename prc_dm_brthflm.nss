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
        FloatingTextStringOnCreature("Breath of Flame not possible", OBJECT_SELF);
        SendMessageToPC(OBJECT_SELF, "Breath of Flame not possible: You don't have any alcohol in your system or in your inventory.");
        return;
        }
    }

// Breath of Flame:
object oTarget;

int nDamage = d12(3);
int nPersonalDamage;
int nSaveDC = 18;
//int nType = GetSpellId();
float fDelay;

effect eVis, eBreath;

eVis = EffectVisualEffect(494);
ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetSpellTargetLocation());

//Get first target in spell area
oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 20.0, GetSpellTargetLocation(), TRUE,  OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR  | OBJECT_TYPE_PLACEABLE);

while(GetIsObjectValid(oTarget))
    {
        nPersonalDamage = nDamage;
        if(oTarget != OBJECT_SELF && !GetIsReactionTypeFriendly(oTarget))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
            //Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
            //Determine effect delay
            fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20;
            if(PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, nSaveDC, SAVING_THROW_TYPE_FIRE))
            {
                nPersonalDamage  = nPersonalDamage/2;
                if(GetHasFeat(FEAT_EVASION, oTarget) || GetHasFeat(FEAT_IMPROVED_EVASION, oTarget))
                {
                    nPersonalDamage = 0;
                }
            }
            else if(GetHasFeat(FEAT_IMPROVED_EVASION, oTarget))
            {
                nPersonalDamage = nPersonalDamage/2;
            }
            if (nPersonalDamage > 0)
            {
                //Set Damage and VFX
                eBreath = EffectDamage(nPersonalDamage, DAMAGE_TYPE_FIRE);
                eVis = EffectVisualEffect(VFX_IMP_FLAME_M);
                //Apply the VFX impact and effects
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eBreath, oTarget));
             }
        }
        //Get next target in spell area
        oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 20.0, GetSpellTargetLocation(), TRUE,  OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR  | OBJECT_TYPE_PLACEABLE);
    }

}
