//::///////////////////////////////////////////////
//:: Inferno
//:: x0_s0_inferno.nss
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Does 2d6 fire per round
    Duration: 1 round per level
*/
//:://////////////////////////////////////////////
//:: Created By: Aidan Scanlan
//:: Created On: 01/09/01
//:://////////////////////////////////////////////
//:: Rewritten: Georg Zoeller, 2003-Oct-19
//::            - VFX update
//::            - Spell no longer stacks with itself
//::            - Spell can now be dispelled
//::            - Spell is now much less cpu expensive

//:: altered by mr_bumpkin Dec 4, 2003 for prc stuff
#include "spinc_common"


#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"
#include "x2_i0_spells"

void RunImpact(object oTarget, object oCaster, int nMetamagic,int EleDmg);

void main()
{

    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_TRANSMUTATION);



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
    if (GetHasSpellEffect(GetSpellId(),oTarget) || GetHasSpellEffect(SPELL_COMBUST,oTarget))
    {
        FloatingTextStrRefOnCreature(100775,OBJECT_SELF,FALSE);
        return;
    }

    //--------------------------------------------------------------------------
    // Calculate the duration
    //--------------------------------------------------------------------------
    int nMetaMagic = GetMetaMagicFeat();
    int CasterLvl = PRCGetCasterLevel(OBJECT_SELF);
    int EleDmg = SPGetElementalDamageType(DAMAGE_TYPE_FIRE);

    int nDuration = CasterLvl ;
    int nPenetr =  CasterLvl + SPGetPenetr();

    if (CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND))
    {
       nDuration = nDuration * 2;
    }

    if (nDuration < 1)
    {
        nDuration = 1;
    }

    //--------------------------------------------------------------------------
    // Flamethrower VFX, thanks to Alex
    //--------------------------------------------------------------------------
    effect eRay      = EffectBeam(444,OBJECT_SELF,BODY_NODE_CHEST);
    effect eDur      = EffectVisualEffect(498);


    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));

    float fDelay = GetDistanceBetween(oTarget, OBJECT_SELF)/13;

    if(!MyPRCResistSpell(OBJECT_SELF, oTarget,nPenetr))
    {
        //----------------------------------------------------------------------
        // Engulf the target in flame
        //----------------------------------------------------------------------
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 3.0f,FALSE);


        //----------------------------------------------------------------------
        // Apply the VFX that is used to track the spells duration
        //----------------------------------------------------------------------
        DelayCommand(fDelay,SPApplyEffectToObject(DURATION_TYPE_TEMPORARY,eDur,oTarget,RoundsToSeconds(nDuration),FALSE));
        object oSelf = OBJECT_SELF; // because OBJECT_SELF is a function
        DelayCommand(fDelay+0.1f,RunImpact(oTarget, oSelf,nMetaMagic,EleDmg));
    }
    else
    {
        //----------------------------------------------------------------------
        // Indicate Failure
        //----------------------------------------------------------------------
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 2.0f,FALSE);
        effect eSmoke = EffectVisualEffect(VFX_IMP_REFLEX_SAVE_THROW_USE);
        DelayCommand(fDelay+0.3f,SPApplyEffectToObject(DURATION_TYPE_INSTANT,eSmoke,oTarget));
    }

}


void RunImpact(object oTarget, object oCaster, int nMetaMagic,int EleDmg)
{
    //--------------------------------------------------------------------------
    // Check if the spell has expired (check also removes effects)
    //--------------------------------------------------------------------------
    if (GZGetDelayedSpellEffectsExpired(446,oTarget,oCaster))
    {
        return;
    }

    if (GetIsDead(oTarget) == FALSE)
    {
        //----------------------------------------------------------------------
        // Calculate Damage
        //----------------------------------------------------------------------
        int nDamage = MyMaximizeOrEmpower(6,2,nMetaMagic);
        effect eDam = EffectDamage(nDamage, EleDmg);
        effect eVis = EffectVisualEffect(VFX_IMP_FLAME_S);
        eDam = EffectLinkEffects(eVis,eDam); // flare up
        SPApplyEffectToObject (DURATION_TYPE_INSTANT,eDam,oTarget);
        DelayCommand(6.0f,RunImpact(oTarget,oCaster,nMetaMagic,EleDmg));
    }

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Erasing the variable used to store the spell's spell school
}

