//::///////////////////////////////////////////////
//:: Name Spells Handle - Include
//:: FileName j_inc_prespells
//:://////////////////////////////////////////////
/*
    Include for PHS_INC_SPELLHOK. The spell hook file, this is all the things
    like "Null magic area" or "wild magic area".

    Local integers are set on the areas, under names in the constants file.
*/
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//:://////////////////////////////////////////////

#include "PHS_INC_COMPNENT"
#include "PHS_INC_CONSTANT"

// Returns the integer set to sName on the module.
int PHS_GetModuleToggle(string sName);

// Checks if a paladin, or cleric, casting the spell has an item of divine focus.
int PHS_DivineFocusCheck(string sSpellName);

// This checks Blink effects - there is a 50% chance a spell just will not
// affect them! :-)
// - Of course, seeing eathreal (True Seeing, ETC) eliminates this
// - Returns TRUE if they pass the test, FALSE means that oTarget is blinked :-)
int PHS_BlinkCheck(object oTarget, object oCaster = OBJECT_SELF);

// This will check if the area is toggled to be wild magic, and if so, do random
// effects.
// * FALSE if wild magic check was failed, so something special happened
// * TRUE if the pass was sucessful, or no wild magic.
int PHS_WildMagicAreaSurge(object oCasterArea, object oCaster = OBJECT_SELF);

// Check for concentration - that is, if we don't concentrate, then something
// will happen, but this will not stop the spell cast operating.
// * Will not return anything. The in-built checks here will not stop the spell,
//   but will stop another that is being concentrated upon.
void PHS_SpecialConcentrationChecks(object oCaster = OBJECT_SELF);

// This makes sure the caster isn't in some kind of state that stops spells
// being cast.
// * TRUE means they passed, no bad effects
// * FALSE means some bad effect if possed on the caster.
int PHS_BreakConcentrationCheck(object oCastItem = OBJECT_INVALID, object oCaster = OBJECT_SELF);

// Returns the integer set to sName on the module.
int PHS_GetModuleToggle(string sName)
{
    return GetLocalInt(GetModule(), sName);
}

// Checks if a paladin, or cleric, casting the spell has an item of divine focus.
int PHS_DivineFocusCheck(string sSpellName)
{
    // Make sure it wasn't cast from an item
    if(GetIsObjectValid(GetSpellCastItem())) return TRUE;

    int iCasterClass = GetLastSpellCastClass();

    if(iCasterClass == CLASS_TYPE_CLERIC ||
       iCasterClass == CLASS_TYPE_PALADIN)
    {
        // If this returns FALSE, the focus failed.
        if(!PHS_SpellExactItem(PHS_ITEM_DIVINE_FOCUS, "Item of Divine Focus", sSpellName))
        {
            effect eVis = EffectVisualEffect(VFX_IMP_MAGIC_RESISTANCE_USE);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
            return FALSE;
        }
    }
    return TRUE;
}
// This checks Blink effects - there is a 50% chance a spell just will not
// affect them! :-)
// - Of course, seeing eathreal (True Seeing, ETC) eliminates this
// - Returns TRUE if they pass the test, FALSE means that oTarget is blinked :-)
int PHS_BlinkCheck(object oTarget, object oCaster = OBJECT_SELF)
{
    if(GetHasSpellEffect(PHS_SPELL_BLINK, oTarget))
    {
        // Spells which stop Blinking:
        if(!GetHasSpellEffect(PHS_SPELL_TRUE_SEEING, oCaster) &&
        // Hide effect - Trueseeing
           !GetItemHasItemProperty(GetItemInSlot(INVENTORY_SLOT_CARMOUR, oCaster), ITEM_PROPERTY_TRUE_SEEING))
        {
            // Make the 50% check
            if(d2() == 1)
            {
                // Pass!
                SendMessageToPC(oTarget, "Your blinking upset someones attempt to cast a spell at you");
                SendMessageToPC(oCaster, GetName(oTarget) + " was blinking, and was not in this plane at the time!");
                return FALSE;
            }
            // we don't report a pass - it is like Inside Knowledge, knowing
            // that they are blinking (yeah, right). It is really, just more
            // annoying, as many messages could possibly come up for many blinkers
        }
    }
    return TRUE;
}

// This will check if the area is toggled to be wild magic, and if so, do random
// effects.
// * FALSE if wild magic check was failed, so something special happened
// * TRUE if the pass was sucessful, or no wild magic.
int PHS_WildMagicAreaSurge(object oCasterArea, object oCaster = OBJECT_SELF)
{
    // Get if the area has the wildmagic check flag
    // - This is also the % for failure
    int nWildPercent = GetLocalInt(oCasterArea, "PHS_AREA_WILDMAGIC");
    int nDice;

    // Check if there is a 1% or higher failure rate
    if(nWildPercent > FALSE)
    {
        // Check dice
        nDice = d100();
        if(nDice <= nWildPercent)
        {
            // We fail! Floating text, damage, and visual
            // - Executed script
            ExecuteScript(PHS_WILD_MAGIC_SCRIPT, oCaster);
        }
    }
    return TRUE;
}
// Check for concentration - that is, if we don't concentrate, then something
// will happen.
// * Will not return anything. The in-built checks here will not stop the spell,
//   but will stop another that is being concentrated upon.
void PHS_SpecialConcentrationChecks(object oCaster = OBJECT_SELF)
{
    // * At the moment we got only one concentration spell, black blade of disaster

    object oAssoc = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oCaster);
    if (GetIsObjectValid(oAssoc) && GetIsPC(oCaster)) // only applies to PCS
    {
        if(GetTag(oAssoc) == "x2_s_bblade") // black blade of disaster
        {
            if (GetLocalInt(OBJECT_SELF,"X2_L_CREATURE_NEEDS_CONCENTRATION"))
            {
                SignalEvent(oAssoc,EventUserDefined(1));
            }
        }
    }
}

// This makes sure the caster isn't in some kind of state that stops spells
// being cast.
// * TRUE means they passed, no bad effects
// * FALSE means some bad effect if possed on the caster.
int PHS_BreakConcentrationCheck(object oCastItem = OBJECT_INVALID, object oCaster = OBJECT_SELF)
{
    // Cycle effects on the caster
    effect eCheck = GetFirstEffect(oCaster);
    // Check if it was an item being used for polymorph
    int nValidItem = FALSE;
    int nItemType = GetBaseItemType(oCastItem);
    if(nItemType == BASE_ITEM_SCROLL ||
       nItemType == BASE_ITEM_POTIONS ||
       nItemType == BASE_ITEM_ENCHANTED_POTION ||
       nItemType == BASE_ITEM_ENCHANTED_SCROLL)
    {
        nValidItem = TRUE;
    }
    // Check the type of the effects
    int nType;
    // Loop effects
    while(GetIsEffectValid(eCheck))
    {
        nType = GetEffectType(eCheck);

        // Note: Same as Bioware's check here
        // * Confusion - Is only meant to attack in melee, never cast
        if(nType == EFFECT_TYPE_STUNNED || nType == EFFECT_TYPE_PARALYZE ||
           nType == EFFECT_TYPE_SLEEP || nType == EFFECT_TYPE_FRIGHTENED ||
           nType == EFFECT_TYPE_PETRIFY || nType == EFFECT_TYPE_CONFUSED ||
           nType == EFFECT_TYPE_DOMINATED)
        {
            // * False means we have broken concentration
            return FALSE;
        }
        // * Polymorph - Stops the use of spells - but not potions!
        else if(nType == EFFECT_TYPE_POLYMORPH && nValidItem != TRUE)
        {
            // * False means we have broken concentration
            return FALSE;
        }
        eCheck = GetNextEffect(oCaster);
    }
    // * TRUE means successful pass
    return TRUE;
}
