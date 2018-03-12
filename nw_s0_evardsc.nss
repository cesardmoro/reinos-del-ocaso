//::///////////////////////////////////////////////
//:: Evards Black Tentacles: Heartbeat
//:: NW_S0_EvardsB
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Upon entering the mass of rubbery tentacles the
    target is struck by 1d4 tentacles.  Each has
    a chance to hit of 5 + 1d20. If it succeeds then
    it does 2d6 damage and the target must make
    a Fortitude Save versus paralysis or be paralyzed
    for 1 round.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 23, 2001
//:://////////////////////////////////////////////
//:: GZ: Removed SR, its not there by the book

//:: modified by mr_bumpkin Dec 4, 2003 for PRC stuff
#include "spinc_common"


#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_CONJURATION);
 ActionDoCommand(SetAllAoEInts(SPELL_EVARDS_BLACK_TENTACLES,OBJECT_SELF, GetSpellSaveDC()));


     object oTarget;
    effect eParal = EffectParalyze();
    effect eDur = EffectVisualEffect(VFX_DUR_PARALYZED);
    effect eLink = EffectLinkEffects(eDur, eParal);
    effect eDam;

    int nMetaMagic = GetMetaMagicFeat();
    int nDamage;
    int nAC = GetAC(oTarget);
    int nHits = d4();
    int nRoll;
    float fDelay;


    oTarget = GetFirstInPersistentObject();
    while(GetIsObjectValid(oTarget))
    {
        nDamage = 0;
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_EVARDS_BLACK_TENTACLES));
            nDamage = 0;
            for (nHits = d4(); nHits > 0; nHits--)
            {
                fDelay = GetRandomDelay(0.75, 1.5);
                nRoll = 5 + d20();
                if(nRoll >= nAC)
                {
                    nDamage = nDamage + d6();
                    //Enter Metamagic conditions
                    if (CheckMetaMagic(nMetaMagic, METAMAGIC_MAXIMIZE))
                    {
                        nDamage = 12;//Damage is at max
                    }
                    else if (CheckMetaMagic(nMetaMagic, METAMAGIC_EMPOWER))
                    {
                        nDamage = nDamage + (nDamage/2); //Damage/Healing is +50%
                    }
                }
            }
        }
        if(nDamage > 0)
        {
            eDam = EffectDamage(nDamage, DAMAGE_TYPE_BLUDGEONING, DAMAGE_POWER_PLUS_TWO);
            DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
            if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, (GetSpellSaveDC()+ GetChangesToSaveDC(oTarget,(GetAreaOfEffectCreator()))), SAVING_THROW_TYPE_NONE, OBJECT_SELF, fDelay))
            {
                DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(1),FALSE));
            }
        }
        oTarget = GetNextInPersistentObject();
    }
    
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name

}
