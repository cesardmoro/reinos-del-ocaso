//::///////////////////////////////////////////////
//:: Magic Vestment
//:: X2_S0_MagcVest
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
  Grants a +1 AC bonus to armor touched per 3 caster
  levels (maximum of +5).
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Nov 28, 2002
//:://////////////////////////////////////////////
//:: Updated by Andrew Nobbs May 09, 2003
//:: 2003-07-29: Rewritten, Georg Zoeller

//:: altered by mr_bumpkin Dec 4, 2003 for prc stuff
#include "spinc_common"

#include "nw_i0_spells"
#include "x2_i0_spells"

#include "x2_inc_spellhook"



void  AddACBonusToArmor(object oMyArmor, float fDuration, int nAmount)
{
    IPSafeAddItemProperty(oMyArmor,ItemPropertyACBonus(nAmount), fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING ,FALSE,TRUE);
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
    effect eVis = EffectVisualEffect(VFX_IMP_GLOBE_USE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    int nDuration  = PRCGetCasterLevel(OBJECT_SELF);
    int nMetaMagic = GetMetaMagicFeat();
    int nAmount = nDuration/3;
    if (nAmount <0)
    {
        nAmount =1;
    }
    else if (nAmount>5)
    {
        nAmount =5;
    }

    object oMyArmor   =  IPGetTargetedOrEquippedArmor(TRUE);
    int nGold = nAmount*10;
    if (CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND))
    {
        nDuration = nDuration * 2; //Duration is +100%
    }

    if( !GetIsPC(OBJECT_SELF) || GetIsDMPossessed(OBJECT_SELF) || GetGold(OBJECT_SELF) >= nGold )
    {

        if(GetIsObjectValid(oMyArmor) )
        {
            SignalEvent(GetItemPossessor(oMyArmor ), EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

            if (nDuration>0)
            {
                TakeGoldFromCreature(nGold, OBJECT_SELF, TRUE);
                location lLoc = GetLocation(GetSpellTargetObject());
                DelayCommand(1.3f, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, GetItemPossessor(oMyArmor)));
                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, GetItemPossessor(oMyArmor), HoursToSeconds(nDuration));
                AddACBonusToArmor(oMyArmor, HoursToSeconds(nDuration),nAmount);
        }
            return;
        }
            else
        {
               FloatingTextStrRefOnCreature(83826, OBJECT_SELF);
               return;
        }
        }

    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    // Erasing the variable used to store the spell's spell school
}
