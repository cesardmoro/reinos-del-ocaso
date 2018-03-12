/*
    prc_feats
    
    This is the point all feat checks are routed through
    from EvalPRCFeats() in prc_inc_function.
    
    Done so that if anything applies custom feats as 
    itemproperties (i.e. templates) the bonuses run
    
    Otherwise, the if() checks before the feat is applied
*/

#include "prc_alterations"

void main()
{
    object oPC = OBJECT_SELF;
    // Feats are checked here
    if(GetHasFeat(FEAT_SAC_VOW, oPC) >0)                         ExecuteScript("prc_vows", oPC);
    if(GetHasFeat(FEAT_LICHLOVED, oPC) >0)                       ExecuteScript("prc_lichloved", oPC);
    if(GetHasFeat(FEAT_EB_HAND, oPC)  ||
       GetHasFeat(FEAT_EB_HEAD, oPC)  ||
       GetHasFeat(FEAT_EB_CHEST, oPC) ||
       GetHasFeat(FEAT_EB_ARM, oPC)   ||
       GetHasFeat(FEAT_EB_NECK, oPC)    )                        ExecuteScript("prc_evilbrand", oPC);
    if(GetHasFeat(FEAT_VILE_WILL_DEFORM, oPC) ||
       GetHasFeat(FEAT_VILE_DEFORM_GAUNT, oPC)||
       GetHasFeat(FEAT_VILE_DEFORM_OBESE, oPC)  )                ExecuteScript("prc_vilefeats", oPC);
    if (GetHasFeat(FEAT_VIGIL_ARMOR, oPC))                       ExecuteScript("ft_vigil_armor", oPC);
    if(GetHasFeat(FEAT_BOWMASTERY, oPC)  ||
       GetHasFeat(FEAT_XBOWMASTERY, oPC) ||
       GetHasFeat(FEAT_SHURIKENMASTERY, oPC))                    ExecuteScript("prc_weapmas", oPC);

    //Delays for item bonuses
    if(GetHasFeat(FEAT_FORCE_PERSONALITY, oPC) ||
       GetHasFeat(FEAT_INSIGHTFUL_REFLEXES, oPC) ||
       GetHasFeat(FEAT_INTUITIVE_ATTACK, oPC) ||
       GetHasFeat(FEAT_RAVAGEGOLDENICE, oPC))                    DelayCommand(0.1, ExecuteScript("prc_ft_passive", oPC));
    if(GetHasFeat(FEAT_TACTILE_TRAPSMITH, oPC))                  DelayCommand(0.1, ExecuteScript("prc_ft_tacttrap", oPC));

    //Baelnorn & Undead
    if(GetHasFeat(FEAT_UNDEAD_HD, oPC))                          ExecuteScript("prc_ud_hitdice", oPC);
    if(GetHasFeat(FEAT_TURN_RESISTANCE, oPC))                    ExecuteScript("prc_turnres", oPC);
    if(GetHasFeat(FEAT_IMPROVED_TURN_RESISTANCE, oPC))           ExecuteScript("prc_imp_turnres", oPC);
    if(GetHasFeat(FEAT_IMMUNITY_ABILITY_DECREASE, oPC))          ExecuteScript("prc_ui_abildrain", oPC);
    if(GetHasFeat(FEAT_IMMUNITY_CRITICAL, oPC))                  ExecuteScript("prc_ui_critical", oPC);
    if(GetHasFeat(FEAT_IMMUNITY_DEATH, oPC))                     ExecuteScript("prc_ui_death", oPC);
    if(GetHasFeat(FEAT_IMMUNITY_DISEASE, oPC))                   ExecuteScript("prc_ui_disease", oPC);
    if(GetHasFeat(FEAT_IMMUNITY_MIND_SPELLS, oPC))               ExecuteScript("prc_ui_mind", oPC);
    if(GetHasFeat(FEAT_IMMUNITY_PARALYSIS, oPC))                 ExecuteScript("prc_ui_paral", oPC);
    if(GetHasFeat(FEAT_IMMUNITY_POISON, oPC))                    ExecuteScript("prc_ui_poison", oPC);
    if(GetHasFeat(FEAT_IMMUNITY_SNEAKATTACK, oPC))               ExecuteScript("prc_ui_snattack", oPC);
    if(GetHasFeat(FEAT_POSITIVE_ENERGY_RESISTANCE, oPC))         ExecuteScript("prc_ud_poe", oPC);

    if(GetHasFeat(FEAT_GREATER_TWO_WEAPON_FIGHTING, oPC)
       && GetLevelByClass(CLASS_TYPE_TEMPEST, oPC) == 0)         ExecuteScript("ft_gtwf", oPC);
    if(GetHasFeat(FEAT_LINGERING_DAMAGE, oPC) >0)                ExecuteScript("ft_lingdmg", oPC);
    if(GetHasFeat(FEAT_MAGICAL_APTITUDE, oPC))                   ExecuteScript("prc_magaptitude", oPC);
    if(GetHasFeat(FEAT_ETERNAL_FREEDOM, oPC))                    ExecuteScript("etern_free", oPC);
    if(GetPersistantLocalInt(oPC, "EpicSpell_TransVital"))       ExecuteScript("trans_vital", oPC);
    if(GetHasFeat(FEAT_COMBAT_MANIFESTATION, oPC))               ExecuteScript("psi_combat_manif", oPC);
    if(GetHasFeat(FEAT_WILD_TALENT, oPC))                        ExecuteScript("psi_wild_talent", oPC);
    if(GetHasFeat(FEAT_RAPID_METABOLISM, oPC))                   ExecuteScript("prc_rapid_metab", oPC);
    if(GetHasFeat(FEAT_PSIONIC_HOLE, oPC))                       ExecuteScript("psi_psionic_hole", oPC);
    if(GetHasFeat(FEAT_POWER_ATTACK, oPC))                       ExecuteScript("prc_powatk_eval", oPC);
    if(GetHasFeat(FEAT_ENDURANCE, oPC)
        || GetHasFeat(FEAT_TRACK, oPC)
        || GetHasFeat(FEAT_ETHRAN, oPC))                         ExecuteScript("prc_wyzfeat", oPC);
    if(GetHasFeat(FAST_HEALING_1, oPC)
        || GetHasFeat(FAST_HEALING_2, oPC)
        || GetHasFeat(FAST_HEALING_3, oPC))                      ExecuteScript("prc_fastheal", oPC);

    if(GetHasFeat(FEAT_SPELLFIRE_WIELDER, oPC))                  ExecuteScript("prc_spellf_eval", oPC);
    if(GetHasFeat(FEAT_ULTRAVISION, oPC))                        ExecuteScript("prc_ultravis", oPC);

}