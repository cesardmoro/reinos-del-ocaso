/*
    Henshin Mystic class functions.
    These are all the funstions that the Henshin Mystic pr class
    uses.

    Jeremiah Teague

    Rewritten by Stratovarius to use CompositeBonus
*/

// Include fiels:
#include "prc_class_const"
#include "prc_feat_const"
#include "inc_item_props"
#include "prc_inc_unarmed"


/// Immune to Sneak Attacks /////////
void HappoZanshin(object oPC, object oSkin)
{
    if(GetLocalInt(oSkin, "Happo") == TRUE) return;

    AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyImmunityMisc(IMMUNITY_TYPE_SNEAK_ATTACK), oSkin);
    SetLocalInt(oSkin, "Happo", TRUE);
}


/// +4 to Taunt, Persuade, Bluff, and Intimidate /////////
void Interaction(object oPC ,object oSkin)
{

   if(GetLocalInt(oSkin, "InterP") == 4) return;

    SetCompositeBonus(oSkin, "InterP", 4, ITEM_PROPERTY_SKILL_BONUS,SKILL_PERSUADE);
    SetCompositeBonus(oSkin, "InterT", 4, ITEM_PROPERTY_SKILL_BONUS,SKILL_TAUNT);
    SetCompositeBonus(oSkin, "InterB", 4, ITEM_PROPERTY_SKILL_BONUS,SKILL_BLUFF);
    SetCompositeBonus(oSkin, "InterI", 4, ITEM_PROPERTY_SKILL_BONUS,SKILL_INTIMIDATE);

}

    // Add Blindsight at level 6:
void BlindSight(object oPC)
    {
    if(GetLocalInt(oPC, "HMSight") == TRUE) return;

        // PC can detect Invisible creatures and has Ultravision:
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectUltravision()), oPC);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectSeeInvisible()), oPC);
    SetLocalInt(oPC, "HMSight", TRUE);
    }


// * Applies the Henshin Mystic's damage reduction bonuses as CompositeBonuses on object's skin.
void Invulerability(object oPC, object oSkin)
{
    if(GetLocalInt(oSkin, "HMInvul") == TRUE) return;

    RemoveSpecificProperty(oSkin, ITEM_PROPERTY_DAMAGE_REDUCTION, IP_CONST_DAMAGEREDUCTION_1, IP_CONST_DAMAGESOAK_20_HP, 1, "HMInvul");
    AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageReduction(IP_CONST_DAMAGEREDUCTION_1, IP_CONST_DAMAGESOAK_20_HP), oSkin);
    SetLocalInt(oSkin, "HMInvul", TRUE);
}



void main ()
{
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);

    UnarmedFeats(oPC);
    UnarmedFists(oPC);

    if(GetLevelByClass(CLASS_TYPE_HENSHIN_MYSTIC, oPC) >= 3)
    {
    HappoZanshin(oPC, oSkin);
    }

    if(GetLevelByClass(CLASS_TYPE_HENSHIN_MYSTIC, oPC) >= 4)
    {
    Interaction(oPC , oSkin);
    }

    if(GetLevelByClass(CLASS_TYPE_HENSHIN_MYSTIC, oPC) >= 6)
    {
    BlindSight(oPC);
    }

    if(GetLevelByClass(CLASS_TYPE_HENSHIN_MYSTIC, oPC) >= 10)
    {
    Invulerability(oPC, oSkin);
    }


}