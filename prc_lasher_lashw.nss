//::///////////////////////////////////////////////
//:: Lasher - Lashing Whip
//:://////////////////////////////////////////////
/*
*/
//:://////////////////////////////////////////////
//:: Created By: Flaming_Sword
//:: Created On: Sept 24, 2005
//:: Modified: Sept 29, 2005
//:://////////////////////////////////////////////

//compiler would completely crap itself unless this include was here
#include "inc_2dacache"
#include "spinc_common"

void main()
{
    object oPC = PRCGetSpellTargetObject();
    RemoveEffectsFromSpell(oPC, GetSpellId());
    ApplyEffectToObject(DURATION_TYPE_PERMANENT,
        SupernaturalEffect(
            EffectDamageIncrease(DAMAGE_BONUS_2, IP_CONST_DAMAGETYPE_PHYSICAL)
        ),
        oPC);

}
