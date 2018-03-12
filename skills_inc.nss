#include "rdo_const_skill"
#include "rdo_spinc"
#include "x2_inc_itemprop"

const string Skills_EFFECT_CREATOR = "Skills_EFFECT_CREATOR";
const int NUMBER_OF_SKILLS = 52;


/////////////////////// FUNCIONES /////////////////////////////

// Devuelve el valor de la tirada de Conocimiento Bardico
int GetBardicKnowledgeMod( object oPC );
int GetBardicKnowledgeMod( object oPC )
{
    int nivelBardo = GetLevelByClass(CLASS_TYPE_BARD, oPC);
    int bardicKnowledgeMod = 0;
    if (nivelBardo > 0) {
        bardicKnowledgeMod = nivelBardo;
        bardicKnowledgeMod += (GetSkillRank(SKILL_LORE_HISTORY, oPC, TRUE) >= 5) ? 2 : 0;
    }

    return bardicKnowledgeMod;
}

void Skills_ajustarDisciplina( object oPC )
{
/*    object creadorDisciplina = RDO_GetCreatorByTag(Skills_EFFECT_CREATOR);

    // Se quita primero para evitar que apile
    RDO_RemoveEffectsByCreator( oPC, creadorDisciplina );
*/
    int ajusteDisciplina = 10 + GetBaseAttackBonus(oPC) - GetSkillRank(SKILL_DISCIPLINE, oPC, TRUE);
//    AssignCommand(creadorDisciplina, ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectSkillIncrease(SKILL_DISCIPLINE, ajusteDisciplina)), oPC));
    IPSafeAddItemProperty(GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPC), ItemPropertySkillBonus(SKILL_DISCIPLINE, ajusteDisciplina));
}

#include "LetoCommands_inc"

// Usa el Leto para borrar todos los skills de oPC y
void Skills_ResetLevel1Skills( object oPC, int newSpareSkills );
void Skills_ResetLevel1Skills( object oPC, int newSpareSkills )
{
    int skill;
    for (skill=0; skill <= NUMBER_OF_SKILLS; skill++)
    {
        int skillRanks = GetSkillRank(skill, oPC, TRUE);
        if (skillRanks > 0)
        {
            Leto_addScriptToPCStack(oPC, Leto_SetSkill(skill, 0, 1));
        }
    }
    Leto_addScriptToPCStack(oPC, Leto_SetSpareSkill(newSpareSkills, 1));
}

