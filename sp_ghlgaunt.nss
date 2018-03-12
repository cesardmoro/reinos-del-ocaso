//::///////////////////////////////////////////////
//:: Name     Ghoul Gauntlet
//:: FileName   sp_ghlgaunt.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/** @file
Ghoul Gauntlet
Necromancy [Death, Evil]
Level: Sorcerer/Wizard 6
Components: V,S
Casting Time: 1 Standard Action
Range: Touch
Target: 1 Living Creature
Duration: Instantaneous
Saving Throw: Fortitude Negates
Spell Resistance: Yes


Your touch gradually transforms a living victim into
a ravening, flesh-eating ghoul. The transformation
process begins at the limb or extremity (usually the
hand or arm) touched. The victim takes 3d6 points of
damage per round while the body slowly dies as it is
transformed into a ghoul’s cold undying flesh. When
the victim reaches 0 hit points, she becomes a ghoul,
body and mind.

If the victim fails her initial saving throw, cure
disease, dispel magic, heal, limited wish, miracle,
mordenkainen's disjunction, remove curse, wish, or
greater restoration negates the gradual change.
Healing spells may temporarily prolong the process
by increasing the victims HP, but the transformation
continues unabated.

The ghoul that you create remains under your control
indefinitely. No matter how many ghouls you generate
with this spell, however, you can control only 2 HD
worth of undead creatures per caster level (this
includes undead from all sources under your control).
If you exceed this number, all the newly created
creatures fall under your control, and any excess
undead from previous castings become uncontrolled
(you choose which creatures are released). If you are
a cleric, any undead you might command by virtue of
your power to command or rebuke undead do not count
towards the limit.
*/
//:://////////////////////////////////////////////
//:: Created By: Tenjac
//:: Created On: 11/07/05
//::
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "spinc_common"
#include "prc_inc_spells"
#include "prc_inc_clsfunc"
#include "inc_persist_loca"

void SummonGhoul (int nHD, object oTarget, object oPC, location lCorpse)
{

    string sGhoul = "NW_GHOUL";

    //Ghast if levels 6 - 8
    if(nHD > 5)
    {
        sGhoul = "NW_GHAST";
    }
    //Ghoul Lord if levels 9 - 11
    if(nHD > 8)
    {
        sGhoul = "NW_GHOULLORD";
    }
    //Ghoul Ravager if 12 or above
    if (nHD > 11)
    {
        sGhoul = "NW_GHOULBOSS";
    }

    //Check for controlled undead and limit



    //Get original max henchmen
    int nMax = GetMaxHenchmen();

    //Set new max henchmen high
    SetMaxHenchmen(150);

    //Create appropriate Ghoul henchman
    object oGhoul = CreateObject(OBJECT_TYPE_CREATURE, sGhoul, lCorpse, TRUE);

    //Make henchman
    AddHenchman(oPC, oGhoul);

    //Restore original max henchmen
    SetMaxHenchmen(nMax);
}

void Gauntlet(object oTarget, object oPC, int nHP, int nHD)
{
    int nDam = 0;


    //deal damage
    nDam = d6(3);
    effect eDam = EffectDamage(nDam, DAMAGE_TYPE_MAGICAL);
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);

    //redefine nHP after damage
    nHP = GetCurrentHitPoints(oTarget);

    //check for removal conditions
    if(!GetPersistantLocalInt(oTarget, "HAS_CURSE")|| !GetPersistantLocalInt(oTarget, "HAS_DISEASE"))

    {
        RemoveSpellEffects(SPELL_GHOUL_GAUNTLET, oPC, oTarget);
        return;
    }


    //if target still has HP, run again on next round.  Avoids use of loop.
    if (nHP > 1)
    {
        DelayCommand(6.0f, Gauntlet(oTarget, oPC, nHP, nHD));
    }

    else
    {
        //Get location of corpse
        location lCorpse = GetLocation(oTarget);

        //Apply VFX
        effect eVis = EffectVisualEffect(VFX_DUR_SMOKE);
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lCorpse);

        //Summon a ghoul henchman
        SummonGhoul(nHD, oTarget, oPC, lCorpse);
    }
}

void main()
{
    //Spellhook
    if (!X2PreSpellCastCode()) return;

    //define variables

    object oPC = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    int nCasterLvl = PRCGetCasterLevel(OBJECT_SELF);

    //Spell Resistance
    if (!MyPRCResistSpell(oPC, oTarget, nCasterLvl + SPGetPenetr()))
    {
        int nDC = SPGetSpellSaveDC(oTarget, oPC);

        //Saving Throw
        if (!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_EVIL))
        {
            int nHP = GetCurrentHitPoints(oTarget);
            int nHD = GetHitDice(oTarget);
            int nDam;

            //Set persistant local to handle tracking of Remove Curse
            SetPersistantLocalInt(oTarget, "HAS_CURSE", 1);

            //Set persistant local to handle tracking of Remove Disease
            SetPersistantLocalInt(oTarget, "HAS_DISEASE", 1);

            Gauntlet(oTarget, oPC, nHP, nHD);
        }
    }
    //SPEvilShift(oPC);
}
