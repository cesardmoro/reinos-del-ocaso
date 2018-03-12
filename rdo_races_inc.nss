/******************************************************************************
Sistema de Subrazas - Script By dragoncin

Para agregar una subraza hay que:
    . Agregar un ID a la lista de identificadores de la subraza
    . Aumentar en 1 la constante Races_NUMBER_OF_SUBRACES
    . Agregar una rama en el switch de la funcion RDO_getSubRaceInfo() con los datos de la subraza

La unica limitacion esta en el numero de feats raciales que no puede superar 5 sin cambiar más código
******************************************************************************/

#include "RDO_Races_Itf"
#include "LetoCommands_inc"
#include "RDO_Clases_Itf"
#include "inc_msg"
#include "Skills_inc"
#include "PRC_Feat_Const"
#include "SPC_PoderRel_inc"


// Setea la subraza de oPC y guarda en la DB que su subraza fue seteada
// Devuelve TRUE si la subraza necesita un cambio a traves del Leto
// IMPORTANTE: Usa el LetoScript para ajustar los stats. Por lo tanto, "reloguea" al usuario pasandolo por otro mod
int SetAllowedSubRace( object oPC, int subRaceId );
int SetAllowedSubRace( object oPC, int subRaceId )
{
    int subRaceNeedsAdjustments = FALSE;
    SetCampaignInt(SubRaces_DATABASE, SubRaces_DB_SUBRACE_WAS_SET, TRUE, oPC);
    struct RDO_SubraceInfo subRace = RDO_getSubRaceInfo( subRaceId );
    int playerXP = GetXP(oPC);
    if (playerXP == 0)
    {
        if (subRace.Str != 0)
            Leto_addScriptToPCStack(oPC, Leto_AdjustAbility(ABILITY_STRENGTH, subRace.Str));
        if (subRace.Dex != 0)
            Leto_addScriptToPCStack(oPC, Leto_AdjustAbility(ABILITY_DEXTERITY, subRace.Dex));
        if (subRace.Con != 0)
            Leto_addScriptToPCStack(oPC, Leto_AdjustAbility(ABILITY_CONSTITUTION, subRace.Con));
        if (subRace.Int != 0) {
            Leto_addScriptToPCStack(oPC, Leto_AdjustAbility(ABILITY_INTELLIGENCE, subRace.Int));
            int spareSkills = (GetAbilityScore(oPC, ABILITY_INTELLIGENCE, TRUE) + subRace.Int - 10) / 2 + StringToInt(Get2DAString("classes", "SkillPointBase", GetClassByPosition(1, oPC)));
            spareSkills = (spareSkills < 1) ? 4 : (spareSkills * 4);
            Skills_ResetLevel1Skills(oPC, spareSkills);
        }
        if (subRace.Wis != 0)
            Leto_addScriptToPCStack(oPC, Leto_AdjustAbility(ABILITY_WISDOM, subRace.Wis));
        if (subRace.Cha != 0)
            Leto_addScriptToPCStack(oPC, Leto_AdjustAbility(ABILITY_CHARISMA, subRace.Cha));

        if (subRace.Feat1 > -1)
            Leto_addScriptToPCStack(oPC, Leto_AddFeat(subRace.Feat1));
        if (subRace.Feat2 > -1)
            Leto_addScriptToPCStack(oPC, Leto_AddFeat(subRace.Feat2));
        if (subRace.Feat3 > -1)
            Leto_addScriptToPCStack(oPC, Leto_AddFeat(subRace.Feat3));
        if (subRace.Feat4 > -1)
            Leto_addScriptToPCStack(oPC, Leto_AddFeat(subRace.Feat4));
        if (subRace.Feat5 > -1)
            Leto_addScriptToPCStack(oPC, Leto_AddFeat(subRace.Feat5));

        int newStrength     = GetAbilityScore(oPC, ABILITY_STRENGTH, TRUE)      + subRace.Str;
        int newDexterity    = GetAbilityScore(oPC, ABILITY_DEXTERITY, TRUE)     + subRace.Dex;
        int newConstitution = GetAbilityScore(oPC, ABILITY_CONSTITUTION, TRUE)  + subRace.Con;
        int newIntelligence = GetAbilityScore(oPC, ABILITY_INTELLIGENCE, TRUE)  + subRace.Int;
        int newWisdom       = GetAbilityScore(oPC, ABILITY_WISDOM, TRUE)        + subRace.Wis;
        int newCharisma     = GetAbilityScore(oPC, ABILITY_CHARISMA, TRUE)      + subRace.Cha;

        // ---> Correccion de las dotes tomadas tramposamente
        if (newStrength < 13 && GetHasFeat(FEAT_POWER_ATTACK, oPC))
            Leto_addScriptToPCStack(oPC, Leto_RemoveFeat(FEAT_POWER_ATTACK));
        if (newStrength < 13 && GetHasFeat(FEAT_IMPROVED_POWER_ATTACK, oPC))
            Leto_addScriptToPCStack(oPC, Leto_RemoveFeat(FEAT_IMPROVED_POWER_ATTACK ));
        if (newStrength < 13 && GetHasFeat(FEAT_CLEAVE, oPC))
            Leto_addScriptToPCStack(oPC, Leto_RemoveFeat(FEAT_CLEAVE));
        if (newStrength < 13 && GetHasFeat(FEAT_GREAT_CLEAVE, oPC))
            Leto_addScriptToPCStack(oPC, Leto_RemoveFeat(FEAT_GREAT_CLEAVE));

        if (newDexterity < 15 && GetHasFeat(FEAT_AMBIDEXTERITY, oPC))
            Leto_addScriptToPCStack(oPC, Leto_RemoveFeat(FEAT_AMBIDEXTERITY));
        if (newDexterity < 13 && GetHasFeat(FEAT_DODGE, oPC))
            Leto_addScriptToPCStack(oPC, Leto_RemoveFeat(FEAT_DODGE));
        if (newDexterity < 13 && GetHasFeat(FEAT_MOBILITY, oPC))
            Leto_addScriptToPCStack(oPC, Leto_RemoveFeat(FEAT_MOBILITY));
        if (newDexterity < 13 && GetHasFeat(FEAT_RAPID_SHOT, oPC))
            Leto_addScriptToPCStack(oPC, Leto_RemoveFeat(FEAT_RAPID_SHOT));

        if (newIntelligence < 13 && GetHasFeat(FEAT_DISARM, oPC))
            Leto_addScriptToPCStack(oPC, Leto_RemoveFeat(FEAT_DISARM));
        if (newIntelligence < 13 && GetHasFeat(FEAT_EXPERTISE, oPC))
            Leto_addScriptToPCStack(oPC, Leto_RemoveFeat(FEAT_EXPERTISE));
        if (newIntelligence < 13 && GetHasFeat(FEAT_IMPROVED_EXPERTISE, oPC))
            Leto_addScriptToPCStack(oPC, Leto_RemoveFeat(FEAT_IMPROVED_EXPERTISE));
        if (newIntelligence < 13 && GetHasFeat(FEAT_IMPROVED_PARRY, oPC))
            Leto_addScriptToPCStack(oPC, Leto_RemoveFeat(FEAT_IMPROVED_PARRY));

        if (newCharisma < 13 && GetHasFeat(FEAT_DIVINE_CLEANSING, oPC))
            Leto_addScriptToPCStack(oPC, Leto_RemoveFeat(FEAT_DIVINE_CLEANSING));
        if (newCharisma < 13 && GetHasFeat(FEAT_DIVINE_MIGHT, oPC))
            Leto_addScriptToPCStack(oPC, Leto_RemoveFeat(FEAT_DIVINE_MIGHT));
        if (newCharisma < 13 && GetHasFeat(FEAT_DIVINE_SHIELD, oPC))
            Leto_addScriptToPCStack(oPC, Leto_RemoveFeat(FEAT_DIVINE_SHIELD));
        if (newCharisma < 13 && GetHasFeat(FEAT_DIVINE_VIGOR, oPC))
            Leto_addScriptToPCStack(oPC, Leto_RemoveFeat(FEAT_DIVINE_VIGOR));
        if (newCharisma < 11 && GetHasFeat(FEAT_ETHRAN, oPC))
            Leto_addScriptToPCStack(oPC, Leto_RemoveFeat(FEAT_ETHRAN));
        if (newCharisma < 15 && GetHasFeat(FEAT_HOLYRADIANCE, oPC))
            Leto_addScriptToPCStack(oPC, Leto_RemoveFeat(FEAT_HOLYRADIANCE));
        // <---

        if (subRace.Str != 0 || subRace.Dex != 0 || subRace.Con != 0 || subRace.Int != 0 || subRace.Wis != 0 || subRace.Cha != 0)
        {
            subRaceNeedsAdjustments = TRUE;
            mensajeFlotanteReiterativo( oPC, "Debes reloguear para que los cambios por tu subraza hagan efecto." );
        }

        SetSubRace(oPC, subRace.Name);
      }
    // Si no es un personaje recien creado, solo puede tomar subrazas sin ajuste de nivel,
    // y se asume que los atributos fueron cambiados
    else if (subRace.LevelAdjustmentFixed == 0 && subRace.LevelAdjustmentProgressive == 0 )
    {
        SetSubRace(oPC, subRace.Name);
    }
    // Si la subraza tiene ajuste de nivel, borrarla
    else
    {
        SetSubRace(oPC, "");
    }

    string sSubRace = GetSubRace(oPC);
    if (sSubRace != "")
        SendMessageToPC(oPC, "Ahora eres un "+subRace.Name+"!");

    if (subRaceId == SUBRACE_ID_HALFLING_STRONGHEART) {
        SendMessageToPC(oPC, "Debes contactar un DM para obtener tu Dote Extra.");
    }

    return subRaceNeedsAdjustments;
}

int round( float value ) {
    if( value >=0.0 )
        return FloatToInt( value + 0.5 );
    else
        return FloatToInt( value - 0.5 );
}


int CalculateSubRaceLevelAdjustment( object oPC );
int CalculateSubRaceLevelAdjustment( object oPC ) {
    struct RDO_SubraceInfo sri = RDO_getSubRaceInfo( GetSubRaceId(oPC) );
    if( sri.LevelAdjustmentProgressive != 0 ) {
        float poderRelativo = IntToFloat(100 + sri.LevelAdjustmentProgressive) / 100.0;
        int nivelPj = GetHitDice( oPC );
        float nivelPjConAjusteProgresivo = SisPremioCombate_calcularNivelParaPoderRelativo( IntToFloat(nivelPj), poderRelativo );
        return sri.LevelAdjustmentFixed + round( nivelPjConAjusteProgresivo ) - nivelPj;
    }
    else {
        return sri.LevelAdjustmentFixed;
    }
}

// Calcula el ajuste de nivel de la subraza de oPC, y guarda el resultado en el PJ para su uso posterior.
// Si la subraza de oPC no tiene ajuste de nivel, no hace nada
void SetSubRaceLevelAdjustment( object oPC );
void SetSubRaceLevelAdjustment( object oPC )
{
    SetLocalInt(oPC, RDO_modificadorNivelSubraza_PN, CalculateSubRaceLevelAdjustment( oPC ) );
}

// Handler para el evento onEnter del sistema de razas y subrazas
// Estandariza la subraza de oPC y asigna el ajuste de nivel si es necesario
// Asume que oPC es un PJ
// IMPORTANTE: debe llamarse antes de la funcion prepararPersonajeNivel1()
void Races_onEnter( object oPC );
void Races_onEnter( object oPC )
{
    int subRaceNeedsAdjustments = FALSE;
    int subRaceId = GetSubRaceId(oPC);
    if (GetCampaignInt(SubRaces_DATABASE, SubRaces_DB_SUBRACE_WAS_SET, oPC) == FALSE)
    {
        subRaceNeedsAdjustments = SetAllowedSubRace( oPC, subRaceId );
    }

    if (subRaceNeedsAdjustments)
        SetLocalInt(oPC, STOP_ON_ENTER_STUFF, TRUE);
    else
        DeleteLocalInt(oPC, STOP_ON_ENTER_STUFF);

    if ( subRaceId == SUBRACE_ID_DWARF_ARTIC )
    {
        // Para simular el tamaño pequeño de la subraza Enano Artico
        // Al ingresar se le debe dar su forma de enano y se le debe agregar a su cola de LetoScripts
        // el cambio de apariencia a gnomo, para que al salir se ejecute y al momento de entrar, sea pequeño
        // Eso no se hace al salir porque la subraza no esta disponible con GetSubRace()
        SetCreatureAppearanceType( oPC, APPEARANCE_TYPE_DWARF );
        Leto_addScriptToPCStack(oPC, Leto_SetAppearanceType(APPEARANCE_TYPE_GNOME));

        DelayCommand(1.0, AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyDamageImmunity(IP_CONST_DAMAGETYPE_COLD, IP_CONST_DAMAGEIMMUNITY_100_PERCENT), GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPC)));
    }

    SetSubRaceLevelAdjustment( oPC );
}

void Races_onExit( object oPC );
void Races_onExit( object oPC )
{
}


