//::///////////////////////////////////////////////
//:: Name      Necrotic Termination
//:: FileName  sp_nec_term.nss
//:://////////////////////////////////////////////
/** @file
        Necrotic Termination
    Necromancy [Evil]
    Level: Clr 9, sor/wiz 9
    Components: V, S, F, XP
    Casting Time: 1 standard action
    Range: Medium (100 ft. + 10 ft./level)
    Target: Living creature with necrotic cyst
    Duration: Instantaneous
    Saving Throw: Fortitude partial
    Spell Resistance: No

    You cause the cyst of a subject already harboring a necrotic cyst 
    (see spell of the same name) to physically and spiritually enlarge
    itself at the expense of the subject's body and soul. If the subject
    succeeds on her saving throw, she takes 1d6 points of damage per level
    (maximum 25d6), and half the damage is considered vile damage 
    (see necrotic bloat). The subject's cyst-derived saving throw penalty 
    against effects from the school of necromancy applies.

    If the subject fails her saving throw, the cyst expands beyond control, 
    killing the subject and digesting her soul. Raise dead, resurrection, 
    true resurrection, wish, and miracle cannot return life to the subject 
    once her soul is digested-she is gone forever. On the round following 
    the subject's death, the cyst exits the flesh of the slain subject as 
    a free-willed undead called a skulking cyst.

    XP Cost: 1,000 XP.

    Author:    Tenjac
    Created:   10/28/05
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "spinc_common" 
#include "spinc_necro_cyst"
#include "prc_inc_switch"
#include "inc_utility"
#include "prc_inc_spells"


//Check for XP
int GetHasXPToSpend(object oPC, int nCost)
{
    // To be TRUE, make sure that oPC wouldn't lose a level by spending nCost.
    int nHitDice = GetHitDice(oPC);
    int nHitDiceXP = (500 * nHitDice * (nHitDice - 1)); // simplification of the sum
    int nXP = GetXP(oPC);
    if(!GetIsPC(oPC))
        nXP = GetLocalInt(oPC, "NPC_XP");
    if (nXP >= (nHitDiceXP + nCost))
        return TRUE;
    return FALSE;
}

//Spend XP
void SpendXP(object oPC, int nCost)
{
    if (nCost > 0)
    {
        if(GetIsPC(oPC))
            SetXP(oPC, GetXP(oPC) - nCost);
        else
            SetLocalInt(oPC, "NPC_XP", GetLocalInt(oPC, "NPC_XP")-nCost);
    }
}

void main()
{
    // Set the spellschool
    SPSetSchool(SPELL_SCHOOL_NECROMANCY); 

    // Run the spellhook. 
    if (!X2PreSpellCastCode()) return;

    object oPC = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nLevel = min(PRCGetCasterLevel(oPC), 25);
    int nMetaMagic = PRCGetMetaMagicFeat();

    if(!GetCanCastNecroticSpells(oPC))
        return;

    if(!GetHasNecroticCyst(oTarget))
    {
        // "Your target does not have a Necrotic Cyst."
        SendMessageToPCByStrRef(oPC, nNoNecCyst);
        return;
    }
    //Check for perma-death
    if(GetPRCSwitch(PRC_NEC_TERM_PERMADEATH))
    {
          int nCost = 1000;
        //Check XP if perma-death enabled
        if(GetHasXPToSpend(oPC, nCost))
        {
            SpendXP(oPC, nCost);
        }
        else
        {
            SendMessageToPC(oPC, "You don't have enough experience to cast this spell");
            return;
        }
    }
    SPEvilShift(oPC);

    
    //Define nDC
    int nDC = SPGetSpellSaveDC(oTarget, oPC);     
    
    //Resolve spell
        
    if (PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_EVIL))
    {
    int nDam = d6(nLevel);
    
    //Metmagic: Maximize
    if (nMetaMagic == METAMAGIC_MAXIMIZE)
    {
        nDam = 6 * (nLevel);
    }
    
    //Metmagic: Empower
    if (nMetaMagic == METAMAGIC_EMPOWER)
    {
        nDam += (nDam/2);
    }
    
    int nVile = nDam/2;
    int nNorm = (nDam - nVile);
    //Vile damage is currently being applied as Positive damage
    effect eVileDam = EffectDamage(nVile, DAMAGE_TYPE_POSITIVE);
    effect eNormDam = EffectDamage(nNorm, DAMAGE_TYPE_MAGICAL);
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVileDam, oTarget); 
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eNormDam, oTarget);
    }

    else 
    {
        //Target SOL. Kill it.
        DeathlessFrenzyCheck(oTarget);
        effect eDeath = EffectDeath();
        effect eVis = EffectVisualEffect(VFX_IMP_DEATH);
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget);
        
        //Check for module perma-death
        if(GetPRCSwitch(PRC_NEC_TERM_PERMADEATH))
        {
            //Prevent revive
            SetLocalInt(oPC, "PERMA_DEAD", 1);
        }
        
        RemoveCyst(oTarget);
    }
    SPSetSchool(); 
}