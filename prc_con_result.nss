/*
    this script is the result
    of golem crafting
    also used when checking the name of the product
*/
#include "prc_inc_craft"
#include "inc_utility"

void main()
{
    object oPC = OBJECT_SELF;
    string sResRef = PRCCraft_GetArguments();
    location lLimbo = PRC_GetLimbo();
    object oGolem = CreateObject(OBJECT_TYPE_CREATURE, sResRef, lLimbo);
    AssignCommand(oGolem, DelayCommand(0.5, SetIsDestroyable(TRUE)));
    DestroyObject(oGolem, 1.0);
    PRCCraft_SetCaption(GetName(oGolem)+" ("+IntToString(GetHitDice(oGolem))+" HD)");
    if(PRCCraft_GetConsume())
    {
        effect eSummon = SupernaturalEffect(EffectSummonCreature(sResRef));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSummon, oPC);
        persistant_array_create(oPC, "GolemList");
        persistant_array_set_string(oPC, "GolemList", persistant_array_get_size(oPC, "GolemList"), sResRef);
    }
}