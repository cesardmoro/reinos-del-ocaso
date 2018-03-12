///////////////////////////////
// Sinergias entre Skills
//
////////////////

#include "Skills_inc"

const string Skills_Sinergy_EFFECT_CREATOR = "Skills_Sinergy_EFFECT_CREATOR";

// Funcion privada de Skills_Sinergy_applyGeneralSinergies()
// Para que un efecto este relacionado a su creador, debe ser CREADO por el mismo (valga la redundancia)
// No alcanza con asignarle la aplicacion. Por eso es necesario este segundo paso.
void Skills_Sinergy_applyGeneralSinergies_step2( object oPC )
{
    int skillBalance;
    int skillDisguise;
    int skillGatherInformation;
    int skillIntimidate;
    int skillJump;
    int skillLoreNature;
    int skillPersuade;
    int skillRide;
    int skillSleightOfHand;
    int skillSpellcraft;
    int skillTumble;
    int skillUseMagicDevice;

    if (GetSkillRank(SKILL_BLUFF, oPC, TRUE) >= 5) {
        skillPersuade += 2;
        skillDisguise += 2;
        skillSleightOfHand += 2;
        skillIntimidate += 2;
    }

    if (GetSkillRank(SKILL_DESCIPHER, oPC, TRUE) >= 5)
       skillUseMagicDevice += 2;

    if (GetSkillRank(SKILL_HANDLE_ANIMAL, oPC, TRUE) >= 5)
       skillRide += 2;

    if (GetSkillRank(SKILL_JUMP, oPC, TRUE) >= 5)
       skillTumble += 2;

    if (GetSkillRank(SKILL_LORE_ARCANA, oPC, TRUE) >= 5)
       skillSpellcraft += 2;
    if (GetSkillRank(SKILL_LORE_LOCAL, oPC, TRUE) >= 5)
       skillGatherInformation += 2;
    if (GetSkillRank(SKILL_LORE_NOBILITY, oPC, TRUE) >= 5)
       skillPersuade += 2;

    if (GetSkillRank(SKILL_SENSE_MOTIVE, oPC, TRUE) >= 5)
        skillPersuade += 2;

    if (GetSkillRank(SKILL_SPELLCRAFT, oPC, TRUE) >= 5)
       skillSpellcraft += 2;

    if (GetSkillRank(SKILL_SURVIVAL, oPC, TRUE) >= 5)
       skillLoreNature += 2;

    if (GetSkillRank(SKILL_TUMBLE, oPC, TRUE) >= 5) {
        skillBalance += 2;
        skillJump += 2;
    }

    if (GetSkillRank(SKILL_USE_MAGIC_DEVICE, oPC, TRUE) >= 5)
       skillUseMagicDevice += 2;

    effect skillIncrease;
    if (skillBalance > 0)
        skillIncrease = EffectLinkEffects(skillIncrease, EffectSkillIncrease(SKILL_BALANCE, skillBalance));
    if (skillDisguise > 0)
        skillIncrease = EffectLinkEffects(skillIncrease, EffectSkillIncrease(SKILL_DISGUISE, skillDisguise));
    if (skillGatherInformation > 0)
        skillIncrease = EffectLinkEffects(skillIncrease, EffectSkillIncrease(SKILL_GATHER_INF, skillGatherInformation));
    if (skillIntimidate > 0)
        skillIncrease = EffectLinkEffects(skillIncrease, EffectSkillIncrease(SKILL_INTIMIDATE, skillIntimidate));
    if (skillJump > 0)
        skillIncrease = EffectLinkEffects(skillIncrease, EffectSkillIncrease(SKILL_JUMP, skillJump));
    if (skillLoreNature > 0)
        skillIncrease = EffectLinkEffects(skillIncrease, EffectSkillIncrease(SKILL_LORE_NATURE, skillLoreNature));
    if (skillPersuade > 0)
        skillIncrease = EffectLinkEffects(skillIncrease, EffectSkillIncrease(SKILL_PERSUADE, skillPersuade));
    if (skillRide > 0)
        skillIncrease = EffectLinkEffects(skillIncrease, EffectSkillIncrease(SKILL_RIDE, skillRide));
    if (skillSleightOfHand > 0)
        skillIncrease = EffectLinkEffects(skillIncrease, EffectSkillIncrease(SKILL_SLEIGHT_OF_HAND, skillSleightOfHand));
    if (skillSpellcraft > 0)
        skillIncrease = EffectLinkEffects(skillIncrease, EffectSkillIncrease(SKILL_SPELLCRAFT, skillSpellcraft));
    if (skillTumble > 0)
        skillIncrease = EffectLinkEffects(skillIncrease, EffectSkillIncrease(SKILL_TUMBLE, skillTumble));
    if (skillUseMagicDevice > 0)
        skillIncrease = EffectLinkEffects(skillIncrease, EffectSkillIncrease(SKILL_USE_MAGIC_DEVICE, skillUseMagicDevice));

    skillIncrease = SupernaturalEffect(skillIncrease);

    ApplyEffectToObject(DURATION_TYPE_PERMANENT, skillIncrease, oPC);
}

// Handler de las sinergias generales.
// Se llama desde el evento OnEnter y desde la salida del Fugue.
// Algunas sinergias deben ser aplicadas en otros eventos.
void Skills_Sinergy_applyGeneralSinergies( object oPC );
void Skills_Sinergy_applyGeneralSinergies( object oPC )
{
    object oCreator = RDO_GetCreatorByTag(Skills_Sinergy_EFFECT_CREATOR);
    //Es necesario removerlos primero porque apilan y al desloguear no se borran los efectos
    RDO_RemoveEffectsByCreator(oPC, oCreator);

    AssignCommand(oCreator, Skills_Sinergy_applyGeneralSinergies_step2(oPC));
}

// Handler de las sinergias para los eventos de entradas a areas
// Esto es necesario porque hay algunas sinergias que cuentan en areas naturales,
// otras que funcionan en areas bajo tierra, etc.
void Skills_Sinergy_areaOnEnter( object oPC );
void Skills_Sinergy_areaOnEnter( object oPC )
{
    int esUnPlano = GetLocalInt(OBJECT_SELF, "Plano");
    int skillSurvival = (esUnPlano) ? 2 : 0;
    int skillSearch;
    if (GetIsAreaNatural(OBJECT_SELF)) {
        if (GetIsAreaAboveGround(OBJECT_SELF)) {
            skillSurvival += (GetSkillRank(SKILL_LORE_NATURE, oPC, TRUE) >= 5 && !esUnPlano) ? 2 : 0;
            skillSurvival += (GetSkillRank(SKILL_LORE_GEOGRAPHY, oPC, TRUE) >= 5 && !esUnPlano) ? 2 : 0;
        } else
            skillSurvival += (GetSkillRank(SKILL_LORE_DUNGEONEERING, oPC, TRUE) >= 5 && !esUnPlano) ? 2 : 0;
    } else
        skillSearch += (GetSkillRank(SKILL_LORE_ARCHITECTURE, oPC, TRUE) >= 5 && !esUnPlano) ? 2 : 0;


    // Asigno al area como creador del efecto, para poder quitarlo al salir
    if (skillSurvival > 0)
        AssignCommand(OBJECT_SELF, ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectSkillIncrease(SKILL_SURVIVAL, skillSurvival)), oPC));
    if (skillSearch > 0)
        AssignCommand(OBJECT_SELF, ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectSkillIncrease(SKILL_SEARCH, skillSearch)), oPC));
}

// Debe ser llamada desde los eventos de salida de un area
void Skills_Sinergy_areaOnExit( object oPC );
void Skills_Sinergy_areaOnExit( object oPC )
{
    RDO_RemoveEffectsByCreator(oPC, OBJECT_SELF);
}


const int STORE_TYPE_ARMOR  = 1;
const int STORE_TYPE_WEAPON = 2;
const int STORE_TYPE_TRAPS  = 3;
const int STORE_TYPE_NONE   = -1;

// Aplica las sinergias para la skill Appraise dependiendo del tipo de mercader
// El tipo de mercader debe ser dado con la constante STORE_TYPE_*
void Skills_Sinergy_storeOnOpen( object oPC, int storeType = STORE_TYPE_NONE );
void Skills_Sinergy_storeOnOpen( object oPC, int storeType = STORE_TYPE_NONE )
{
    if (storeType == STORE_TYPE_ARMOR && GetSkillRank(SKILL_CRAFT_ARMOR, oPC, TRUE) >= 5)
        AssignCommand(OBJECT_SELF, ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectSkillIncrease(SKILL_APPRAISE, 2)), oPC));
    else if (storeType == STORE_TYPE_WEAPON && GetSkillRank(SKILL_CRAFT_WEAPON, oPC, TRUE) >= 5)
        AssignCommand(OBJECT_SELF, ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectSkillIncrease(SKILL_APPRAISE, 2)), oPC));
    else if (storeType == STORE_TYPE_TRAPS && GetSkillRank(SKILL_CRAFT_TRAP, oPC, TRUE) >= 5)
        AssignCommand(OBJECT_SELF, ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectSkillIncrease(SKILL_APPRAISE, 2)), oPC));
}

// Handler a ser llamado desde el evento OnClose de cada mercader
void Skills_Sinergy_storeOnClose( object oPC, object oStore = OBJECT_SELF );
void Skills_Sinergy_storeOnClose( object oPC, object oStore = OBJECT_SELF )
{
    RDO_RemoveEffectsByCreator(oPC, oStore);
}
