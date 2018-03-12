//////////////////
// 13/05/07 Script By Dragoncin
//
// Sistema de competencias con armas y escudos.
// Aplica la pena correcta por usar un arma o escudo sin su correspondiente competencia.
// Funciona en conjunto con un cambio en el baseitems.2da que permite equipar cualquier tipo de arma o escudo
// sin tener la competencia necesaria.
//
// Afecta los eventos:
// - onEquip
// - onUnequip
// - onClientEnter
/////////////////

#include "RDO_const_feat"
#include "RDO_const_skill"
#include "inc_item_props"
#include "RDO_SpInc"
#include "Item_inc"
#include "x2_inc_itemprop"

const string Competencias_hasArmorProfLight_VN      = "Profs_hasArmorProfLight";
const string Competencias_hasArmorProfMedium_VN     = "Profs_hasArmorProfMedium";
const string Competencias_hasArmorProfHeavy_VN      = "Profs_hasArmorProfHeavy";

// Nota: la longitud de EFFECT_CREATOR+TIPO_ITEM_* no puede superar el maximo para un Tag
const string Competencias_effectCreator_RN          = "Profs_effectCreator";
const string Competencias_tipoItemAmbasManos_RN     = "AmbasManos";
const string Competencias_tipoItemArmaIzquierda_RN  = "ManoIzquierda";
const string Competencias_tipoItemArmaDerecha_RN    = "ManoDerecha";
const string Competencias_skillsEffectCreator_RN    = "Skills";

// Este sistema requiere aplicarle un penalizador al ataque a cada mano por separado
// Por ende, es necesario distinguirlos de alguna manera. Como se usa un efecto, una opcion es distinguirlos
// por el creador del efecto.

// Devuelve el creador del efecto que baja el ataque para la mano correspondiente
// Las manos son Competencias_tipoItemAmbasManos_RN, Competencias_tipoItemArmaDerecha_RN y Competencias_tipoItemArmaIzquierda_RN
// Devuelve OBJECT_INVALID en caso de error
object Competencias_GetEffectCreator( string mano );
object Competencias_GetEffectCreator( string mano )
{
    object oModule = GetModule();
    // El nombre de la variable de modulo del creador es igual a su tag
    string identificador = Competencias_effectCreator_RN+mano;
    object creadorEfectos = GetLocalObject(oModule, identificador);
    if (!GetIsObjectValid(creadorEfectos)) {
        creadorEfectos = GetObjectByTag(identificador);
        SetLocalObject(oModule, identificador, creadorEfectos);
    }
    if (!GetIsObjectValid(creadorEfectos))
        SendMessageToPC(GetFirstPC(), identificador+" no encontrado");
    return creadorEfectos;
}


// Proficiencias necesarias (con una de las mencionadas alcanza para usar el arma sin problemas)
const int Item_WEAPON_PROFICIENCY_SIMPLE                            = 1;
const int Item_WEAPON_PROFICIENCY_MARTIAL                           = 2;
const int Item_WEAPON_PROFICIENCY_EXOTIC                            = 3;
const int Item_WEAPON_PROFICIENCY_SIMPLE_DRUID_MONK_ROGUE_WIZARD    = 4;
const int Item_WEAPON_PROFICIENCY_MARTIAL_MONK_ROGUE                = 5;
const int Item_WEAPON_PROFICIENCY_SIMPLE_MONK_ROGUE_WIZARD          = 6;
const int Item_WEAPON_PROFICIENCY_SIMPLE_ROGUE                      = 7;
const int Item_WEAPON_PROFICIENCY_MARTIAL_ELF_ROGUE                 = 8;
const int Item_WEAPON_PROFICIENCY_MARTIAL_DRUID                     = 9;
const int Item_WEAPON_PROFICIENCY_SIMPLE_DRUID                      = 10;
const int Item_WEAPON_PROFICIENCY_MARTIAL_ROGUE                     = 11;
const int Item_WEAPON_PROFICIENCY_SIMPLE_DRUID_ROGUE                = 12;
const int Item_WEAPON_PROFICIENCY_MARTIAL_ELF                       = 13;
const int Item_WEAPON_PROFICIENCY_SIMPLE_DRUID_MONK_ROGUE           = 14;
const int Item_WEAPON_PROFICIENCY_SHURIKEN                          = 15;

// Linea del feats.2da a partir de la cual se suman los indices del baseitems.2da para cada tipo de arma exotica
const int Item_WEAPON_PROFICIENCY_EXOTIC_BASEVALUE  = 5200;

// Devuelve el tipo de proficiencia necesaria para usar oItem
// con la forma Item_WEAPON_PROFICIENCY_* si no es exotica.
// Si es exotica, devuelve el identificador de la dote necesaria.
// En caso de error devuelve -1
int Competencias_GetWeaponProficiencyNeeded( object oItem );
int Competencias_GetWeaponProficiencyNeeded( object oItem )
{
    int tipoProficiencia = -1;
    switch (GetBaseItemType(oItem)) {
            case BASE_ITEM_BATTLEAXE:
            case BASE_ITEM_GREATAXE:
            case BASE_ITEM_GREATSWORD:
            case BASE_ITEM_HALBERD:
            case BASE_ITEM_HEAVYFLAIL:
            case BASE_ITEM_LIGHTFLAIL:
            case BASE_ITEM_LIGHTHAMMER:
            case BASE_ITEM_THROWINGAXE:
            case BASE_ITEM_WARHAMMER:       tipoProficiencia = Item_WEAPON_PROFICIENCY_MARTIAL; break;
            case BASE_ITEM_LONGBOW:
            case BASE_ITEM_LONGSWORD:       tipoProficiencia = Item_WEAPON_PROFICIENCY_MARTIAL_ELF; break;
            case BASE_ITEM_CLUB:
            case BASE_ITEM_DAGGER:
            case BASE_ITEM_QUARTERSTAFF:    tipoProficiencia = Item_WEAPON_PROFICIENCY_SIMPLE_DRUID_MONK_ROGUE_WIZARD; break;
            case BASE_ITEM_DART:            tipoProficiencia = Item_WEAPON_PROFICIENCY_SIMPLE_DRUID_ROGUE; break;
            case BASE_ITEM_HANDAXE:         tipoProficiencia = Item_WEAPON_PROFICIENCY_MARTIAL_MONK_ROGUE; break;
            case BASE_ITEM_HEAVYCROSSBOW:
            case BASE_ITEM_LIGHTCROSSBOW:   tipoProficiencia = Item_WEAPON_PROFICIENCY_SIMPLE_MONK_ROGUE_WIZARD; break;
            case BASE_ITEM_LIGHTMACE:
            case BASE_ITEM_MORNINGSTAR:     tipoProficiencia = Item_WEAPON_PROFICIENCY_SIMPLE_ROGUE; break;
            case BASE_ITEM_SHORTBOW:
            case BASE_ITEM_RAPIER:          tipoProficiencia = Item_WEAPON_PROFICIENCY_MARTIAL_ELF_ROGUE; break;
            case BASE_ITEM_SCIMITAR:        tipoProficiencia = Item_WEAPON_PROFICIENCY_MARTIAL_DRUID; break;
            case BASE_ITEM_SHORTSPEAR:      tipoProficiencia = Item_WEAPON_PROFICIENCY_SIMPLE_DRUID; break;
            case BASE_ITEM_SHORTSWORD:      tipoProficiencia = Item_WEAPON_PROFICIENCY_MARTIAL_ROGUE; break;
            case BASE_ITEM_SLING:           tipoProficiencia = Item_WEAPON_PROFICIENCY_SIMPLE_DRUID_MONK_ROGUE; break;
            case BASE_ITEM_BASTARDSWORD:    tipoProficiencia = Item_WEAPON_PROFICIENCY_EXOTIC_BASEVALUE+BASE_ITEM_BASTARDSWORD; break;
            case BASE_ITEM_DIREMACE:        tipoProficiencia = Item_WEAPON_PROFICIENCY_EXOTIC_BASEVALUE+BASE_ITEM_DIREMACE; break;
            case BASE_ITEM_DOUBLEAXE:       tipoProficiencia = Item_WEAPON_PROFICIENCY_EXOTIC_BASEVALUE+BASE_ITEM_DOUBLEAXE; break;
            case BASE_ITEM_DWARVENWARAXE:   tipoProficiencia = Item_WEAPON_PROFICIENCY_EXOTIC_BASEVALUE+BASE_ITEM_DWARVENWARAXE; break;
            case BASE_ITEM_KATANA:          tipoProficiencia = Item_WEAPON_PROFICIENCY_EXOTIC_BASEVALUE+BASE_ITEM_KATANA; break;
            case BASE_ITEM_KUKRI:           tipoProficiencia = Item_WEAPON_PROFICIENCY_EXOTIC_BASEVALUE+BASE_ITEM_KUKRI; break;
            case BASE_ITEM_SCYTHE:          tipoProficiencia = Item_WEAPON_PROFICIENCY_EXOTIC_BASEVALUE+BASE_ITEM_SCYTHE; break;
            case BASE_ITEM_SHURIKEN:        tipoProficiencia = Item_WEAPON_PROFICIENCY_SHURIKEN; break;
            case BASE_ITEM_TWOBLADEDSWORD:  tipoProficiencia = Item_WEAPON_PROFICIENCY_EXOTIC_BASEVALUE+BASE_ITEM_TWOBLADEDSWORD; break;
            case BASE_ITEM_WHIP:            tipoProficiencia = Item_WEAPON_PROFICIENCY_EXOTIC_BASEVALUE+BASE_ITEM_WHIP; break;
    }
    /* Nota: las proficiencias exoticas, por comodidad valen un valor base
             mas la constante de tipo basico, cosa que debe ser respetada en el
             feat.2da.*/
    //if (tipoProficiencia==-1) SendMessageToPC(GetFirstPC(), "Error: proficiencia no encontrada");
    return tipoProficiencia;
}

// Devuelve si oPC tiene competencia con el arma oWeapon
int GetIsCreatureProficientWithWeapon( object oPC, object oWeapon );
int GetIsCreatureProficientWithWeapon( object oPC, object oWeapon )
{
    int isProficient = TRUE;
    // Nota por dragoncin: Esto es poco elegante, pero no encontre una mejor manera de hacerlo
    if (Item_GetIsMeleeWeapon(oWeapon) || GetWeaponRanged(oWeapon))
    {
        int proficiency = Competencias_GetWeaponProficiencyNeeded(oWeapon);
        //SendMessageToPC(oPC, "Competencias_GetWeaponProficiencyNeeded= "+IntToString(proficiency));
        switch (proficiency) {
            case Item_WEAPON_PROFICIENCY_SIMPLE:                            isProficient = (GetHasFeat(FEAT_WEAPON_PROFICIENCY_SIMPLE, oPC)) ? TRUE: FALSE; break;
            case Item_WEAPON_PROFICIENCY_MARTIAL:                           isProficient = (GetHasFeat(FEAT_WEAPON_PROFICIENCY_MARTIAL, oPC)) ? TRUE: FALSE; break;
            case Item_WEAPON_PROFICIENCY_SIMPLE_DRUID_MONK_ROGUE_WIZARD:    isProficient = (GetHasFeat(FEAT_WEAPON_PROFICIENCY_SIMPLE, oPC) || GetHasFeat(FEAT_WEAPON_PROFICIENCY_DRUID, oPC) || GetHasFeat(FEAT_WEAPON_PROFICIENCY_MONK, oPC) || GetHasFeat(FEAT_WEAPON_PROFICIENCY_ROGUE, oPC) || GetHasFeat(FEAT_WEAPON_PROFICIENCY_WIZARD, oPC)) ? TRUE: FALSE; break;
            case Item_WEAPON_PROFICIENCY_MARTIAL_MONK_ROGUE:                isProficient = (GetHasFeat(FEAT_WEAPON_PROFICIENCY_MARTIAL, oPC) || GetHasFeat(FEAT_WEAPON_PROFICIENCY_MONK, oPC) || GetHasFeat(FEAT_WEAPON_PROFICIENCY_ROGUE, oPC)) ? TRUE: FALSE; break;
            case Item_WEAPON_PROFICIENCY_SIMPLE_MONK_ROGUE_WIZARD:          isProficient = (GetHasFeat(FEAT_WEAPON_PROFICIENCY_SIMPLE, oPC) || GetHasFeat(FEAT_WEAPON_PROFICIENCY_MONK, oPC) || GetHasFeat(FEAT_WEAPON_PROFICIENCY_ROGUE, oPC) || GetHasFeat(FEAT_WEAPON_PROFICIENCY_WIZARD, oPC)) ? TRUE: FALSE; break;
            case Item_WEAPON_PROFICIENCY_SIMPLE_ROGUE:                      isProficient = (GetHasFeat(FEAT_WEAPON_PROFICIENCY_SIMPLE, oPC) || GetHasFeat(FEAT_WEAPON_PROFICIENCY_ROGUE, oPC)) ? TRUE: FALSE; break;
            case Item_WEAPON_PROFICIENCY_MARTIAL_ELF_ROGUE:                 isProficient = (GetHasFeat(FEAT_WEAPON_PROFICIENCY_MARTIAL, oPC) || GetHasFeat(FEAT_WEAPON_PROFICIENCY_ELF, oPC) || GetHasFeat(FEAT_WEAPON_PROFICIENCY_ROGUE, oPC)) ? TRUE: FALSE; break;
            case Item_WEAPON_PROFICIENCY_MARTIAL_DRUID:                     isProficient = (GetHasFeat(FEAT_WEAPON_PROFICIENCY_MARTIAL, oPC) || GetHasFeat(FEAT_WEAPON_PROFICIENCY_DRUID, oPC)) ? TRUE: FALSE; break;
            case Item_WEAPON_PROFICIENCY_SIMPLE_DRUID:                      isProficient = (GetHasFeat(FEAT_WEAPON_PROFICIENCY_SIMPLE, oPC) || GetHasFeat(FEAT_WEAPON_PROFICIENCY_DRUID, oPC)) ? TRUE: FALSE; break;
            case Item_WEAPON_PROFICIENCY_MARTIAL_ROGUE:                     isProficient = (GetHasFeat(FEAT_WEAPON_PROFICIENCY_MARTIAL, oPC) || GetHasFeat(FEAT_WEAPON_PROFICIENCY_ROGUE, oPC)) ? TRUE: FALSE; break;
            case Item_WEAPON_PROFICIENCY_SIMPLE_DRUID_ROGUE:                isProficient = (GetHasFeat(FEAT_WEAPON_PROFICIENCY_SIMPLE, oPC) || GetHasFeat(FEAT_WEAPON_PROFICIENCY_DRUID, oPC) || GetHasFeat(FEAT_WEAPON_PROFICIENCY_ROGUE, oPC)) ? TRUE: FALSE; break;
            case Item_WEAPON_PROFICIENCY_MARTIAL_ELF:                       isProficient = (GetHasFeat(FEAT_WEAPON_PROFICIENCY_MARTIAL, oPC) || GetHasFeat(FEAT_WEAPON_PROFICIENCY_ELF, oPC)) ? TRUE: FALSE; break;
            case Item_WEAPON_PROFICIENCY_SIMPLE_DRUID_MONK_ROGUE:           isProficient = (GetHasFeat(FEAT_WEAPON_PROFICIENCY_SIMPLE, oPC) || GetHasFeat(FEAT_WEAPON_PROFICIENCY_DRUID, oPC) || GetHasFeat(FEAT_WEAPON_PROFICIENCY_MONK, oPC) || GetHasFeat(FEAT_WEAPON_PROFICIENCY_ROGUE, oPC)) ? TRUE: FALSE; break;
            case (Item_WEAPON_PROFICIENCY_EXOTIC_BASEVALUE+BASE_ITEM_DWARVENWARAXE):
                                                                            isProficient = (GetHasFeat(proficiency, oPC) || (GetRacialType(oPC)==RACIAL_TYPE_DWARF && GetHasFeat(FEAT_WEAPON_PROFICIENCY_MARTIAL, oPC))); break;
            case Item_WEAPON_PROFICIENCY_SHURIKEN:                          isProficient = (GetHasFeat(Item_WEAPON_PROFICIENCY_EXOTIC_BASEVALUE+BASE_ITEM_SHURIKEN, oPC) || GetHasFeat(FEAT_WEAPON_PROFICIENCY_MONK, oPC)); break;
            default:                                                        isProficient = GetHasFeat(proficiency, oPC);
        }
        //SendMessageToPC(oPC, "hasFeat= "+IntToString(GetHasFeat(proficiency, oPC)));
    }
    //SendMessageToPC(oPC, "isProficient= "+IntToString(isProficient));
    return isProficient;
}

// Devuelve si oPC tiene competencia con la armadura oArmor
int GetIsCreatureProficientWithArmor( object oPC, object oArmor );
int GetIsCreatureProficientWithArmor( object oPC, object oArmor )
{
    int isProficient;
    if (GetBaseItemType(oArmor)==BASE_ITEM_ARMOR)
    {
        int baseAC = GetBaseAC(oArmor);
        /*  Las competencias no se rigen por dotes sino por una variable que se guarda
            en el evento onEnter del personaje. De esta manera se puede agregar todas las
            dotes de competencia en la piel del personaje y este se puede equipar todas
            las armaduras.  */
        if (baseAC > 5) // Heavy Armor
            isProficient = GetLocalInt(oPC, Competencias_hasArmorProfHeavy_VN);
        else if (baseAC > 3) // Medium Armor
            isProficient = GetLocalInt(oPC, Competencias_hasArmorProfMedium_VN);
        else if (baseAC > 0) // Light Armor
            isProficient = GetLocalInt(oPC, Competencias_hasArmorProfLight_VN);
    }
    return isProficient;
}

// En base a la armadura y escudo equipados, aplica las penas a los skills que
void Competencias_aplicarPenalizadoresSkills( object oPC, object objetoManoDerecha = OBJECT_INVALID, object objetoManoIzquierda = OBJECT_INVALID );
void Competencias_aplicarPenalizadoresSkills( object oPC, object objetoManoDerecha = OBJECT_INVALID, object objetoManoIzquierda = OBJECT_INVALID )
{
    object skillsEffectCreator = Competencias_GetEffectCreator(Competencias_skillsEffectCreator_RN);
    RDO_RemoveEffectsByCreator(oPC, skillsEffectCreator);

    int penaSkills;
    if ( GetIsObjectValid( objetoManoIzquierda ) )
    {
        if (!GetHasFeat(FEAT_SHIELD_PROFICIENCY, oPC)) {
            object oShield = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
            switch (GetBaseItemType(oShield)) {
                case BASE_ITEM_SMALLSHIELD:     penaSkills += SKILL_CHECK_PENALTY_SMALL_SHIELD; break;
                case BASE_ITEM_LARGESHIELD:     penaSkills += SKILL_CHECK_PENALTY_LARGE_SHIELD; break;
                case BASE_ITEM_TOWERSHIELD:     penaSkills += SKILL_CHECK_PENALTY_TOWER_SHIELD; break;
            }
        }
    }

    object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
    if (!GetIsCreatureProficientWithArmor(oPC, oArmor))
        penaSkills += Item_GetArmorCheckPenalty(oArmor);

    if (penaSkills > 0) {
        AssignCommand(skillsEffectCreator, ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectSkillDecrease(SKILL_SWIM, penaSkills), oPC));
        AssignCommand(skillsEffectCreator, ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectSkillDecrease(SKILL_JUMP, penaSkills), oPC));
        AssignCommand(skillsEffectCreator, ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectSkillDecrease(SKILL_RIDE, penaSkills), oPC));
    }
}

// Revisa qué sostiene el personaje en ambas manos y aplica penalizadores al ataque en base a las proficiencias
void Competencias_aplicarPenalizadoresAtaque( object oPC, object objetoManoDerecha = OBJECT_INVALID, object objetoManoIzquierda = OBJECT_INVALID );
void Competencias_aplicarPenalizadoresAtaque( object oPC, object objetoManoDerecha = OBJECT_INVALID, object objetoManoIzquierda = OBJECT_INVALID )
{
    int tieneObjetoEnManoDerecha = GetIsObjectValid(objetoManoDerecha);
    int tieneObjetoEnManoIzquierda = GetIsObjectValid(objetoManoIzquierda);
    int penaAtaqueManoDerecha;
    if (tieneObjetoEnManoDerecha)
    {
        penaAtaqueManoDerecha = (!GetIsCreatureProficientWithWeapon(oPC, objetoManoDerecha)) ? 4 : 0;
    }

    int penaAtaqueManoIzquierda;
    if (tieneObjetoEnManoIzquierda)
    {
        switch (GetBaseItemType(objetoManoIzquierda)) {
            case BASE_ITEM_SMALLSHIELD:     penaAtaqueManoDerecha += (!GetHasFeat(FEAT_SHIELD_PROFICIENCY, oPC)) ? SKILL_CHECK_PENALTY_SMALL_SHIELD : 0;
                                            break;
            case BASE_ITEM_LARGESHIELD:     penaAtaqueManoDerecha += (!GetHasFeat(FEAT_SHIELD_PROFICIENCY, oPC)) ? SKILL_CHECK_PENALTY_LARGE_SHIELD : 0;
                                            break;
            case BASE_ITEM_TOWERSHIELD:     {
                                                penaAtaqueManoDerecha += (!GetHasFeat(FEAT_SHIELD_PROFICIENCY, oPC)) ? SKILL_CHECK_PENALTY_TOWER_SHIELD : 0;
                                                int tipoBaseManoDerecha = GetBaseItemType(objetoManoDerecha);
                                                // Para cualquier arma menos las ballestas, se gana un -2 al ataque al usar un Tower Shield, se tenga o no la proficiencia
                                                penaAtaqueManoDerecha += (tipoBaseManoDerecha!=BASE_ITEM_LIGHTCROSSBOW && tipoBaseManoDerecha!=BASE_ITEM_HEAVYCROSSBOW) ? 1 : 0;
                                            }
                                            break;
            default:                        penaAtaqueManoIzquierda += (!GetIsCreatureProficientWithWeapon(oPC, objetoManoIzquierda)) ? 4 : 0;
                                            break;
        }
    }

    object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
    if (!GetIsCreatureProficientWithArmor(oPC, oArmor))
    {
        int checkPenalty = Item_GetArmorCheckPenalty(oArmor);
        penaAtaqueManoDerecha   += checkPenalty;
        penaAtaqueManoIzquierda += checkPenalty;
    }

    /* Nota:
        Una muy buena opcion es buscar la manera de incorporar este sistema
        al PRC utilizando la funcion SetCompositeBonus. Esa funcion mantiene
        un solo bonus que suma todos los bonus de un mismo tipo, usando
        propiedades en la piel del personaje. El tema es que creo que no funciona con
        penalizadores.
    */

    object creadorManoDerecha = Competencias_GetEffectCreator(Competencias_tipoItemArmaDerecha_RN);
    RDO_RemoveEffectsByCreator( oPC, creadorManoDerecha );
    if (penaAtaqueManoDerecha > 0) {
        int mano = (tieneObjetoEnManoIzquierda) ? ATTACK_BONUS_ONHAND : ATTACK_BONUS_MISC;
        AssignCommand(creadorManoDerecha, ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectAttackDecrease(penaAtaqueManoDerecha, mano)), oPC));
    }

    object creadorManoIzquierda = Competencias_GetEffectCreator(Competencias_tipoItemArmaIzquierda_RN);
    RDO_RemoveEffectsByCreator( oPC, creadorManoIzquierda );
    if (penaAtaqueManoIzquierda > 0 && tieneObjetoEnManoIzquierda)
        AssignCommand(creadorManoIzquierda, ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectAttackDecrease(penaAtaqueManoIzquierda, ATTACK_BONUS_OFFHAND)), oPC));
}

// Aplica las penas correctas por usar un arma o escudo
// sin su correspondiente competencia
void Competencias_onEquip( object oPC, object oItem );
void Competencias_onEquip( object oPC, object oItem )
{
    Competencias_aplicarPenalizadoresSkills( oPC, GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC), GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC) );
    Competencias_aplicarPenalizadoresAtaque( oPC, GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC), GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC) );
}

// Aplica las penas correctas por usar un arma o escudo
// sin su correspondiente competencia
void Competencias_onUnequip( object oPC, object oItem );
void Competencias_onUnequip( object oPC, object oItem )
{
    Competencias_aplicarPenalizadoresSkills( oPC );
    Competencias_aplicarPenalizadoresAtaque( oPC );
}

// Handler para el evento onEnter de las competencias
// Debe ser llamado luego de que se cree la piel en el personaje
void Competencias_onEnter( object oPC );
void Competencias_onEnter( object oPC )
{
    object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPC);
    if (GetHasFeat(FEAT_ARMOR_PROFICIENCY_HEAVY, oPC))
        SetLocalInt(oPC, Competencias_hasArmorProfHeavy_VN, TRUE);
    else
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_ARMOR_PROF_HEAVY), oSkin);

    if (GetHasFeat(FEAT_ARMOR_PROFICIENCY_MEDIUM, oPC))
        SetLocalInt(oPC, Competencias_hasArmorProfMedium_VN, TRUE);
    else
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_ARMOR_PROF_MEDIUM), oSkin);

    if (GetHasFeat(FEAT_ARMOR_PROFICIENCY_LIGHT, oPC))
        SetLocalInt(oPC, Competencias_hasArmorProfLight_VN, TRUE);
    else
        AddItemProperty(DURATION_TYPE_PERMANENT, ItemPropertyBonusFeat(IP_CONST_FEAT_ARMOR_PROF_LIGHT), oSkin);
}
