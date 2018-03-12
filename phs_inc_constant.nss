/*:://////////////////////////////////////////////
//:: Name Spell Constants
//:: FileName PHS_INC_Constant
//:://////////////////////////////////////////////
    This include file is meant for spells which do not
    use default numbers. All spells which are new
    have constants here.

    Also includes all spell-related item specifics and so on.

    Included in phs_inc_spells, and phs_inc_prespells.


    Remember, for the lines in the .2da, add 16777216+(tlk entry number) for
    the name and descriptions.

    Start at #1505, in the spells.2da provided. I still have a couple vfx to
    do, then I'm done. Afterwards, gonna have to fix up the robes and staves.

    Thanks,
    -Soopaman-
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

// Other constants
#include "PHS_INC_VISUALS"
#include "PHS_INC_POLYCONT"

// Special
// - If this is TRUE for a creature, local int, then they are a plant race.
const string PHS_PLANT = "PHS_PLANT";
// - If this is TRUE, for a creature, they are "crystaline".
const string PHS_CRYSTALLINE = "PHS_CRYSTALLINE";
// - This is the wieght of a door, in Pounds (lbs) used for Shatter. Set as local integer.
// - If 0, IE not set, then shatter doesn't work.
const string PHS_PLACEABLE_WEIGHT   = "PHS_PLACEABLE_WEIGHT";
// * Immunity to Open/Close cantrip if set to 1+ on any placeable/door. Plot are auto-not-opened.
const string PHS_CONST_CANNOT_BE_MAGICALLY_OPENED = "PHS_CONST_CANNOT_BE_MAGICALLY_OPENED";

// Spell levels
const int PHS_SPELL_LEVEL_0                         = 0;
const int PHS_SPELL_LEVEL_1                         = 1;
const int PHS_SPELL_LEVEL_2                         = 2;
const int PHS_SPELL_LEVEL_3                         = 3;
const int PHS_SPELL_LEVEL_4                         = 4;
const int PHS_SPELL_LEVEL_5                         = 5;
const int PHS_SPELL_LEVEL_6                         = 6;
const int PHS_SPELL_LEVEL_7                         = 7;
const int PHS_SPELL_LEVEL_8                         = 8;
const int PHS_SPELL_LEVEL_9                         = 9;

// AOEs set thier values (Spell save DC, Caster Level) in locals for better useability
const string PHS_AOE_CASTER_LEVEL       = "PHS_AOE_CASTER_LEVEL";
const string PHS_AOE_SPELL_SAVE_DC      = "PHS_AOE_SPELL_SAVE_DC";
const string PHS_AOE_SPELL_METAMAGIC    = "PHS_AOE_SPELL_METAMAGIC";

// AOEs who have things for On Enter (EG: Acid fog slow) do not stack, but
// are tracked (how many AOE's are affecting the target) via. this local
// integer
const string PHS_SPELL_AOE_AMOUNT = "PHS_SPELL_AOE_AMOUNT";

// Items needed for spells.
// - TAGS!
// All divine focus's tagged...
const string PHS_ITEM_DIVINE_FOCUS          = "PHS_DIV_FOCUS";// Divine Focus Componant.

const string PHS_ITEM_ROPE                  = "PHS_Rope";       // Animate Rope
const string PHS_ITEM_SPELL_WATER_BOTTLE    = "PHS_Water";      // Create Water
const string PHS_ITEM_SPELL_5LS_SILVER      = "PHS_Silver";     // Bless Water
const string PHS_ITEM_500_HOLY_SYMBOL       = "PHS_500Holy";    // Destruction
const string PHS_ITEM_DIAMOND_DUST          = "PHS_Dia_Dust";   // Stoneskin
const string PHS_ITEM_1000_DIAMOND          = "PHS_Diamond_1000";// Prot. Spells
const string PHS_ITEM_500_DIAMOND           = "PHS_Diamond_500";// Prot. Spells
const string PHS_ITEM_25_INCENSE            = "PHS_Incense_25"; // Augury.

// This stores the diamond for each target that they are using for
// protection Versus spells
const string PHS_STORED_PROT_SPELLS_ITEM    = "PHS_STORED_PROT_SPELLS_ITEM";

// AOE constants
const int PHS_AOE_PER_FOGACID           = 0; //AOE_PER_FOGACID
const int PHS_AOE_PER_GHOST_SOUND       = 29;//AOE_PER_INVIS_SPHERE
const int PHS_AOE_PER_ALARM             = 29;//AOE_PER_INVIS_SPHERE
const int PHS_AOE_PER_DIMENSIONAL_LOCK  = 0; //AOE_PER_FOGACID
const int PHS_AOE_MOB_ANITLIFE_SHELL    = 44;//2da entry. 3.3M radius.
const int PHS_AOE_PER_WALLBLADE_ROUND   = 30;//VFX_MOB_SILENCE

const string PHS_TAG_AOE_PER_ALARM              = "PHS_AOE_PER_ALARM";
const string PHS_TAG_AOE_MOB_ANITLIFE_SHELL     = "PHS_AOE_MOB_ANITLIFE_SHELL";
const string PHS_TAG_AOE_PER_DIMENSIONAL_LOCK   = "PHS_AOE_PER_DIM_LOCK";

// New item property constants
const int PHS_IP_CONST_CASTSPELL_GOODBERRY                  = 1;
const int PHS_IP_CONST_ONHIT_CASTSPELL_DISRUPTING_WEAPON    = 1;

// Wild magic constants
// - the applying effects script
const string PHS_WILD_MAGIC_SCRIPT          = "phs_ail_wildmagc";
// - Set to a LOCATION or OBJECT, the new one that the spell should hit
const string PHS_WILD_MAGIC_OVERRIDE_THING  = "PHS_WILD_MAGIC_OVERRIDE_THING";
// - Set to TRUE if the object/location of the spell has changed
const string PHS_WILD_MAGIC_CHECK           = "PHS_WILD_MAGIC_CHECK";
// - Set to TRUE if a object, else location
const string PHS_WILD_MAGIC_LOCATIONTARGET  = "PHS_WILD_MAGIC_LOCATIONTARGET";


// Other constants

// Object for Maze or Imprisonment
const string PHS_MAZEPRISON_OBJECT      = "PHS_MAZEPRISON_OBJECT";
// Maze target - Tag of waypoint
const string PHS_S_MAZE_TARGET          = "PHS_S_MAZE_TARGET";
// Imprisonment Target - Tag of waypoint
const string PHS_S_IMPRISONMENT_TARGET  = "PHS_S_IMPRISONMENT_TARGET";
// The objects that need to be created
const string PHS_MAZE_OBJECT            = "phs_maze_marker";
const string PHS_IMPRISONMENT_OBJECT    = "phs_pris_marker";
// And the variables set on the target to get them back
const string PHS_S_MAZEPRISON_LOCATION  = "PHS_S_MAZEPRISON_LOCATION";
const string PHS_S_MAZEPRISON_OLD_AREA  = "PHS_S_MAZEPRISON_OLD_AREA";
// - Only used in maze below
const string PHS_S_MAZE_ROUND_COUNTER   = "PHS_S_MAZE_ROUND_COUNTER";

// Cloudkill moves! (Creature based, therefore will not upset any sort of walls)
// - Constants set on it for the spell to work
const string PHS_CLOUDKILL_LOCATION     = "PHS_CLOUDKILL_LOCATION";
const string PHS_CLOUDKILL_CASTER       = "PHS_CLOUDKILL_CASTER";
const string PHS_CLOUDKILL_SAVEDC       = "PHS_CLOUDKILL_SAVEDC";
const string PHS_CLOUDKILL_METAMAGIC    = "PHS_CLOUDKILL_METAMAGIC";
const string PHS_CLOUDKILL_DURATION     = "PHS_CLOUDKILL_DURATION";
// Incremented on pesudo-heartbeat
const string PHS_CLOUDKILL_ROUNDS_DONE  = "PHS_CLOUDKILL_ROUNDS_DONE";
// Constant used dynamically on targets. Adds ID of cloudkill object.
const string PHS_CLOUDKILL_6HD_SAVED    = "PHS_CLOUDKILL_6HD_SAVED";

// The integers set for Spell Immunty spell, user choices.
const string PHS_SPELL_IMMUNITY_USER = "PHS_SPELL_IMMUNITY_USER";

// Integer for moving, barriers.
// - If TRUE on enter, it destroys the barrier.
const string PHS_MOVING_BARRIER             = "PHS_MOVING_BARRIER";
// - If TRUE, ignore On Enter events. The barrier starts on the first HB.
const string PHS_MOVING_BARRIER_START       = "PHS_MOVING_BARRIER_START";
// - Mobile barriers last location
const string PHS_MOVING_BARRIER_LOCATION    = "PHS_MOVING_BARRIER_LOCATION";

// These are sound constants. Can use PHS_PlaySounds(int iSoundVariable) with these
// - Used in Ghost Sounds
const int PHS_SOUNDS_HUMAN          = 1;
const int PHS_SOUNDS_HUMAN_LOUD     = 2;
const int PHS_SOUNDS_HUMAN_BATTLE   = 3;
const int PHS_SOUNDS_ORCS           = 4;
const int PHS_SOUNDS_ORCS_MOB       = 5;
const int PHS_SOUNDS_WIND           = 6;
const int PHS_SOUNDS_WIND_LOUD      = 7;
const int PHS_SOUNDS_WIND_GALE      = 8;
const int PHS_SOUNDS_WATER_DRIP     = 9;
const int PHS_SOUNDS_WATER_POOL     = 10;
const int PHS_SOUNDS_WATER_RIVER    = 11;
const int PHS_SOUNDS_RATS           = 12;


// These use AmbientSoundChangeDay/AmbientSoundChangeNight for a bit.
const int PHS_SOUNDS_AREA_WHISPERS  = 100;
const int PHS_SOUNDS_AREA_TALKING   = 101;
const int PHS_SOUNDS_AREA_FIGHTING  = 102;

// String setting (LocalString/Integer) constants for the variable names
const string PHS_GHOST_SOUND_SOUNDS_CUSTOM = "PHS_GHOST_SOUND_SOUNDS_CUSTOM";


/******************************* SPECIAL **************************************/

// - "Spell" which applys fatigue effects
const int PHS_SPECIAL_FATIGUE                   = 1;


/******************************* MONSTER ABILITIES ****************************/




/******************************* SPELLS ***************************************/

// - If uncommented, the spell is not complete, or no spell script exsists.

/*
    Version number is at the end (IE where it is from) most will be "3.5 Standard"
    for the 3.5 standard ruleset
       - http://3.5srd.com/web/sovelior_sage_srd/Sovelior%20SRD/home.html
*/

/*AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA*/
// - Complete 3.5 list!
const int PHS_SPELL_ACID_ARROW                  = -10;
const int PHS_SPELL_ACID_FOG                    = -10;
const int PHS_SPELL_ACID_SPLASH                 = -10;
const int PHS_SPELL_AID                         = -10;
const int PHS_SPELL_AIR_WALK                    = -10;
const int PHS_SPELL_ALARM                       = -10;
const int PHS_SPELL_ALARM_AUDIBLE                   = -10;
const int PHS_SPELL_ALARM_MESSAGE                   = -10;
const int PHS_SPELL_ALIGN_WEAPON                = -10;
const int PHS_SPELL_ALIGN_WEAPON_EVIL               = -10;
const int PHS_SPELL_ALIGN_WEAPON_GOOD               = -30;
const int PHS_SPELL_ALIGN_WEAPON_CHAOTIC            = -40;
const int PHS_SPELL_ALIGN_WEAPON_LAWFUL             = -50;
//const int PHS_SPELL_ALTER_SELF                  = -10;
//const int PHS_SPELL_ALTER_SELF_HUMAN            = -10;
//const int PHS_SPELL_ALTER_SELF_ELF              = -10;
//const int PHS_SPELL_ALTER_SELF_HALF_ORC         = -10;
//const int PHS_SPELL_ALTER_SELF_HALFLING         = -10;
//const int PHS_SPELL_ALTER_SELF_GNOME            = -10;
//const int PHS_SPELL_ANALYZE_DWEOMER             = -10;
//const int PHS_SPELL_ANALYZE_DWEOMER_MORE            = -10;
//const int PHS_SPELL_ANIMAL_GROWTH               = -10;
//const int PHS_SPELL_ANIMAL_MESSENGER            = -10;
//const int PHS_SPELL_ANIMAL_MESSENGER_RAVEN          = -10;
//const int PHS_SPELL_ANIMAL_MESSENGER_RAT            = -10;
//const int PHS_SPELL_ANIMAL_SHAPES               = -10;
//const int PHS_SPELL_ANIMAL_TRANCE               = -10;
//const int PHS_SPELL_ANIMATE_DEAD                = -10;
//const int PHS_SPELL_ANIMATE_OBJECTS             = -10;
//const int PHS_SPELL_ANIMATE_PLANTS              = -10;
const int PHS_SPELL_ANIMATE_ROPE                = -10;
const int PHS_SPELL_ANTILIFE_SHELL              = 1505;
//const int PHS_SPELL_ANTIMAGIC_FIELD             = -10;
//const int PHS_SPELL_ANTIPATHY                   = -10;
//const int PHS_SPELL_ANITPLANT_SHELL             = -10;
//const int PHS_SPELL_ARCANE_EYE                  = -10;
//const int PHS_SPELL_ARCANE_LOCK                 = -10;
//const int PHS_SPELL_ARCANE_MARK                 = -10;
//const int PHS_SPELL_ARCANE_SIGHT                = -10;
//const int PHS_SPELL_ARCANE_SIGHT_GREATER        = -10;
//const int PHS_SPELL_ASTRAL_PROJECTION           = -10;
//const int PHS_SPELL_ATONEMENT                   = -10;
const int PHS_SPELL_AUGURY                      = -10;
const int PHS_SPELL_AWAKEN                      = 1506;

/*BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB*/
// - Complete 3.5 list!
//const int PHS_SPELL_BALEFUL_POLYMORPH           = -10;
const int PHS_SPELL_BANE                        = -10;
//const int PHS_SPELL_BANISHMENT                  = -10;
const int PHS_SPELL_BARKSKIN                    = -10;
const int PHS_SPELL_BEARS_ENDURANCE             = -10;
const int PHS_SPELL_BEARS_ENDURANCE_MASS        = -10;
const int PHS_SPELL_BESTOW_CURSE                = -10;
const int PHS_SPELL_BESTOW_CURSE_ABILITY            = -10;
const int PHS_SPELL_BESTOW_CURSE_ROLLS              = -30;
const int PHS_SPELL_BESTOW_CURSE_RANDOM             = -40;
//const int PHS_SPELL_BINDING                     = -10;
//const int PHS_SPELL_BLACK_TENTACLES             = -10;
const int PHS_SPELL_BLADE_BARRIER               = -10;
const int PHS_SPELL_BLADE_BARRIER_SQUARE            = -10;
const int PHS_SPELL_BLADE_BARRIER_ROUND             = -10;
//const int PHS_SPELL_BLASPHEMY                   = -10;
const int PHS_SPELL_BLESS                       = -10;
const int PHS_SPELL_BLESS_WATER                 = -10;
const int PHS_SPELL_BLESS_WEAPON                = -10;
const int PHS_SPELL_BLIGHT                      = -10;
const int PHS_SPELL_BLINDNESS_DEAFNESS          = -10;
const int PHS_SPELL_BLINDNESS_DEAFNESS_BLIND        = -20;
const int PHS_SPELL_BLINDNESS_DEAFNESS_DEAF         = -30;
const int PHS_SPELL_BLINK                       = -10;
const int PHS_SPELL_BLUR                        = -10;
//const int PHS_SPELL_BREAK_ENCHANTMENT           = -10;
const int PHS_SPELL_BULLS_STRENGTH              = -10;
const int PHS_SPELL_BULLS_STRENGTH_MASS         = -10;
const int PHS_SPELL_BURNING_HANDS               = -10;

/*CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC*/

const int PHS_SPELL_CALL_LIGHTNING              = -10;
const int PHS_SPELL_CALL_LIGHTNING_STORM        = -10;
//const int PHS_SPELL_CALM_ANIMALS                = -10;
//const int PHS_SPELL_CALM_EMOTIONS               = -10;
const int PHS_SPELL_CATS_GRACE                  = -10;
const int PHS_SPELL_CATS_GRACE_MASS             = -10;
const int PHS_SPELL_CAUSE_FEAR                  = -10;
const int PHS_SPELL_CHAIN_LIGHTNING             = -10;
const int PHS_SPELL_CHANGESTAFF                 = -10;
const int PHS_SPELL_CHAOS_HAMMER                = 1507;
//const int PHS_SPELL_CHARM_ANIMAL                = 1;
//const int PHS_SPELL_CHARM_MONSTER               = 1;
//const int PHS_SPELL_CHARM_MONSTER_MASS          = 1;
//const int PHS_SPELL_CHARM_PERSON                = 1;
//const int PHS_SPELL_CHILL_METAL                 = 1;
const int PHS_SPELL_CHILL_TOUCH                 = 1508;
//const int PHS_SPELL_CIRCLE_OF_DEATH             = -10;
//const int PHS_SPELL_CLAIRAUDIENCE_CLAIRVOYANCE  = -10;
//const int PHS_SPELL_CLENCHED_FIST               = -10;
const int PHS_SPELL_CLOAK_OF_CHAOS              = -10;
//const int PHS_SPELL_CLONE                       = -10;
const int PHS_SPELL_CLOUDKILL                   = -10;

const int PHS_SPELL_COLOR_SPRAY                 = -10;

const int PHS_SPELL_CONFUSION                   = -10;
const int PHS_SPELL_LESSER_CONFUSION            = -10;

const int PHS_SPELL_CREATE_WATER                = -10;
const int PHS_SPELL_CREATE_WATER_BOTTLE             = -10;
const int PHS_SPELL_CREATE_WATER_VISUAL             = -10;
const int PHS_SPELL_CREATE_WATER_EXTINGUISH         = -10;

const int PHS_SPELL_CRUSHING_DISPARE            = -10;

const int PHS_SPELL_CURE_CRITICAL_WOUNDS        = -10;
const int PHS_SPELL_CURE_CRITICAL_WOUNDS_MASS   = -10;
const int PHS_SPELL_CURE_LIGHT_WOUNDS           = -10;
const int PHS_SPELL_CURE_LIGHT_WOUNDS_MASS      = -10;
const int PHS_SPELL_CURE_MINOR_WOUNDS           = -10;
const int PHS_SPELL_CURE_MODERATE_WOUNDS        = -10;
const int PHS_SPELL_CURE_MODERATE_WOUNDS_MASS   = -10;
const int PHS_SPELL_CURE_SERIOUS_WOUNDS         = -10;
const int PHS_SPELL_CURE_SERIOUS_WOUNDS_MASS    = -10;

/*DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD*/

const int PHS_SPELL_DANCING_LIGHTS              = 1509;

const int PHS_SPELL_DAZE                        = -10;

const int PHS_SPELL_DAZE_MONSTER                = -10;

const int PHS_SPELL_DEATH_KNELL                 = -10;

const int PHS_SPELL_DESTRUCTION                 = -10;

const int PHS_SPELL_DETECT_POISON               = -10;

const int PHS_SPELL_DIMENSION_DOOR              = 1510;
const int PHS_SPELL_DIMENSIONAL_ANCHOR          = -666;
const int PHS_SPELL_DIMENSIONAL_LOCK            = -777;

const int PHS_SPELL_DISINTEGRATE                = 1511;
const int PHS_SPELL_DISRUPT_UNDEAD              = -11;
const int PHS_SPELL_DISRUPTING_WEAPON           = -10;

const int PHS_SPELL_DISPLACEMENT                = -10;


const int PHS_SPELL_DIVINE_POWER                = -10;

const int PHS_SPELL_DOMINATE_PERSON             = -10;
const int PHS_SPELL_DOMINATE_MONSTER            = -10;

const int PHS_SPELL_DOOM                        = -99999;

/*EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE*/

const int PHS_SPELL_EAGLES_SPLENDOR             = -10;
const int PHS_SPELL_EAGLES_SPLENDOR_MASS        = -10;

const int PHS_SPELL_ENERGY_DRAIN                = -10;
const int PHS_SPELL_ENERVATION                  = -10;

const int PHS_SPELL_EYEBITE                     = -1111;

/*FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF*/

//const int PHS_SPELL_FABRICATE                   = -10;
//const int PHS_SPELL_FAERIE_FIRE                 = -10;
const int PHS_SPELL_FALSE_LIFE                  = -10;
//const int PHS_SPELL_FALSE_VISION                = -10;
const int PHS_SPELL_FEAR                        = -444444;
//const int PHS_SPELL_FEATHER_FALL                = -10;
const int PHS_SPELL_FEEBLEMIND                  = -10;
const int PHS_SPELL_FIND_THE_PATH               = -10;
const int PHS_SPELL_FIND_TRAPS                  = -10;
const int PHS_SPELL_FINGER_OF_DEATH             = -10;
//const int PHS_SPELL_FIRE_SEEDS                  = -10;
const int PHS_SPELL_FIRE_SHIELD                 = -10;
const int PHS_SPELL_FIRE_SHIELD_WARM                = -10;
const int PHS_SPELL_FIRE_SHIELD_CHILL               = -20;
//const int PHS_SPELL_FIRE_STORM                  = -10;
//const int PHS_SPELL_FIRE_TRAP                   = -10;
const int PHS_SPELL_FIREBALL                    = -10;
const int PHS_SPELL_FLAME_ARROW                 = -10;
const int PHS_SPELL_FLAME_STRIKE                = -10;
//const int PHS_SPELL_FLAMING_SPHERE              = -10;
const int PHS_SPELL_FLARE                       = -10;
const int PHS_SPELL_FLESH_TO_STONE              = -10;
//const int PHS_SPELL_FLY                         = -10;
//const int PHS_SPELL_FLOATING_DISK               = -10;
//const int PHS_SPELL_FOG_CLOUD                   = -10;
//const int PHS_SPELL_FORBIDDANCE                 = -10;
//const int PHS_SPELL_FORCECAGE                   = -10;
const int PHS_SPELL_FORCEFUL_HAND               = -10;
const int PHS_SPELL_FORESIGHT                   = -10;
const int PHS_SPELL_FOXS_CUNNING                = -10;
const int PHS_SPELL_FOXS_CUNNING_MASS           = -10;
const int PHS_SPELL_FREEDOM                     = -10;
const int PHS_SPELL_FREEDOM_OF_MOVEMENT         = -10;
const int PHS_SPELL_FREEZING_SPHERE             = 1512;

/*GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG*/

const int PHS_SPELL_GHOST_SOUND                 = -10;
const int PHS_SPELL_GHOST_SOUND_HUMANS              = -10;
const int PHS_SPELL_GHOST_SOUND_ORCS                = -10;
const int PHS_SPELL_GHOST_SOUND_RATS                = -10;
const int PHS_SPELL_GHOST_SOUND_WIND                = -10;
const int PHS_SPELL_GHOST_SOUND_CUSTOM              = -10;
const int PHS_SPELL_GHOUL_TOUCH                 = -10;

const int PHS_SPELL_GLIBNESS                    = 1513;

const int PHS_SPELL_GLITTERDUST                 = 1514;
const int PHS_SPELL_GLOBE_OF_INVUNRABILITY        = -10;
const int PHS_SPELL_GLOBE_OF_INVUNRABILITY_LESSER = -10;
const int PHS_SPELL_GOOD_HOPE                   = -10;
const int PHS_SPELL_GOODBERRY                   = -10;

const int PHS_SPELL_GUIDANCE                    = -10;
const int PHS_SPELL_GUIDANCE_ATTACK                 = -10;
const int PHS_SPELL_GUIDANCE_SAVE                   = -10;
const int PHS_SPELL_GUIDANCE_SKILL                  = -10;

/*HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH*/

//const int PHS_SPELL_HALLOW                      = -10;
//const int PHS_SPELL_HALLUCINATORY_TERRAIN       = -10;
const int PHS_SPELL_HALT_UNDEAD                 = -10;
const int PHS_SPELL_HARM                        = -10;
const int PHS_SPELL_HASTE                       = -10;
const int PHS_SPELL_HEAL                        = -10;
//const int PHS_SPELL_HEAL_MASS                   = -10;
//const int PHS_SPELL_HEAL_MOUNT                  = -10;
//const int PHS_SPELL_HEAT_METAL                  = -10;
//const int PHS_SPELL_HELPING_HAND                = -10;
//const int PHS_SPELL_HEROES_FEAST                = -10;
const int PHS_SPELL_HEROISM                     = -10;
const int PHS_SPELL_HEROISM_GREATER             = -10;
//const int PHS_SPELL_HIDE_FROM_ANIMALS           = -10;
//const int PHS_SPELL_HIDE_FROM_UNDEAD            = -10;
//const int PHS_SPELL_HIDEOUS_LAUGHTER            = -10;
//const int PHS_SPELL_HOLD_ANIMAL                 = -10;
//const int PHS_SPELL_HOLD_MONSTER                = -10;
//const int PHS_SPELL_HOLD_MONSTER_MASS           = -10;
//const int PHS_SPELL_HOLD_PERSON                 = -10;
//const int PHS_SPELL_HOLD_PERSON_MASS            = -10;
//const int PHS_SPELL_HOLD_PORTAL                 = -10;
//const int PHS_SPELL_HOLY_AURA                   = -10;
//const int PHS_SPELL_HOLY_SMITE                  = -10;
//const int PHS_SPELL_HOLY_SWORD                  = -10;
//const int PHS_SPELL_HOLY_WORD                   = -10;
//const int PHS_SPELL_HORRID_WILTING              = -10;
//const int PHS_SPELL_HYPNOTIC_PATTERN            = -10;
//const int PHS_SPELL_HYPNOTISM                   = -10;

/*IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII*/

//const int PHS_SPELL_ICE_STORM                   = -10;
//const int PHS_SPELL_IDENTIFY                    = -10;
//const int PHS_SPELL_ILLUSORY_SCRIPT             = -10;
//const int PHS_SPELL_ILLUSORY_WALL               = -10;
//const int PHS_SPELL_IMBUNE_WITH_SPELL_ABILITY   = -10;
const int PHS_SPELL_IMPLOSION                   = -10;
const int PHS_SPELL_IMPRISONMENT                = 1515;
//const int PHS_SPELL_INCENDIARY_CLOUD            = -10;
const int PHS_SPELL_INFLICT_CRITICAL_WOUNDS     = -10;
const int PHS_SPELL_INFLICT_CRITICAL_WOUNDS_MASS = -10;
const int PHS_SPELL_INFLICT_LIGHT_WOUNDS        = -10;
const int PHS_SPELL_INFLICT_LIGHT_WOUNDS_MASS   = -10;
const int PHS_SPELL_INFLICT_MINOR_WOUNDS        = -10;
const int PHS_SPELL_INFLICT_MODERATE_WOUNDS     = -10;
const int PHS_SPELL_INFLICT_MODERATE_WOUNDS_MASS = -10;
const int PHS_SPELL_INFLICT_SERIOUS_WOUNDS      = -10;
const int PHS_SPELL_INFLICT_SERIOUS_WOUNDS_MASS = -10;
const int PHS_SPELL_INSANITY                    = 1516;
//const int PHS_SPELL_INSECT_PLAGUE               = -10;
//const int PHS_SPELL_INSTANT_SUMMONS             = -10;
//const int PHS_SPELL_INTERPOSING_HAND            = -10;
//const int PHS_SPELL_INVISIBILITY                = -10;
//const int PHS_SPELL_INVISIBILITY_GREATER        = -10;
//const int PHS_SPELL_INVISIBILITY_MASS           = -10;
//const int PHS_SPELL_INVISIBILITY_PURGE          = -10;
//const int PHS_SPELL_INVISIBILITY_SPHERE         = -10;
//const int PHS_SPELL_IRON_BODY                   = -10;
//const int PHS_SPELL_IRONWOOD                    = -10;
//const int PHS_SPELL_IRRESISTIBLE_DANCE          = -10;

/*JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ*/

//const int PHS_SPELL_JUMP                        = -10;

/*KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK*/

//const int PHS_SPELL_KEEN_EDGE                   = -10;
const int PHS_SPELL_KNOCK                       = -10;
const int PHS_SPELL_KNOW_DIRECTION              = -10;

/*LLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL*/

//const int PHS_SPELL_LEGEND_LORE                 = -10;
//const int PHS_SPELL_LEVITATE                    = -10;
//const int PHS_SPELL_LIGHT                       = -10;
//const int PHS_SPELL_LIGHTNING_BOLT              = -10;
//const int PHS_SPELL_LIMITED_WISH                = -10;
//const int PHS_SPELL_LIVEOAK                     = -10;
//const int PHS_SPELL_LOCATE_CREATURE             = -10;
//const int PHS_SPELL_LOCATE_OBJECT               = -10;
const int PHS_SPELL_LONGSTRIDER                 = -10;
const int PHS_SPELL_LULLABY                     = -10;

/*MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM*/

const int PHS_SPELL_MAGE_ARMOR                  = -10;

const int PHS_SPELL_MAGIC_MISSILE               = -10;
const int PHS_SPELL_MAGIC_MISSILE_SINGLE            = -10;
const int PHS_SPELL_MAGIC_MISSILE_AREA              = -10;

const int PHS_SPELL_MAZE                        = 1517;

/*NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN*/

const int PHS_SPELL_NEUTRALIZE_POISON           = -10;
//const int PHS_SPELL_NIGHTMARE                   = -10;
//const int PHS_SPELL_NONDETECTION                = -10;

/*OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO*/

//const int PHS_SPELL_OBSCURE_OBJECT              = -10;
//const int PHS_SPELL_OBSCURING_MIST              = -10;
const int PHS_SPELL_OPEN_CLOSE                  = -10;
//const int PHS_SPELL_ORDERS_WRATH                = -10;
//const int PHS_SPELL_OVERLAND_FLIGHT             = -10;
const int PHS_SPELL_OWLS_WISDOM                 = -10;
const int PHS_SPELL_OWLS_WISDOM_MASS            = -10;

/*PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP*/

//const int PHS_SPELL_PASSWALL                    = -10;
//const int PHS_SPELL_PASS_WITHOUT_TRACE          = -10;
//const int PHS_SPELL_PERMANENCY                  = -10;
//const int PHS_SPELL_PERMANENT_IMAGE             = -10;
//const int PHS_SPELL_PERSISTENT_IMAGE            = -10;
const int PHS_SPELL_PHANTASMAL_KILLER           = -10;
//const int PHS_SPELL_PHANTOM_STEED               = -10;
//const int PHS_SPELL_PHANTOM_TRAP                = -10;
//const int PHS_SPELL_PHASE_DOOR                  = -10;
//const int PHS_SPELL_PLANAR_ALLY                 = -10;
//const int PHS_SPELL_PLANAR_ALLY_GREATER         = -10;
//const int PHS_SPELL_PLANAR_ALLY_LESSER          = -10;
//const int PHS_SPELL_PLANAR_BINDING              = -10;
//const int PHS_SPELL_PLANAR_BINDING_GREATER      = -10;
//const int PHS_SPELL_PLANAR_BINDING_LESSER       = -10;
//const int PHS_SPELL_PLANE_SHIFT                 = -10;
//const int PHS_SPELL_PLANT_GROWTH                = -10;
//const int PHS_SPELL_POISON                      = -10;
const int PHS_SPELL_POLAR_RAY                   = -10;
//const int PHS_SPELL_POLYMORPH                   = -10;
//const int PHS_SPELL_POLYMORPH_ANY_OBJECT        = -10;
const int PHS_SPELL_POWER_WORD_BLIND            = 1518;
const int PHS_SPELL_POWER_WORD_KILL             = -10;
const int PHS_SPELL_POWER_WORD_STUN             = 1519;
//const int PHS_SPELL_PRAYER                      = -10;
//const int PHS_SPELL_PRESTIDIGITATION            = -10;
//const int PHS_SPELL_PRISMATIC_SPHERE            = -10;
const int PHS_SPELL_PRISMATIC_SPRAY             = -10;
//const int PHS_SPELL_PRISMATIC_WALL              = -10;
//const int PHS_SPELL_PRODUCE_FLAME               = -10;
//const int PHS_SPELL_PROGRAMMED_IMAGE            = -10;
//const int PHS_SPELL_PROJECT_IMAGE               = -10;
const int PHS_SPELL_PROTECTION_FROM_ARROWS      = 1520;
//const int PHS_SPELL_PROTECTION_FROM_CHAOS       = -10;
const int PHS_SPELL_PROTECTION_FROM_ENERGY      = 1521;
const int PHS_SPELL_PROTECTION_FROM_ENERGY_ACID     = 1522;
const int PHS_SPELL_PROTECTION_FROM_ENERGY_COLD     = 1523;
const int PHS_SPELL_PROTECTION_FROM_ENERGY_ELECTRICAL = 1524;
const int PHS_SPELL_PROTECTION_FROM_ENERGY_FIRE     = 1525;
const int PHS_SPELL_PROTECTION_FROM_ENERGY_SONIC    = 1526;
//const int PHS_SPELL_PROTECTION_FROM_EVIL        = -10;
//const int PHS_SPELL_PROTECTION_FROM_GOOD        = -10;
//const int PHS_SPELL_PROTECTION_FROM_LAW         = -10;
const int PHS_SPELL_PROTECTION_FROM_SPELLS      = -10;
//const int PHS_SPELL_PRYING_EYES                 = -10;
//const int PHS_SPELL_PRYING_EYES_GREATER         = -10;
//const int PHS_SPELL_PURIFY_FOOD_AND_DRINK       = -10;
//const int PHS_SPELL_PYROTECHNICS                = -10;

/*QQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQ*/

//const int PHS_SPELL_QUENCH                      = -10;

/*RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR*/

const int PHS_SPELL_RAGE                        = -10;
//const int PHS_SPELL_RAINBOW_PATTERN             = -10;
//const int PHS_SPELL_RAISE_DEAD                  = -10;
const int PHS_SPELL_RAY_OF_ENFEEBLEMENT         = -10;
const int PHS_SPELL_RAY_OF_FROST                = -10;
const int PHS_SPELL_READ_MAGIC                  = -10;
//const int PHS_SPELL_REDUCE_ANIMAL               = -10;
//const int PHS_SPELL_REDUCE_PERSON               = -10;
//const int PHS_SPELL_REDUCE_PERSON_MASS          = -10;
//const int PHS_SPELL_REFUGE                      = -10;
const int PHS_SPELL_REGENERATE                  = -10;
//const int PHS_SPELL_REINCARNATE                 = -10;
//const int PHS_SPELL_REMOVE_BLINDNESS_DEAFNESS   = -10;
//const int PHS_SPELL_REMOVE_CURSE                = -10;
//const int PHS_SPELL_REMOVE_DISEASE              = -10;
//const int PHS_SPELL_REMOVE_FEAR                 = -10;
//const int PHS_SPELL_REMOVE_PARALYSIS            = -10;
//const int PHS_SPELL_REPEL_METAL_OR_STONE        = -10;
//const int PHS_SPELL_REPEL_VIRMIN                = -10;
//const int PHS_SPELL_REPEL_WOOD                  = -10;
//const int PHS_SPELL_REPULSION                   = -10;
//const int PHS_SPELL_RESILIENT_SPHERE            = -10;
const int PHS_SPELL_RESISTANCE                  = -10;
//const int PHS_SPELL_RESIST_ENERGY               = -10;
//const int PHS_SPELL_RESTORATION                 = -10;
//const int PHS_SPELL_RESTORATION_GREATER         = -10;
//const int PHS_SPELL_RESTORATION_LESSER          = -10;
//const int PHS_SPELL_RESSURECTION                = -10;
//const int PHS_SPELL_REVERSE_GRAVITY             = -10;
//const int PHS_SPELL_RIGHTEOUS_MIGHT             = -10;
//const int PHS_SPELL_ROPE_TRICK                  = -10;
//const int PHS_SPELL_RUSTING_GRASP               = -10;

/*SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS*/

const int PHS_SPELL_SANCTUARY                   = -10;
const int PHS_SPELL_SCARE                       = -11111;
//const int PHS_SPELL_SCINTILLATING_PATTERN       = -10;
//const int PHS_SPELL_SCORCHING_RAY               = -10;
//const int PHS_SPELL_SCREEN                      = -10;
//const int PHS_SPELL_SCRYING                     = -10;
//const int PHS_SPELL_SCRYING_GREATER             = -10;
//const int PHS_SPELL_SCULPT_SOUND                = -10;
const int PHS_SPELL_SEARING_LIGHT               = -10;
//const int PHS_SPELL_SECRET_CHEST                = -10;
//const int PHS_SPELL_SECRET_PAGE                 = -10;
//const int PHS_SPELL_SECURE_SHELTER              = -10;
//const int PHS_SPELL_SEE_INVISIBILITY            = -10;
//const int PHS_SPELL_SEEMING                     = -10;
//const int PHS_SPELL_SENDING                     = -10;
//const int PHS_SPELL_SEPIA_SNAKE_SIGIL           = -10;
//const int PHS_SPELL_SEQUESTER                   = -10;
//const int PHS_SPELL_SHADES                      = -10;
//const int PHS_SPELL_SHADOW_CONJURATION          = -10;
//const int PHS_SPELL_SHADOW_CONJURATION_GREATER  = -10;
//const int PHS_SPELL_SHADOW_EVOVATION            = -10;
//const int PHS_SPELL_SHADOW_EVOVATION_GREATER    = -10;
//const int PHS_SPELL_SHADOW_WALK                 = -10;
//const int PHS_SPELL_SHAMBLER                    = -10;
//const int PHS_SPELL_SHAPECHANGE                 = -10;
 int PHS_SPELL_SHATTER                     = -10;
const int PHS_SPELL_SHIELD                      = -10;
//const int PHS_SPELL_SHIELD_OF_FAITH             = -10;
//const int PHS_SPELL_SHIELD_OF_LAW               = -10;
const int PHS_SPELL_SHIELD_OTHER                = -10;
//const int PHS_SHILLELAGH                        = -10;
const int PHS_SPELL_SHOCKING_GRASP              = 1527;
//const int PHS_SPELL_SHOUT                       = -10;
//const int PHS_SPELL_SHOUT_GREATER               = -10;
//const int PHS_SPELL_SHRINK_ITEM                 = -10;
//const int PHS_SPELL_SILENCE                     = -10;
//const int PHS_SPELL_SILENT_IMAGE                = -10;
//const int PHS_SPELL_SIMULACRUM                  = -10;
//const int PHS_SPELL_SLAY_LIVING                 = -10;
//const int PHS_SPELL_SLEEP                       = -10;
//const int PHS_SPELL_SLEET_STORM                 = -10;
const int PHS_SPELL_SLOW                        = -10;
//const int PHS_SPELL_SNARE                       = -10;
//const int PHS_SPELL_SOFTEN_EARTH_AND_STONE      = -10;
//const int PHS_SPELL_SOLID_FOG                   = -10;
//const int PHS_SPELL_SONG_OF_DISCORD             = -10;
//const int PHS_SPELL_SOUL_BIND                   = -10;
const int PHS_SPELL_SOUND_BURST                 = -10;
//const int PHS_SPELL_SPEAK_WITH_ANIMALS          = -10;
//const int PHS_SPELL_SPEAK_WITH_DEAD             = -10;
//const int PHS_SPELL_SPEAK_WITH_PLANTS           = -10;
//const int PHS_SPELL_SPECTRAL_HAND               = -10;
const int PHS_SPELL_SPELL_IMMUNITY              = -10;
const int PHS_SPELL_SPELL_IMMUNITY_FNF_AOE          = -10;
const int PHS_SPELL_SPELL_IMMUNITY_SINGLE           = -10;
const int PHS_SPELL_SPELL_IMMUNITY_PERSISTANT_AOE   = -10;
const int PHS_SPELL_SPELL_IMMUNITY_MIND_AFFECTING   = -10;
const int PHS_SPELL_SPELL_IMMUNITY_USER_SPELL_SET   = -10;
//const int PHS_SPELL_SPELL_IMMUNITY_GREATER      = -10;
const int PHS_SPELL_SPELL_RESISTANCE            = -10;
//const int PHS_SPELL_SPELLSTAFF                  = -10;
const int PHS_SPELL_SPELL_TURNING               = -10;
//const int PHS_SPELL_SPIDER_CLIMB                = -10;
//const int PHS_SPELL_SPIKE_GROWTH                = -10;
//const int PHS_SPELL_SPIKE_STONES                = -10;
//const int PHS_SPELL_SPIRITUAL_WEAPON            = -10;
//const int PHS_SPELL_STATUE                      = -10;
//const int PHS_SPELL_STATUS                      = -10;
//const int PHS_SPELL_STINKING_CLOUD              = -10;
//const int PHS_SPELL_STONE_SHAPE                 = -10;
const int PHS_SPELL_STONESKIN                   = -10;
//const int PHS_SPELL_STONE_TELL                  = -10;
//const int PHS_SPELL_STONE_TO_FLESH              = -10;
//const int PHS_SPELL_STORM_OF_VENGEANCE          = -10;
//const int PHS_SPELL_SUGGESTION                  = -10;
//const int PHS_SPELL_SUGGESTION_MASS             = -10;
//const int PHS_SPELL_SUMMON_INSTRUMENT           = -10;
//const int PHS_SPELL_SUMMON_MONSTER_I            = -10;
//const int PHS_SPELL_SUMMON_MONSTER_II           = -10;
//const int PHS_SPELL_SUMMON_MONSTER_III          = -10;
//const int PHS_SPELL_SUMMON_MONSTER_IV           = -10;
//const int PHS_SPELL_SUMMON_MONSTER_V            = -10;
//const int PHS_SPELL_SUMMON_MONSTER_VI           = -10;
//const int PHS_SPELL_SUMMON_MONSTER_VII          = -10;
//const int PHS_SPELL_SUMMON_MONSTER_VIII         = -10;
//const int PHS_SPELL_SUMMON_MONSTER_IX           = -10;
//const int PHS_SPELL_SUMMON_NATURES_ALLY_I       = -10;
//const int PHS_SPELL_SUMMON_NATURES_ALLY_II      = -10;
//const int PHS_SPELL_SUMMON_NATURES_ALLY_III     = -10;
//const int PHS_SPELL_SUMMON_NATURES_ALLY_IV      = -10;
//const int PHS_SPELL_SUMMON_NATURES_ALLY_V       = -10;
//const int PHS_SPELL_SUMMON_NATURES_ALLY_VI      = -10;
//const int PHS_SPELL_SUMMON_NATURES_ALLY_VII     = -10;
//const int PHS_SPELL_SUMMON_NATURES_ALLY_VIII    = -10;
//const int PHS_SPELL_SUMMON_NATURES_ALLY_IX      = -10;
//const int PHS_SPELL_SUMMON_SWARM                = -10;
const int PHS_SPELL_SUNBEAM                     = -10;
const int PHS_SPELL_SUNBURST                    = -10;
//const int PHS_SPELL_SYMBOL_OF_DEATH             = -10;
//const int PHS_SPELL_SYMBOL_OF_FEAR              = -10;
//const int PHS_SPELL_SYMBOL_OF_INSANITY          = -10;
//const int PHS_SPELL_SYMBOL_OF_PAIN              = -10;
//const int PHS_SPELL_SYMBOL_OF_PERSUASION        = -10;
//const int PHS_SPELL_SYMBOL_OF_SLEEP             = -10;
//const int PHS_SPELL_SYMBOL_OF_STUNNING          = -10;
//const int PHS_SPELL_SYMBOL_OF_WEAKNESS          = -10;
//const int PHS_SPELL_SYMPATHETIC_VIBRATION       = -10;
//const int PHS_SPELL_SYMPATHY                    = -10;

/*TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT*/

//const int PHS_SPELL_TELEKINESIS                 = -10;
//const int PHS_SPELL_TELEKINETIC_SPHERE          = -10;
//const int PHS_SPELL_TELEPATHIC_BOND             = -10;
const int PHS_SPELL_TELEPORT                    = -10;
//const int PHS_SPELL_TELEPORT_OBJECT             = -10;
//const int PHS_SPELL_TELEPORT_GREATER            = -10;
//const int PHS_SPELL_TELEPORTATION_CIRCLE        = -10;
const int PHS_SPELL_TEMPORAL_STASIS             = -10;
const int PHS_SPELL_TIME_STOP                   = -10;
//const int PHS_SPELL_TINY_HUT                    = -10;
//const int PHS_SPELL_TONGUES                     = -10;
//const int PHS_SPELL_TOUCH_OF_FATIGUE            = -10;
const int PHS_SPELL_TOUCH_OF_IDIOCY             = -10;
//const int PHS_SPELL_TRANSFORMATION              = -10;
//const int PHS_SPELL_TRANSMUTE_METAL_TO_WOOD     = -10;
//const int PHS_SPELL_TRANSMUTE_MUD_TO_ROCK       = -10;
//const int PHS_SPELL_TRANSMUTE_ROCK_TO_MUD       = -10;
//const int PHS_SPELL_TRANSPORT_VIA_PLANTS        = -10;
//const int PHS_SPELL_TRAP_THE_SOUL               = -10;
//const int PHS_SPELL_TREE_SHAPE                  = -10;
//const int PHS_SPELL_TREE_STRIDE                 = -10;
//const int PHS_SPELL_TRUE_RESURRECTION           = -10;
const int PHS_SPELL_TRUE_SEEING                 = -10;
//const int PHS_SPELL_TRUE_STRIKE                 = -10;

/*UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU*/

//const int PHS_SPELL_UNDEATH_TO_DEATH            = -10;
//const int PHS_SPELL_UNDETECTABLE_ALIGNMENT      = -10;
//const int PHS_SPELL_UNHALLOW                    = -10;
//const int PHS_SPELL_UNHOLY_AURA                 = -10;
//const int PHS_SPELL_UNHOLY_BLIGHT               = -10;
//const int PHS_SPELL_UNSEEN_SERVANT              = -10;

/*VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV*/

//const int PHS_SPELL_VAMPIRIC_TOUCH              = -10;
//const int PHS_SPELL_VEIL                        = -10;
//const int PHS_SPELL_VENTRILOQUISM               = -10;
//const int PHS_SPELL_VIRTUE                      = -10;
//const int PHS_SPELL_VISION                      = -10;

/*WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW*/

const int PHS_SPELL_WAIL_OF_THE_BANSHEE         = -10;
//const int PHS_SPELL_WALL_OF_FIRE                = -10;
//const int PHS_SPELL_WALL_OF_FORCE               = -10;
//const int PHS_SPELL_WALL_OF_ICE                 = -10;
//const int PHS_SPELL_WALL_OF_IRON                = -10;
//const int PHS_SPELL_WALL_OF_STONE               = -10;
//const int PHS_SPELL_WALL_OF_THORNS              = -10;
//const int PHS_SPELL_WARP_WOOD                   = -10;
//const int PHS_SPELL_WATER_BREATHING             = -10;
//const int PHS_SPELL_WATER_WALK                  = -10;
//const int PHS_SPELL_WAVES_OF_EXHAUSTION         = -10;
//const int PHS_SPELL_WAVES_OF_FATIGUE            = -10;
//const int PHS_SPELL_WEB                         = -10;
//const int PHS_SPELL_WEIRD                       = -10;
//const int PHS_SPELL_WHIRLWIND                   = -10;
//const int PHS_SPELL_WHISPERING_WIND             = -10;
//const int PHS_SPELL_WIND_WALK                   = -10;
//const int PHS_SPELL_WIND_WALL                   = -10;
//const int PHS_SPELL_WISH                        = -10;
//const int PHS_SPELL_WOOD_SHAPE                  = -10;
//const int PHS_SPELL_WORD_OF_CHAOS               = -10;
//const int PHS_SPELL_WORD_OF_RECALL              = -10;

/*XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX*/

//None

/*YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY*/

//None

/*ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ*/

//const int PHS_SPELL_ZONE_OF_SILENCE             = -10;
//const int PHS_SPELL_ZONE_OF_TRUTH               = -10;

/*END*/
