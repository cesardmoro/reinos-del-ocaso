//::///////////////////////////////////////////////
//:: Name    Night's Caress 
//:: FileName   sp_nght_caress.nss
//:: 
//:: Author: Tenjac
//:: Created: 12/13/05
//:://////////////////////////////////////////////
/** @file
   School: Necromancy [Evil]
   Level: Sorc/Wiz 5
   Compnents: V,S
   Range: Touch
   Duration: Instantaneous
   Save: Fortitude partial
   Spell Resistance: Yes
   
   A touch from your hand, which sheds darkness like 
   the blackest of night, disrupts the life force of
   a living creature.  Your touch deals 1d6 points of
   damage per caster level (max 15d6), and 1d6+2 
   points of Constituion damage (a sucessful Fortitude
   saving throw negates the Constitution damage.)
   
   The spell has a special effect on an undead creature.
   An undead touched by you takes no damage, but it 
   must make a successful Will saving throw or flee
   as if panicked for 1d4 rounds + 1 round per caster
   level.
   
*/
//:://////////////////////////////////////////////
//:: Created By: Tenjac
//:: Created On: 12/13/05
//::
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "inc_abil_damage"
#include "spinc_common"
#include "prc_inc_spells"

void main()
{
	if (!X2PreSpellCastCode())
	{
		// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
		return;
	}
	
// End of Spell Cast Hook
	
	SPSetSchool(SPELL_SCHOOL_NECROMANCY);
	
	//define vars
	object oPC = OBJECT_SELF;
	object oTarget = GetSpellTargetObject();
	int nCasterLevel = PRCGetCasterLevel(OBJECT_SELF);
        int nDC = SPGetSpellSaveDC(oTarget, oPC);
        int nMetaMagic = PRCGetMetaMagicFeat();
        
	//Make touch attack
	int nTouch = PRCDoMeleeTouchAttack(oTarget);
		
	// if fails touch
	if(!nTouch)
	{
			return;
	}
	
	//if undead
	int nType = MyPRCGetRacialType(oTarget);
	
	if(nType == RACIAL_TYPE_UNDEAD)
	{
		//Will saving throw
		if (!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_EVIL))
		{
			float fRounds = RoundsToSeconds(d4(1) + nCasterLevel);
			
			if (CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND))
			{
				fRounds = (fRounds * 2);
			}
			
			effect eFear = EffectFrightened();
			effect eVis = EffectVisualEffect(VFX_IMP_HEAD_EVIL);
			effect eLink = EffectLinkEffects(eFear, eVis);
			
			SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fRounds);
			return;
		}
	}
			
	//Spell Resistance
	if (!MyPRCResistSpell(oPC, oTarget, nCasterLevel + SPGetPenetr()))
	{	
		//Max of 15 caster levels
		if (nCasterLevel > 15) 
		{
			nCasterLevel = 15;
		}
		
		int nDam = d6(nCasterLevel);
		
		//Metmagic: Maximize
		if (nMetaMagic == METAMAGIC_MAXIMIZE)
		{
			nDam = 6 * (nCasterLevel);
		}
		
		//Metmagic: Empower
		if (nMetaMagic == METAMAGIC_EMPOWER)
		{
			nDam += (nDam/2);
		}
		
		effect eDam = EffectDamage(nDam, DAMAGE_TYPE_MAGICAL);
		
		//Apply damage as magical
		SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
						
		// Fort saving throw 
		if (!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_EVIL))
		{
			int nConDam = (d6(1) + 2);
			
			if (nMetaMagic == METAMAGIC_MAXIMIZE)
			{
				nConDam = 8;
			}
			
			if (nMetaMagic == METAMAGIC_EMPOWER)
			{
				nConDam += (nConDam/2);
			}
			
			//Drain VFX
			effect eVis2 = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
			
			//Ability damage healing 1 point per hour
			ApplyAbilityDamage(oTarget, ABILITY_CONSTITUTION, nConDam, DURATION_TYPE_TEMPORARY, TRUE, -1.0, FALSE, SPELL_NIGHTS_CARESS);
			SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis2, oTarget);
		}
	}
	SPEvilShift(oPC);
	
	SPSetSchool();
}
		

			