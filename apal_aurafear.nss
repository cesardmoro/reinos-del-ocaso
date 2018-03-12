//::///////////////////////////////////////////////
//:: Aura of Fear
//:: NW_S1_AuraFear.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Upon entering the aura of the creature the player
    must make a will save or be struck with fear because
    of the creatures presence.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 25, 2001
//:://////////////////////////////////////////////

#include "prc_alterations"

void main()
{
 
    if(GetHasSpellEffect(SPELL_ANTIPAL_AURAFEAR))
    {
        RemoveEffectsFromSpell(OBJECT_SELF,SPELL_ANTIPAL_AURAFEAR);
        return;
    }
    
    effect eImmu = EffectImmunity(IMMUNITY_TYPE_FEAR);
    //Set and apply AOE object
    effect eAOE = ExtraordinaryEffect(EffectAreaOfEffect(AOE_MOB_DRAGON_FEAR,"apal_aurafeara","","apal_aurafearb"));
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eAOE, OBJECT_SELF);   

    ApplyEffectToObject(DURATION_TYPE_PERMANENT,ExtraordinaryEffect(eImmu), OBJECT_SELF);
}
