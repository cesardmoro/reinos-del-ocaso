//::///////////////////////////////////////////////
//:: Weird
//:: NW_S0_Weird
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    All enemies in LOS of the spell must make 2 saves or die.
    Even IF the fortitude save is succesful, they will still take
    3d6 damage.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: DEc 14 , 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 10, 2001
//:: VFX Pass By: Preston W, On: June 27, 2001

//:: modified by mr_bumpkin  Dec 4, 2003
#include "spinc_common"

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_ILLUSION);
/*
  Spellcast Hook Code
  Added 2003-06-20 by Georg
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Declare major variables
    object oTarget;
    effect eDam;
    effect eVis = EffectVisualEffect(VFX_IMP_SONIC);
    effect eVis2 = EffectVisualEffect(VFX_IMP_DEATH);
    effect eWeird = EffectVisualEffect(VFX_FNF_WEIRD);
    effect eAbyss = EffectVisualEffect(VFX_DUR_ANTI_LIGHT_10);
    int CasterLvl = PRCGetCasterLevel(OBJECT_SELF);


    

    int nCasterLvl =CasterLvl;
    int nMetaMagic = GetMetaMagicFeat();
    int nDamage;
    float fDelay;
    
    CasterLvl +=SPGetPenetr();

    //Apply the FNF VFX impact
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eWeird, GetSpellTargetLocation());
    //Get the first target in the spell area
    oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetSpellTargetLocation(), TRUE);
    while (GetIsObjectValid(oTarget))
    {
        //Make a faction check
        if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF))
        {
               fDelay = GetRandomDelay(3.0, 4.0);
               //Fire cast spell at event for the specified target
               SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_WEIRD));
               //Make an SR Check
               if(!MyPRCResistSpell(OBJECT_SELF, oTarget,CasterLvl, fDelay))
               {
                    if(GetHitDice(oTarget) >= 4)
                    {
                        int nDC = GetChangesToSaveDC(oTarget,OBJECT_SELF);
                        //Make a Will save against mind-affecting
                        if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, (GetSpellSaveDC() + nDC), SAVING_THROW_TYPE_MIND_SPELLS, OBJECT_SELF, fDelay))
                        {
                            //Make a fortitude save against death
                            if(PRCMySavingThrow(SAVING_THROW_FORT, oTarget, (GetSpellSaveDC() + nDC), SAVING_THROW_TYPE_DEATH, OBJECT_SELF, fDelay))
                            {
                                // * I made my saving throw but I still have to take the 3d6 damage

                                //Roll damage
                                nDamage = d6(3);
                                //Make metamagic check
                                if (CheckMetaMagic(nMetaMagic, METAMAGIC_MAXIMIZE))
                                {
                                    nDamage = 18;
                                }
                                if (CheckMetaMagic(nMetaMagic, METAMAGIC_EMPOWER))
                                {
                                    nDamage = FloatToInt( IntToFloat(nDamage) * 1.5 );
                                }
                                //Set damage effect
                                eDam = EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL);
                                //Apply VFX Impact and damage effect
                                DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                                DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                            }
                            else
                            {
                                // * I failed BOTH saving throws. Now I die.
                                
                                DeathlessFrenzyCheck(oTarget);

                                //Apply VFX impact and death effect
                                //DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget));
                                effect eDeath = EffectDeath();
                                DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget));
                            }
                        } // Will save
                    }
                    else
                    {
                        // * I have less than 4HD, I die.
                        
                        DeathlessFrenzyCheck(oTarget);

                        //Apply VFX impact and death effect
                        //DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget));
                        effect eDeath = EffectDeath();
                        DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget));
                    }
               }
        }
        //Get next target in spell area
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetSpellTargetLocation(), TRUE);
    }
    
 


DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the integer used to hold the spells spell school
}
