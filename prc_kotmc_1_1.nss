//::///////////////////////////////////////////////
//:: Bless
//:: NW_S0_Bless.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    All allies within 30ft of the caster gain a
    +1 attack bonus and a +1 save bonus vs fear
    effects

    also can be cast on crossbow bolts to bless them
    in order to slay rakshasa
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: July 24, 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001
//:: Added Bless item ability: Georg Z, On: June 20, 2001


//:: modified by mr_bumpkin Dec 4, 2003
#include "spinc_common"

#include "NW_I0_SPELLS"

#include "x2_inc_spellhook"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_ENCHANTMENT);
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
    object oTarget = GetSpellTargetObject();
    int CasterLvl = GetLevelByClass(CLASS_TYPE_KNIGHT_MIDDLECIRCLE, OBJECT_SELF);
    int nDuration = CasterLvl+ 1;

    effect eVis = EffectVisualEffect(VFX_IMP_HEAD_HOLY);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    // ---------------- TARGETED ON BOLT  -------------------
    if(GetIsObjectValid(oTarget) && GetObjectType(oTarget) == OBJECT_TYPE_ITEM)
    {
        // special handling for blessing crossbow bolts that can slay rakshasa's
        if (GetBaseItemType(oTarget) ==  BASE_ITEM_BOLT)
        {
           SignalEvent(GetItemPossessor(oTarget), EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
           IPSafeAddItemProperty(oTarget, ItemPropertyOnHitCastSpell(123,1), RoundsToSeconds(nDuration), X2_IP_ADDPROP_POLICY_KEEP_EXISTING );
           SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, GetItemPossessor(oTarget));
           SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, GetItemPossessor(oTarget), TurnsToSeconds(nDuration),FALSE);
           return;
        }
    }


    effect eImpact = EffectVisualEffect(VFX_FNF_LOS_HOLY_30);
    effect eAttack = EffectAttackIncrease(1);
    effect eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, 1, SAVING_THROW_TYPE_FEAR);

    effect eLink = EffectLinkEffects(eAttack, eSave);
    eLink = EffectLinkEffects(eLink, eDur);

    int nMetaMagic = GetMetaMagicFeat();
    float fDelay;
    //Metamagic duration check
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2;   //Duration is +100%
    }

    //Apply Impact
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, GetSpellTargetLocation());

    //Get the first target in the radius around the caster
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
    while(GetIsObjectValid(oTarget))
    {
        if(GetIsReactionTypeFriendly(oTarget) || GetFactionEqual(oTarget))
        {
            fDelay = GetRandomDelay(0.4, 1.1);
            //Fire spell cast at event for target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_BLESS, FALSE));
            //Apply VFX impact and bonus effects
            DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
            DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration),TRUE,-1,CasterLvl));
        }
        //Get the next target in the specified area around the caster
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
    }

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name
}

