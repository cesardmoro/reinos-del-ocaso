//::///////////////////////////////////////////////
//:: Visage of Terror
//:: prc_rava_visage
//:://////////////////////////////////////////////
/*
    Target of the spell must make 2 saves or die.
*/

#include "NW_I0_SPELLS"
#include "prc_class_const"
void main()
{
    //Declare major variables
    int nDamage = d6(3);
    int nDC = GetLevelByClass(CLASS_TYPE_RAVAGER,OBJECT_SELF) + 14;
    object oTarget = GetSpellTargetObject();
    effect eDam;
    effect eVis = EffectVisualEffect(VFX_IMP_DEATH);
    effect eVis2 = EffectVisualEffect(VFX_IMP_SONIC);

            //Make a Will save
           if (!PRCMySavingThrow(SAVING_THROW_WILL,  oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
            {
                //Make a Fort save
                if (PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC,SAVING_THROW_TYPE_DEATH))
               {
                     //Set the damage property
                     eDam = EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL);
                     //Apply the damage effect and VFX impact
                     ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
                     ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
                }
                else
                {
                     DeathlessFrenzyCheck(oTarget);

                     //Apply the death effect and VFX impact
                     ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oTarget);

                }
           }


}
