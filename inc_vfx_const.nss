//::///////////////////////////////////////////////
//:: Visual Effect constant include
//:: inc_vfx_const
//::///////////////////////////////////////////////
/*
    Constants for vfx present in visualeffects.2da that
    do not have a constant defined by bioware.
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////


//////////////////////////////////////////////////
/* Unenumerated BW VFX                          */
//////////////////////////////////////////////////

const int VFX_COM_BLOOD_REG_WIMPY       = 296;
const int VFX_COM_BLOOD_LRG_WIMPY       = 297;
const int VFX_COM_BLOOD_CRT_WIMPY       = 298;
const int VFX_COM_BLOOD_REG_WIMPG       = 299;
const int VFX_COM_BLOOD_LRG_WIMPG       = 300;
const int VFX_COM_BLOOD_CRT_WIMPG       = 301;
const int VFX_COM_BLOOD_CRT_RED_HEAD    = 491;
const int VFX_COM_BLOOD_CRT_GREEN_HEAD  = 492;
const int VFX_COM_BLOOD_CRT_YELLOW_HEAD = 493;

const int VFX_IMP_LEAF                  = 132;
const int VFX_IMP_CLOUD                 = 133;
const int VFX_IMP_WIND                  = 134;
const int VFX_IMP_ROCKEXPLODE           = 135;
const int VFX_IMP_ROCKEXPLODE2          = 136;
const int VFX_IMP_ROCKSUP               = 137;
const int VFX_IMP_DESTRUCTION_LOW       = 302;
const int VFX_IMP_PULSE_BOMB            = 469;
const int VFX_IMP_SILENCE_NO_SOUND      = 470;

const int VFX_BEAM_FLAME                = 444;
const int VFX_BEAM_DISINTEGRATE         = 447;

const int VFX_DUR_GHOSTLY_PULSE_QUICK   = 295;
const int VFX_DUR_PROT_ACIDSHIELD       = 448;
const int VFX_DUR_BARD_SONG_SILENT      = 468;
const int VFX_DUR_CONECOLD_HEAD         = 490;
const int VFX_DUR_BARD_SONG_EVIL        = 507;

const int VFX_FNF_SPELL_FAIL_HEA        = 292;
const int VFX_FNF_SPELL_FAIL_HAND       = 293;
const int VFX_FNF_HIGHLIGHT_FLASH_WHITE = 294;
const int VFX_FNF_SCREEN_SHAKE2         = 356;
const int VFX_FNF_HELLBALL              = 464;
const int VFX_FNF_TELEPORT_IN           = 471;
const int VFX_FNF_TELEPORT_OUT          = 472;
const int VFX_FNF_DRAGBREATHGROUND      = 494;

const int VFX_CONJ_MIND                 = 466;
const int VFX_CONJ_FIRE                 = 467;


const int SCENE_WEIRD               = 323;
const int SCENE_EVARD               = 346;
const int SCENE_TOWER               = 347;
const int SCENE_TEMPLE              = 348;
const int SCENE_LAVA                = 349;
const int SCENE_LAVA2               = 350;
const int SCENE_WATER               = 401;
const int SCENE_GRASS               = 402;
const int SCENE_FORMIAN1            = 404;
const int SCENE_FORMIAN2            = 405;
const int SCENE_PITTRAP             = 406;
const int SCENE_ICE                 = 426;
const int SCENE_MFPillar            = 427;
const int SCENE_MFWaterfall         = 428;
const int SCENE_MFGroundCover       = 429;
const int SCENE_MFGroundCover2      = 430;
const int SCENE_MF6                 = 431;
const int SCENE_MF7                 = 432;
const int SCENE_MF8                 = 433;
const int SCENE_MF9                 = 434;
const int SCENE_MF10                = 435;
const int SCENE_MF11                = 436;
const int SCENE_MF12                = 437;
const int SCENE_MF13                = 438;
const int SCENE_MF14                = 439;
const int SCENE_MF15                = 440;
const int SCENE_MF16                = 441;
const int SCENE_ICE_CLEAR           = 442;
const int SCENE_EVIL_CASTLE_WALL    = 443;
const int SCENE_BUILDING            = 449;
const int SCENE_BURNED_RUBBLE       = 450;
const int SCENE_BURNING_HALF_HOUSE  = 451;
const int SCENE_RUINED_ARCH         = 452;
const int SCENE_SOLID_ARCH          = 453;
const int SCENE_BURNED_RUBBLE_2     = 454;
const int SCENE_MARKET_1            = 455;
const int SCENE_MARKET_2            = 456;
const int SCENE_GAZEBO              = 457;
const int SCENE_WAGON               = 458;
const int SCENE_SEWER_WATER         = 461;
const int SCENE_BLACK_TILE          = 506;
const int SCENE_PRISON_FLOOR        = 511;

const int WELL                      = 358;

const int NORMAL_ARROW              = 357;
const int NORMAL_DART               = 359;




//////////////////////////////////////////////////
/* shadguy's spell VFX (visual effects) library */
//////////////////////////////////////////////////


// retextured magic missle effects
//
// Note: in game, these are a bit flakey; the engine tries to apply these as
//    an impact VFX right away, even before the MIRV itself lands on target.
//
// I also tried Mirv's with chunk models - using the black skull from the mind
// fear effect.  It looked even dumber manifesting at the target before impact.

const int VFX_IMP_MIRV_SILENT           = 1000;
const int VFX_IMP_MIRV_DN_YELLOW        = 1001;
const int VFX_IMP_MIRV_DN_RED           = 1002;
const int VFX_IMP_MIRV_DN_GREEN         = 1003;
const int VFX_IMP_MIRV_DN_VIOLET        = 1004;
const int VFX_IMP_MIRV_DN_CYAN          = 1005;
const int VFX_IMP_MIRV_DN_PURPLE        = 1006;
const int VFX_IMP_MIRV_DN_MAGENTA       = 1007;
const int VFX_IMP_MIRV_DN_LAWNGREEN     = 1008;
const int VFX_IMP_MIRV_DN_ORANGE        = 1009;
const int VFX_IMP_MIRV_DN_SPRINGGREEN   = 1010;
const int VFX_IMP_MIRV_DN_STEELBLUE     = 1011;
const int VFX_IMP_MIRV_DN_ECTO          = 1012;
const int VFX_IMP_MIRV_DN_SOUNDFX       = 1013;


// recolored AID VFX:
const int VFX_IMP_HOLY_AID_DN_SILENT       = 1017;
const int VFX_IMP_HOLY_AID_DN_GREEN        = 1018;
const int VFX_IMP_HOLY_AID_DN_CYAN         = 1019;
const int VFX_IMP_HOLY_AID_DN_ORANGE       = 1020;
const int VFX_IMP_HOLY_AID_DN_RED          = 1021;
const int VFX_IMP_HOLY_AID_DN_BLUE         = 1022;
const int VFX_IMP_HOLY_AID_DN_PURPLE       = 1023;
const int VFX_IMP_HOLY_AID_DN_SOUNDFX      = 1024;


//recolored Word of Faith VFX, slightly bastardized; nwmax wouldn't import the higres version, so these are all based on teh low res version
const int VFX_FNF_WORD_DN_SILENT           = 1028;
const int VFX_FNF_WORD_DN_GREEN            = 1029;
const int VFX_FNF_WORD_DN_CYAN             = 1030;
const int VFX_FNF_WORD_DN_BLUE             = 1031;
const int VFX_FNF_WORD_DN_PURPLE           = 1032;
const int VFX_FNF_WORD_DN_RED              = 1033;
const int VFX_FNF_WORD_DN_ORANGE           = 1034;
const int VFX_FNF_WORD_DN_SOUNDFX          = 1035;


//attempted recolor of Power Word Stun that turned out screwy but useable;
//I'll recommend using them in combo with silent version of stuff like timestop below
const int VFX_FNF_PW_DN_YG              = 1039;
const int VFX_FNF_PW_DN_GB              = 1040;
const int VFX_FNF_PW_DN_BP              = 1041;
const int VFX_FNF_PW_DN_PR              = 1042;
const int VFX_FNF_PW_DN_RY              = 1043;
const int VFX_FNF_PW_DN_STUN_SOUNDFX    = 1044;
const int VFX_FNF_PW_DN_KILL_SOUNDFX    = 1045;


// recolored time stop VFX
const int VFX_IMP_TIME_STOP_DN_SOUNDFX          = 1049;
const int VFX_IMP_TIME_STOP_DN_RED              = 1050;
const int VFX_IMP_TIME_STOP_DN_ORANGE           = 1051;
const int VFX_IMP_TIME_STOP_DN_YELLOW           = 1052;
const int VFX_IMP_TIME_STOP_DN_GREEN            = 1053;
const int VFX_IMP_TIME_STOP_DN_BLUE             = 1054;
const int VFX_IMP_TIME_STOP_DN_PURPLE           = 1055;
const int VFX_IMP_TIME_STOP_DN_SILENT           = 1056;


// recolored blindness and deafness
const int VFX_IMP_BLINDDEAD_DN_RED          = 1060;
const int VFX_IMP_BLINDDEAD_DN_YELLOW       = 1061;
const int VFX_IMP_BLINDDEAD_DN_GREEN        = 1062;
const int VFX_IMP_BLINDDEAD_DN_CYAN         = 1063;
const int VFX_IMP_BLINDDEAD_DN_BLUE         = 1064;
const int VFX_IMP_BLINDDEAD_DN_PURPLE       = 1065;
const int VFX_IMP_BLINDDEAD_DN_SOUNDFX      = 1066;


// recolored magic eye VFX
const int VFX_MAGICAL_VISION_DN_GREEN       = 1070;
const int VFX_MAGICAL_VISION_DN_RED         = 1071;
const int VFX_MAGICAL_VISION_DN_SOUNDFX     = 1075;


// recolored healing_s
const int VFX_IMP_HEALING_S_VIO                  = 1079;
const int VFX_IMP_HEALING_S_MAG                  = 1080;
const int VFX_IMP_HEALING_S_ORA                  = 1081;
const int VFX_IMP_HEALING_S_LAW                  = 1082;
const int VFX_IMP_HEALING_S_SPR                  = 1083;
const int VFX_IMP_HEALING_S_SILENT               = 1094;
const int VFX_IMP_HEALING_S_RED                  = 1085;
const int VFX_IMP_HEALING_S_SOUNDFX              = 1086;
const int VFX_IMP_HEALING_HARM_SOUNDFX           = 1087;


// recolored healing_m
const int VFX_IMP_HEALING_M_PUR                  = 1091;
const int VFX_IMP_HEALING_M_MAG                  = 1092;
const int VFX_IMP_HEALING_M_YEL                  = 1093;
const int VFX_IMP_HEALING_M_CYA                  = 1094;
const int VFX_IMP_HEALING_M_SILENT               = 1095;
const int VFX_IMP_HEALING_M_RED                  = 1096;
const int VFX_IMP_HEALING_M_SOUNDFX              = 1097;


// recolored healing_l
const int VFX_IMP_HEALING_L_MAG                  = 1101;
const int VFX_IMP_HEALING_L_ORA                  = 1102;
const int VFX_IMP_HEALING_L_LAW                  = 1103;
const int VFX_IMP_HEALING_L_SPR                  = 1104;
const int VFX_IMP_HEALING_L_VIO                  = 1105;
const int VFX_IMP_HEALING_L_RED                  = 1106;
const int VFX_IMP_HEALING_L_SILENT               = 1107;
const int VFX_IMP_HEALING_L_SOUNDFX              = 1108;


// recolored healing_G
const int VFX_IMP_HEALING_G_MAG                  = 1112;
const int VFX_IMP_HEALING_G_LAW                  = 1113;
const int VFX_IMP_HEALING_G_SPR                  = 1114;
const int VFX_IMP_HEALING_G_VIO                  = 1115;
const int VFX_IMP_HEALING_G_RED                  = 1116;
const int VFX_IMP_HEALING_G_SILENT               = 1117;
const int VFX_IMP_HEALING_G_SOUNDFX              = 1118;


// recolored healing_X
const int VFX_IMP_HEALING_X_MAG                  = 1122;
const int VFX_IMP_HEALING_X_ORA                  = 1123;
const int VFX_IMP_HEALING_X_LAW                  = 1124;
const int VFX_IMP_HEALING_X_SPR                  = 1125;
const int VFX_IMP_HEALING_X_VIO                  = 1126;
const int VFX_IMP_HEALING_X_SILENT               = 1127;
const int VFX_IMP_HEALING_X_SOUNDFX              = 1128;


// recolored magic impact VFX - these are for use with the recolorded MIRV (magic missile) FX
const int VFX_IMP_MAGCYA                         = 1132;
const int VFX_IMP_MAGBLU                         = 1133;
const int VFX_IMP_MAGVIO                         = 1134;
const int VFX_IMP_MAGPUR                         = 1135;
const int VFX_IMP_MAGRED                         = 1136;
const int VFX_IMP_MAGMAG                         = 1137;
const int VFX_IMP_MAGORA                         = 1138;
const int VFX_IMP_MAGYEL                         = 1139;
const int VFX_IMP_MAGLAW                         = 1140;
const int VFX_IMP_MAGGRN                         = 1141;
const int VFX_IMP_MAG_SOUNDFX                    = 1142;


// tornadoheal VFX recolored
const int VFX_IMP_TORNADO_L_SILENT               = 1146;
const int VFX_IMP_TORNADO_L_MAG                  = 1147;
const int VFX_IMP_TORNADO_L_ORA                  = 1148;
const int VFX_IMP_TORNADO_L_LAW                  = 1149;
const int VFX_IMP_TORNADO_L_SPR                  = 1150;
const int VFX_IMP_TORNADO_L_VIO                  = 1151;
const int VFX_IMP_TORNADO_L_RED                  = 1152;
const int VFX_IMP_TORNADO_L_SOUNDFX              = 1153;


// recolored flame_M effects
const int VFX_IMP_FLAME_M_SILENT                 = 1157;
const int VFX_IMP_FLAME_M_CYAN                   = 1158;
const int VFX_IMP_FLAME_M_GREEN                  = 1159;
const int VFX_IMP_FLAME_M_MAGENTA                = 1160;
const int VFX_IMP_FLAME_M_PURPLE                 = 1161;
const int VFX_IMP_FLAME_M_SOUNDFX                = 1162;


// recolored spell mantle ground VFX.  I tried the impact VFX to and didn't get them working yet.
const int VFX_DUR_SPELLTURNING_SILENT            = 1166;
const int VFX_DUR_SPELLTURNING_P                 = 1167;
const int VFX_DUR_SPELLTURNING_R                 = 1168;
const int VFX_DUR_SPELLTURNING_Y                 = 1169;
const int VFX_DUR_SPELLTURNING_G                 = 1170;
const int VFX_DUR_SPELLTURNING_C                 = 1171;
const int VFX_DUR_SPELLTURNING_O                 = 1172;
const int VFX_DUR_SPELLTURNING_V                 = 1173;
const int VFX_DUR_SPELLTURNING_S                 = 1174;
const int VFX_DUR_SPELLTURNING_M                 = 1175;
const int VFX_DUR_SPELLTURNING_SOUNDFX           = 1176;


// recolored Magic resistence VFX rings
const int VFX_DUR_MAGIC_RESISTANCE_SILENT        = 1180;
const int VFX_DUR_MAGIC_RESISTANCE_G             = 1181;
const int VFX_DUR_MAGIC_RESISTANCE_B             = 1182;
const int VFX_DUR_MAGIC_RESISTANCE_P             = 1183;
const int VFX_DUR_MAGIC_RESISTANCE_O             = 1184;
const int VFX_DUR_MAGIC_RESISTANCE_Y             = 1185;
const int VFX_DUR_MAGIC_RESISTANCE_SOUNDFX       = 1186;


// recolored IMP Magic VFX (the impact for "Spell Resistence")
const int VFX_IMP_MAGIC_PROTECTION_SILENT        = 1190;
const int VFX_IMP_MAGIC_PROTECTION_G             = 1191;
const int VFX_IMP_MAGIC_PROTECTION_B             = 1192;
const int VFX_IMP_MAGIC_PROTECTION_P             = 1193;
const int VFX_IMP_MAGIC_PROTECTION_O             = 1194;
const int VFX_IMP_MAGIC_PROTECTION_Y             = 1195;
const int VFX_IMP_MAGIC_PROTECTION_SOUND         = 1196;


// recolored holy strike VFX
const int VFX_FNF_STRIKE_HOLY_SILENT             = 1200;
const int VFX_FNF_STRIKE_HOLY_G                  = 1201;
const int VFX_FNF_STRIKE_HOLY_C                  = 1202;
const int VFX_FNF_STRIKE_HOLY_B                  = 1203;
const int VFX_FNF_STRIKE_HOLY_P                  = 1204;
const int VFX_FNF_STRIKE_HOLY_R                  = 1205;
const int VFX_FNF_STRIKE_HOLY_O                  = 1206;
const int VFX_FNF_STRIKE_HOLY_SOUNDFX            = 1207;


// recolored ability score buff VFX
const int VFX_IMP_IMPROVE_ABILITY_SCORE_SILENT   = 1211;
const int VFX_IMP_IMPROVE_ABILITY_SCORE_A        = 1212;
const int VFX_IMP_IMPROVE_ABILITY_SCORE_B        = 1213;
const int VFX_IMP_IMPROVE_ABILITY_SCORE_C        = 1214;
const int VFX_IMP_IMPROVE_ABILITY_SCORE_D        = 1215;
const int VFX_IMP_IMPROVE_ABILITY_SCORE_E        = 1216;
const int VFX_IMP_IMPROVE_ABILITY_SCORE_SOUNDFX  = 1217;


// recolroed "reduce ability score" vfx, with the darkness FX removed
const int VFX_IMP_REDUCE_ABILITY_SCORE_RED       = 1221;
const int VFX_IMP_REDUCE_ABILITY_SCORE_YEL       = 1222;
const int VFX_IMP_REDUCE_ABILITY_SCORE_ORA       = 1223;
const int VFX_IMP_REDUCE_ABILITY_SCORE_GRN       = 1224;
const int VFX_IMP_REDUCE_ABILITY_SCORE_CYA       = 1225;
const int VFX_IMP_REDUCE_ABILITY_SCORE_BLU       = 1226;
const int VFX_IMP_REDUCE_ABILITY_SCORE_PUR       = 1227;
const int VFX_IMP_REDUCE_ABILITY_SCORE_SOUNDFX   = 1228;

//Baelnorn eyes by Tenjac
const int VFX_BAELN_EYES            = 808;


//Supamans Custom VFX for psionics & epic spells
const int VFX_IMP_EPIC_GEM_EMERALD      = 809;
const int VFX_IMP_EPIC_GEM_SAPPHIRE     = 810;
const int VFX_IMP_EPIC_GEM_DIAMOND      = 811;
const int VFX_PRC_FNF_EARTHQUAKE        = 812;
const int PSI_IMP_ULTRABLAST            = 813;
const int PSI_DUR_TIMELESS_BODY         = 814;
const int PSI_DUR_TEMPORAL_ACCELERATION = 815;
const int PSI_DUR_SHADOW_BODY           = 816;
const int PSI_FNF_PSYCHIC_CRUSH         = 817;
const int EPIC_DUR_FLEETNESS_OF_FOOT    = 818;
const int PSI_DUR_ENERGY_ADAPTATION_ALL = 819;
//Spellfire
const int VFX_FNF_SPELLF_EXP   =  820;
const int VFX_IMP_SPELLF_FLAME =  821;
const int VFX_IMP_SPELLF_HEAL  =  822;
const int VFX_BEAM_SPELLFIRE   =  823;
