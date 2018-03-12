//::///////////////////////////////////////////////
//:: Name x2_def_spawn
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Default On Spawn script


    2003-07-28: Georg Zoeller:

    If you set a ninteger on the creature named
    "X2_USERDEFINED_ONSPAWN_EVENTS"
    The creature will fire a pre and a post-spawn
    event on itself, depending on the value of that
    variable
    1 - Fire Userdefined Event 1510 (pre spawn)
    2 - Fire Userdefined Event 1511 (post spawn)
    3 - Fire both events

*/
//:://////////////////////////////////////////////
//:: Created By: Keith Warner, Georg Zoeller
//:: Created On: June 11/03
//:://////////////////////////////////////////////

const int EVENT_USER_DEFINED_PRESPAWN = 1510;
const int EVENT_USER_DEFINED_POSTSPAWN = 1511;


#include "x2_inc_switches"

void todosin(object oPC)
{
DelayCommand(90.0, ExecuteScript("borrarcriatura", OBJECT_SELF));
object oPri = GetFirstItemInInventory(oPC);
while(oPri != OBJECT_INVALID)
{
if(!(GetStringLeft(GetTag(oPri), 6) == "Cuerpo"))
{
SetDroppableFlag(oPri, FALSE);
SetPlotFlag(oPri, FALSE);
}
oPri = GetNextItemInInventory(oPC);
}

SetDroppableFlag(GetItemInSlot(INVENTORY_SLOT_ARMS, oPC), FALSE);
SetDroppableFlag(GetItemInSlot(INVENTORY_SLOT_ARROWS, oPC), FALSE);
SetDroppableFlag(GetItemInSlot(INVENTORY_SLOT_BELT, oPC), FALSE);
SetDroppableFlag(GetItemInSlot(INVENTORY_SLOT_BOLTS, oPC), FALSE);
SetDroppableFlag(GetItemInSlot(INVENTORY_SLOT_BOOTS, oPC), FALSE);
SetDroppableFlag(GetItemInSlot(INVENTORY_SLOT_BULLETS, oPC), FALSE);
SetDroppableFlag(GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPC), FALSE);
SetDroppableFlag(GetItemInSlot(INVENTORY_SLOT_CHEST, oPC), FALSE);
SetDroppableFlag(GetItemInSlot(INVENTORY_SLOT_CLOAK, oPC), FALSE);
SetDroppableFlag(GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oPC), FALSE);
SetDroppableFlag(GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oPC), FALSE);
SetDroppableFlag(GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oPC), FALSE);
SetDroppableFlag(GetItemInSlot(INVENTORY_SLOT_HEAD, oPC), FALSE);
SetDroppableFlag(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC), FALSE);
SetDroppableFlag(GetItemInSlot(INVENTORY_SLOT_LEFTRING, oPC), FALSE);
SetDroppableFlag(GetItemInSlot(INVENTORY_SLOT_NECK, oPC), FALSE);
SetDroppableFlag(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC), FALSE);
SetDroppableFlag(GetItemInSlot(INVENTORY_SLOT_RIGHTRING, oPC), FALSE);

//}


}
void main()
{
    todosin(OBJECT_SELF);
    SetLootable(OBJECT_SELF, TRUE);
    if(GetLocalInt(OBJECT_SELF, "fantasma") == 1)
    {
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_DUR_GHOSTLY_VISAGE), OBJECT_SELF);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectMissChance(50), OBJECT_SELF);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectConcealment(50), OBJECT_SELF);

    }
    if(GetRacialType(OBJECT_SELF) == RACIAL_TYPE_UNDEAD)
    {
    effect eAppear = EffectVisualEffect(VFX_FNF_SUMMON_UNDEAD);
    if(GetHitDice(OBJECT_SELF) > 20)
    {
    eAppear = EffectVisualEffect(VFX_FNF_SUMMON_EPIC_UNDEAD);
    }
    DelayCommand(0.1, ApplyEffectToObject(DURATION_TYPE_INSTANT, eAppear, OBJECT_SELF));
    }
    if(GetSkillRank(SKILL_HIDE, OBJECT_SELF) > 10)
    {
    SetActionMode(OBJECT_SELF, ACTION_MODE_STEALTH, TRUE);
    }
    int masini;
    if(GetHasFeat(FEAT_EPIC_SUPERIOR_INITIATIVE, OBJECT_SELF) == TRUE)
    {
    masini = masini + 4;
    }
    if(GetHasFeat(FEAT_IMPROVED_INITIATIVE, OBJECT_SELF) == TRUE)
    {
    masini = masini +4;
    }

    if(GetLocalInt(GetArea(OBJECT_SELF), "ini") > d20(1)+GetAbilityModifier(ABILITY_DEXTERITY, OBJECT_SELF)+masini)
    {
    effect ePara = EffectCutsceneParalyze();
    DelayCommand(0.8, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePara, OBJECT_SELF, 6.0));
    }

    // User defined OnSpawn event requested?
    int nSpecEvent = GetLocalInt(OBJECT_SELF,"X2_USERDEFINED_ONSPAWN_EVENTS");

    // Pre Spawn Event requested
    if (nSpecEvent == 1  || nSpecEvent == 3  )
    {
    SignalEvent(OBJECT_SELF,EventUserDefined(EVENT_USER_DEFINED_PRESPAWN ));
    }

    /*  Fix for the new golems to reduce their number of attacks */

    int nNumber = GetLocalInt(OBJECT_SELF,CREATURE_VAR_NUMBER_OF_ATTACKS);
    if (nNumber >0 )
    {
        SetBaseAttackBonus(nNumber);
    }

    object oPC = OBJECT_SELF;
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectSkillIncrease(SKILL_DISCIPLINE, (GetBaseAttackBonus(oPC)+10+GetAbilityModifier(ABILITY_STRENGTH, oPC)) - (GetSkillRank(SKILL_DISCIPLINE, oPC))), OBJECT_SELF);

    // Execute default OnSpawn script.
    ExecuteScript("nw_c2_default9b", OBJECT_SELF);


    //Post Spawn event requeste
    if (nSpecEvent == 2 || nSpecEvent == 3)
    {
    SignalEvent(OBJECT_SELF,EventUserDefined(EVENT_USER_DEFINED_POSTSPAWN));
    }

}
