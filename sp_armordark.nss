// Armor of Darkness
// lvl 4
// +3 bonus to ac plus additional +1 per every 4 lvl of caster to max of +8 .
// Gives Darkvision , +2 save against holy , light , or good spells.


#include "prc_alterations"
#include "spinc_common"
//#include "x2_inc_spellhook"
//#include "x0_i0_spells"

void main()
{
    SPSetSchool(SPELL_SCHOOL_ABJURATION);
    int nCasterLvl = PRCGetCasterLevel();
    int nMetaMagic = GetMetaMagicFeat();
    float fDuration = SPGetMetaMagicDuration(TenMinutesToSeconds(nCasterLvl));

    int iAC = 3 + nCasterLvl/4;
    if (iAC >8)  iAC = 8;
    
    effect eAC=EffectACIncrease(iAC,AC_DEFLECTION_BONUS);
    effect eUltravision = EffectUltravision();
    effect eSaveG=EffectSavingThrowIncrease(2,SAVING_THROW_ALL,SAVING_THROW_TYPE_GOOD);
    effect eSaveD=EffectSavingThrowIncrease(2,SAVING_THROW_ALL,SAVING_THROW_TYPE_DIVINE);
    effect eVisual=EffectVisualEffect(VFX_DUR_PROT_SHADOW_ARMOR);

    effect eLinks=EffectLinkEffects(eAC,eUltravision);
           eLinks=EffectLinkEffects(eLinks,eSaveG);
           eLinks=EffectLinkEffects(eLinks,eSaveD);
           eLinks=EffectLinkEffects(eLinks, eVisual);

    object oTarget=GetSpellTargetObject();

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_MAGE_ARMOR));

    if(MyPRCGetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
    {
       effect eTurn=EffectTurnResistanceIncrease(4);
       eLinks=EffectLinkEffects(eLinks,eTurn);
    }

    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLinks, oTarget,fDuration);
    SPSetSchool();
}