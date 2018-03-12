/*:://////////////////////////////////////////////
//:: Name Spell Visual effect Constants
//:: FileName phs_inc_visuals
//:://////////////////////////////////////////////
    This is the visuals missing from Bioware's constants list, and new ones,
    from visualeffects.2da file.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

// First, missing bioware ones (not sure they work, but they will be here)
// which may have been updated and forgotten or never added to the constants
// list.
const int PHS_VFX_IMP_LEAF                  = 132;
const int PHS_VFX_IMP_CLOUD                 = 133;
const int PHS_VFX_IMP_WIND                  = 134;
const int PHS_VFX_IMP_ROCKEXPLODE           = 135;
const int PHS_VFX_IMP_ROCKEXPLODE2          = 136;
const int PHS_VFX_IMP_ROCKSUP               = 137;

const int PHS_VFX_FNF_SPELL_FAIL_HEAD       = 292;
const int PHS_VFX_FNF_SPELL_FAIL_HAND       = 293;
const int PHS_VFX_FNF_HIGHLIGHT_FLASH_WHITE = 294;
const int PHS_VFX_DUR_GHOSTLY_PULSE_QUICK   = 295;
const int PHS_VFX_COM_BLOOD_REG_WIMPY       = 296;
const int PHS_VFX_COM_BLOOD_LRG_WIMPY       = 297;
const int PHS_VFX_COM_BLOOD_CRT_WIMPY       = 298;
const int PHS_VFX_COM_BLOOD_REG_WIMPG       = 299;
const int PHS_VFX_COM_BLOOD_LRG_WIMPG       = 300;
const int PHS_VFX_COM_BLOOD_CRT_WIMPG       = 301;
const int PHS_VFX_IMP_DESTRUCTION_LOW       = 302;

const int PHS_SCENE_WEIRD                   = 323;

const int PHS_SCENE_TOWER                   = 347;
const int PHS_SCENE_TEMPLE                  = 348;
const int PHS_SCENE_LAVA                    = 349;
const int PHS_SCENE_LAVA_2                  = 350; // Note: this and 349 are both SCENE_LAVA in the 2da.

const int PHS_VFX_FNF_SCREEN_SHAKE2         = 356;
const int PHS_NORMAL_ARROW                  = 357;
const int PHS_WELL                          = 358;
const int PHS_NORMAL_DART                   = 359;

const int PHS_SCENE_WATER                   = 401;
const int PHS_SCENE_GRASS                   = 402;

const int PHS_SCENE_FORMIAN1                = 404;
const int PHS_SCENE_FORMIAN2                = 405;
const int PHS_SCENE_PITTRAP                 = 406;

const int PHS_SCENE_ICE                     = 426;
const int PHS_SCENE_MFPillar                = 427;
const int PHS_SCENE_MFWaterfall             = 428;
const int PHS_SCENE_MFGroundCover           = 429;
const int PHS_SCENE_MFGroundCover_2         = 430;// This was the same name as 429. Made _2.
const int PHS_SCENE_MF6                     = 431;
const int PHS_SCENE_MF7                     = 432;
const int PHS_SCENE_MF8                     = 433;
const int PHS_SCENE_MF9                     = 434;
const int PHS_SCENE_MF10                    = 435;
const int PHS_SCENE_MF11                    = 436;
const int PHS_SCENE_MF12                    = 437;
const int PHS_SCENE_MF13                    = 438;
const int PHS_SCENE_MF14                    = 438;
const int PHS_SCENE_MF15                    = 440;
const int PHS_SCENE_MF16                    = 441;
const int PHS_SCENE_ICE_CLEAR               = 442;
const int PHS_SCENE_EVIL_CASTLE_WALL        = 443;
const int PHS_VFX_BEAM_FLAME                = 444;

const int PHS_VFX_BEAM_DISINTEGRATE         = 447;
const int PHS_VFX_DUR_PROT_ACIDSHIELD       = 448;
const int PHS_SCENE_BUILDING                = 449;
const int PHS_SCENE_BURNED_RUBBLE           = 450;
const int PHS_SCENE_BURNING_HALF_HOUSE      = 451;
const int PHS_SCENE_RUINED_ARCH             = 452;
const int PHS_SCENE_SOLID_ARCH              = 453;
const int PHS_SCENE_BURNED_RUBBLE_2         = 454;
const int PHS_SCENE_MARKET_1                = 455;
const int PHS_SCENE_MARKET_2                = 456;
const int PHS_SCENE_GAZEBO                  = 457;
const int PHS_SCENE_WAGON                   = 458;
// These were mixed up - SCENE_SEWER_WATER was referenced under VFX_IMP_PULSE_HOLY_SILENT :-P
const int PHS_SCENE_SEWER_WATER             = 461;
const int PHS_VFX_IMP_PULSE_HOLY_SILENT     = 462;

const int PHS_VFX_FNF_HELLBALL              = 464;

const int PHS_VFX_CONJ_MIND                 = 466;
const int PHS_VFX_CONJ_FIRE                 = 467;
const int PHS_VFX_DUR_BARD_SONG_SILENT      = 468;
const int PHS_VFX_IMP_PULSE_BOMB            = 469;
const int PHS_VFX_IMP_SILENCE_NO_SOUND      = 470;
const int PHS_VFX_FNF_TELEPORT_IN           = 471;
const int PHS_VFX_FNF_TELEPORT_OUT          = 472;

const int PHS_VFX_DUR_CONECOLD_HEAD         = 490;
const int PHS_VFX_COM_BLOOD_CRT_RED_HEAD    = 491;
const int PHS_VFX_COM_BLOOD_CRT_GREEN_HEAD  = 492;
const int PHS_VFX_COM_BLOOD_CRT_YELLOW_HEAD = 493;
const int PHS_VFX_FNF_DRAGBREATHGROUND      = 494;

const int PHS_SCENE_BLACK_TILE              = 506;
const int PHS_VFX_DUR_BARD_SONG_EVIL        = 507;
const int PHS_VFX_DUR_UNSUPPORTED_CAGE      = 508;
const int PHS_VFX_DUR_UNSUPPORTED_ANIMAL_CAGE = 509;
const int PHS_VFX_DUR_UNSUPPORTED_FLAME_L   = 510;


// Visual effect constants

// NEW ONES
const int PHS_VFX_FNF_AWAKEN                = 761;
const int PHS_VFX_FNF_CHAOS_HAMMER          = 762;
const int PHS_VFX_IMP_DIMENSION_DOOR_DISS   = 777;
const int PHS_VFX_IMP_DIMENSION_DOOR_APPR   = 776;
const int PHS_VFX_IMP_DISINTEGRATION        = 780;
const int PHS_VFX_FNF_FREEZING_SPHERE       = 763;
const int PHS_VFX_FNF_GLITTERDUST           = 783;
const int PHS_VFX_FNF_IMPRISONMENT          = 785;
const int PHS_VFX_IMP_INSANITY              = 784;
const int PHS_VFX_FNF_MAZE                  = 764;
const int PHS_VFX_FNF_PWBLIND               = 752;
const int PHS_VFX_DUR_PROTECTION_ARROWS     = 768;
const int PHS_VFX_DUR_PROTECTION_ENERGY     = 786;
const int PHS_VFX_IMP_SHOCKING_GRASP        = 760;

// Not used
const int PHS_VFX_DUR_ELEMENTAL_SHIELD_WARM = 147;// Default VFX_DUR_ELEMENTAL_SHIELD
const int PHS_VFX_DUR_ELEMENTAL_SHIELD_COOL = 147;// New one

const int PHS_VFX_DUR_PROTECTION_FROM_SPELLS= 422;// VFX_DUR_GLOW_WHITE

