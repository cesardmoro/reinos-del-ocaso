//::///////////////////////////////////////////////
//:: [Harm]
//:: [NW_S0_Harm.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Reduces target to 1d4 HP on successful touch
//:: attack.  If the target is undead it is healed.
//:://////////////////////////////////////////////
//:: Created By: Keith Soleski
//:: Created On: Jan 18, 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001
//:: Update Pass By: Preston W, On: Aug 1, 2001

//:: modified by mr_bumpkin Dec 4, 2003 for PRC stuff

//::Added code to maximize for Faith Healing and Blast Infidel
//::Aaon Graywolf - Jan 7, 2004

//#include "spinc_common"

#include "NW_I0_SPELLS"
#include "prc_inc_racial"
#include "x2_inc_spellhook"
#include "prc_add_spell_dc"

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
    object oTarget = GetSpellTargetObject();
    int nDamage, nHeal;
    int nModPorNivel = 10;
    int nMetaMagic = GetMetaMagicFeat();
    int nTouch = TouchAttackMelee(oTarget);
    int nCasterLvl = PRCGetCasterLevel(OBJECT_SELF);
    effect eVis = EffectVisualEffect(246);
    effect eVis2 = EffectVisualEffect(VFX_IMP_HEALING_G);
    effect eHeal, eDam;

    //Check for metamagic
    if (CheckMetaMagic(nMetaMagic, METAMAGIC_EMPOWER))
        nModPorNivel = 15;

    //Check that the target is undead
    if (MyPRCGetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
    {
        //Figure out the amount of damage to heal
        nHeal = nModPorNivel * nCasterLvl;
        //Set the heal effect
      if(nHeal > 150)
        nHeal = 150;
        eHeal = EffectHeal(nHeal);
        //Apply heal effect and VFX impact
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_HARM, FALSE));
    }
    else if (nTouch) //== TRUE) 1 or 2 are valid return numbers from TouchAttackMelee
    {
        if(!GetIsReactionTypeFriendly(oTarget))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_HARM));
            if (!MyResistSpell(OBJECT_SELF, oTarget))
            {
                //nDamage = GetCurrentHitPoints(oTarget) - d4(1);
                nDamage = nModPorNivel * nCasterLvl;
                if(nDamage > 150)
                    nDamage = 150;
                // will save for half damage and only drop to 1 hp
                if ( PRCMySavingThrow( SAVING_THROW_WILL, oTarget, ( GetSpellSaveDC()+ GetChangesToSaveDC(oTarget,OBJECT_SELF) ) ) != 0 )
                    nDamage /= 2;
                if( nDamage > GetCurrentHitPoints(oTarget) )
                    nDamage = GetCurrentHitPoints(oTarget) - 1;

                eDam = EffectDamage(nDamage,DAMAGE_TYPE_NEGATIVE);
                //Apply the VFX impact and effects
                DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            }
        }
    }

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name
}
