//::///////////////////////////////////////////////
//:: Tensor's Transformation
//:: NW_S0_TensTrans.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Gives the caster the following bonuses:
        +1 Attack per 2 levels
        +4 Natural AC
        20 STR and DEX and CON
        1d6 Bonus HP per level
        +5 on Fortitude Saves
        -10 Intelligence
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 26, 2001
//:://////////////////////////////////////////////
//: Sep2002: losing hit-points won't get rid of the rest of the bonuses

//:: modified by mr_bumpkin  Dec 4, 2003
#include "spinc_common"
/*#include "x2_inc_spellhook"
#include "x2_inc_itemprop"
#include "x2_inc_shifter"
#include "pnp_shft_poly"*/

const int BONUS_FEAT_WEAPON_PROFICIENCY_SIMPLE      = 23;
const int BONUS_FEAT_WEAPON_PROFICIENCY_MARTIAL     = 22;

int CalculateAttackBonus()
{
   int iBAB = GetBaseAttackBonus(OBJECT_SELF);
   int iHD = GetHitDice(OBJECT_SELF);
   int iBonus = (iHD > 20) ? ((20 + (iHD - 19) / 2) - iBAB) : (iHD - iBAB); // most confusing line ever. :)

   return (iBonus > 0) ? iBonus : 0;
}

// Aplica el conjuro en base al libro
// Tenser's Transformation
//    Transmutation
//
//    Level: Sor/Wiz 6
//    Components: V, S, M
//    Casting Time: 1 standard action
//    Range: Personal
//    Target: You
//    Duration: 1 round/level
//
//    You become a virtual fighting machine— stronger, tougher, faster, and more
//    skilled in combat. Your mind-set changes so that you relish combat and you
//    can’t cast spells, even from magic items.
//
//    You gain a +4 enhancement bonus to Strength, Dexterity, and Constitution, a
//    +4 natural armor bonus to AC, a +5 competence bonus on Fortitude saves, and
//    proficiency with all simple and martial weapons. Your base attack bonus
//    equals your character level (which may give you multiple attacks).
//
//    You lose your spellcasting ability, including your ability to use spell
//    activation or spell completion magic items, just as if the spells were no
//    longer on your class list.
//
//    Material Component: A potion of bull’s strength, which you drink (and whose
//    effects are subsumed by the spell effects).
//
//    Variaciones de la casa:
//    - no tiene costo material
//    - no esta implementado el fallo arcano de los objetos magicos
//    - no se dispellean las proficiencias
void aplicarCustomTensersTransformation( int casterLevel, int metaMagia );
void aplicarCustomTensersTransformation( int casterLevel, int metaMagia )
{
    int nDuration = casterLevel;
    if(metaMagia == METAMAGIC_EXTEND)
        nDuration *= 2;

    effect eAttack = EffectAttackIncrease(CalculateAttackBonus());
    effect eSave = EffectSavingThrowIncrease(SAVING_THROW_FORT, 5);
    effect eSwing = EffectModifyAttacks(2);
    effect eFuerza = EffectAbilityIncrease(ABILITY_STRENGTH, 4);
    effect eDestreza = EffectAbilityIncrease(ABILITY_DEXTERITY, 4);
    effect eConstitucion = EffectAbilityIncrease(ABILITY_CONSTITUTION, 4);
    effect eNaturalArmor = EffectACIncrease(4, AC_NATURAL_BONUS);
    effect eFalloArcano = EffectSpellFailure(100);
    effect eVis = EffectVisualEffect(VFX_IMP_SUPER_HEROISM);

    effect eLink = EffectLinkEffects(eAttack, eSave);
    eLink = EffectLinkEffects(eLink, eSwing);
    eLink = EffectLinkEffects(eLink, eFuerza);
    eLink = EffectLinkEffects(eLink, eDestreza);
    eLink = EffectLinkEffects(eLink, eConstitucion);
    eLink = EffectLinkEffects(eLink, eNaturalArmor);
    eLink = EffectLinkEffects(eLink, eFalloArcano);

    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, RoundsToSeconds(nDuration), TRUE, -1, casterLevel);

    // Dado que no se puede aplicar de otra manera, se agregan las proficiencias en la piel del personaje
    object oPiel = GetItemInSlot(INVENTORY_SLOT_CARMOUR,OBJECT_SELF);
    itemproperty IPWeaponProfSimple = ItemPropertyBonusFeat(BONUS_FEAT_WEAPON_PROFICIENCY_SIMPLE);
    itemproperty IPWeaponProfMartial = ItemPropertyBonusFeat(BONUS_FEAT_WEAPON_PROFICIENCY_MARTIAL);
    IPSafeAddItemProperty(oPiel, IPWeaponProfSimple, RoundsToSeconds(nDuration));
    IPSafeAddItemProperty(oPiel, IPWeaponProfMartial, RoundsToSeconds(nDuration));

    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    // Getting rid of the integer used to hold the spells spell school
}

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_TRANSMUTATION);

  //----------------------------------------------------------------------------
  // GZ, Nov 3, 2003
  // There is a serious problems with creatures turning into unstoppable killer
  // machines when affected by tensors transformation. NPC AI can't handle that
  // spell anyway, so I added this code to disable the use of Tenser's by any
  // NPC.
  //----------------------------------------------------------------------------
  if (!GetIsPC(OBJECT_SELF))
  {
      WriteTimestampedLogEntry(GetName(OBJECT_SELF) + "[" + GetTag (OBJECT_SELF) +"] tried to cast Tensors Transformation. Bad! Remove that spell from the creature");
      return;
  }

  /*
    Spellcast Hook Code
      Added 2003-06-23 by GeorgZ
      If you want to make changes to all spells,
      check x2_inc_spellhook.nss to find out more
    */

    if (!X2PreSpellCastCode())
    {
        return;
    }

    // End of Spell Cast Hook

    //Declare major variables
    int CasterLvl = PRCGetCasterLevel(OBJECT_SELF);
    int nDuration = CasterLvl;
    int nMeta = GetMetaMagicFeat();
    int nHP, nCnt;

    //Aplica el conjuro propio y corta la ejecucion del viejo
    aplicarCustomTensersTransformation(CasterLvl, nMeta);
    return;

    //Determine bonus HP
    for(nCnt; nCnt <= CasterLvl; nCnt++)
    {
        nHP += d6();
    }

    //Metamagic
    if(nMeta == METAMAGIC_MAXIMIZE)
    {
        nHP = CasterLvl * 6;
    }
    else if(nMeta == METAMAGIC_EMPOWER)
    {
        nHP = nHP + (nHP/2);
    }
    else if(nMeta == METAMAGIC_EXTEND)
    {
        nDuration *= 2;
    }

    // Get The PC's Equipment
    object oWeaponOld = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, OBJECT_SELF);
    object oArmorOld  = GetItemInSlot(INVENTORY_SLOT_CHEST, OBJECT_SELF);
    object oHelmetOld = GetItemInSlot(INVENTORY_SLOT_HEAD, OBJECT_SELF);
    object oShieldOld = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, OBJECT_SELF);

    if (GetBaseItemType(oShieldOld) != BASE_ITEM_SMALLSHIELD &&
        GetBaseItemType(oShieldOld) != BASE_ITEM_LARGESHIELD &&
        GetBaseItemType(oShieldOld) != BASE_ITEM_TOWERSHIELD)
    {
        oShieldOld = OBJECT_INVALID;
    }

    //Declare effects
    effect eAttack = EffectAttackIncrease(CalculateAttackBonus());
    effect eSave = EffectSavingThrowIncrease(SAVING_THROW_FORT, 5);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eSwing = EffectModifyAttacks(2);
    effect ePoly = EffectPolymorph(28);
    effect eHP = EffectTemporaryHitpoints(nHP);
    effect eVis = EffectVisualEffect(VFX_IMP_SUPER_HEROISM);


    //Link effects
    effect eLink = EffectLinkEffects(eAttack, eSave);
    eLink = EffectLinkEffects(eLink, eDur);
    eLink = EffectLinkEffects(eLink, eSwing);
    eLink = EffectLinkEffects(eLink, ePoly);

    //Signal Spell Event
    SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, SPELL_TENSERS_TRANSFORMATION, FALSE));

    //this command will make shore that polymorph plays nice with the shifter
    //ShifterCheck(OBJECT_SELF);

    ClearAllActions(); // prevents an exploit

    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHP, OBJECT_SELF, RoundsToSeconds(nDuration), TRUE, -1, CasterLvl);
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, RoundsToSeconds(nDuration), TRUE, -1, CasterLvl);

    // Get the Polymorphed form's stuff
    object oWeaponNew = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,OBJECT_SELF);
    object oArmorNew = GetItemInSlot(INVENTORY_SLOT_CARMOUR,OBJECT_SELF);

    // Tenser's Sword is overpowerful with equipment merging -- no longer do you
    // need a +3 flaming longsword if you have reasonably good equipment.
    itemproperty ip = GetFirstItemProperty(oWeaponNew);
    while (GetIsItemPropertyValid(ip))
    {
        RemoveItemProperty(oWeaponNew, ip);
        ip = GetNextItemProperty(oWeaponNew);
    }

    // I like that nice flaming effect though.
    itemproperty ipFlaming = ItemPropertyVisualEffect(ITEM_VISUAL_FIRE);
    IPSafeAddItemProperty(oWeaponNew, ipFlaming);

    // Merges in your stuff so that you're not weakened by the morph.
    IPWildShapeCopyItemProperties(oWeaponOld, oWeaponNew, TRUE);
    IPWildShapeCopyItemProperties(oArmorOld, oArmorNew, TRUE);
    IPWildShapeCopyItemProperties(oHelmetOld, oArmorNew, TRUE);
    IPWildShapeCopyItemProperties(oShieldOld, oArmorNew, TRUE);

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the integer used to hold the spells spell school
}
