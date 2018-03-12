#include "prc_alterations"

const int DISEASE_TALONAS_BLIGHT = 52;

void AnimalCompanion()
{

   if (GetMaxHenchmen() < 5)
   {
      SetMaxHenchmen(5);
   }
   
// add
    location loc = GetLocation(OBJECT_SELF);
    vector vloc = GetPositionFromLocation( loc );
    vector vLoc;
    location locSummon;

    vLoc = Vector( vloc.x + (Random(6) - 2.5f),
                       vloc.y + (Random(6) - 2.5f),
                       vloc.z );
        locSummon = Location( GetArea(OBJECT_SELF), vLoc, IntToFloat(Random(361) - 180) );

//

    object oPC = OBJECT_SELF;
    int nClass = GetLevelByClass(CLASS_TYPE_ULTIMATE_RANGER);
    string sRef ;
    
    if (nClass >= 30) sRef = "acomep_winwolf";
    else  sRef = "acomp_winwolf";
    
    object oAni = CreateObject(OBJECT_TYPE_CREATURE,sRef,locSummon,TRUE);
    effect eVis = EffectVisualEffect(VFX_IMP_UNSUMMON);
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis, locSummon);
    
    int HD = GetHitDice(OBJECT_SELF);
    int i;
    for (i = 1; i < nClass; i++)
      LevelUpHenchman( oAni,CLASS_TYPE_MAGICAL_BEAST,TRUE,PACKAGE_ANIMAL);
      
    object oCreR=GetItemInSlot(INVENTORY_SLOT_CWEAPON_B,oAni);
    
    itemproperty ip = GetFirstItemProperty(oCreR);
    while (GetIsItemPropertyValid(ip))
    {
        RemoveItemProperty(oCreR, ip);
        ip = GetNextItemProperty(oCreR);
    }
    
    object oHide=GetItemInSlot(INVENTORY_SLOT_CARMOUR,oAni);
    int iStr,iDex;
    if (nClass >= 30)
    {
      iStr = (nClass-30)/2;
      iDex = (nClass-31)/2;
    }
    else
    {
      iStr = (nClass-4)/2;
      iDex = (nClass-5)/2;
    }
    
    /*
    int iStr = nClass - 1;
    
    
    if (nClass>= 18) iStr = nClass - 18;
    else  iStr = nClass - 5;
    
    if (iStr>12) iStr = 12;
    */
    if (iStr>0)
     AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyAbilityBonus(IP_CONST_ABILITY_STR,iStr),oHide);
    if (iDex>0)
     AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyAbilityBonus(IP_CONST_ABILITY_DEX,iDex),oHide);
        
    int Dmg = IP_CONST_MONSTERDAMAGE_1d6;
    int Enh = (nClass/5)+1;

    if (HD>24) {
       Dmg = IP_CONST_MONSTERDAMAGE_1d12;
          AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_COLD,IP_CONST_DAMAGEBONUS_1d12),oCreR);
    }
    else if (HD>16){ 
    	   AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_COLD,IP_CONST_DAMAGEBONUS_1d10),oCreR);
       Dmg = IP_CONST_MONSTERDAMAGE_1d10;
    }
    else if (HD>7) {
    	   AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_COLD,IP_CONST_DAMAGEBONUS_1d8),oCreR);
       Dmg = IP_CONST_MONSTERDAMAGE_1d8;}
    else{
       AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_COLD,IP_CONST_DAMAGEBONUS_1d6),oCreR);
       Dmg = IP_CONST_MONSTERDAMAGE_1d6;}
 
    AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyMonsterDamage(Dmg),oCreR);
    AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyAttackBonus(Enh),oCreR);  
    
    int iMax;
    int coneAbi = nClass/5;
    if ( coneAbi == 7) iMax = 1;
    else if ( coneAbi == 6) iMax = 2;
    else if ( coneAbi == 5) iMax = 3;
    else if ( coneAbi == 4) iMax = 4;
    else if ( coneAbi == 3) iMax = 5;
    else if ( coneAbi == 2) iMax = 6;
    else if ( coneAbi == 1) iMax = 7;
    
    if (iMax>0)
    {
      for (i = 1; i < iMax; i++)
         DecrementRemainingSpellUses(oAni,230);
    }
    SetLocalObject(OBJECT_SELF, "URANG",oAni);
    SetAssociateState(NW_ASC_HAVE_MASTER,TRUE,oAni);
    SetAssociateState(NW_ASC_DISTANCE_2_METERS);
    SetAssociateState(NW_ASC_DISTANCE_4_METERS, FALSE);
    SetAssociateState(NW_ASC_DISTANCE_6_METERS, FALSE);

    //Exalted Companion
    if (GetHasFeat(FEAT_EXALTED_COMPANION) && GetAlignmentGoodEvil(oPC) == ALIGNMENT_GOOD)
    {
        object oComp = GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION);
        int nHD = GetHitDice(oComp);
        int nResist;
        effect eDR;
        if (nHD >= 12)
        {
                eDR = EffectDamageReduction(10, DAMAGE_POWER_PLUS_THREE);
                nResist = 20;
        }
        else if (12 > nHD && nHD >= 8)
        {
                eDR = EffectDamageReduction(5, DAMAGE_POWER_PLUS_TWO);
                nResist = 20;
        }
        else if (8 > nHD && nHD >= 4)
        {
                eDR = EffectDamageReduction(5, DAMAGE_POWER_PLUS_ONE);
                nResist = 20;
        }
        else if (4 > nHD)
        {
                nResist = 5;
        }

        effect eAcid = EffectDamageResistance(DAMAGE_TYPE_ACID, nResist);
        effect eCold = EffectDamageResistance(DAMAGE_TYPE_COLD, nResist);
        effect eElec = EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, nResist);
        effect eVis = EffectUltravision();
        effect eLink = EffectLinkEffects(eDR, eAcid);
        eLink = EffectLinkEffects(eLink, eCold);
        eLink = EffectLinkEffects(eLink, eElec);
        eLink = EffectLinkEffects(eLink, eVis);
        eLink = SupernaturalEffect(eLink);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oComp);
    }

    //Talontar Blightlord's Illmaster
    if (GetLevelByClass(CLASS_TYPE_BLIGHTLORD, OBJECT_SELF) >= 2)
    {
        //Get the companion
        object oComp = GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION);
        //Get the companion's skin
        object oCompSkin = GetPCSkin(oComp);
        //Give the companion Str +4, Con +2, Wis -2, and Cha -2
        effect eStr = EffectAbilityIncrease(ABILITY_STRENGTH, 4);
        effect eCon = EffectAbilityIncrease(ABILITY_CONSTITUTION, 2);
        effect eWis = EffectAbilityDecrease(ABILITY_WISDOM, 2);
        effect eCha = EffectAbilityDecrease(ABILITY_CHARISMA, 2);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eStr, oCompSkin);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eCon, oCompSkin);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eWis, oCompSkin);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eCha, oCompSkin);
        //Get the companion's Hit Dice
        int iHD = GetHitDice(oComp);
        //Get the companion's constitution modifier
        int iCons = GetAbilityModifier(ABILITY_CONSTITUTION, oComp);
        //Compute the DC for this companion's blight touch
        int iDC = 10 + (iHD / 2) + iCons;
        //Create the onhit item property for causing the blight touch disease
        itemproperty ipBlightTouch = ItemPropertyOnHitProps(IP_CONST_ONHIT_DISEASE, iDC, DISEASE_TALONAS_BLIGHT);
        //Get the companion's creature weapons
        object oBite = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oComp);
        object oLClaw = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oComp);
        object oRClaw = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oComp);
        //Apply blight touch to each weapon
        if (GetIsObjectValid(oBite))
        {
            IPSafeAddItemProperty(oBite, ipBlightTouch);
        }
        if (GetIsObjectValid(oLClaw))
        {
            IPSafeAddItemProperty(oLClaw, ipBlightTouch);
        }
        if (GetIsObjectValid(oRClaw))
        {
            IPSafeAddItemProperty(oRClaw, ipBlightTouch);
        }
        //Get the companion's alignment
        int iCompLCA = GetAlignmentLawChaos(oComp);
        int iCompGEA = GetAlignmentGoodEvil(oComp);
        //Set PLANT immunities and add low light vision
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_CHARM_PERSON), oCompSkin);
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_DOMINATE_PERSON), oCompSkin);
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_HOLD_PERSON), oCompSkin);
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertySpellImmunitySpecific(IP_CONST_IMMUNITYSPELL_MASS_CHARM), oCompSkin);
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_MINDSPELLS), oCompSkin);
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_POISON), oCompSkin);
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_PARALYSIS), oCompSkin);
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_CRITICAL_HITS), oCompSkin);
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_DISEASE), oCompSkin);
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_BACKSTAB), oCompSkin);
        //Feat 354 is FEAT_LOWLIGHTVISION
        AddItemProperty(DURATION_TYPE_PERMANENT, PRCItemPropertyBonusFeat(354), oCompSkin);
        if (iCompLCA != ALIGNMENT_NEUTRAL)
        {
            AdjustAlignment(oComp, ALIGNMENT_NEUTRAL, 50);
        }
        if (iCompGEA != ALIGNMENT_EVIL)
        {
            AdjustAlignment(oComp, ALIGNMENT_EVIL, 80);
        }
    }


    AddHenchman(OBJECT_SELF,oAni);
}



void main()
{
    if (GetLevelByClass(CLASS_TYPE_ULTIMATE_RANGER))
    {

      object oDes =  GetLocalObject(OBJECT_SELF, "URANG");

      AssignCommand(oDes, SetIsDestroyable(TRUE));
      DestroyObject(oDes);
      DelayCommand(0.4,AnimalCompanion());
       return;
    }



}
