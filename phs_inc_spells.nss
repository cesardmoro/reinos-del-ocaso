/*:://////////////////////////////////////////////
//:: Spells Include
//:: PHS_Inc_spells
//:://////////////////////////////////////////////
    Reference numbers, may be useful:

    1 foot = 0.32 meter.
    10 feet = 3.33M.

    // Diameter = What the D&D books use normally, so half for radius.
    float RADIUS_SIZE_SMALL           = 1.67f; 5 Feet
    float RADIUS_SIZE_MEDIUM          = 3.33f; 10 Feet
    float RADIUS_SIZE_LARGE           = 5.0f;  15 Feet
    float RADIUS_SIZE_HUGE            = 6.67f; 20 feet
    float RADIUS_SIZE_GARGANTUAN      = 8.33f; 25 Feet
    float RADIUS_SIZE_COLOSSAL        = 10.0f; 30 Feet

    int    SHAPE_SPELLCYLINDER      = 0;
    int    SHAPE_CONE               = 1;
    int    SHAPE_CUBE               = 2;
    int    SHAPE_SPELLCONE          = 3;
    int    SHAPE_SPHERE             = 4;
//::////////////////////////////////////////////*/

// All AOE functions
#include "PHS_INC_AOE"
// All Applying wrappers - EG for damage (for, say, Shield Other)
#include "PHS_INC_APPLY"
// All Array functions
#include "PHS_INC_ARRAY"
// All spell componant checks - gems, items ETC
#include "PHS_INC_COMPNENT"
// All new spell constants  (Includes polymorph and visuals includes)
#include "PHS_INC_CONSTANT"
// All difficulty functions (mainly not used)
#include "PHS_INC_DIFFICLT"
// All effect creating functions
#include "PHS_INC_EFFECTS"
// All Item Property checking, and adding
#include "PHS_INC_ITEMPROP"
// All removal things (RemoveEffect)
#include "PHS_INC_REMOVE"
// All resisting spell (ResistSpell) functions
#include "PHS_INC_RESIST"
// All spell save functions
#include "PHS_INC_SAVES"
// Spell hook (this includes, in itself, UMD and Pre-spells checks)
#include "PHS_INC_SPLLHOOK"
// All touch and Range touch attack functions
#include "PHS_INC_TOUCHAKK"
// All turning functions (Which normally stops spells)
#include "PHS_INC_TURNING"

const int PHS_ROUNDS = 1;
const int PHS_TURNS  = 2;
const int PHS_HOURS  = 3;

// This allows the application of a random delay to effects based on time
// parameters passed in.
// - Min default = 0.4, Max default = 1.1
float PHS_GetRandomDelay(float fMinimumTime = 0.4, float MaximumTime = 1.1);

// * Returns true if Target is a humanoid
int PHS_GetIsHumanoid(object oTarget = OBJECT_SELF);

// Totals the amount of items of sTag in oTargets inventory.
int PHS_TotalItemsOfBlueprint(object oTarget, string sBluePrint);
// Destroys all items of sBluePrint on oTarget.
void PHS_DestroyItemsOfBluePrint(object oTarget, string sBluePrint);

// This alerts all DM's of the spell being cast, and of names of targets
// also reports Caster Level and DC for save.
void PHS_AlertDMsOfSpell(string sName, int nSpellSaveDC, int nCasterLevel);

// checks for iEffect on oTarget
int PHS_GetHasEffect(int iEffect, object oTarget);
// checks for iEffect on oTarget, cast by oCaster.
int PHS_GetHasEffectFromCaster(int iEffect, object oTarget, object oCaster);
// checks for nSpellId on oTarget, cast by oCaster.
int PHS_GetHasSpellEffectFromCaster(int nSpellId, object oTarget, object oCaster);

// Wrapper for the signal event. Smaller :-P
// * Default to a HOSTILE spell. :-)
// * It uses OBJECT_SELF as the caster - this is the only drawback
// It uses SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell, bHarmful));
void PHS_SignalSpellCastAt(object oTarget, int nSpell, int bHarmful = TRUE);

// * returns true if oCreature does not have a mind
// XP1
int PHS_spellsIsMindless(object oCreature);
// * Returns true or false depending on whether the creature is flying
// * or not
// XP1
int PHS_spellsIsFlying(object oCreature);
// * returns true if the creature has flesh
// XP1
int PHS_spellsIsImmuneToPetrification(object oCreature);

// Bullrush attack
// - Uses oTarget's strength, add modifiers, against iCasterModifier.
// - Reports results to caster and target
int PHS_Bullrush(object oTarget, int iCasterModifier, object oCaster = OBJECT_SELF);
// Bullrush
// - Returns TRUE if oCreature is immune to bullrush
// - Oozes, for instance.
int PHS_ImmuneToBullrush(object oCreature);
// Bullrush
// * Returns the size modifier for bullrush in spells (XP1)
// +4 for every size over medium
// -4 for every size under medium. Medium = 0.
int PHS_GetSizeModifier(object oCreature);
// Bullrush
// * Returns TRUE if oCreature is steady.
//      - Has more then 2 legs
//      - Is steadying themselves by use of Defensive Casting or Expertise.
//      - Is steady by moving slowly around!
int PHS_GetIsSteady(object oCreature);
// Gets a location in a straight line, between oSouce and oTarget, adding fDistance.
location PHS_GetLocationBehind(object oSource, object oTarget, float fDistance);
// Gets a location in a straight line, between lSource and lTarget, adding fDistance.
location PHS_GetLocationBehindLocation(location lSource, location lTarget, float fDistance);

// can the creature be destroyed without breaking a plot
// - Immortal, Plot or DM returns FALSE.
int PHS_CanCreatureBeDestroyed(object oTarget);
// Returns TRUE if oTarget is an Minotaur
int PHS_GetIsMinotaur(object oTarget);

// Is oTarget in a maze area? (disables some spells)
int PHS_IsInMazeArea(object oTarget = OBJECT_SELF);
// Is oTarget in a Imprisonment area? (only used to check to jump back really)
int PHS_IsInPrisonArea(object oTarget = OBJECT_SELF);

// Returns TRUE if oTarget is an Ethereal, or an Ethereal creature
int PHS_GetIsEthereal(object oTarget);
// Returns TRUE if oTarget is an Astral creature
int PHS_GetIsAstral(object oTarget);
// Returns TRUE if oTarget is Crystalline - earthy
int PHS_GetIsCrystalline(object oTarget);

// This checks the item, or creature, imputted by this function.
// It will return:
// - TRUE if they passed thier save (or the item did) and so the spell ends (and the thing get immunity to the spell)
// - FALSE if they did not pass, and some information was given out.
int PHS_AnalyzeDweomerCheck(object oTarget, object oCaster);

// This returns a positive, negative or zero number
// Add this to any DC's for sleep.
// * Adds 2 for lullaby.
int PHS_GetSleepSaveModifier(object oTarget);

// This returns TRUE as long as the target is an alive creature. Dead objects
// cannot have effects applied to them anyway, so GetIsDead is not used.
// * sDebug - If this is filled, it is sent to the caster, if it returns FALSE.
int PHS_GetIsAliveCreature(object oTarget, string sDebug = "");

// Sorts out metamagic checks, using Random()
// - Adds on nBonus at the end.
// - Maximises if so, empowers all dice finally if it is empower.
// (Bioware SoU function)
// * can put in nTouch to see if it critical hits. (And does double what it would return).
int PHS_MaximizeOrEmpower(int nDiceSides, int nNumberOfDice, int nMeta, int nBonus = 0, int nTouch = 0);

// Works out a dice-rolled time.
// * nType - Use PHS_ROUNDS, PHS_TURNS and PHS_HOURS for duration time
// * nDiceSides, nNumberOfDice - The dice (EG 5, 6sided dice = 6, 5)
// * nMeta - Metamagic feat EXTEND is used here
// * nBonus - Added before metamagic, such as 4d(caster level) + Bonus.
float PHS_GetRandomDuration(int nType, int nDiceSides, int nNumberOfDice, int nMeta, int nBonusTime = 0);
// Works out a normal time. Useful wrapper.
// * nType - use PHS_ROUNDS, PHS_TURNS, PHS_HOURS
// * nTime - the time in hours, rounds or turns
// * nMeta - The metamagic feat EXTEND is also taken into account.
float PHS_GetDuration(int nType, int nTime, int nMeta);

// Get oObject's local integer variable sVarName
// * Return value on error: -1
// This is similar to LocalInt, but takes one away as it is a constant value.
int PHS_GetLocalConstant(object oObject, string sVarName);

// Does a fortitude check and applys EffectPetrify :-)
// - Taken from Bioware's petrify. More generic however.
// - No ReactionType checks.
// - Will not petrify immune creatures
// * oTarget - Target
// * nCasterLevel - Either the hit dice of the creature or the caster level
// * nFortSaveDC: pass in this number from the spell script
// - It will also apply bonuses of a construct.
void PHS_SpellFortitudePetrify(object oTarget, int nCasterLevel, int nFortSaveDC);

// Creates a new location from lLocation on a varying X and Y value, in increments
// of 1 meter.
// * iRandom - this is the number you want to randomise. It will be up to HALF
//             this in meters from lLocation, north south east or west.
location PHS_GetRandomLocation(location lLocation, int iRandom);

// Returns bolts, arrows, bullets or -1 for the ammo item type used by oWeapon.
int PHS_GetWeaponsAmmoType(object oWeapon);
// Gets the right slot for iBaseAmmoType or -1.
int PHS_GetAmmoSlot(int iBaseAmmoType);

// Returns TRUE if oTarget can see.
// - Is not blinded
// - Is not a creature with no eyes
// - Local variable also allowed for "I have no eyes"
int PHS_GetCanSee(object oTarget);
// Returns TRUE if oTarget can hear.
// - Is not deafened
// - Is not a creature with no eyes
// - Local variable also allowed for "I have no ears"
int PHS_GetCanHear(object oTarget);
// Is the creature dazzeled?
// Spells include:
// - Flare
int PHS_GetIsDazzled(object oTarget);

// Can the caster, oCaster, teleport to lTarget without disrupting a module?
// - Trigger, if at the location or the caster, stops it
// - The area can be made "No teleport"
int PHS_CannotTeleport(object oCaster, location lTarget);
// Returns TRUE if oCreature is locked in this dimension by:
// - Dimensional Anchor
// - Dimensional Lock
int PHS_GetDimensionalAnchor(object oCreature);

// This is used for some spells to limit creatures by size. EG: Dimension door.
// This returns:
// - 1 for Medium, small and tiny creatures.
// - 2 for Large (Equivilant of 2 medium creatures)
// - 4 for Huge creature sizes (Equivilant of 2 Large creatures)
int PHS_SizeEquvilant(object oCreature);

// Removes all Fatigue from oTarget.
void PHS_RemoveFatigue(object oTarget);

// Returns iHighest if it is over iHighest, or iLowest if under iLowest, or
// the integer put in if between them already.
int PHS_LimitInteger(int iInteger, int iHighest = 100, int iLowest = 1);

// This is fired from AI files.
// - Removes cirtain spells if the target is attacked, harmed and so on during
//   the spells effects.
void PHS_RemoveSpellsIfAttacked(object oAttacked = OBJECT_SELF);

// This DESTROYS oTarget.
// - Removes plot flags, all inventory, before proper destorying.
void PHS_PermamentlyRemove(object oTarget);

// Increase or decrease a stored integer on oTarget, by iAmount, under sName
void PHS_IncreaseStoredInteger(object oTarget, string sName, int iAmount);

// Returns TRUE if oTarget's subrace is plant, or integer PHS_PLANT is valid.
int PHS_GetIsPlant(object oTarget);

// This will make sure that oTarget is not commandable, and also that the commandable
// was not applied by some other spell which is active.
void PHS_SetCommandableOnSafe(object oTarget, int iSpellRemove);

// Automatically reports sucess or failure for the ability check. The roll
// of d20 + iAbility's scrore needs to be >= nDC.
int PHS_AbilityCheck(object oCheck, int iAbility, int nDC);

// Applys the visual effect nVis, across from oStart to the object oTarget,
// at intervals of 0.05, playing the visual in the direction.
void PHS_ApplyBeamAlongVisuals(int nVis, object oStart, object oTarget, float fIncrement = 1.0);

// Returns TRUE if sunlight will kill/seriously damage/almost obliterate oTarget,
// IE: Vampires.
int PHS_GetHateSun(object oTarget);

// Check the caster item, and if they have just cast the spell, apply an amount
// of charges for a cirtain duration.
// - TRUE if the check passes, else FALSE
int PHS_CheckChargesForSpell(int nSpellId, int nChargesIfNew, float fDuration, object oCaster = OBJECT_SELF);

// This changed oArea's music to iTrack for fDuration.
// * Note: If either tracks are already iTrack, they don't change.
void PHS_PlayMusicForDuration(object oArea, int iTrack, float fDuration);
// This changes it permantly. (used in PlayMusicForDuration).
// * Set iNightOrDay to TRUE for daytime music.
void PHS_ChangeMusicPermantly(object oArea, int iTrack, int iNightOrDay);
// This performs an area wether check.
// * Changes oAreas wether to iNewWether for fDuration.
void PHS_ChangeAreaWether(object oArea, int iNewWether, float fDuration);

/*:://////////////////////////////////////////////
//:: Functions
//:://////////////////////////////////////////////
    Functions start.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

// This returns TRUE as long as the target is an alive creature.
// * sDebug - If this is filled, it is sent to the caster, if it returns FALSE.
int PHS_GetIsAliveCreature(object oTarget, string sDebug = "")
{
    // invalid (IE dead etc) races and so on.
    int nRace = GetRacialType(oTarget);
    // Needs to be a creature
    if(GetObjectType(oTarget) != OBJECT_TYPE_CREATURE ||
    // Needs to be a valid race (not a dead or un-alive one!)
        nRace == RACIAL_TYPE_CONSTRUCT ||
        nRace == RACIAL_TYPE_UNDEAD)
    {
        if(sDebug != "")
        {
            SendMessageToPC(OBJECT_SELF, sDebug);
        }
        return FALSE;
    }
    return TRUE;
}

// Get oObject's local integer variable sVarName
// * Return value on error: -1
// This is similar to LocalInt, but takes one away as it is a constant value.
int PHS_GetLocalConstant(object oObject, string sVarName)
{
    return GetLocalInt(oObject, sVarName) - 1;
}

// * Returns true if Target is a humanoid
int PHS_GetIsHumanoid(object oTarget)
{
    int nRacial = GetRacialType(oTarget);

    switch(nRacial)
    {
        case RACIAL_TYPE_DWARF:
        case RACIAL_TYPE_HALFELF:
        case RACIAL_TYPE_HALFORC:
        case RACIAL_TYPE_ELF:
        case RACIAL_TYPE_GNOME:
        case RACIAL_TYPE_HUMANOID_GOBLINOID:
        case RACIAL_TYPE_HALFLING:
        case RACIAL_TYPE_HUMAN:
        case RACIAL_TYPE_HUMANOID_MONSTROUS:
        case RACIAL_TYPE_HUMANOID_ORC:
        case RACIAL_TYPE_HUMANOID_REPTILIAN:
            return TRUE;
    }
   return FALSE;
}

//This allows the application of a random delay to effects based on time parameters passed in.  Min default = 0.4, Max default = 1.1
float PHS_GetRandomDelay(float fMinimumTime = 0.4, float MaximumTime = 1.1)
{
    float fRandom = MaximumTime - fMinimumTime;
    int nRandom;
    if(fRandom < 0.0)
    {
        return 0.0;
    }
    else
    {
        nRandom = FloatToInt(fRandom  * 10.0);
        nRandom = Random(nRandom) + 1;
        fRandom = IntToFloat(nRandom);
        fRandom /= 10.0;
        return fRandom + fMinimumTime;
    }
}

// Totals the amount of items of sTag in oTargets inventory.
int PHS_TotalItemsOfBlueprint(object oTarget, string sBluePrint)
{
    object oItem = GetFirstItemInInventory(oTarget);
    int iCount = 0;
    while(GetIsObjectValid(oItem))
    {
        if(GetResRef(oItem) == sBluePrint)
        {
            iCount += GetNumStackedItems(oItem);
        }
        oItem = GetNextItemInInventory(oTarget);
    }
    return iCount;
}

// Destroys all items of sBluePrint on oTarget.
void PHS_DestroyItemsOfBluePrint(object oTarget, string sBluePrint)
{
    object oItem = GetFirstItemInInventory(oTarget);
    while(GetIsObjectValid(oItem))
    {
        if(GetResRef(oItem) == sBluePrint)
        {
            DestroyObject(oItem);
        }
        oItem = GetNextItemInInventory(oTarget);
    }
}
// This alerts all DM's of the spell being cast, and of names of targets
// also reports Caster Level and DC for save.
void PHS_AlertDMsOfSpell(string sName, int nSpellSaveDC, int nCasterLevel)
{
    string sMessage;
    string sTarget = "None";
    object oTarget = GetSpellTargetObject();
    object oArea = GetArea(OBJECT_SELF);
    if(GetIsObjectValid(oTarget))
    {
        sTarget = GetName(oTarget);
    }
    sMessage = "[SPELL CAST: "+sName+"] [Caster: "+GetName(OBJECT_SELF)+"] [Caster Level: "+IntToString(nCasterLevel)+"] [Target: "+sTarget+"] [Area :"+GetName(oArea)+"] [SaveDC: "+IntToString(nSpellSaveDC) + "]";
    SendMessageToAllDMs(sMessage);
}
// checks for iEffect on oTarget
int PHS_GetHasEffect(int iEffect, object oTarget = OBJECT_SELF)
{
    effect eCheck = GetFirstEffect(oTarget);
    while(GetIsEffectValid(eCheck))
    {
        if(GetEffectType(eCheck) == iEffect)
        {
             return TRUE;
             break;
        }
        eCheck = GetNextEffect(oTarget);
    }
    return FALSE;
}
// checks for iEffect on oTarget, cast by oCaster.
int PHS_GetHasEffectFromCaster(int iEffect, object oTarget, object oCaster)
{
    effect eCheck = GetFirstEffect(oTarget);
    while(GetIsEffectValid(eCheck))
    {
        if(GetEffectType(eCheck) == iEffect)
        {
            if(GetEffectCreator(eCheck) == oCaster)
            {
                return TRUE;
                break;
            }
        }
        eCheck = GetNextEffect(oTarget);
    }
    return FALSE;
}
// checks for nSpellId on oTarget, cast by oCaster.
int PHS_GetHasSpellEffectFromCaster(int nSpellId, object oTarget, object oCaster)
{
    effect eCheck = GetFirstEffect(oTarget);
    while(GetIsEffectValid(eCheck))
    {
        if(GetEffectSpellId(eCheck) == nSpellId)
        {
            if(GetEffectCreator(eCheck) == oCaster)
            {
                return TRUE;
                break;
            }
        }
        eCheck = GetNextEffect(oTarget);
    }
    return FALSE;
}

// Wrapper for the signal event. Smaller :-P
void PHS_SignalSpellCastAt(object oTarget, int nSpell, int bHarmful)
{
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpell, bHarmful));
}

// * returns true if oCreature does not have a mind
// XP1
int PHS_spellsIsMindless(object oCreature)
{
    int nRacialType = GetRacialType(oCreature);
    switch(nRacialType)
    {
        case RACIAL_TYPE_ELEMENTAL:
        case RACIAL_TYPE_UNDEAD:
        case RACIAL_TYPE_VERMIN:
        case RACIAL_TYPE_CONSTRUCT:
        return TRUE;
    }
    return FALSE;
}

// * Returns true or false depending on whether the creature is flying
// * or not
// XP1
int PHS_spellsIsFlying(object oCreature)
{
    int nAppearance = GetAppearanceType(oCreature);
    int bFlying = FALSE;
    switch(nAppearance)
    {
        case APPEARANCE_TYPE_ALLIP:
        case APPEARANCE_TYPE_BAT:
        case APPEARANCE_TYPE_BAT_HORROR:
        case APPEARANCE_TYPE_ELEMENTAL_AIR:
        case APPEARANCE_TYPE_ELEMENTAL_AIR_ELDER:
        case APPEARANCE_TYPE_FAERIE_DRAGON:
        case APPEARANCE_TYPE_FALCON:
        case APPEARANCE_TYPE_FAIRY:
        case APPEARANCE_TYPE_HELMED_HORROR:
        case APPEARANCE_TYPE_IMP:
        case APPEARANCE_TYPE_LANTERN_ARCHON:
        case APPEARANCE_TYPE_MEPHIT_AIR:
        case APPEARANCE_TYPE_MEPHIT_DUST:
        case APPEARANCE_TYPE_MEPHIT_EARTH:
        case APPEARANCE_TYPE_MEPHIT_FIRE:
        case APPEARANCE_TYPE_MEPHIT_ICE:
        case APPEARANCE_TYPE_MEPHIT_MAGMA:
        case APPEARANCE_TYPE_MEPHIT_OOZE:
        case APPEARANCE_TYPE_MEPHIT_SALT:
        case APPEARANCE_TYPE_MEPHIT_STEAM:
        case APPEARANCE_TYPE_MEPHIT_WATER:
        case APPEARANCE_TYPE_QUASIT:
        case APPEARANCE_TYPE_RAVEN:
        case APPEARANCE_TYPE_SHADOW:
        case APPEARANCE_TYPE_SHADOW_FIEND:
        case APPEARANCE_TYPE_SPECTRE:
        case APPEARANCE_TYPE_WILL_O_WISP:
        case APPEARANCE_TYPE_WRAITH:
        case APPEARANCE_TYPE_WYRMLING_BLACK:
        case APPEARANCE_TYPE_WYRMLING_BLUE:
        case APPEARANCE_TYPE_WYRMLING_BRASS:
        case APPEARANCE_TYPE_WYRMLING_BRONZE:
        case APPEARANCE_TYPE_WYRMLING_COPPER:
        case APPEARANCE_TYPE_WYRMLING_GOLD:
        case APPEARANCE_TYPE_WYRMLING_GREEN:
        case APPEARANCE_TYPE_WYRMLING_RED:
        case APPEARANCE_TYPE_WYRMLING_SILVER:
        case APPEARANCE_TYPE_WYRMLING_WHITE:
        case APPEARANCE_TYPE_ELEMENTAL_WATER:
        case APPEARANCE_TYPE_ELEMENTAL_WATER_ELDER:
        // hordes
        case 401: //beholder
        case 402: //beholder
        case 403: //beholder
        case 419: // harpy
        case 430: // Demi Lich
        case 472: // Hive mother

        bFlying = TRUE;
    }
    if(!bFlying)
    {
        // Checking effect appear disappear - like flying dragons
        bFlying = PHS_GetHasEffect(EFFECT_TYPE_DISAPPEARAPPEAR, oCreature);
    }
    return bFlying;
}

// * returns true if the creature has flesh
// XP1
int PHS_spellsIsImmuneToPetrification(object oCreature)
{
    int nAppearance = GetAppearanceType(oCreature);
    int bFlesh = FALSE;
    switch (nAppearance)
    {
        case APPEARANCE_TYPE_BASILISK:
        case APPEARANCE_TYPE_COCKATRICE:
        case APPEARANCE_TYPE_MEDUSA:
        case APPEARANCE_TYPE_ALLIP:
        case APPEARANCE_TYPE_ELEMENTAL_AIR:
        case APPEARANCE_TYPE_ELEMENTAL_AIR_ELDER:
        case APPEARANCE_TYPE_ELEMENTAL_EARTH:
        case APPEARANCE_TYPE_ELEMENTAL_EARTH_ELDER:
        case APPEARANCE_TYPE_ELEMENTAL_FIRE:
        case APPEARANCE_TYPE_ELEMENTAL_FIRE_ELDER:
        case APPEARANCE_TYPE_ELEMENTAL_WATER:
        case APPEARANCE_TYPE_ELEMENTAL_WATER_ELDER:
        case APPEARANCE_TYPE_GOLEM_STONE:
        case APPEARANCE_TYPE_GOLEM_IRON:
        case APPEARANCE_TYPE_GOLEM_CLAY:
        case APPEARANCE_TYPE_GOLEM_BONE:
        case APPEARANCE_TYPE_GORGON:
        case APPEARANCE_TYPE_HEURODIS_LICH:
        case APPEARANCE_TYPE_LANTERN_ARCHON:
        case APPEARANCE_TYPE_SHADOW:
        case APPEARANCE_TYPE_SHADOW_FIEND:
        case APPEARANCE_TYPE_SHIELD_GUARDIAN:
        case APPEARANCE_TYPE_SKELETAL_DEVOURER:
        case APPEARANCE_TYPE_SKELETON_CHIEFTAIN:
        case APPEARANCE_TYPE_SKELETON_COMMON:
        case APPEARANCE_TYPE_SKELETON_MAGE:
        case APPEARANCE_TYPE_SKELETON_PRIEST:
        case APPEARANCE_TYPE_SKELETON_WARRIOR:
        case APPEARANCE_TYPE_SKELETON_WARRIOR_1:
        case APPEARANCE_TYPE_SPECTRE:
        case APPEARANCE_TYPE_WILL_O_WISP:
        case APPEARANCE_TYPE_WRAITH:
        case APPEARANCE_TYPE_BAT_HORROR:
        // Hordes
        case 405: // Dracolich:
        case 415: // Alhoon
        case 418: // shadow dragon
        case 420: // mithral golem
        case 421: // admantium golem
        case 430: // Demi Lich
        case 469: // animated chest
        case 474: // golems
        case 475: // golems
        {
            bFlesh = TRUE;
        }
    }
    // - No death for things that cannot be destroyed.
    if(!bFlesh)
    {
        bFlesh = PHS_CanCreatureBeDestroyed(oCreature);
    }
    return bFlesh;
}

/*:://////////////////////////////////////////////
//:: Name Bullrush Attack
//:: Function Name PHS_Bullrush
//:://////////////////////////////////////////////
    Performs a D&D bullrush attack against oTarget.

    - Used to push back a person in forceful hand.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/
// Bullrush attack
// - Uses oTarget's strength, add modifiers, against iCasterModifier.
// - Reports results to caster and target
int PHS_Bullrush(object oTarget, int iCasterModifier, object oCaster = OBJECT_SELF)
{
    // Check if oTarget is immune to bullrush
    if(PHS_ImmuneToBullrush(oTarget))
    {
        return FALSE;
    }

    // Get the modifier for the target
    int iTargetModifier = GetAbilityModifier(ABILITY_STRENGTH, oTarget);

    // Add 2 if they are steady
    if(PHS_GetIsSteady(oTarget))
    {
        iTargetModifier += 2;
    }

    // Add size modifier
    iTargetModifier += PHS_GetSizeModifier(oTarget);

    // We now make the rolls
    int iCasterRoll = d20();
    int iTargetRoll = d20();

    string sMessage = "Bullrush Attack! Charger Roll: " + IntToString(iCasterRoll) + ", Modifier: " + IntToString(iCasterModifier) + ". Defender Roll: " + IntToString(iTargetRoll) + ", Modifier: " + IntToString(iTargetModifier) + ". RESULT: ";

    // Check results and relay
    if(iCasterRoll + iCasterModifier > iTargetRoll + iTargetModifier)
    {
        // Charger beats the defender
        sMessage += "Charger Wins!";
        FloatingTextStringOnCreature(sMessage, oTarget, FALSE);
        FloatingTextStringOnCreature(sMessage, oCaster, FALSE);
        // Return TRUE.
        return TRUE;
    }
    else
    {
        // Defender beats the charger
        sMessage += "Defender Wins!";
        FloatingTextStringOnCreature(sMessage, oTarget, FALSE);
        FloatingTextStringOnCreature(sMessage, oCaster, FALSE);
        // Return FALSE
        return FALSE;
    }
    // Default to false if error somehow.
    return FALSE;
}
// Bullrush
// - Returns TRUE if oCreature is immune to bullrush
// - Oozes, for instance.
int PHS_ImmuneToBullrush(object oCreature)
{
    // Return immune if local variable set
    if(GetLocalInt(oCreature, "PHS_SPELL_IMMUNE_TO_BULLRUSH")) return TRUE;

    int iAppearance = GetAppearanceType(oCreature);
    // Is it some odd creature, which is immune to being held or pushed back?
    // - EG: Oozes.
    switch(iAppearance)
    {
        case APPEARANCE_TYPE_ARCH_TARGET:
        case APPEARANCE_TYPE_COMBAT_DUMMY:
        {
            return TRUE;
        }
        break;
    }
    return FALSE;
}
// Bullrush
// * Returns the size modifier for bullrush in spells (XP1)
// +4 for every size over medium
// -4 for every size under medium. Medium = 0.
int PHS_GetSizeModifier(object oCreature)
{
    int nSize = GetCreatureSize(oCreature);
    int nModifier = 0;
    switch (nSize)
    {
        case CREATURE_SIZE_TINY: nModifier = -8;  break;
        case CREATURE_SIZE_SMALL: nModifier = -4; break;
        case CREATURE_SIZE_MEDIUM: nModifier = 0; break;
        case CREATURE_SIZE_LARGE: nModifier = 4;  break;
        case CREATURE_SIZE_HUGE: nModifier = 8;   break;
    }
    return nModifier;
}
// Bullrush
// * Returns TRUE if oCreature is steady.
//      - Has more then 2 legs
//      - Is steadying themselves by use of Defensive Casting or Expertise.
//      - Is steady by moving slowly around!
int PHS_GetIsSteady(object oCreature)
{
    // They are steady if moving slowly.
    int iSpeed = GetMovementRate(oCreature);
    // 0 = PC Movement Speed or invalid oCreature
    // 1 = Immobile
    // 2 = Very Slow
    // 3 = Slow
    // 4 = Normal
    // 5 = Fast
    // 6 = Very Fast
    // 7 = Creature Default (defined in appearance.2da)
    // 8 = DM Speed
    if(iSpeed == 1 || iSpeed == 2 || iSpeed == 3)
    {
        return TRUE;
    }

    int iAppearance = GetAppearanceType(oCreature);
    // Has it got more then two legs, or is otherwise steady? (such as a tree
    // is steady, or ooze would be steady :-) ).
    switch(iAppearance)
    {
        case APPEARANCE_TYPE_ARANEA:        // 6-8 legs
        case APPEARANCE_TYPE_BADGER:        // 4
        case APPEARANCE_TYPE_BADGER_DIRE:   // 4
        case APPEARANCE_TYPE_BASILISK:      // 4
        case APPEARANCE_TYPE_BEAR_BLACK:    // 4
        case APPEARANCE_TYPE_BEAR_BROWN:    // 4
        case APPEARANCE_TYPE_BEAR_DIRE:     // 4
        case APPEARANCE_TYPE_BEAR_KODIAK:   // 4
        case APPEARANCE_TYPE_BEAR_POLAR:    // 4
        case APPEARANCE_TYPE_BEETLE_FIRE:   // 6
        case APPEARANCE_TYPE_BEETLE_SLICER: // 6
        case APPEARANCE_TYPE_BEETLE_STAG:   // 6
        case APPEARANCE_TYPE_BEETLE_STINK:  // 6
        case APPEARANCE_TYPE_BOAR:          // 4
        case APPEARANCE_TYPE_BOAR_DIRE:     // 4
        case APPEARANCE_TYPE_CAT_CAT_DIRE:  // 4
        case APPEARANCE_TYPE_CAT_COUGAR:    // 4
        case APPEARANCE_TYPE_CAT_CRAG_CAT:  // 4
        case APPEARANCE_TYPE_CAT_JAGUAR:    // 4
        case APPEARANCE_TYPE_CAT_KRENSHAR:  // 4
        case APPEARANCE_TYPE_CAT_LEOPARD:   // 4
        case APPEARANCE_TYPE_CAT_LION:      // 4
        case APPEARANCE_TYPE_CAT_MPANTHER:  // 4
        case APPEARANCE_TYPE_CAT_PANTHER:   // 4
        case APPEARANCE_TYPE_COW:           // 4
        case APPEARANCE_TYPE_DEER:          // 4
        case APPEARANCE_TYPE_DEER_STAG:     // 4
        case APPEARANCE_TYPE_DOG:           // 4
        case APPEARANCE_TYPE_DOG_BLINKDOG:  // 4
        case APPEARANCE_TYPE_DOG_DIRE_WOLF: // 4
        case APPEARANCE_TYPE_DOG_FENHOUND:  // 4
        case APPEARANCE_TYPE_DOG_HELL_HOUND:// 4
        case APPEARANCE_TYPE_DOG_SHADOW_MASTIF:// 4
        case APPEARANCE_TYPE_DOG_WINTER_WOLF:// 4
        case APPEARANCE_TYPE_DOG_WOLF:      // 4
        case APPEARANCE_TYPE_DOG_WORG:      // 4
        // Note - We count large dragons as always being steady
        case APPEARANCE_TYPE_DRAGON_BLACK:
        case APPEARANCE_TYPE_DRAGON_BLUE:
        case APPEARANCE_TYPE_DRAGON_BRASS:
        case APPEARANCE_TYPE_DRAGON_BRONZE:
        case APPEARANCE_TYPE_DRAGON_COPPER:
        case APPEARANCE_TYPE_DRAGON_GOLD:
        case APPEARANCE_TYPE_DRAGON_GREEN:
        case APPEARANCE_TYPE_DRAGON_RED:
        case APPEARANCE_TYPE_DRAGON_SILVER:
        case APPEARANCE_TYPE_DRAGON_WHITE:
        case APPEARANCE_TYPE_FORMIAN_MYRMARCH:// 4
        case APPEARANCE_TYPE_FORMIAN_QUEEN: // 4
        case APPEARANCE_TYPE_FORMIAN_WARRIOR:// 4
        case APPEARANCE_TYPE_FORMIAN_WORKER:// 4
        case APPEARANCE_TYPE_GORGON:        // 4
        case APPEARANCE_TYPE_GYNOSPHINX:    // 4
        case APPEARANCE_TYPE_INTELLECT_DEVOURER:// 4
        case APPEARANCE_TYPE_MANTICORE:     // 4
        case APPEARANCE_TYPE_OX:            // 4
        case APPEARANCE_TYPE_RAT:           // 4
        case APPEARANCE_TYPE_RAT_DIRE:      // 4
        case APPEARANCE_TYPE_SPHINX:        // 4
        case APPEARANCE_TYPE_SPIDER_DIRE:   // 6-8
        case APPEARANCE_TYPE_SPIDER_GIANT:  // 6-8
        case APPEARANCE_TYPE_SPIDER_PHASE:  // 6-8
        case APPEARANCE_TYPE_SPIDER_SWORD:  // 6-8
        case APPEARANCE_TYPE_SPIDER_WRAITH: // 6-8
        case APPEARANCE_TYPE_STINGER:       // 4
        case APPEARANCE_TYPE_STINGER_CHIEFTAIN:// 4
        case APPEARANCE_TYPE_STINGER_MAGE:  // 4
        case APPEARANCE_TYPE_STINGER_WARRIOR:// 4
        case APPEARANCE_TYPE_WAR_DEVOURER:  // 4
        {
            return TRUE;
        }
        break;
    }
    return FALSE;
}
// Gets a location in a straight line, between oSouce and oTarget, adding fDistance.
location PHS_GetLocationBehind(object oSource, object oTarget, float fDistance)
{
    // * Thanks to BrainByte!

    // Get target area and facing to be used for the new location.
    object oArea = GetArea(oTarget);
    float fFacing = GetFacing(oTarget);
    // Get target position and relative position.
    vector vTarget = GetPosition(oTarget);
    vector vDelta = GetPosition(oTarget) - GetPosition(oSource);
    // Normalize transfer vector.
    vector vModified = VectorNormalize(vDelta);
    // Apply constant distance.
    vModified = Vector(vModified.x * fDistance, vModified.y * fDistance, vModified.z);
    // Get the new location.
    location locModified = Location(oArea, vTarget + vModified, fFacing);
    // Return the location.
    return locModified;
}
// Gets a location in a straight line, between lSource and lTarget, adding fDistance.
location PHS_GetLocationBehindLocation(location lSource, location lTarget, float fDistance)
{
    // Get target area and facing to be used for the new location.
    object oArea = GetArea(OBJECT_SELF);
    float fFacing = 0.0;// Doesn't matter
    // Get target position and relative position.
    vector vTarget = GetPositionFromLocation(lTarget);
    vector vDelta = GetPositionFromLocation(lTarget) - GetPositionFromLocation(lSource);
    // Normalize transfer vector.
    vector vModified = VectorNormalize(vDelta);
    // Apply constant distance.
    vModified = Vector(vModified.x * fDistance, vModified.y * fDistance, vModified.z);
    // Get the new location.
    location locModified = Location(oArea, vTarget + vModified, fFacing);
    // Return the location.
    return locModified;
}

//::///////////////////////////////////////////////
//:: CanCreatureBeDestroyed
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Returns true if the creature is allowed
    to die (i.e., not plot)
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

int PHS_CanCreatureBeDestroyed(object oTarget)
{
    if (GetPlotFlag(oTarget) == FALSE &&
        GetImmortal(oTarget) == FALSE &&
        GetIsDM(oTarget) == FALSE &&
        GetIsDead(oTarget) == FALSE)
    {
        return TRUE;
    }
    return FALSE;
}
// Is oTarget in a maze area? (disables some spells)
int PHS_IsInMazeArea(object oTarget = OBJECT_SELF)
{
    // Maze waypoint
    object oWP = GetWaypointByTag(PHS_S_MAZE_TARGET);
    if(GetIsObjectValid(oWP) && GetArea(oWP) == GetArea(oTarget))
    {
        // Return TRUE if same area
        return TRUE;
    }
    // Return FALSE
    return FALSE;
}
// Is oTarget in a Imprisonment area? (disables some spells)
int PHS_IsInPrisonArea(object oTarget = OBJECT_SELF)
{
    // Imprisonment waypoint
    object oWP = GetWaypointByTag(PHS_S_IMPRISONMENT_TARGET);
    if(GetIsObjectValid(oWP) && GetArea(oWP) == GetArea(oTarget))
    {
        // Return TRUE if same area
        return TRUE;
    }
    // Return FALSE
    return FALSE;
}

// Returns TRUE if oTarget is an Minotaur
int PHS_GetIsMinotaur(object oTarget)
{
    int nAppearance = GetAppearanceType(oTarget);
    int bReturn = FALSE;
    switch (nAppearance)
    {
        case APPEARANCE_TYPE_MINOGON:
        case APPEARANCE_TYPE_MINOTAUR:
        case APPEARANCE_TYPE_MINOTAUR_CHIEFTAIN:
        case APPEARANCE_TYPE_MINOTAUR_SHAMAN:
        {
            bReturn = TRUE;
        }
        break;
    }
    // Minotaur subrace
    if(FindSubString("MINOTAUR", GetStringUpperCase(GetSubRace(oTarget))) > FALSE)
    {
        bReturn = TRUE;
    }
    return bReturn;
}
// Returns TRUE if oTarget is an Astral creature
int PHS_GetIsAstral(object oTarget)
{
    if(GetLocalInt(oTarget, "SPELL_IS_ASTRAL"))
    {
        return TRUE;
    }
    return FALSE;
}
// Returns TRUE if oTarget is an Ethereal, or an Ethereal creature
int PHS_GetIsEthereal(object oTarget)
{
    if(PHS_GetHasEffect(EFFECT_TYPE_ETHEREAL, oTarget) ||
       GetLocalInt(oTarget, "SPELL_IS_ETHEREAL"))
    {
        return TRUE;
    }
    return FALSE;
}
// Returns TRUE if oTarget is Crystalline - earthy
int PHS_GetIsCrystalline(object oTarget)
{
    if(GetLocalInt(oTarget, PHS_CRYSTALLINE))
    {
        return TRUE;
    }
    // Check appearance
    switch(GetAppearanceType(oTarget))
    {
        case APPEARANCE_TYPE_ELEMENTAL_EARTH:
        case APPEARANCE_TYPE_ELEMENTAL_EARTH_ELDER:
        {
            return TRUE;
        }
        break;
    }
    return FALSE;
}


// This checks the item, or creature, imputted by this function.
// It will return:
// - TRUE if they passed thier save (or the item did) and so the spell ends (and the thing get immunity to the spell)
// - FALSE if they did not pass, and some information was given out.
int PHS_AnalyzeDweomerCheck(object oTarget, object oCaster)
{
    int iSaveDC = GetSpellSaveDC();
    int iReturn = TRUE;// Default to stop just in case


    return iReturn;
}

// Sorts out metamagic checks, using Random()
// - Adds on nBonus at the end.
// - Maximises if so, empowers all dice finally if it is empower.
// (Bioware SoU function)
int PHS_MaximizeOrEmpower(int nDiceSides, int nNumberOfDice, int nMeta, int nBonus = 0, int nTouch = 0)
{
    int nDiceReturn, iCnt;
    //Resolve metamagic
    if(nMeta == METAMAGIC_MAXIMIZE)
    {
        nDiceReturn = nDiceSides * nNumberOfDice;
    }
    else
    {
        // Else, can be empowered or normal. Roll dice
        for(iCnt = 1; iCnt <= nNumberOfDice; iCnt++)
        {
            nDiceReturn += Random(nDiceSides) + 1;
        }
        // Resolve metamagic empower
        if(nMeta == METAMAGIC_EMPOWER)
        {
            nDiceReturn = nDiceReturn + (nDiceReturn/2);
        }
    }
    // Add bonus.
    nDiceReturn += nBonus;
    // Make sure we multiply if touch attack based.
    if(nTouch == 2)
    {
        nDiceReturn * 2;
    }
    return nDiceReturn;
}

// Works out a dice-rolled time.
// * nType - Use PHS_ROUNDS, PHS_TURNS and PHS_HOURS for duration time
// * nDiceSides, nNumberOfDice - The dice (EG 5, 6sided dice = 6, 5)
// * nMeta - Metamagic feat EXTEND is used here
// * nBonus - Added before metamagic, such as 4d(caster level) + Bonus.
float PHS_GetRandomDuration(int nType, int nDiceSides, int nNumberOfDice, int nMeta, int nBonusTime = 0)
{
    int nDiceRolls, iCnt;
    // Roll dice
    for(iCnt = 1; iCnt <= nNumberOfDice; iCnt++)
    {
        nDiceRolls = nDiceRolls + Random(nDiceSides - 1) + 1;
    }
    // Resolve metamagic
    int nTotal = nDiceRolls + nBonusTime;
    if(nMeta == METAMAGIC_EXTEND)
    {
        nTotal *= 2;// x2 duration
    }
    // Returns the right time
    float fTime;
    if(nType == PHS_ROUNDS)
    {
        fTime = RoundsToSeconds(nTotal);
    }
    else if(nType == PHS_TURNS)
    {
        fTime = TurnsToSeconds(nTotal);
    }
    else if(nType == PHS_HOURS)
    {
        fTime = HoursToSeconds(nTotal);
    }
    return fTime;
}

// Works out a normal time. Useful wrapper.
// * nType - use PHS_ROUNDS, PHS_TURNS, PHS_HOURS
// * nTime - the time in hours, rounds or turns
// * nMeta - The metamagic feat EXTEND is also taken into account.
float PHS_GetDuration(int nType, int nTime, int nMeta)
{
    // Error checking
    if(nTime < 1) nTime = 1;
    // Resolve metamagic
    if(nMeta == METAMAGIC_EXTEND)
    {
        nTime *= 2;// x2 duration
    }
    // Returns the right time
    float fTime;
    if(nType == PHS_ROUNDS)
    {
        fTime = RoundsToSeconds(nTime);
    }
    else if(nType == PHS_TURNS)
    {
        fTime = TurnsToSeconds(nTime);
    }
    else if(nType == PHS_HOURS)
    {
        fTime = HoursToSeconds(nTime);
    }
    return fTime;
}


// Does a fortitude check and applys EffectPetrify :-)
// - Taken from Bioware's petrify. More generic however.
// - No ReactionType checks.
// - Will not petrify immune creatures
// * oTarget - Target
// * nCasterLevel - Either the hit dice of the creature or the caster level
// * nFortSaveDC: pass in this number from the spell script
// - It will also apply bonuses of a construct.
void PHS_SpellFortitudePetrify(object oTarget, int nCasterLevel, int nFortSaveDC)
{
    // * Exit if creature is immune to petrification
    if(PHS_spellsIsImmuneToPetrification(oTarget)) return;

    float fDifficulty = 0.0;
    int bShowPopup = FALSE;

    // Declare effects
    effect ePetrify = EffectPetrify();
    effect eImmunity1 = EffectImmunity(IMMUNITY_TYPE_CRITICAL_HIT);
    effect eImmunity2 = EffectImmunity(IMMUNITY_TYPE_DEATH);
    effect eImmunity3 = EffectImmunity(IMMUNITY_TYPE_DISEASE);
    effect eImmunity4 = EffectImmunity(IMMUNITY_TYPE_NEGATIVE_LEVEL);
    effect eImmunity5 = EffectImmunity(IMMUNITY_TYPE_PARALYSIS);
    effect eImmunity6 = EffectImmunity(IMMUNITY_TYPE_POISON);
    effect eImmunity7 = EffectImmunity(IMMUNITY_TYPE_SNEAK_ATTACK);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    // Link effects
    effect eLink = EffectLinkEffects(eDur, ePetrify);
    eLink = EffectLinkEffects(eLink, eImmunity1);
    eLink = EffectLinkEffects(eLink, eImmunity2);
    eLink = EffectLinkEffects(eLink, eImmunity3);
    eLink = EffectLinkEffects(eLink, eImmunity4);
    eLink = EffectLinkEffects(eLink, eImmunity5);
    eLink = EffectLinkEffects(eLink, eImmunity6);
    eLink = EffectLinkEffects(eLink, eImmunity7);

    // Do a fortitude save check
    if(!PHS_SavingThrow(SAVING_THROW_FORT, oTarget, nFortSaveDC))
    {
        // * The duration is permanent against NPCs but only temporary against PCs
        //   unless the PC's are playing core rules or higher.
        if(GetIsPC(oTarget))
        {
            // * Under hardcore rules or higher, this is an instant death
            if(GetGameDifficulty() >= GAME_DIFFICULTY_CORE_RULES)
            {
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
                // Death panel
                DelayCommand(2.75, PopUpDeathGUIPanel(oTarget, FALSE , TRUE, 40579));
            }
            else
            {
                // Apply for nCasterLevel rounds.
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nCasterLevel));
            }
        }
        else
        // * NPCs get full effect. No death panel.
        {
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
        }
        // April 2003: Clearing actions to kick them out of conversation when petrified
        AssignCommand(oTarget, ClearAllActions());
    }
}


// Creates a new location from lLocation on a varying X and Y value, in increments
// of 1 meter.
// * iRandom - this is the number you want to randomise. It will be up to HALF
//             this in meters from lLocation, north south east or west.
location PHS_GetRandomLocation(location lLocation, int iRandom)
{
    vector vOld = GetPositionFromLocation(lLocation);
    float fFacing = IntToFloat(Random(360));
    float fNewX = vOld.x + IntToFloat(Random(iRandom) - (iRandom/2));
    float fNewY = vOld.y + IntToFloat(Random(iRandom) - (iRandom/2));
    float fNewZ = vOld.z;
    vector vNew = Vector(fNewX, fNewY, fNewZ);
    location lReturn = Location(GetAreaFromLocation(lLocation), vNew, fFacing);
    // Return the finnished one
    return lReturn;
}

// Returns bolts, arrows, bullets or -1 for the ammo item type used by oWeapon.
int PHS_GetWeaponsAmmoType(object oWeapon)
{
    int iItemType = GetBaseItemType(oWeapon);

    if(iItemType == BASE_ITEM_LONGBOW || iItemType == BASE_ITEM_SHORTBOW)
    {
        return BASE_ITEM_ARROW;
    }
    else if(iItemType == BASE_ITEM_HEAVYCROSSBOW || iItemType == BASE_ITEM_LIGHTCROSSBOW)
    {
        return BASE_ITEM_BOLT;
    }
    else if(iItemType == BASE_ITEM_SLING)
    {
        return BASE_ITEM_BULLET;
    }
    return -1;
}
// Gets the right slot for iBaseAmmoType or -1.
int PHS_GetAmmoSlot(int iBaseAmmoType)
{
    if(iBaseAmmoType == BASE_ITEM_ARROW)
    {
        return INVENTORY_SLOT_ARROWS;
    }
    else if(iBaseAmmoType == BASE_ITEM_BOLT)
    {
        return INVENTORY_SLOT_BOLTS;
    }
    else if(iBaseAmmoType == BASE_ITEM_BULLET)
    {
        return INVENTORY_SLOT_BULLETS;
    }
    return -1;
}

// Returns TRUE if oTarget can see.
// - Is not blinded
// - Is not a creature with no eyes
// - Local variable also allowed for "I have no eyes"
int PHS_GetCanSee(object oTarget)
{
    // Are they blinded?
    if(PHS_GetHasEffect(EFFECT_TYPE_BLINDNESS, oTarget)) return FALSE;

    // Can they see? Some appearances do not have eyes, as such.
    int iAppearance = GetAppearanceType(oTarget);

    switch(iAppearance)
    {
        case APPEARANCE_TYPE_BAT:
        case APPEARANCE_TYPE_BAT_HORROR:
        case APPEARANCE_TYPE_ELEMENTAL_AIR:
        case APPEARANCE_TYPE_ELEMENTAL_AIR_ELDER:
        case APPEARANCE_TYPE_ELEMENTAL_EARTH:
        case APPEARANCE_TYPE_ELEMENTAL_EARTH_ELDER:
        case APPEARANCE_TYPE_ELEMENTAL_FIRE:
        case APPEARANCE_TYPE_ELEMENTAL_FIRE_ELDER:
        case APPEARANCE_TYPE_ELEMENTAL_WATER:
        case APPEARANCE_TYPE_ELEMENTAL_WATER_ELDER:
        case APPEARANCE_TYPE_GOLEM_BONE:
        case APPEARANCE_TYPE_GOLEM_CLAY:
        case APPEARANCE_TYPE_GOLEM_FLESH:
        case APPEARANCE_TYPE_GOLEM_IRON:
        case APPEARANCE_TYPE_GOLEM_STONE:
        case APPEARANCE_TYPE_HELMED_HORROR:
        case APPEARANCE_TYPE_SHIELD_GUARDIAN:
        case APPEARANCE_TYPE_INTELLECT_DEVOURER:
        case APPEARANCE_TYPE_SKELETAL_DEVOURER:
        case APPEARANCE_TYPE_WAR_DEVOURER:
        case APPEARANCE_TYPE_WILL_O_WISP:
        case APPEARANCE_TYPE_LANTERN_ARCHON:
        case 470: // GelatinousCube
        {
            // Cannot see
            return FALSE;
        }
        break;
    }

    // Local variable
    if(GetLocalInt(oTarget, "PHS_SPELLS_CANNOT_SEE")) return FALSE;

    // Is immune to blindness
    if(GetIsImmune(oTarget, IMMUNITY_TYPE_BLINDNESS)) return FALSE;

    return TRUE;
}
// Returns TRUE if oTarget can hear.
// - Is not deafened
// - Is not a creature with no eyes
// - Local variable also allowed for "I have no ears"
int PHS_GetCanHear(object oTarget)
{
    // Are they blinded?
    if(PHS_GetHasEffect(EFFECT_TYPE_DEAF, oTarget)) return FALSE;

    // Can they see? Some appearances do not have eyes, as such.
    int iAppearance = GetAppearanceType(oTarget);

    switch(iAppearance)
    {
        case 470: // GelatinousCube
        {
            // Cannot see
            return FALSE;
        }
        break;
    }

    // Local variable
    if(GetLocalInt(oTarget, "PHS_SPELLS_CANNOT_HEAR")) return FALSE;

    return TRUE;
}

// Is the creature dazzeled?
// Spells include:
// - Flare
int PHS_GetIsDazzled(object oTarget)
{
    effect eCheck = GetFirstEffect(oTarget);
    int iSpell;
    while(GetIsEffectValid(eCheck))
    {
        iSpell = GetEffectSpellId(eCheck);
        // Check spells
        switch(iSpell)
        {
            case PHS_SPELL_FLARE:
            {
                return TRUE;
            }
            break;
        }
        eCheck = GetNextEffect(oTarget);
    }
    return FALSE;
}

// Can the caster, oCaster, teleport to lTarget without disrupting a module?
// - Trigger, if at the location or the caster, stops it
// - The area can be made "No teleport"
int PHS_CannotTeleport(object oCaster, location lTarget)
{
    // Check for Dimensional Anchor
    if(PHS_GetDimensionalAnchor(oCaster))
    {
        SendMessageToPC(oCaster, "Your Dimensional Anchor stops extraplanar travel!");
        return TRUE;
    }

    // Check for waypoint
    object oWP = GetWaypointByTag("PHS_SPELL_NO_TELEPORT_WP");
    if(GetIsObjectValid(oWP))
    {
        // Return TRUE - cannot teleport
        SendMessageToPC(oCaster, "Your movement spell is disrupted!");
        return TRUE;
    }

    // Get nearest teleport trigger.
    object oTeleportTrigger = GetNearestObjectByTag("PHS_SPELL_NO_TELEPORT", oCaster);

    // Make sure oCaster is not in the trigger
    if(GetIsObjectValid(oTeleportTrigger) &&
       GetObjectType(oTeleportTrigger) == OBJECT_TYPE_TRIGGER)
    {
        // Loop objects in the trigger
        object oInTrig = GetFirstInPersistentObject(oTeleportTrigger, OBJECT_TYPE_CREATURE);
        while(GetIsObjectValid(oInTrig))
        {
            // Cannot teleport if in the trigger
            if(oInTrig == oCaster)
            {
                SendMessageToPC(oCaster, "Your movement spell is disrupted!");
                return TRUE;
            }
            oInTrig = GetNextInPersistentObject(oTeleportTrigger, OBJECT_TYPE_CREATURE);
        }
        // If we didn't find the caster was in the known trigger, check the
        // location

        // Make sure, that the location is valid, and not in a trigger
        // - We create a placeable object, invisible object, of a new tag mind
        //   you, for this.
        string sCaster = ObjectToString(oCaster);
        object oNewPlaceable = CreateObject(OBJECT_TYPE_PLACEABLE, "invis", lTarget, FALSE, sCaster);

        // We check the nearest trigger to the target location
        oTeleportTrigger = GetNearestObjectByTag("PHS_SPELL_NO_TELEPORT", oNewPlaceable);
        if(GetIsObjectValid(oTeleportTrigger))
        {
            if(GetObjectType(oTeleportTrigger) == OBJECT_TYPE_TRIGGER)
            {
                // Loop the objects in the teleport trigger
                oInTrig = GetFirstInPersistentObject(oTeleportTrigger, OBJECT_TYPE_PLACEABLE);
                while(GetIsObjectValid(oInTrig))
                {
                    // Cannot teleport if in the trigger
                    if(oInTrig == oNewPlaceable)
                    {
                        DestroyObject(oNewPlaceable);
                        SendMessageToPC(oCaster, "Your movement spell is disrupted!");
                        return TRUE;
                    }
                    oInTrig = GetNextInPersistentObject(oTeleportTrigger, OBJECT_TYPE_PLACEABLE);
                }
            }
        }

        // FINALLY, we check for any Dimensional Anchors in the target location.
        oTeleportTrigger = GetNearestObjectByTag(PHS_TAG_AOE_PER_DIMENSIONAL_LOCK, oNewPlaceable);
        if(GetIsObjectValid(oTeleportTrigger))
        {
            if(GetObjectType(oTeleportTrigger) == OBJECT_TYPE_AREA_OF_EFFECT)
            {
                // Loop the objects in the teleport trigger
                oInTrig = GetFirstInPersistentObject(oTeleportTrigger, OBJECT_TYPE_PLACEABLE);
                while(GetIsObjectValid(oInTrig))
                {
                    // Cannot teleport if in the trigger
                    if(oInTrig == oNewPlaceable)
                    {
                        DestroyObject(oNewPlaceable);
                        SendMessageToPC(oCaster, "Your movement spell is disrupted by Dimensional Lock!");
                        return TRUE;
                    }
                    oInTrig = GetNextInPersistentObject(oTeleportTrigger, OBJECT_TYPE_PLACEABLE);
                }
            }
        }

    }
    // We can teleport or whatever.
    return FALSE;
}

// Returns TRUE if oCreature is locked in this dimension by:
// - Dimensional Anchor
// - Dimensional Lock
int PHS_GetDimensionalAnchor(object oCreature)
{
    if(GetHasSpellEffect(PHS_SPELL_DIMENSIONAL_ANCHOR, oCreature) ||
       GetHasSpellEffect(PHS_SPELL_DIMENSIONAL_LOCK, oCreature))
    {
        return TRUE;
    }
    return FALSE;
}

// This is used for some spells to limit creatures by size. EG: Dimension door.
// This returns:
// - 1 for Medium, small and tiny creatures.
// - 2 for Large (Equivilant of 2 medium creatures)
// - 4 for Huge creature sizes (Equivilant of 2 Large creatures)
int PHS_SizeEquvilant(object oCreature)
{
    int iReturn = 1;
    int iSize = GetCreatureSize(oCreature);
    // Check size of creature
    switch(iSize)
    {
        case CREATURE_SIZE_TINY:   iReturn = 1; break;
        case CREATURE_SIZE_SMALL:  iReturn = 1; break;
        case CREATURE_SIZE_MEDIUM: iReturn = 1; break;
        case CREATURE_SIZE_LARGE:  iReturn = 2; break;
        case CREATURE_SIZE_HUGE:   iReturn = 4; break;
    }
    return iReturn;
}

// Removes all Fatigue from oTarget.
void PHS_RemoveFatigue(object oTarget)
{
    // Check for spells of X type...
    // - Ability Fatigue is just fatigue :-)
    if(GetHasSpellEffect(PHS_SPECIAL_FATIGUE, oTarget))
    {
        effect eCheck = GetFirstEffect(oTarget);
        while(GetIsEffectValid(eCheck))
        {
            // Check spell ID is fatigue
            if(GetEffectSpellId(eCheck) == PHS_SPECIAL_FATIGUE)
            {
                RemoveEffect(oTarget, eCheck);
            }
            eCheck = GetNextEffect(oTarget);
        }
    }
}

// Returns iHighest if it is over iHighest, or iLowest if under iLowest, or
// the integer put in if between them already.
int PHS_LimitInteger(int iInteger, int iHighest = 100, int iLowest = 1)
{
    if(iInteger > iHighest)
    {
        return iHighest;
    }
    else if(iInteger < iLowest)
    {
        return iLowest;
    }
    return iInteger;
}

// - Removes cirtain spells if the target is attacked, harmed and so on during
//   the spells effects.
void PHS_RemoveSpellsIfAttacked(object oAttacked = OBJECT_SELF)
{
    // - Removes Halt Undead effects
    PHS_RemoveSpellEffectsFromTarget(PHS_SPELL_HALT_UNDEAD, oAttacked);

    // - Others...
}

// This DESTROYS oTarget.
// - Removes plot flags, all inventory, before proper destorying.
void PHS_PermamentlyRemove(object oTarget)
{
    // Error check
    if(GetIsPC(oTarget)) return;
    // We can destroy them
    SetPlotFlag(oTarget, FALSE);
    SetImmortal(oTarget, FALSE);
    // If a creature, make sure their corpse is off
    if(GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
    {
        AssignCommand(oTarget, ClearAllActions());
        AssignCommand(oTarget, SetIsDestroyable(TRUE, FALSE, FALSE));
        SetLootable(oTarget, FALSE);
    }
    // Destory inventory
    if(GetHasInventory(oTarget))
    {
        object oItem = GetFirstItemInInventory(oTarget);
        while(GetIsObjectValid(oItem))
        {
            SetPlotFlag(oItem, FALSE);
            DestroyObject(oItem);
            oItem = GetNextItemInInventory(oTarget);
        }
    }
    // Destroy target
    DestroyObject(oTarget);
}

// Increase or decrease a stored integer on oTarget, by iAmount, under sName
void PHS_IncreaseStoredInteger(object oTarget, string sName, int iAmount)
{
    // Get old
    int iOriginal = GetLocalInt(oTarget, sName);
    // Add new
    int iNew = iOriginal + iAmount;
    // Set new
    SetLocalInt(oTarget, sName, iNew);
}

// Returns TRUE if oTarget's subrace is plant, or integer PHS_PLANT is valid.
int PHS_GetIsPlant(object oTarget)
{
    if(FindSubString(GetStringUpperCase(GetSubRace(oTarget)), "PLANT") >= 0)
    {
        return TRUE;
    }
    else if(GetLocalInt(oTarget, PHS_PLANT))
    {
        return TRUE;
    }
    return FALSE;
}

// This will make sure that oTarget is not commandable, and also that the commandable
// was not applied by some other spell which is active.
void PHS_SetCommandableOnSafe(object oTarget, int iSpellRemove)
{
    if(GetIsObjectValid(oTarget) && !GetCommandable(oTarget))
    {
        // Check spells which use SetCommandable
        if((!GetHasSpellEffect(PHS_SPELL_BESTOW_CURSE_RANDOM, oTarget) || iSpellRemove == PHS_SPELL_BESTOW_CURSE_RANDOM) &&
           (!GetHasSpellEffect(PHS_SPELL_TEMPORAL_STASIS, oTarget) || iSpellRemove == PHS_SPELL_TEMPORAL_STASIS) &&
           (!GetHasSpellEffect(PHS_SPELL_IMPRISONMENT, oTarget) || iSpellRemove == PHS_SPELL_IMPRISONMENT))
        {
            SetCommandable(TRUE, oTarget);
        }
    }
}

// Automatically reports sucess or failure for the ability check. The roll
// of d20 + iAbility's scrore needs to be >= nDC.
int PHS_AbilityCheck(object oCheck, int iAbility, int nDC)
{
    int nAbilityScore = GetAbilityScore(oCheck, iAbility);

    if(nAbilityScore + d20() >= nDC)
    {
        SendMessageToPC(oCheck, "Ability Check: Pass");
        return TRUE;
    }
    else
    {
        SendMessageToPC(oCheck, "Ability Check: Fail");
    }
    return FALSE;
}

// Applys the visual effect nVis, across from oStart to the object oTarget,
// at intervals of 0.05, playing the visual in the direction.
void PHS_ApplyBeamAlongVisuals(int nVis, object oStart, object oTarget, float fIncrement = 1.0)
{
    effect eVis = EffectVisualEffect(nVis);
    float fDelay;
    object oArea = GetArea(oStart);
    vector vTarget = GetPosition(oStart);
    vector vCaster = GetPosition(oTarget);
    vector vEffectStep = vTarget - vCaster; /* Get the vector from caster to target */
    int iFXCount = FloatToInt(VectorMagnitude(vEffectStep)/fIncrement); /* Determine the number of effects needed */
    vEffectStep = (VectorNormalize(vEffectStep) * fIncrement); /* generate the normalized vector (assuming a length of 1m) */
    vector vEffect = vCaster + vEffectStep; /* first Effect location (fIncrement from caster) */
    while(iFXCount > 0)
    {
        fDelay += 0.05;
        DelayCommand(fDelay, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, Location(oArea, vEffect, 0.0)));
        vEffect += vEffectStep; /* Move effect location 1m */
        iFXCount--; /* decrement the effect counter */
    }
}

// Returns TRUE if sunlight will kill/seriously damage/almost obliterate oTarget,
// IE: Vampires.
int PHS_GetHateSun(object oTarget)
{
    switch(GetAppearanceType(oTarget))
    {
        case APPEARANCE_TYPE_VAMPIRE_MALE:
        case APPEARANCE_TYPE_VAMPIRE_FEMALE:
        {
            return TRUE;
        }
        break;
    }
    // Check subrace
    string sSubrace = GetStringUpperCase(GetSubRace(oTarget));
    // Check subraces
    if(FindSubString(sSubrace, "VAMPIRE") >= 0)
    {
        return TRUE;
    }
    return FALSE;
}

// Check the caster item, and if they have just cast the spell, apply an amount
// of charges for a cirtain duration.
// - TRUE if the check passes, else FALSE
int PHS_CheckChargesForSpell(int nSpellId, int nChargesIfNew, float fDuration, object oCaster = OBJECT_SELF)
{
    // Check caster item
    object oCastItem = GetSpellCastItem();
    string sVariableName = "PHS_SPELL_CHARGES" + IntToString(nSpellId);
    if(GetIsObjectValid(oCastItem) &&
       GetTag(oCastItem) == "PHS_CLASS_ITEM")
    {
        // Check charges used by this item - do we have the effects at all?
        if(PHS_GetHasSpellEffectFromCaster(nSpellId, oCaster, oCaster))
        {
            // Got the spell's effects, so thats good.
            int nChargesNow = GetLocalInt(oCaster, sVariableName);

            // Check charges
            if(nChargesNow <= 0)
            {
                // No charges left
                SendMessageToPC(oCaster, "You have no more charges of this spell to release.");
                DeleteLocalInt(oCaster, sVariableName);
                PHS_RemoveSpellEffects(nSpellId, oCaster, oCaster);
                return FALSE;
            }
            else
            {
                // Decrease charges by 1
                nChargesNow--;
                SetLocalInt(oCaster, sVariableName, nChargesNow);
                SendMessageToPC(oCaster, "You can release the spell " + IntToString(nChargesNow) + " more times.");
                return TRUE;
            }
        }
        else
        {
            // Not got the spell's effects, bad, can't cast more
            DeleteLocalInt(oCaster, sVariableName);
            SendMessageToPC(oCaster, "You have not cast this spell in time, or not cast it at all, and cannot use another stored charge");
            return FALSE;
        }
    }
    else
    {
        // New spell from a scroll or normal spell, ETC.
        // Set charges and apply new effect
        effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oCaster, fDuration);
        SetLocalInt(oCaster, sVariableName, nChargesIfNew);
        SendMessageToPC(oCaster, "You can release the spell " + IntToString(nChargesIfNew) + " more times.");
        return TRUE;
    }
    // Default.
    return TRUE;
}

void PHS_ChangeMusicPermantly(object oArea, int iTrack, int iNightOrDay)
{
    MusicBackgroundStop(oArea);
    if(iNightOrDay)
    {
        MusicBackgroundChangeDay(oArea, iTrack);
    }
    else
    {
        MusicBackgroundChangeNight(oArea, iTrack);
    }
    MusicBackgroundPlay(oArea);
}

void PHS_PlayMusicForDuration(object oArea, int iTrack, float fDuration)
{
    int nMusicNight = MusicBackgroundGetNightTrack(oArea);
    int nMusicDay = MusicBackgroundGetDayTrack(oArea);
    // Change it.
    MusicBackgroundStop(oArea);
    if(nMusicNight != iTrack)
    {
        MusicBackgroundChangeNight(oArea, iTrack);
        DelayCommand(fDuration, PHS_ChangeMusicPermantly(oArea, nMusicNight, FALSE));
    }
    if(nMusicDay != iTrack)
    {
        MusicBackgroundChangeDay(oArea, iTrack);
        DelayCommand(fDuration, PHS_ChangeMusicPermantly(oArea, nMusicDay, TRUE));
    }
    MusicBackgroundPlay(oArea);
}

void PHS_ChangeAreaWether(object oArea, int iNewWether, float fDuration)
{
    // Return on error.
    if(fDuration < 0.0 || iNewWether > 2 || iNewWether < -1 || !GetIsObjectValid(oArea)) return;

    SetWeather(GetArea(OBJECT_SELF), iNewWether);

    DelayCommand(fDuration, SetWeather(GetArea(OBJECT_SELF), WEATHER_USE_AREA_SETTINGS));
}
