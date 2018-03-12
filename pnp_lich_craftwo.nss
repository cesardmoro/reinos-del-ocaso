//::///////////////////////////////////////////////
//:: Name        Lich
//:: FileName    pnp_lich_craft
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Created By: Shane Hennessy
//:: Created On:
//:://////////////////////////////////////////////
// summons the lich's creation device to allow
// the PC to advance their lich powers.

#include "prc_alterations"

void main()
{
    // effects
    effect eGatefx = EffectVisualEffect(VFX_FNF_SUMMON_GATE);
    effect eSumfx = EffectVisualEffect(VFX_FNF_UNDEAD_DRAGON);
    object oCraft = CreateObject(OBJECT_TYPE_PLACEABLE,"lichcrafting",PRCGetSpellTargetLocation());
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT,eGatefx,PRCGetSpellTargetLocation(),5.0);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT,eSumfx,PRCGetSpellTargetLocation());

    DelayCommand(60.0f, DestroyObject(oCraft));
}
