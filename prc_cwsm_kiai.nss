void main()
{

    object oPC = OBJECT_SELF;
    object oItem1 = GetItemInSlot(INVENTORY_SLOT_LEFTHAND);
    object oItem2 = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);

    int iCha = GetAbilityModifier(ABILITY_CHARISMA,oPC);
    int iDam;

    if(iCha <= 1){iDam = DAMAGE_BONUS_1;}
    if(iCha == 2){iDam = DAMAGE_BONUS_2;}
    if(iCha == 3){iDam = DAMAGE_BONUS_3;}
    if(iCha == 4){iDam = DAMAGE_BONUS_4;}
    if(iCha == 5){iDam = DAMAGE_BONUS_5;}
    if(iCha == 6){iDam = DAMAGE_BONUS_6;}
    if(iCha == 7){iDam = DAMAGE_BONUS_7;}
    if(iCha == 8){iDam = DAMAGE_BONUS_8;}
    if(iCha == 9){iDam = DAMAGE_BONUS_9;}
    if(iCha == 10){iDam = DAMAGE_BONUS_10;}
    if(iCha == 11){iDam = DAMAGE_BONUS_11;}
    if(iCha == 12){iDam = DAMAGE_BONUS_12;}
    if(iCha == 13){iDam = DAMAGE_BONUS_13;}
    if(iCha == 14){iDam = DAMAGE_BONUS_14;}
    if(iCha == 15){iDam = DAMAGE_BONUS_15;}
    if(iCha == 16){iDam = DAMAGE_BONUS_16;}
    if(iCha == 17){iDam = DAMAGE_BONUS_17;}
    if(iCha == 18){iDam = DAMAGE_BONUS_18;}
    if(iCha == 19){iDam = DAMAGE_BONUS_19;}
    if(iCha == 20){iDam = DAMAGE_BONUS_20;}

    //effect eAttackBonus = EffectAttackIncrease(iCha,ATTACK_BONUS_MISC);
    //effect eDamageBonus = EffectDamageIncrease(iDam,DAMAGE_TYPE_DIVINE);

    itemproperty pAB = ItemPropertyAttackBonus(iDam);
    itemproperty pDB = ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_DIVINE,iDam);

    //effect eLink = EffectLinkEffects(eAttackBonus,eDamageBonus);

    PlayVoiceChat(VOICE_CHAT_BATTLECRY1);

    //Dual Weilding
    if(GetIsObjectValid(oItem2) && GetIsObjectValid(oItem1))
    {
    AddItemProperty(DURATION_TYPE_TEMPORARY,pAB,oItem1,9.0f);
    AddItemProperty(DURATION_TYPE_TEMPORARY,pDB,oItem1,9.0f);
    AddItemProperty(DURATION_TYPE_TEMPORARY,pAB,oItem2,9.0f);
    AddItemProperty(DURATION_TYPE_TEMPORARY,pDB,oItem2,9.0f);
    }

    //One Weapon
    if(GetIsObjectValid(oItem2) && !GetIsObjectValid(oItem1))
    {
    AddItemProperty(DURATION_TYPE_TEMPORARY,pAB,oItem2,9.0f);
    AddItemProperty(DURATION_TYPE_TEMPORARY,pDB,oItem2,9.0f);
    }
}