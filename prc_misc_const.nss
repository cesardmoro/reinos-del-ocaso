/** @file
 *
 * Include file for various constants that don't really belong in any of the other files,
 * but aren't numerous enough to warrant their own.
 */

//:://////////////////////////////////////////////
//:: Area of Effect Const
//:://////////////////////////////////////////////

const int AOE_MOB_PESTILENCE                    = 150;
const int AOE_PER_TELEPORTATIONCIRCLE           = 151;
const int AOE_PER_DEEPER_DARKNESS               = 100;

// Psionic Area of Effects
//const int AOE_PER_PSIGREASE                     = 131;
const int AOE_PER_ESHAMBLER                     = 132;
const int AOE_PER_ENERGYWALL                    = 133;
const int AOE_MOB_CATAPSI                       = 134;
const int AOE_PER_NULL_PSIONICS_FIELD           = 135;
const int AOE_MOB_FORM_DOOM                     = 136;
const int AOE_PER_ENERGYWALL_WIDENED            = 137;
const int AOE_PER_ESHAMBLER_WIDENED             = 138;
const int AOE_PER_NULL_PSIONICS_FIELD_WIDENED   = 139;

// Invisible Area of Effects
const int VFX_PER_5_FT_INVIS                    = 184;
const int VFX_PER_10_FT_INVIS                   = 185;
const int VFX_PER_15_FT_INVIS                   = 186;
const int VFX_PER_20_FT_INVIS                   = 187;
const int VFX_PER_25_FT_INVIS                   = 188;
const int VFX_PER_30_FT_INVIS                   = 189;
const int VFX_PER_5M_INVIS                      = 190;
const int VFX_PER_10M_INVIS                     = 191;
const int VFX_PER_15M_INVIS                     = 192;
const int VFX_PER_20M_INVIS                     = 193;
const int VFX_PER_25M_INVIS                     = 194;
const int VFX_PER_30M_INVIS                     = 195;
const int VFX_PER_35M_INVIS                     = 196;
const int VFX_PER_40M_INVIS                     = 197;
const int VFX_PER_45M_INVIS                     = 198;
const int VFX_PER_50M_INVIS                     = 199;


//:://////////////////////////////////////////////
//:: Disease Const
//:://////////////////////////////////////////////

const int DISEASE_CONTAGION_BLINDING_SICKNESS   = 20;
const int DISEASE_CONTAGION_CACKLE_FEVER        = 21;
const int DISEASE_CONTAGION_FILTH_FEVER         = 22;
const int DISEASE_CONTAGION_MINDFIRE            = 23;
const int DISEASE_CONTAGION_RED_ACHE            = 24;
const int DISEASE_CONTAGION_SHAKES              = 25;
const int DISEASE_CONTAGION_SLIMY_DOOM          = 26;
const int DISEASE_PESTILENCE                    = 51;


//:://////////////////////////////////////////////
//:: Poison Const
//:://////////////////////////////////////////////

const int POISON_TINY_CENTIPEDE_POISON          = 122;
const int POISON_MEDIUM_CENTIPEDE_POISON        = 123;
const int POISON_LARGE_CENTIPEDE_POISON         = 124;
const int POISON_HUGE_CENTIPEDE_POISON          = 125;
const int POISON_GARGANTUAN_CENTIPEDE_POISON    = 126;
const int POISON_COLOSSAL_CENTIPEDE_POISON      = 127;

const int POISON_TINY_SCORPION_VENOM            = 128;
const int POISON_SMALL_SCORPION_VENOM           = 129;
const int POISON_MEDIUM_SCORPION_VENOM          = 130;
const int POISON_HUGE_SCORPION_VENOM            = 131;
const int POISON_GARGANTUAN_SCORPION_VENOM      = 132;
const int POISON_COLOSSAL_SCOPRION_VENOM        = 133;

const int POISON_EYEBLAST                       = 134;
const int POISON_BALOR_BILE                     = 135;
const int POISON_VILESTAR                       = 136;
const int POISON_SASSON_JUICE                   = 137;

const int POISON_SUFFERFUME                     = 138;
const int POISON_URTHANYK                       = 139;
const int POISON_MIST_OF_NOURN                  = 140;
const int POISON_ISHENTAV                       = 141;
const int POISON_BURNING_ANGEL_WING_FUMES       = 142;

const int POISON_RAVAGE_GOLDEN_ICE              = 100;
const int POISON_RAVAGE_CELESTIAL_LIGHTSBLOOD   = 143;
const int POISON_RAVAGE_JADE_WATER              = 144;
const int POISON_RAVAGE_PURIFIED_COUATL_VENOM   = 145;
const int POISON_RAVAGE_UNICORN_BLOOD           = 146;

const int VFX_PER_AVASMASS                      = 141;

//:://////////////////////////////////////////////
//:: Skill Const
//:://////////////////////////////////////////////

//const int SKILL_IAIJUTSU_FOCUS  = 27;
//const int SKILL_JUMP            = 28;


//:://////////////////////////////////////////////
//:: Size Const
//:://////////////////////////////////////////////

const int CREATURE_SIZE_FINE            = -1;
/**
 * Yes, this is the same as CREATURE_SIZE_INVALID, live with it.
 * If it weren't, the constants wouldn't be straight series any longer.
 */
const int CREATURE_SIZE_DIMINUTIVE      =  0;
const int CREATURE_SIZE_GARGANTUAN      =  6;
const int CREATURE_SIZE_COLOSSAL        =  7;


//:://////////////////////////////////////////////
//:: Saving Throw Const
//:://////////////////////////////////////////////

//const int SAVING_THROW_NONE = 4;


//:://////////////////////////////////////////////
//:: Psionic Discipline Const
//:://////////////////////////////////////////////

// Psionic Disciplines
const int DISCIPLINE_NONE             = 0;
const int DISCIPLINE_PSYCHOMETABOLISM = 1;
const int DISCIPLINE_PSYCHOKINESIS    = 2;
const int DISCIPLINE_PSYCHOPORTATION  = 3;
const int DISCIPLINE_CLAIRSENTIENCE   = 4;
const int DISCIPLINE_METACREATIVITY   = 5;
const int DISCIPLINE_TELEPATHY        = 6;


//:://////////////////////////////////////////////
//:: Polymorph Const
//:://////////////////////////////////////////////

const int POLYMORPH_TYPE_WOLF_0                    = 133;
const int POLYMORPH_TYPE_WOLF_1                    = 134;
const int POLYMORPH_TYPE_WOLF_2                    = 135;
const int POLYMORPH_TYPE_WEREWOLF_0                = 136;
const int POLYMORPH_TYPE_WEREWOLF_1                = 137;
const int POLYMORPH_TYPE_WEREWOLF_2                = 138;

const int POLYMORPH_TYPE_WOLF_0s                   = 139;
const int POLYMORPH_TYPE_WOLF_1s                   = 140;
const int POLYMORPH_TYPE_WOLF_2s                   = 141;
const int POLYMORPH_TYPE_WEREWOLF_0s               = 142;
const int POLYMORPH_TYPE_WEREWOLF_1s               = 143;
const int POLYMORPH_TYPE_WEREWOLF_2s               = 144;

const int POLYMORPH_TYPE_WOLF_0l                   = 145;
const int POLYMORPH_TYPE_WOLF_1l                   = 146;
const int POLYMORPH_TYPE_WOLF_2l                   = 147;
const int POLYMORPH_TYPE_WEREWOLF_0l               = 148;
const int POLYMORPH_TYPE_WEREWOLF_1l               = 149;
const int POLYMORPH_TYPE_WEREWOLF_2l               = 150;
