//::///////////////////////////////////////////////
//:: [Control Undead]
//:: [NW_S0_ConUnd.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
/*
    A single undead with up to 3 HD per caster level
    can be dominated.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Feb 2, 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk
//:: Last Updated On: April 6, 2001


//:: modified by mr_bumpkin Dec 4, 2003
#include "spinc_common"

#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"

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

    effect eControl = EffectCutsceneDominated();
    effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DOMINATED);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eVis = EffectVisualEffect(VFX_IMP_DOMINATE_S);
    effect eLink = EffectLinkEffects(eMind, eControl);
    eLink = EffectLinkEffects(eLink, eDur);

    int nMetaMagic = GetMetaMagicFeat();
    int CasterLvl = PRCGetCasterLevel(OBJECT_SELF);
    int nDuration = CasterLvl;
    int nHD = CasterLvl * 2;

    //Make meta magic
    if (CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND))
    {
        nDuration = CasterLvl * 2;
    }
    int nPenetr = CasterLvl + SPGetPenetr();

    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_LOS_EVIL_30), GetLocation(oTarget));

    int hdIterado;
    int hdControlados;
    int iterador;
    object objetoIterado = oTarget;
    while (GetDistanceBetween(objetoIterado, oTarget) <= 30.0) {
        hdIterado = GetHitDice(objetoIterado);
        if (MyPRCGetRacialType(objetoIterado) == RACIAL_TYPE_UNDEAD && (hdControlados+hdIterado) <= nHD)
        {
            if(!GetIsReactionTypeFriendly(objetoIterado))
            {
               //Fire cast spell at event for the specified target
               SignalEvent(objetoIterado, EventSpellCastAt(OBJECT_SELF, SPELL_CONTROL_UNDEAD));
               if (!MyPRCResistSpell(OBJECT_SELF, objetoIterado,nPenetr))
               {
                    //Make a Will save
                    if (!/*Will Save*/ PRCMySavingThrow(SAVING_THROW_WILL, objetoIterado, (GetSpellSaveDC()+ GetChangesToSaveDC(objetoIterado,OBJECT_SELF)), SAVING_THROW_TYPE_NONE, OBJECT_SELF, 1.0))
                    {
                        //Apply VFX impact and Link effect
                        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, objetoIterado);
                        DelayCommand(1.0, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, objetoIterado, TurnsToSeconds(nDuration),TRUE,-1,CasterLvl));
                        hdControlados += hdIterado;
                        //Increment HD affected count
                    }
                }
            }
        }
        iterador++;
        objetoIterado = GetNearestObject(OBJECT_TYPE_CREATURE, oTarget, iterador);
    }

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name
}
