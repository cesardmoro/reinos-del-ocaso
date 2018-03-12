//::///////////////////////////////////////////////
//:: Name      Energy Ebb
//:: FileName  sp_energy_ebb.nss
//:://////////////////////////////////////////////
/** @file

    Energy Ebb
    Necromancy (Evil)
    Cleric 7, Sorc/Wiz 7
    Duration 1 round/level
    Saving throw: Fortitude negates

    This spell functions like enervation except that
    the creature struck gains negative levels over an
    extended period. You point your finger and utter
    the incantation, releasing a black needle of
    crackling negative energy that suppresses the life
    force of any living creature it strikes. You must
    make a ranged touch attack to hit. If the attack
    succeeds, the subject immediately gains one negative
    level, then continues to gain another each round
    thereafter as her life force slowly bleeds away. The
    drain can only be stopped by a successful Heal check
    (DC 23) or the application of a heal, restoration, or
    greater restoration spell.

    If the black needle strikes an undead creature, that
    creature gains 4d4 * 5 temporary hp that last for up
    to 1 hour.


    Author:    Tenjac
    Created:   12/07/05
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////


#include "prc_alterations"
#include "spinc_common"
#include "prc_inc_spells"


void Ebb(object oTarget, int nRounds)
{
    //check duration
    if(nRounds < 1)
    {
        return;
    }

    effect eNegLev = EffectNegativeLevel(1);
    effect eDur = EffectVisualEffect(VFX_IMP_PULSE_NEGATIVE);
        effect eLink = EffectLinkEffects(eNegLev, eDur);

    //apply
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);

    //decrement duration
    nRounds--;

    //Reapply after 1 round
    DelayCommand(6.0f, Ebb(oTarget, nRounds));
}

void main()
{
    SPSetSchool(SPELL_SCHOOL_NECROMANCY);

    //Spellhook
    if (!X2PreSpellCastCode()) return;

    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);
    object oTarget = GetSpellTargetObject();
    int nMetaMagic = PRCGetMetaMagicFeat();

    //if undead
    if(MyPRCGetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
    {
        //roll temp hp
        int nHP = (d4(4) * 5);

        //give temp hp
        effect eHP = EffectTemporaryHitpoints(nHP);
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHP, oTarget, 3600.00);
    }

    //not undead
    else
    {
        int nDC = SPGetSpellSaveDC(oTarget, oPC);

        //Get nLevel = rounds remaining
        int nRounds = PRCGetCasterLevel(oPC);

        if (CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND))
        {
        nRounds = (nRounds * 2);
    }

        if (!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_NEGATIVE))
        {
        Ebb(oTarget, nRounds);
        }
    }

    //SPEvilShift(oPC);

    SPSetSchool();
}
