#include "inc_utility"
#include "prc_class_const"

int GetIPDmg(int iDmg)
{
        switch(iDmg)
        {
            case 1:
                return DAMAGE_BONUS_1;
            case 2:
                return DAMAGE_BONUS_2;
            case 3:
                return DAMAGE_BONUS_3;
            case 4:
                return DAMAGE_BONUS_4;
            case 5:
                return DAMAGE_BONUS_5;
            case 6:
                return DAMAGE_BONUS_6;
            case 7:
                return DAMAGE_BONUS_7;
            case 8:
                return DAMAGE_BONUS_8;
            case 9:
                return DAMAGE_BONUS_9;
            case 10:
                return DAMAGE_BONUS_10;
            case 11:
                return DAMAGE_BONUS_11;
            case 12:
                return DAMAGE_BONUS_12;
            case 13:
                return DAMAGE_BONUS_13;
            case 14:
                return DAMAGE_BONUS_14;
            case 15:
                return DAMAGE_BONUS_15;
            case 16:
                return DAMAGE_BONUS_16;
            case 17:
                return DAMAGE_BONUS_17;
            case 18:
                return DAMAGE_BONUS_18;
            case 19:
                return DAMAGE_BONUS_19;
            case 20:
                return DAMAGE_BONUS_20;
        }

        return -1;
}


void main()
{
        int nWis = GetAbilityModifier(ABILITY_WISDOM)<1 ? 1 : GetAbilityModifier(ABILITY_WISDOM);
        int totDamage = nWis+GetLevelByClass(CLASS_TYPE_SACREDFIST,OBJECT_SELF);
        int iDivDmg = totDamage / 2; // round down
        int iFlmDmg = totDamage - iDivDmg; // round up

        if (iDivDmg > 20) iDivDmg = 20;
        if (iFlmDmg > 20) iFlmDmg = 20;
        
        iDivDmg = GetIPDmg(iDivDmg);
        iFlmDmg = GetIPDmg(iFlmDmg);

        effect eDmg = EffectDamageIncrease(iFlmDmg, DAMAGE_TYPE_FIRE);
        eDmg = EffectLinkEffects(eDmg,EffectDamageIncrease(iDivDmg,DAMAGE_TYPE_DIVINE));
        eDmg = EffectLinkEffects(eDmg, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
        eDmg = SupernaturalEffect(eDmg);

    effect eVFX = EffectVisualEffect(VFX_IMP_HOLY_AID );

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eDmg), OBJECT_SELF, TurnsToSeconds(1));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVFX, OBJECT_SELF);

}
