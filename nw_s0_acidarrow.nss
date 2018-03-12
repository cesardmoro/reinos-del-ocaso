//::///////////////////////////////////////////////
//:: Melf's Acid Arrow
//:: MelfsAcidArrow.nss
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
/*
    An acidic arrow springs from the caster's hands
    and does 3d6 acid damage to the target.  For
    every 3 levels the caster has the target takes an
    additional 1d6 per round.
*/
/////////////////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Aidan Scanlan
//:: Created On: 01/09/01
//:://////////////////////////////////////////////
//:: Rewritten: Georg Zoeller, Oct 29, 2003
//:: Now uses VFX to track its own duration, cutting
//:: down the impact on the CPU to 1/6th
//:://////////////////////////////////////////////


//:: modified by mr_bumpkin Dec 4, and 15, 2003
#include "spinc_common"
#include "x2_i0_spells"



void RunImpact(object oTarget, object oCaster, int nMetamagic,int EleDmg);

void main()
{

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_CONJURATION);

   object oTarget = GetSpellTargetObject();

    //--------------------------------------------------------------------------
    // Spellcast Hook Code
    // Added 2003-06-20 by Georg
    // If you want to make changes to all spells, check x2_inc_spellhook.nss to
    // find out more
    //--------------------------------------------------------------------------
    if (!X2PreSpellCastCode())
    {
        return;
    }
    // End of Spell Cast Hook

    //--------------------------------------------------------------------------
    // This spell no longer stacks. If there is one of that type, thats ok
    //--------------------------------------------------------------------------


    //--------------------------------------------------------------------------
    // Calculate the duration
    //--------------------------------------------------------------------------
    int nMetaMagic = GetMetaMagicFeat();
    int CasterLvl = PRCGetCasterLevel(OBJECT_SELF);
    int EleDmg = SPGetElementalDamageType(DAMAGE_TYPE_ACID);
        CasterLvl +=SPGetPenetr();
    int nDuration = (CasterLvl/3);

    if (CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND))
    {
       nDuration = nDuration * 2;
    }

    if (nDuration < 1)
    {
        nDuration = 1;
    }


    //--------------------------------------------------------------------------
    // Setup VFX
    //--------------------------------------------------------------------------
    effect eVis      = EffectVisualEffect(VFX_IMP_ACID_L);
    effect eDur      = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eArrow = EffectVisualEffect(245);


    //--------------------------------------------------------------------------
    // Set the VFX to be non dispelable, because the acid is not magic
    //--------------------------------------------------------------------------
    eDur = ExtraordinaryEffect(eDur);
     // * Dec 2003- added the reaction check back i
    if (GetIsReactionTypeFriendly(oTarget) == FALSE)
    {
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));

        float fDist = GetDistanceToObject(oTarget);
        float fDelay = (fDist/25.0);//(3.0 * log(fDist) + 2.0);


        if(MyPRCResistSpell(OBJECT_SELF, oTarget,CasterLvl) == FALSE)
        {
            //----------------------------------------------------------------------
            // Do the initial 3d6 points of damage
            //----------------------------------------------------------------------
            int nDamage = MyMaximizeOrEmpower(6,3,nMetaMagic);
            effect eDam = EffectDamage(nDamage, EleDmg);

            DelayCommand(fDelay,SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
            DelayCommand(fDelay,SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));

            //----------------------------------------------------------------------
            // Apply the VFX that is used to track the spells duration
            //----------------------------------------------------------------------
            DelayCommand(fDelay,SPApplyEffectToObject(DURATION_TYPE_TEMPORARY,eDur,oTarget,RoundsToSeconds(nDuration),FALSE));
            object oSelf = OBJECT_SELF; // because OBJECT_SELF is a function
            DelayCommand(6.0f,RunImpact(oTarget, oSelf,nMetaMagic,EleDmg));
        }
        else
        {
            //----------------------------------------------------------------------
            // Indicate Failure
            //----------------------------------------------------------------------
            effect eSmoke = EffectVisualEffect(VFX_IMP_REFLEX_SAVE_THROW_USE);
            DelayCommand(fDelay+0.1f,SPApplyEffectToObject(DURATION_TYPE_INSTANT,eSmoke,oTarget));
        }
    }
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eArrow, oTarget);

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name

}


void RunImpact(object oTarget, object oCaster, int nMetaMagic,int EleDmg)
{
    //--------------------------------------------------------------------------
    // Check if the spell has expired (check also removes effects)
    //--------------------------------------------------------------------------
    if (GZGetDelayedSpellEffectsExpired(SPELL_MELFS_ACID_ARROW,oTarget,oCaster))
    {
        return;
    }

    if (GetIsDead(oTarget) == FALSE)
    {
        //----------------------------------------------------------------------
        // Calculate Damage
        //----------------------------------------------------------------------
        int nDamage = MyMaximizeOrEmpower(6,1,nMetaMagic);
        effect eDam = EffectDamage(nDamage, EleDmg);
        effect eVis = EffectVisualEffect(VFX_IMP_ACID_S);
        eDam = EffectLinkEffects(eVis,eDam); // flare up
        SPApplyEffectToObject (DURATION_TYPE_INSTANT,eDam,oTarget);
        DelayCommand(6.0f,RunImpact(oTarget,oCaster,nMetaMagic,EleDmg));
    }
}

