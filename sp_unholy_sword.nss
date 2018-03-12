//::///////////////////////////////////////////////
//:: Unholy Sword
//:: sp_unholySwrd
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
  Grants holy avenger properties.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Nov 28, 2002
//:://////////////////////////////////////////////
//:: Updated by Andrew Nobbs May 08, 2003
//:: 2003-07-07: Stacking Spell Pass, Georg Zoeller

//:: altered by mr_bumpkin Dec 4, 2003 for prc stuff
#include "spinc_common"
#include "prc_alterations"
#include "x2_inc_spellhook"


void  AddHolyAvengerEffectToWeapon(object oMyWeapon, float fDuration, int nLevel)
{
   //IPSafeAddItemProperty(oMyWeapon,ItemPropertyEnhancementBonus(2), fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING ,FALSE,TRUE);
   //IPSafeAddItemProperty(oMyWeapon,ItemPropertyHolyAvenger(), fDuration, X2_IP_ADDPROP_POLICY_KEEP_EXISTING,TRUE,TRUE);

   //IPSafeAddItemProperty(oMyWeapon,ItemPropertyEnhancementBonus(2), fDuration, X2_IP_ADDPROP_POLICY_KEEP_EXISTING ,TRUE,TRUE);
   //IPSafeAddItemProperty(oMyWeapon,ItemPropertyEnhancementBonusVsAlign(IP_CONST_ALIGNMENTGROUP_EVIL, 5), fDuration, X2_IP_ADDPROP_POLICY_KEEP_EXISTING,TRUE,TRUE);
   //IPSafeAddItemProperty(oMyWeapon,ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_DISPEL_MAGIC, nLevel), fDuration, X2_IP_ADDPROP_POLICY_KEEP_EXISTING,TRUE,TRUE);
   AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyEnhancementBonus(2), oMyWeapon, fDuration);
   AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyEnhancementBonusVsAlign(IP_CONST_ALIGNMENTGROUP_GOOD, 5), oMyWeapon, fDuration);
   AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyDamageBonusVsAlign(IP_CONST_ALIGNMENTGROUP_GOOD, IP_CONST_DAMAGETYPE_DIVINE, IP_CONST_DAMAGEBONUS_2d6), oMyWeapon, fDuration);
   //AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_DISPEL_MAGIC, nLevel), oMyWeapon, fDuration);
   AddItemProperty(DURATION_TYPE_TEMPORARY, ItemPropertyAreaOfEffect(IP_CONST_AOE_CIRCLE_VS_GOOD, nLevel), oMyWeapon, fDuration);
   return;
}

#include "x2_inc_toollib"

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
    effect eVis = EffectVisualEffect(VFX_IMP_GOOD_HELP);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    int nLevel = PRCGetCasterLevel(OBJECT_SELF);
    int nDuration = nLevel;
    int nMetaMagic = PRCGetMetaMagicFeat();

   if ((nMetaMagic & METAMAGIC_EXTEND))
    {
        nDuration = nDuration * 2; //Duration is +100%
    }

    object oMyWeapon   =  IPGetTargetedOrEquippedMeleeWeapon();



    if(GetIsObjectValid(oMyWeapon) )
    {
        SignalEvent(oMyWeapon, EventSpellCastAt(OBJECT_SELF, PRCGetSpellId(), FALSE));

        if (nDuration>0)
        {
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, GetItemPossessor(oMyWeapon));
            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, GetItemPossessor(oMyWeapon), RoundsToSeconds(nDuration));

            AddHolyAvengerEffectToWeapon(oMyWeapon, RoundsToSeconds(nDuration), nLevel);
        }
        TLVFXPillar(VFX_IMP_GOOD_HELP, GetLocation(PRCGetSpellTargetObject()), 4, 0.0f, 6.0f);
        DelayCommand(1.0f, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_SUPER_HEROISM),GetLocation(PRCGetSpellTargetObject())));

        return;
    }
        else
    {
           FloatingTextStrRefOnCreature(83615, OBJECT_SELF);
           return;
    }


DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Erasing the variable used to store the spell's spell school

}
