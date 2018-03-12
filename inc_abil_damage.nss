//::///////////////////////////////////////////////
//:: Ability Damage special effects include
//:: inc_abil_damage
//:://////////////////////////////////////////////
/** @file
    Implements the special effects of an ability
    score falling down to 0 as according to PnP.

    Strength: Lies helpless on ground (knockdown)
    Dexterity: Paralyzed
    Constitution: Death
    Intelligence: Coma (knockdown)
    Wisdom: Coma (knockdown)
    Charisma: Coma (knockdown)


    This can be turned off with a switch in
    prc_inc_switches : PRC_NO_PNP_ABILITY_DAMAGE


    NOTE: Due to BioOptimization (tm), Dex reaching
    0 from above 3 when any other stat is already
    at 0 will result in Dex being considered
    restored at the same time the other stat is.

    This might be workable around, but not
    efficiently.
*/
//:://////////////////////////////////////////////
//:: Created By: Ornedan
//:: Created On: 09.04.2005
//:: Modified On: 25.06.2005
//:://////////////////////////////////////////////

/*
[00:55] <Stratovarius> yup
[00:56] <Stratovarius> well, something to add
[00:56] <Stratovarius> if KTTS reduces target to 0 (or would, i know NWN goes to 3)
[00:56] <Stratovarius> drop a cutscene paralyze on em
[00:56] <Stratovarius> and a long duration knockdown
[01:00] <Ornedan> 'k. And spawn a pseudo-hb on them to do recovery if they ever regain the mental stat
[01:01] <Ornedan> Also, test result: You lose spellcasting if your casting stat drops below the required, even if the reduction is a magical penalty
[01:03] <Stratovarius> you do? cool
*/

//////////////////////////////////////////////////
/* Internal constants                           */
//////////////////////////////////////////////////

const string VIRTUAL_ABILITY_SCORE   = "PRC_Virtual_Ability_Score_";
const string ABILITY_DAMAGE_SPECIALS = "PRC_Ability_Damage_Special_Effects_Flags";
const string ABILITY_DAMAGE_MONITOR  = "PRC_Ability_Monitor";
const int ABILITY_DAMAGE_EFFECT_PARALYZE  = 1;
const int ABILITY_DAMAGE_EFFECT_KNOCKDOWN = 2;


//////////////////////////////////////////////////
/* Function prototypes                          */
//////////////////////////////////////////////////

/**
 * Applies the ability damage to the given target. Handles the virtual loss of
 * ability scores below 3 and the effects of reaching 0 and making the damage
 * unhealable by standard means if requested.
 *
 *
 * @param oTarget          The creature about to take ability damage
 * @param nAbility         One of the ABILITY_* constants
 * @param nAmount          How much to reduce the ability score by
 * @param nDurationType    One of the DURATION_TYPE_* contants
 * @param bHealable        Whether the damage is healable by normal means or not.
 *                         Implemented by applying the damage as an iprop on the hide
 *
 * The following are passed to SPApplyEffectToObject:
 * @param fDuration        If temporary, the duration. If this is -1.0, the damage
 *                         will be applied so that it wears off at the rate of 1 point
 *                         per ingame day.
 * @param bDispellable     Is the effect dispellable? If FALSE, the system will delay
 *                         the application of the effect a short moment (10ms) to break
 *                         spellID association. This will make effects from the same
 *                         source stack with themselves.
 * @param nSpellID         ID of spell causing damage
 * @param nCasterLevel     Casterlevel of the effect being applied
 * @param oSource          Object causing the ability damage
 */
void ApplyAbilityDamage(object oTarget, int nAbility, int nAmount, int nDurationType, int bHealable = TRUE,
                        float fDuration = 0.0f, int bDispellable = FALSE, int nSpellID = -1, int nCasterLevel = -1, object oSource = OBJECT_SELF);

/**
 * Gets the amount of unhealable ability damage suffered by the creature to given ability
 *
 * @param oTarget          The creature whose unhealable ability damage to examine
 * @param nAbility         One of the ABILITY_* constants
 */
int GetUnhealableAbilityDamage(object oTarget, int nAbility);

/**
 * Removes the specified amount of normally unhealable ability damage from the target
 *
 * @param oTarget      The creature to restore
 * @param nAbility     Ability to restore, one of the ABILITY_* constants
 * @param nAmount      Amount to restore the ability by, should be > 0 for the function
 *                     to have any effect
 */
void RecoverUnhealableAbilityDamage(object oTarget, int nAbility, int nAmount);

/**
 * Sets the values of ability decrease on target's hide to be the same as the value
 * tracked on the target object itself. This is called with delay from ScrubPCSkin()
 * in order to synchronise the tracked value of unhealable damage with that actually
 * present on the hide.
 * Please call this if you do similar operations on the hide.
 *
 * @param oTarget The creature whose hide and tracked value to synchronise.
 */
void ReApplyUnhealableAbilityDamage(object oTarget);



// Internal function. Called by a threadscript. Handles checking if any ability that has reached 0 has been restored
void AbilityDamageMonitor();

// Dex needs special handling due to the way CutsceneParalyze works (sets Dex to 3)
void DoDexCheck(object oCreature, int bFirstPart = TRUE);


#include "inc_utility"
#include "inc_dispel"
#include "prc_inc_racial"


//////////////////////////////////////////////////
/* Function defintions                          */
//////////////////////////////////////////////////


void ApplyAbilityDamage(object oTarget, int nAbility, int nAmount, int nDurationType, int bHealable = TRUE,
                        float fDuration = 0.0f, int bDispellable = FALSE, int nSpellID = -1, int nCasterLevel = -1, object oSource = OBJECT_SELF)
{
    // Immunity check
    if(GetIsImmune(oTarget, IMMUNITY_TYPE_ABILITY_DECREASE, oSource))
        return;

    // Get the value of the stat before anything is done
    int nStartingValue = GetAbilityScore(oTarget, nAbility);

    // First, apply the whole damage as an effect
    //SendMessageToPC(GetFirstPC(), "Applying " + IntToString(nAmount) + " damage to stat " + IntToString(nAbility));
    if(bHealable)
    {
        // Is the damage temporary and specified to heal at the PnP rate
        if(nDurationType == DURATION_TYPE_TEMPORARY && fDuration == -1.0f)
        {
            int i;
            for(; i < nAmount; i++)
                DelayCommand(0.01f, SPApplyEffectToObject(nDurationType, bDispellable ?
                                                                          EffectAbilityDecrease(nAbility, 1) :
                                                                          SupernaturalEffect(EffectAbilityDecrease(nAbility, 1)),
                                                          oTarget, HoursToSeconds(24) * i, bDispellable, nSpellID, nCasterLevel, oSource));
        }
        else if(!bDispellable)
        {
            DelayCommand(0.01f, SPApplyEffectToObject(nDurationType, SupernaturalEffect(EffectAbilityDecrease(nAbility, nAmount)),
                                                      oTarget, fDuration, bDispellable, nSpellID, nCasterLevel, oSource));
        }
        else
        {
            SPApplyEffectToObject(nDurationType, EffectAbilityDecrease(nAbility, nAmount),
                                  oTarget, fDuration, bDispellable, nSpellID, nCasterLevel, oSource);
        }
    }
    // Non-healable damage
    else
    {
        int nIPType;
        int nTotalAmount;
        string sVarName = "PRC_UnhealableAbilityDamage_";
        switch(nAbility)
        {
            case ABILITY_STRENGTH:      nIPType = IP_CONST_ABILITY_STR; sVarName += "STR"; break;
            case ABILITY_DEXTERITY:     nIPType = IP_CONST_ABILITY_DEX; sVarName += "DEX"; break;
            case ABILITY_CONSTITUTION:  nIPType = IP_CONST_ABILITY_CON; sVarName += "CON"; break;
            case ABILITY_INTELLIGENCE:  nIPType = IP_CONST_ABILITY_INT; sVarName += "INT"; break;
            case ABILITY_WISDOM:        nIPType = IP_CONST_ABILITY_WIS; sVarName += "WIS"; break;
            case ABILITY_CHARISMA:      nIPType = IP_CONST_ABILITY_CHA; sVarName += "CHA"; break;

            default:
                WriteTimestampedLogEntry("Unknown nAbility passed to ApplyAbilityDamage: " + IntToString(nAbility));
                return;
        }

        // Sum the damage being added with damage that was present previously
        nTotalAmount = GetLocalInt(oTarget, sVarName) + nAmount;

        // Apply the damage
        SetCompositeBonus(GetPCSkin(oTarget), sVarName, nTotalAmount, ITEM_PROPERTY_DECREASED_ABILITY_SCORE, nIPType);

        // Also store the amount of damage on the PC itself so it can be restored at a later date.
        SetLocalInt(oTarget, sVarName, nTotalAmount);

        // Schedule recovering if the damage is temporary
        if(nDurationType == DURATION_TYPE_TEMPORARY)
        {
            // If the damage is specified to heal at the PnP rate, schedule one point to heal per day
            if(fDuration == -1.0f)
            {
                int i;
                for(i = 1; i <= nAmount; i++)
                    DelayCommand(HoursToSeconds(24) * i, RecoverUnhealableAbilityDamage(oTarget, nAbility, 1));
            }
            // Schedule everything to heal at once
            else
                DelayCommand(fDuration, RecoverUnhealableAbilityDamage(oTarget, nAbility, nAmount));
        }
    }

    // The system is off by default
    if(!GetPRCSwitch(PRC_PNP_ABILITY_DAMAGE_EFFECTS))
        return;

    // If the target is at the minimum supported by NWN, check if they have had their ability score reduced below already
    if(nStartingValue == 3)
        nStartingValue = GetLocalInt(oTarget, VIRTUAL_ABILITY_SCORE + IntToString(nAbility)) ?
                          GetLocalInt(oTarget, VIRTUAL_ABILITY_SCORE + IntToString(nAbility)) - 1 :
                          nStartingValue;

    // See if any of the damage goes into the virtual area of score < 3
    if(nStartingValue - nAmount < 3)
    {
        int nVirtual = nStartingValue - nAmount;
        if(nVirtual < 0) nVirtual = 0;

        // Mark the virtual value
        SetLocalInt(oTarget, VIRTUAL_ABILITY_SCORE + IntToString(nAbility), nVirtual + 1);

        // Cause effects for being at 0
        if(nVirtual == 0)
        {
            // Apply the effects
            switch(nAbility)
            {
                // Lying down
                case ABILITY_STRENGTH:
                case ABILITY_INTELLIGENCE:
                case ABILITY_WISDOM:
                case ABILITY_CHARISMA:
                    // Do not apply duplicate effects
                    /*if(!(GetLocalInt(oTarget, ABILITY_DAMAGE_SPECIALS) & ABILITY_DAMAGE_EFFECT_PARALYZE))
                        ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectCutsceneParalyze(), oTarget);*/
                    if(!(GetLocalInt(oTarget, ABILITY_DAMAGE_SPECIALS) & ABILITY_DAMAGE_EFFECT_KNOCKDOWN))
                    {
                        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectKnockdown(), oTarget, 9999.0f);
                        SetLocalInt(oTarget, ABILITY_DAMAGE_SPECIALS, GetLocalInt(oTarget, ABILITY_DAMAGE_SPECIALS) | ABILITY_DAMAGE_EFFECT_KNOCKDOWN);
                    }
                    //break;

                // Paralysis
                case ABILITY_DEXTERITY:
                    // Do not apply duplicate effects
                    if(!(GetLocalInt(oTarget, ABILITY_DAMAGE_SPECIALS) & ABILITY_DAMAGE_EFFECT_PARALYZE))
                    {
                        ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectCutsceneParalyze(), oTarget);
                        SetLocalInt(oTarget, ABILITY_DAMAGE_SPECIALS, GetLocalInt(oTarget, ABILITY_DAMAGE_SPECIALS) | ABILITY_DAMAGE_EFFECT_PARALYZE);
                    }
                    break;

                // Death
                case ABILITY_CONSTITUTION:
                    // Non-constitution score critters avoid this one
                    if(!(MyPRCGetRacialType(oTarget) == RACIAL_TYPE_UNDEAD ||
                         MyPRCGetRacialType(oTarget) == RACIAL_TYPE_CONSTRUCT
                      ) )
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, SupernaturalEffect(EffectDeath()), oTarget);
                    break;

                default:
                    WriteTimestampedLogEntry("Unknown nAbility passed to ApplyAbilityDamage: " + IntToString(nAbility));
                    return;
            }

            // Start the monitor HB if it is not active yet
            if(GetThreadState(ABILITY_DAMAGE_MONITOR, oTarget) == THREAD_STATE_DEAD)
                SpawnNewThread(ABILITY_DAMAGE_MONITOR, "prc_abil_monitor", 1.0f, oTarget);

            // Note the ability score for monitoring
            SetLocalInt(oTarget, ABILITY_DAMAGE_MONITOR, GetLocalInt(oTarget, ABILITY_DAMAGE_MONITOR) | (1 << nAbility));
        }
    }
}


void AbilityDamageMonitor()
{
    object oCreature = OBJECT_SELF;
    int nMonitoredAbilities = GetLocalInt(oCreature, ABILITY_DAMAGE_MONITOR);
    int nEffects            = GetLocalInt(oCreature, ABILITY_DAMAGE_SPECIALS);

    //SendMessageToPC(GetFirstPC(), "Monitor running");

    // Check each of the monitored abilities
    if(nMonitoredAbilities & (1 << ABILITY_STRENGTH))
    {
        if(GetAbilityScore(oCreature, ABILITY_STRENGTH) > 3)
        {
            DeleteLocalInt(oCreature, VIRTUAL_ABILITY_SCORE + IntToString(ABILITY_STRENGTH));
            SetLocalInt(oCreature, ABILITY_DAMAGE_MONITOR, GetLocalInt(oCreature, ABILITY_DAMAGE_MONITOR) ^ (1 << ABILITY_STRENGTH));
            //SendMessageToPC(GetFirstPC(), "Strength healed");
        }
    }
    /*if(nMonitoredAbilities & (1 << ABILITY_DEXTERITY))
    {
        if(GetAbilityScore(oCreature, ABILITY_DEXTERITY) > 3)
        {
            DeleteLocalInt(oCreature, VIRTUAL_ABILITY_SCORE + IntToString(ABILITY_DEXTERITY));
            SetLocalInt(oCreature, ABILITY_DAMAGE_MONITOR, GetLocalInt(oCreature, ABILITY_DAMAGE_MONITOR) ^ (1 << ABILITY_DEXTERITY));
        }
    }*/
    if(nMonitoredAbilities & (1 << ABILITY_INTELLIGENCE))
    {
        if(GetAbilityScore(oCreature, ABILITY_INTELLIGENCE) > 3)
        {
            DeleteLocalInt(oCreature, VIRTUAL_ABILITY_SCORE + IntToString(ABILITY_INTELLIGENCE));
            SetLocalInt(oCreature, ABILITY_DAMAGE_MONITOR, GetLocalInt(oCreature, ABILITY_DAMAGE_MONITOR) ^ (1 << ABILITY_INTELLIGENCE));
            //SendMessageToPC(GetFirstPC(), "Int healed");
        }
    }
    if(nMonitoredAbilities & (1 << ABILITY_WISDOM))
    {
        if(GetAbilityScore(oCreature, ABILITY_WISDOM) > 3)
        {
            DeleteLocalInt(oCreature, VIRTUAL_ABILITY_SCORE + IntToString(ABILITY_WISDOM));
            SetLocalInt(oCreature, ABILITY_DAMAGE_MONITOR, GetLocalInt(oCreature, ABILITY_DAMAGE_MONITOR) ^ (1 << ABILITY_WISDOM));
            //SendMessageToPC(GetFirstPC(), "Wis healed");
        }
    }
    if(nMonitoredAbilities & (1 << ABILITY_CHARISMA))
    {
        if(GetAbilityScore(oCreature, ABILITY_CHARISMA) > 3)
        {
            DeleteLocalInt(oCreature, VIRTUAL_ABILITY_SCORE + IntToString(ABILITY_CHARISMA));
            SetLocalInt(oCreature, ABILITY_DAMAGE_MONITOR, GetLocalInt(oCreature, ABILITY_DAMAGE_MONITOR) ^ (1 << ABILITY_CHARISMA));
            //SendMessageToPC(GetFirstPC(), "Cha healed");
        }
    }

    // Check which effects, if any, need to be removed
    int bRemovePara, bRemoveKnock;
    nMonitoredAbilities = GetLocalInt(oCreature, ABILITY_DAMAGE_MONITOR);
    if(!(nMonitoredAbilities & (1 << ABILITY_STRENGTH)     ||
         nMonitoredAbilities & (1 << ABILITY_INTELLIGENCE) ||
         nMonitoredAbilities & (1 << ABILITY_WISDOM)       ||
         nMonitoredAbilities & (1 << ABILITY_CHARISMA)
      ) )
    {
        // Only remove effects if they are present
        if(nEffects & ABILITY_DAMAGE_EFFECT_KNOCKDOWN)
        {
            bRemoveKnock = TRUE;
            nEffects ^= ABILITY_DAMAGE_EFFECT_KNOCKDOWN;
        }
        if(!(nMonitoredAbilities & (1 << ABILITY_DEXTERITY)))
        {
            if(nEffects & ABILITY_DAMAGE_EFFECT_PARALYZE)
            {
                bRemovePara = TRUE;
                nEffects ^= ABILITY_DAMAGE_EFFECT_KNOCKDOWN;
            }
        }
        // Dex is the only remaining stat keeping CutscenePara on, so run the dexcheck
        else
            DelayCommand(0.1f, DoDexCheck(oCreature, TRUE));

        SetLocalInt(oCreature, ABILITY_DAMAGE_SPECIALS, nEffects);
    }

    //SendMessageToPC(GetFirstPC(), "bRemovePara:" + IntToString(bRemovePara));
    //SendMessageToPC(GetFirstPC(), "bRemoveKnock:" + IntToString(bRemoveKnock));

    // Do effect removal
    if(bRemovePara || bRemoveKnock)
    {
        effect eCheck = GetFirstEffect(oCreature);
        while(GetIsEffectValid(eCheck))
        {
            if(bRemovePara && GetEffectType(eCheck) == EFFECT_TYPE_CUTSCENE_PARALYZE){
                //SendMessageToPC(GetFirstPC(), "Removed para");
                RemoveEffect(oCreature, eCheck);
            }
            else if(bRemoveKnock && GetEffectType(eCheck) == 0){
                RemoveEffect(oCreature, eCheck);
                //SendMessageToPC(GetFirstPC(), "Removed knock");
            }
            eCheck = GetNextEffect(oCreature);
        }
    }
    //SendMessageToPC(GetFirstPC(), "Monitored abilities:" + IntToString(nMonitoredAbilities));

    // Stop the thread if there is nothing to monitor anymore
    if(!nMonitoredAbilities)
        TerminateCurrentThread();
}


void DoDexCheck(object oCreature, int bFirstPart = TRUE)
{
    // Remove CutscenePara
    if(bFirstPart)
    {
        effect eCheck = GetFirstEffect(oCreature);
        while(GetIsEffectValid(eCheck))
        {
            if(GetEffectType(eCheck) == EFFECT_TYPE_CUTSCENE_PARALYZE)
                RemoveEffect(oCreature, eCheck);
            eCheck = GetNextEffect(oCreature);
        }

        DelayCommand(0.1f, DoDexCheck(oCreature, FALSE));
        //SendMessageToPC(GetFirstPC(), "First part ran");
    }
    // Check if Dex is over 3 when it's gone
    else
    {
        // It is, so remove Dex from the monitored list
        if(GetAbilityScore(oCreature, ABILITY_DEXTERITY) > 3)
        {
            DeleteLocalInt(oCreature, VIRTUAL_ABILITY_SCORE + IntToString(ABILITY_DEXTERITY));
            SetLocalInt(oCreature, ABILITY_DAMAGE_MONITOR, GetLocalInt(oCreature, ABILITY_DAMAGE_MONITOR) ^ (1 << ABILITY_DEXTERITY));
            //SendMessageToPC(GetFirstPC(), "Dex check +");
        }
        /*else
            SendMessageToPC(GetFirstPC(), "Dex check -");*/

        // Apply CutscenePara back in either case. Next monitor call will remove it if it's supposed to be gone
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectCutsceneParalyze(), oCreature);
    }
}


int GetUnhealableAbilityDamage(object oTarget, int nAbility)
{
    int nIPType;
    string sVarName = "PRC_UnhealableAbilityDamage_";
    switch(nAbility)
    {
        case ABILITY_STRENGTH:      sVarName += "STR"; break;
        case ABILITY_DEXTERITY:     sVarName += "DEX"; break;
        case ABILITY_CONSTITUTION:  sVarName += "CON"; break;
        case ABILITY_INTELLIGENCE:  sVarName += "INT"; break;
        case ABILITY_WISDOM:        sVarName += "WIS"; break;
        case ABILITY_CHARISMA:      sVarName += "CHA"; break;

        default:
            WriteTimestampedLogEntry("Unknown nAbility passed to GetUnhealableAbilityDamage: " + IntToString(nAbility));
            return FALSE;
    }

    return GetLocalInt(oTarget, sVarName);
}


void RecoverUnhealableAbilityDamage(object oTarget, int nAbility, int nAmount)
{
    // Sanity check, one should not be able to cause more damage via this function, ApplyAbilityDamage() is for that.
    if(nAmount < 0) return;

    int nIPType, nNewVal;
    string sVarName = "PRC_UnhealableAbilityDamage_";
    switch(nAbility)
    {
        case ABILITY_STRENGTH:      nIPType = IP_CONST_ABILITY_STR; sVarName += "STR"; break;
        case ABILITY_DEXTERITY:     nIPType = IP_CONST_ABILITY_DEX; sVarName += "DEX"; break;
        case ABILITY_CONSTITUTION:  nIPType = IP_CONST_ABILITY_CON; sVarName += "CON"; break;
        case ABILITY_INTELLIGENCE:  nIPType = IP_CONST_ABILITY_INT; sVarName += "INT"; break;
        case ABILITY_WISDOM:        nIPType = IP_CONST_ABILITY_WIS; sVarName += "WIS"; break;
        case ABILITY_CHARISMA:      nIPType = IP_CONST_ABILITY_CHA; sVarName += "CHA"; break;

        default:
            WriteTimestampedLogEntry("Unknown nAbility passed to ApplyAbilityDamage: " + IntToString(nAbility));
            return;
    }

    nNewVal = GetLocalInt(oTarget, sVarName) - nAmount;
    if(nNewVal < 0) nNewVal = 0;

    SetCompositeBonus(GetPCSkin(oTarget), sVarName, nNewVal, ITEM_PROPERTY_DECREASED_ABILITY_SCORE, nIPType);
    SetLocalInt(oTarget, sVarName, nNewVal);
}


void ReApplyUnhealableAbilityDamage(object oTarget)
{
    object oSkin = GetPCSkin(oTarget);
    SetCompositeBonus(oSkin, "PRC_UnhealableAbilityDamage_STR",
                      GetLocalInt(oTarget, "PRC_UnhealableAbilityDamage_STR"),
                      ITEM_PROPERTY_DECREASED_ABILITY_SCORE, IP_CONST_ABILITY_STR);
    SetCompositeBonus(oSkin, "PRC_UnhealableAbilityDamage_DEX",
                      GetLocalInt(oTarget, "PRC_UnhealableAbilityDamage_DEX"),
                      ITEM_PROPERTY_DECREASED_ABILITY_SCORE, IP_CONST_ABILITY_DEX);
    SetCompositeBonus(oSkin, "PRC_UnhealableAbilityDamage_CON",
                      GetLocalInt(oTarget, "PRC_UnhealableAbilityDamage_CON"),
                      ITEM_PROPERTY_DECREASED_ABILITY_SCORE, IP_CONST_ABILITY_CON);
    SetCompositeBonus(oSkin, "PRC_UnhealableAbilityDamage_INT",
                      GetLocalInt(oTarget, "PRC_UnhealableAbilityDamage_INT"),
                      ITEM_PROPERTY_DECREASED_ABILITY_SCORE, IP_CONST_ABILITY_INT);
    SetCompositeBonus(oSkin, "PRC_UnhealableAbilityDamage_WIS",
                      GetLocalInt(oTarget, "PRC_UnhealableAbilityDamage_WIS"),
                      ITEM_PROPERTY_DECREASED_ABILITY_SCORE, IP_CONST_ABILITY_WIS);
    SetCompositeBonus(oSkin, "PRC_UnhealableAbilityDamage_CHA",
                      GetLocalInt(oTarget, "PRC_UnhealableAbilityDamage_CHA"),
                      ITEM_PROPERTY_DECREASED_ABILITY_SCORE, IP_CONST_ABILITY_CHA);
}

// Test main
//void main(){}
