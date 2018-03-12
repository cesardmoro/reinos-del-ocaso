#include "RDO_const_skill"

// Da el modificador de iniciativa de 'sujeto'.

int DRC_initiativeModifier( object sujeto );
int DRC_initiativeModifier( object sujeto ) {
    int modifier = GetAbilityModifier( ABILITY_DEXTERITY, sujeto );
    if( GetHasFeat(FEAT_EPIC_SUPERIOR_INITIATIVE, sujeto) )
        modifier += 4;
    if( GetHasFeat(FEAT_IMPROVED_INITIATIVE, sujeto) )
        modifier += 4;
    return modifier;
}

int DRC_hideModifier( object sujeto );
int DRC_hideModifier( object sujeto ) {
    int modifier = GetSkillRank( SKILL_HIDE, sujeto );
    return modifier;
}

int DRC_listenModifier( object sujeto, int isBaseSkillRank=FALSE );
int DRC_listenModifier( object sujeto, int isBaseSkillRank=FALSE ) {
    int modifier = GetSkillRank( SKILL_LISTEN, sujeto, isBaseSkillRank );
    return modifier;
}

int DRC_moveSilentlyModifier( object sujeto, int isBaseSkillRank=FALSE );
int DRC_moveSilentlyModifier( object sujeto, int isBaseSkillRank=FALSE ) {
    int modifier = GetSkillRank( SKILL_MOVE_SILENTLY, sujeto, isBaseSkillRank );
    return modifier;
}

int DRC_spotModifier( object sujeto, int isBaseSkillRank=FALSE );
int DRC_spotModifier( object sujeto, int isBaseSkillRank=FALSE ) {
    int modifier = GetSkillRank( SKILL_SPOT, sujeto, isBaseSkillRank );
    return modifier;
}

int DRC_loreModifier( object sujeto, int isBaseSkillRank=FALSE );
int DRC_loreModifier( object sujeto, int isBaseSkillRank=FALSE ) {
    int modifier = GetSkillRank( SKILL_LORE, sujeto, isBaseSkillRank );
    return modifier;
}

int DRC_survivalModifier( object sujeto, int isBaseSkillRank=FALSE );
int DRC_survivalModifier( object sujeto, int isBaseSkillRank=FALSE ) {
    int modifier = GetSkillRank( SKILL_SURVIVAL, sujeto, isBaseSkillRank );
    return modifier;
}
