//::///////////////////////////////////////////////
//:: [Mass Charm]
//:: [NW_S0_MsCharm.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The caster attempts to charm a group of individuals
    who's HD can be no more than his level combined.
    The spell starts checking the area and those that
    fail a will save are charmed.  The affected persons
    are Charmed for 1 round per 2 caster levels.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 29, 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 10, 2001
//:: VFX Pass By: Preston W, On: June 22, 2001

//:: modified by mr_bumpkin Dec 4, 2003 for PRC stuff
#include "prc_alterations"

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"
#include "prc_class_const"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_ENCHANTMENT);
/*
  Spellcast Hook Code
  Added 2003-06-20 by Georg
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    object oTarget;
    effect eCharm = EffectCharmed();
    effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
    effect eImpact = EffectVisualEffect(VFX_FNF_LOS_NORMAL_20);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    effect eLink = EffectLinkEffects(eMind, eCharm);
    eLink = EffectLinkEffects(eLink, eDur);

    effect eVis = EffectVisualEffect(VFX_IMP_CHARM);
    int iSaveDC = GetLevelByClass(CLASS_TYPE_DISC_BAALZEBUL) + GetAbilityModifier(ABILITY_CHARISMA) + 10;
    int nCasterLevel = GetLevelByClass(CLASS_TYPE_DISC_BAALZEBUL);
    int nDuration = GetLevelByClass(CLASS_TYPE_DISC_BAALZEBUL);
    int nHD = GetLevelByClass(CLASS_TYPE_DISC_BAALZEBUL);
    int nCnt = 0;
    int nRacial;
    float fDelay;
    int nAmount = nHD * 2;


    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, GetSpellTargetLocation());

    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetSpellTargetLocation());
    while (GetIsObjectValid(oTarget) && nAmount > 0)
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
        {
            nRacial = MyPRCGetRacialType(oTarget);
            fDelay = GetRandomDelay();
            //Check that the target is humanoid or animal
            if  ((nRacial == RACIAL_TYPE_DWARF) ||
                (nRacial == RACIAL_TYPE_ELF) ||
                (nRacial == RACIAL_TYPE_GNOME) ||
                (nRacial == RACIAL_TYPE_HUMANOID_GOBLINOID) ||
                (nRacial == RACIAL_TYPE_HALFLING) ||
                (nRacial == RACIAL_TYPE_HUMAN) ||
                (nRacial == RACIAL_TYPE_HALFELF) ||
                (nRacial == RACIAL_TYPE_HALFORC) ||
                (nRacial == RACIAL_TYPE_HUMANOID_MONSTROUS) ||
                (nRacial == RACIAL_TYPE_HUMANOID_ORC) ||
                (nRacial == RACIAL_TYPE_HUMANOID_REPTILIAN))
            {
                //SpeakString(IntToString(nAmount) + " and HD of " + IntToString(GetHitDice(oTarget)));
                if(nAmount > GetHitDice(oTarget))
                {
                    //Fire cast spell at event for the specified target
                    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_MASS_CHARM, FALSE));
                    //Make an SR check
                    if (!MyPRCResistSpell(OBJECT_SELF, oTarget,nCasterLevel+SPGetPenetr()))
                    {
                        //Make a Will save to negate
                        if (!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, iSaveDC, SAVING_THROW_TYPE_MIND_SPELLS))
                        {
                            //Apply the linked effects and the VFX impact
                            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration)));
                            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                        }
                    }
                    //Add the creatures HD to the count of affected creatures
                    //nCnt = nCnt + GetHitDice(oTarget);
                    nAmount = nAmount - GetHitDice(oTarget);
                }
            }
        }
        //Get next target in spell area
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetSpellTargetLocation());
    }

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name
}
