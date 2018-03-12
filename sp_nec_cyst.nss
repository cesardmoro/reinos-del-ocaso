//::///////////////////////////////////////////////
//:: Name      Necrotic Cyst
//:: FileName  sp_nec_cyst.nss
//:://////////////////////////////////////////////
/** @file
Necrotic Cyst
Necromancy [Evil]
Level: Clr 2, sor/wiz 2
Components: V, S, F
Casting Time: 1 standard action
Range: Touch
Target: Living creature touched
Duration: Instantaneous
Saving Throw: Fortitude negates
Spell Resistance: Yes

The subject develops an internal spherical sac that
contains fluid or semisolid necrotic flesh. The 
internal cyst is noticeable as a slight bulge on the
subject's arm, abdomen, face (wherever you chose to 
touch the target) or it is buried deeply enough in 
the flesh of your target that it is not immediately 
obvious-the subject may not realize what was implanted
within her.

From now on, undead foes and necromantic magic are 
particularly debilitating to the subject-the cyst 
enables a sympathetic response between free-roaming 
external undead and itself. Whenever the victim is 
subject to a spell or effect from the school of 
necromancy, she makes saving throws to resist at a -2
penalty. Whenever the subject is dealt damage by the
natural weapon of an undead (claw, bite, or other 
attack form), she takes an additional 1d6 points of 
damage.

Victims who possess necrotic cysts may elect to have 
some well-meaning chirurgeon remove them surgically. 
The procedure is a bloody, painful process that 
incapacitates the subject for 1 hour on a successful 
DC 20 Heal check, and kills the subject with an 
unsuccessful Heal check. The procedure takes 1 hour, 
and the chirurgeon can't take 20 on the check.

Protection from evil or a similar spell prevents the 
necrotic cyst from forming. Once a necrotic cyst is 
implanted, spells that manipulate the cyst and its 
bearer are no longer thwarted by protection from evil.

    Author:    Tenjac
    Created:   10/30/05
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "spinc_necro_cyst"
#include "inc_utility"
#include "spinc_common"
#include "prc_spell_const"
#include "prc_inc_spells"

void main()
{		
	// Set the spellschool
	SPSetSchool(SPELL_SCHOOL_NECROMANCY); 
	
	// Run the spellhook. 
	if (!X2PreSpellCastCode()) return;
	
	//Define vars
	object oPC = OBJECT_SELF;
	object oTarget = GetSpellTargetObject();
	int nCasterLvl = PRCGetCasterLevel(oPC);
	
	//Check for Mother Cyst
	if(!GetCanCastNecroticSpells(oPC))
	{
		return;
	}
			
	//Check for Protection from Evil
	if(GetHasSpellEffect(SPELL_PROTECTION_FROM_EVIL, oTarget))
	return;
	
	//Check for Magic Circle against Evil
	if(GetHasSpellEffect(SPELL_MAGIC_CIRCLE_AGAINST_EVIL))
	return;
	
	//Check Spell Resistance
	if (MyPRCResistSpell(oPC, oTarget, nCasterLvl + SPGetPenetr()))
	{
		return;
	}
	
	//Calculate DC
	int nDC = SPGetSpellSaveDC(oTarget, oPC);
	
	//Resolve Spell if failed save
	if (!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_EVIL))    
	{
		GiveNecroticCyst(oTarget);
	}
	
	SPEvilShift(oPC);
	
	SPSetSchool();
}