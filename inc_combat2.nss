#include "inc_combat"

// * Performs a ranged attack roll by oPC against oTarget.
// * Begins with BAB; to simulate multiple attacks in one round,
// * use iMod to add a -5 modifier for each consecutive attack.
// * If bShowFeedback is TRUE, display the attack roll in oPC's
// * message window after a delay of fDelay seconds.
// * Caveat: Cannot account for ATTACK_BONUS effects on oPC
int DoRangedAttackS(object oPC, object oWeap, object oTarget, int iMod = 0, int bShowFeedback = TRUE, float fDelay = 0.0);

// Get Bonus Mighty
int GetMightyWeapon(object oWeap);

// * Returns an integer amount of damage done by oPC with oWeap
// * Caveat: Cannot account for DAMAGE_BONUS effects on oPC
int GetRangedWeaponDamageS(object oPC, object oWeap, int bCrit = FALSE,int iDamage = 0,int bCritMult=0);

// * Return Melee Attacker around 15 feet (TRUE or FALSE).
int GetMeleeAttackers15ft(object oPC = OBJECT_SELF);

// Return  attacks by round
int NbAtk(object oPC);

int GetWeaponRangeEnhancement(object oWeap,object oPC);

int GetDamageByConstantEnh(int iDamageConst, int iItemProp);

int GetDamageByConstantBonus(int iDamageConst);

struct iMultiDmg  DmgSpellEffect(int iCritik , object oPC ,struct iMultiDmg iMDmg);

int GetCastLvl (object oCaster,int nSpell ,int iTypeSpell);

struct iMultiDmg
{
    int dAcid,dBlud,dCold,dDiv,dElec,dFire,dMag,dNeg,dPierc,dPos,dSlash,dSon;
    int Phys;
};

struct iMultiDmg  DmgSpellEffect(int iCritik , object oPC ,struct iMultiDmg iMDmg);

int IsMagicalArrow(object oAmmu)
{
    int iMagic;

    if (GetBaseItemType(oAmmu)!= BASE_ITEM_ARROW) return 1;
    
    if (GetResRef(oAmmu)== "nw_wamar001")
       return 0;
    else
       return 1;
 
}

int GetMeleeAttackers15ft(object oPC = OBJECT_SELF)
{

    object oTarget = GetNearestCreature(CREATURE_TYPE_REPUTATION,REPUTATION_TYPE_ENEMY,oPC,1,CREATURE_TYPE_IS_ALIVE,TRUE);

   if (oTarget == OBJECT_INVALID) return FALSE;
   if ( GetDistanceBetween(oPC,oTarget)>3.0) return FALSE;

   return TRUE;
}

int NbAtk(object oPC)
{
  int BAB=GetBaseAttackBonus(oPC);
  int LvlCarac=GetHitDice(oPC);

  if (LvlCarac>20)
  {
     LvlCarac=(LvlCarac-19)/2;
     BAB=BAB-LvlCarac;
  }
  int iAttacks= (BAB - 1) / 5 + 1;
      iAttacks = iAttacks > 4 ? 4 : iAttacks;
  return iAttacks;
}

int GetMightyWeapon(object oWeap)
{
 int iMighty;
 itemproperty ip = GetFirstItemProperty(oWeap);
 while(GetIsItemPropertyValid(ip))
 {
    int iTemp;
    if(GetItemPropertyType(ip) == ITEM_PROPERTY_MIGHTY)
      iTemp = GetItemPropertyCostTableValue(ip);

    iMighty = iTemp > iMighty ? iTemp : iMighty;
    ip = GetNextItemProperty(oWeap);
  }
  return iMighty;
}
int GetAmmunitionEnhancement(object oWeap)
{
    int iTemp;
    int iBonus,iDmgType;
    int iBase =GetBaseItemType(oWeap);

    //Get Damage Bonus and Massive Critical Properties from oWeap
    itemproperty ip = GetFirstItemProperty(oWeap);
    while(GetIsItemPropertyValid(ip))
    {

        if(GetItemPropertyType(ip) == ITEM_PROPERTY_DAMAGE_BONUS){

           iDmgType = GetItemPropertySubType(ip);

            if ( (iBase==BASE_ITEM_BOLT || iBase==BASE_ITEM_ARROW)&& iDmgType ==IP_CONST_DAMAGETYPE_PIERCING)
            {
              iTemp = GetDamageByConstantEnh(GetItemPropertyCostTableValue(ip), TRUE);
              iBonus = iTemp> iBonus ? iTemp:iBonus ;
            }
            else if ( iBase==BASE_ITEM_BULLET && iDmgType ==IP_CONST_DAMAGETYPE_BLUDGEONING)
            {
              iTemp = GetDamageByConstantEnh(GetItemPropertyCostTableValue(ip), TRUE);
              iBonus = iTemp> iBonus ? iTemp:iBonus ;
            }

        }
       ip = GetNextItemProperty(oWeap);
    }

    return iBonus ;

}

object  GetWeaponAmmu(object oWeap,object oPC)
{
    int iType = GetBaseItemType(oWeap);
    object oAmmu = oWeap;

    switch (iType)
    {
      case BASE_ITEM_LIGHTCROSSBOW:
      case BASE_ITEM_HEAVYCROSSBOW:
        oAmmu=GetItemInSlot(INVENTORY_SLOT_BOLTS,oPC);
        break;
      case BASE_ITEM_SLING:
        oAmmu=GetItemInSlot(INVENTORY_SLOT_BULLETS,oPC);
        break;
     case BASE_ITEM_SHORTBOW:
     case BASE_ITEM_LONGBOW:
       oAmmu=GetItemInSlot(INVENTORY_SLOT_ARROWS,oPC);
    }
    return oAmmu;
}

int GetRangedWeaponDamageS(object oPC, object oWeap, int bCrit = FALSE,int iDamage = 0,int bCritMult=0)
{
    //Declare in instantiate major variables
    int iType = GetBaseItemType(oWeap);
    int nSides = StringToInt(Get2DAString("baseitems", "DieToRoll", iType));
    int nDice = StringToInt(Get2DAString("baseitems", "NumDice", iType));
    int nCritMult = StringToInt(Get2DAString("baseitems", "CritHitMult", iType))+bCritMult;
    int nMassiveCrit;
    int bSpec = GetHasFeat(GetFeatByWeaponType(iType, "Specialization"), oPC);
    int bESpec = GetHasFeat(GetFeatByWeaponType(iType, "EpicSpecialization"), oPC);
//    int iDamage = 0;
    int iBonus = 0;


    int iStr = GetAbilityModifier(ABILITY_STRENGTH, oPC);
        iBonus = iStr < 0 ?  iStr : 0 ;
        iStr = iStr > 0 ? iStr : 0 ;
    int iMighty = GetMightyWeapon(oWeap);
        iMighty = iStr>iMighty ? iMighty:iStr;


    object oAmmu;

    switch (iType)
    {
      case BASE_ITEM_LIGHTCROSSBOW:
      case BASE_ITEM_HEAVYCROSSBOW:
        oAmmu=GetItemInSlot(INVENTORY_SLOT_BOLTS,oPC);
        break;
      case BASE_ITEM_SLING:
        oAmmu=GetItemInSlot(INVENTORY_SLOT_BULLETS,oPC);
        break;
     case BASE_ITEM_SHORTBOW:
     case BASE_ITEM_LONGBOW:
       oAmmu=GetItemInSlot(INVENTORY_SLOT_ARROWS,oPC);
     case BASE_ITEM_SHURIKEN:
       oAmmu= oWeap;
    }

    int iEnhancement = GetWeaponRangeEnhancement(oAmmu,oPC);
        iEnhancement = iEnhancement < 0 ? 0 : iEnhancement;

    //Get Damage Bonus and Massive Critical Properties from oWeap
    itemproperty ip = GetFirstItemProperty(oAmmu);
    while(GetIsItemPropertyValid(ip))
    {
        int tempConst = 0;
        int iCostVal = GetItemPropertyCostTableValue(ip);

        if(GetItemPropertyType(ip) == ITEM_PROPERTY_MASSIVE_CRITICALS){
            if(iCostVal > tempConst){
                nMassiveCrit = GetDamageByConstant(iCostVal, TRUE);
                tempConst = iCostVal;
             }
        }
/*
        if(GetItemPropertyType(ip) == ITEM_PROPERTY_DAMAGE_BONUS){
            iBonus += GetDamageByConstant(iCostVal, TRUE);
        }
*/
        ip = GetNextItemProperty(oAmmu);

    }
    
    // SendMessageToPC(GetFirstPC(), "MassiveCrit:"+IntToString(nMassiveCrit));

    // SendMessageToPC(GetFirstPC(), "idamage:"+IntToString(iDamage));
    //Roll the base damage dice.
    if(nSides == 2) iDamage += d2(nDice);
    if(nSides == 4) iDamage += d4(nDice);
    if(nSides == 6) iDamage += d6(nDice);
    if(nSides == 8) iDamage += d8(nDice);
    if(nSides == 10) iDamage += d10(nDice);
    if(nSides == 12) iDamage += d12(nDice);
    
    // SendMessageToPC(GetFirstPC(), "nSides:"+IntToString(nSides));
    // SendMessageToPC(GetFirstPC(), "idamage+nSides"+IntToString(iDamage));

    //Add any applicable bonuses
    if(bSpec) iDamage += 2;
    if(bESpec) iDamage += 4;

    // SendMessageToPC(GetFirstPC(), "Spec"+IntToString(bSpec+bESpec));

    iDamage += iMighty;
    // SendMessageToPC(GetFirstPC(), "iMighty"+IntToString(iMighty));
   // SendMessageToPC(GetFirstPC(), "idamage+iMighty"+IntToString(iDamage));

    iDamage += iEnhancement;
    // SendMessageToPC(GetFirstPC(), "iEnhancement"+IntToString(iEnhancement));
    // SendMessageToPC(GetFirstPC(), "idamage+iEnhancement"+IntToString(iDamage));

    iDamage += iBonus;
    // SendMessageToPC(GetFirstPC(), "iBonus"+IntToString(iBonus));

    //Add critical bonuses
    if(bCrit){
        iDamage *= nCritMult;
        iDamage += nMassiveCrit;
    }

    iDamage =  iDamage<1 ? 1 :iDamage;

    return iDamage;
}



int DoRangedAttackS(object oPC, object oWeap, object oTarget, int iMod = 0, int bShowFeedback = TRUE, float fDelay = 0.0)
{
    //Declare in instantiate major variables
    int iDiceRoll = d20();
    int iBAB = GetBaseAttackBonus(oPC);
    int iAC = GetAC(oTarget);
    int iType = GetBaseItemType(oWeap);
    int iCritThreat = GetMeleeWeaponCriticalRange(oPC, oWeap);
    int bFocus = GetHasFeat(GetFeatByWeaponType(iType, "Focus"), oPC);
    int bEFocus = GetHasFeat(GetFeatByWeaponType(iType, "EpicFocus"), oPC);
    int bProwess = GetHasFeat(FEAT_EPIC_PROWESS, oPC);
    int iDex = GetAbilityModifier(ABILITY_DEXTERITY, oPC);
        iDex = iDex > 0 ? iDex:0;

    int iWis = GetAbilityModifier(ABILITY_WISDOM,oPC) && GetHasFeat(FEAT_ZEN_ARCHERY,oPC);
        iDex = iWis>iDex ? iWis:iDex;

    string sFeedback = GetName(oPC) + " attacks " + GetName(oTarget) + ": ";
    int iReturn = 0;

    int RangeWeap=StringToInt(Get2DAString("baseitems", "RangedWeapon", iType));;
    int iBonus;
    int iEnhancement = GetWeaponRangeEnhancement(oWeap,oPC) ;

    int Distance=FloatToInt(GetDistanceBetween(oPC,oTarget));

    int mRange=Distance/RangeWeap*2;
    int mMelee=GetMeleeAttackers15ft(oPC);

    int bPBShot = (mMelee) ? (GetHasFeat(FEAT_POINT_BLANK_SHOT,oPC)? 1:-4):0 ;
//    int iTrueStrike = GetHasSpellEffect(SPELL_TRUE_STRIKE,oPC) ? 20:0 ;

    //Add up total attack bonus

        int iAttackBonus = iBAB;
            // SendMessageToPC(GetFirstPC(), "iBAB:"+IntToString(iBAB));

        iAttackBonus += iDex;
            // SendMessageToPC(GetFirstPC(), "iDex:"+IntToString(iDex));

        iAttackBonus += bFocus ? 1 : 0;
        iAttackBonus += bEFocus ? 2 : 0;
        iAttackBonus += bProwess ? 1 : 0;
            // SendMessageToPC(GetFirstPC(), "Focus:"+IntToString(bFocus+bEFocus+bProwess));

        iAttackBonus += iEnhancement;
            // SendMessageToPC(GetFirstPC(), "iEnhancement:"+IntToString(iEnhancement));

        iAttackBonus += iMod;
            // SendMessageToPC(GetFirstPC(), "iMod:"+IntToString(iMod));

        iAttackBonus -= mRange;
            // SendMessageToPC(GetFirstPC(), "mRange:-"+IntToString(mRange));

        iAttackBonus += bPBShot;
        iAttackBonus += iBonus; // Weapon mastery
        iAttackBonus += AtkSpellEffect(oPC);
            // SendMessageToPC(GetFirstPC(), "AtkSpellEffect:"+IntToString(AtkSpellEffect(oPC)));

    iAttackBonus += GetWeaponAtkBonusIP(oWeap,oTarget);
            // SendMessageToPC(GetFirstPC(), "GetWeaponAtkBonusIP:"+IntToString(GetWeaponAtkBonusIP(oWeap,oTarget)));


    //Check for a critical threat
    if(iDiceRoll >= iCritThreat && iDiceRoll + iAttackBonus > iAC)
    {
        sFeedback += "*critical hit*: (" + IntToString(iDiceRoll) + " + " + IntToString(iAttackBonus) + " = " + IntToString(iDiceRoll + iAttackBonus) + "): ";
        //Roll again to see if we scored a critical hit
        iDiceRoll = d20();

        sFeedback += "*threat roll*: (" + IntToString(iDiceRoll) + " + " + IntToString(iAttackBonus) + " = " + IntToString(iDiceRoll + iAttackBonus) + ")";
        if(iDiceRoll + iAttackBonus > iAC)
            iReturn = 2;
        else
            iReturn = 1;
    }

    //Just a regular hit
    else if(iDiceRoll + iAttackBonus > iAC)
    {
        sFeedback += "*hit*: (" + IntToString(iDiceRoll) + " + " + IntToString(iAttackBonus) + " = " + IntToString(iDiceRoll + iAttackBonus) + ")";
        iReturn = 1;
    }

    //Missed
    else
    {
        sFeedback += "*miss*: (" + IntToString(iDiceRoll) + " + " + IntToString(iAttackBonus) + " = " + IntToString(iDiceRoll + iAttackBonus) + ")";
        iReturn = 0;
    }

    if(bShowFeedback) DelayCommand(fDelay, SendMessageToPC(oPC, sFeedback));
    return iReturn;
}

int GetWeaponRangeEnhancement(object oWeap,object oPC)
{
    int iBonus = 0;
    int iTemp;

    itemproperty ip = GetFirstItemProperty(oWeap);
    while(GetIsItemPropertyValid(ip))
    {
        if(GetItemPropertyType(ip) == ITEM_PROPERTY_ENHANCEMENT_BONUS)
            iTemp = GetItemPropertyCostTableValue(ip);
            iBonus = iTemp > iBonus ? iTemp : iBonus;
        ip = GetNextItemProperty(oWeap);
    }

    object oAmmu;
    int iType = GetBaseItemType(oWeap);
    switch (iType)
    {
      case BASE_ITEM_LIGHTCROSSBOW:
      case BASE_ITEM_HEAVYCROSSBOW:
        oAmmu=GetItemInSlot(INVENTORY_SLOT_BOLTS,oPC);
        break;
      case BASE_ITEM_SLING:
        oAmmu=GetItemInSlot(INVENTORY_SLOT_BULLETS,oPC);
        break;
     case BASE_ITEM_SHORTBOW:
     case BASE_ITEM_LONGBOW:
       oAmmu=GetItemInSlot(INVENTORY_SLOT_ARROWS,oPC);
    }

    iBonus = iBonus > GetAmmunitionEnhancement(oAmmu)?iBonus : GetAmmunitionEnhancement(oAmmu);
    int iEnhAA =  !IsMagicalArrow(oAmmu)? (GetLevelByClass(CLASS_TYPE_ARCANE_ARCHER,oPC)+1)/2 : 0;
        iBonus = iEnhAA >iBonus ? iEnhAA : iBonus ;
        iBonus = iBonus < 0 ? 0 : iBonus;

    return iBonus;
}


int GetDamageByConstantEnh(int iDamageConst, int iItemProp)
{
    if(iItemProp)
    {
        switch(iDamageConst)
        {
            case IP_CONST_DAMAGEBONUS_1:
                return 1;
            case IP_CONST_DAMAGEBONUS_2:
                return 2;
            case IP_CONST_DAMAGEBONUS_3:
                return 3;
            case IP_CONST_DAMAGEBONUS_4:
                return 4;
            case IP_CONST_DAMAGEBONUS_5:
                return 5;
            case IP_CONST_DAMAGEBONUS_6:
                return 6;
            case IP_CONST_DAMAGEBONUS_7:
                return 7;
            case IP_CONST_DAMAGEBONUS_8:
                return 8;
            case IP_CONST_DAMAGEBONUS_9:
                return 9;
            case IP_CONST_DAMAGEBONUS_10:
                return 10;
            case IP_CONST_DAMAGEBONUS_11:
                return 11;
            case IP_CONST_DAMAGEBONUS_12:
                return 12;
            case IP_CONST_DAMAGEBONUS_13:
                return 13;
            case IP_CONST_DAMAGEBONUS_14:
                return 14;
            case IP_CONST_DAMAGEBONUS_15:
                return 15;
            case IP_CONST_DAMAGEBONUS_16:
                return 16;
            case IP_CONST_DAMAGEBONUS_17:
                return 17;
            case IP_CONST_DAMAGEBONUS_18:
                return 18;
            case IP_CONST_DAMAGEBONUS_19:
                return 19;
            case IP_CONST_DAMAGEBONUS_20:
                return 20;
        }
    }
    else
    {
        switch(iDamageConst)
        {
            case DAMAGE_BONUS_1:
                return 1;
            case DAMAGE_BONUS_2:
                return 2;
            case DAMAGE_BONUS_3:
                return 3;
            case DAMAGE_BONUS_4:
                return 4;
            case DAMAGE_BONUS_5:
                return 5;
            case DAMAGE_BONUS_6:
                return 6;
            case DAMAGE_BONUS_7:
                return 7;
            case DAMAGE_BONUS_8:
                return 8;
            case DAMAGE_BONUS_9:
                return 9;
            case DAMAGE_BONUS_10:
                return 10;
            case DAMAGE_BONUS_11:
                return 11;
            case DAMAGE_BONUS_12:
                return 12;
            case DAMAGE_BONUS_13:
                return 13;
            case DAMAGE_BONUS_14:
                return 14;
            case DAMAGE_BONUS_15:
                return 15;
            case DAMAGE_BONUS_16:
                return 16;
            case DAMAGE_BONUS_17:
                return 17;
            case DAMAGE_BONUS_18:
                return 18;
            case DAMAGE_BONUS_19:
                return 19;
            case DAMAGE_BONUS_20:
                return 20;
        }
    }
    return 0;
}

int GetDamageByConstantBonus(int iDamageConst)
{

        switch(iDamageConst)
        {
            case IP_CONST_DAMAGEBONUS_1d4:
                return d4(1);
            case IP_CONST_DAMAGEBONUS_1d6:
                return d6(1);
            case IP_CONST_DAMAGEBONUS_1d8:
                return d8(1);
            case IP_CONST_DAMAGEBONUS_1d10:
                return d10(1);
            case IP_CONST_DAMAGEBONUS_1d12:
                return d12(1);
            case IP_CONST_DAMAGEBONUS_2d4:
                return d4(2);
            case IP_CONST_DAMAGEBONUS_2d6:
                return d6(2);
            case IP_CONST_DAMAGEBONUS_2d8:
                return d8(2);
            case IP_CONST_DAMAGEBONUS_2d10:
                return d10(2);
            case IP_CONST_DAMAGEBONUS_2d12:
                return d12(2);
        }


    return 0;
}

int GetWeaponDmgBonusIP(object oWeap,object oTarget)
{
    int iBonus = 0;
    int iTemp;

    int iRace=MyPRCGetRacialType(oTarget);

    int iGoodEvil=GetAlignmentGoodEvil(oTarget);
    int iLawChaos=GetAlignmentLawChaos(oTarget);
    int iAlignSp=ConvAlignGr(iGoodEvil,iLawChaos);
    int iAlignGr;
    int iDmgType ;
    int iDmg = GetWeaponDamageType(oWeap);
    int dBlud,dPierc,dSlash;

    itemproperty ip = GetFirstItemProperty(oWeap);
    while(GetIsItemPropertyValid(ip))
    {
        int iIp=GetItemPropertyType(ip);
        switch(iIp)
        {

           case ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP:
                iAlignGr=GetItemPropertySubType(ip);
                iDmgType =0;

                if (iAlignGr==ALIGNMENT_NEUTRAL)
                {
                  if (iAlignGr==iLawChaos)
                        iDmgType = GetItemPropertyParam1Value(ip);
                }
                else if (iAlignGr==iGoodEvil || iAlignGr==iLawChaos || iAlignGr==IP_CONST_ALIGNMENTGROUP_ALL)
                 iDmgType = GetItemPropertyParam1Value(ip);

                iTemp = 0;

                switch (iDmgType)
                {
                   case -1:
                      break;

                   case IP_CONST_DAMAGETYPE_BLUDGEONING:
                      if (iDmg==DAMAGE_TYPE_BLUDGEONING)
                           iTemp = GetDamageByConstantEnh(GetItemPropertyCostTableValue(ip),TRUE);
                      dBlud = iTemp > dBlud ? iTemp : dBlud;
                      break;
                   case IP_CONST_DAMAGETYPE_PIERCING:
                      if (iDmg==DAMAGE_TYPE_PIERCING)
                           iTemp = GetDamageByConstantEnh(GetItemPropertyCostTableValue(ip),TRUE);
                      dPierc = iTemp > dPierc ? iTemp : dPierc;
                      break;
                   case IP_CONST_DAMAGETYPE_SLASHING:
                      if (iDmg==DAMAGE_TYPE_SLASHING)
                          iTemp = GetDamageByConstantEnh(GetItemPropertyCostTableValue(ip),TRUE);
                      dSlash = iTemp > dSlash ? iTemp : dSlash;
                      break;
                }

                break;

            case ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP:
                iTemp = 0 ;
                iDmgType = GetItemPropertyParam1Value(ip);

                switch (iDmgType)
                {
                  case IP_CONST_DAMAGETYPE_BLUDGEONING:
                    if (iDmg==DAMAGE_TYPE_BLUDGEONING)
                        iTemp = GetDamageByConstantEnh(GetItemPropertyCostTableValue(ip),TRUE);
                    dBlud = iTemp > dBlud ? iTemp : dBlud;
                    break;
                  case IP_CONST_DAMAGETYPE_PIERCING:
                    if (iDmg==DAMAGE_TYPE_PIERCING)
                       iTemp = GetDamageByConstantEnh(GetItemPropertyCostTableValue(ip),TRUE);
                    dPierc = iTemp > dPierc ? iTemp : dPierc;
                    break;
                  case IP_CONST_DAMAGETYPE_SLASHING:
                    if (iDmg==DAMAGE_TYPE_SLASHING)
                       iTemp = GetDamageByConstantEnh(GetItemPropertyCostTableValue(ip),TRUE);
                    dSlash = iTemp > dSlash ? iTemp : dSlash;
                    break;
                }

                break;

            case ITEM_PROPERTY_DAMAGE_BONUS_VS_SPECIFIC_ALIGNMENT:
                iTemp = 0 ;
                iDmgType = GetItemPropertyParam1Value(ip);

                switch (iDmgType)
                {
                  case IP_CONST_DAMAGETYPE_BLUDGEONING:
                    if (iDmg==DAMAGE_TYPE_BLUDGEONING)
                       iTemp = GetDamageByConstantEnh(GetItemPropertyCostTableValue(ip),TRUE);
                    dBlud = iTemp > dBlud ? iTemp : dBlud;
                    break;
                  case IP_CONST_DAMAGETYPE_PIERCING:
                    if (iDmg==DAMAGE_TYPE_PIERCING)
                        iTemp = GetDamageByConstantEnh(GetItemPropertyCostTableValue(ip),TRUE);
                    dPierc = iTemp > dPierc ? iTemp : dPierc;
                    break;
                  case IP_CONST_DAMAGETYPE_SLASHING:
                    if (iDmg==DAMAGE_TYPE_SLASHING)
                       iTemp = GetDamageByConstantEnh(GetItemPropertyCostTableValue(ip),TRUE);
                    dSlash = iTemp > dSlash ? iTemp : dSlash;
                    break;
                }


                break;

            case ITEM_PROPERTY_DAMAGE_BONUS:
                iTemp = 0;
                iDmgType = GetItemPropertySubType(ip);

                switch (iDmgType)
                {
                  case IP_CONST_DAMAGETYPE_BLUDGEONING:
                    if (iDmg==DAMAGE_TYPE_BLUDGEONING)
                       iTemp = GetDamageByConstantEnh(GetItemPropertyCostTableValue(ip),TRUE);
                    dBlud = iTemp > dBlud ? iTemp : dBlud;
                    break;
                  case IP_CONST_DAMAGETYPE_PIERCING:
                    if (iDmg==DAMAGE_TYPE_PIERCING)
                      iTemp = GetDamageByConstantEnh(GetItemPropertyCostTableValue(ip),TRUE);
                    dPierc = iTemp > dPierc ? iTemp : dPierc;
                    break;
                  case IP_CONST_DAMAGETYPE_SLASHING:
                    if (iDmg==DAMAGE_TYPE_SLASHING)
                        iTemp = GetDamageByConstantEnh(GetItemPropertyCostTableValue(ip),TRUE);
                    dSlash = iTemp > dSlash ? iTemp : dSlash;
                    break;
                }
                break;


        }

        ip = GetNextItemProperty(oWeap);
    }

    return iBonus;
}

int GetMeleeWeaponDamageS(object oPC, object oWeap, object oTarget ,int bCrit = FALSE,int iDamage = 0)
{
    //Declare in instantiate major variables
    int iType = GetBaseItemType(oWeap);
    int nSides = StringToInt(Get2DAString("baseitems", "DieToRoll", iType));
    int nDice = StringToInt(Get2DAString("baseitems", "NumDice", iType));
    int nCritMult = StringToInt(Get2DAString("baseitems", "CritHitMult", iType));
    int nMassiveCrit;
    int iStr = GetAbilityModifier(ABILITY_STRENGTH, oPC);
        iStr = iStr < 0 ? 0 : iStr;
    int bSpec = GetHasFeat(GetFeatByWeaponType(iType, "Specialization"), oPC);
    int bESpec = GetHasFeat(GetFeatByWeaponType(iType, "EpicSpecialization"), oPC);
//    int iDamage = 0;
    int iBonus = 0;
    int iEnhancement = GetWeaponEnhancement(oWeap);
        iEnhancement = iEnhancement < 0 ? 0 : iEnhancement;

    //Get Damage Bonus and Massive Critical Properties from oWeap
    itemproperty ip = GetFirstItemProperty(oWeap);
    while(GetIsItemPropertyValid(ip))
    {
        int tempConst = 0;
        int iCostVal = GetItemPropertyCostTableValue(ip);

        if(GetItemPropertyType(ip) == ITEM_PROPERTY_MASSIVE_CRITICALS){
            if(iCostVal > tempConst){
                nMassiveCrit = GetDamageByConstant(iCostVal, TRUE);
                tempConst = iCostVal;
             }
        }
        ip = GetNextItemProperty(oWeap);

    }

    iDamage +=GetWeaponDmgBonusIP(oWeap,oTarget);

//  SendMessageToPC(GetFirstPC(), "GetWeaponDmgBonusIP:"+IntToString(GetWeaponDmgBonusIP(oWeap,oTarget)));
// SendMessageToPC(GetFirstPC(), "iDamage:"+IntToString(iDamage));


    //Roll the base damage dice.
    if(nSides == 2) iDamage += d2(nDice);
    if(nSides == 4) iDamage += d4(nDice);
    if(nSides == 6) iDamage += d6(nDice);
    if(nSides == 8) iDamage += d8(nDice);
    if(nSides == 10) iDamage += d10(nDice);
    if(nSides == 12) iDamage += d12(nDice);

    //Add any applicable bonuses
    if(bSpec) iDamage += 2;
    if(bESpec) iDamage += 4;
 // SendMessageToPC(GetFirstPC(), "iDamage+Spec:"+IntToString(iDamage));

    iDamage += iStr;
 // SendMessageToPC(GetFirstPC(), "iStr:"+IntToString(iStr));

    iDamage += iEnhancement;
 // SendMessageToPC(GetFirstPC(), "iEnhancement:"+IntToString(iEnhancement));

    iDamage += iBonus;
 // SendMessageToPC(GetFirstPC(), "iBonus:"+IntToString(iBonus));

    
    //Add critical bonuses
    if(bCrit){
        iDamage *= nCritMult;
        iDamage += nMassiveCrit;
    }

    return iDamage;
}


effect AddDmgEffectMulti(int nDmg ,int dType, object oAmmu, object oTarget ,int iEnhancement, int iCritik = 0)
{
    int dAcid,dBlud,dCold,dDiv,dElec,dFire,dMag,dNeg,dPierc,dPos,dSlash,dSon;
    int iDmgType;
    int iTemp;
    int iBonus = 0;
    effect eLink;

    int iRace=MyPRCGetRacialType(oTarget);

    int iGoodEvil=GetAlignmentGoodEvil(oTarget);
    int iLawChaos=GetAlignmentLawChaos(oTarget);
    int iAlignSp=ConvAlignGr(iGoodEvil,iLawChaos);
    int iAlignGr;
    int iType = GetBaseItemType(oAmmu);
    int iDmg;
    struct iMultiDmg sDmg;
    
    DmgSpellEffect(iCritik,OBJECT_SELF,sDmg);
 
    
    // SendMessageToPC(GetFirstPC(), "DmgSpellEffect:"+IntToString(sDmg.Phys));


    switch (iType)
    {
      case BASE_ITEM_BOLT:
      case BASE_ITEM_ARROW:
           iDmg = DAMAGE_TYPE_PIERCING;
           break;
      case BASE_ITEM_BULLET:
           iDmg = DAMAGE_TYPE_BLUDGEONING;
          break;
      default:
           iDmg = GetWeaponDamageType(oAmmu);
           break;
    }


    switch (dType)
    {
      case DAMAGE_TYPE_PIERCING:
         sDmg.dPierc+= nDmg+ sDmg.Phys;
         break;
      case DAMAGE_TYPE_BLUDGEONING:
         sDmg.dBlud+= nDmg+ sDmg.Phys;
         break;
      case DAMAGE_TYPE_DIVINE:
         sDmg.dDiv+= nDmg;
         break;

      default:
         sDmg.dSlash+= nDmg+ sDmg.Phys;
         break;
    }

 
    itemproperty ip = GetFirstItemProperty(oAmmu);
    while(GetIsItemPropertyValid(ip))
    {
        int iIp=GetItemPropertyType(ip);
        switch(iIp)
        {

           case ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP:
                iAlignGr=GetItemPropertySubType(ip);
                iDmgType =-1;

                if (iAlignGr==ALIGNMENT_NEUTRAL)
                {
                  if (iAlignGr==iLawChaos)
                        iDmgType = GetItemPropertyParam1Value(ip);
                }
                else if (iAlignGr==iGoodEvil || iAlignGr==iLawChaos || iAlignGr==IP_CONST_ALIGNMENTGROUP_ALL)
                 iDmgType = GetItemPropertyParam1Value(ip);

                iTemp = GetDamageByConstant(GetItemPropertyCostTableValue(ip),TRUE);

                       switch (iDmgType)
                       {
                         case -1:
                            break;

                         case IP_CONST_DAMAGETYPE_ACID:
                            dAcid = iTemp > dAcid ? iTemp : dAcid;
                            break;
                         case IP_CONST_DAMAGETYPE_BLUDGEONING:
                            if (iDmg==DAMAGE_TYPE_BLUDGEONING)
                                    iTemp = GetDamageByConstantBonus(GetItemPropertyCostTableValue(ip));
                            dBlud = iTemp > dBlud ? iTemp : dBlud;
                            break;
                         case IP_CONST_DAMAGETYPE_COLD:
                            dCold = iTemp > dCold ? iTemp : dCold;
                            break;
                         case IP_CONST_DAMAGETYPE_DIVINE:
                            dDiv = iTemp > dDiv ? iTemp : dDiv;
                            break;
                         case IP_CONST_DAMAGETYPE_ELECTRICAL:
                            dElec = iTemp > dElec ? iTemp : dElec;
                            break;
                         case IP_CONST_DAMAGETYPE_FIRE:
                            dFire = iTemp > dFire ? iTemp : dFire;
                            break;
                         case IP_CONST_DAMAGETYPE_MAGICAL:
                            dMag = iTemp > dMag ? iTemp : dMag;
                            break;
                         case IP_CONST_DAMAGETYPE_NEGATIVE:
                             dNeg = iTemp > dNeg ? iTemp : dNeg;
                             break;
                         case IP_CONST_DAMAGETYPE_PIERCING:
                             if (iDmg==DAMAGE_TYPE_PIERCING)
                                    iTemp = GetDamageByConstantBonus(GetItemPropertyCostTableValue(ip));
                             dPierc = iTemp > dPierc ? iTemp : dPierc;
                              break;
                         case IP_CONST_DAMAGETYPE_POSITIVE:
                            dPos = iTemp > dPos ? iTemp : dPos;
                            break;
                        case IP_CONST_DAMAGETYPE_SLASHING:
                           if (iDmg==DAMAGE_TYPE_SLASHING)
                             iTemp = GetDamageByConstantBonus(GetItemPropertyCostTableValue(ip));
                            dSlash = iTemp > dSlash ? iTemp : dSlash;
                            break;
                        case IP_CONST_DAMAGETYPE_SONIC:
                            dSon = iTemp > dSon ? iTemp : dSon;
                           break;

                        }
 
                break;

            case ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP:
                iTemp = GetItemPropertySubType(ip)==iRace ? GetDamageByConstant(GetItemPropertyCostTableValue(ip),TRUE):0 ;
                iDmgType = GetItemPropertyParam1Value(ip);

                switch (iDmgType)
                {
                  case IP_CONST_DAMAGETYPE_ACID:
                    dAcid = iTemp > dAcid ? iTemp : dAcid;
                    break;
                  case IP_CONST_DAMAGETYPE_BLUDGEONING:
                    if (iDmg==DAMAGE_TYPE_BLUDGEONING)
                        iTemp = GetDamageByConstantBonus(GetItemPropertyCostTableValue(ip));
                    dBlud = iTemp > dBlud ? iTemp : dBlud;
                    break;
                  case IP_CONST_DAMAGETYPE_COLD:
                    dCold = iTemp > dCold ? iTemp : dCold;
                    break;
                  case IP_CONST_DAMAGETYPE_DIVINE:
                    dDiv = iTemp > dDiv ? iTemp : dDiv;
                    break;
                  case IP_CONST_DAMAGETYPE_ELECTRICAL:
                    dElec = iTemp > dElec ? iTemp : dElec;
                    break;
                  case IP_CONST_DAMAGETYPE_FIRE:
                    dFire = iTemp > dFire ? iTemp : dFire;
                    break;
                  case IP_CONST_DAMAGETYPE_MAGICAL:
                    dMag = iTemp > dMag ? iTemp : dMag;
                    break;
                  case IP_CONST_DAMAGETYPE_NEGATIVE:
                    dNeg = iTemp > dNeg ? iTemp : dNeg;
                    break;
                  case IP_CONST_DAMAGETYPE_PIERCING:
                    if (iDmg==DAMAGE_TYPE_PIERCING)
                       iTemp = GetDamageByConstantBonus(GetItemPropertyCostTableValue(ip));
                    dPierc = iTemp > dPierc ? iTemp : dPierc;
                    break;
                  case IP_CONST_DAMAGETYPE_POSITIVE:
                    dPos = iTemp > dPos ? iTemp : dPos;
                    break;
                  case IP_CONST_DAMAGETYPE_SLASHING:
                    if (iDmg==DAMAGE_TYPE_SLASHING)
                       iTemp = GetDamageByConstantBonus(GetItemPropertyCostTableValue(ip));
                    dSlash = iTemp > dSlash ? iTemp : dSlash;
                    break;
                  case IP_CONST_DAMAGETYPE_SONIC:
                    dSon = iTemp > dSon ? iTemp : dSon;
                    break;
                    
 
                }
 
                break;

            case ITEM_PROPERTY_DAMAGE_BONUS_VS_SPECIFIC_ALIGNMENT:
                iTemp = GetItemPropertySubType(ip)==iAlignSp ? GetDamageByConstant(GetItemPropertyCostTableValue(ip),TRUE):0 ;
                iDmgType = GetItemPropertyParam1Value(ip);

                switch (iDmgType)
                {
                  case IP_CONST_DAMAGETYPE_ACID:
                    dAcid = iTemp > dAcid ? iTemp : dAcid;
                    break;
                  case IP_CONST_DAMAGETYPE_BLUDGEONING:
                    if (iDmg==DAMAGE_TYPE_BLUDGEONING)
                       iTemp = GetDamageByConstantBonus(GetItemPropertyCostTableValue(ip));
                    dBlud = iTemp > dBlud ? iTemp : dBlud;
                    break;
                  case IP_CONST_DAMAGETYPE_COLD:
                    dCold = iTemp > dCold ? iTemp : dCold;
                    break;
                  case IP_CONST_DAMAGETYPE_DIVINE:
                    dDiv = iTemp > dDiv ? iTemp : dDiv;
                    break;
                  case IP_CONST_DAMAGETYPE_ELECTRICAL:
                    dElec = iTemp > dElec ? iTemp : dElec;
                    break;
                  case IP_CONST_DAMAGETYPE_FIRE:
                    dFire = iTemp > dFire ? iTemp : dFire;
                    break;
                  case IP_CONST_DAMAGETYPE_MAGICAL:
                    dMag = iTemp > dMag ? iTemp : dMag;
                    break;
                  case IP_CONST_DAMAGETYPE_NEGATIVE:
                    dNeg = iTemp > dNeg ? iTemp : dNeg;
                    break;
                  case IP_CONST_DAMAGETYPE_PIERCING:
                    if (iDmg==DAMAGE_TYPE_PIERCING)
                        iTemp = GetDamageByConstantBonus(GetItemPropertyCostTableValue(ip));
                    dPierc = iTemp > dPierc ? iTemp : dPierc;
                    break;
                  case IP_CONST_DAMAGETYPE_POSITIVE:
                    dPos = iTemp > dPos ? iTemp : dPos;
                    break;
                  case IP_CONST_DAMAGETYPE_SLASHING:
                    if (iDmg==DAMAGE_TYPE_SLASHING)
                       iTemp = GetDamageByConstantBonus(GetItemPropertyCostTableValue(ip));
                    dSlash = iTemp > dSlash ? iTemp : dSlash;
                    break;
                  case IP_CONST_DAMAGETYPE_SONIC:
                    dSon = iTemp > dSon ? iTemp : dSon;
                    break;
                    
 
                }

                break;

            case ITEM_PROPERTY_DAMAGE_BONUS:
                iTemp = GetDamageByConstant(GetItemPropertyCostTableValue(ip), TRUE);
                iDmgType = GetItemPropertySubType(ip);

                switch (iDmgType)
                {
                  case IP_CONST_DAMAGETYPE_ACID:
                    dAcid = iTemp > dAcid ? iTemp : dAcid;
                    break;
                  case IP_CONST_DAMAGETYPE_BLUDGEONING:
                    if (iDmg==DAMAGE_TYPE_BLUDGEONING)
                       iTemp = GetDamageByConstantBonus(GetItemPropertyCostTableValue(ip));
                    dBlud = iTemp > dBlud ? iTemp : dBlud;
                    break;
                  case IP_CONST_DAMAGETYPE_COLD:
                    dCold = iTemp > dCold ? iTemp : dCold;
                    break;
                  case IP_CONST_DAMAGETYPE_DIVINE:
                    dDiv = iTemp > dDiv ? iTemp : dDiv;
                    break;
                  case IP_CONST_DAMAGETYPE_ELECTRICAL:
                    dElec = iTemp > dElec ? iTemp : dElec;
                    break;
                  case IP_CONST_DAMAGETYPE_FIRE:
                    dFire = iTemp > dFire ? iTemp : dFire;
                    break;
                  case IP_CONST_DAMAGETYPE_MAGICAL:
                    dMag = iTemp > dMag ? iTemp : dMag;
                    break;
                  case IP_CONST_DAMAGETYPE_NEGATIVE:
                    dNeg = iTemp > dNeg ? iTemp : dNeg;
                    break;
                  case IP_CONST_DAMAGETYPE_PIERCING:
                    if (iDmg==DAMAGE_TYPE_PIERCING)
                      iTemp = GetDamageByConstantBonus(GetItemPropertyCostTableValue(ip));
                    dPierc = iTemp > dPierc ? iTemp : dPierc;
                    break;
                  case IP_CONST_DAMAGETYPE_POSITIVE:
                    dPos = iTemp > dPos ? iTemp : dPos;
                    break;
                  case IP_CONST_DAMAGETYPE_SLASHING:
                    if (iDmg==DAMAGE_TYPE_SLASHING)
                        iTemp = GetDamageByConstantBonus(GetItemPropertyCostTableValue(ip));
                    dSlash = iTemp > dSlash ? iTemp : dSlash;
                    break;
                  case IP_CONST_DAMAGETYPE_SONIC:
                    dSon = iTemp > dSon ? iTemp : dSon;
                    break;
                    
  
                }

                break;


        }

        ip = GetNextItemProperty(oAmmu);
    }

    dAcid+=sDmg.dAcid ; dBlud+=sDmg.dBlud   ; dCold+=sDmg.dCold ; dDiv+=sDmg.dDiv     ;
    dFire+=sDmg.dFire ; dMag+=sDmg.dMag     ; dNeg+=sDmg.dNeg   ; dPierc+=sDmg.dPierc ;
    dPos+=sDmg.dPos   ; dSlash+=sDmg.dSlash ; dSon+=sDmg.dSon   ; dElec+=sDmg.dElec   ;

//SendMessageToPC(GetFirstPC(), "dBlud:"+IntToString(dBlud));
//SendMessageToPC(GetFirstPC(), "dPierc:"+IntToString(dPierc));
//SendMessageToPC(GetFirstPC(), "dSlash:"+IntToString(dSlash));
//SendMessageToPC(GetFirstPC(), "dDiv:"+IntToString(dDiv));

  if (dAcid>0)eLink=EffectLinkEffects(EffectLinkEffects(eLink,EffectDamage(dAcid,DAMAGE_TYPE_ACID,iEnhancement)),EffectVisualEffect(VFX_COM_HIT_ACID));
  if (dBlud>0)eLink=EffectLinkEffects(eLink,EffectDamage(dBlud,DAMAGE_TYPE_BLUDGEONING,iEnhancement));
  if (dCold>0)eLink=EffectLinkEffects(EffectLinkEffects(eLink,EffectDamage(dCold,DAMAGE_TYPE_COLD,iEnhancement)),EffectVisualEffect(VFX_COM_HIT_FROST ));
  if (dDiv>0)eLink=EffectLinkEffects(EffectLinkEffects(eLink,EffectDamage(dDiv,DAMAGE_TYPE_DIVINE,iEnhancement)),EffectVisualEffect(VFX_COM_HIT_DIVINE));
  if (dElec>0)eLink=EffectLinkEffects(EffectLinkEffects(eLink,EffectDamage(dElec,DAMAGE_TYPE_ELECTRICAL,iEnhancement)),EffectVisualEffect(VFX_COM_HIT_ELECTRICAL ));
  if (dFire>0)eLink=EffectLinkEffects(EffectLinkEffects(eLink,EffectDamage(dFire,DAMAGE_TYPE_FIRE,iEnhancement)),EffectVisualEffect(VFX_IMP_FLAME_S));
  if (dMag>0)eLink=EffectLinkEffects(EffectLinkEffects(eLink,EffectDamage(dMag,DAMAGE_TYPE_MAGICAL,iEnhancement)),EffectVisualEffect(VFX_COM_HIT_DIVINE));
  if (dNeg>0)eLink=EffectLinkEffects(EffectLinkEffects(eLink,EffectDamage(dNeg,DAMAGE_TYPE_NEGATIVE,iEnhancement)),EffectVisualEffect(VFX_COM_HIT_NEGATIVE ));
  if (dPierc>0)eLink=EffectLinkEffects(eLink,EffectDamage(dPierc,DAMAGE_TYPE_PIERCING,iEnhancement));
  if (dPos>0)eLink=EffectLinkEffects(EffectLinkEffects(eLink,EffectDamage(dPos,DAMAGE_TYPE_POSITIVE,iEnhancement)),EffectVisualEffect(VFX_COM_HIT_DIVINE));
  if (dSlash>0)eLink=EffectLinkEffects(eLink,EffectDamage(dSlash,DAMAGE_TYPE_SLASHING,iEnhancement));
  if (dSon>0)eLink=EffectLinkEffects(EffectLinkEffects(eLink,EffectDamage(dSon,DAMAGE_TYPE_SONIC,iEnhancement)),EffectVisualEffect(VFX_COM_HIT_SONIC ));

  return eLink;
}

struct iMultiDmg  DmgSpellEffect(int iCritiks , object oPC ,struct iMultiDmg iMDmg)
{

   int iCritik = (iCritiks >1) ? 2:1;

   effect eff,eDmg ;
   int nDam,eType,eSpellID;
   object eCrea;
   int iBonus;
   int iBlud,iDiv,iSlash,iMag,iPierc;
   int nCharismaBonus,nLvl;

   eff = GetFirstEffect(oPC);
   while (GetIsEffectValid(eff))
   {
      eType = GetEffectType(eff);

      if (eType == EFFECT_TYPE_DAMAGE_INCREASE)
      {
         eSpellID = GetEffectSpellId(eff);

         switch(eSpellID)
         {
            case SPELL_PRAYER:
                 // +1 slashing
                 iSlash+= iCritik;
                 break;

            case SPELL_WAR_CRY:
                // +2 slashing
                iSlash+= 2*iCritik;
                break;
                
            case SPELL_BATTLETIDE:
              iMag+= 2*iCritik;
              break;

            case SPELL_PA_POWERSHOT:
                // +2 slashing
                iSlash+= 5*iCritik;
                break;
                
            case SPELL_PA_IMP_POWERSHOT:
                // +2 slashing
                iSlash+= 10*iCritik;
                break;
                
            case SPELL_PA_SUP_POWERSHOT:
                // +2 slashing
                iSlash+= 15*iCritik;
                break;

            case SPELL_BARD_SONGS:
                // bludgeon
               eCrea =GetEffectCreator(eff);
               nDam = 1;
               if (GetIsObjectValid(eCrea))
               {
                  int nLvl = GetLevelByClass(CLASS_TYPE_BARD,eCrea);
                  int iPerform = GetSkillRank(SKILL_PERFORM,eCrea);
                  if (nLvl>=14 && iPerform>= 21)
                     nDam = 3;
                  else if (nLvl>= 3 && iPerform>= 9)
                    nDam = 2;

               }
               iBlud+= nDam*iCritik;
               break;

            case SPELL_DIVINE_MIGHT:
               // divine
               nDam = 1 + GetHasFeat(FEAT_EPIC_DIVINE_MIGHT, GetEffectCreator(eff));
               nCharismaBonus = GetAbilityModifier(ABILITY_CHARISMA,GetEffectCreator(eff))*nDam;
               nDam= nCharismaBonus >1 ? nCharismaBonus :1;
               iDiv+= nDam*iCritik;
               break;

            case SPELL_DIVINE_WRATH:
               //  magical
              nDam = 3;
              eCrea =GetEffectCreator(eff);
              nLvl = GetLevelByClass(CLASS_TYPE_DIVINECHAMPION,eCrea);
              nLvl = (nLvl / 5)-1;

              if (nLvl >6 )
                nDam = 15;
              else if (nLvl >5 )
                nDam = 12;
              else if (nLvl >4 )
                nDam = 10;
              else if (nLvl >3)
                nDam = 8;
              else if (nLvl >2)
                nDam = 6;
              else if (nLvl >1)
                nDam = 4;

              iMag+= nDam*iCritik;
              break;

            case SPELL_DIVINE_FAVOR:
              //  divine
              eCrea = GetEffectCreator(eff);

              nDam = 1;
              if (GetIsObjectValid(eCrea))
              {
                 nLvl = GetCastLvl (eCrea,SPELL_DIVINE_FAVOR,TYPE_DIVINE);
                 nDam = nLvl/3;
                 nDam = nDam <1 ? 1 :nDam ;
                 nDam = nDam >5 ? 5 :nDam ;
              }
              iDiv+= nDam*iCritik;
               break;
         }


      }
      else if (eType == EFFECT_TYPE_DAMAGE_DECREASE)
      {

         switch(eSpellID)
         {
            case SPELLABILITY_HOWL_DOOM:
            case SPELLABILITY_GAZE_DOOM:
            case SPELL_DOOM:
              iMag-= 2*iCritik;
              break;

            case SPELL_GHOUL_TOUCH:
              iMag-= 2*iCritik;
              break;

            case SPELL_BATTLETIDE:
              iMag-= 2*iCritik;
              break;

            case SPELL_PRAYER:
              // -1 slashing
              iSlash-= iCritik;
              break;

            case SPELL_SCARE:
              iMag-= 2*iCritik;
              break;

            case SPELL_HELLINFERNO:
              iMag-= 4*iCritik;
              break;

            case SPELL_CURSE_SONG:
              // bludgeon
              eCrea =GetEffectCreator(eff);
              nDam = 1;
              if (GetIsObjectValid(eCrea))
              {
                nLvl = GetLevelByClass(CLASS_TYPE_BARD,eCrea);
                int iPerform = GetSkillRank(SKILL_PERFORM,eCrea);
                if (nLvl>=14 && iPerform>= 21)
                   nDam = 3;
                else if (nLvl>= 3 && iPerform>= 9)
                   nDam = 2;
              }
              iBlud-= nDam*iCritik;
         }
      }

      eff = GetNextEffect(oPC);
   }

   iMDmg.dDiv   = iDiv;
   iMDmg.dMag   = iMag;
   iMDmg.Phys   = iBlud+ iSlash;

  return  iMDmg ;
}

