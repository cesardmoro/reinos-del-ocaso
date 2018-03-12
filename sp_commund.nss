#include "spinc_common"
#include "nigromancia_inc"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_NECROMANCY);

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
    object oTarget = PRCGetSpellTargetObject();

    if (GetRacialType(oTarget)==RACIAL_TYPE_UNDEAD)
    {
        effect eControl = EffectCutsceneDominated();
        effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DOMINATED);
        effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
        effect eVis = EffectVisualEffect(VFX_IMP_DOMINATE_S);
        effect eLink = EffectLinkEffects(eMind, eControl);
        eLink = EffectLinkEffects(eLink, eDur);

        int CasterLevel = PRCGetCasterLevel(OBJECT_SELF);
        int nMetaMagic = GetMetaMagicFeat();

        int nDuration = 24 * CasterLevel;

        //Make meta magic
        if (CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND))
        {
            nDuration *= 2;
        }

        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_CONTROL_UNDEAD));

        int nPenetr = CasterLevel + SPGetPenetr();
        if (!MyPRCResistSpell(OBJECT_SELF, oTarget, nPenetr))
        {
            //Make a Will save
            if (!/*Will Save*/ PRCMySavingThrow(SAVING_THROW_WILL, oTarget, (GetSpellSaveDC()+ GetChangesToSaveDC(oTarget,OBJECT_SELF)), SAVING_THROW_TYPE_NONE, OBJECT_SELF, 1.0) || GetAbilityScore(oTarget, ABILITY_INTELLIGENCE) < 4)
            {
                if (GetHasEffect(EFFECT_TYPE_DOMINATED, oTarget))
                {
                    effect efectoIterado = GetFirstEffect(oTarget);
                    while (GetIsEffectValid(efectoIterado))
                    {
                        if (GetEffectType(efectoIterado)==EFFECT_TYPE_DOMINATED)
                        {
                            object oVersus = GetEffectCreator(efectoIterado);
                            if (d20()+CasterLevel-10-GetLocalInt(oTarget, CommandUndead_lastCommanderCasterLevel_VN) > 0)
                            {
                                RemoveEffect(oTarget, efectoIterado);
                                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(nDuration));
                                SetLocalInt(oTarget, CommandUndead_lastCommanderCasterLevel_VN, CasterLevel);
                                DelayCommand(HoursToSeconds(nDuration), DeleteLocalInt(oTarget, CommandUndead_lastCommanderCasterLevel_VN));
                            }
                        }
                        efectoIterado = GetNextEffect(oTarget);
                    }
                }
                else
                {
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(nDuration));
                    SetLocalInt(oTarget, CommandUndead_lastCommanderCasterLevel_VN, CasterLevel);
                    DelayCommand(HoursToSeconds(nDuration), DeleteLocalInt(oTarget, CommandUndead_lastCommanderCasterLevel_VN));
                }
            }
        }
    }

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name
}
