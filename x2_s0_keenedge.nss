//::///////////////////////////////////////////////
//:: Keen Edge
//:: X2_S0_KeenEdge
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
  Adds the keen property to one melee weapon,
  increasing its critical threat range.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Nov 28, 2002
//:://////////////////////////////////////////////
//:: Updated by Andrew Nobbs May 08, 2003
//:: 2003-07-07: Stacking Spell Pass, Georg Zoeller
//:: 2003-07-17: Complete Rewrite to make use of Item Property System

//:: altered by mr_bumpkin Dec 4, 2003 for prc stuff
#include "spinc_common"
#include "item_inc"

#include "nw_i0_spells"
#include "x2_i0_spells"

#include "x2_inc_spellhook"




void  AddKeenEffectToWeapon(object oMyWeapon, int bonusFeat, float fDuration)
{
   IPSafeAddItemProperty(oMyWeapon, ItemPropertyBonusFeat(bonusFeat), fDuration, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
   if (bonusFeat == IP_CONST_FEAT_IMPROVED_CRITICAL_LONGBOW)
       IPSafeAddItemProperty(oMyWeapon, ItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_CRITICAL_SHORTBOW), fDuration, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
   if (bonusFeat == IP_CONST_FEAT_IMPROVED_CRITICAL_HEAVY_CROSSBOW)
       IPSafeAddItemProperty(oMyWeapon, ItemPropertyBonusFeat(IP_CONST_FEAT_IMPROVED_CRITICAL_LIGHT_CROSSBOW), fDuration, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
   return;
}

void main()
{
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_TRANSMUTATION);

    /*
      Spellcast Hook Code
      Added 2003-07-07 by Georg Zoeller
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
    effect eVis = EffectVisualEffect(VFX_IMP_SUPER_HEROISM);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    int nDuration = 10 * PRCGetCasterLevel(OBJECT_SELF);
    int nMetaMagic = GetMetaMagicFeat();

    object oMyWeapon   =  IPGetTargetedOrEquippedMeleeWeapon();

    if (CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND))
    {
        nDuration = nDuration * 2; //Duration is +100%
    }

    if(GetIsObjectValid(oMyWeapon) )
    {
        SignalEvent(oMyWeapon, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

        int featId = Item_GetWeaponImprovedCriticalBonusFeat( oMyWeapon );
        if (featId > -1)
        {
            if (nDuration>0)
            {
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, GetItemPossessor(oMyWeapon));
                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, GetItemPossessor(oMyWeapon), TurnsToSeconds(nDuration));
                AddKeenEffectToWeapon(oMyWeapon, featId, TurnsToSeconds(nDuration));
            }
            return;
        }
        else
        {
          FloatingTextStringOnCreature("El arma no es cortante ni perforante.", OBJECT_SELF); // not a slashing weapon
          return;
        }
    }
    else
    {
        FloatingTextStrRefOnCreature(83615, OBJECT_SELF);
        return;
    }

    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    // Erasing the variable used to store the spell's spell school
}
