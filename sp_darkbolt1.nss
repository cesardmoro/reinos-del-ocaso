#include "spinc_common"

void DarkBolt(object oTarget,int nMissiles, int nDC , int nMetaMagic)
{
   if (GetIsDead(oTarget)) return;

   nMissiles--;
   effect eMissile = EffectVisualEffect(VFX_BEAM_BLACK);
   effect eVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
   effect eDazed=EffectDazed();
   effect eVis2 = EffectVisualEffect(VFX_IMP_DAZED_S);
   //effect eBolt = EffectBeam(VFX_BEAM_BLACK, OBJECT_SELF, BODY_NODE_HAND);
    effect eBolt = EffectVisualEffect(VFX_BEAM_BLACK);

   float fDist = GetDistanceBetween(OBJECT_SELF, oTarget);
   float fDelay = fDist/(3.0 * log(fDist) + 2.0);
   float fDelay2, fTime;

   //Make SR Check
   if (!MyPRCResistSpell(OBJECT_SELF, oTarget))
   {
      //Roll damage
      int nDam = d8(2);
      //Enter Metamagic conditions
       if (CheckMetaMagic(nMetaMagic, METAMAGIC_MAXIMIZE))
       {
          nDam = 16;//Damage is at max
       }
       if (CheckMetaMagic(nMetaMagic, METAMAGIC_EMPOWER))
       {
           nDam = nDam + nDam/2; //Damage/Healing is +50%
       }

       fTime = fDelay;
       fDelay2 += 0.1;
       fTime += fDelay2;

      SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBolt, oTarget, 1.0,FALSE);

       //Set damage effect
       effect eDam = EffectDamage(nDam, DAMAGE_TYPE_MAGICAL);
       SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBolt, oTarget, 1.0,FALSE);

       if(MyPRCGetRacialType(oTarget) != RACIAL_TYPE_UNDEAD)
       {
           DelayCommand(fTime, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
           DelayCommand(fTime, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget,0.0,FALSE));
           //DelayCommand(fDelay2, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oTarget,1.0));
       }

       //Make reflex save
       if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget,nDC))
       {
           DelayCommand(fTime, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget,6.0));

           if(!GetIsImmune(oTarget,IMMUNITY_TYPE_MIND_SPELLS))
           {
              DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDazed, oTarget,6.0));
              // FloatingTextStringOnCreature("no immune " , OBJECT_SELF, FALSE);
           }
           else
           {
              // FloatingTextStringOnCreature("immune " , OBJECT_SELF, FALSE);

              AssignCommand(oTarget,ClearAllActions(TRUE));
              AssignCommand(oTarget,ActionPlayAnimation(ANIMATION_LOOPING_PAUSE,1.0,6.0));
              DelayCommand(0.2,SetCommandable(FALSE,oTarget));
              DelayCommand(6.2,SetCommandable(TRUE,oTarget));
           }
        }
    }

    if (nMissiles>0)
        DelayCommand(6.2,DarkBolt(oTarget,nMissiles,nDC,nMetaMagic));

}


void main()
{
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
    if (!X2PreSpellCastCode()) return;

    SPSetSchool(SPELL_SCHOOL_NECROMANCY);
    object oTarget = GetSpellTargetObject();
    int nCasterLvl = PRCGetCasterLevel();
    int nMetaMagic = GetMetaMagicFeat();
        int nPenetr = nCasterLvl + SPGetPenetr();

    int nMissiles = nCasterLvl/2;
    float fDist = GetDistanceBetween(OBJECT_SELF, oTarget);
    float fDelay = fDist/(3.0 * log(fDist) + 2.0);
    float fDelay2, fTime;
    int nCnt;

        effect eBolt = EffectBeam(VFX_BEAM_BLACK, OBJECT_SELF, BODY_NODE_HAND);
    effect eMissile = EffectVisualEffect(VFX_BEAM_BLACK);
    effect eVis = EffectVisualEffect(VFX_IMP_MAGBLUE);
    effect eDazed=EffectDazed();

    effect eVis2 = EffectVisualEffect(VFX_IMP_DAZED_S);

        int nDC = GetSpellSaveDC()+GetChangesToSaveDC(oTarget,OBJECT_SELF);
    //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_RAY_OF_ENFEEBLEMENT));
        //Limit missiles to 7
        if (nMissiles > 7) nMissiles = 7;

        //Make SR Check
        if (!MyPRCResistSpell(OBJECT_SELF, oTarget,nPenetr))
        {

                //Roll damage
                int nDam = d8(2);
                //Enter Metamagic conditions
                if (CheckMetaMagic(nMetaMagic, METAMAGIC_MAXIMIZE))
                {
                      nDam = 16;//Damage is at max
                }
                if (CheckMetaMagic(nMetaMagic, METAMAGIC_EMPOWER))
                {
                      nDam = nDam + nDam/2; //Damage/Healing is +50%
                }

               fTime = fDelay;
               fDelay2 += 0.1;
               fTime += fDelay2;

               //Set damage effect
                effect eDam = EffectDamage(nDam, DAMAGE_TYPE_MAGICAL);
                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBolt, oTarget, 1.0,FALSE);

                if(MyPRCGetRacialType(oTarget) != RACIAL_TYPE_UNDEAD)
                {
                   DelayCommand(fTime, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                   DelayCommand(fTime, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget,0.0,FALSE));
                //   DelayCommand(fDelay2, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oTarget,1.0));
                }


             //Make reflex save
                if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget,nDC))
                {
                   DelayCommand(fTime, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget,6.0));

                   if(!GetIsImmune(oTarget,IMMUNITY_TYPE_MIND_SPELLS))
                   {
                     DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDazed, oTarget,6.0));
                    // FloatingTextStringOnCreature("no immune " , OBJECT_SELF, FALSE);
                   }
                   else
                   {
                    // FloatingTextStringOnCreature("immune " , OBJECT_SELF, FALSE);

                     AssignCommand(oTarget,ClearAllActions(TRUE));
                     AssignCommand(oTarget,ActionPlayAnimation(ANIMATION_LOOPING_PAUSE,1.0,6.0));
                     DelayCommand(0.2,SetCommandable(FALSE,oTarget));
                     DelayCommand(6.2,SetCommandable(TRUE,oTarget));
                   }
                }
        }
        nMissiles--;
        if (nMissiles>0)
           DelayCommand(6.2,DarkBolt( oTarget,nMissiles,nDC,nMetaMagic));

        SPSetSchool();

}
