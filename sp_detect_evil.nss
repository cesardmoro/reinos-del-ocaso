/*
Detect Evil

Divination
Level: Clr 1, Rgr 2
Components: V, S, DF
Casting Time: 1 action
Range: 60 ft.
Area: Quarter circle emanating from you
to the extreme of the range
Duration: Concentration, up to 10
minutes/level (D)
Saving Throw: None
Spell Resistance: No

You can sense the presence of evil. The amount of information revealed depends
on how long you study a particular area or subject:
1st Round: Presence or absence of evil.
2nd Round: Number of evil auras (creatures, objects, or spells) in the area and
the strength of the strongest evil aura present. If you are of good alignment, the strongest evil aura�s strength is
"overwhelming" (see below), and the strength is at least twice your character
level, you are stunned for 1 round and the spell ends. While you are stunned, you
can�t act, you lose any Dexterity bonus to AC, and attackers gain +2 bonuses to attack
you.
3rd Round: The strength and location of each aura. If an aura is outside your line of
sight, then you discern its direction but not its exact location.

Aura Strength: An aura�s evil power and strength depend on the type of evil
creature or object that you�re detecting and its HD, caster level, or (in the case of a
cleric) class level.

Creature/Object     Evil Power
Evil creature       HD / 5
Undead creature     HD / 2
Evil elemental       HD / 2
Evil outsider       HD
Cleric of an evil deity     Caster Level

Evil Power      Aura Strength
Lingering       Dim
1 or less       Faint
2�4         Moderate
5�10        Strong
11+         Overwhelming
If an aura falls into more than one strength category, the spell indicates the stronger of
the two.

Remember that animals, traps, poisons, and other potential perils are not evil; this
spell does not detect them.

Note: Each round, you can turn to detect things in a new area but if you move
more than 2 meters the spell ends. The spell can penetrate barriers, but 1 foot
of stone, 1 inch of common metal, a thin sheet of lead, or 3 feet of wood or dirt
blocks it.

*/
/*******************************************************************************
12/03/07 - Script By Dragoncin
Conjuro Detect evil
*******************************************************************************/

#include "sp_detect_inc"

void main()
{
    int metamagia = GetMetaMagicFeat();
    if (GetLevelByClass(CLASS_TYPE_PALADIN, OBJECT_SELF) > 0)
        metamagia = METAMAGIC_QUICKEN;

    Detect_Round1(OBJECT_SELF, ALIGNMENT_EVIL, metamagia);
}


/*Script del PRC:

#include "prc_inc_s_det"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_DIVINATION);


    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    location lTarget = PRCGetSpellTargetLocation();
    if(GetIsObjectValid(PRCGetSpellTargetObject()))
        lTarget = GetLocation(PRCGetSpellTargetObject());
    //                                                   "evil"
    DetectAlignmentRound(0, lTarget, ALIGNMENT_EVIL, -1, GetStringByStrRef(4960), VFX_BEAM_EVIL);
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
} */
