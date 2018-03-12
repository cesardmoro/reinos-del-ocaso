/************************** RdlC - REGLAS DE LA CASA **************************
08/03/07 Script By Dragoncin

Aplica las reglas de la casa

Scripts que incluyen a este:
- mod_onmoduleload
- mod_onlevelup
- mod_onrest
******************************************************************************/
#include "x2_inc_itemprop"
#include "prc_class_const"
#include "experience_inc"
#include "inc_item_props"
#include "Skills_sinergy"
#include "prc_feat_const"
#include "rdo_const_feat"
#include "competencias_inc"

///////////////////////////// CONSTANTES //////////////////////////////////////


const string RdlC_DATABASE = "reglas";
const string RdlC_Feats_DB_DOTES_FUERON_ENTREGADAS = "DOTES_FUERON_ENTREGADAS";

/////////////////////// DECLARACION PREVIA DE FUNCIONES ///////////////////////

//Define las clases restringidas y las guarda en una variable global
//Debe ser llamada desde el evento OnModuleLoad
void RdlC_StartUp();

//Chequea que el personaje no tenga mas rangos de skill que lo que deberia
//(por inyeccion de paquetes, overrides truchos, etc)
void RdlC_ChequearRangosDeSkills( object oPC );

//Impide toamr la clase Dragon Disciple sin tener el idioma Draconico
void RdlC_ChequearDragonDisciple( object oPC );

//Impide subir niveles y envia al mapa Perdedores si tiene una clase que solo
//puede tomarse en nivel 1, fuera de la primera posicion
int RdlC_ChequearClasesLevel1( object oPC );

//Chequear 2 prestiges
int RdlC_ChequearDosPrestiges( object oPC );

//Impide subir niveles en las clases monje, paladin y antipaladin, una vez que
//se tomo un nivel en otra clase
int RdlC_ChequearMulticlassRestringidas( object oPC );

//Inicia los chequeos
//Debe ser llamada desde el evento OnLevelUp
int RdlC_controlarReglasDeLaCasa( object oPC );

// Controla la experiencia del personaje con la guardada en la base de datos
void RdlC_controlXP( object oPC );

// Ajusta el fallo arcano de ciertas clases y dotes
void RdlC_ajustarFalloArcano( object oPC );


///////////////////////////////  FUNCIONES  /////////////////////////////////

int RdlC_chequearSkillsDeshabilitadas( object oPC )
{
    int noTieneSkillsDeshabilitadas = TRUE;
    RDO_RemoveEffectsByCreator(oPC, RDO_GetCreatorByTag(Skills_EFFECT_CREATOR));
    RDO_RemoveEffectsByCreator(oPC, RDO_GetCreatorByTag(Skills_Sinergy_EFFECT_CREATOR));
    if (GetSkillRank(SKILL_DISCIPLINE, oPC, TRUE) > 0 || GetSkillRank(SKILL_ANIMAL_EMPATHY, oPC, TRUE) > 0 || GetSkillRank(SKILL_PICK_POCKET, oPC, TRUE) > 0 ) {
        ResetLevel(oPC);
        SetLocalString(oPC, "rdlc_token", "Tienes puntos en una habilidad deshabilitada. Por favor, reloguea para que se reacomoden tus puntos.");
        AssignCommand(oPC, ActionStartConversation(oPC, "rdlc_conv", TRUE, FALSE));
        noTieneSkillsDeshabilitadas = FALSE;
    }
    Skills_Sinergy_applyGeneralSinergies( oPC );
    Skills_ajustarDisciplina( oPC );

    return noTieneSkillsDeshabilitadas;
}

// Controla el uso de la habilidad Use Magic Device por parte del clerigo
int RdlC_controlarUMDClerigo( object oPC );
int RdlC_controlarUMDClerigo( object oPC )
{
    int cumpleRegla = TRUE;
    if (GetLevelByClass(CLASS_TYPE_CLERIC, oPC) > 0) {
        int rangosUMD = GetSkillRank(SKILL_USE_MAGIC_DEVICE, oPC);
        // NOTA: todo este sistema se basa en que Use Magic Device es una habilidad que requiere entrenamiento
        if ( (rangosUMD > 0) &&
            (GetLevelByClass(CLASS_TYPE_ROGUE, oPC) == 0) &&
            (GetLevelByClass(CLASS_TYPE_BARD, oPC) == 0) &&
            (GetLevelByClass(CLASS_TYPE_MYSTIC_THEURGE, oPC) == 0) &&
            (!GetHasFeat(FEAT_MAGIC_DOMAIN_POWER, oPC))
           ) {
                ResetLevel(oPC);
                SetLocalString(oPC, "rdlc_token", "No puedes tomar puntos como clerigo en la habilidad Usar Objeto Magico si no tienes el Dominio Magia.");
                AssignCommand(oPC, ActionStartConversation(oPC, "rdlc_conv", TRUE, FALSE));
                cumpleRegla = FALSE;
             }
    }
    return cumpleRegla;
}


void RdlC_StartUp()
{
    object oModule = GetModule();

    SetLocalInt(oModule, "CantidadClasesRestringidasLevel1", 3);

    SetLocalInt(oModule, "ClaseRestringidaLevel1_1", CLASS_TYPE_MONK);
    SetLocalInt(oModule, "ClaseRestringidaLevel1_2", CLASS_TYPE_PALADIN);
    SetLocalInt(oModule, "ClaseRestringidaLevel1_3", CLASS_TYPE_ANTI_PALADIN);
}

void RdlC_ChequearRangosDeSkills( object oPC )
{
    int i;
    int iClase = GetClassByPosition(1, oPC);;
    int iNivelClase = GetLevelByPosition(1, oPC);
    int iRacialType = GetRacialType(oPC);
    int iCantidadRangosBase = StringToInt(Get2DAString("classes", "SkillPointBase", iClase));
    int iCantidadRangosMaxima;
    int iCantidadRangosActual = 0;
    int iCantidadRangosTemp;
    int iModificadorInt = (GetAbilityScore(oPC, ABILITY_INTELLIGENCE, TRUE)-10) / 2; //Modificador de inteligencia sin bonus

    iCantidadRangosBase += iModificadorInt;
    // Por lo menos debe tener 1 skill por nivel
    if (iCantidadRangosBase < 1 ) iCantidadRangosBase = 1;
    //Si es humano tiene mas skills
    if (iRacialType==RACIAL_TYPE_HUMAN) iCantidadRangosBase++;

    //Puntos de nivel 1
    iCantidadRangosMaxima = iCantidadRangosBase * 4;
    //SendMessageToPC(oPC, "Rangos de skill teoricos nivel 1: "+IntToString(iCantidadRangosMaxima));
    //resto de los niveles
    for (i=1; i<=3; i++) {
        iClase = GetClassByPosition(i, oPC);
        iNivelClase = GetLevelByPosition(i, oPC);
        if (i==1) iNivelClase--; //Descartar el nivel 1
        if (iNivelClase > 0) {
            iCantidadRangosBase = StringToInt(Get2DAString("classes", "SkillPointBase", iClase)) + iModificadorInt;
            if (iCantidadRangosBase < 1) iCantidadRangosBase = 1;
            if (iRacialType==RACIAL_TYPE_HUMAN) iCantidadRangosBase++;
            iCantidadRangosMaxima += iCantidadRangosBase * iNivelClase;
            //SendMessageToPC(oPC, "Rangos de skill teoricos clase "+IntToString(i)+": "+IntToString(iCantidadRangosBase * iNivelClase));
        }
    }
    // rangos de skill actuales
    for (i=0; i<=50; i++) {
        iCantidadRangosTemp = GetSkillRank(i, oPC, TRUE);
        if (iCantidadRangosTemp > 0)        //evita problemas si el personaje no tiene la habilidad
            iCantidadRangosActual += iCantidadRangosTemp;
    }

    if (iCantidadRangosActual > iCantidadRangosMaxima) {
        SendMessageToAllDMs("El personaje "+GetName(oPC)+" tiene mas skills de los debidos.");
        ResetLevel(oPC);
        SetLocalString(oPC, "rdlc_token", "Has tomado mas rangos de habilidad de los permitidos. Por favor, contacta un DM.");
        AssignCommand(oPC, ActionStartConversation(oPC, "rdlc_conv", TRUE, FALSE));
        return;
    }
}

void RdlC_ChequearDragonDisciple( object oPC )
{
    //Si ya tiene mas de 1 nivel de Dragon Disciple, ignorar el chequeo
    if (GetLevelByClass(37, oPC) > 1) {

        return;

    //Si esta tomando el primer nivel de la clase, buscar en el inventario el item del idioma draconico
    } else if (GetLevelByClass(37, oPC) == 1) {
    int PuedeTomarDD = FALSE;
        object oItem = GetFirstItemInInventory(oPC);
        while (oItem!=OBJECT_INVALID) {
            if (GetTag(oItem)=="rdlc_draconico") {
                PuedeTomarDD = TRUE;
            }
            oItem = GetNextItemInInventory(oPC);
        }
        //Si no posee el item, notificar al PJ y quitar el nivel
        if (PuedeTomarDD == FALSE) {
            ResetLevel(oPC);
            SetLocalString(oPC, "rdlc_token", "Para tomar la clase de prestigio Discipulo del Dragon debes aprender el idioma draconico. Para mas informacion, consulta un DM.");
            AssignCommand(oPC, ActionStartConversation(oPC, "rdlc_conv", TRUE, FALSE));
            return;
        }
    }
}

int RdlC_ChequearClasesLevel1( object oPC )
{
    int noTieneClaseTomableSoloNivel1 = TRUE;
    object oModule = GetModule();
    int i;
    string ClaseRestringida = "ClaseRestringidaLevel1_";

    for (i=1; i<=GetLocalInt(oModule, "CantidadClasesRestringidasLevel1"); i++) {
        ClaseRestringida = GetSubString(ClaseRestringida, 0, 23);
        ClaseRestringida += IntToString(i);

        if ( (GetClassByPosition(2, oPC)==GetLocalInt(oModule, ClaseRestringida)) || (GetClassByPosition(3, oPC)==GetLocalInt(oModule, ClaseRestringida)) ) {
            ResetLevel(oPC);
            SetLocalString(oPC, "rdlc_token", "La clase que elegiste solo puede ser tomada en nivel 1.");
            AssignCommand(oPC, ActionStartConversation(oPC, "rdlc_conv", TRUE, FALSE));
            noTieneClaseTomableSoloNivel1 = FALSE;
        }
    }
    return noTieneClaseTomableSoloNivel1;
}

int RdlC_ChequearMulticlassRestringidas( object oPC )
{
    int noTieneMulticlaseRestringida = TRUE;

    object oModule = GetModule();
    int i;
    string ClaseRestringida = "ClaseRestringidaLevel1_";
    int TieneClaseRestringida = FALSE;
    string sName = GetStringLeft(GetName(oPC), 20);

    for (i=1; i<=GetLocalInt(oModule, "CantidadClasesRestringidasLevel1"); i++) {
        ClaseRestringida = GetSubString(ClaseRestringida, 0, 23);
        ClaseRestringida += IntToString(i);

        if (GetClassByPosition(1, oPC)==GetLocalInt(oModule, ClaseRestringida)) {
            TieneClaseRestringida = TRUE;
        }

   }

    //Si tiene una clase restringida...
    if (TieneClaseRestringida == TRUE) {

        int LevelDB = GetCampaignInt("rdlc", "NivelPrimeraClase", oPC);
        //Si el nivel de la primera clase supera al nivel guardado en la DB, retirar el nivel
        if ( (GetLevelByPosition(1, oPC) > LevelDB) && (LevelDB > 0) ) {
            ResetLevel(oPC);
            SetLocalString(oPC, "rdlc_token", "Te has alejado del camino de tu clase principal. Una regla de la casa te impide volvera  tomar niveles de esa clase. Si tienes dudas, por favor contacta un DM.");
            AssignCommand(oPC, ActionStartConversation(oPC, "rdlc_conv", TRUE, FALSE));
            noTieneMulticlaseRestringida = FALSE;
        } else {

            //Si la segunda clase no es una clase de prestigio...
            if (GetClassByPosition(2, oPC) < 11) {

                //Si tiene un solo nivel, es la primera vez que la toma...
                if (GetLevelByPosition(2, oPC) == 1) {
                    //Guarda en la base de datos el nivel maximo que puede tomar en la clase 1
                    SetCampaignInt("rdlc", "NivelPrimeraClase", GetLevelByPosition(1, oPC), oPC);
                    SetLocalString(oPC, "rdlc_token", "Te has alejado del camino de tu clase principal. Ya no podras tomar mas niveles de dicha clase.");
                    AssignCommand(oPC, ActionStartConversation(oPC, "rdlc_conv", TRUE, FALSE));
                }

            //Si la segunda es una clase de prestigio, chequear la tercera...
            } else {
                //Si la tercera es clase de prestigio...
                if ( (GetLevelByPosition(3, oPC) > 0) && (GetClassByPosition(3, oPC) > 10) && (GetClassByPosition(3, oPC)!=CLASS_TYPE_ARCHER) ) {
                    //Quitar el nivel por tener 2 clases de prestigio
                    ResetLevel(oPC);
                    SetLocalString(oPC, "rdlc_token", "Solo puedes tomar una clase de prestigio.");
                    AssignCommand(oPC, ActionStartConversation(oPC, "rdlc_conv", TRUE, FALSE));
                    noTieneMulticlaseRestringida = FALSE;
                //Si la tercera no es clase de prestigio y es el primer nivel...
                } else if (GetLevelByPosition(3, oPC) == 1) {
                    //Guarda en la base de datos el nivel maximo que puede tomar en la clase 1
                    SetCampaignInt("rdlc", "NivelPrimeraClase", GetLevelByPosition(1, oPC), oPC);
                    SetLocalString(oPC, "rdlc_token", "Te has alejado del camino de tu clase principal. Ya no podras tomar mas niveles de dicha clase.");
                    AssignCommand(oPC, ActionStartConversation(oPC, "rdlc_conv", TRUE, FALSE));
                }
            }
        }
    }
    return noTieneMulticlaseRestringida;
}

int RdlC_ChequearDosPrestiges( object oPC )
{
    int noTiene2prestiges = TRUE;
    if ( (GetLevelByPosition(2, oPC) > 0) && (GetLevelByPosition(3, oPC) > 0) ) {
        int Clase2 = GetClassByPosition(2, oPC);
        int Clase3 = GetClassByPosition(3, oPC);
        if ( (Clase2 > 10) && (Clase3 > 10) &&
             (Clase2 != CLASS_TYPE_ARCHER) && (Clase3 != CLASS_TYPE_ARCHER) &&
             (Clase2 != CLASS_TYPE_ANTI_PALADIN) && (Clase3 != CLASS_TYPE_ANTI_PALADIN) &&
             (Clase2 != CLASS_TYPE_SWASHBUCKLER) && (Clase3 != CLASS_TYPE_SWASHBUCKLER)
            ) {
            ResetLevel(oPC);
            SetLocalString(oPC, "rdlc_token", "No puedes tomar 2 clases de prestigio.");
            AssignCommand(oPC, ActionStartConversation(oPC, "rdlc_conv", TRUE, FALSE));
            noTiene2prestiges = FALSE;
        }
    }
    return noTiene2prestiges;
}

// Devuelve si oPC cumple con las reglas de la casa
// En caso de no cumplirlas, le quita el nivel
int RdlC_controlarReglasDeLaCasa( object oPC );
int RdlC_controlarReglasDeLaCasa( object oPC )
{
    int cumpleReglasDeLaCasa = RdlC_ChequearDosPrestiges(oPC);
    cumpleReglasDeLaCasa += RdlC_ChequearClasesLevel1(oPC);
    cumpleReglasDeLaCasa += RdlC_ChequearMulticlassRestringidas(oPC);
    //cumpleReglasDeLaCasa += RdlC_ChequearDragonDisciple(oPC); //Desactivado porque ahora esta chequeado en "prc_prereq"
    //cumpleReglasDeLaCasa += RdlC_ChequearRangosDeSkills(oPC);
    cumpleReglasDeLaCasa += RdlC_controlarUMDClerigo(oPC);
    cumpleReglasDeLaCasa += RdlC_chequearSkillsDeshabilitadas(oPC);

    return (cumpleReglasDeLaCasa > 0);
}

void RdlC_controlXP( object oPC )
{
    int databaseXP = GetCampaignInt("Xp", "Xp", oPC);
    int playerXP = GetXP(oPC);

    if (playerXP != databaseXP) {
        SetXP(oPC, databaseXP);
        SendMessageToAllDMs("El personaje "+GetName(oPC)+" tenia mal su experiencia.");
        SendMessageToAllDMs("XPactual= "+IntToString(playerXP)+"; XPdb= "+IntToString(databaseXP));
    }
}


const int ARMADURA_LIGERA = 1;
const int ARMADURA_MEDIA  = 2;
const int ARMADURA_PESADA = 3;

//Devuelve el tipo de armadura que puede usar un personaje sin fallo arcano
int RdlC_GetTipoArmaduraPermitidaSinFalloArcano( object oPC );
int RdlC_GetTipoArmaduraPermitidaSinFalloArcano( object oPC )
{
    int nivelBardo = GetLevelByClass(CLASS_TYPE_BARD, oPC);
    int nivelMago = GetLevelByClass(CLASS_TYPE_WIZARD, oPC);
    int nivelHechicero = GetLevelByClass(CLASS_TYPE_SORCERER, oPC);
    int nivelMinstrel = GetLevelByClass(CLASS_TYPE_MINSTREL_EDGE, oPC);
    int nivelBladesinger = GetLevelByClass(CLASS_TYPE_BLADESINGER, oPC);
    int doteBattleCaster = GetHasFeat(FEAT_BATTLECASTER, oPC);
    int reduccionFalloArcano;

    int tipoArmaduraPermitida = (nivelBardo > 0 && nivelMago == 0 && nivelHechicero == 0) ? 1 : 0;
    tipoArmaduraPermitida += (nivelMinstrel > 0) ? 1 : 0;
    tipoArmaduraPermitida += (nivelBladesinger > 5) ? 1 : 0;
    // El chequeo de la dote Battle Caster debe hacerse al final, porque para que sirva, se debe tener la habilidad para lanzar conjuros con armadura
    tipoArmaduraPermitida += (doteBattleCaster && tipoArmaduraPermitida > 0) ? 1 : 0;
    // El máximo son las armaduras pesadas, asi que si un personaje ya tiene de mas, lo acotamos
    tipoArmaduraPermitida = (tipoArmaduraPermitida > 3) ? 3 : tipoArmaduraPermitida;

    return tipoArmaduraPermitida;
}

// Aplica los bonificadores de Fallo arcano para las clases, incluyendo al bardo
void RdlC_ajustarFalloArcano( object oPC )
{
    object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPC);
    int tipoArmaduraPermitida = RdlC_GetTipoArmaduraPermitidaSinFalloArcano(oPC);

    object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
    int baseAC = GetBaseAC(oArmor);
    if ( (baseAC > 5 && tipoArmaduraPermitida == ARMADURA_PESADA) ||
         (baseAC > 4 && baseAC <= 5 && tipoArmaduraPermitida >= ARMADURA_MEDIA) ||
         (baseAC > 0 && baseAC <= 4 && tipoArmaduraPermitida >= ARMADURA_LIGERA)
        )
    {
        int counterSpellFailure = -1;
        switch (baseAC) {
            case 1:                 counterSpellFailure = IP_CONST_ARCANE_SPELL_FAILURE_MINUS_5_PERCENT; break;
            case 2:                 counterSpellFailure = IP_CONST_ARCANE_SPELL_FAILURE_MINUS_10_PERCENT; break;
            case 3:                 counterSpellFailure = IP_CONST_ARCANE_SPELL_FAILURE_MINUS_15_PERCENT; break;
            case 4:                 counterSpellFailure = IP_CONST_ARCANE_SPELL_FAILURE_MINUS_20_PERCENT; break;
            case 5:                 counterSpellFailure = IP_CONST_ARCANE_SPELL_FAILURE_MINUS_30_PERCENT; break;
            case 6:                 counterSpellFailure = IP_CONST_ARCANE_SPELL_FAILURE_MINUS_40_PERCENT; break;
            case 7:                 counterSpellFailure = IP_CONST_ARCANE_SPELL_FAILURE_MINUS_40_PERCENT; break;
            case 8:                 counterSpellFailure = IP_CONST_ARCANE_SPELL_FAILURE_MINUS_35_PERCENT; break;
        }
        if (counterSpellFailure != -1)
            IPSafeAddItemProperty(oSkin, ItemPropertyArcaneSpellFailure(counterSpellFailure));
    }
    else if (tipoArmaduraPermitida > 0)
    {
        IPRemoveMatchingItemProperties(oSkin, ITEM_PROPERTY_ARCANE_SPELL_FAILURE, DURATION_TYPE_PERMANENT);
    }
    //SendMessageToPC(oPC, "[FalloArcano] tipoArmaduraPermitid= "+IntToString(tipoArmaduraPermitida)+"; reduccionFalloArcano= "+IntToString(reduccionFalloArcano));
}

// Si oPC tiene una cabeza prohibida, le asigna una cabeza estandar
void RdlC_reformarCabezasProhibidas( object oPC )
{
    if (GetRacialType(oPC) == RACIAL_TYPE_HUMAN)
    {
        if (GetGender(oPC) == GENDER_MALE)
        {
            if (GetCreatureBodyPart(CREATURE_PART_HEAD, oPC) == 20)
                SetCreatureBodyPart(CREATURE_PART_HEAD, 1, oPC);
        }
        else
        {
            if (GetCreatureBodyPart(CREATURE_PART_HEAD, oPC) == 14)
                SetCreatureBodyPart(CREATURE_PART_HEAD, 1, oPC);
        }
    }
}

void RdlC_onEnter( object oPC );
void RdlC_onEnter( object oPC )
{
    object piel = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPC);

    //Bonificador de clase de armadura AC de la clase Monje
    int nivelMonje = GetLevelByClass(CLASS_TYPE_MONK, oPC);
    if(nivelMonje > 0) {
        // Al asignar una division a una variable entera, se truncan los decimales. Es decir, 4 / 5 = 0.8 = 0.
        int monkBonusAC = nivelMonje / 5;
        DelayCommand(3.0, AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyACBonus(monkBonusAC) , GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPC)));
    }
    RdlC_reformarCabezasProhibidas( oPC );
}


// Aplica las penas por dormir con armadura
// Esta consiste en:
// Pena de -2 a Destreza y Fuerza
// Reduccion de un 10% de la velocidad
// Todo hasta el proximo descanso o que se quite alguna de las propiedades con un conjuro (Restoration/Freedom of Movemente)
void RdlC_penaPorDormirConArmadura( object oPC );
void RdlC_penaPorDormirConArmadura( object oPC )
{
    object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
    if (GetBaseAC(oArmor) > 4) {
        effect efectos = EffectAbilityDecrease(ABILITY_STRENGTH, 2);
        efectos = EffectLinkEffects(efectos, EffectAbilityDecrease(ABILITY_DEXTERITY, 2));
        efectos = EffectLinkEffects(efectos, EffectMovementSpeedDecrease(10));
        efectos = ExtraordinaryEffect(efectos);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, efectos, oPC);
        FloatingTextStringOnCreature("Te despiertas luego de un pesimo sueño por acostarte con tu armadura. Te duele todo el cuerpo y te cuesta moverte.", oPC, FALSE);
    }
}


// Usa el Leto para guardar como puntos de skill libres los puntos de las habilidades deshabilitadas
void RdlC_recuperarSkillsDeshabilitadas( object oPC );
void RdlC_recuperarSkillsDeshabilitadas( object oPC )
{
    int spareSkills;

    int disciplina = GetSkillRank(SKILL_DISCIPLINE, oPC, TRUE);
    if (disciplina > 0)
    {
        Leto_addScriptToPCStack(oPC, Leto_SetSkill(SKILL_DISCIPLINE, 0, 1));
        spareSkills += disciplina;
    }

    int pickPocket = GetSkillRank(SKILL_PICK_POCKET, oPC, TRUE);
    if (pickPocket > 0)
    {
        Leto_addScriptToPCStack(oPC, Leto_SetSkill(SKILL_PICK_POCKET, 0, 1));
        Leto_addScriptToPCStack(oPC, Leto_AdjustSkill(SKILL_SLEIGHT_OF_HAND, pickPocket, 1));
    }

    int animalEmpathy = GetSkillRank(SKILL_ANIMAL_EMPATHY, oPC, TRUE);
    if (animalEmpathy > 0)
    {
        Leto_addScriptToPCStack(oPC, Leto_SetSkill(SKILL_ANIMAL_EMPATHY, 0, 1));
        Leto_addScriptToPCStack(oPC, Leto_AdjustSkill(SKILL_HANDLE_ANIMAL, animalEmpathy, 1));
    }

    int lore = GetSkillRank(SKILL_LORE, oPC, TRUE);
    if (lore > 0)
    {
        Leto_addScriptToPCStack(oPC, Leto_SetSkill(SKILL_LORE, 0, 1));
        spareSkills += lore;
    }

    if (spareSkills > 0)
        Leto_addScriptToPCStack(oPC, Leto_AdjustSpareSkill(spareSkills, 1));

}

const string RdlC_DisabledSkills_EFFECT_CREATOR = "DisabledSkills_EFFECT_CREATOR";

void RdlC_AplicarPenasASkillsDeshabilitadas( object oPC );
void RdlC_AplicarPenasASkillsDeshabilitadas( object oPC )
{
    object creadorPenas = RDO_GetCreatorByTag(RdlC_DisabledSkills_EFFECT_CREATOR);
    RDO_RemoveEffectsByCreator(oPC, creadorPenas);
    effect eLink = EffectSkillDecrease(SKILL_ANIMAL_EMPATHY, 20);
    eLink = EffectLinkEffects(eLink, EffectSkillDecrease(SKILL_PICK_POCKET, 20));
    //eLink = EffectLinkEffects(eLink, EffectSkillDecrease(SKILL_LORE, 20));
    eLink = SupernaturalEffect(eLink);

    AssignCommand(creadorPenas, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC));
}

// Usa el Leto para entregar ciertas dotes gratuitas del módulo
void RdlC_entregarDotesGratuitas( object oPC );
void RdlC_entregarDotesGratuitas( object oPC )
{
    if (GetHitDice(oPC) > 1) {
        if (GetLevelByClass(CLASS_TYPE_ROGUE, oPC) > 0 && !GetHasFeat(FEAT_SHADOW_LORD_CONVO, oPC))
            Leto_addScriptToPCStack(oPC, Leto_AddFeat(FEAT_SHADOW_LORD_CONVO, 1));

        // ACP_Fighting_Styles
        if (!GetHasFeat(FEAT_ACP_FIGHTING_STYLES, oPC))
            Leto_addScriptToPCStack(oPC, Leto_AddFeat(FEAT_ACP_FIGHTING_STYLES, 1));

        // Cabalgar
        if (!GetHasFeat(FEAT_RIDE, oPC))
            Leto_addScriptToPCStack(oPC, Leto_AddFeat(FEAT_RIDE, 1));

        // volar
        if (!GetHasFeat(FEAT_FLY, oPC))
            Leto_addScriptToPCStack(oPC, Leto_AddFeat(FEAT_FLY, 1));

        // Cargar
        if (!GetHasFeat(FEAT_CHARGE, oPC))
            Leto_addScriptToPCStack(oPC, Leto_AddFeat(FEAT_CHARGE, 1));

        // Armored Spellcasting (sirve de requisito para Battle Caster)
        if ((GetLevelByClass(CLASS_TYPE_BARD, oPC) > 0 || GetLevelByClass(CLASS_TYPE_BLADESINGER, oPC) >= 6) && !GetHasFeat(FEAT_ARMORED_SPELLCASTING, oPC))
            Leto_addScriptToPCStack(oPC, Leto_AddFeat(FEAT_ARMORED_SPELLCASTING, 1));
    }

    // Competencia con hacha enana para los enanos que tengan competencia con armas marciales
    if (GetRacialType(oPC)==RACIAL_TYPE_DWARF && GetHasFeat(FEAT_WEAPON_PROFICIENCY_MARTIAL, oPC) && !GetHasFeat(Item_WEAPON_PROFICIENCY_EXOTIC_BASEVALUE+BASE_ITEM_DWARVENWARAXE, oPC)) {
        FloatingTextStringOnCreature("Puedes reloguear si deseas tomar Soltura con Hacha Enana para obtener la competencia gratis sin que necesites gastar una dote.", oPC);
        Leto_addScriptToPCStack(oPC, Leto_AddFeat(Item_WEAPON_PROFICIENCY_EXOTIC_BASEVALUE+BASE_ITEM_DWARVENWARAXE));
    }
}

