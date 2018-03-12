#include "inc_item_props"
#include "nw_i0_plot"
#include "prc_inc_function"
#include "prc_ipfeat_const"
#include "inc_epicspells"
#include "prc_inc_clsfunc"

void PrcFeats(object oPC)
{
     SetLocalInt(oPC,"ONREST",1);
     DeletePRCLocalIntsT(oPC);
     EvalPRCFeats(oPC);
     DeleteLocalInt(oPC,"ONREST");
     FeatSpecialUsePerDay(oPC);
}

void main()
{
    object oPC= OBJECT_SELF;



         if (GetLevelByClass(CLASS_TYPE_DRUNKEN_MASTER, oPC)){
            SetLocalInt(oPC, "DRUNKEN_MASTER_IS_IN_DRUNKEN_RAGE", 0);
            SetLocalInt(oPC, "DRUNKEN_MASTER_IS_DRUNK_LIKE_A_DEMON", 0);
         }
        if (GetHasFeat(FEAT_PRESTIGE_IMBUE_ARROW))
        {
            //Destroy imbued arrows.
            AADestroyAllImbuedArrows(oPC);
        }

     //Restore Power Points for Psionics
     ExecuteScript("prc_psi_ppoints", oPC);

         // To heal up enslaved creatures...
         object oSlave = GetLocalObject(oPC, "EnslavedCreature");
         if (GetIsObjectValid(oSlave) && !GetIsDead(oSlave) && !GetIsInCombat(oSlave)) ForceRest(oSlave);

         if (GetHasFeat(FEAT_LIPS_RAPTUR,oPC)){
            int iLips=GetAbilityModifier(ABILITY_CHARISMA,oPC)+1;
            if (iLips<2)iLips=1;
               SetLocalInt(oPC,"FEAT_LIPS_RAPTUR",iLips);
            SendMessageToPC(oPC," Lips of Rapture : use "+IntToString(iLips-1));
         }

         if (GetLevelByClass(CLASS_TYPE_BONDED_SUMMONNER, oPC))
         {
            object oFam =  GetLocalObject(oPC, "BONDED");
            if (GetIsObjectValid(oFam) && !GetIsDead(oFam) && !GetIsInCombat(oFam)) ForceRest(oFam);
         }

        if (GetIsEpicCleric(oPC) || GetIsEpicDruid(oPC) ||
                GetIsEpicSorcerer(oPC) || GetIsEpicWizard(oPC)) {
            FloatingTextStringOnCreature("*You feel refreshed*", oPC, FALSE);
            ReplenishSlots(oPC);
        }

          if (GetHasFeat(FEAT_SF_CODE,oPC))
            RemoveSpecificProperty(GetPCSkin(oPC),ITEM_PROPERTY_BONUS_FEAT,IP_CONST_FEAT_SF_CODE);

          // begin flurry of swords array
          if (GetLevelByClass(CLASS_TYPE_ARCANE_DUELIST, oPC))
          {
             DeleteLocalInt(oPC, "FLURRY_TARGET_NUMBER");

             int i;
             for (i = 0 ; i < 10 ; i++)
             {
                string sName = "FLURRY_TARGET_" + IntToString(i);
                SetLocalObject(oPC, sName, OBJECT_INVALID);
             }
          }
          // end flurry or swords array

          DelayCommand(1.0,PrcFeats(oPC));





}
