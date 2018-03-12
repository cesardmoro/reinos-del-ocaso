//:://////////////////////////////////////////////
//:: FileName: "inc_epicspells"
/*   Purpose: This is the #include file that contains all constants and
        functions needed for the Epic Spellcasting System.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank (Don Armstrong)
//:: Last Updated On: March 18, 2004
//:://////////////////////////////////////////////

#include "prc_inc_spells"
#include "prc_class_const"

/*
CONSTANTS FOR OPTIONAL FEATURES
*/
// Use the "XP Costs" option, making casters expend some experience when they
//      cast certain spells?
const int XP_COSTS = TRUE;

// Use the "Take 10" variant rule?
// If TRUE, all Spellcraft checks will be automatically equal to the caster's
//      Spellcraft skill level, plus 10. The outcome is never a surprise.
// If FALSE, every Spellcraft check is a roll of the dice, being equal to the
//      caster's Spellcraft skill level, plus 1d20. Risky, but more fun!
const int TAKE_TEN_RULE = FALSE;

// Use the "Primary Ability Modifier Bonus to Skills" variant rule?
// If TRUE, caster's use their primary ability (WISDOM for clerics and druids,
//      CHARISMA for sorcerers) instead of intelligence as a modifier on their
//      Spellcraft checks for casting and researching epic spells, as well as
//      their total Lore skill level for determining spell slots per day.
const int PRIMARY_ABILITY_MODIFIER_RULE = FALSE;

// Enable BACKLASH damage on spells? TRUE for yes, FALSE for no.
const int BACKLASH_DAMAGE = TRUE;

// Sets the DC adjustment active or inactive for researching spells.
// If TRUE, the player's spell foci feats are used to lower the spell's DC which
//      lowers the overall costs of researching the spell. For example, if the
//      spell is from the school of Necromancy, and the player has the feat Epic
//      Spell Focus: Necromancy, then the DC for the rearch would be lowered by
//      six. This would (under default ELHB settings) lower the gold cost by
//      54000 gold and 2160 exp. points, as well as makee the spell accessible
//      to the player earlier and with a greater chance of success (due to the
//      Spellcraft check).
// Setting this to FALSE will disable this feature.
const int FOCI_ADJUST_DC = TRUE;

// This sets the multiplier for the cost, in gold, to a player for the
//      researching of an epic spell. The number is multiplied by the DC of
//      the spell to be researched. ELHB default is 9000.
const int GOLD_MULTIPLIER = 9000;

// This sets the number to divide the gold cost by to determine the cost,
//      in experience, to research an epic spell. The formula is as follows:
//      XP Cost = Spell's DC x GOLD_MULTIPLIER / XP_FRACTION. The default from
//      the ELHB is 25.
const int XP_FRACTION = 25;

// Set the number you want to divide the gold cost by for research failures.
// Examples: 2 would result in half the loss of the researcher's gold.
//           3 would result in a third of the gold lost.
//           4 would result in a quarter, etc.
const int FAILURE_FRACTION_GOLD = 2;

// Sets the percentage chance that a seed book is destroyed on a use of it.
// 0 = the book is never randomly destroyed from reading (using) it.
// 100 = the book is always destroyed from reading it.
// NOTE! This function is only ever called when the player actually acquires
//      the seed feat. It is a way to control mass "gift-giving" amongst players
const int BOOK_DESTRUCTION = 50;

// Play cutscenes for learning Epic Spell Seeds and researching Epic Spells?
const int PLAY_RESEARCH_CUTS = FALSE;
const int PLAY_SPELLSEED_CUT = FALSE;
// What school of magic does each spell belong to? (for research cutscenes)
// A = Abjuration
// C = Conjuration
// D = Divination
// E = Enchantment
// V = Evocation
// I = Illusion
// N = Necromancy
// T = Transmutation
// Between the quotation marks, enter the name of the cutscene script.
const string SCHOOL_A       = "";
const string SCHOOL_C       = "";
const string SCHOOL_D       = "";
const string SCHOOL_E       = "";
const string SCHOOL_V       = "";
const string SCHOOL_I       = "";
const string SCHOOL_N       = "";
const string SCHOOL_T       = "";
const string SPELLSEEDS_CUT = "";

///////////////////////////////////////////////////////////////////////////////
/*
CONSTANTS FOR THE SEEDS
*/
///////////////////////////////////////////////////////////////////////////////
// const int SEEDNAME_DC is the base DC for learning an Epic Spell Seed
// const int SEEDNAME_FE is for the line number in the feat.2da file
// const int SEEDNAME_IP is the line number of the seed in iprp_feats.2da.
// const int SEEDNAME_XX is for allowing levels of access to the seed...
//          Use the following numbers for SEEDNAME_XX for different options:
//          0 <---- Zero allows NO ONE to learn the seed.
//          1 <---- One allows only clerics to learn the seed.
//          2 <---- Two allows only druids to learn the seed.
//          4 <---- Four allows only sorcerers to learn the seed.
//          8 <---- Eight allows only wizards to learn the seed.
//         ?? <---- Add the previous four numbers together to have combinations
//                      of classes able to learn the seed. (15 for ALL)
///////////////////////////////////////////////////////////////////////////////
const int AFFLICT_DC    = 14;
const int AFFLICT_FE    = 5000;
const int AFFLICT_IP    = 400;
const int AFFLICT_XX    = 15;
const int ANIMATE_DC    = 25;
const int ANIMATE_FE    = 5001;
const int ANIMATE_IP    = 401;
const int ANIMATE_XX    = 15;
const int ANIDEAD_DC    = 23;
const int ANIDEAD_FE    = 5002;
const int ANIDEAD_IP    = 402;
const int ANIDEAD_XX    = 15;
const int ARMOR_DC      = 14;
const int ARMOR_FE      = 5003;
const int ARMOR_IP      = 403;
const int ARMOR_XX      = 15;
const int BANISH_DC     = 27;
const int BANISH_FE     = 5004;
const int BANISH_IP     = 404;
const int BANISH_XX     = 15;
const int COMPEL_DC     = 19;
const int COMPEL_FE     = 5005;
const int COMPEL_IP     = 405;
const int COMPEL_XX     = 15;
const int CONCEAL_DC    = 17;
const int CONCEAL_FE    = 5006;
const int CONCEAL_IP    = 406;
const int CONCEAL_XX    = 15;
const int CONJURE_DC    = 21;
const int CONJURE_FE    = 5007;
const int CONJURE_IP    = 407;
const int CONJURE_XX    = 15;
const int CONTACT_DC    = 23;
const int CONTACT_FE    = 5008;
const int CONTACT_IP    = 408;
const int CONTACT_XX    = 15;
const int DELUDE_DC     = 14;
const int DELUDE_FE     = 5009;
const int DELUDE_IP     = 409;
const int DELUDE_XX     = 15;
const int DESTROY_DC    = 29;
const int DESTROY_FE    = 5010;
const int DESTROY_IP    = 410;
const int DESTROY_XX    = 15;
const int DISPEL_DC     = 19;
const int DISPEL_FE     = 5011;
const int DISPEL_IP     = 411;
const int DISPEL_XX     = 15;
const int ENERGY_DC     = 19;
const int ENERGY_FE     = 5012;
const int ENERGY_IP     = 412;
const int ENERGY_XX     = 15;
const int FORESEE_DC    = 17;
const int FORESEE_FE    = 5013;
const int FORESEE_IP    = 413;
const int FORESEE_XX    = 15;
const int FORTIFY_DC    = 17;
const int FORTIFY_FE    = 5014;
const int FORTIFY_IP    = 414;
const int FORTIFY_XX    = 15;
const int HEAL_DC       = 25;
const int HEAL_FE       = 5015;
const int HEAL_IP       = 415;
const int HEAL_XX       = 15;
const int LIFE_DC       = 27;
const int LIFE_FE       = 5016;
const int LIFE_IP       = 416;
const int LIFE_XX       = 15;
const int LIGHT_DC      = 14;
const int LIGHT_FE      = 5017;
const int LIGHT_IP      = 417;
const int LIGHT_XX      = 15;
const int OPPOSIT_DC    = 14;
const int OPPOSIT_FE    = 5018;
const int OPPOSIT_IP    = 418;
const int OPPOSIT_XX    = 15;
const int REFLECT_DC    = 27;
const int REFLECT_FE    = 5019;
const int REFLECT_IP    = 419;
const int REFLECT_XX    = 15;
const int REVEAL_DC     = 19;
const int REVEAL_FE     = 5020;
const int REVEAL_IP     = 420;
const int REVEAL_XX     = 15;
const int SHADOW_DC     = 21;
const int SHADOW_FE     = 5021;
const int SHADOW_IP     = 421;
const int SHADOW_XX     = 15;
const int SLAY_DC       = 25;
const int SLAY_FE       = 5022;
const int SLAY_IP       = 422;
const int SLAY_XX       = 15;
const int SUMMON_DC     = 14;
const int SUMMON_FE     = 5023;
const int SUMMON_IP     = 423;
const int SUMMON_XX     = 15;
const int TIME_DC       = 19;
const int TIME_FE       = 5024;
const int TIME_IP       = 424;
const int TIME_XX       = 15;
const int TRANSFO_DC    = 21;
const int TRANSFO_FE    = 5025;
const int TRANSFO_IP    = 425;
const int TRANSFO_XX    = 15;
const int TRANSPO_DC    = 27;
const int TRANSPO_FE    = 5026;
const int TRANSPO_IP    = 426;
const int TRANSPO_XX    = 15;
const int WARD_DC       = 14;
const int WARD_FE       = 5027;
const int WARD_IP       = 427;
const int WARD_XX       = 15;

/*
CONSTANTS FOR EACH EPIC SPELL
*/
///////////////////////////////////////////////////////////////////////////////
// EXAMPLE EPIC SPELL: "BLAH"
// const int BLAH_DC is for the DC of the spell for casting and researching.
//      NOTE! Changing the DC will affect the costs of researching it as well!
// const int BLAH_IP is the line number of the CASTABLE feat in iprp_feats.2da.
// const int R_BLAH_IP is for the line number of the RESEARCHED feat in
//                                              iprp_feats.2da.
// const int BLAH_FE is the line number of the CASTABLE feat in feat.2da.
// const int R_BLAH_FE is the line number of the RESEARCHED feat in feat.2da.
// const int BLAH_XP is the experience point cost for CASTING the spell.
//
//      You can have up to four required feats to be able to learn the spell.
//      Use the desired SEED_FE constants,
//          or even a SPELL_FE constant if you want a
//          prerequisite to be another spell.
//      You should use the BLAH_R#'s up in order, leaving any unused ones as 0.
// const int BLAH_R1 is the first prerequisite to learn the spell.
// const int BLAH_R2 is the second prerequisite to learn the spell.
// const int BLAH_R3 is the third prerequisite to learn the spell.
// const int BLAH_R4 is the fourth prerequisite to learn the spell.
//
// const string BLAH_S is the school the spell belongs to.
//              A = Abjuration
//              C = Conjuration
//              D = Divination
//              E = Enchantment
//              V = Evocation
//              I = Illusion
//              N = Necromancy
//              T = Transmutation
///////////////////////////////////////////////////////////////////////////////

// EPIC SPELL: Achilles Heel
const int ACHHEEL_DC    = 54;
const int ACHHEEL_IP    = 429;
const int R_ACHHEEL_IP  = 500;
const int ACHHEEL_FE    = 5030;
const int R_ACHHEEL_FE  = 5031;
const int ACHHEEL_XP    = 0;
const int ACHHEEL_R1    = AFFLICT_FE; // Afflict seed
const int ACHHEEL_R2    = WARD_FE; // Ward seed
const int ACHHEEL_R3    = 0;
const int ACHHEEL_R4    = 0;
const string ACHHEEL_S  = "A";
///////////////////////////////////////////////////////////////////////////////
// EPIC SPELL: All Hope Lost
const int ALLHOPE_DC    = 29;
const int ALLHOPE_IP    = 430;
const int R_ALLHOPE_IP  = 501;
const int ALLHOPE_FE    = 5032;
const int R_ALLHOPE_FE  = 5033;
const int ALLHOPE_XP    = 0;
const int ALLHOPE_R1    = COMPEL_FE; // Compel seed
const int ALLHOPE_R2    = 0;
const int ALLHOPE_R3    = 0;
const int ALLHOPE_R4    = 0;
const string ALLHOPE_S  = "E";
///////////////////////////////////////////////////////////////////////////////
// EPIC SPELL: Allied Martyr
const int AL_MART_DC    = 47;
const int AL_MART_IP    = 431;
const int R_AL_MART_IP  = 502;
const int AL_MART_FE    = 5034;
const int R_AL_MART_FE  = 5035;
const int AL_MART_XP    = 0;
const int AL_MART_R1    = HEAL_FE; // Heal seed
const int AL_MART_R2    = FORESEE_FE; // Foresee seed
const int AL_MART_R3    = 0;
const int AL_MART_R4    = 0;
const string AL_MART_S  = "D";
///////////////////////////////////////////////////////////////////////////////
// EPIC SPELL: Anarchy's Call
const int ANARCHY_DC    = 43;
const int ANARCHY_IP    = 432;
const int R_ANARCHY_IP  = 503;
const int ANARCHY_FE    = 5036;
const int R_ANARCHY_FE  = 5037;
const int ANARCHY_XP    = 0;
const int ANARCHY_R1    = OPPOSIT_FE; // Opposition seed
const int ANARCHY_R2    = COMPEL_FE; // Compel seed
const int ANARCHY_R3    = 0;
const int ANARCHY_R4    = 0;
const string ANARCHY_S  = "E";
///////////////////////////////////////////////////////////////////////////////
// EPIC SPELL: Animus Blast
const int ANBLAST_DC    = 30;
const int ANBLAST_IP    = 433;
const int R_ANBLAST_IP  = 504;
const int ANBLAST_FE    = 5038;
const int R_ANBLAST_FE  = 5039;
const int ANBLAST_XP    = 0;
const int ANBLAST_R1    = ENERGY_FE; // Energy seed
const int ANBLAST_R2    = ANIDEAD_FE; // Animate Dead seed
const int ANBLAST_R3    = 0;
const int ANBLAST_R4    = 0;
const string ANBLAST_S  = "V";
///////////////////////////////////////////////////////////////////////////////
// EPIC SPELL: Animus Blizzard
const int ANBLIZZ_DC    = 58;
const int ANBLIZZ_IP    = 434;
const int R_ANBLIZZ_IP  = 505;
const int ANBLIZZ_FE    = 5040;
const int R_ANBLIZZ_FE  = 5041;
const int ANBLIZZ_XP    = 0;
const int ANBLIZZ_R1    = ENERGY_FE; // Energy seed
const int ANBLIZZ_R2    = ANIDEAD_FE; // Animate Dead seed
const int ANBLIZZ_R3    = 0;
const int ANBLIZZ_R4    = 0;
const string ANBLIZZ_S  = "V";
///////////////////////////////////////////////////////////////////////////////
// EPIC SPELL: Army Unfallen
const int ARMY_UN_DC    = 66;
const int ARMY_UN_IP    = 435;
const int R_ARMY_UN_IP  = 506;
const int ARMY_UN_FE    = 5042;
const int R_ARMY_UN_FE  = 5043;
const int ARMY_UN_XP    = 0;
const int ARMY_UN_R1    = LIFE_FE; // Life seed
const int ARMY_UN_R2    = HEAL_FE; // Heal seed
const int ARMY_UN_R3    = WARD_FE; // Ward seed
const int ARMY_UN_R4    = 0;
const string ARMY_UN_S  = "C";
///////////////////////////////////////////////////////////////////////////////
// EPIC SPELL: Audience of Stone
const int A_STONE_DC    = 41;
const int A_STONE_IP    = 436;
const int R_A_STONE_IP  = 507;
const int A_STONE_FE    = 5044;
const int R_A_STONE_FE  = 5045;
const int A_STONE_XP    = 0;
const int A_STONE_R1    = TRANSFO_FE; // Transform seed
const int A_STONE_R2    = 0;
const int A_STONE_R3    = 0;
const int A_STONE_R4    = 0;
const string A_STONE_S  = "T";
///////////////////////////////////////////////////////////////////////////////
// EPIC SPELL: Battle Bounding
const int BATTLEB_DC    = 41;
const int BATTLEB_IP    = 437;
const int R_BATTLEB_IP  = 508;
const int BATTLEB_FE    = 5046;
const int R_BATTLEB_FE  = 5047;
const int BATTLEB_XP    = 0;
const int BATTLEB_R1    = WARD_FE; // Ward seed
const int BATTLEB_R2    = TRANSPO_FE; // Transport seed
const int BATTLEB_R3    = 0;
const int BATTLEB_R4    = 0;
const string BATTLEB_S  = "T";
///////////////////////////////////////////////////////////////////////////////
// EPIC SPELL: Celestial Council
const int CELCOUN_DC    = 27;
const int CELCOUN_IP    = 438;
const int R_CELCOUN_IP  = 509;
const int CELCOUN_FE    = 5048;
const int R_CELCOUN_FE  = 5049;
const int CELCOUN_XP    = 0;
const int CELCOUN_R1    = CONTACT_FE; // Contact seed
const int CELCOUN_R2    = 0;
const int CELCOUN_R3    = 0;
const int CELCOUN_R4    = 0;
const string CELCOUN_S  = "D";
///////////////////////////////////////////////////////////////////////////////
// EPIC SPELL: Champion's Valor
const int CHAMP_V_DC    = 45;
const int CHAMP_V_IP    = 439;
const int R_CHAMP_V_IP  = 510;
const int CHAMP_V_FE    = 5050;
const int R_CHAMP_V_FE  = 5051;
const int CHAMP_V_XP    = 200;
const int CHAMP_V_R1    = FORTIFY_FE; // Fortify seed
const int CHAMP_V_R2    = 0;
const int CHAMP_V_R3    = 0;
const int CHAMP_V_R4    = 0;
const string CHAMP_V_S  = "T";
///////////////////////////////////////////////////////////////////////////////
// EPIC SPELL: Contingent Resurrection
const int CON_RES_DC    = 52;
const int CON_RES_IP    = 440;
const int R_CON_RES_IP  = 511;
const int CON_RES_FE    = 5052;
const int R_CON_RES_FE  = 5053;
const int CON_RES_XP    = 0;
const int CON_RES_R1    = LIFE_FE; // Life seed
const int CON_RES_R2    = 0;
const int CON_RES_R3    = 0;
const int CON_RES_R4    = 0;
const string CON_RES_S  = "C";
///////////////////////////////////////////////////////////////////////////////
// EPIC SPELL: Contingent Reunion
const int CON_REU_DC    = 44;
const int CON_REU_IP    = 441;
const int R_CON_REU_IP  = 512;
const int CON_REU_FE    = 5054;
const int R_CON_REU_FE  = 5055;
const int CON_REU_XP    = 0;
const int CON_REU_R1    = TRANSPO_FE; // Transport seed
const int CON_REU_R2    = FORESEE_FE; // Foresee seed
const int CON_REU_R3    = 0;
const int CON_REU_R4    = 0;
const string CON_REU_S  = "T";
///////////////////////////////////////////////////////////////////////////////
// EPIC SPELL: Deadeye Sense
const int DEADEYE_DC    = 47;
const int DEADEYE_IP    = 442;
const int R_DEADEYE_IP  = 513;
const int DEADEYE_FE    = 5056;
const int R_DEADEYE_FE  = 5057;
const int DEADEYE_XP    = 400;
const int DEADEYE_R1    = FORTIFY_FE; // Fortify seed
const int DEADEYE_R2    = 0;
const int DEADEYE_R3    = 0;
const int DEADEYE_R4    = 0;
const string DEADEYE_S  = "T";
///////////////////////////////////////////////////////////////////////////////
// EPIC SPELL: Deathmark
const int DTHMARK_DC    = 59;
const int DTHMARK_IP    = 443;
const int R_DTHMARK_IP  = 514;
const int DTHMARK_FE    = 5058;
const int R_DTHMARK_FE  = 5059;
const int DTHMARK_XP    = 0;
const int DTHMARK_R1    = SLAY_FE; // Slay seed
const int DTHMARK_R2    = TIME_FE; // Time seed
const int DTHMARK_R3    = AFFLICT_FE; // Afflict seed
const int DTHMARK_R4    = 0;
const string DTHMARK_S  = "N";
///////////////////////////////////////////////////////////////////////////////
// EPIC SPELL: Dire Winter
const int DIREWIN_DC    = 99;
const int DIREWIN_IP    = 444;
const int R_DIREWIN_IP  = 515;
const int DIREWIN_FE    = 5060;
const int R_DIREWIN_FE  = 5061;
const int DIREWIN_XP    = 2000;
const int DIREWIN_R1    = ENERGY_FE; // Energy seed
const int DIREWIN_R2    = 0;
const int DIREWIN_R3    = 0;
const int DIREWIN_R4    = 0;
const string DIREWIN_S  = "V";
///////////////////////////////////////////////////////////////////////////////
// EPIC SPELL: Dragon Knight
const int DRG_KNI_DC    = 48;
const int DRG_KNI_IP    = 445;
const int R_DRG_KNI_IP  = 516;
const int DRG_KNI_FE    = 5062;
const int R_DRG_KNI_FE  = 5063;
const int DRG_KNI_XP    = 0;
const int DRG_KNI_R1    = SUMMON_FE; // Summon seed
const int DRG_KNI_R2    = 0;
const int DRG_KNI_R3    = 0;
const int DRG_KNI_R4    = 0;
const string DRG_KNI_S  = "C";
///////////////////////////////////////////////////////////////////////////////
// EPIC SPELL: Dreamscape
const int DREAMSC_DC    = 29;
const int DREAMSC_IP    = 446;
const int R_DREAMSC_IP  = 517;
const int DREAMSC_FE    = 5064;
const int R_DREAMSC_FE  = 5065;
const int DREAMSC_XP    = 0;
const int DREAMSC_R1    = TRANSPO_FE; // Transport seed
const int DREAMSC_R2    = 0;
const int DREAMSC_R3    = 0;
const int DREAMSC_R4    = 0;
const string DREAMSC_S  = "T";
///////////////////////////////////////////////////////////////////////////////
// EPIC SPELL: Dullblades
const int DULBLAD_DC    = 54;
const int DULBLAD_IP    = 447;
const int R_DULBLAD_IP  = 518;
const int DULBLAD_FE    = 5066;
const int R_DULBLAD_FE  = 5067;
const int DULBLAD_XP    = 0;
const int DULBLAD_R1    = WARD_FE; // Ward seed
const int DULBLAD_R2    = 0;
const int DULBLAD_R3    = 0;
const int DULBLAD_R4    = 0;
const string DULBLAD_S  = "A";
///////////////////////////////////////////////////////////////////////////////
// EPIC SPELL: Dweomer Thief
const int DWEO_TH_DC    = 65;
const int DWEO_TH_IP    = 448;
const int R_DWEO_TH_IP  = 519;
const int DWEO_TH_FE    = 5068;
const int R_DWEO_TH_FE  = 5069;
const int DWEO_TH_XP    = 0;
const int DWEO_TH_R1    = REVEAL_FE; // Reveal seed
const int DWEO_TH_R2    = COMPEL_FE; // Compel seed
const int DWEO_TH_R3    = REFLECT_FE; // Reflect seed
const int DWEO_TH_R4    = 0;
const string DWEO_TH_S  = "A";
///////////////////////////////////////////////////////////////////////////////
// EPIC SPELL: Enslave
const int ENSLAVE_DC    = 60;
const int ENSLAVE_IP    = 449;
const int R_ENSLAVE_IP  = 520;
const int ENSLAVE_FE    = 5070;
const int R_ENSLAVE_FE  = 5071;
const int ENSLAVE_XP    = 3500;
const int ENSLAVE_R1    = COMPEL_FE; // Compel seed
const int ENSLAVE_R2    = 0;
const int ENSLAVE_R3    = 0;
const int ENSLAVE_R4    = 0;
const string ENSLAVE_S  = "E";
///////////////////////////////////////////////////////////////////////////////
// EPIC SPELL: Epic Mage Armor
const int EP_M_AR_DC    = 46;
const int EP_M_AR_IP    = 450;
const int R_EP_M_AR_IP  = 521;
const int EP_M_AR_FE    = 5072;
const int R_EP_M_AR_FE  = 5073;
const int EP_M_AR_XP    = 0;
const int EP_M_AR_R1    = ARMOR_FE; // Armor seed
const int EP_M_AR_R2    = 0;
const int EP_M_AR_R3    = 0;
const int EP_M_AR_R4    = 0;
const string EP_M_AR_S  = "C";
///////////////////////////////////////////////////////////////////////////////
// EPIC SPELL: Epic Repulsion
const int EP_RPLS_DC    = 34;
const int EP_RPLS_IP    = 451;
const int R_EP_RPLS_IP  = 522;
const int EP_RPLS_FE    = 5074;
const int R_EP_RPLS_FE  = 5075;
const int EP_RPLS_XP    = 0;
const int EP_RPLS_R1    = WARD_FE; // Ward seed
const int EP_RPLS_R2    = 0;
const int EP_RPLS_R3    = 0;
const int EP_RPLS_R4    = 0;
const string EP_RPLS_S  = "A";
///////////////////////////////////////////////////////////////////////////////
// EPIC SPELL: Epic Spell Reflection
const int EP_SP_R_DC    = 52;
const int EP_SP_R_IP    = 452;
const int R_EP_SP_R_IP  = 523;
const int EP_SP_R_FE    = 5076;
const int R_EP_SP_R_FE  = 5077;
const int EP_SP_R_XP    = 0;
const int EP_SP_R_R1    = REFLECT_FE; // Reflect seed
const int EP_SP_R_R2    = 0;
const int EP_SP_R_R3    = 0;
const int EP_SP_R_R4    = 0;
const string EP_SP_R_S  = "A";
///////////////////////////////////////////////////////////////////////////////
// EPIC SPELL: Epic Warding
const int EP_WARD_DC    = 68;
const int EP_WARD_IP    = 453;
const int R_EP_WARD_IP  = 524;
const int EP_WARD_FE    = 5078;
const int R_EP_WARD_FE  = 5079;
const int EP_WARD_XP    = 0;
const int EP_WARD_R1    = WARD_FE; // Ward seed
const int EP_WARD_R2    = 0;
const int EP_WARD_R3    = 0;
const int EP_WARD_R4    = 0;
const string EP_WARD_S  = "A";
///////////////////////////////////////////////////////////////////////////////
// EPIC SPELL: Eternal Freedom
const int ET_FREE_DC    = 101;
const int ET_FREE_IP    = 454;
const int R_ET_FREE_IP  = 525;
const int ET_FREE_FE    = 5080;
const int R_ET_FREE_FE  = 5081;
const int ET_FREE_XP    = 10000;
const int ET_FREE_R1    = WARD_FE; // Ward seed
const int ET_FREE_R2    = 0;
const int ET_FREE_R3    = 0;
const int ET_FREE_R4    = 0;
const string ET_FREE_S  = "A";
///////////////////////////////////////////////////////////////////////////////
// EPIC SPELL: Fiendish Words
const int FIEND_W_DC    = 27;
const int FIEND_W_IP    = 455;
const int R_FIEND_W_IP  = 526;
const int FIEND_W_FE    = 5082;
const int R_FIEND_W_FE  = 5083;
const int FIEND_W_XP    = 0;
const int FIEND_W_R1    = CONTACT_FE; // Contact seed
const int FIEND_W_R2    = 0;
const int FIEND_W_R3    = 0;
const int FIEND_W_R4    = 0;
const string FIEND_W_S  = "D";
///////////////////////////////////////////////////////////////////////////////
// EPIC SPELL: Fleetness of Foot
const int FLEETNS_DC    = 32;
const int FLEETNS_IP    = 456;
const int R_FLEETNS_IP  = 527;
const int FLEETNS_FE    = 5084;
const int R_FLEETNS_FE  = 5085;
const int FLEETNS_XP    = 0;
const int FLEETNS_R1    = FORTIFY_FE; // Fortify seed
const int FLEETNS_R2    = 0;
const int FLEETNS_R3    = 0;
const int FLEETNS_R4    = 0;
const string FLEETNS_S  = "T";
///////////////////////////////////////////////////////////////////////////////
// EPIC SPELL: Gem Cage
const int GEMCAGE_DC    = 48;
const int GEMCAGE_IP    = 457;
const int R_GEMCAGE_IP  = 528;
const int GEMCAGE_FE    = 5086;
const int R_GEMCAGE_FE  = 5087;
const int GEMCAGE_XP    = 0;
const int GEMCAGE_R1    = TRANSFO_FE; // Transform seed
const int GEMCAGE_R2    = TRANSPO_FE; // Transport seed
const int GEMCAGE_R3    = 0;
const int GEMCAGE_R4    = 0;
const string GEMCAGE_S  = "T";
///////////////////////////////////////////////////////////////////////////////
// EPIC SPELL: Godsmite
const int GODSMIT_DC    = 63;
const int GODSMIT_IP    = 458;
const int R_GODSMIT_IP  = 529;
const int GODSMIT_FE    = 5088;
const int R_GODSMIT_FE  = 5089;
const int GODSMIT_XP    = 0;
const int GODSMIT_R1    = DESTROY_FE; // Destroy seed
const int GODSMIT_R2    = OPPOSIT_FE; // Opposition seed
const int GODSMIT_R3    = 0;
const int GODSMIT_R4    = 0;
const string GODSMIT_S  = "V";
///////////////////////////////////////////////////////////////////////////////
// EPIC SPELL: Greater Ruin
const int GR_RUIN_DC    = 59;
const int GR_RUIN_IP    = 459;
const int R_GR_RUIN_IP  = 530;
const int GR_RUIN_FE    = 5090;
const int R_GR_RUIN_FE  = 5091;
const int GR_RUIN_XP    = 0;
const int GR_RUIN_R1    = DESTROY_FE; // Destroy seed
const int GR_RUIN_R2    = 0;
const int GR_RUIN_R3    = 0;
const int GR_RUIN_R4    = 0;
const string GR_RUIN_S  = "T";
///////////////////////////////////////////////////////////////////////////////
// EPIC SPELL: Greater Spell Resistance
const int GR_SP_RE_DC   = 67;
const int GR_SP_RE_IP   = 460;
const int R_GR_SP_RE_IP = 531;
const int GR_SP_RE_FE   = 5092;
const int R_GR_SP_RE_FE = 5093;
const int GR_SP_RE_XP   = 0;
const int GR_SP_RE_R1   = FORTIFY_FE; // Fortify seed
const int GR_SP_RE_R2   = 0;
const int GR_SP_RE_R3   = 0;
const int GR_SP_RE_R4   = 0;
const string GR_SP_RE_S = "T";
///////////////////////////////////////////////////////////////////////////////
// EPIC SPELL: Greater Timestop
const int GR_TIME_DC    = 27;
const int GR_TIME_IP    = 461;
const int R_GR_TIME_IP  = 532;
const int GR_TIME_FE    = 5094;
const int R_GR_TIME_FE  = 5095;
const int GR_TIME_XP    = 0;
const int GR_TIME_R1    = TIME_FE; // Time seed
const int GR_TIME_R2    = 0;
const int GR_TIME_R3    = 0;
const int GR_TIME_R4    = 0;
const string GR_TIME_S  = "T";
///////////////////////////////////////////////////////////////////////////////
// EPIC SPELL: Hell Send
const int HELSEND_DC    = 34;
const int HELSEND_IP    = 462;
const int R_HELSEND_IP  = 533;
const int HELSEND_FE    = 5096;
const int R_HELSEND_FE  = 5097;
const int HELSEND_XP    = 0;
const int HELSEND_R1    = TRANSPO_FE; // Transport seed
const int HELSEND_R2    = 0;
const int HELSEND_R3    = 0;
const int HELSEND_R4    = 0;
const string HELSEND_S  = "T";
///////////////////////////////////////////////////////////////////////////////
// EPIC SPELL: Hellball
const int HELBALL_DC    = 70;
const int HELBALL_IP    = 463;
const int R_HELBALL_IP  = 534;
const int HELBALL_FE    = 5098;
const int R_HELBALL_FE  = 5099;
const int HELBALL_XP    = 400;
const int HELBALL_R1    = ENERGY_FE; // Energy seed
const int HELBALL_R2    = 0;
const int HELBALL_R3    = 0;
const int HELBALL_R4    = 0;
const string HELBALL_S  = "V";
///////////////////////////////////////////////////////////////////////////////
// EPIC SPELL: Herculean Alliance
const int HERCALL_DC    = 61;
const int HERCALL_IP    = 464;
const int R_HERCALL_IP  = 535;
const int HERCALL_FE    = 5100;
const int R_HERCALL_FE  = 5101;
const int HERCALL_XP    = 0;
const int HERCALL_R1    = FORTIFY_FE; // Fortify seed
const int HERCALL_R2    = 5103; // the Herculean Empowerment spell researched
const int HERCALL_R3    = 0;
const int HERCALL_R4    = 0;
const string HERCALL_S  = "T";
///////////////////////////////////////////////////////////////////////////////
// EPIC SPELL: Herculean Empowerment
const int HERCEMP_DC    = 51;
const int HERCEMP_IP    = 465;
const int R_HERCEMP_IP  = 536;
const int HERCEMP_FE    = 5102;
const int R_HERCEMP_FE  = 5103;
const int HERCEMP_XP    = 0;
const int HERCEMP_R1    = FORTIFY_FE; // Fortify seed
const int HERCEMP_R2    = 0;
const int HERCEMP_R3    = 0;
const int HERCEMP_R4    = 0;
const string HERCEMP_S  = "T";
///////////////////////////////////////////////////////////////////////////////
// EPIC SPELL: Impenetrability
const int IMPENET_DC    = 54;
const int IMPENET_IP    = 466;
const int R_IMPENET_IP  = 537;
const int IMPENET_FE    = 5104;
const int R_IMPENET_FE  = 5105;
const int IMPENET_XP    = 0;
const int IMPENET_R1    = WARD_FE; // Ward seed
const int IMPENET_R2    = 0;
const int IMPENET_R3    = 0;
const int IMPENET_R4    = 0;
const string IMPENET_S  = "A";
///////////////////////////////////////////////////////////////////////////////
// EPIC SPELL: Leech Field
const int LEECH_F_DC    = 64;
const int LEECH_F_IP    = 467;
const int R_LEECH_F_IP  = 538;
const int LEECH_F_FE    = 5106;
const int R_LEECH_F_FE  = 5107;
const int LEECH_F_XP    = 0;
const int LEECH_F_R1    = HEAL_FE; // Heal seed
const int LEECH_F_R2    = 0;
const int LEECH_F_R3    = 0;
const int LEECH_F_R4    = 0;
const string LEECH_F_S  = "N";
///////////////////////////////////////////////////////////////////////////////
// EPIC SPELL: Legendary Artisan
const int LEG_ART_DC    = 78;
const int LEG_ART_IP    = 468;
const int R_LEG_ART_IP  = 539;
const int LEG_ART_FE    = 5108;
const int R_LEG_ART_FE  = 5109;
const int LEG_ART_XP    = 0;
const int LEG_ART_R1    = TRANSFO_FE; // Transform seed
const int LEG_ART_R2    = FORTIFY_FE; // Fortify seed
const int LEG_ART_R3    = ENERGY_FE; // Energy seed
const int LEG_ART_R4    = CONJURE_FE; // Conjure seed
const string LEG_ART_S  = "T";
///////////////////////////////////////////////////////////////////////////////
// EPIC SPELL: Life Force Transfer
const int LIFE_FT_DC    = 0;
const int LIFE_FT_IP    = 469;
const int R_LIFE_FT_IP  = 540;
const int LIFE_FT_FE    = 5110;
const int R_LIFE_FT_FE  = 5111;
const int LIFE_FT_XP    = 0;
const int LIFE_FT_R1    = 0;
const int LIFE_FT_R2    = 0;
const int LIFE_FT_R3    = 0;
const int LIFE_FT_R4    = 0;
const string LIFE_FT_S  = "C";
///////////////////////////////////////////////////////////////////////////////
// EPIC SPELL: Magma Burst
const int MAGMA_B_DC    = 80;
const int MAGMA_B_IP    = 470;
const int R_MAGMA_B_IP  = 541;
const int MAGMA_B_FE    = 5112;
const int R_MAGMA_B_FE  = 5113;
const int MAGMA_B_XP    = 0;
const int MAGMA_B_R1    = ENERGY_FE; // Energy seed
const int MAGMA_B_R2    = TRANSFO_FE; // Transform seed
const int MAGMA_B_R3    = 0;
const int MAGMA_B_R4    = 0;
const string MAGMA_B_S  = "V";
///////////////////////////////////////////////////////////////////////////////
// EPIC SPELL: Mass Penguin
const int MASSPEN_DC    = 35;
const int MASSPEN_IP    = 471;
const int R_MASSPEN_IP  = 542;
const int MASSPEN_FE    = 5114;
const int R_MASSPEN_FE  = 5115;
const int MASSPEN_XP    = 0;
const int MASSPEN_R1    = TRANSFO_FE; // Transform seed
const int MASSPEN_R2    = 0;
const int MASSPEN_R3    = 0;
const int MASSPEN_R4    = 0;
const string MASSPEN_S  = "T";
///////////////////////////////////////////////////////////////////////////////
// EPIC SPELL: Momento Mori
const int MORI_DC       = 78;
const int MORI_IP       = 472;
const int R_MORI_IP     = 543;
const int MORI_FE       = 5116;
const int R_MORI_FE     = 5117;
const int MORI_XP       = 0;
const int MORI_R1       = SLAY_FE; // Slay seed.
const int MORI_R2       = 0;
const int MORI_R3       = 0;
const int MORI_R4       = 0;
const string MORI_S     = "N";
///////////////////////////////////////////////////////////////////////////////
// EPIC SPELL: Mummy Dust
const int MUMDUST_DC    = 35;
const int MUMDUST_IP    = 473;
const int R_MUMDUST_IP  = 544;
const int MUMDUST_FE    = 5118;
const int R_MUMDUST_FE  = 5119;
const int MUMDUST_XP    = 0;
const int MUMDUST_R1    = ANIDEAD_FE; // Animate Dead seed
const int MUMDUST_R2    = 0;
const int MUMDUST_R3    = 0;
const int MUMDUST_R4    = 0;
const string MUMDUST_S  = "N";
///////////////////////////////////////////////////////////////////////////////
// EPIC SPELL: Nailed to the Sky
const int NAILSKY_DC    = 42;
const int NAILSKY_IP    = 474;
const int R_NAILSKY_IP  = 545;
const int NAILSKY_FE    = 5120;
const int R_NAILSKY_FE  = 5121;
const int NAILSKY_XP    = 1000;
const int NAILSKY_R1    = FORESEE_FE; // Foresee seed
const int NAILSKY_R2    = TRANSPO_FE; // Transport seed
const int NAILSKY_R3    = 0;
const int NAILSKY_R4    = 0;
const string NAILSKY_S  = "T";
///////////////////////////////////////////////////////////////////////////////
// EPIC SPELL: Night's Undoing
const int NIGHTSU_DC    = 24;
const int NIGHTSU_IP    = 475;
const int R_NIGHTSU_IP  = 546;
const int NIGHTSU_FE    = 5122;
const int R_NIGHTSU_FE  = 5123;
const int NIGHTSU_XP    = 0;
const int NIGHTSU_R1    = LIGHT_FE; // Light seed
const int NIGHTSU_R2    = 0;
const int NIGHTSU_R3    = 0;
const int NIGHTSU_R4    = 0;
const string NIGHTSU_S  = "V";
///////////////////////////////////////////////////////////////////////////////
// EPIC SPELL: Order Restored
const int ORDER_R_DC    = 43;
const int ORDER_R_IP    = 476;
const int R_ORDER_R_IP  = 547;
const int ORDER_R_FE    = 5124;
const int R_ORDER_R_FE  = 5125;
const int ORDER_R_XP    = 0;
const int ORDER_R_R1    = OPPOSIT_FE; // Opposition seed
const int ORDER_R_R2    = COMPEL_FE; // Compel seed
const int ORDER_R_R3    = 0;
const int ORDER_R_R4    = 0;
const string ORDER_R_S  = "E";
///////////////////////////////////////////////////////////////////////////////
// EPIC SPELL: Paths Become Known
const int PATHS_B_DC    = 36;
const int PATHS_B_IP    = 477;
const int R_PATHS_B_IP  = 548;
const int PATHS_B_FE    = 5126;
const int R_PATHS_B_FE  = 5127;
const int PATHS_B_XP    = 0;
const int PATHS_B_R1    = FORESEE_FE; // Foresee seed
const int PATHS_B_R2    = REVEAL_FE; // Reveal seed
const int PATHS_B_R3    = 0;
const int PATHS_B_R4    = 0;
const string PATHS_B_S  = "D";
///////////////////////////////////////////////////////////////////////////////
// EPIC SPELL: Peerless Penitence
const int PEERPEN_DC    = 68;
const int PEERPEN_IP    = 478;
const int R_PEERPEN_IP  = 549;
const int PEERPEN_FE    = 5128;
const int R_PEERPEN_FE  = 5129;
const int PEERPEN_XP    = 1000;
const int PEERPEN_R1    = HEAL_FE; // Heal seed
const int PEERPEN_R2    = OPPOSIT_FE; // Opposition seed
const int PEERPEN_R3    = DESTROY_FE; // Destroy seed
const int PEERPEN_R4    = 0;
const string PEERPEN_S  = "V";
///////////////////////////////////////////////////////////////////////////////
// EPIC SPELL: Pestilence
const int PESTIL_DC     = 44;
const int PESTIL_IP     = 479;
const int R_PESTIL_IP   = 550;
const int PESTIL_FE     = 5130;
const int R_PESTIL_FE   = 5131;
const int PESTIL_XP     = 600;
const int PESTIL_R1     = AFFLICT_FE; // Afflict seed
const int PESTIL_R2     = 0;
const int PESTIL_R3     = 0;
const int PESTIL_R4     = 0;
const string PESTIL_S   = "N";
///////////////////////////////////////////////////////////////////////////////
// EPIC SPELL: Pious Parley
const int PIOUS_P_DC    = 36;
const int PIOUS_P_IP    = 480;
const int R_PIOUS_P_IP  = 551;
const int PIOUS_P_FE    = 5132;
const int R_PIOUS_P_FE  = 5133;
const int PIOUS_P_XP    = 0;
const int PIOUS_P_R1    = CONTACT_FE; // Contact seed
const int PIOUS_P_R2    = 0;
const int PIOUS_P_R3    = 0;
const int PIOUS_P_R4    = 0;
const string PIOUS_P_S  = "D";
///////////////////////////////////////////////////////////////////////////////
// EPIC SPELL: Planar Cell
const int PLANCEL_DC    = 51;
const int PLANCEL_IP    = 481;
const int R_PLANCEL_IP  = 552;
const int PLANCEL_FE    = 5134;
const int R_PLANCEL_FE  = 5135;
const int PLANCEL_XP    = 0;
const int PLANCEL_R1    = TRANSPO_FE; // Transport seed
const int PLANCEL_R2    = 0;
const int PLANCEL_R3    = 0;
const int PLANCEL_R4    = 0;
const string PLANCEL_S  = "T";
///////////////////////////////////////////////////////////////////////////////
// EPIC SPELL: Psionic Salvo
const int PSION_S_DC    = 74;
const int PSION_S_IP    = 482;
const int R_PSION_S_IP  = 553;
const int PSION_S_FE    = 5136;
const int R_PSION_S_FE  = 5137;
const int PSION_S_XP    = 0;
const int PSION_S_R1    = AFFLICT_FE; // Afflict seed
const int PSION_S_R2    = 0;
const int PSION_S_R3    = 0;
const int PSION_S_R4    = 0;
const string PSION_S_S  = "E";
///////////////////////////////////////////////////////////////////////////////
// EPIC SPELL: Rain of Fire
const int RAINFIR_DC    = 75;
const int RAINFIR_IP    = 483;
const int R_RAINFIR_IP  = 554;
const int RAINFIR_FE    = 5138;
const int R_RAINFIR_FE  = 5139;
const int RAINFIR_XP    = 500;
const int RAINFIR_R1    = ENERGY_FE; // Energy seed
const int RAINFIR_R2    = 0;
const int RAINFIR_R3    = 0;
const int RAINFIR_R4    = 0;
const string RAINFIR_S  = "V";
///////////////////////////////////////////////////////////////////////////////
// EPIC SPELL: Risen Reunited
const int RISEN_R_DC    = 67;
const int RISEN_R_IP    = 484;
const int R_RISEN_R_IP  = 555;
const int RISEN_R_FE    = 5140;
const int R_RISEN_R_FE  = 5141;
const int RISEN_R_XP    = 0;
const int RISEN_R_R1    = TRANSPO_FE; // Transport seed
const int RISEN_R_R2    = CONTACT_FE; // Contact seed
const int RISEN_R_R3    = LIFE_FE; // Life seed
const int RISEN_R_R4    = 0;
const string RISEN_R_S  = "C";
///////////////////////////////////////////////////////////////////////////////
// EPIC SPELL: Ruin
const int RUIN_DC       = 29;
const int RUIN_IP       = 485;
const int R_RUIN_IP     = 556;
const int RUIN_FE       = 5142;
const int R_RUIN_FE     = 5143;
const int RUIN_XP       = 0;
const int RUIN_R1       = DESTROY_FE; // Destroy seed
const int RUIN_R2       = 0;
const int RUIN_R3       = 0;
const int RUIN_R4       = 0;
const string RUIN_S     = "T";
///////////////////////////////////////////////////////////////////////////////
// EPIC SPELL: Singular Sunder
const int SINGSUN_DC    = 58;
const int SINGSUN_IP    = 486;
const int R_SINGSUN_IP  = 557;
const int SINGSUN_FE    = 5144;
const int R_SINGSUN_FE  = 5145;
const int SINGSUN_XP    = 0;
const int SINGSUN_R1    = DESTROY_FE; // Destroy seed
const int SINGSUN_R2    = DISPEL_FE; // Dispel seed
const int SINGSUN_R3    = 0;
const int SINGSUN_R4    = 0;
const string SINGSUN_S  = "T";
///////////////////////////////////////////////////////////////////////////////
// EPIC SPELL: Spell Worm
const int SP_WORM_DC    = 25;
const int SP_WORM_IP    = 487;
const int R_SP_WORM_IP  = 558;
const int SP_WORM_FE    = 5146;
const int R_SP_WORM_FE  = 5147;
const int SP_WORM_XP    = 0;
const int SP_WORM_R1    = COMPEL_FE; // Compel seed
const int SP_WORM_R2    = 0;
const int SP_WORM_R3    = 0;
const int SP_WORM_R4    = 0;
const string SP_WORM_S  = "E";
///////////////////////////////////////////////////////////////////////////////
// EPIC SPELL: Storm Mantle
const int STORM_M_DC    = 74;
const int STORM_M_IP    = 488;
const int R_STORM_M_IP  = 559;
const int STORM_M_FE    = 5148;
const int R_STORM_M_FE  = 5149;
const int STORM_M_XP    = 0;
const int STORM_M_R1    = WARD_FE; // Ward seed
const int STORM_M_R2    = 0;
const int STORM_M_R3    = 0;
const int STORM_M_R4    = 0;
const string STORM_M_S  = "A";
///////////////////////////////////////////////////////////////////////////////
// EPIC SPELL: Summon Aberration
const int SUMABER_DC    = 42;
const int SUMABER_IP    = 489;
const int R_SUMABER_IP  = 560;
const int SUMABER_FE    = 5150;
const int R_SUMABER_FE  = 5151;
const int SUMABER_XP    = 0;
const int SUMABER_R1    = SUMMON_FE; // Summon seed
const int SUMABER_R2    = 0;
const int SUMABER_R3    = 0;
const int SUMABER_R4    = 0;
const string SUMABER_S  = "C";
///////////////////////////////////////////////////////////////////////////////
// EPIC SPELL: Superb Dispelling
const int SUP_DIS_DC    = 59;
const int SUP_DIS_IP    = 490;
const int R_SUP_DIS_IP  = 561;
const int SUP_DIS_FE    = 5152;
const int R_SUP_DIS_FE  = 5153;
const int SUP_DIS_XP    = 0;
const int SUP_DIS_R1    = DISPEL_FE; // Dispel seed
const int SUP_DIS_R2    = 0;
const int SUP_DIS_R3    = 0;
const int SUP_DIS_R4    = 0;
const string SUP_DIS_S  = "A";
///////////////////////////////////////////////////////////////////////////////
// EPIC SPELL: Symrustar's Spellbinding
const int SYMRUST_DC    = 0;
const int SYMRUST_IP    = 491;
const int R_SYMRUST_IP  = 562;
const int SYMRUST_FE    = 5154;
const int R_SYMRUST_FE  = 5155;
const int SYMRUST_XP    = 0;
const int SYMRUST_R1    = 0;
const int SYMRUST_R2    = 0;
const int SYMRUST_R3    = 0;
const int SYMRUST_R4    = 0;
const string SYMRUST_S  = "E";
///////////////////////////////////////////////////////////////////////////////
// EPIC SPELL: The Withering
const int THEWITH_DC    = 69;
const int THEWITH_IP    = 492;
const int R_THEWITH_IP  = 563;
const int THEWITH_FE    = 5156;
const int R_THEWITH_FE  = 5157;
const int THEWITH_XP    = 300;
const int THEWITH_R1    = AFFLICT_FE; // Afflict seed
const int THEWITH_R2    = 0;
const int THEWITH_R3    = 0;
const int THEWITH_R4    = 0;
const string THEWITH_S  = "N";
///////////////////////////////////////////////////////////////////////////////
// EPIC SPELL: Tolodine's Killing Wind
const int TOLO_KW_DC    = 91;
const int TOLO_KW_IP    = 493;
const int R_TOLO_KW_IP  = 564;
const int TOLO_KW_FE    = 5158;
const int R_TOLO_KW_FE  = 5159;
const int TOLO_KW_XP    = 400;
const int TOLO_KW_R1    = AFFLICT_FE; // Afflict seed
const int TOLO_KW_R2    = SLAY_FE; // Slay seed
const int TOLO_KW_R3    = 0;
const int TOLO_KW_R4    = 0;
const string TOLO_KW_S  = "N";
///////////////////////////////////////////////////////////////////////////////
// EPIC SPELL: Transcendent Vitality
const int TRANVIT_DC    = 101;
const int TRANVIT_IP    = 494;
const int R_TRANVIT_IP  = 565;
const int TRANVIT_FE    = 5160;
const int R_TRANVIT_FE  = 5161;
const int TRANVIT_XP    = 10000;
const int TRANVIT_R1    = FORTIFY_FE; // Fortify seed
const int TRANVIT_R2    = HEAL_FE; // Heal seed
const int TRANVIT_R3    = 0;
const int TRANVIT_R4    = 0;
const string TRANVIT_S  = "T";
///////////////////////////////////////////////////////////////////////////////
// EPIC SPELL: Twinfiend
const int TWINF_DC      = 64;
const int TWINF_IP      = 495;
const int R_TWINF_IP    = 566;
const int TWINF_FE      = 5162;
const int R_TWINF_FE    = 5163;
const int TWINF_XP      = 0;
const int TWINF_R1      = SUMMON_FE; // Summon seed
const int TWINF_R2      = 0;
const int TWINF_R3      = 0;
const int TWINF_R4      = 0;
const string TWINF_S    = "C";
///////////////////////////////////////////////////////////////////////////////
// EPIC SPELL: Unholy Disciple
const int UNHOLYD_DC    = 47;
const int UNHOLYD_IP    = 496;
const int R_UNHOLYD_IP  = 567;
const int UNHOLYD_FE    = 5164;
const int R_UNHOLYD_FE  = 5165;
const int UNHOLYD_XP    = 300;
const int UNHOLYD_R1    = SUMMON_FE; // Summon seed
const int UNHOLYD_R2    = 0;
const int UNHOLYD_R3    = 0;
const int UNHOLYD_R4    = 0;
const string UNHOLYD_S  = "N";
///////////////////////////////////////////////////////////////////////////////
// EPIC SPELL: Unimpinged
const int UNIMPIN_DC    = 54;
const int UNIMPIN_IP    = 497;
const int R_UNIMPIN_IP  = 568;
const int UNIMPIN_FE    = 5166;
const int R_UNIMPIN_FE  = 5167;
const int UNIMPIN_XP    = 0;
const int UNIMPIN_R1    = WARD_FE; // Ward seed
const int UNIMPIN_R2    = 0;
const int UNIMPIN_R3    = 0;
const int UNIMPIN_R4    = 0;
const string UNIMPIN_S  = "A";
///////////////////////////////////////////////////////////////////////////////
// EPIC SPELL: Unseen Wanderer
const int UNSEENW_DC    = 101;
const int UNSEENW_IP    = 498;
const int R_UNSEENW_IP  = 569;
const int UNSEENW_FE    = 5168;
const int R_UNSEENW_FE  = 5169;
const int UNSEENW_XP    = 10000;
const int UNSEENW_R1    = CONCEAL_FE; // Conceal seed
const int UNSEENW_R2    = 0;
const int UNSEENW_R3    = 0;
const int UNSEENW_R4    = 0;
const string UNSEENW_S  = "I";
///////////////////////////////////////////////////////////////////////////////
// EPIC SPELL: Whip of Shar
const int WHIP_SH_DC    = 73;
const int WHIP_SH_IP    = 499;
const int R_WHIP_SH_IP  = 570;
const int WHIP_SH_FE    = 5170;
const int R_WHIP_SH_FE  = 5171;
const int WHIP_SH_XP    = 0;
const int WHIP_SH_R1    = SHADOW_FE; // Shadow seed
const int WHIP_SH_R2    = CONJURE_FE; // Conjure seed
const int WHIP_SH_R3    = TRANSFO_FE; // Transform seed
const int WHIP_SH_R4    = 0;
const string WHIP_SH_S  = "V";
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

/*
CONSTANTS FOR MESSAGES.
*/
const string MES_LEARN_SEED             = "You have gained the knowledge of this epic spell seed!";
const string MES_KNOW_SEED              = "You already have knowledge of this epic spell seed.";
const string MES_LEARN_SPELL            = "You have gained the knowledge and use of this epic spell!";
const string MES_KNOW_SPELL             = "You have already researched this spell.";
const string MES_CLASS_NOT_ALLOWED      = "Your magical teachings do not seem to allow the learning of this epic spell seed.";
const string MES_BOOK_DESTROYED         = "The handling of this book has caused it to disintegrate!";
const string MES_CANNOT_RESEARCH_HERE   = "You are not allowed to pursue magical research here.";
const string MES_RESEARCH_SUCCESS       = "Congratulations! You have successfully researched an Epic spell!";
const string MES_RESEARCH_FAILURE       = "Failure! You have not found success in your research...";
const string MES_SPELLCRAFT_CHECK_PASS  = "Spellcraft check: Success!";
const string MES_SPELLCRAFT_CHECK_FAIL  = "Spellcraft check: Failed!";
const string MES_NOT_ENOUGH_GOLD        = "You do not have the required gold.";
const string MES_NOT_ENOUGH_XP          = "You do not have the required experience.";
const string MES_NOT_ENOUGH_SKILL       = "You do not have the required skill.";
const string MES_NOT_HAVE_REQ_FEATS     = "You cannot research this, since you do not have the required knowledge.";
const string MES_CANNOT_CAST_SLOTS      = "Spell failed! You do not have any epic spell slots remaining.";
const string MES_CANNOT_CAST_XP         = "Spell failed! You do not have enough experience to cast this spell.";
const string MES_CONTINGENCIES_YES1     = "You have contingencies active, therefore you do not have your full complement of spell slots.";
const string MES_CONTINGENCIES_YES2     = "The contingencies must expire to allow you to regain the spell slots.";


/******************************************************************************
FUNCTION DECLARATIONS
******************************************************************************/



// Returns the combined caster level of oPC.
int GetTotalCastingLevel(object oPC);

// Returns TRUE if oPC is an Epic level cleric.
int GetIsEpicCleric(object oPC);

// Returns TRUE if oPC is an Epic level druid.
int GetIsEpicDruid(object oPC);

// Returns TRUE if oPC is an Epic level sorcerer.
int GetIsEpicSorcerer(object oPC);

// Returns TRUE if oPC is an Epic level wizard.
int GetIsEpicWizard(object oPC);

// Performs a check on the book to randomly destroy it or not when used.
void DoBookDecay(object oBook, object oPC);

// Returns oPC's spell slot limit, based on Lore and on optional rules.
int GetEpicSpellSlotLimit(object oPC);

// Returns the number of remaining unused spell slots for oPC.
int GetSpellSlots(object oPC);

// Replenishes oPC's Epic spell slots.
void ReplenishSlots(object oPC);

// Decrements oPC's Epic spell slots by one.
void DecrementSpellSlots(object oPC);

// Lets oPC know how many Epic spell slots remain for use.
void MessageSpellSlots(object oPC);

// Returns a Spellcraft check for oPC, based on optional rules.
int GetSpellcraftCheck(object oPC);

// Returns the Spellcraft skill level of oPC, based on optional rules.
int GetSpellcraftSkill(object oPC);

// Returns TRUE if oPC has enough gold to research the spell.
int GetHasEnoughGoldToResearch(object oPC, int nSpellDC);

// Returns TRUE if oPC has enough excess experience to research the spell.
int GetHasEnoughExperienceToResearch(object oPC, int nSpellDC);

// Returns TRUE if oPC has the passed in required feats (Seeds or other Epic spells)... needs BLAH_IP's
int GetHasRequiredFeatsForResearch(object oPC, int nReq1, int nReq2 = 0, int nReq3 = 0, int nReq4 = 0);

// Returns success (TRUE) or failure (FALSE) in oPC's researching of a spell.
int GetResearchResult(object oPC, int nSpellDC);

// Takes the gold & experience (depending on success) from oPC for researching.
void TakeResourcesFromPC(object oPC, int nSpellDC, int nSuccess);

// Returns TRUE if oPC can cast the spell.
int GetCanCastSpell(object oPC, int nSpellDC, string sChool, int nSpellXP);

// Returns the adjusted DC of a spell that takes into account oPC's Spell Foci.
int GetDCSchoolFocusAdjustment(object oPC, string sChool);

// Returns TRUE if oPC has enough excess XP to spend on the casting of a spell.
int GetHasXPToSpend(object oPC, int nCost);

// Spends oPC's XP on the casting of the spell.
void SpendXP(object oPC, int nCost);

// Checks to see if oPC has a creature hide. If not, create and equip one.
void EnsurePCHasSkin(object oPC);

// Add nFeatIP to oPC's creature hide.
void GiveFeat(object oPC, int nFeatIP);

// Remove nFeatIP from oPC's creature hide.
void TakeFeat(object oPC, int nFeatIP);

// Checks to see how many castable epic spell feats oPC has ready to use.
// This is used for the control of the radial menu issue.
int GetCastableFeatCount(object oPC);

// When a contingency spell is active, oCaster loses the use of one slot per day
void PenalizeSpellSlotForCaster(object oCaster);

// When a contingecy expires, restore the spell slot for the caster.
void RestoreSpellSlotForCaster(object oCaster);

// Researches an Epic Spell for the caster.
void DoSpellResearch(object oCaster, int nSpellDC, int nSpellIP, string sSchool, object oBook);

// Cycles through equipped items on oTarget, and unequips any having nImmunityType
void UnequipAnyImmunityItems(object oTarget, int nImmType);

// Finds a given spell's DC
int GetEpicSpellSaveDC(object oCaster = OBJECT_SELF);

/******************************************************************************
FUNCTION BODIES
******************************************************************************/



int GetIsEpicCleric(object oPC)
{
    if (GetCasterLvl(TYPE_CLERIC, oPC) >= 17 && GetHitDice(oPC) >= 21 && 
        GetAbilityScore(oPC, ABILITY_WISDOM) >= 19)
            return TRUE;
    return FALSE;
}

int GetIsEpicDruid(object oPC)
{
    if (GetCasterLvl(TYPE_DRUID, oPC) >= 17 && GetHitDice(oPC) >= 21 &&
        GetAbilityScore(oPC, ABILITY_WISDOM) >= 19)
            return TRUE;
    return FALSE;
}

int GetIsEpicSorcerer(object oPC)
{
    if (GetCasterLvl(TYPE_SORCERER, oPC) >= 18 &&  GetHitDice(oPC) >= 21 &&
        GetAbilityScore(oPC, ABILITY_CHARISMA) >= 19)
            return TRUE;
    return FALSE;
}

int GetIsEpicWizard(object oPC)
{
    if (GetCasterLvl(TYPE_WIZARD, oPC) >= 17 && GetHitDice(oPC) >= 21 &&
        GetAbilityScore(oPC, ABILITY_INTELLIGENCE) >= 19)
            return TRUE;
    return FALSE;
}

void DoBookDecay(object oBook, object oPC)
{
    if (d100() >= BOOK_DESTRUCTION)
    {
        DestroyObject(oBook, 2.0);
        SendMessageToPC(oPC, MES_BOOK_DESTROYED);
    }
}

int GetEpicSpellSlotLimit(object oPC)
{
    int nLimit;
    int nPen = GetLocalInt(oPC, "nSpellSlotPenalty");
    int nBon = GetLocalInt(oPC, "nSpellSlotBonus");
    // What's oPC's Lore skill?.
    nLimit = GetSkillRank(SKILL_LORE, oPC);
    // Variant rule implementation.
    if (PRIMARY_ABILITY_MODIFIER_RULE == TRUE)
    {
        if (GetIsEpicSorcerer(oPC))
        {
            nLimit -= GetAbilityModifier(ABILITY_INTELLIGENCE, oPC);
            nLimit += GetAbilityModifier(ABILITY_CHARISMA, oPC);
        }
        else if (GetIsEpicCleric(oPC) || GetIsEpicDruid(oPC))
        {
            nLimit -= GetAbilityModifier(ABILITY_INTELLIGENCE, oPC);
            nLimit += GetAbilityModifier(ABILITY_WISDOM, oPC);
        }
    }
    // Primary calculation of slots.
    nLimit /= 10;
    // Modified calculation (for contingencies, bonuses, etc)
    nLimit = nLimit + nBon;
    nLimit = nLimit - nPen;
    return nLimit;
}

int GetSpellSlots(object oPC)
{
    int nSlots = GetLocalInt(oPC, "nEpicSpellSlots");
    return nSlots;
}

void ReplenishSlots(object oPC)
{
    SetLocalInt(oPC, "nEpicSpellSlots", GetEpicSpellSlotLimit(oPC));
    MessageSpellSlots(oPC);
}

void DecrementSpellSlots(object oPC)
{
    SetLocalInt(oPC, "nEpicSpellSlots", GetLocalInt(oPC, "nEpicSpellSlots")-1);
    MessageSpellSlots(oPC);
}

void MessageSpellSlots(object oPC)
{
    SendMessageToPC(oPC, "You now have " +
        IntToString(GetSpellSlots(oPC)) +
        " Epic spell slots available.");
}

int GetSpellcraftCheck(object oPC)
{
    // Get oPC's skill rank.
    int nCheck = GetSpellcraftSkill(oPC);
    // Do the check, dependant on "Take 10" variant rule.
    if (TAKE_TEN_RULE == TRUE)
        nCheck += 10;
    else
        nCheck += d20();
    return nCheck;
}

int GetSpellcraftSkill(object oPC)
{
    // Determine initial Spellcraft skill.
    int nSkill = GetSkillRank(SKILL_SPELLCRAFT, oPC);
    // Variant rule implementation.
    if (PRIMARY_ABILITY_MODIFIER_RULE == TRUE)
    {
        if (GetIsEpicSorcerer(oPC))
        {
            nSkill -= GetAbilityModifier(ABILITY_INTELLIGENCE, oPC);
            nSkill += GetAbilityModifier(ABILITY_CHARISMA, oPC);
        }
        else if (GetIsEpicCleric(oPC) || GetIsEpicDruid(oPC))
        {
            nSkill -= GetAbilityModifier(ABILITY_INTELLIGENCE, oPC);
            nSkill += GetAbilityModifier(ABILITY_WISDOM, oPC);
        }
    }
    return nSkill;
}

int GetHasEnoughGoldToResearch(object oPC, int nSpellDC)
{
    if (GetGold(oPC) >= nSpellDC * GOLD_MULTIPLIER)
        return TRUE;
    return FALSE;
}

int GetHasEnoughExperienceToResearch(object oPC, int nSpellDC)
{
    int nHitDice = GetHitDice(oPC);
    int nHitDiceXP = (500 * nHitDice * (nHitDice - 1)); // simplification of the sum
    if (GetXP(oPC) >= (nHitDiceXP + (nSpellDC * GOLD_MULTIPLIER / XP_FRACTION)))
        return TRUE;
    return FALSE;
}

int GetHasRequiredFeatsForResearch(object oPC, int nReq1, int nReq2 = 0, int nReq3 = 0, int nReq4 = 0)
{
    if (GetHasFeat(nReq1, oPC))
    {
        if (GetHasFeat(nReq2, oPC) || nReq2 == 0)
        {
            if (GetHasFeat(nReq3, oPC) || nReq3 == 0)
            {
                if (GetHasFeat(nReq4, oPC) || nReq4 == 0)
                    return TRUE;
            }
        }
    }
    return FALSE;
}
int GetResearchResult(object oPC, int nSpellDC)
{
    int nCheck = GetSpellcraftCheck(oPC);
    SendMessageToPC(oPC, "Your spellcraft check was a " +
        IntToString(nCheck) + ", against a researching DC of " +
        IntToString(nSpellDC));
    if (nCheck >= nSpellDC)
    {
        SendMessageToPC(oPC, MES_SPELLCRAFT_CHECK_PASS);
        return TRUE;
    }
    else
    {
        SendMessageToPC(oPC, MES_SPELLCRAFT_CHECK_FAIL);
        return FALSE;
    }
}

void TakeResourcesFromPC(object oPC, int nSpellDC, int nSuccess)
{
    if (nSuccess != TRUE)
        TakeGoldFromCreature(nSpellDC *
            GOLD_MULTIPLIER / FAILURE_FRACTION_GOLD, oPC, TRUE);
    else
    {
        TakeGoldFromCreature(nSpellDC * GOLD_MULTIPLIER, oPC, TRUE);
        SetXP(oPC, GetXP(oPC) - nSpellDC * GOLD_MULTIPLIER / XP_FRACTION);
    }
}

int GetCanCastSpell(object oPC, int nSpellDC, string sChool, int nSpellXP)
{
    // Adjust the DC to account for Spell Foci feats.
    nSpellDC -= GetDCSchoolFocusAdjustment(oPC, sChool);
    int nCheck = GetSpellcraftCheck(oPC);
    // Does oPC have any epic spell slots available?
    if (!GetIsPC(oPC))
    {
        return TRUE;
    }    
    if (!(GetSpellSlots(oPC) >= 1))
    { // No? Cancel spell, then.
        SendMessageToPC(oPC, MES_CANNOT_CAST_SLOTS);
        return FALSE;
    }
    if (XP_COSTS == TRUE)
    {
        // Does oPC have the needed XP available to cast the spell?
        if (!GetHasXPToSpend(oPC, nSpellXP))
        { // No? Cancel spell, then.
            SendMessageToPC(oPC, MES_CANNOT_CAST_XP);
            return FALSE;
        }
    }
    // Does oPC pass the Spellcraft check for the spell's casting?
    if (!(nCheck >= nSpellDC))
    { // No?
        SendMessageToPC(oPC, MES_SPELLCRAFT_CHECK_FAIL);
        SendMessageToPC(oPC,
            IntToString(nCheck) + " against a DC of " + IntToString(nSpellDC));
        // Failing a Spellcraft check still costs a spell slot, so decrement...
        DecrementSpellSlots(oPC);
        return FALSE;
    }
    // If the answer is YES to all three, cast the spell!
    SendMessageToPC(oPC, MES_SPELLCRAFT_CHECK_PASS);
    SendMessageToPC(oPC,
        IntToString(nCheck) + " against a DC of " + IntToString(nSpellDC));
    SpendXP(oPC, nSpellXP); // Only spends the XP on a successful casting.
    DecrementSpellSlots(oPC);
    return TRUE;
}

int GetHasXPToSpend(object oPC, int nCost)
{
    //NPCs dont have XP
    if(!GetIsPC(oPC))
        return TRUE;
    // To be TRUE, make sure that oPC wouldn't lose a level by spending nCost.
    int nHitDice = GetHitDice(oPC);
    int nHitDiceXP = (500 * nHitDice * (nHitDice - 1)); // simplification of the sum
    if (GetXP(oPC) >= (nHitDiceXP + nCost))
        return TRUE;
    return FALSE;
}

void SpendXP(object oPC, int nCost)
{
    if (nCost > 0)
        SetXP(oPC, GetXP(oPC) - nCost);
}

void EnsurePCHasSkin(object oPC)
{
    object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPC);
    if (oSkin == OBJECT_INVALID)
    {
        oSkin = CreateItemOnObject("base_prc_skin", oPC);
        AssignCommand(oPC, ActionEquipItem(oSkin, INVENTORY_SLOT_CARMOUR));
    }
}

void GiveFeat(object oPC, int nFeatIP)
{
    EnsurePCHasSkin(oPC);
    object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPC);
    if (oSkin != OBJECT_INVALID)
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(nFeatIP), oSkin);
    SetLocalInt(oPC, "nEpicSpellFeatCastable", GetCastableFeatCount(oPC));
}

void TakeFeat(object oPC, int nFeatIP)
{
    object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPC);
    itemproperty ipX = GetFirstItemProperty(oSkin);
    while (GetIsItemPropertyValid(ipX))
    {
        if (GetItemPropertyType(ipX) == ITEM_PROPERTY_BONUS_FEAT)
        {
            if(GetItemPropertySubType(ipX) == nFeatIP)
            {
                RemoveItemProperty(oSkin, ipX);
                break;
            }
        }
        ipX = GetNextItemProperty(oSkin);
    }
}

int GetCastableFeatCount(object oPC)
{
    int nX = 0;
    if (GetHasFeat(A_STONE_FE, oPC)) nX += 1;
    if (GetHasFeat(ACHHEEL_FE, oPC)) nX += 1;
    if (GetHasFeat(AL_MART_FE, oPC)) nX += 1;
    if (GetHasFeat(ALLHOPE_FE, oPC)) nX += 1;
    if (GetHasFeat(ANARCHY_FE, oPC)) nX += 1;
    if (GetHasFeat(ANBLAST_FE, oPC)) nX += 1;
    if (GetHasFeat(ANBLIZZ_FE, oPC)) nX += 1;
    if (GetHasFeat(ARMY_UN_FE, oPC)) nX += 1;
    if (GetHasFeat(BATTLEB_FE, oPC)) nX += 1;
    if (GetHasFeat(CELCOUN_FE, oPC)) nX += 1;
    if (GetHasFeat(CHAMP_V_FE, oPC)) nX += 1;
    if (GetHasFeat(CON_RES_FE, oPC)) nX += 1;
    if (GetHasFeat(CON_REU_FE, oPC)) nX += 1;
    if (GetHasFeat(DEADEYE_FE, oPC)) nX += 1;
    if (GetHasFeat(DIREWIN_FE, oPC)) nX += 1;
    if (GetHasFeat(DREAMSC_FE, oPC)) nX += 1;
    if (GetHasFeat(DRG_KNI_FE, oPC)) nX += 1;
    if (GetHasFeat(DTHMARK_FE, oPC)) nX += 1;
    if (GetHasFeat(DULBLAD_FE, oPC)) nX += 1;
    if (GetHasFeat(DWEO_TH_FE, oPC)) nX += 1;
    if (GetHasFeat(ENSLAVE_FE, oPC)) nX += 1;
    if (GetHasFeat(EP_M_AR_FE, oPC)) nX += 1;
    if (GetHasFeat(EP_RPLS_FE, oPC)) nX += 1;
    if (GetHasFeat(EP_SP_R_FE, oPC)) nX += 1;
    if (GetHasFeat(EP_WARD_FE, oPC)) nX += 1;
    if (GetHasFeat(ET_FREE_FE, oPC)) nX += 1;
    if (GetHasFeat(FIEND_W_FE, oPC)) nX += 1;
    if (GetHasFeat(FLEETNS_FE, oPC)) nX += 1;
    if (GetHasFeat(GEMCAGE_FE, oPC)) nX += 1;
    if (GetHasFeat(GODSMIT_FE, oPC)) nX += 1;
    if (GetHasFeat(GR_RUIN_FE, oPC)) nX += 1;
    if (GetHasFeat(GR_SP_RE_FE, oPC)) nX += 1;
    if (GetHasFeat(GR_TIME_FE, oPC)) nX += 1;
    if (GetHasFeat(HELBALL_FE, oPC)) nX += 1;
    if (GetHasFeat(HELSEND_FE, oPC)) nX += 1;
    if (GetHasFeat(HERCALL_FE, oPC)) nX += 1;
    if (GetHasFeat(HERCEMP_FE, oPC)) nX += 1;
    if (GetHasFeat(IMPENET_FE, oPC)) nX += 1;
    if (GetHasFeat(LEECH_F_FE, oPC)) nX += 1;
    if (GetHasFeat(LEG_ART_FE, oPC)) nX += 1;
    if (GetHasFeat(LIFE_FT_FE, oPC)) nX += 1;
    if (GetHasFeat(MAGMA_B_FE, oPC)) nX += 1;
    if (GetHasFeat(MASSPEN_FE, oPC)) nX += 1;
    if (GetHasFeat(MORI_FE, oPC)) nX += 1;
    if (GetHasFeat(MUMDUST_FE, oPC)) nX += 1;
    if (GetHasFeat(NAILSKY_FE, oPC)) nX += 1;
    if (GetHasFeat(NIGHTSU_FE, oPC)) nX += 1;
    if (GetHasFeat(ORDER_R_FE, oPC)) nX += 1;
    if (GetHasFeat(PATHS_B_FE, oPC)) nX += 1;
    if (GetHasFeat(PEERPEN_FE, oPC)) nX += 1;
    if (GetHasFeat(PESTIL_FE, oPC)) nX += 1;
    if (GetHasFeat(PIOUS_P_FE, oPC)) nX += 1;
    if (GetHasFeat(PLANCEL_FE, oPC)) nX += 1;
    if (GetHasFeat(PSION_S_FE, oPC)) nX += 1;
    if (GetHasFeat(RAINFIR_FE, oPC)) nX += 1;
    if (GetHasFeat(RISEN_R_FE, oPC)) nX += 1;
    if (GetHasFeat(RUIN_FE, oPC)) nX += 1;
    if (GetHasFeat(SINGSUN_FE, oPC)) nX += 1;
    if (GetHasFeat(SP_WORM_FE, oPC)) nX += 1;
    if (GetHasFeat(STORM_M_FE, oPC)) nX += 1;
    if (GetHasFeat(SUMABER_FE, oPC)) nX += 1;
    if (GetHasFeat(SUP_DIS_FE, oPC)) nX += 1;
    if (GetHasFeat(SYMRUST_FE, oPC)) nX += 1;
    if (GetHasFeat(THEWITH_FE, oPC)) nX += 1;
    if (GetHasFeat(TOLO_KW_FE, oPC)) nX += 1;
    if (GetHasFeat(TRANVIT_FE, oPC)) nX += 1;
    if (GetHasFeat(TWINF_FE, oPC)) nX += 1;
    if (GetHasFeat(UNHOLYD_FE, oPC)) nX += 1;
    if (GetHasFeat(UNIMPIN_FE, oPC)) nX += 1;
    if (GetHasFeat(UNSEENW_FE, oPC)) nX += 1;
    if (GetHasFeat(WHIP_SH_FE, oPC)) nX += 1;
    return nX;
}

void PenalizeSpellSlotForCaster(object oCaster)
{
    int nMod = GetLocalInt(oCaster, "nSpellSlotPenalty");
    SetLocalInt(oCaster, "nSpellSlotPenalty", nMod + 1);
    SendMessageToPC(oCaster, MES_CONTINGENCIES_YES1);
    SendMessageToPC(oCaster, MES_CONTINGENCIES_YES2);
    SendMessageToPC(oCaster, "Your epic spell slot limit is now " +
        IntToString(GetEpicSpellSlotLimit(oCaster)) + ".");
}

void RestoreSpellSlotForCaster(object oCaster)
{
    int nMod = GetLocalInt(oCaster, "nSpellSlotPenalty");
    if (nMod > 0) SetLocalInt(oCaster, "nSpellSlotPenalty", nMod - 1);
    SendMessageToPC(oCaster, "Your epic spell slot limit is now " +
        IntToString(GetEpicSpellSlotLimit(oCaster)) + ".");
}

void DoSpellResearch(object oCaster, int nSpellDC, int nSpellIP, string sSchool, object oBook)
{
    float fDelay = 2.0;
    string sCutScript;
    int nResult = GetResearchResult(oCaster, nSpellDC);
    if (PLAY_RESEARCH_CUTS == TRUE)
    {
        if (sSchool == "A") sCutScript = SCHOOL_A;
        if (sSchool == "C") sCutScript = SCHOOL_C;
        if (sSchool == "D") sCutScript = SCHOOL_D;
        if (sSchool == "E") sCutScript = SCHOOL_E;
        if (sSchool == "I") sCutScript = SCHOOL_I;
        if (sSchool == "N") sCutScript = SCHOOL_N;
        if (sSchool == "T") sCutScript = SCHOOL_T;
        if (sSchool == "V") sCutScript = SCHOOL_V;
        ExecuteScript(sCutScript, oCaster);
        fDelay = 10.0;
    }
    DelayCommand(fDelay, TakeResourcesFromPC(oCaster, nSpellDC, nResult));
    if (nResult == TRUE)
    {
        DelayCommand(fDelay, SendMessageToPC(oCaster, MES_RESEARCH_SUCCESS));
        DelayCommand(fDelay, GiveFeat(oCaster, nSpellIP));
        DelayCommand(fDelay, DestroyObject(oBook));
    }
    else
    {
        DelayCommand(fDelay, SendMessageToPC(oCaster, MES_RESEARCH_FAILURE));
    }
}

void UnequipAnyImmunityItems(object oTarget, int nImmType)
{
    object oItem;
    int nX;
    for (nX = 0; nX <= 13; nX++) // Does not include creature items in search.
    {
        oItem = GetItemInSlot(nX, oTarget);
        // Debug.
        //SendMessageToPC(oTarget, "Checking slot " + IntToString(nX));
        if (oItem != OBJECT_INVALID)
        {
            // Debug.
            //SendMessageToPC(oTarget, "Valid item.");
            itemproperty ipX = GetFirstItemProperty(oItem);
            while (GetIsItemPropertyValid(ipX))
            {
                // Debug.
                //SendMessageToPC(oTarget, "Valid ip");
                if (GetItemPropertySubType(ipX) == nImmType)
                {
                    // Debug.
                    //SendMessageToPC(oTarget, "ip match!!");
                    SendMessageToPC(oTarget, GetName(oItem) +
                        " cannot be equipped at this time.");
                    AssignCommand(oTarget, ClearAllActions());
                    AssignCommand(oTarget, ActionUnequipItem(oItem));
                    break;
                }
                else
                    ipX = GetNextItemProperty(oItem);
            }
        }
    }
}

int GetTotalCastingLevel(object oCaster)
{
    int iBestArcane = GetLevelByTypeArcaneFeats();
    int iBestDivine = GetLevelByTypeDivineFeats();
    int iBest = (iBestDivine > iBestArcane) ? iBestDivine : iBestArcane;
    
    //SendMessageToPC(oCaster, "Epic casting at level " + IntToString(iBest));
    
    return iBest;
}

int GetDCSchoolFocusAdjustment(object oPC, string sChool)
{
    int nNewDC = 0;
    if (sChool == "A") // Abjuration spell?
    {
        if (GetHasFeat(FEAT_SPELL_FOCUS_ABJURATION, oPC)) nNewDC = 2;
        if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_ABJURATION, oPC)) nNewDC = 4;
        if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_ABJURATION, oPC)) nNewDC = 6;
    }
    if (sChool == "C") // Conjuration spell?
    {
        if (GetHasFeat(FEAT_SPELL_FOCUS_CONJURATION, oPC)) nNewDC = 2;
        if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_CONJURATION, oPC)) nNewDC = 4;
        if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_CONJURATION, oPC)) nNewDC = 6;
    }
    if (sChool == "D") // Divination spell?
    {
        if (GetHasFeat(FEAT_SPELL_FOCUS_DIVINATION, oPC)) nNewDC = 2;
        if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_DIVINIATION, oPC)) nNewDC = 4;
        if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_DIVINATION, oPC)) nNewDC = 6;
    }
    if (sChool == "E") // Enchantment spell?
    {
        if (GetHasFeat(FEAT_SPELL_FOCUS_ENCHANTMENT, oPC)) nNewDC = 2;
        if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_ENCHANTMENT, oPC)) nNewDC = 4;
        if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_ENCHANTMENT, oPC)) nNewDC = 6;
    }
    if (sChool == "V") // Evocation spell?
    {
        if (GetHasFeat(FEAT_SPELL_FOCUS_EVOCATION, oPC)) nNewDC = 2;
        if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_EVOCATION, oPC)) nNewDC = 4;
        if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_EVOCATION, oPC)) nNewDC = 6;
    }
    if (sChool == "I") // Illusion spell?
    {
        if (GetHasFeat(FEAT_SPELL_FOCUS_ILLUSION, oPC)) nNewDC = 2;
        if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_ILLUSION, oPC)) nNewDC = 4;
        if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_ILLUSION, oPC)) nNewDC = 6;
    }
    if (sChool == "N") // Necromancy spell?
    {
        if (GetHasFeat(FEAT_SPELL_FOCUS_NECROMANCY, oPC)) nNewDC = 2;
        if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_NECROMANCY, oPC)) nNewDC = 4;
        if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_NECROMANCY, oPC)) nNewDC = 6;
    }
    if (sChool == "T") // Transmutation spell?
    {
        if (GetHasFeat(FEAT_SPELL_FOCUS_TRANSMUTATION, oPC)) nNewDC = 2;
        if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_TRANSMUTATION, oPC)) nNewDC = 4;
        if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_TRANSMUTATION, oPC)) nNewDC = 6;
    }
    return nNewDC;
}

int GetEpicSpellSaveDC(object oCaster = OBJECT_SELF)
{
    int iDiv = GetCasterLvl(TYPE_DIVINE,   oCaster);
    int iWiz = GetCasterLvl(TYPE_WIZARD,   oCaster);
    int iSor = GetCasterLvl(TYPE_SORCERER, oCaster);
    int iBest = 0;
    int iAbility;

    if (iDiv > iBest) { iAbility = ABILITY_WISDOM;       iBest = iDiv; }
    if (iWiz > iBest) { iAbility = ABILITY_INTELLIGENCE; iBest = iWiz; }
    if (iSor > iBest) { iAbility = ABILITY_CHARISMA;     iBest = iSor; }
    
    if (iBest)   return 20 + GetAbilityModifier(iAbility, oCaster);
    else         return 20; // DC = 20 if the epic spell is cast some other way.
}
