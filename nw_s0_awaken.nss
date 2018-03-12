//::///////////////////////////////////////////////
//:: Awaken
//:: NW_S0_Awaken
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This spell makes an animal ally more
    powerful, intelligent and robust for the
    duration of the spell.  Requires the caster to
    make a Will save to succeed.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 10, 2001
//:://////////////////////////////////////////////


//:: modified by mr_bumpkin Dec 4, 2003
#include "spinc_common"

#include "x2_inc_spellhook"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_TRANSMUTATION);
/*
  Spellcast Hook Code
  Added 2003-06-23 by GeorgZ
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
    int CasterLvl = PRCGetCasterLevel(OBJECT_SELF);
    object oTarget = GetSpellTargetObject();
    effect eStr = EffectAbilityIncrease(ABILITY_STRENGTH, 4);
    effect eCon = EffectAbilityIncrease(ABILITY_CONSTITUTION, 4);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eInt;
    effect eAttack = EffectAttackIncrease(2);
    effect eVis = EffectVisualEffect(VFX_IMP_HOLY_AID);
    int nInt = d10();
    int nDuration = 24;
    int nMetaMagic = GetMetaMagicFeat();

    if(GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION) == oTarget)
    {
        if(!GetHasSpellEffect(SPELL_AWAKEN))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_AWAKEN, FALSE));
            //Enter Metamagic conditions
            if (CheckMetaMagic(nMetaMagic, METAMAGIC_MAXIMIZE))
            {
                18;//Damage is at max
            }
            else if (CheckMetaMagic(nMetaMagic, METAMAGIC_EMPOWER))
            {
                nInt = nInt + (nInt/2); //Damage/Healing is +50%
            }
            else if (CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND))
            {
                nDuration = nDuration *2; //Duration is +100%
            }
            eInt = EffectAbilityIncrease(ABILITY_WISDOM, nInt);

            effect eLink = EffectLinkEffects(eStr, eCon);
            eLink = EffectLinkEffects(eLink, eAttack);
            eLink = EffectLinkEffects(eLink, eInt);
            eLink = EffectLinkEffects(eLink, eDur);
            eLink = SupernaturalEffect(eLink);
            //Apply the VFX impact and effects
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget,0.0f,TRUE,-1,CasterLvl);
        }
    }

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name
}
