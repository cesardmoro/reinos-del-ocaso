//::///////////////////////////////////////////////
//:: OnDeath NPC eventscript
//:: prc_npc_death
//:://////////////////////////////////////////////
#include "prc_alterations"
#include "prc_inc_clsfunc"
#include "inc_utility"
#include "prc_inc_death"


void main()
{
    ExecuteScript("prc_ondeath", OBJECT_SELF);
    /* Moved to prc_ondeath
    object oKiller = GetLastKiller();

    if(GetAbilityScore(OBJECT_SELF, ABILITY_INTELLIGENCE)>4)
    {
        LolthMeat(oKiller);
    }
    */

    if (GetLocalInt(OBJECT_SELF, "DestructionRetribution"))
    {

        if(DEBUG) DoDebug("Destruction Retribution firing. Dead creature = " + DebugObject2Str(OBJECT_SELF));

        int nDamage;
        int nHD = GetHitDice(OBJECT_SELF)/2;
        float fDelay;
        effect eExplode = EffectVisualEffect(VFX_FNF_LOS_EVIL_10); //Replace with Negative Pulse
        effect eVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
        effect eVisHeal = EffectVisualEffect(VFX_IMP_HEALING_M);
        effect eDam, eHeal;
        effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
        effect eDur2 = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

        location lTarget = PRCGetSpellTargetLocation();
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);
        object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget);
        while (GetIsObjectValid(oTarget))
        {
            // d6 for every 2 HD
            int n = 0;
            for(n=1;n<nHD;n++)
            {
                nDamage += d6();
            }
            // always does at least 1d6 damage.
            nDamage += d6();
            if(PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, 15, SAVING_THROW_TYPE_NEGATIVE))
            {
                nDamage /= 2;
            }
            //fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
            //cant use delay commands in an OnDeath event
            if (MyPRCGetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
            {
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_NEGATIVE_ENERGY_BURST));
                eHeal = EffectHeal(nDamage);
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget);
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVisHeal, oTarget);
                //DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget));
                //DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVisHeal, oTarget));
            }
            else if(MyPRCGetRacialType(oTarget) != RACIAL_TYPE_UNDEAD)
            {
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_NEGATIVE_ENERGY_BURST));
                eDam = EffectDamage(nDamage, DAMAGE_TYPE_NEGATIVE);
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                //DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                //DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
            }

        oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget);
        }
    }
    
    DoDied(OBJECT_SELF, FALSE);

    // Execute scripts hooked to this event for the NPC triggering it
    ExecuteAllScriptsHookedToEvent(OBJECT_SELF, EVENT_NPC_ONDEATH);
}