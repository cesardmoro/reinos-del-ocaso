#include "nw_i0_spells"

void main()
{
    object oCastingObject = OBJECT_SELF;
    object oPC = GetSpellTargetObject();
    
    string sBonus = GetLocalString(oCastingObject, "SET_COMPOSITE_STRING");
    
    int iVal     = GetLocalInt(oCastingObject, "SET_COMPOSITE_VALUE");
    int iSubType = GetLocalInt(oCastingObject, "SET_COMPOSITE_SUBTYPE");

    int iTotalR = GetLocalInt(oPC, "CompositeAttackBonusR");
    int iTotalL = GetLocalInt(oPC, "CompositeAttackBonusL");
    int iCur = GetLocalInt(oPC, sBonus);
    int iAB, iAP, iHand;

    RemoveEffectsFromSpell(oPC, GetSpellId());

    switch (iSubType)
    {
        case ATTACK_BONUS_MISC:
            iTotalR -= iCur;
            iTotalL -= iCur;
            if (iTotalR + iVal > 20) iVal = 20 - iTotalR;
            if (iTotalL + iVal > 20) iVal = 20 - iTotalL;
            iTotalR += iVal;
            iTotalL += iVal;
            break;
        case ATTACK_BONUS_ONHAND:
            iTotalR -= iCur;
            if (iTotalR + iVal > 20) iVal = 20 - iTotalR;
            iTotalR += iVal;
            break;
        case ATTACK_BONUS_OFFHAND:
            iTotalL -= iCur;
            if (iTotalL + iVal > 20) iVal = 20 - iTotalL;
            iTotalL += iVal;
            break;
    }           

    if (iTotalR > iTotalL)
    {
        iAB = iTotalR;
        iAP = iTotalR - iTotalL;
        iHand = ATTACK_BONUS_OFFHAND;
    }
    else
    {
        iAB = iTotalL;
        iAP = iTotalL - iTotalR;
        iHand = ATTACK_BONUS_ONHAND;
    }
    
    effect eAttackInc = EffectAttackIncrease(iAB);
    effect eAttackDec = EffectAttackDecrease(iAP, iHand);
    effect eAttack = EffectLinkEffects(eAttackInc, eAttackDec);

    eAttack = ExtraordinaryEffect(eAttack);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAttack, oPC, 9999.0);

    SetLocalInt(oPC, "CompositeAttackBonusR", iTotalR);
    SetLocalInt(oPC, "CompositeAttackBonusL", iTotalL);
    SetLocalInt(oPC, sBonus, iVal);
}