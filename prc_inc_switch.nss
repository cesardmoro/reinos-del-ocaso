/**
 * @file
 * This file defines names of switches that can be used to modify
 * the behaviour of certain parts of the PRC pack.
 * It also contains functions for getting and setting the values of
 * these switches and in addition some functions dealing with the
 * implementation of certain switches.
 */

 /* This variable MUST be updated with every new version of the PRC!!! */

 const string PRC_VERSION                           = "PRC 2.3 alpha 15";


/******************************************************************************\
*                                  Spell switches                              *
\******************************************************************************/

/** Bioware True Seeing can see stealthed creatures.
 * This replaces the trueseeing effect with a See Invisible + Ultravision + Spot bonus.
 * This affects the spell and power True Seeing and the Dragon Disciple class
 */
const string PRC_PNP_TRUESEEING                      = "PRC_PNP_TRUESEEING";

/**
 * PRC_PNP_TRUESEEING must be on.
 * Value of spot skill bonus that True Seeing grants.
 * Defaults to +15 if not set.
 */
const string PRC_PNP_TRUESEEING_SPOT_BONUS           = "PRC_PNP_TRUESEEING_SPOT_BONUS";

/** Remove the cap PRC added to this spell */
const string PRC_BIOWARE_GRRESTORE                   = "PRC_BIOWARE_GRRESTORE";
/** Remove the cap PRC added to this spell */
const string PRC_BIOWARE_HEAL                        = "PRC_BIOWARE_HEAL";
/** Remove the cap PRC added to this spell */
const string PRC_BIOWARE_MASS_HEAL                   = "PRC_BIOWARE_MASS_HEAL";
/** Remove the cap PRC added to this spell */
const string PRC_BIOWARE_HARM                        = "PRC_BIOWARE_HARM";
/** Remove the cap PRC added to this spell */
const string PRC_BIOWARE_NEUTRALIZE_POISON           = "PRC_BIOWARE_NEUTRALIZE_POISON";
/** Remove the cap PRC added to this spell */
const string PRC_BIOWARE_REMOVE_DISEASE              = "PRC_BIOWARE_REMOVE_DISEASE";


/***
 * Timestop has Bioware durations (9 seconds or 18 for Greater Timestop) rather
 * than PnP durations (1d4+1 or 2d4+2)
 */
const string PRC_TIMESTOP_BIOWARE_DURATION           = "PRC_TIMESTOP_BIOWARE_DURATION";

/**
 * Timestop has only a local affect, i.e doesn't stop people on the other areas of the module.
 * Note that AOEs continue to act during a timestop, and durations/delayed events still occur.
 */
const string PRC_TIMESTOP_LOCAL                      = "PRC_TIMESTOP_LOCAL";

/**
 * PRC_TIMESTOP_LOCAL must be enabled.
 * Caster can't perform any hostile actions while in timestop.
 */
const string PRC_TIMESTOP_NO_HOSTILE                 = "PRC_TIMESTOP_NO_HOSTILE";

/**
 * PRC_TIMESTOP_LOCAL must be enabled.
 * PCs can't see anything while stopped.
 * This might look to the player like their game crashed.
 */
const string PRC_TIMESTOP_BLANK_PC                   = "PRC_TIMESTOP_BLANK_PC";

/**
 * Instead of Bioware's sequential summons it creates multiple elementals.
 * Only works if PRC_MULTISUMMON is on
 */
const string PRC_PNP_ELEMENTAL_SWARM                 = "PRC_PNP_ELEMENTAL_SWARM";

/**
 * If you pass a save, you can't be affected by that aura for 24h.
 * NOTE: Not implemented yet
 */
const string PRC_PNP_FEAR_AURAS                      = "PRC_PNP_FEAR_AURAS";

/**
 * Not a polymorph but ability bonuses instead.
 */
const string PRC_PNP_TENSERS_TRANSFORMATION          = "PRC_PNP_TENSERS_TRANSFORMATION";

/**
 * Less powerful, more PnP accurate version.
 * Caster must concentrate to maintain it.
 */
const string PRC_PNP_BLACK_BLADE_OF_DISASTER         = "PRC_PNP_BLACK_BLADE_OF_DISASTER";

/**
 * Traps are only shown, not disarmed
 */
const string PRC_PNP_FIND_TRAPS                      = "PRC_PNP_FIND_TRAPS";

/**
 * PnP Darkness
 * Is a mobile AOE based off an item
 */
const string PRC_PNP_DARKNESS                        = "PRC_PNP_DARKNESS";

/**
 * 3.5ed Darkness
 * Gives 20% concelement rather than bioware darkness
 */
const string PRC_PNP_DARKNESS_35ED                   = "PRC_PNP_DARKNESS_35ED";

/**
 * Undead summons are permanent, but can only have 4HD/casterlevel in total
 * Does not enforce the requirement for a corpse
 */
const string PRC_PNP_ANIMATE_DEAD                    = "PRC_PNP_ANIMATE_DEAD";

/**
 * "Word of Faith" spells use 3.5 ed rules rather than 3.0ed
 * basically instead of 12+ / <12 / <8 / <4 its relative to caster level
 * at >=CL / <CL / <CL-5 / <CL-10
 * This basically makes it more powerful at higher levels
 */
const string PRC_35ED_WORD_OF_FAITH                  = "PRC_35ED_WORD_OF_FAITH";

/*
 * Undead created by Create Undead and Create Greater Undead are
 * not automatically under the casters control
 * If this is set, the undead are permanently created
 */
const string PRC_CREATE_UNDEAD_UNCONTROLLED          = "PRC_CREATE_UNDEAD_UNCONTROLLED";

/*
 * Undead created by Create Undead and Create Greater Undead are
 * not removed on resting etc
 */
const string PRC_CREATE_UNDEAD_PERMANENT             = "PRC_CREATE_UNDEAD_PERMANENT";

/*
 * Sleep and Deep Slumber dont have a limit on the
 * HD of a target to be effected.
 */
const string PRC_SLEEP_NO_HD_CAP                     = "PRC_SLEEP_NO_HD_CAP";

/**
 * By request, set this to use the 1.65 behaviour for implosion, phantasmal killer,
 * and weird, i.e. death immunity counts
 * This is in addition to the extra immunities 1.66 adds
 */
const string PRC_165_DEATH_IMMUNITY                  = "PRC_165_DEATH_IMMUNITY";

/*
 * This is for builders. It should not be set on the module, but should be set on players/creatures.
 * When this is set, it will override spell DC for all spells cast (including SLAs and items)
 * This will overrule all feats, racial bonuses, etc that would effect DC
*/
const string PRC_DC_TOTAL_OVERRIDE                   = "PRC_DC_TOTAL_OVERRIDE";

/*
 * This is for builders. It should not be set on the module, but should be set on players/creatures.
 * When this is set, it will override spell DC for all spells cast (including SLAs and items)
 * This will ony override base DC+spelllevel+statmod, feats race etc are added on top of this
*/
const string PRC_DC_BASE_OVERRIDE                   = "PRC_DC_BASE_OVERRIDE";

/*
 * This is for builders. It should not be set on the module, but should be set on players/creatures.
 * When this is set, it will add to spell DC for all spells cast (including SLAs and items)
*/
const string PRC_DC_ADJUSTMENT                       = "PRC_DC_ADJUSTMENT";

/*
 * This is for builders. It should not be set on the module, but should be set on players/creatures.
 * When this is set, it will override spell casterlevel for all spells cast (including SLAs and items)
*/
const string PRC_CASTERLEVEL_OVERRIDE                = "PRC_CASTERLEVEL_OVERRIDE";

/*
 * This is for builders. It should not be set on the module, but should be set on players/creatures.
 * When this is set, it will add to spell casterlevel for all spells cast (including SLAs and items)
*/
const string PRC_CASTERLEVEL_ADJUSTMENT              = "PRC_CASTERLEVEL_ADJUSTMENT";

/*
 * Mostly internal, but builders may find a use for it
 * Used to override GetLastSpellCastClass();
*/
const string PRC_CASTERCLASS_OVERRIDE                = "PRC_CASTERCLASS_OVERRIDE";

/*
 * Mostly internal, but builders may find a use for it
 * Used to override PRCGetSpellTargetLocation();
 * To activate set a location and an int on the module
 * The int must be TRUE
*/
//const string PRC_SPELL_TARGET_LOCATION_OVERRIDE      = "PRC_SPELL_TARGET_LOCATION_OVERRIDE";

/*
 * Mostly internal, but builders may find a use for it
 * Used to override PRCGetSpellTargetObject();
 * To activate set a object and an int on the module
 * The int must be TRUE
*/
//const string PRC_SPELL_TARGET_OBJECT_OVERRIDE        = "PRC_SPELL_TARGET_OBJECT_OVERRIDE";

/*
 * This is for builders. It should not be set on the module, but should be set on players/creatures.
 * When this is set, it will add to spell metamagic. Not all spells may accept this.
 * Only use Empower, Extend, or Maximize.
 * Still, Silent, and Quicken wont work
*/
const string PRC_METAMAGIC_ADJUSTMENT                 = "PRC_METAMAGIC_ADJUSTMENT";

/*
 * Mostly internal, but builders may find a use for it
 * Used to override PRCGetMetaMagicFeat();
 * Only use Empower, Extend, or Maximize.
 * Still, Silent, and Quicken wont work
*/
const string PRC_METAMAGIC_OVERRIDE                   = "PRC_METAMAGIC_OVERRIDE";

/*
 * Override for SpellID for PRCGetSpellID()
 * Doesnt effect spellID from effects, or automatic 2da reads
 */
const string PRC_SPELLID_OVERRIDE                     = "PRC_SPELLID_OVERRIDE";

/******************************************************************************\
*                                  Class switches                              *
\******************************************************************************/

/*
 * This turns on the new improved imbue arrow functionallity
 * so all the player has to do is cast the spell at an arrow in their inventory
 * If this is off, players get the default bioware imbue arrow as a bonus feat on their hides
*/
const string PRC_USE_NEW_IMBUE_ARROW                 = "PRC_USE_NEW_IMBUE_ARROW";

/*
 * If this is set, the Dragon Disciple size increases at level 15 and 25 will be disabled
 * Players will still recieve the feats, but they will not do anything.
*/
const string PRC_DRAGON_DISCIPLE_SIZE_CHANGES        = "PRC_DRAGON_DISCIPLE_SIZE_CHANGES";

/*
 *   Start of samurai switches
 */

/*
 * This values are divided by 100 when applied so a value of 100 is equivalent
 * to 1.0
 */

/*
 *
 *
 *
 */
const string PRC_SAMURAI_                            = "PRC_SAMURAI_";

/*
 * This allows samurai to sacrifice stolen items
 */
const string PRC_SAMURAI_ALLOW_STOLEN_SACRIFICE      = "PRC_SAMURAI_ALLOW_STOLEN_SACRIFICE";

/*
 * This allows samurai to sacrifice unidentified items
 * They will get full value for them however
 */
const string PRC_SAMURAI_ALLOW_UNIDENTIFIED_SACRIFICE= "PRC_SAMURAI_ALLOW_UNIDENTIFIED_SACRIFICE";

/*
 * This scales the value of sacrificed items
 * This values are divided by 100 when applied so a value of 100 is equivalent
 * to 1.0
 */
const string PRC_SAMURAI_SACRIFICE_SCALAR_x100       = "PRC_SAMURAI_SACRIFICE_SCALAR_x100";

/*
 * This scales the maximum value a samurai can have
 * This values are divided by 100 when applied so a value of 100 is equivalent
 * to 1.0
 */
const string PRC_SAMURAI_VALUE_SCALAR_x100           = "PRC_SAMURAI_VALUE_SCALAR_x100";

/******************************************************************************\
*                               Epic Spell switches                            *
\******************************************************************************/

/**
 * If set, then the switches below will not be set to default values.
 * Should be used if any customisation is done.
 */
const string PRC_EPIC_INGORE_DEFAULTS                = "PRC_EPIC_INGORE_DEFAULTS";

/**
 * Do epic spells cost XP to cast?
 * Defaults to: TRUE
 */
const string PRC_EPIC_XP_COSTS                       = "PRC_EPIC_XP_COSTS";

/**
 * Do casters take 10 when researching?
 * Defaults to: FALSE
 */
const string PRC_EPIC_TAKE_TEN_RULE                  = "PRC_EPIC_TAKE_TEN_RULE";

/**
 * Use caster's primary ability (divine casters Wis, arcane Int/Cha as appropriate)
 * Defaults to: FALSE
 */
const string PRC_EPIC_PRIMARY_ABILITY_MODIFIER_RULE  = "PRC_EPIC_PRIMARY_ABILITY_MODIFIER_RULE";

/**
 * Do epic spells do backlash damage if specified in the spell?
 * Defaults to: TRUE
 */
const string PRC_EPIC_BACKLASH_DAMAGE                = "PRC_EPIC_BACKLASH_DAMAGE";

/**
 * Do school foci change the research and casting DC?
 * Defaults to: TRUE
 */
const string PRC_EPIC_FOCI_ADJUST_DC                 = "PRC_EPIC_FOCI_ADJUST_DC";

/**
 * DC multiplier for gold to research.
 * Defaults to: 9000 as per PnP
 */
const string PRC_EPIC_GOLD_MULTIPLIER                = "PRC_EPIC_GOLD_MULTIPLIER";

/**
 * Amount the researched spell's gold cost is divided by to get it's XP cost.
 * Defaults to: 25
 */
const string PRC_EPIC_XP_FRACTION                    = "PRC_EPIC_XP_FRACTION";

/**
 * Proportion of research gold is lost in a failed attempt. The full cost is
 * divided by this value to get the amount lost.
 * Defaults to: 2 (i.e half)
 */
const string PRC_EPIC_FAILURE_FRACTION_GOLD          = "PRC_EPIC_FAILURE_FRACTION_GOLD";

/**
 * Probablity out of 100 of seeds being destroyed when learnt.
 * Defaults to: 50
 */
const string PRC_EPIC_BOOK_DESTRUCTION               = "PRC_EPIC_BOOK_DESTRUCTION";

/** 100% immunity and 20h duration instead of 50% and casterlevel+10 rounds. */
const string PRC_PNP_UNIMPINGED                      = "PRC_PNP_UNIMPINGED";

/** 100% immunity and 20h duration instead of 50% and casterlevel+10 rounds. */
const string PRC_PNP_IMPENETRABILITY                 = "PRC_PNP_IMPENETRABILITY";

/** 100% immunity and 20h duration instead of 50% and casterlevel+10 rounds. */
const string PRC_PNP_DULLBLADES                      = "PRC_PNP_DULLBLADES";

/** 20h instead of rounds per level */
const string PRC_PNP_CHAMPIONS_VALOR                  = "PRC_PNP_CHAMPIONS_VALOR";




/******************************************************************************\
*                                General switches                              *
\******************************************************************************/

/** DO NOT SET THIS SWITCH
 * The companion sets it automatically.
 * It is only here to be used by other scripts.
 */
const string PRC_COMPANION_IN_USE                    = "PRC_COMPANION_IN_USE";

/** DO NOT SET THIS SWITCH
 * The companion sets it automatically.
 * It is only here to be used by other scripts
 */
const string PRC_CEP_COMPANION_IN_USE                = "PRC_CEP_COMPANION_IN_USE";

/**
 * Spells cast from magic staffs use the wielder's casterlevel rather than the
 * item's if the wielder's casterlevel is higher.
 * This makes magic staffs more valuable to mages, especially at high levels.
 */
const string PRC_STAFF_CASTER_LEVEL                  = "PRC_STAFF_CASTER_LEVEL";

/**
 * NPCs go through spellhooking as if they are PCs.
 */
const string PRC_NPC_HAS_PC_SPELLCASTING             = "PRC_NPC_HAS_PC_SPELLCASTING";

/**
 * Stops players banking loads of XP without leveling by using the level they
 * would have with their current XP instead of whatever their level is.
 */
const string PRC_ECL_USES_XP_NOT_HD                  = "PRC_ECL_USES_XP_NOT_HD";

/**
 * Stops demilich, i.e. Lich class has only 4 levels
 */
const string PRC_DISABLE_DEMILICH                    = "PRC_DISABLE_DEMILICH";

/**
 * Defines the possible uses of the Epic Spell Laboratory. Values as follows:
 *
 * 0 = (default) Can teleport to the Epic Spell Laboratory, merchant sells all
 *     epic spells and new wizard scrolls.
 * 1 = Can teleport to the Epic Spell Laboratory, merchant sells only the epic
 *     spells available in HotU and new wizard scrolls.
 * 2 = Can teleport to the Epic Spell Laboratory, but the merchant is unavailable.
 * 3 = Cannot teleport to the Epic Spell Laboratory.
 */
const string PRC_SPELLSLAB                           = "PRC_SPELLSLAB";

/**
 * Disables the sale of scrolls from the epic spell laboratory.
 */
const string PRC_SPELLSLAB_NOSCROLLS                 = "PRC_SPELLSLAB_NOSCROLLS";

/**
 * Disables the sale of crafting recipes from the epic spell laboratory.
 */
const string PRC_SPELLSLAB_NORECIPES                 = "PRC_SPELLSLAB_NORECIPES";

/**
 * Makes reaching 0 in an ability score have the special effects it should have
 * according to PnP.
 *
 * @see inc_abil_damage.nss
 */
const string PRC_PNP_ABILITY_DAMAGE_EFFECTS          = "PRC_PNP_ABILITY_DAMAGE_EFFECTS";

/**
 * Turns on the included version of supply based rest by demitious
 * See inc_sbr_readme.nss for details
 */
const string PRC_SUPPLY_BASED_REST                   = "PRC_SUPPLY_BASED_REST";

/**
 * Charaters only gain a number of hitpoints equal to their level from resting.
 */
const string PRC_PNP_REST_HEALING                    = "PRC_PNP_REST_HEALING";

/**
 * Resting causes game time to advance.
 * See inc_time.nss for details
 */
const string PRC_PNP_REST_TIME                       = "PRC_PNP_REST_TIME";

/**
 * Wizards use PnP spellschools instead of Bioware's
 * They must be generalists, but there is no way to enforce that
 * If letoscript is enabled, then all wizards will be set to PnP Spellschool as their school
 * plus the ConvoCC will set it if this switch is on
 */
const string PRC_PNP_SPELL_SCHOOLS                   = "PRC_PNP_SPELL_SCHOOLS";

/**
 * Players have a variable tracking how far ahead of the module clock they are
 * and when all players are ahead, the module clock advances to catch up.
 */
const string PRC_PLAYER_TIME                         = "PRC_PLAYER_TIME";

/**
 * You must have at least 1 hand free to cast spells with somatic components.
 * This means at most a small shield in the off hand and
 * no dual weilded weapons, though ranged and doublehanded are OK.
 */
const string PRC_PNP_SOMATIC_COMPOMENTS              = "PRC_PNP_SOMATIC_COMPOMENTS";

/**
 * You must have at least 1 hand free to use items that you do not have equipped.
 * This means at most a small shield in the off hand and
 * no dual weilded weapons, though ranged and doublehanded are OK.
 */
const string PRC_PNP_SOMATIC_ITEMS                   = "PRC_PNP_SOMATIC_ITEMS";

/**
 * Second or subsequent summons dont destroy the first.
 * Can cause lag with high numbers of summons and/or tight spaces
 */
const string PRC_MULTISUMMON                         = "PRC_MULTISUMMON";

/**
 * Summons last for a number of rounds equal to caster level, rather than 24h or other timings
 */
const string PRC_SUMMON_ROUND_PER_LEVEL              = "PRC_SUMMON_ROUND_PER_LEVEL";

/**
 * Familiars follow PnP rules rather than Bioware's.
 * This makes them a lot weaker and less suited for combat.
 * Includes bonded summoner familiars.
 */
const string PRC_PNP_FAMILIARS                       = "PRC_PNP_FAMILIARS";

/**
 * This disables the ability to heal Bioware familiars by feading them
 * through the conversation
 */
const string PRC_PNP_FAMILIAR_FEEDING                = "PRC_PNP_FAMILIAR_FEEDING";

/**
 * This disables the ability to reroll HP at levelup
 * It requires letoscript to work.
 */
const string PRC_NO_HP_REROLL                        = "PRC_NO_HP_REROLL";

/**
 * This disables the 2 free spells wizards get at levelup
 * The GUI still shows, but it does nothing or rather its effects are undone afterwards
 * It requires letoscript to work.
 * not implemented yet
 */
const string PRC_NO_FREE_WIZ_SPELLS                        = "PRC_NO_FREE_WIZ_SPELLS";

/**
 * Sets the behaviour of the PRC Power Attack. Set this to either
 * PRC_POWER_ATTACK_DISABLED or PRC_POWER_ATTACK_FULL_PNP if you give
 * it a value.
 *
 * Default: One cannot use a higher power attack setting than one could using
 *          Bioware Power Attack. ie, if one possessed PA, but not IPA, one
 *          can only use PA up to 5. And up to 10 with IPA.
 *
 * @see PRC_POWER_ATTACK_DISABLED
 * @see PRC_POWER_ATTACK_FULL_PNP
 */
const string PRC_POWER_ATTACK                        = "PRC_POWER_ATTACK";

/**
 * A possible value of PRC_POWER_ATTACK.
 * If this is used, PRC Power Attack is completely disabled. The feats will
 * not be granted to players and even if they somehow gain access to the feats,
 * they will have no effect.
 *
 * @see PRC_POWER_ATTACK
 */
const int PRC_POWER_ATTACK_DISABLED = -1;

/**
 * A possible value of PRC_POWER_ATTACK.
 * If this is used, PRC Power Attack behaves as the Pen and Paper version.
 * This means ability to sacrifice any amount of attack bonus, up to one's
 * BAB. The existence of Bioware IPA is ignored as a limiting factor, only
 * normal Power Attack is required.
 *
 * @see PRC_POWER_ATTACK
 */
const int PRC_POWER_ATTACK_FULL_PNP = 1;

/**
 * Sets the behaviour of the PRC Power Attack.
 * If this is set, the Bioware Power Attack modes are included in the
 * calculation against the characters BAB limit.
 * Default: PRC Power Attack ignores whether BW Power Attack is active or not,
 *          which may result in the character paying a total amount of AB
 *          greater than their BAB.
 */
const string PRC_POWER_ATTACK_STACK_WITH_BW          = "PRC_POWER_ATTACK_STACK_WITH_BW";


/*
 * Disabling specific feat and/or skills
 * Each of these has 2 parts. One part is a variable defining the size of the list
 * The other part is the list itself. The numbers are the row numbers in feat.2da or skills.2da
 * or spells.2da.
 * For example, if you want to disable Knockdown and Improved Knockdown you would set
 * the variables as follows:
 * PRC_DISABLE_FEAT_COUNT = 2
 * PRC_DISABLE_FEAT_1     = 23
 * PRC_DISABLE_FEAT_2     = 17
 */
const string PRC_DISABLE_FEAT_COUNT                  = "PRC_DISABLE_FEAT_COUNT";
const string PRC_DISABLE_FEAT_                       = "PRC_DISABLE_FEAT_";
const string PRC_DISABLE_SKILL_COUNT                 = "PRC_DISABLE_SKILL_COUNT";
const string PRC_DISABLE_SKILL_                      = "PRC_DISABLE_SKILL_";
const string PRC_DISABLE_SPELL_COUNT                 = "PRC_DISABLE_SPELL_COUNT";
const string PRC_DISABLE_SPELL_                      = "PRC_DISABLE_SPELL_";

/*
 * Setting this will stop the GUI automatically appearing when a player is petrified on
 * hardcore
 * You can use a script named "prc_pw_petrific" which will always be run at petrification
 * (regardless of this switch) on hardcore to pop up the GUI as you want it, rather than
 * being forced to use biowares
*/
const string PRC_NO_PETRIFY_GUI                      = "PRC_NO_PETRIFY_GUI";


/*
 * Set this to remove the switch changing convo feat.
 * This must be set for PWs to avoid players screwing around with switches
 */

const string PRC_DISABLE_SWITCH_CHANGING_CONVO       = "PRC_DISABLE_SWITCH_CHANGING_CONVO";

/*
 * Set this to remove checks to enforce domains
 * e.g. Fire Gensai dont have to take the Fire domain, etc
 */

const string PRC_DISABLE_DOMAIN_ENFORCEMENT          = "PRC_DISABLE_DOMAIN_ENFORCEMENT";

/*
 * Set this to remove replace bioware HolyAvenger itemproperties
 * with PnP HolyAvenger itemprperties instead
 * (for paladins, +5 +2d6 divine vs evil, castspel:dispel magic @ casterlevel = paladinlevels)
 * (for non paladins, +2)
 */

const string PRC_PNP_HOLY_AVENGER_IPROP              = "PRC_PNP_HOLY_AVENGER_IPROP";

/* Set this to enable the permanent death and XP cost functionality
 * of Necrotic Termination spell.
 */

 const string PRC_NEC_TERM_PERMADEATH                = "PRC_NEC_TERM_PERMADEATH" ;

 /*
  * Set this to enable alignment changes for the casting of spells with the Evil descriptor
  */
 const string PRC_SPELL_ALIGNMENT_SHIFT              = "PRC_SPELL_ALIGNMENT_SHIFT";

 /*
  * Set this to give a number of Free cohorts as with leadership
  * This can be used to simulate a party of players
  */
 const string PRC_BONUS_COHORTS                      = "PRC_BONUS_COHORTS";

/******************************************************************************\
*                               ACP switches                              *
\******************************************************************************/
/*
 * This is a set of settings for Ragnaroks Alternate Combat animations Pack (ACP)
 * Main hak:
 * http://nwvault.ign.com/View.php?view=hakpaks.Detail&id=5895
 * CEP heads:
 * http://nwvault.ign.com/View.php?view=hakpaks.Detail&id=5934
 * CEP robes:
 * http://nwvault.ign.com/View.php?view=hakpaks.Detail&id=5950
 * (credit to USAgreco66kg for those CEP files)
 * Note on haks: You should NOT add the acp_2da hak if you have the PRC installed
 * already. Plus, once you press the OK button to add the ACP haks, make sure
 * you press cancel as soon as it appears. Otherwise, the toolset will crash
 * as it tries to compile the PRC scripts.
 */

/*
 * Set this to give players radial feats to change combat animations
 */
const string PRC_ACP_MANUAL                          = "PRC_ACP_MANUAL";

/*
 * Set this so that players will change combat animations automatically
 * based on weapons equiped and class
 */
const string PRC_ACP_AUTOMATIC                       = "PRC_ACP_AUTOMATIC";

/*
 * Set this so that NPCs will change combat animations automatically
 * based on weapons equiped and class
 * This can either be set on the module for a global setting
 * or set on individual NPCs for specific individuals
 */
const string PRC_ACP_NPC_AUTOMATIC                   = "PRC_ACP_NPC_AUTOMATIC";

/*
 * Set this for a number of minutes delay betwen changing animations
 * This is useful to stop people spamming the server with changes
 * If not set, it defaults to 90 seconds. To set to zero, set var to -1
 */
const string PRC_ACP_DELAY                           = "PRC_ACP_DELAY";


/******************************************************************************\
*                               File End switches                              *
\******************************************************************************/

/**
 * If this is set it will disable the defaults and the module builder must set
 * the values manually.
 * Otherwise it will set the automatically, and will take the PRC companion
 * into account, including CEP if its the CEP/PRC companion.
 */
const string FILE_END_MANUAL                         = "FILE_END_MANUAL";

/** Last line of classes.2da
 * This will be set automatically to a default unless FILE_END_MANUAL is turned on */
const string FILE_END_CLASSES                        = "FILE_END_CLASSES";

/** Last line of racialtypes.2da
 * This will be set automatically to a default unless FILE_END_MANUAL is turned on */
const string FILE_END_RACIALTYPES                    = "FILE_END_RACIALTYPES";

/** Last line of gender.2da
 * This will be set automatically to a default unless FILE_END_MANUAL is turned on */
const string FILE_END_GENDER                         = "FILE_END_GENDER";

/** Last line of portraits.2da
 * This will be set automatically to a default unless FILE_END_MANUAL is turned on */
const string FILE_END_PORTRAITS                      = "FILE_END_PORTRAITS";

/** Last line of skills.2da
 * This will be set automatically to a default unless FILE_END_MANUAL is turned on */
const string FILE_END_SKILLS                         = "FILE_END_SKILLS";

/** Defines the line after which none of the cls_feat_*.2da have entries.
 * This will be set automatically to a default unless FILE_END_MANUAL is turned on */
const string FILE_END_CLASS_FEAT                     = "FILE_END_CLASS_FEAT";

/** Defines the line after which none of the cls_skill_*.2da have entries.
 * This will be set automatically to a default unless FILE_END_MANUAL is turned on */
const string FILE_END_CLASS_SKILLS                   = "FILE_END_CLASS_SKILLS";

/** Defines the line after which none of the cls_psipw_*.2da have entries.
 * This will be set automatically to a default unless FILE_END_MANUAL is turned on */
const string FILE_END_CLASS_POWER                    = "FILE_END_CLASS_POWER";

/** Defines the line after which none of the cls_spbk_*.2da have entries.
 * This will be set automatically to a default unless FILE_END_MANUAL is turned on */
 const string FILE_END_CLASS_SPELLBOOK               = "FILE_END_CLASS_SPELLBOOK";

/** Last line of feat.2da
 * This will be set automatically to a default unless FILE_END_MANUAL is turned on */
const string FILE_END_FEAT                           = "FILE_END_FEAT";

/** Defines the line after which none of the cls_pres_*.2da have entries.
 * This will be set automatically to a default unless FILE_END_MANUAL is turned on */
const string FILE_END_CLASS_PREREQ                   = "FILE_END_CLASS_PREREQ";

/** Last line of hen_familiar.2da
 * This will be set automatically to a default unless FILE_END_MANUAL is turned on */
const string FILE_END_FAMILIAR                       = "FILE_END_FAMILIAR";

/** Last line of hen_companion.2da
 * This will be set automatically to a default unless FILE_END_MANUAL is turned on */
const string FILE_END_ANIMALCOMP                     = "FILE_END_ANIMALCOMP";

/** Last line of domains.2da
 * This will be set automatically to a default unless FILE_END_MANUAL is turned on */
const string FILE_END_DOMAINS                        = "FILE_END_DOMAINS";

/** Last line of soundset.2da
 * This will be set automatically to a default unless FILE_END_MANUAL is turned on */
const string FILE_END_SOUNDSET                       = "FILE_END_SOUNDSET";

/** Last line of spells.2da
 * This will be set automatically to a default unless FILE_END_MANUAL is turned on */
const string FILE_END_SPELLS                         = "FILE_END_SPELLS";

/** Last line of spellschools.2da
 * This will be set automatically to a default unless FILE_END_MANUAL is turned on */
const string FILE_END_SPELLSCHOOL                    = "FILE_END_SPELLSCHOOL";

/** Last line of appearance.2da
 * This will be set automatically to a default unless FILE_END_MANUAL is turned on */
const string FILE_END_APPEARANCE                     = "FILE_END_APPEARANCE";

/** Last line of wingmodel.2da
 * This will be set automatically to a default unless FILE_END_MANUAL is turned on */
const string FILE_END_WINGS                          = "FILE_END_WINGS";

/** Last line of tailmodel.2da
 * This will be set automatically to a default unless FILE_END_MANUAL is turned on */
const string FILE_END_TAILS                          = "FILE_END_TAILS";

/** Last line of packages.2da
 * This will be set automatically to a default unless FILE_END_MANUAL is turned on */
const string FILE_END_PACKAGE                        = "FILE_END_PACKAGE";

/** Defines the line after which none of the race_feat_*.2da have entries.
 * This will be set automatically to a default unless FILE_END_MANUAL is turned on */
const string FILE_END_RACE_FEAT                      = "FILE_END_RACE_FEAT";

/** Defines the line after which none of the race_feat_*.2da have entries.
 * This will be set automatically to a default unless FILE_END_MANUAL is turned on */
const string FILE_END_IREQ                           = "FILE_END_IREQ";

/** Defines the line after which none of the race_feat_*.2da have entries.
 * This will be set automatically to a default unless FILE_END_MANUAL is turned on */
const string FILE_END_ITEM_TO_IREQ                   = "FILE_END_ITEM_TO_IREQ";

/** Last line of baseitems.2da
 * This will be set automatically to a default unless FILE_END_MANUAL is turned on */
const string FILE_END_BASEITEMS                          = "FILE_END_BASEITEMS";



/******************************************************************************\
*                            Poison system switches                            *
\******************************************************************************/

/**
 * If this is set, uses the last three characters from the item's tag
 * instead of the local variable 'pois_idx' to define the poison the item
 * represents. The value is used as an index to poison.2da.
 */
const string PRC_USE_TAGBASED_INDEX_FOR_POISON       = "USE_TAGBASED_INDEX_FOR_POISON";

/**
 * Number of times the poisoned item works. Or if PRC_USES_PER_ITEM_POISON_DIE
 * is set, the number of dice rolled to determine it. Should be at least 1 if
 * set.
 * Default: 1
 */
const string PRC_USES_PER_ITEM_POISON_COUNT          = "PRC_USES_PER_ITEM_POISON_COUNT";

/**
 * Size of dice used to determine number of times the poisoned item works. Value
 * should be at least 2.
 * If value is less than 2, the die roll is skipped.
 * Default: No dice are rolled.
 */
const string PRC_USES_PER_ITEM_POISON_DIE            = "USES_PER_ITEM_POISON_DIE";

/**
 * If this is nonzero, only weapons that do slashing or piercing damage are allowed
 * to be poisoned.
 * Default: All weapons can be poisoned.
 */
const string PRC_ALLOW_ONLY_SHARP_WEAPONS            = "PRC_ALLOW_ONLY_SHARP_WEAPONS";

/**
 * If this is nonzero, inhaled and ingest poisons may be placed on weapons in
 * addition to contact and injury poisons.
 * Default: Only contact and injury poisons are allowed on weapons.
 */
const string PRC_ALLOW_ALL_POISONS_ON_WEAPONS        = "PRC_ALLOW_ALL_POISONS_ON_WEAPONS";

/**
 * If this is nonzero, a DEX check is rolled against Handle_DC in the poison's
 * column in poison.2da.
 * Possessing the Use Poison feat will always pass this check.
 * Default: A static 5% failure chance is used, as per the DMG.
 */
const string PRC_USE_DEXBASED_WEAPON_POISONING_FAILURE_CHANCE = "PRC_USE_DEXBASED_WEAPON_POISONING_FAILURE_CHANCE";

/**
 * Number of hits the poison will function on the weapon. Or if
 * PRC_USES_PER_WEAPON_POISON_DIE is set, the number of dice rolled.
 * If this is set, the value should be >= 1.
 * Default: 1
 */
const string PRC_USES_PER_WEAPON_POISON_COUNT        = "PRC_USES_PER_WEAPON_POISON_COUNT";

/**
 * Size of the die rolled when determining the amount of hits the poison will
 * work on. If this is set, the value should be at least 2.
 * Default: Dice aren't rolled.
 */
const string PRC_USES_PER_WEAPON_POISON_DIE          = "PRC_USES_PER_WEAPON_POISON_DIE";

/**
 * This is the name of the script to be run when someone attempts to poison food to
 * check if the targeted item is food. The default script returns FALSE for everything,
 * so you must define your own to have this functionality.
 *
 * This switch has string values instead of integers.
 *
 * Default: poison_is_food <- an example script, just returns false
 *
 * @see poison_is_food
 */
const string PRC_POISON_IS_FOOD_SCRIPT_NAME          = "PRC_POISON_IS_FOOD_SCRIPT_NAME";

/**
 * This switch determines whether a creature equipping a poisoned item is assumed to be
 * acting smartly in that it attempts to clean the item first. If it's not set, the
 * creature just directly equips the item and gets poisoned.
 *
 * Default: Off, the creature gets poisoned without any checks
 *
 * @see poison_onequip
 */
const string PRC_POISON_ALLOW_CLEAN_IN_EQUIP         = "PRC_POISON_ALLOW_CLEAN_IN_EQUIP";


/******************************************************************************\
*                             PRGT system switches                             *
\******************************************************************************/

//these three are strings not switches
const string PRC_PRGT_XP_SCRIPT_TRIGGERED            = "PRC_PRGT_XP_SCRIPT_TRIGGERED";
const string PRC_PRGT_XP_SCRIPT_DISARMED             = "PRC_PRGT_XP_SCRIPT_DISARMED";
const string PRC_PRGT_XP_SCRIPT_RECOVERED            = "PRC_PRGT_XP_SCRIPT_RECOVERED";

/**
 * @TODO: Write description.
 */
const string PRC_PRGT_XP_AWARD_FOR_TRIGGERED         = "PRC_PRGT_XP_AWARD_FOR_TRIGGERED";

/**
 * @TODO: Write description.
 */
const string PRC_PRGT_XP_AWARD_FOR_RECOVERED         = "PRC_PRGT_XP_AWARD_FOR_RECOVERED";

/**
 * @TODO: Write description.
 */
const string PRC_PRGT_XP_AWARD_FOR_DISARMED          = "PRC_PRGT_XP_AWARD_FOR_DISARMED";



/******************************************************************************\
*                               Psionics switches                              *
\******************************************************************************/

/**
 * If this is set, use ac_appearances.2da to determine an Astral Construct's
 * appearance instead of the values hardcoded into the script.
 */
const string PRC_PSI_ASTRAL_CONSTRUCT_USE_2DA        = "ASTRAL_CONSTRUCT_USE_2DA";

/**
 * Setting this switch active makes Psychic Reformation only allow one to
 * reselect psionic powers instead of fully rebuilding their character.
 *
 * Possible values:
 * 0              = Off, Psychic Reformation behaves as specified in the power
 *                  description. That is, the target is deleveled by a certain
 *                  amount and then releveled back to where they were.
 * Nonzero, not 2 = On, Psychic Reformation only nulls a selected number of
 *                  the target's selected powers and allows reselection.
 * 2              = On, and the XP cost is reduced to 25 per level reformed.
 */
const string PRC_PSI_PSYCHIC_REFORMATION_NERF        = "PRC_PSI_PSYCHIC_REFORMATION_NERF";

/**
 * Determines how Rapid Metabolism works.
 * When set, heals the feat possessor by their Hit Dice + Constitution modifier
 * every 24h.
 * Default: Heals the feat possessor by 1 + their Constitution modifier every
 *          turn (60s).
 */
const string PRC_PNP_RAPID_METABOLISM                = "PRC_PNP_RAPID_METABOLISM";

/**
 * Determines how the epic feat Improved Metapsionics works.
 * When set, the total cost of metapsionics applied to power being manifested is
 * summed and Improved Metapsionics cost reduction is applied to the sum.
 * Default: Improved Metapsionics cost reduction is applied separately to each
 *          metapsionic used with power being manifested.
 */
const string PRC_PSI_IMP_METAPSIONICS_USE_SUM        = "PRC_PSI_IMP_METAPSIONICS_USE_SUM";


/**
 * A switch a player can personally toggle. If this is set, their augmentation level
 * is considered to be the amount of PP they are willing to pay for augmentation.
 * Default: A player's augmentation level is the number of times to augment the power.
 */
const string PRC_PLAYER_SWITCH_AUGMENT_IS_PP         = "PRC_PLAYER_SWITCH_AUGMENT_IS_PP";

/******************************************************************************\
*                               PnP shifter switches                              *
\******************************************************************************/

/*
 * These are used to restrict what forms the PnP shifter can use
 * Remember, mimicing uses the targetting instance, whereas
 * shifting into that form again later creats a new instance from
 * the resref. Thus if you modify creatures after they have been
 * placed from the palette, odd things may happen.
 *
 * Also if you give any monster the "Anomalous Form" feat, the players
 * will not be able to take that monsters shape.
 */

/*
 * if set to 1 uses CR for target level checks instead of HD
 */
const string PNP_SHFT_USECR                     = "PNP_SHFT_USECR";
/*
 * if set to 1 cannot take huge shapes
 */
const string PNP_SHFT_S_HUGE                    = "PNP_SHFT_S_HUGE";
/*
 * if set to 1 cannot take large shapes
 */
const string PNP_SHFT_S_LARGE                   = "PNP_SHFT_S_LARGE";
/*
 * if set to 1 cannot take medium shapes
 */
const string PNP_SHFT_S_MEDIUM                  = "PNP_SHFT_S_MEDIUM";
/*
 * if set to 1 cannot take small shapes
 */
const string PNP_SHFT_S_SMALL                   = "PNP_SHFT_S_SMALL";
/*
 * if set to 1 cannot take tiny shapes
 */
const string PNP_SHFT_S_TINY                    = "PNP_SHFT_S_TINY";
/*
 * if set to 1 cannot take outsider shapes
 */
const string PNP_SHFT_F_OUTSIDER                = "PNP_SHFT_F_OUTSIDER";
/*
 * if set to 1 cannot take elemental shapes
 */
const string PNP_SHFT_F_ELEMENTAL               = "PNP_SHFT_F_ELEMENTAL";
/*
 * if set to 1 cannot take construct shapes
 */
const string PNP_SHFT_F_CONSTRUCT               = "PNP_SHFT_F_CONSTRUCT";
/*
 * if set to 1 cannot take undead shapes
 */
const string PNP_SHFT_F_UNDEAD                  = "PNP_SHFT_F_UNDEAD";
/*
 * if set to 1 cannot take dragon shapes
 */
const string PNP_SHFT_F_DRAGON                  = "PNP_SHFT_F_DRAGON";
/*
 * if set to 1 cannot take aberration shapes
 */
const string PNP_SHFT_F_ABERRATION              = "PNP_SHFT_F_ABERRATION";
/*
 * if set to 1 cannot take ooze shapes
 */
const string PNP_SHFT_F_OOZE                    = "PNP_SHFT_F_OOZE";
/*
 * if set to 1 cannot take magical beast shapes
 */
const string PNP_SHFT_F_MAGICALBEAST            = "PNP_SHFT_F_MAGICALBEAST";
/*
 * if set to 1 cannot take giant shapes
 */
const string PNP_SHFT_F_GIANT                   = "PNP_SHFT_F_GIANT";
/*
 * if set to 1 cannot take vermin shapes
 */
const string PNP_SHFT_F_VERMIN                  = "PNP_SHFT_F_VERMIN";
/*
 * if set to 1 cannot take beast shapes
 */
const string PNP_SHFT_F_BEAST                   = "PNP_SHFT_F_BEAST";
/*
 * if set to 1 cannot take animal shapes
 */
const string PNP_SHFT_F_ANIMAL                  = "PNP_SHFT_F_ANIMAL";
/*
 * if set to 1 cannot take monstrous humanoid shapes
 */
const string PNP_SHFT_F_MONSTROUSHUMANOID       = "PNP_SHFT_F_MONSTROUSHUMANOID";
/*
 * if set to 1 cannot take humanoid shapes
 */
const string PNP_SHFT_F_HUMANOID                = "PNP_SHFT_F_HUMANOID";

/******************************************************************************\
*                            Combat System Switches                            *
\******************************************************************************/

/**
 * TODO: Write description.
 */
const string PRC_PNP_ELEMENTAL_DAMAGE                = "PRC_PNP_ELEMENTAL_DAMAGE";

/**
 * TODO: Write description.
 */
const string PRC_SPELL_SNEAK_DISABLE                 = "PRC_SPELL_SNEAK_DISABLE";

/**
 * Use 3.5 edition unarmed damage progression instead of 3.0 edition.
 * Default: Use 3.0 unarmed damage progression.
 */
const string PRC_3_5e_FIST_DAMAGE                    = "PRC_3_5e_FIST_DAMAGE";

/**
 * Use a Brawler character's size as a part of determining their unarmed
 * damage.
 * Default: A Brawler's size is ignored.
 */
const string PRC_BRAWLER_SIZE                        = "PRC_BRAWLER_SIZE";




/******************************************************************************\
*                           Craft System Switches                           *
\******************************************************************************/

/*
 * Completely disable the PRC Crafting System
 */
const string PRC_DISABLE_CRAFT                       = "PRC_DISABLE_CRAFT";


/*
 * Multiply the delay (in seconds) after the creation of an item in which a PC
 * can't craft anything. This is divided by 100 to get a float.
 * Normally, it's set to the market price of the item. Set
 * it to less than 100 to reduce it instead. (default: 0).
 */
const string PRC_CRAFT_TIMER_MULTIPLIER              = "PRC_CRAFT_TIMER_MULTIPLIER";

/*
 * Absolute maximum delay (in seconds) where crafting is disabled for a PC,
 * regardless of the item's market price. By default it's 0 (meaning that there's
 * no delay at all).
 */
const string PRC_CRAFT_TIMER_MAX                     = "PRC_CRAFT_TIMER_MAX";

/*
 * Absolute minimum delay (in seconds) where crafting is disabled for a PC,
 * regardless of the item's market price. By default it's 0 (meaning that there's
 * no delay at all).
 */
const string PRC_CRAFT_TIMER_MIN                     = "PRC_CRAFT_TIMER_MIN";

/**
 * These three switches modify Bioware crafting so that the items produced have the
 * casterlevel of the spellcaster who created them. Normally under Bioware, it is possible
 * for a level 3 caster to produce level 9 items and for a level 40 caster to only produce
 * level 5 items.
 * This also allows metamagic to apply to crafting. i.e you produce a wand of maximized fireball
 *
 * @see PRC_SCRIBE_SCROLL_CASTER_LEVEL
 * @see PRC_CRAFT_WAND_CASTER_LEVEL
 */
const string PRC_BREW_POTION_CASTER_LEVEL            = "PRC_BREW_POTION_CASTER_LEVEL";

/**
 * These three switches modify Bioware crafting so that the items produced have the
 * casterlevel of the spellcaster who created them. Normally under Bioware, it is possible
 * for a level 3 caster to produce level 9 items and for a level 40 caster to only produce
 * level 5 items.
 * This also allows metamagic to apply to crafting. i.e you produce a wand of maximized fireball
 *
 * @see PRC_BREW_POTION_CASTER_LEVEL
 * @see PRC_CRAFT_WAND_CASTER_LEVEL
 */
const string PRC_SCRIBE_SCROLL_CASTER_LEVEL          = "PRC_SCRIBE_SCROLL_CASTER_LEVEL";

/**
 * These three switches modify Bioware crafting so that the items produced have the
 * casterlevel of the spellcaster who created them. Normally under Bioware, it is possible
 * for a level 3 caster to produce level 9 items and for a level 40 caster to only produce
 * level 5 items.
 * This also allows metamagic to apply to crafting. i.e you produce a wand of maximized fireball
 *
 * @see PRC_BREW_POTION_CASTER_LEVEL
 * @see PRC_SCRIBE_SCROLL_CASTER_LEVEL
 */
const string PRC_CRAFT_WAND_CASTER_LEVEL             = "PRC_CRAFT_WAND_CASTER_LEVEL";

/*
 * Characters with a crafting feat always have the appropriate base item in their inventory
 */
const string PRC_CRAFTING_BASE_ITEMS               = "PRC_CRAFTING_BASE_ITEMS";

/*
 * Max level of spells brewed into potions
 * defaults to 3
 */
const string X2_CI_BREWPOTION_MAXLEVEL               = "X2_CI_BREWPOTION_MAXLEVEL";

/*
 * cost modifier of spells brewed into poitions
 * defaults to 50
 */
const string X2_CI_BREWPOTION_COSTMODIFIER           = "X2_CI_BREWPOTION_COSTMODIFIER";

/*
 * cost modifier of spells scribed into scrolls
 * defaults to 25
 */
const string X2_CI_SCRIBESCROLL_COSTMODIFIER         = "X2_CI_SCRIBESCROLL_COSTMODIFIER";

/*
 * Max level of spells crafted into wands
 * defaults to 4
 */
const string X2_CI_CRAFTWAND_MAXLEVEL                = "X2_CI_CRAFTWAND_MAXLEVEL";

/*
 * cost modifier of spells crafted into wands
 * defaults to 750
 */
const string X2_CI_CRAFTWAND_COSTMODIFIER            = "X2_CI_CRAFTWAND_COSTMODIFIER";


/******************************************************************************\
*                           Teleport System Switches                           *
\******************************************************************************/

/**
 * Defines the maximum number of teleport target locations a PC may store.
 * Default: 50
 */
const string PRC_TELEPORT_MAX_TARGET_LOCATIONS       = "PRC_TELEPORT_MAX_TARGET_LOCATIONS";

/**
 * If this is set, all teleportation spells fail.
 * Default: Off
 */
const string PRC_DISABLE_TELEPORTATION              = "PRC_DISABLE_TELEPORTATION";

/**
 * If a local integer variable by this name is set on an area, that area
 * cannot be either teleported to or teleported from or both, depending on
 * the value of the variable.
 *
 * Possible values:
 * PRC_DISABLE_TELEPORTATION_FROM_AREA,
 * PRC_DISABLE_TELEPORTATION_TO_AREA,
 * PRC_DISABLE_TELEPORTATION_TO_AND_FROM_AREA
 */
const string PRC_DISABLE_TELEPORTATION_IN_AREA      = "PRC_DISABLE_TELEPORTATION_IN_AREA";

/**
 * A value of PRC_DISABLE_TELEPORTATION_IN_AREA. This disables teleporting
 * away from the area in question.
 */
const int PRC_DISABLE_TELEPORTATION_FROM_AREA        = 0x1;

/**
 * A value of PRC_DISABLE_TELEPORTATION_IN_AREA. This disables teleporting
 * into the area in question.
 */
const int PRC_DISABLE_TELEPORTATION_TO_AREA          = 0x2;

/**
 * A value of PRC_DISABLE_TELEPORTATION_IN_AREA. This disables both teleporting
 * into and out of the area in question.
 */
const int PRC_DISABLE_TELEPORTATION_TO_AND_FROM_AREA = 3;
//this wont compile from inside a module
//using the prc compile
//PRC_DISABLE_TELEPORTATION_FROM_AREA |
//PRC_DISABLE_TELEPORTATION_TO_AREA;

/**
 * If a variable by this name is non-zero on a creature, that creature cannot
 * teleport. If you use this in your own scripts, please do not set it to
 * a static value or directly remove it.
 * Instead, increase it's value by one when the disabling occurs and decrease
 * by one when the disabling turns off. This is required in order to be able to
 * handle overlapping sources of forbiddance.
 */
const string PRC_DISABLE_CREATURE_TELEPORT           = "PRC_DISABLE_CREATURE_TELEPORT";


/******************************************************************************\
*                          Persistent World switches                           *
\******************************************************************************/

/**
 * Persistant time tracking.
 * This is done on a player-by-player basis if PRC_PLAYER_TIME is on.
 *
 * TODO: Elaborate
 */
const string PRC_PW_TIME                             = "PRC_PW_TIME";

/**
 * Number of rounds between exporting all characters.
 */
const string PRC_PW_PC_AUTOEXPORT                    = "PRC_PW_PC_AUTOEXPORT";

/**
 * A player's HP is stored via persistant locals every HB and restored on logon.
 */
const string PRC_PW_HP_TRACKING                      = "PRC_PW_HP_TRACKING";

/**
 * A player's location is stored via persistant locals every HB and restored
 * on logon.
 */
const string PRC_PW_LOCATION_TRACKING                = "PRC_PW_LOCATION_TRACKING";

/**
 * Player places map pins are tracked via persistant locals and restored on logon
 */
const string PRC_PW_MAPPIN_TRACKING                   = "PRC_PW_MAPPIN_TRACKING";

/**
 * Being dead is stored via persistant locals and restored on logon.
 */
const string PRC_PW_DEATH_TRACKING                   = "PRC_PW_DEATH_TRACKING";

/**
 * Spells cast are tracked via persistant locals and restored on logon
 */
const string PRC_PW_SPELL_TRACKING                   = "PRC_PW_SPELL_TRACKING";



/******************************************************************************\
*                             XP system switches                               *
\******************************************************************************/

/**
 * This modifies the amount of XP a character recieves based on Level Adjustment
 * - Doesn't take racial hit dice into account.
 * - Should work with any prior XP system.
 * - Use this on pre-exisitng modules.
 */
const string PRC_XP_USE_SIMPLE_LA                    = "PRC_XP_USE_SIMPLE_LA";

/**
 * Any new characters entering the module are automatically given racial hit dice
 * Unlike PnP, they do not get to select what feats/skills the racial HD grant
 * Instead the default bioware package will be used.
 * Do not use if the ConvoCCs racial hit dice option is in use.
 */
const string PRC_XP_USE_SIMPLE_RACIAL_HD             = "PRC_XP_USE_SIMPLE_RACIAL_HD";

/**
 * Characters must earn their racial HD through the normal levelup process
 * Player must still take all their racial HD before they can take more
 * than one level in a non-racial class.
 * PRC_XP_USE_SIMPLE_RACIAL_HD must be on, and the convoCC racial hit dice option
 * must be off
 */
const string PRC_XP_USE_SIMPLE_RACIAL_HD_NO_FREE_XP  = "PRC_XP_USE_SIMPLE_RACIAL_HD_NO_FREE_XP";

/**
 * Characters are given racial HD via LevelupHenchman so can't select feats etc
 * Uses the default packages for each class, which are poor to say the least
 * PRC_XP_USE_SIMPLE_RACIAL_HD must be on, and the convoCC racial hit dice option
 * must be off
 */
const string PRC_XP_USE_SIMPLE_RACIAL_HD_NO_SELECTION  = "PRC_XP_USE_SIMPLE_RACIAL_HD_NO_SELECTION";

/**
 * Enables PRC XP system.
 * This may cause balance issues with pre-exisiting modules, so it is recomended
 * that only builders use this and do extensive playtesting and tweaking for
 * balance.
 *
 * Uses the dmgxp.2da file which is a copy of the XP tables in the DMG and ELH
 * these are based on the formula of 13.3333 encounters of CR = ECL to advance
 * a level.
 * Enconters of CR > ECL+8 or CR < ECL-8 dont give XP.
 * Tables are setup so that parties' levels will converge over time.
 */
const string PRC_XP_USE_PNP_XP                       = "PRC_XP_USE_PNP_XP";

/**
 * This value is divided by 100 when applied so a value of 100 is equivalent to 1.0
 * slider for PnP XP system, multiplier for final XP amount
 * This can also be set on individual PCs for the same result. If it is not set, then
 * it defaults to 1.0. If you want 0.0 then set it to -1
 */
const string PRC_XP_SLIDER_x100                      = "PRC_XP_SLIDER_x100";

/**
 * Use ECL for NPCs instead of CR.
 * Should be close, but I dont know how Bioware CR calculations work with the
 * PRC races.
 * Also note ECL is a measure of power in a campaign, wheras CR is measure of
 * power in a single encounter. Thus ECL weights use/day abilitieis more than
 * CR does.
 */
const string PRC_XP_USE_ECL_NOT_CR                   = "PRC_XP_USE_ECL_NOT_CR";

/**
 * If this is set, ECL = LA + racial hit dice
 * EVEN IF THE CHARACTER DOESNT HAVE ANY RACIAL HIT DICE!
 * So it penalizes the power races far more than PnP because they don't get any
 * of the other benefits of racial hit dice (BAB, HP, saves, skills, feats, etc)
 */
const string PRC_XP_INCLUDE_RACIAL_HIT_DIE_IN_LA     = "PRC_XP_INCLUDE_RACIAL_HIT_DIE_IN_LA";

/**
 * These values are divided by 100 when applied so a value of 100 is equivalent
 * to 1.0.
 * This is for purposes of party size for dividing XP awards by.
 * By PnP only PCs would count, and possibly henchmen too, but you might want to
 * tweak others for balance purposes, for example to hinder a solo wizard with
 * dozens of summons.
 */
const string PRC_XP_PC_PARTY_COUNT_x100              = "PRC_XP_PC_PARTY_COUNT_x100";

/**
 * These values are divided by 100 when applied so a value of 100 is equivalent
 * to 1.0.
 * This is for purposes of party size for dividing XP awards by.
 * By PnP only PCs would count, and possibly henchmen too, but you might want to
 * tweak others for balance purposes, for example to hinder a solo wizard with
 * dozens of summons.
 */
const string PRC_XP_HENCHMAN_PARTY_COUNT_x100        = "PRC_XP_HENCHMAN_PARTY_COUNT_x100";

/**
 * These values are divided by 100 when applied so a value of 100 is equivalent
 * to 1.0.
 * This is for purposes of party size for dividing XP awards by.
 * By PnP only PCs would count, and possibly henchmen too, but you might want to
 * tweak others for balance purposes, for example to hinder a solo wizard with
 * dozens of summons.
 */
const string PRC_XP_DOMINATED_PARTY_COUNT_x100       = "PRC_XP_DOMINATED_PARTY_COUNT_x100";

/**
 * These values are divided by 100 when applied so a value of 100 is equivalent
 * to 1.0.
 * This is for purposes of party size for dividing XP awards by.
 * By PnP only PCs would count, and possibly henchmen too, but you might want to
 * tweak others for balance purposes, for example to hinder a solo wizard with
 * dozens of summons.
 */
const string PRC_XP_ANIMALCOMPANION_PARTY_COUNT_x100 = "PRC_XP_ANIMALCOMPANION_PARTY_COUNT_x100";

/**
 * These values are divided by 100 when applied so a value of 100 is equivalent
 * to 1.0.
 * This is for purposes of party size for dividing XP awards by.
 * By PnP only PCs would count, and possibly henchmen too, but you might want to
 * tweak others for balance purposes, for example to hinder a solo wizard with
 * dozens of summons.
 */
const string PRC_XP_FAMILIAR_PARTY_COUNT_x100        = "PRC_XP_FAMILIAR_PARTY_COUNT_x100";

/**
 * These values are divided by 100 when applied so a value of 100 is equivalent
 * to 1.0.
 * This is for purposes of party size for dividing XP awards by.
 * By PnP only PCs would count, and possibly henchmen too, but you might want to
 * tweak others for balance purposes, for example to hinder a solo wizard with
 * dozens of summons.
 */
const string PRC_XP_SUMMONED_PARTY_COUNT_x100        = "PRC_XP_SUMMONED_PARTY_COUNT_x100";

/**
 * Use SetXP rather than GiveXP. Will bypass any possible Bioware interference.
 */
const string PRC_XP_USE_SETXP                        = "PRC_XP_USE_SETXP";

/**
 * Give XP to NPCs via a local int variable on the NPC named "NPC_XP".
 * This is used for epic spells that require XP and could also be hooked into
 * henchmen levelling systems.
 */
const string PRC_XP_GIVE_XP_TO_NPCS                  = "PRC_XP_GIVE_XP_TO_NPCS";

/**
 * PCs must be in the same area as the CR to gain XP.
 * Helps stop powerlevelling by detering low level characters hanging around
 * with 1 very strong char.
 */
const string PRC_XP_MUST_BE_IN_AREA                  = "PRC_XP_MUST_BE_IN_AREA";

/**
 * Maximum distance that a PC must be to gain XP.
 * Helps stop powerlevelling by detering low level characters hanging around
 * with 1 very strong char.
 */
const string PRC_XP_MAX_PHYSICAL_DISTANCE            = "PRC_XP_MAX_PHYSICAL_DISTANCE";

/**
 * Maximum level difference in levels between killer and PC being awarded XP.
 * Helps stop powerlevelling by detering low level characters hanging around
 * with 1 very strong char.
 */
const string PRC_XP_MAX_LEVEL_DIFF                   = "PRC_XP_MAX_LEVEL_DIFF";

/**
 * Gives XP to NPCs when no PCs are in their faction
 * This might cause lag if large numebrs of NPCs in the same faction.
 */
const string PRC_XP_GIVE_XP_TO_NON_PC_FACTIONS       = "PRC_XP_GIVE_XP_TO_NON_PC_FACTIONS";




/******************************************************************************\
*                      Database and Letoscript switches                        *
\******************************************************************************/

/**
 * Set this if you are using NWNX and any sort of database.
 */
const string PRC_USE_DATABASE                        = "PRC_USE_DATABASE";

/**
 * Set this if you want to use the bioware db for 2da caching
 * the value is the number of Hbs between caching runs
 * Defaults to 600 (10 mins) if not set
 * cache will be flushed automatically when the PRC version changes
 */
const string PRC_USE_BIOWARE_DATABASE                = "PRC_USE_BIOWARE_DATABASE";

/**
 * This will precache 2da files into the database.
 * The first time a module runs with this set it will lag a lot for a long time
 * as the game does 2da reads.
 * Afterwards it will be much faster.
 */
const string PRC_DB_PRECACHE                         = "PRC_DB_PRECACHE";

/**
 * Set this if you are using SQLite (the built-in database in NWNX-ODBC2).
 * This will use transactions and SQLite specific syntax.
 */
const string PRC_DB_SQLLITE                          = "PRC_DB_SQLLITE";

/**
 * This is the interval of each transaction. By default it is 600 seconds.
 * Shorter will mean slower, but less data lost in the event of a server crash.
 * Longer is visa versa.
 */
const string PRC_DB_SQLLITE_INTERVAL                 = "PRC_DB_SQLLITE_INTERVAL";

/**
 * Set this if you are using MySQL.
 * This will not use transactions and will use MySQL specific syntax
 */
const string PRC_DB_MYSQL                            = "PRC_DB_MYSQL";


/**
 * TODO: Write description.
 */
const string PRC_USE_LETOSCRIPT                      = "PRC_USE_LETOSCRIPT";

/**
 * Set this to 1 if using build 18
 */
const string PRC_LETOSCRIPT_PHEONIX_SYNTAX           = "PRC_LETOSCRIPT_PHEONIX_SYNTAX";

/**
 * Set this to 1 to have Letoscript convert stat boosts on the hide to
 * permanent ones.
 */
const string PRC_LETOSCRIPT_FIX_ABILITIES            = "PRC_LETOSCRIPT_FIX_ABILITIES";

/**
 * Letoscript needs a string named PRC_LETOSCRIPT_NWN_DIR set to the
 * directory of NWN. If it doesnt work, try different slash options: // \\ / \
 */
const string PRC_LETOSCRIPT_NWN_DIR                  = "PRC_LETOSCRIPT_NWN_DIR";

/**
 * Switch so that Unicorn will use the SQL database for SCO/RCO
 * Must have the zeoslib.dlls installed for this
 *
 * UNTESTED!!!
 */
const string PRC_LETOSCRIPT_UNICORN_SQL              = "PRC_LETOSCRIPT_UNICORN_SQL";

/**
 * This is a string, not integer.
 * If the IP is set, Letoscript will use ActivatePortal instead of booting.
 * The IP and Password must be correct for your server or bad things will happen.
 * - If your IP is non-static make sure this is kept up to date.
 *
 * See the Lexicon entry on ActivatePortal for more information.
 *
 * @see PRC_LETOSCRIPT_PORTAL_PASSWORD
 */
const string PRC_LETOSCRIPT_PORTAL_IP                = "PRC_LETOSCRIPT_PORTAL_IP";

/**
 * This is a string, not integer.
 * If the IP is set, Letoscript will use ActivatePortal instead of booting.
 * The IP and Password must be correct for your server or bad things will happen.
 * - If your IP is non-static make sure this is kept up to date.
 *
 * See the Lexicon entry on ActivatePortal for more information.
 *
 * @see PRC_LETOSCRIPT_PORTAL_IP
 */
const string PRC_LETOSCRIPT_PORTAL_PASSWORD          = "PRC_LETOSCRIPT_PORTAL_PASSWORD";

/**
 * If set you must be using Unicorn.
 * Will use getnewest bic instead of filename reconstruction (which fails if
 * multiple characters have the same name)
 */
const string PRC_LETOSCRIPT_GETNEWESTBIC             = "PRC_LETOSCRIPT_GETNEWESTBIC";




/******************************************************************************\
*                              ConvoCC switches                                *
\******************************************************************************/

/**
 * Activates the ConvoCC.
 * This doesn't turn on the database and letoscript as well, which you must
 * do yourself.
 *
 * @see PRC_USE_DATABASE
 * @see PRC_USE_LETOSCRIPT
 */
const string PRC_CONVOCC_ENABLE                      = "PRC_CONVOCC_ENABLE";

/**
 * Avariel characters have bird wings.
 */
const string PRC_CONVOCC_AVARIEL_WINGS               = "PRC_CONVOCC_AVARIEL_WINGS";

/**
 * Fey'ri characters have bat wings.
 */
const string PRC_CONVOCC_FEYRI_WINGS                 = "PRC_CONVOCC_FEYRI_WINGS";

/**
 * Fey'ri characters have a demonic tail.
 */
const string PRC_CONVOCC_FEYRI_TAIL                  = "PRC_CONVOCC_FEYRI_TAIL";

/**
 * Force Drow characters to be of the correct gender for their race.
 */
const string PRC_CONVOCC_DROW_ENFORCE_GENDER         = "PRC_CONVOCC_DROW_ENFORCE_GENDER";

/**
 * Force Genasi clerics to select the relevant elemental domain as one of
 * their feats.
 */
const string PRC_CONVOCC_GENASI_ENFORCE_DOMAINS      = "PRC_CONVOCC_GENASI_ENFORCE_DOMAINS";

/**
 * Female Rakshasha use the female rakshasha model.
 */
const string PRC_CONVOCC_RAKSHASHA_FEMALE_APPEARANCE = "PRC_CONVOCC_RAKSHASHA_FEMALE_APPEARANCE";

/**
 * Female Driders use the female drider model.
 */
const string PRC_CONVOCC_DRIDER_FEMALE_APPEARANCE    = "PRC_CONVOCC_DRIDER_FEMALE_APPEARANCE";

/**
 * A combination switch to turn on all the racial enforcement settings.
 */
const string PRC_CONVOCC_ENFORCE_PNP_RACIAL          = "PRC_CONVOCC_ENFORCE_PNP_RACIAL";

/** Separate enforcement of feats with special restrictions. */
const string PRC_CONVOCC_ENFORCE_BLOOD_OF_THE_WARLORD= "PRC_CONVOCC_ENFORCE_BLOOD_OF_THE_WARLORD";
/** Separate enforcement of feats with special restrictions. */
const string PRC_CONVOCC_ENFORCE_FEAT_NIMBUSLIGHT    = "PRC_CONVOCC_ENFORCE_FEAT_NIMBUSLIGHT";
/** Separate enforcement of feats with special restrictions. */
const string PRC_CONVOCC_ENFORCE_FEAT_HOLYRADIANCE   = "PRC_CONVOCC_ENFORCE_FEAT_HOLYRADIANCE";
/** Separate enforcement of feats with special restrictions. */
const string PRC_CONVOCC_ENFORCE_FEAT_SERVHEAVEN     = "PRC_CONVOCC_ENFORCE_FEAT_SERVHEAVEN";
/** Separate enforcement of feats with special restrictions. */
const string PRC_CONVOCC_ENFORCE_FEAT_SAC_VOW        = "PRC_CONVOCC_ENFORCE_FEAT_SAC_VOW";
/** Separate enforcement of feats with special restrictions. */
const string PRC_CONVOCC_ENFORCE_FEAT_VOW_OBED       = "PRC_CONVOCC_ENFORCE_FEAT_VOW_OBED";
/** Separate enforcement of feats with special restrictions. */
const string PRC_CONVOCC_ENFORCE_FEAT_THRALL_TO_DEMON= "PRC_CONVOCC_ENFORCE_FEAT_THRALL_TO_DEMON";
/** Separate enforcement of feats with special restrictions. */
const string PRC_CONVOCC_ENFORCE_FEAT_DISCIPLE_OF_DARKNESS="PRC_CONVOCC_ENFORCE_FEAT_DISCIPLE_OF_DARKNESS";
/** Separate enforcement of feats with special restrictions. */
const string PRC_CONVOCC_ENFORCE_FEAT_LICHLOVED      = "PRC_CONVOCC_ENFORCE_FEAT_LICHLOVED";
/** Separate enforcement of feats with special restrictions. */
const string PRC_CONVOCC_ENFORCE_FEAT_EVIL_BRANDS    = "PRC_CONVOCC_ENFORCE_FEAT_EVIL_BRANDS";
/** Separate enforcement of feats with special restrictions. */
const string PRC_CONVOCC_ENFORCE_FEAT_VILE_WILL_DEFORM="PRC_CONVOCC_ENFORCE_FEAT_VILE_WILL_DEFORM";
/** Separate enforcement of feats with special restrictions. */
const string PRC_CONVOCC_ENFORCE_FEAT_VILE_DEFORM_OBESE="PRC_CONVOCC_ENFORCE_FEAT_VILE_DEFORM_OBESE";
/** Separate enforcement of feats with special restrictions. */
const string PRC_CONVOCC_ENFORCE_FEAT_VILE_DEFORM_GAUNT="PRC_CONVOCC_ENFORCE_FEAT_VILE_DEFORM_GAUNT";
/** Separate enforcement of feats with special restrictions. */
const string PRC_CONVOCC_ENFORCE_FEAT_LOLTHS_MEAT   = "PRC_CONVOCC_ENFORCE_FEAT_LOLTHS_MEAT";


/**
 * A combination switch to turn on all the feat enforcement settings.
 */
const string PRC_CONVOCC_ENFORCE_FEATS               = "PRC_CONVOCC_ENFORCE_FEATS";

/**
 * Stops players from changing their wings.
 */
const string PRC_CONVOCC_DISALLOW_CUSTOMISE_WINGS    = "PRC_CONVOCC_DISALLOW_CUSTOMISE_WINGS";

/**
 * Stops players from changing their tail.
 */
const string PRC_CONVOCC_DISALLOW_CUSTOMISE_TAIL     = "PRC_CONVOCC_DISALLOW_CUSTOMISE_TAIL";

/**
 * Stops players from changing their model at all.
 */
const string PRC_CONVOCC_DISALLOW_CUSTOMISE_MODEL    = "PRC_CONVOCC_DISALLOW_CUSTOMISE_MODEL";

/**
 * TODO: Write description.
 */
const string PRC_CONVOCC_USE_RACIAL_APPEARANCES      = "PRC_CONVOCC_USE_RACIAL_APPEARANCES";
/**
 * TODO: Write description.
 */
const string PRC_CONVOCC_USE_RACIAL_PORTRAIT         = "PRC_CONVOCC_USE_RACIAL_PORTRAIT";

//this isnt actually used, removed to avoid confusion
//const string PRC_CONVOCC_USE_RACIAL_SOUNDSET         = "PRC_CONVOCC_USE_RACIAL_SOUNDSET";

/**
 * Players can only change their model / portrait / soundset to alternatives of
 * the same race. If you have extra content (e.g. from CEP) you must add them to
 * SetupRacialAppearances or SetupRacialPortraits or SetupRacialSoundsets in
 * prc_ccc_inc_e in order for them to be shown on the list.
 */
const string PRC_CONVOCC_USE_RACIAL_VOICESET         = "PRC_CONVOCC_USE_RACIAL_VOICESET";

/**
 * Players can only select from the player voicesets. NPC voicesets are not
 * complete, so wont play sounds for many things such as emotes.
 */
const string PRC_CONVOCC_ONLY_PLAYER_VOICESETS       = "PRC_CONVOCC_ONLY_PLAYER_VOICESETS";

/**
 * Only allows players to select voiceset of the same gender as their character.
 */
const string PRC_CONVOCC_RESTRICT_VOICESETS_BY_SEX   = "PRC_CONVOCC_RESTRICT_VOICESETS_BY_SEX";

/**
 * Skips the select a voiceset step entirely, and players have to keep their
 * current voiceset.
 */
const string PRC_CONVOCC_FORCE_KEEP_VOICESET         = "PRC_CONVOCC_FORCE_KEEP_VOICESET";

/**
 * Allow players to keep their exisiting voiceset.
 * The ConvoCC cannot allow players to select custom voiceset, so the only way
 * for players to have them is to select them in the Bioware character creator
 * and then select to keep them in the ConvoCC.
 */
const string PRC_CONVOCC_ALLOW_TO_KEEP_VOICESET      = "PRC_CONVOCC_ALLOW_TO_KEEP_VOICESET";

/**
 * Allow players to keep their exisiting portrait.
 * The ConvoCC cannot allow players to select custom portraits, so the only way
 * for players to have them is to select them in the Bioware character creator
 * and then select to keep them in the ConvoCC.
 */
const string PRC_CONVOCC_ALLOW_TO_KEEP_PORTRAIT      = "PRC_CONVOCC_ALLOW_TO_KEEP_PORTRAIT";

/**
 * Skips the select a portrait step entirely, and players have to keep their
 * current portrait
 */
const string PRC_CONVOCC_FORCE_KEEP_PORTRAIT         = "PRC_CONVOCC_FORCE_KEEP_PORTRAIT";

/**
 * Only allow players to select portraits of the same gender as their character.
 * Most of the NPC portraits do not have a gender so are also removed.
 */
const string PRC_CONVOCC_RESTRICT_PORTRAIT_BY_SEX    = "PRC_CONVOCC_RESTRICT_PORTRAIT_BY_SEX";

/**
 * This option give players the ability to start with racial hit dice for some
 * of the more powerful races. These are defined in ECL.2da.
 * For these races, players do not pick a class in the ConvoCC but instead
 * select 1 or more levels in a racial class (such as monsterous humanoid, or
 * outsider).
 * This is not a complete ECL system, it merely gives players the racial hit
 * dice component of their race. It does not make any measure of the Level
 * Adjustment component. For example, a pixie has no racial hit dice, but has a
 * +4 level adjustment.
 */
const string PRC_CONVOCC_ENABLE_RACIAL_HITDICE       = "PRC_CONVOCC_ENABLE_RACIAL_HITDICE";

/**
 * This enables players to select the hidden skin colours (metallics, matt
 * black, matt white).
 */
const string PRC_CONVOCC_ALLOW_HIDDEN_SKIN_COLOURS   = "PRC_CONVOCC_ALLOW_HIDDEN_SKIN_COLOURS";

/**
 * This enables players to select the hidden hair colours (metallics, matt
 * black, matt white).
 */
const string PRC_CONVOCC_ALLOW_HIDDEN_HAIR_COLOURS   = "PRC_CONVOCC_ALLOW_HIDDEN_HAIR_COLOURS";

/**
 * This enables players to select the hidden tattoo colours (metallics, matt
 * black, matt white).
 */
const string PRC_CONVOCC_ALLOW_HIDDEN_TATTOO_COLOURS = "PRC_CONVOCC_ALLOW_HIDDEN_TATTOO_COLOURS";

/**
 * This option allows players to keep their skillpoints from one level to
 * the next, if they want to.
 */
const string PRC_CONVOCC_ALLOW_SKILL_POINT_ROLLOVER  = "PRC_CONVOCC_ALLOW_SKILL_POINT_ROLLOVER";

/**
 * This will identify new characters based on XP as in v1.3
 * This is less secure than using the encrypted key.
 */
const string PRC_CONVOCC_USE_XP_FOR_NEW_CHAR         = "PRC_CONVOCC_USE_XP_FOR_NEW_CHAR";

/**
 * This is the key used to encrypt characters' names if USE_XP_FOR_NEW_CHAR
 * is false in order to identify returning characters. It should be in the
 * range 1-100.
 * If USE_XP_FOR_NEW_CHAR is true along with this, then returning characters
 * will be encrypted too, so once everone has logged on at least once,
 * USE_XP_FOR_NEW_CHAR can be set to false for greater security.
 */
const string PRC_CONVOCC_ENCRYPTION_KEY              = "PRC_CONVOCC_ENCRYPTION_KEY";

/**
 * As requested, an option to alter the amount of points available in the stat
 * point-buy at character creation.
 * Default: 30
 */
const string PRC_CONVOCC_STAT_POINTS                 = "PRC_CONVOCC_STAT_POINTS";

/**
 * As requirested, if set this will give a number of bonus feats equal to this
 * value to each created character, similar to human Quick To Master feat.
 */
const string PRC_CONVOCC_BONUS_FEATS                 = "PRC_CONVOCC_BONUS_FEATS";

/**
 * As requested, this will cap the maximum a stat can start at, excluding racial
 * modifies.
 * Default: 18
 */
const string PRC_CONVOCC_MAX_STAT                    = "PRC_CONVOCC_MAX_STAT";

/**
 * As requested, this will change the skill point multplier at level 1.
 * Default: 4
 */
const string PRC_CONVOCC_SKILL_MULTIPLIER            = "PRC_CONVOCC_SKILL_MULTIPLIER";

/**
 * As requested, this will give a bonus to skill points after multiplication.
 */
const string PRC_CONVOCC_SKILL_BONUS                 = "PRC_CONVOCC_SKILL_BONUS";


/**
 * Agregado por Inquisidor para que compilen "ow_sum_*"
 */
const string PRC_ORC_WARLORD_COHORT                  = "PRC_ORC_WARLORD_COHORT";

///////////////////////
// Function protypes //
///////////////////////


/**
 * Checks the state of a PRC switch.
 * NOTE: This will only work with switches that use integer values. You
 * must get the value of non-integer-valued switches manually.
 *
 * @param sSwitch  One of the PRC_* constant strings defined in prc_inc_switch
 * @return         The value of the switch queried
 */
int GetPRCSwitch(string sSwitch);

/**
 * Sets a PRC switch state.
 * NOTE: As this will only set switches with integer values, you will need
 * to manually set the (few) switches that should have a value other than
 * integer.
 *
 * @param sSwitch  One of the PRC_* constant strings defined in prc_inc_switch
 * @param nState   The integer value to set the switch to
 */
void SetPRCSwitch(string sSwitch, int nState);

/**
 * Multisummon code, to be run before the summoning effect is applied.
 * Normally, this will only perform the multisummon trick of setting
 * pre-existing summons indestructable if PRC_MULTISUMMON is set.
 *
 * @param oPC          The creature casting the summoning spell
 * @param bOverride    If this is set, ignores the value of PRC_MULTISUMMON switch
 */
void MultisummonPreSummon(object oPC = OBJECT_SELF, int bOverride = FALSE);


/**
 * Sets the epic spell switches to their default values.
 *
 * If PRC_EPIC_INGORE_DEFAULTS is set, this does nothing.
 */
void DoEpicSpellDefaults();

/**
 * Sets the file end markers to their default values.
 *
 * If FILE_END_MANUAL is set, this does nothing.
 */
void SetDefaultFileEnds();

/*
 * This creates an array of all switch names on a waypoint
 * It is used for the switch setting convo to loop over switches easily
 */
void CreateSwitchNameArray();


//////////////////////////////////////////////////
/* Include section                              */
//////////////////////////////////////////////////

#include "inc_array" // Needs direct include instead of inc_utility


//////////////////////////
// Function definitions //
//////////////////////////

int GetPRCSwitch(string sSwitch)
{
    return GetLocalInt(GetModule(), sSwitch);
}

void SetPRCSwitch(string sSwitch, int nState)
{
    SetLocalInt(GetModule(), sSwitch, nState);
}


void MultisummonPreSummon(object oPC = OBJECT_SELF, int bOverride = FALSE)
{
    if(!GetPRCSwitch(PRC_MULTISUMMON) && !bOverride)
        return;
    int i=1;
    object oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oPC, i);
    while(GetIsObjectValid(oSummon))
    {
        AssignCommand(oSummon, SetIsDestroyable(FALSE, FALSE, FALSE));
        AssignCommand(oSummon, DelayCommand(0.1, SetIsDestroyable(TRUE, FALSE, FALSE)));
        i++;
        oSummon = GetAssociate(ASSOCIATE_TYPE_SUMMONED, oPC, i);
    }
}

void DoEpicSpellDefaults()
{
    if(GetPRCSwitch(PRC_EPIC_INGORE_DEFAULTS))
        return;
    SetPRCSwitch(PRC_EPIC_XP_COSTS, TRUE);
    SetPRCSwitch(PRC_EPIC_BACKLASH_DAMAGE, TRUE);
    SetPRCSwitch(PRC_EPIC_FOCI_ADJUST_DC, TRUE);
    SetPRCSwitch(PRC_EPIC_GOLD_MULTIPLIER, 9000);
    SetPRCSwitch(PRC_EPIC_XP_FRACTION, 25);
    SetPRCSwitch(PRC_EPIC_FAILURE_FRACTION_GOLD, 2);
    SetPRCSwitch(PRC_EPIC_BOOK_DESTRUCTION, 50);
}

void SetDefaultFileEnds()
{
    //there is also the fileends.2da file, but that
    //isnt read in here yet. may be later though
    if(GetPRCSwitch(FILE_END_MANUAL))
        return;
    SetPRCSwitch(FILE_END_CLASSES,         255);
    SetPRCSwitch(FILE_END_RACIALTYPES,     255);
    SetPRCSwitch(FILE_END_GENDER,          2);
    SetPRCSwitch(FILE_END_PORTRAITS,       1100);
    SetPRCSwitch(FILE_END_SKILLS,          50);
    SetPRCSwitch(FILE_END_CLASS_FEAT,      600);
    SetPRCSwitch(FILE_END_CLASS_SKILLS,    50);
    SetPRCSwitch(FILE_END_CLASS_POWER,     300);
    SetPRCSwitch(FILE_END_CLASS_SPELLBOOK, 300);
    SetPRCSwitch(FILE_END_FEAT,            22300);
    SetPRCSwitch(FILE_END_CLASS_PREREQ,    25);
    SetPRCSwitch(FILE_END_FAMILIAR,        20);
    SetPRCSwitch(FILE_END_ANIMALCOMP,      20);
    SetPRCSwitch(FILE_END_DOMAINS,         70);
    SetPRCSwitch(FILE_END_SOUNDSET,        450);
    SetPRCSwitch(FILE_END_SPELLS,          16100);
    SetPRCSwitch(FILE_END_SPELLSCHOOL,     10);
    SetPRCSwitch(FILE_END_APPEARANCE,      500);
    SetPRCSwitch(FILE_END_WINGS,           10);
    SetPRCSwitch(FILE_END_TAILS,           10);
    SetPRCSwitch(FILE_END_PACKAGE,         150);
    SetPRCSwitch(FILE_END_RACE_FEAT,       30);
    SetPRCSwitch(FILE_END_IREQ,            50);
    SetPRCSwitch(FILE_END_ITEM_TO_IREQ,    700);
    SetPRCSwitch(FILE_END_BASEITEMS,       115);
    //Companion alone
    if(GetPRCSwitch(PRC_COMPANION_IN_USE))
    {
        SetPRCSwitch(FILE_END_APPEARANCE,   2100);
        SetPRCSwitch(FILE_END_SOUNDSET,     1000);
        SetPRCSwitch(FILE_END_PORTRAITS,    3550);
    }
    //Companion with CEP
    if(GetPRCSwitch(PRC_CEP_COMPANION_IN_USE))
    {
        SetPRCSwitch(FILE_END_APPEARANCE,   2100);
        SetPRCSwitch(FILE_END_SOUNDSET,     1000);
        SetPRCSwitch(FILE_END_PORTRAITS,    3550);
    }
}

void CreateSwitchNameArray()
{
    object oWP = GetWaypointByTag("PRC_Switch_Name_WP");
    if(!GetIsObjectValid(oWP))
        oWP = CreateObject(OBJECT_TYPE_WAYPOINT, "NW_WAYPOINT001", GetStartingLocation(), FALSE, "PRC_Switch_Name_WP");
    if(!GetIsObjectValid(oWP))
        PrintString("CreateSwitchNameArray: Problem creating waypoint.");
    array_create(oWP, "Switch_Name");
    //if you add more switches, add them to this list
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_PNP_TRUESEEING);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_PNP_TRUESEEING_SPOT_BONUS);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_BIOWARE_GRRESTORE);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_BIOWARE_HEAL);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_BIOWARE_MASS_HEAL);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_BIOWARE_HARM);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_BIOWARE_NEUTRALIZE_POISON);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_BIOWARE_REMOVE_DISEASE);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_TIMESTOP_BIOWARE_DURATION);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_TIMESTOP_LOCAL);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_TIMESTOP_NO_HOSTILE);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_TIMESTOP_BLANK_PC);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_PNP_ELEMENTAL_SWARM);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_PNP_FEAR_AURAS);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_PNP_TENSERS_TRANSFORMATION);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_PNP_BLACK_BLADE_OF_DISASTER);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_PNP_FIND_TRAPS);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_PNP_DARKNESS);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_PNP_DARKNESS_35ED);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_PNP_ANIMATE_DEAD);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_CREATE_UNDEAD_PERMANENT);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_CREATE_UNDEAD_UNCONTROLLED);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_NEC_TERM_PERMADEATH);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_SPELL_ALIGNMENT_SHIFT);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_35ED_WORD_OF_FAITH);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_SLEEP_NO_HD_CAP);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_165_DEATH_IMMUNITY);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_USE_NEW_IMBUE_ARROW);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_DRAGON_DISCIPLE_SIZE_CHANGES);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_SAMURAI_ALLOW_STOLEN_SACRIFICE);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_SAMURAI_ALLOW_UNIDENTIFIED_SACRIFICE);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_SAMURAI_SACRIFICE_SCALAR_x100);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_SAMURAI_VALUE_SCALAR_x100);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_EPIC_XP_COSTS);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_EPIC_TAKE_TEN_RULE);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_EPIC_PRIMARY_ABILITY_MODIFIER_RULE);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_EPIC_BACKLASH_DAMAGE);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_EPIC_FOCI_ADJUST_DC);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_EPIC_GOLD_MULTIPLIER);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_EPIC_XP_FRACTION);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_EPIC_FAILURE_FRACTION_GOLD);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_EPIC_BOOK_DESTRUCTION);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_PNP_UNIMPINGED);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_PNP_IMPENETRABILITY);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_PNP_DULLBLADES);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_PNP_CHAMPIONS_VALOR);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_STAFF_CASTER_LEVEL);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_NPC_HAS_PC_SPELLCASTING);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_ECL_USES_XP_NOT_HD);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_DISABLE_DEMILICH);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_SPELLSLAB);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_SPELLSLAB_NOSCROLLS);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_SPELLSLAB_NORECIPES);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_PNP_ABILITY_DAMAGE_EFFECTS);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_SUPPLY_BASED_REST);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_PNP_REST_HEALING);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_PNP_REST_TIME);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_PNP_SPELL_SCHOOLS);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_PLAYER_TIME);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_PNP_SOMATIC_COMPOMENTS);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_PNP_SOMATIC_ITEMS);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_MULTISUMMON);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_SUMMON_ROUND_PER_LEVEL);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_PNP_FAMILIARS);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_PNP_FAMILIAR_FEEDING);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_NO_HP_REROLL);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_NO_FREE_WIZ_SPELLS);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_POWER_ATTACK);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_POWER_ATTACK_STACK_WITH_BW);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_NO_PETRIFY_GUI);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_DISABLE_SWITCH_CHANGING_CONVO);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_DISABLE_DOMAIN_ENFORCEMENT);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_BONUS_COHORTS);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_ACP_MANUAL);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_ACP_AUTOMATIC);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_ACP_NPC_AUTOMATIC);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_ACP_DELAY);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_USE_TAGBASED_INDEX_FOR_POISON);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_USES_PER_ITEM_POISON_COUNT);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_USES_PER_ITEM_POISON_DIE);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_ALLOW_ONLY_SHARP_WEAPONS);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_ALLOW_ALL_POISONS_ON_WEAPONS);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_USE_DEXBASED_WEAPON_POISONING_FAILURE_CHANCE);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_USES_PER_WEAPON_POISON_COUNT);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_USES_PER_WEAPON_POISON_DIE);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_POISON_ALLOW_CLEAN_IN_EQUIP);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_PSI_ASTRAL_CONSTRUCT_USE_2DA);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_PNP_RAPID_METABOLISM);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_PSI_IMP_METAPSIONICS_USE_SUM);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PNP_SHFT_USECR);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PNP_SHFT_S_HUGE);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PNP_SHFT_S_LARGE);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PNP_SHFT_S_MEDIUM);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PNP_SHFT_S_SMALL);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PNP_SHFT_S_TINY);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PNP_SHFT_F_OUTSIDER);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PNP_SHFT_F_ELEMENTAL);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PNP_SHFT_F_CONSTRUCT);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PNP_SHFT_F_UNDEAD);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PNP_SHFT_F_DRAGON);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PNP_SHFT_F_ABERRATION);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PNP_SHFT_F_OOZE);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PNP_SHFT_F_MAGICALBEAST);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PNP_SHFT_F_GIANT);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PNP_SHFT_F_VERMIN);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PNP_SHFT_F_BEAST);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PNP_SHFT_F_ANIMAL);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PNP_SHFT_F_MONSTROUSHUMANOID);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PNP_SHFT_F_HUMANOID);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_PNP_ELEMENTAL_DAMAGE);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_SPELL_SNEAK_DISABLE);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_3_5e_FIST_DAMAGE);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_BRAWLER_SIZE);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_DISABLE_CRAFT);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_CRAFT_TIMER_MULTIPLIER);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_CRAFT_TIMER_MAX);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_CRAFT_TIMER_MIN);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_BREW_POTION_CASTER_LEVEL);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_SCRIBE_SCROLL_CASTER_LEVEL);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_CRAFT_WAND_CASTER_LEVEL);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_CRAFTING_BASE_ITEMS);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), X2_CI_BREWPOTION_MAXLEVEL);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), X2_CI_BREWPOTION_COSTMODIFIER);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), X2_CI_SCRIBESCROLL_COSTMODIFIER);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), X2_CI_CRAFTWAND_MAXLEVEL);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), X2_CI_CRAFTWAND_COSTMODIFIER);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_TELEPORT_MAX_TARGET_LOCATIONS);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_DISABLE_TELEPORTATION);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_PW_TIME);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_PW_PC_AUTOEXPORT);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_PW_HP_TRACKING);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_PW_LOCATION_TRACKING);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_PW_MAPPIN_TRACKING);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_PW_DEATH_TRACKING);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_PW_SPELL_TRACKING);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_XP_USE_SIMPLE_LA);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_XP_USE_SIMPLE_RACIAL_HD);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_XP_USE_SIMPLE_RACIAL_HD_NO_FREE_XP);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_XP_USE_SIMPLE_RACIAL_HD_NO_SELECTION);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_XP_USE_SETXP);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_USE_DATABASE);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_USE_BIOWARE_DATABASE);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_DB_PRECACHE);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_DB_SQLLITE);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_DB_SQLLITE_INTERVAL);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_DB_MYSQL);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_USE_LETOSCRIPT);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_LETOSCRIPT_PHEONIX_SYNTAX);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_LETOSCRIPT_FIX_ABILITIES);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_LETOSCRIPT_UNICORN_SQL);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_LETOSCRIPT_GETNEWESTBIC);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_CONVOCC_ENABLE);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_CONVOCC_AVARIEL_WINGS);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_CONVOCC_FEYRI_WINGS);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_CONVOCC_FEYRI_TAIL);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_CONVOCC_ENFORCE_PNP_RACIAL);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_CONVOCC_ENFORCE_FEATS);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_CONVOCC_DISALLOW_CUSTOMISE_WINGS);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_CONVOCC_DISALLOW_CUSTOMISE_TAIL);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_CONVOCC_DISALLOW_CUSTOMISE_MODEL);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_CONVOCC_USE_RACIAL_APPEARANCES);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_CONVOCC_USE_RACIAL_PORTRAIT);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_CONVOCC_USE_RACIAL_VOICESET);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_CONVOCC_ONLY_PLAYER_VOICESETS);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_CONVOCC_RESTRICT_VOICESETS_BY_SEX);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_CONVOCC_FORCE_KEEP_VOICESET);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_CONVOCC_ALLOW_TO_KEEP_VOICESET);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_CONVOCC_ALLOW_TO_KEEP_PORTRAIT);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_CONVOCC_FORCE_KEEP_PORTRAIT);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_CONVOCC_RESTRICT_PORTRAIT_BY_SEX);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_CONVOCC_ENABLE_RACIAL_HITDICE);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_CONVOCC_ALLOW_HIDDEN_SKIN_COLOURS);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_CONVOCC_ALLOW_HIDDEN_HAIR_COLOURS);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_CONVOCC_ALLOW_HIDDEN_TATTOO_COLOURS);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_CONVOCC_ALLOW_SKILL_POINT_ROLLOVER);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_CONVOCC_USE_XP_FOR_NEW_CHAR);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_CONVOCC_ENCRYPTION_KEY);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_CONVOCC_STAT_POINTS);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_CONVOCC_BONUS_FEATS);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_CONVOCC_MAX_STAT);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_CONVOCC_SKILL_MULTIPLIER);
    array_set_string(oWP, "Switch_Name", array_get_size(oWP, "Switch_Name"), PRC_CONVOCC_SKILL_BONUS);
}
