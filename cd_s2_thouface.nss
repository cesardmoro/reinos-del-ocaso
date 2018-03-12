//::///////////////////////////////////////////////
//:: Thousand Faces
//:: no_sw_thouface
//:://////////////////////////////////////////////
/*
    Allows the Ninjamastah to appear as various
    NPCs of PC playable races.
*/
//:://////////////////////////////////////////////
//:: Created By: Tim Czvetics (NamelessOne)
//:: Created On: Dec 17, 2003
//:://////////////////////////////////////////////
//taken from
//::///////////////////////////////////////////////
//:: Name        Rak disguise
//:: FileName    race_rkdisguise
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Created By: Shane Hennessy
//:: Created On:
//:://////////////////////////////////////////////
// disguise for rak


#include "pnp_shft_poly"
#include "pnp_shft_main"

void main()
{
    int iSpell = GetSpellId();
    StoreAppearance(OBJECT_SELF);
    int nCurForm = GetAppearanceType(OBJECT_SELF);
    int nPCForm = GetTrueForm(OBJECT_SELF);

    // Switch to lich
    if (nPCForm == nCurForm)
    {
        //Determine subradial selection
        if(iSpell == SPELLABILITY_NS_DWARF)   //DWARF
        {
            effect eFx = EffectVisualEffect(VFX_IMP_MAGICAL_VISION);
            ApplyEffectToObject(DURATION_TYPE_INSTANT,eFx,OBJECT_SELF);
            DoDisguise(RACIAL_TYPE_DWARF);
        }
        else if (iSpell == SPELLABILITY_NS_ELF) //ELF
        {
            effect eFx = EffectVisualEffect(VFX_IMP_MAGICAL_VISION);
            ApplyEffectToObject(DURATION_TYPE_INSTANT,eFx,OBJECT_SELF);
            DoDisguise(RACIAL_TYPE_ELF);
        }
        else if (iSpell == SPELLABILITY_NS_HALF_ELF) //HALF_ELF
        {
            effect eFx = EffectVisualEffect(VFX_IMP_MAGICAL_VISION);
            ApplyEffectToObject(DURATION_TYPE_INSTANT,eFx,OBJECT_SELF);
            DoDisguise(RACIAL_TYPE_HALFELF);
        }
        else if (iSpell == SPELLABILITY_NS_HALF_ORC) //HALF_ORC
        {
            effect eFx = EffectVisualEffect(VFX_IMP_MAGICAL_VISION);
            ApplyEffectToObject(DURATION_TYPE_INSTANT,eFx,OBJECT_SELF);
            DoDisguise(RACIAL_TYPE_HALFORC);
        }
        else if (iSpell == SPELLABILITY_NS_HUMAN) //HUMAN
        {
            effect eFx = EffectVisualEffect(VFX_IMP_MAGICAL_VISION);
            ApplyEffectToObject(DURATION_TYPE_INSTANT,eFx,OBJECT_SELF);
            DoDisguise(RACIAL_TYPE_HUMAN);
        }
        else if (iSpell == SPELLABILITY_NS_GNOME) //GNOME
        {
            effect eFx = EffectVisualEffect(VFX_IMP_MAGICAL_VISION);
            ApplyEffectToObject(DURATION_TYPE_INSTANT,eFx,OBJECT_SELF);
            DoDisguise(RACIAL_TYPE_GNOME);
        }
        else if (iSpell == SPELLABILITY_NS_HALFLING) //HALFLING
        {
            effect eFx = EffectVisualEffect(VFX_IMP_MAGICAL_VISION);
            ApplyEffectToObject(DURATION_TYPE_INSTANT,eFx,OBJECT_SELF);
            DoDisguise(RACIAL_TYPE_HALFLING);
        }
        else if (iSpell == SPELLABILITY_NS_OFF) //RETURN TO ORIGINAL APPEARANCE
        {
            effect eFx = EffectVisualEffect(VFX_IMP_MAGICAL_VISION);
            ApplyEffectToObject(DURATION_TYPE_INSTANT,eFx,OBJECT_SELF);
            //re-use unshifter code from shifter instead
            //this will also remove complexities with lich/shifter characters
            SetShiftTrueForm(OBJECT_SELF);
            //SetCreatureAppearanceType(OBJECT_SELF,nPCForm);
        }
    }   
    else // Switch to PC
    {
        effect eFx = EffectVisualEffect(VFX_IMP_MAGICAL_VISION);
        ApplyEffectToObject(DURATION_TYPE_INSTANT,eFx,OBJECT_SELF);
        //re-use unshifter code from shifter instead
        //this will also remove complexities with lich/shifter characters
        SetShiftTrueForm(OBJECT_SELF);
        //SetCreatureAppearanceType(OBJECT_SELF,nPCForm);
        
    }
}    